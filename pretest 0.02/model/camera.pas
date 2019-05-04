(*
一个用于控制OpenGL视角变换的单元
By FPC5719
2018.11.20
*)
unit camera;

interface

uses
	gl;
	
procedure cmrMove(t:extended);			//向面朝的方向移动
procedure cmrMoveY(t:extended);			//在Y轴上移动
procedure cmrTurn(drd,dud:extended);	//旋转（drd：水平；dud：竖直；使用角度单位）
procedure cmrMoveTo(nx,ny,nz:extended);	//移动到
procedure cmrTurnTo(nrd,nud:extended);	//转到（nrd：水平；nud：竖直；使用角度单位）
procedure cmrModify;					//改变视角（Move/Turn但不Modify无效）

implementation

var
	x,y,z:extended;
	rd,ud:extended;

procedure cmrMove(t:extended);
begin
	x:=x+sin(rd*PI/180)*t;
	z:=z+cos(rd*PI/180)*t;
end;
procedure cmrMoveY(t:extended);
begin
	y:=y-t;
end;
procedure cmrTurn(drd,dud:extended);
begin
	rd:=rd+drd;
	if(rd>359)then
		rd:=0;
	if(rd<-359)then
		rd:=0;
	ud:=ud+dud;
	if(ud>89)then
		ud:=89;
	if(ud<-89)then
		ud:=-89;
end;
procedure cmrMoveTo(nx,ny,nz:extended);
begin
	x:=nx;
	y:=ny;
	z:=nz;
end;
procedure cmrTurnTo(nrd,nud:extended);
begin
	rd:=nrd;
	ud:=nud;
end;
procedure cmrModify;
begin
	glRotatef(ud,1,0,0);
	glRotatef(360-rd,0,1,0);
	glTranslatef(x,y,z);
end;

end.