{$MODE OBJFPC}
unit block;

interface

uses
	gl,gla,perlin,gVector;
	
procedure InitBML;

type
	TBlock=class
	private
		id,idx,idy,idz:longint;
		fa:TObject;
	public
		constructor Create(f:TObject;x,y,z:longint);
		destructor Destroy;override;
		procedure SetID(t:longint);
		procedure Redraw;
	end;

type
	TBlockList=specialize TVector<TBlock>;

type
	TChunk=class
	private
		blk:array[0..15,0..63,0..15] of TBlock;
		rl:TBlockList;
		idx,idy:longint;
		fa:TObject;
	public
		constructor Create(f:TObject;x,y:longint);
		destructor Destroy;override;
		function GetBlockType(x,y,z:longint):longint;
		procedure UpdateRedrawList;
		procedure Redraw;
	end;

implementation

uses
	world;

var
	BML:array[0..$1000] of GLUint;
	BDL:array[0..$1000] of record
		trsp,show:boolean;
	end;
	
procedure InitBML;
var
	md:TGLAModel;
	f:TGLAByteFile;
begin
	md:=TGLAModel.Create;
	assign(f,'.\blocks\null.model'); reset(f);
	md.LoadFromFile(f); close(f);
	BML[0]:=md.BuildDisplayList(glaLoadTexture('.\blocks\null.png'));
	BDL[0].trsp:=true; BDL[0].show:=false;
	assign(f,'.\blocks\default.model'); reset(f);
	md.LoadFromFile(f); close(f);
	BML[1]:=md.BuildDisplayList(glaLoadTexture('.\blocks\stone.png'));
	BDL[1].trsp:=false; BDL[1].show:=true;
end;

constructor TBlock.Create(f:TObject;x,y,z:longint);
begin fa:=f; idx:=x; idy:=y; idz:=z; end;
destructor TBlock.Destroy;
begin end;
procedure TBlock.SetID(t:longint);
begin id:=t; end;
procedure TBlock.Redraw;
begin
	glPushMatrix;
	glTranslatef(idx,idy,idz);
	glCallList(BML[id]);
	glPopMatrix;
end;

constructor TChunk.Create(f:TObject;x,y:longint);
var i,j,k,t:longint;
begin
	// writeln('Creating Chunk:',x,',',y);
	fa:=f; idx:=x; idy:=y;
	for i:=0 to 15 do for k:=0 to 15 do begin
		t:=round(GetHeight(i/5+idx,k/5+idy)*32);
		for j:=0 to 63 do begin
			blk[i,j,k]:=TBlock.Create(self,i,j,k);
			if j<=t then blk[i,j,k].id:=1
			else blk[i,j,k].id:=0;
		end;
	end;
	rl:=TBlockList.Create;
	UpdateRedrawList;
end;
destructor TChunk.Destroy;
var i,j,k:longint;
begin
	for i:=0 to 15 do for j:=0 to 63 do for k:=0 to 15 do blk[i,j,k].Destroy;
end;
function TChunk.GetBlockType(x,y,z:longint):longint;
begin exit(blk[x,y,z].id); end;
procedure TChunk.UpdateRedrawList;
var i,j,k,t,nx,ny,nz:longint;
const
	dx:array[1..6] of longint=(1,0,-1,0,0,0);
	dy:array[1..6] of longint=(0,1,0,-1,0,0);
	dz:array[1..6] of longint=(0,0,0,0,1,-1);
begin
	rl.Clear;
	for i:=0 to 15 do for j:=0 to 63 do for k:=0 to 15 do begin
		if not BDL[blk[i,j,k].id].show then continue;
		for t:=1 to 6 do begin
			nx:=i+dx[t]+idx*16; ny:=j+dy[t]; nz:=k+dz[t]+idy*16;
			if BDL[(fa as TWorld).GetBlockType(nx,ny,nz)].trsp then begin
				rl.PushBack(blk[i,j,k]); break;
			end;
		end;
	end;
end;
procedure TChunk.Redraw;
var
	i:TBlockList.TVectorEnumerator;
	b:TBlock;
begin
	glPushMatrix;
	glTranslatef(idx*16,0,idy*16);
	i:=rl.GetEnumerator;
	// writeln('Redrawing Chunk:',idx,',',idy,':',rl.Size);
	repeat
		b:=i.Current; b.Redraw;
	until not i.MoveNext;
	glPopMatrix;
end;

begin
	SetSeed(12345);
end.