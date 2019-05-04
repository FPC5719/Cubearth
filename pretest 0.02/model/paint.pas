uses
	gl,glu,glut,
	texture,model,utility,camera;
var
	m:TModel;
	l:GLUint;
procedure Display;cdecl;
begin
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity;
	gluPerspective(60,1,0.01,30);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity;
	cmrModify;
	glCallList(l);
	glutSwapBuffers;
end;
procedure keyboard(key:byte;mx,my:longint);cdecl;
begin
	case(chr(key))of
		'w':cmrMove(0.1);
		's':cmrMove(-0.1);
		'i':cmrTurn(0,-1);
		'k':cmrTurn(0,1);
		'j':cmrTurn(1,0);
		'l':cmrTurn(-1,0);
		'z':cmrMoveY(0.1);
		'c':cmrMoveY(-0.1);
		#27:halt;
	end;
	glutPostRedisplay;
end;
procedure Init;
var
	f:TFile;
begin
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_DEPTH_TEST);
	m:=TModel.Create;
	assign(f,'1.model');
	reset(f);
	m.LoadFromFile(f);
	close(f);
	l:=m.BuildDisplayList(txrLoad('1.bmp'));
end;
begin
	glutInit(@argc,argv);
	glutInitDisplayMode(GLUT_RGB or GLUT_DOUBLE);
	glutInitWindowSize(200,200);
	glutInitWindowPosition(200,200);
	glutCreateWindow('');
	Init;
	glutDisplayFunc(@display);
	glutKeyboardFunc(@keyboard);
	glutMainLoop;
end.