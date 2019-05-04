{$MODE OBJFPC}
unit world;

interface

uses
	block,gUtil,gMap;

type
	TWorld=class
	private type
		TLS=specialize TLess<int64>;
		TCM=specialize TMap<int64,TChunk,TLS>;
		TI=TCM.TIterator;
	private
		cm:TCM;
	public
		constructor Create;
		destructor Destroy;override;
		procedure InsertChunk(x,y:longint);
		procedure DeleteChunk(x,y:longint);
		function FindChunk(x,y:longint):TChunk;
		function GetBlockType(cx,cy,x,y,z:longint):longint;
		function GetBlockType(x,y,z:longint):longint;
		procedure Redraw;
	end;

implementation

constructor TWorld.Create;
begin cm:=TCM.Create; end;
destructor TWorld.Destroy;
begin cm.Destroy; end;
procedure TWorld.InsertChunk(x,y:longint);
var tc:TChunk;
begin
	tc:=TChunk.Create(self,x,y);
	cm.Insert(int64(x)<<32+y,tc);
end;
procedure TWorld.DeleteChunk(x,y:longint);
begin
	cm.Delete(int64(x)<<32+y);
end;
function TWorld.FindChunk(x,y:longint):TChunk;
var res:TChunk;
begin
	if cm.TryGetValue(int64(x)<<32+y,res) then exit(res)
	else exit(NIL);
end;
function TWorld.GetBlockType(cx,cy,x,y,z:longint):longint;
var c:TChunk;
begin
	c:=FindChunk(cx,cy);
	if c=NIL then exit(0)
	else exit(c.GetBlockType(x,y,z));
end;
function TWorld.GetBlockType(x,y,z:longint):longint;
begin
	if (x<0)or(y<0)or(z<0) then exit(0);
	exit(GetBlockType(x div 16,z div 16,x mod 16,y,z mod 16));
end;
procedure TWorld.Redraw;
var
	i:TI;
	c:TChunk;
begin
	i:=cm.Min;
	repeat
		c:=i.Value; c.Redraw;
	until not i.next;
end;

end.