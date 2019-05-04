uses
	model,utility;
var
	t:TModel;
	s:array[1..6]of TSurface;
	v:TVertex;
	f:TFile;
begin
	t:=TModel.Create;
	s[1]:=TSurface.Create;
	v.x:=0.5; v.y:=0.5; v.z:=0.5; v.tx:=0; v.ty:=0; s[1].AddVertex(v);
	v.x:=0.5; v.y:=-0.5; v.z:=0.5; v.tx:=0; v.ty:=1; s[1].AddVertex(v);
	v.x:=-0.5; v.y:=-0.5; v.z:=0.5; v.tx:=1; v.ty:=1; s[1].AddVertex(v);
	v.x:=-0.5; v.y:=0.5; v.z:=0.5; v.tx:=1; v.ty:=0; s[1].AddVertex(v);
	s[2]:=TSurface.Create;
	v.x:=0.5; v.y:=0.5; v.z:=-0.5; v.tx:=0; v.ty:=0; s[2].AddVertex(v);
	v.x:=0.5; v.y:=-0.5; v.z:=-0.5; v.tx:=0; v.ty:=1; s[2].AddVertex(v);
	v.x:=-0.5; v.y:=-0.5; v.z:=-0.5; v.tx:=1; v.ty:=1; s[2].AddVertex(v);
	v.x:=-0.5; v.y:=0.5; v.z:=-0.5; v.tx:=1; v.ty:=0; s[2].AddVertex(v);
	s[3]:=TSurface.Create;
	v.x:=0.5; v.y:=0.5; v.z:=0.5; v.tx:=0; v.ty:=0; s[3].AddVertex(v);
	v.x:=0.5; v.y:=0.5; v.z:=-0.5; v.tx:=0; v.ty:=1; s[3].AddVertex(v);
	v.x:=-0.5; v.y:=0.5; v.z:=-0.5; v.tx:=1; v.ty:=1; s[3].AddVertex(v);
	v.x:=-0.5; v.y:=0.5; v.z:=0.5; v.tx:=1; v.ty:=0; s[3].AddVertex(v);
	s[4]:=TSurface.Create;
	v.x:=0.5; v.y:=-0.5; v.z:=0.5; v.tx:=0; v.ty:=0; s[4].AddVertex(v);
	v.x:=0.5; v.y:=-0.5; v.z:=-0.5; v.tx:=0; v.ty:=1; s[4].AddVertex(v);
	v.x:=-0.5; v.y:=-0.5; v.z:=-0.5; v.tx:=1; v.ty:=1; s[4].AddVertex(v);
	v.x:=-0.5; v.y:=-0.5; v.z:=0.5; v.tx:=1; v.ty:=0; s[4].AddVertex(v);
	s[5]:=TSurface.Create;
	v.x:=0.5; v.y:=0.5; v.z:=0.5; v.tx:=0; v.ty:=0; s[5].AddVertex(v);
	v.x:=0.5; v.y:=0.5; v.z:=-0.5; v.tx:=0; v.ty:=1; s[5].AddVertex(v);
	v.x:=0.5; v.y:=-0.5; v.z:=-0.5; v.tx:=1; v.ty:=1; s[5].AddVertex(v);
	v.x:=0.5; v.y:=-0.5; v.z:=0.5; v.tx:=1; v.ty:=0; s[5].AddVertex(v);
	s[6]:=TSurface.Create;
	v.x:=-0.5; v.y:=0.5; v.z:=0.5; v.tx:=0; v.ty:=0; s[6].AddVertex(v);
	v.x:=-0.5; v.y:=0.5; v.z:=-0.5; v.tx:=0; v.ty:=1; s[6].AddVertex(v);
	v.x:=-0.5; v.y:=-0.5; v.z:=-0.5; v.tx:=1; v.ty:=1; s[6].AddVertex(v);
	v.x:=-0.5; v.y:=-0.5; v.z:=0.5; v.tx:=1; v.ty:=0; s[6].AddVertex(v);
	t.AddSurface(s[1]); t.AddSurface(s[2]); t.AddSurface(s[3]);
	t.AddSurface(s[4]); t.AddSurface(s[5]); t.AddSurface(s[6]);
	assign(f,'1.model'); rewrite(f);
	t.SaveToFile(f);
	close(f);
end.