{
Cubearth pretest 0.01
主程序
By FPC5719
}
{$MODE OBJFPC}
{$DEFINE USECONSOLE}
{$IFDEF USECONSOLE}
	{$APPTYPE CONSOLE}
{$ELSE}
	{$APPTYPE GUI}
{$ENDIF}
uses
	sysutils,windows,
	gl,glu,gla,
	block,world;
var
	UseMouse:boolean;
	lx,ly:longint;
	w:TWorld;
procedure Destroy(wp,lp:DWord);
begin PostQuitMessage(0); end;
var
	fps:longint;
	time:extended;
procedure Display(wp,lp:DWord);
begin
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
	glaModifyCamera;
	glScalef(0.05,0.05,0.05);
	w.Redraw;
	glaFlush;
	fps:=fps+1;
	if (now-time)*86400>1 then begin
		writeln(fps); fps:=0; time:=now;
	end;
end;
procedure Keyboard(wp,lp:DWord);
var
	ch:char;
begin
	ch:=Lowercase(chr(Lo(wp)));
	case ch of
		'w':glaMoveCamera(0.01);
		's':glaMoveCamera(-0.01);
		'c':glaMoveCameraY(0.01);
		'z':glaMoveCameraY(-0.01);
		'i':glaTurnCamera(0,-1);
		'k':glaTurnCamera(0,1);
		'j':glaTurnCamera(1,0);
		'l':glaTurnCamera(-1,0);
		#27:begin
			ShowCursor(UseMouse);
			UseMouse:=not UseMouse;
		end;
	end;
end;
var
	wx,wy:longint;
procedure Resize(wp,lp:DWord);
begin wx:=Hi(lp); wy:=Lo(lp); end;
procedure Mouse(wp,lp:DWord);
var
	x,y:longint;
	p:POINT;
begin
	if not UseMouse then exit;
	x:=Hi(lp); y:=Lo(lp);
	GetCursorPos(@p);
	if x<200 then begin lx:=x+50; ly:=y; SetCursorPos(p.x,p.y+50); exit end;
	if y<200 then begin ly:=y+50; lx:=x; SetCursorPos(p.x+50,p.y); exit end;
	if x>wx-200 then begin lx:=x-50; ly:=y; SetCursorPos(p.x,p.y-50); exit end;
	if y>wy-200 then begin ly:=y-50; lx:=x; SetCursorPos(p.x-50,p.y); exit end;
	if (lx<>-1)and(ly<>-1) then begin
		if x>lx then glaTurnCamera(0,5);
		if x<lx then glaTurnCamera(0,-5);
		if y>ly then glaTurnCamera(-5,0);
		if y<ly then glaTurnCamera(5,0);
	end;
	lx:=x; ly:=y;
end;
procedure InitGL;inline;
begin
	glaInit;
	glaCreateWindow(100,100,640,480,'test');
	
	glaBindFunc(WM_DESTROY,@Destroy);
	glaBindFunc(WM_PAINT,@Display);
	glaBindFunc(WM_CHAR,@Keyboard);
	glaBindFunc(WM_MOUSEMOVE,@Mouse);
	glaBindFunc(WM_SIZE,@Resize);
	
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_DEPTH_TEST);
	
	wx:=480; wy:=640;
	UseMouse:=false;
	lx:=-1; ly:=-1;
	time:=now;
	glaMoveCameraTo(-1.5,-1,-1.5);
end;
begin
	InitGL;
	InitBML;
	w:=TWorld.Create;
	w.InsertChunk(1,1);
	w.InsertChunk(1,2);
	w.InsertChunk(2,1);
	w.InsertChunk(2,2);
	glaLoop;
end.