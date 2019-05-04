{
一个模型导入单元
By FPC5719
2018.12
}
{$MODE DELPHI}
unit model;

interface

uses
	gl,			//OpenGL单元
	utility,	//一些基本的定义
	gmap,gutil;	//FCL-STL中的好东西

type
	TSurface=class
	private type
		TLL=TLess<longint>;
		TMV=TMap<longint,TVertex,TLL>;
	private
		vtx:TMV;
	public
		constructor Create;
		destructor Destroy;override;
		procedure SaveToFile(var f:TFile);		//保存到文件，注意文件必须打开为写方式
		procedure LoadFromFile(var f:TFile);	//从文件读取，注意文件必须打开为读方式
		procedure AddVertex(v:TVertex);			//添加一个顶点
		procedure Debug;
		property Vertexes:TMV read vtx;
	end;

type
	TModel=class
	private type
		TLL=TLess<longint>;
		TMS=TMap<longint,TSurface,TLL>;
	private
		sur:TMS;
	public
		constructor Create;
		destructor Destroy;override;
		procedure SaveToFile(var f:TFile);		//保存到文件，注意文件必须打开为写方式
		procedure LoadFromFile(var f:TFile);	//从文件读取，注意文件必须打开为读方式
		procedure AddSurface(s:TSurface);		//添加一个表面
		procedure Debug;
		property Surfaces:TMS read sur;
		function BuildDisplayList(txr:GLUint):GLUint;	//建立此模型的显示列表
	end;

implementation

constructor TSurface.Create;
begin
	vtx:=TMV.Create;
end;
destructor TSurface.Destroy;
begin
	vtx.Destroy;
end;
procedure TSurface.SaveToFile(var f:TFile);
var
	i,len:longint;
	v:TVertex;
begin
	len:=vtx.Size;
	SaveLongint(len,f);
	for i:=1 to len do begin
		v:=vtx.Items[i];
		SaveVertex(v,f);
	end;
end;
procedure TSurface.LoadFromFile(var f:TFile);
var
	i,len:longint;
	v:TVertex;
begin
	vtx.Destroy;
	vtx:=TMV.Create;
	LoadLongint(len,f);
	for i:=1 to len do begin
		LoadVertex(v,f);
		vtx.Items[i]:=v;
	end;
end;
procedure TSurface.AddVertex(v:TVertex);
begin
	vtx.Items[vtx.Size+1]:=v;
end;
procedure TSurface.Debug;
var
	i:longint;
	v:TVertex;
begin
	for i:=1 to vtx.Size do begin
		with vtx.Items[i] do begin
			writeln('Vertex',i,':',x:0:2,',',y:0:2,',',z:0:2,':',tx:0:2,',',ty:0:2);
		end;
	end;
end;

constructor TModel.Create;
begin
	sur:=TMS.Create;
end;
destructor TModel.Destroy;
begin
	sur.Destroy;
end;
procedure TModel.SaveToFile(var f:TFile);
var
	i,len:longint;
begin
	len:=sur.Size;
	SaveLongint(len,f);
	for i:=1 to len do
		sur.Items[i].SaveToFile(f);
end;
procedure TModel.LoadFromFile(var f:TFile);
var
	i,len:longint;
begin
	LoadLongint(len,f);
	for i:=1 to len do begin
		sur.Items[i]:=TSurface.Create;
		sur.Items[i].LoadFromFile(f);
	end;
end;
procedure TModel.AddSurface(s:TSurface);
begin
	sur.Items[sur.Size+1]:=s;
end;
procedure TModel.Debug;
var
	i:longint;
begin
	for i:=1 to sur.Size do begin
		writeln('Surface',i,':');
		sur.Items[i].Debug;
	end;
end;

function TModel.BuildDisplayList(txr:GLUint):GLUint;
var
	res:GLUint;
	i,j:longint;
begin
	res:=glGenLists(1);
	glBindTexture(GL_TEXTURE_2D,txr);
	glNewList(res,GL_COMPILE);
		for i:=1 to sur.Size do begin
			glBegin(GL_POLYGON);
				for j:=1 to sur.Items[i].vtx.Size do begin
					with sur.Items[i].vtx.Items[j] do begin
						glTexCoord2f(tx,ty);
						glVertex3f(x,y,z);
					end;
				end;
			glEnd;
		end;
	glEndList;
	exit(res);
end;

end.