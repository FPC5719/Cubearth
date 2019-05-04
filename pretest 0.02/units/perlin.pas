unit perlin;

interface

procedure SetSeed(t:DWord);
function GetSeed:DWord;
function GetHeight(x,y:extended):extended;

implementation

var Seed:DWord;

procedure SetSeed(t:DWord);
begin Seed:=t; end;
function GetSeed:DWord;
begin exit(Seed); end;

function rand(x:longint):extended;
begin
	x:=(x<<13)xor x;
	exit(((Seed*(x*x*15731+789221)+1376312589)and $7fffffff)/2147483647); 
end;
function Noise(x,y:extended):extended;
begin
	exit(rand(trunc(abs(x*437+y))));
end;
function Smooth(x,y:extended):extended;
var corners,sides,center:extended;
begin
	corners:=(Noise(x-1,y-1)+Noise(x+1,y-1)+Noise(x-1,y+1)+Noise(x+1,y+1))/32;
	sides:=(Noise(x-1,y)+Noise(x+1,y)+Noise(x,y-1)+Noise(x,y+1))/16;
	center:=Noise(x,y)/8;
	exit(corners+sides+center);
end;
function Inter(a,b,x:extended):extended;
begin
	exit((a*(1-x)*(1-x)+b*x*x)/((1-x)*(1-x)+x*x));
end;
function Inter(x,y:extended):extended;
var
	ix,iy:longint;
	fx,fy,v1,v2,v3,v4,i1,i2:extended;
begin
	ix:=round(x); fx:=x-ix;
	iy:=round(y); fy:=y-iy;
	v1:=Smooth(ix,iy); v2:=Smooth(ix+1,iy);
	v3:=Smooth(ix,iy+1); v4:=Smooth(ix+1,iy+1);
	i1:=Inter(v1,v2,fx); i2:=Inter(v3,v4,fx);
	exit(Inter(i1,i2,fy));
end;
function GetHeight(x,y:extended):extended;
var
	ret,f,a,t:extended;
	i:longint;
begin
	ret:=0; f:=1; a:=1;
	for i:=0 to 3 do begin
		t:=Inter(x*f,y*f)*a;
		ret:=ret+t; f:=f*2; a:=a/2;
	end;
	exit(ret);
end;

end.