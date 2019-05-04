unit utility;

interface

type
	TFile=file of byte;

function ReadFromFile(var f:TFile;const len:longint):pointer;
procedure WriteToFile(var f:TFile;const len:longint;const ptr:pointer);

procedure SaveLongint(l:longint;var f:TFile);
procedure LoadLongint(var l:longint;var f:TFile);

type
	TVertex=record
		x,y,z:extended;
		tx,ty:extended;
	end;
operator >(a,b:TVertex)res:boolean;
operator <(a,b:TVertex)res:boolean;

procedure SaveVertex(v:TVertex;var f:TFile);
procedure LoadVertex(var v:TVertex;var f:TFile);

type
	TPosition=record
		x,y,z:extended;
	end;
	
function CreatePos(x,y,z:extended):TPosition;

implementation

function ReadFromFile(var f:TFile;const len:longint):pointer;
var
	buf:^byte;
	i:longint;
begin
	buf:=GetMem(len);
	for i:=1 to len do
		read(f,buf[i-1]);
	exit(buf);
end;
procedure WriteToFile(var f:TFile;const len:longint;const ptr:pointer);
var
	buf:^byte;
	i:longint;
begin
	buf:=ptr;
	for i:=1 to len do
		write(f,buf[i-1]);
end;

procedure SaveLongint(l:longint;var f:TFile);
var
	pl:^longint;
begin
	pl:=@l;
	WriteToFile(f,sizeof(longint),pl);
end;
procedure LoadLongint(var l:longint;var f:TFile);
var
	pl:^longint;
begin
	pl:=ReadFromFile(f,sizeof(longint));
	l:=pl^;
end;
procedure SaveVertex(v:TVertex;var f:TFile);
var
	pe:^extended;
begin
	pe:=@v.x;
	WriteToFile(f,sizeof(extended),pe);
	pe:=@v.y;
	WriteToFile(f,sizeof(extended),pe);
	pe:=@v.z;
	WriteToFile(f,sizeof(extended),pe);
	pe:=@v.tx;
	WriteToFile(f,sizeof(extended),pe);
	pe:=@v.ty;
	WriteToFile(f,sizeof(extended),pe);
end;
procedure LoadVertex(var v:TVertex;var f:TFile);
var
	pe:^extended;
begin
	pe:=ReadFromFile(f,sizeof(extended));
	v.x:=pe^;
	pe:=ReadFromFile(f,sizeof(extended));
	v.y:=pe^;
	pe:=ReadFromFile(f,sizeof(extended));
	v.z:=pe^;
	pe:=ReadFromFile(f,sizeof(extended));
	v.tx:=pe^;
	pe:=ReadFromFile(f,sizeof(extended));
	v.ty:=pe^;
end;

operator >(a,b:TVertex)res:boolean;
begin
	exit((a.x<b.x)and(a.y<b.y)and(a.z<b.z));
end;
operator <(a,b:TVertex)res:boolean;
begin
	exit((a.x>b.x)and(a.y>b.y)and(a.z>b.z));
end;

function CreatePos(x,y,z:extended):TPosition;
var
	res:TPosition;
begin
	res.x:=x; res.y:=y; res.z:=z;
	exit(res);
end;

end.