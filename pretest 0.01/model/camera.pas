(*
һ�����ڿ���OpenGL�ӽǱ任�ĵ�Ԫ
By FPC5719
2018.11.20
*)
unit camera;

interface

uses
	gl;
	
procedure cmrMove(t:extended);			//���泯�ķ����ƶ�
procedure cmrMoveY(t:extended);			//��Y�����ƶ�
procedure cmrTurn(drd,dud:extended);	//��ת��drd��ˮƽ��dud����ֱ��ʹ�ýǶȵ�λ��
procedure cmrMoveTo(nx,ny,nz:extended);	//�ƶ���
procedure cmrTurnTo(nrd,nud:extended);	//ת����nrd��ˮƽ��nud����ֱ��ʹ�ýǶȵ�λ��
procedure cmrModify;					//�ı��ӽǣ�Move/Turn����Modify��Ч��

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