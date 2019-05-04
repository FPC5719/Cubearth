(*
一个从文件读取纹理的单元
资瓷的格式：BMP、JPG、PNG、GIF，可以有透明
使用前请先glEnable(GL_TEXTURE_2D);
By FPC5719
2018.11.20
*)
unit texture;

interface

uses
	gl,glext,
	fpImage,fpReadBMP,fpReadJPEG,fpReadPNG,fpReadGIF;
	
function txrLoad(fnm:string):GLUint;	//读取纹理，返回编号（非常simple对不对）

implementation

function txrLoad(fnm:string):GLUInt;
var
	Reader:TFPCustomImageReader;
	img:TFPMemoryImage;
	s:string;
	t,i,j,p:longint;
	texture:GLUInt;
	PTexture:^Byte;
begin
	FreeMem(PTexture);
	s:=fnm;
	p:=pos('.',fnm);
	while p<>0 do begin
		delete(fnm,1,p);
		p:=pos('.',fnm);
	end;
	fnm:=LowerCase(fnm);
	if fnm='bmp' then
		Reader:=TFPReaderBMP.Create
	else if fnm='png' then
		Reader:=TFPReaderPNG.Create
	else if (fnm='jpg')or(fnm='jpeg') then
		Reader:=TFPReaderJPEG.Create
	else if fnm='gif' then
		Reader:=TFPReaderGIF.Create;
	img:=TFPMemoryImage.Create(0,0);
	img.LoadFromFile(s,Reader);
	PTexture:=GetMem(img.Height*img.Width*4);
	t:=-1;
	for i:=img.height-1 downto 0 do
		for j:=0 to img.Width-1 do begin
			t:=t+1;
			PTexture[t]:=img.Colors[j,i].red;
			t:=t+1;
			PTexture[t]:=img.Colors[j,i].green;
			t:=t+1;
			PTexture[t]:=img.Colors[j,i].blue;
			t:=t+1;
			PTexture[t]:=img.Colors[j,i].alpha;
		end;
	img.Free;
	Reader.Free;
	glGenTextures(1,@texture);
	glBindTexture(GL_TEXTURE_2D,texture);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
	glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_REPLACE);
	glTexImage2d(GL_TEXTURE_2D,0,GL_RGBA,img.Height,img.Width,0,GL_RGBA,
	             GL_UNSIGNED_BYTE,PTexture);
	exit(texture);
end;

end.