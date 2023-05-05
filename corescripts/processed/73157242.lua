print'[Mercury]: Loaded corescript 73157242'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b,c={},nil c=function(d)local e,f,g=false,game.
Workspace.CurrentCamera,nil do local h=f.CoordinateFrame.p g=Vector3.new(h.X,h.Y
,h.Z)end local h,i,j=Vector3.new(d.X,d.Y,d.Z),Vector3.new(0,1,0),Vector3.new(0,0
,0)local k,l=i:Dot(h-g),d if k~=0 then b=i:Dot(j-g)/k if b>=0 and b<=1 then
local m=((h-g)*b)+g l=game.Workspace.Terrain:WorldToCell(m)e=true end end return
l,e end local d d=function(e)local f,g=game.Workspace.Terrain:
WorldToCellPreferSolid(Vector3.new(e.hit.x,e.hit.y,e.hit.z)),nil if 0==game.
Workspace.Terrain:GetCell(f.X,f.Y,f.Z).Value then f=nil local h g,h=c(Vector3.
new(e.hit.x,e.hit.y,e.hit.z))if h then f=g end end return f end local e,f=
Vector3.new(0.3,0.3,0.3),nil f=function(g,h,i)if g:IsA'BasePart'then g.CFrame=(h
*(g.CFrame-i))+i end local j=g:GetChildren()for k=1,#j do f(j[k],h,i)end end
local g g=function(h,i)local j,k=CFrame.Angles(0,i,0),h:GetModelCFrame().p
return f(h,j,k)end local h h=function(i,j,k,l)if i:IsA'BasePart'then j[#j+1]=i
elseif i:IsA'Script'then k[#k+1]=i elseif i:IsA'Decal'then l[#l+1]=i end for m,n
in pairs(i:GetChildren())do h(n,j,k,l)end end local i i=function(j,k)local l=
game.Workspace:FindFirstChild'Terrain'local m,n=l:WorldToCell(j),l:WorldToCell(k
)local o,p,q,r,s,t=m.X,m.Y,m.Z,n.X,n.Y,n.Z if o<l.MaxExtents.Min.X then o=l.
MaxExtents.Min.X end if p<l.MaxExtents.Min.Y then p=l.MaxExtents.Min.Y end if q<
l.MaxExtents.Min.Z then q=l.MaxExtents.Min.Z end if r>l.MaxExtents.Max.X then r=
l.MaxExtents.Max.X end if s>l.MaxExtents.Max.Y then s=l.MaxExtents.Max.Y end if
t>l.MaxExtents.Max.Z then t=l.MaxExtents.Max.Z end for u=o,r do for v=p,s do for
w=q,t do if l:GetCell(u,v,w).Value>0 then return true end end end end return
false end local j j=function(k,l)if not k then return end if k.className=='Seat'
or k.className=='VehicleSeat'then table.insert(l,k)end local m=k:GetChildren()
for n=1,#m do j(m[n],l)end end local k k=function(l,m)local n={}j(l,n)if m then
for o=1,#n do local p=n[o]:FindFirstChild'SeatWeld'while p do p:Remove()p=n[o]:
FindFirstChild'SeatWeld'end end else for o=1,#n do a('Weld','SeatWeld',{Parent=n
[o]})end end end local l l=function(m)do local n=m:FindFirstChild
'AutoAlignToFace'if n then return n.Value else return false end end end local m
m=function(n)local o,p,q=Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1
)local r,s,t=n.x*o.x+n.y*o.y+n.z*o.z,n.x*p.x+n.y*p.y+n.z*p.z,n.x*q.x+n.y*q.y+n.z
*q.z if math.abs(r)>math.abs(s)and math.abs(r)>math.abs(t)then if r>0 then
return 0 else return 3 end elseif math.abs(s)>math.abs(r)and math.abs(s)>math.
abs(t)then if s>0 then return 1 else return 4 end else if t>0 then return 2 else
return 5 end end end local n n=function(o,p)local q if not p then return p end
if p and(p:IsA'Model'or p:IsA'Tool')then q=p:GetModelCFrame()p:TranslateBy(o.p-q
.p)else p.CFrame=o end return p end local o o=function(p,q,r)if math.abs(q)<0.01
then return 0 end return(r-p)/q end local p p=function(q,r,s)if not q then
return 0 end local t,u if q:IsA'Model'then t=q:GetModelCFrame()u=q:GetModelSize(
)else t=q.CFrame u=q.Size end local v,w=t:pointToObjectSpace(r),t:
pointToObjectSpace(s)local x,y,z,A=w-v,1,1,1 if x.X>0 then y=-1 end if x.Y>0
then z=-1 end if x.Z>0 then A=-1 end local B,C,D,E=o(v.X,x.X,u.X/2*y),o(v.Y,x.Y,
u.Y/2*z),o(v.Z,x.Z,u.Z/2*A),0 if B>C then if B>D then E=1*y else E=3*A end else
if C>D then E=2*z else E=3*A end end return E end local q q=function(r)local s,t
=Vector3.new(math.huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-
math.huge)if r:IsA'Terrain'then s=Vector3.new(-2,-2,-2)t=Vector3.new(2,2,2)
elseif r:IsA'BasePart'then s=-0.5*r.Size t=-s else t=r:GetModelSize()*0.5 s=-t
end local u=r:FindFirstChild'Justification'if(u~=nil)then local v,w,x=u.Value,
Vector3.new(2,2,2),t-s-Vector3.new(0.01,0.01,0.01)local y=Vector3.new(4*math.
ceil(x.x/4),4*math.ceil(x.y/4),4*math.ceil(x.z/4))local z=y-x s=s-(0.5*z*v)t=t+(
0.5*z*(w-v))end return s,t end local r r=function(s)local t,u=Vector3.new(math.
huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-math.huge)if s:IsA
'BasePart'and not s:IsA'Terrain'then local v,w=s.CFrame:pointToWorldSpace(-0.5*s
.Size),s.CFrame:pointToWorldSpace(0.5*s.Size)t=Vector3.new(math.min(v.X,w.X),
math.min(v.Y,w.Y),math.min(v.Z,w.Z))u=Vector3.new(math.max(v.X,w.X),math.max(v.Y
,w.Y),math.max(v.Z,w.Z))elseif not s:IsA'Terrain'then local v,w=s:
GetModelCFrame():pointToWorldSpace(-0.5*s:GetModelSize()),s:GetModelCFrame():
pointToWorldSpace(0.5*s:GetModelSize())t=Vector3.new(math.min(v.X,w.X),math.min(
v.Y,w.Y),math.min(v.Z,w.Z))u=Vector3.new(math.max(v.X,w.X),math.max(v.Y,w.Y),
math.max(v.Z,w.Z))end return t,u end local s s=function(t)return q((function()if
(t.Parent:FindFirstChild'RobloxModel'~=nil)then return t.Parent else return t
end end)())end local t t=function(u)if(u.Parent:FindFirstChild'RobloxModel'~=nil
)then if u.Parent:IsA'Tool'then return u.Parent.Handle.CFrame else return u.
Parent:GetModelCFrame()end else return u.CFrame end end local u u=function(v)if
not v then return false end if not v.Parent then return false end if v:
FindFirstChild'Humanoid'then return false end if v:FindFirstChild'RobloxStamper'
or v:FindFirstChild'RobloxModel'then return true end if v:IsA'Part'and not v.
CanCollide then return false end if v==game.Lighting then return false end
return u(v.Parent)end local v v=function(w,x,y)local z=game.Workspace:
FindPartsInRegion3(Region3.new(Vector3.new(w.Position.X,x,w.Position.Z)-Vector3.
new(0.75,2.75,0.75),Vector3.new(w.Position.X,x,w.Position.Z)+Vector3.new(0.75,
1.75,0.75)),w.Parent,100)for A=1,#z do if z[A].CanCollide and not z[A]:
IsDescendantOf(y.CurrentParts)then return false end end if i(Vector3.new(w.
Position.X,x,w.Position.Z)-Vector3.new(0.75,2.75,0.75),Vector3.new(w.Position.X,
x,w.Position.Z)+Vector3.new(0.75,1.75,0.75))then return false end return true
end local w w=function(x,y)if not x then return end if not y then return error
'findConfigAtMouseTarget: stampData is nil'end if not y['CurrentParts']then
return end local z,A,B,C,D=4,false,CFrame.new(0,0,0),q(y.CurrentParts)local E,F=
D-C,nil if y.CurrentParts:IsA'Model'or y.CurrentParts:IsA'Tool'then F=y.
CurrentParts:GetModelCFrame()else F=y.CurrentParts.CFrame end if x then if y.
CurrentParts:IsA'Tool'then x.TargetFilter=y.CurrentParts.Handle else x.
TargetFilter=y.CurrentParts end end local G,H=false,nil local I=pcall(function()
H=x.Target end)if not I then return A,B end local J=Vector3.new(0,0,0)if x then
J=Vector3.new(x.Hit.x,x.Hit.y,x.Hit.z)end local K if nil==H then K=d(x)if nil==K
then G=false return A,B else H=game.Workspace.Terrain G=true K=Vector3.new(K.X-1
,K.Y,K.Z)J=game.Workspace.Terrain:CellCenterToWorld(K.x,K.y,K.z)end end local L,
M=s(H)local N,O=M-L,t(H)if H:IsA'Terrain'then if not cluster then cluster=game.
Workspace:FindFirstChild'Terrain'end local P=cluster:WorldToCellPreferSolid(J)if
G then P=K end O=CFrame.new(game.Workspace.Terrain:CellCenterToWorld(P.x,P.y,P.z
))end local P,Q=O:pointToObjectSpace(J),Vector3.new(0,0,0)if x then Q=H.CFrame:
vectorToWorldSpace(Vector3.FromNormalId(x.TargetSurface))end local R,S,T if m(Q)
==0 then R=O:vectorToObjectSpace(Vector3.new(1,-1,1))S=F:vectorToObjectSpace(
Vector3.new(-1,-1,1))T=Vector3.new(0,1,1)elseif m(Q)==3 then R=O:
vectorToObjectSpace(Vector3.new(-1,-1,-1))S=F:vectorToObjectSpace(Vector3.new(1,
-1,-1))T=Vector3.new(0,1,1)elseif m(Q)==1 then R=O:vectorToObjectSpace(Vector3.
new(-1,1,1))S=F:vectorToObjectSpace(Vector3.new(-1,-1,1))T=Vector3.new(1,0,1)
elseif m(Q)==4 then R=O:vectorToObjectSpace(Vector3.new(-1,-1,1))S=F:
vectorToObjectSpace(Vector3.new(-1,1,1))T=Vector3.new(1,0,1)elseif m(Q)==2 then
R=O:vectorToObjectSpace(Vector3.new(-1,-1,1))S=F:vectorToObjectSpace(Vector3.
new(-1,-1,-1))T=Vector3.new(1,1,0)else R=O:vectorToObjectSpace(Vector3.new(1,-1,
-1))S=F:vectorToObjectSpace(Vector3.new(1,-1,1))T=Vector3.new(1,1,0)end R=R*((
0.5*N)+0.5*(M+L))S=S*((0.5*E)+0.5*(D+C))local U=P-R local V=Vector3.new(z*math.
modf(U.x/z),z*math.modf(U.y/z),z*math.modf(U.z/z))V=V*T local W=V+R local X,Y=O:
pointToWorldSpace(W),F:vectorToWorldSpace(S)local Z,_,aa,ab,ac,ad,ae,af,ag,ah,ai
,aj,ak=X-Y,F:components()B=CFrame.new(Z.x,Z.y,Z.z,ac,ad,ae,af,ag,ah,ai,aj,ak)A=
true return A,B,m(Q)end local ab ab=function(ac,ad)local ae,af=math.abs(ac),math
.abs(ad)local ag=math.sqrt(ae*ae+af*af)local ah,ai,aj=af/ag,1,1 if ac<0 then ai=
-1 end if ad<0 then aj=-1 end if ah>0.382683432 then return 0.707106781*ag*ai,
0.707106781*ag*aj else return ag*ai,0 end end local ac ac=function(ad,ae,af)if
ad:IsA'ManualWeld'or ad:IsA'Rotate'then table.insert(ae,ad)return table.insert(
af,ad.Parent)else local ag=ad:GetChildren()for ah=1,#ag do ac(ag[ah],ae,af)end
end end local ad ad=function(ae,af)for ag=1,#ae do ae[ag].Parent=af[ag]end end b
.CanEditRegion=function(ae,af)if not af then return true,false end local ag,ah=
r(ae)if ag.X<af.CFrame.p.X-af.Size.X/2 or ag.Y<af.CFrame.p.Y-af.Size.Y/2 or ag.Z
<af.CFrame.p.Z-af.Size.Z/2 then return false,false end if ah.X>af.CFrame.p.X+af.
Size.X/2 or ah.Y>af.CFrame.p.Y+af.Size.Y/2 or ah.Z>af.CFrame.p.Z+af.Size.Z/2
then return false,false end return true,false end b.GetStampModel=function(ae,af
,ag)if ae==0 then return nil,'No Asset'end if ae<0 then return nil,
'Negative Asset'end local ah ah=function(ai)if ai:IsA'BasePart'then ai.Locked=
false end for aj,ak in pairs(ai:GetChildren())do ah(ak)end end local ai ai=
function(aj)return BrickColor.new((function()if 1==aj then return'Bright green'
elseif 2==aj then return'Bright yellow'elseif 3==aj then return'Bright red'
elseif 4==aj then return'Sand red'elseif 5==aj then return'Black'elseif 6==aj
then return'Dark stone grey'elseif 7==aj then return'Sand blue'elseif 8==aj then
return'Deep orange'elseif 9==aj then return'Dark orange'elseif 10==aj then
return'Reddish brown'elseif 11==aj then return'Light orange'elseif 12==aj then
return'Light stone grey'elseif 13==aj then return'Sand green'elseif 14==aj then
return'Medium stone grey'elseif 15==aj then return'Really red'elseif 16==aj then
return'Really blue'elseif 17==aj then return'Bright blue'else return
'Bright green'end end)())end local aj aj=function(ak,x,y)local z if x==1 or x==4
then z=Instance.new'WedgePart'z.formFactor='Custom'elseif x==2 then z=Instance.
new'CornerWedgePart'else z=Instance.new'Part'z.formFactor='Custom'end z.Name=
'MegaClusterCube'z.Size=Vector3.new(4,4,4)z.BottomSurface='Smooth'z.TopSurface=
'Smooth'z.BrickColor=ai(ak)local A,B=0,math.pi if x==4 then A=-math.pi/2 end if
x==2 or x==3 then B=0 end z.CFrame=CFrame.Angles(0,math.pi/2*y+B,A)if x==3 then
a('SpecialMesh',{MeshType='FileMesh',MeshId=
'http://www.roblox.com/asset?id=66832495',Scale=Vector3.new(2,2,2),Parent=z})end
a('Vector3Value','ClusterMaterial',{Value=Vector3.new(ak,x,y),Parent=z})return z
end local ak,x,y=nil,nil,true if ag then x=coroutine.create(function()ak=game:
GetService'InsertService':LoadAssetVersion(ae)y=false end)coroutine.resume(x)
else x=coroutine.create(function()ak=game:GetService'InsertService':LoadAsset(ae
)y=false end)coroutine.resume(x)end local z,A,B=0,0,8 while y and A<B do z=tick(
)wait(1)A=A+(tick()-z)end y=false if A>=B then return nil,'Load Time Fail'end if
ak==nil then return nil,'Load Asset Fail'end if not ak:IsA'Model'then return nil
,'Load Type Fail'end local C=ak:GetChildren()if#C==0 then return nil,
'Empty Model Fail'end ah(ak)ak=ak:GetChildren()[1]for D,E in pairs(C)do if E:IsA
'Team'then E.Parent=game:GetService'Teams'elseif E:IsA'Sky'then local F=game:
GetService'Lighting'for G,H in pairs(F:GetChildren())do if H:IsA'Sky'then H:
Remove()end end E.Parent=F return end end if ak:FindFirstChild'RobloxModel'==nil
then a('BoolValue','RobloxModel',{Parent=ak})if ak:FindFirstChild'RobloxStamper'
==nil then a('BoolValue','RobloxStamper',{Parent=ak})end end if af then if ak.
Name=='MegaClusterCube'then if af==6 then a('BoolValue','AutoWedge',{Parent=ak})
else local F=ak:FindFirstChild'ClusterMaterial'if F then if F:IsA'Vector3Value'
then ak=aj(F.Value.X,af,F.Value.Z)else ak=aj(F.Value,af,0)end else ak=aj(1,af,0)
end end end end return ak end b.SetupStamperDragger=function(ae,af,ag,ah,ai)if
not ae then error
[[SetupStamperDragger: modelToStamp (first arg) is nil! Should be a stamper model]]
return nil end if not ae:IsA'Model'and not ae:IsA'BasePart'then error
[[SetupStamperDragger: modelToStamp (first arg) is neither a Model or Part!]]
return nil end if not af then error
[[SetupStamperDragger: Mouse (second arg) is nil! Should be a mouse object]]
return nil end if not af:IsA'Mouse'then error
[[SetupStamperDragger: Mouse (second arg) is not of type Mouse!]]return nil end
local aj,ak,x if ag then if not ag:IsA'Model'then error
[[SetupStamperDragger: StampInModel (optional third arg) is not of type 'Model']]
return nil end if not ah then error
[[SetupStamperDragger: AllowedStampRegion (optional fourth arg) is nil when StampInModel (optional third arg) is defined]]
return nil end x=ai aj=ag ak=ah end local y,z,A,B,C=0,nil,nil,a('SelectionBox',{
Color=BrickColor.new'Bright red',Transparency=0,Archivable=false}),a('Part',{
Parent=nil,formFactor='Custom',Size=Vector3.new(4,4,4),CFrame=CFrame.new(),
Archivable=false})local D,E=a('SelectionBox','HighScalabilityStamperLine',{Color
=BrickColor.new'Toothpaste',Adornee=C,Visible=true,Transparency=0,Archivable=
false}),{}E.Start=nil E.End=nil E.Adorn=D E.AdornPart=C E.InternalLine=nil E.
NewHint=true E.MorePoints={nil,nil}E.MoreLines={nil,nil}E.Dimensions=1 local F,G
,H,I,J,K,L,M={},false,false,false,{},nil,a('BoolValue',{Archivable=false,Value=
false}),{}M.TerrainOrientation=0 M.CFrame=0 local N={}N.Material=1 N.clusterType
=0 N.clusterOrientation=0 local O O=function()if not z then return false end if
not z.CurrentParts then return false end return z.CurrentParts:FindFirstChild(
'ClusterMaterial',true)or(z.CurrentParts.Name=='MegaClusterCube')end local P P=
function()local Q=z.CurrentParts:FindFirstChild'MegaClusterCube'if not Q then if
not z.CurrentParts.Name=='MegaClusterCube'then return else Q=z.CurrentParts end
end E.End=Q.CFrame.p local R,S,T=nil,Vector3.new(0,0,0),Vector3.new(0,0,0)if E.
Dimensions==1 then R=E.End-E.Start if math.abs(R.X)<math.abs(R.Y)then if math.
abs(R.X)<math.abs(R.Z)then local U,V if math.abs(R.Y)>math.abs(R.Z)then U,V=ab(R
.Y,R.Z)else V,U=ab(R.Z,R.Y)end R=Vector3.new(0,U,V)else local U,V=ab(R.Y,R.X)R=
Vector3.new(V,U,0)end else if math.abs(R.Y)<math.abs(R.Z)then local U,V if math.
abs(R.X)>math.abs(R.Z)then U,V=ab(R.X,R.Z)else V,U=ab(R.Z,R.X)end R=Vector3.new(
U,0,V)else local U,V=ab(R.X,R.Y)R=Vector3.new(U,V,0)end end E.InternalLine=R
elseif E.Dimensions==2 then R=E.MoreLines[1]S=E.End-E.MorePoints[1]S=S-(R.unit*R
.unit:Dot(S))local U=CFrame.new(E.Start,E.Start+R)local V,W=U:
vectorToWorldSpace(Vector3.new(0,1,0)),U:vectorToWorldSpace(Vector3.new(1,0,0))
local X,Y=W:Dot(S),V:Dot(S)if math.abs(Y)>math.abs(X)then S=S-(W*X)else S=S-(V*Y
)end E.InternalLine=S elseif E.Dimensions==3 then R=E.MoreLines[1]S=E.MoreLines[
2]T=E.End-E.MorePoints[2]T=T-(R.unit*R.unit:Dot(T))T=T-(S.unit*S.unit:Dot(T))E.
InternalLine=T end local U=CFrame.new(E.Start,E.Start+R)if E.Dimensions==1 then
E.AdornPart.Size=Vector3.new(4,4,R.magnitude+4)E.AdornPart.CFrame=U+U:
vectorToWorldSpace(Vector3.new(2,2,2)-E.AdornPart.Size/2)else local V=U:
vectorToObjectSpace(R+S+T)E.AdornPart.Size=Vector3.new(4,4,4)+Vector3.new(math.
abs(V.X),math.abs(V.Y),math.abs(V.Z))E.AdornPart.CFrame=U+U:vectorToWorldSpace(V
/2)end local V if game.Players['LocalPlayer']then V=game.Players.LocalPlayer:
FindFirstChild'PlayerGui'if V and V:IsA'PlayerGui'then if(E.Dimensions==1 and R.
magnitude>3)or E.Dimensions>1 then E.Adorn.Parent=V end end end if not(V~=nil)
then V=game:GetService'CoreGui'if(E.Dimensions==1 and R.magnitude>3)or E.
Dimensions>1 then E.Adorn.Parent=V end end end local Q Q=function(R)if not R
then error'Error: RbxStamper.DoStamperMouseMove: Mouse is nil'return end if not
R:IsA'Mouse'then error('Error: RbxStamper.DoStamperMouseMove: Mouse is of type',
R.className,'should be of type Mouse')return end if not R.Target then local S=d(
R)if nil==S then return end end if not z then return end local S,T,U=w(R,z)if
not S then error'RbxStamper.DoStamperMouseMove No configFound, returning'return
end local V=0 if l(z.CurrentParts)and U~=1 and U~=4 then if U==3 then V=0-y+l(z.
CurrentParts)elseif U==0 then V=2-y+l(z.CurrentParts)elseif U==5 then V=3-y+l(z.
CurrentParts)elseif U==2 then V=1-y+l(z.CurrentParts)end end local W=math.pi/2 y
=y+V if z.CurrentParts:IsA'Model'or z.CurrentParts:IsA'Tool'then g(z.
CurrentParts,W*V)else z.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,W*V,0,{z
.CurrentParts.CFrame})end local X,Y=r(z.CurrentParts)local Z if z.CurrentParts:
IsA'Model'then Z=z.CurrentParts:GetModelCFrame()else Z=z.CurrentParts.CFrame end
X=X+(T.p-Z.p)Y=Y+(T.p-Z.p)if i(X+e,Y-e)then if M.CFrame then if z.CurrentParts:
FindFirstChild('ClusterMaterial',true)then local al=z.CurrentParts:
FindFirstChild('ClusterMaterial',true)if al:IsA'Vector3Value'then local am=z.
CurrentParts:FindFirstChild('ClusterMaterial',true)if am then am=clusterMat end
end end end return end if O()then local al=game.Workspace.Terrain:WorldToCell(T.
p)local am,an,ao,ap,aq,ar,as,at,au,av,aw,ax,ay=game.Workspace.Terrain:
CellCenterToWorld(al.X,al.Y,al.Z),T:components()T=CFrame.new(am.X,am.Y,am.Z,aq,
ar,as,at,au,av,aw,ax,ay)end n(T,z.CurrentParts)M.CFrame=T if z.CurrentParts:
FindFirstChild('ClusterMaterial',true)then local al=z.CurrentParts:
FindFirstChild('ClusterMaterial',true)if al:IsA'Vector3Value'then M.
TerrainOrientation=al.Value.Z end end if R and R.Target and R.Target.Parent then
local al=R.Target:FindFirstChild'RobloxModel'if not al then al=R.Target.Parent:
FindFirstChild'RobloxModel'end local am=z.CurrentParts:FindFirstChild
'UnstampableFaces'do local ap,aq='',''if al and al.Parent:FindFirstChild
'UnstampableFaces'then ap=al.Parent.UnstampableFaces.Value end if am then aq=am.
Value end local ar=0 if al then ar=p(al.Parent,game.Workspace.CurrentCamera.
CoordinateFrame.p,R.Hit.p)end for as in string.gmatch(ap,'[^,]+')do if ar==
tonumber(as)then I=true game.JointsService:ClearJoinAfterMoveJoints()return end
end ar=p(z.CurrentParts,R.Hit.p,game.Workspace.CurrentCamera.CoordinateFrame.p)
for at in string.gmatch(aq,'[^,]+')do if ar==tonumber(at)then I=true game.
JointsService:ClearJoinAfterMoveJoints()return end end end end I=false game.
JointsService:SetJoinAfterMoveInstance(z.CurrentParts)if(not pcall(function()
return end))then error
[[Error: RbxStamper.DoStamperMouseMove Mouse is nil on second check]]game.
JointsService:ClearJoinAfterMoveJoints()R=nil return end if R and R.Target and
not(R.Target.Parent:FindFirstChild'RobloxModel'~=nil)then game.JointsService:
SetJoinAfterMoveTarget(R.Target)else game.JointsService:SetJoinAfterMoveTarget(
nil)end game.JointsService:ShowPermissibleJoints()if O()and E and E.Start then
return P()end end local al al=function(am,ap)if F and F['Paused']then return end
am=string.lower(am)if am=='r'and not l(z.CurrentParts)then y=y+1 local aq=z.
CurrentParts:FindFirstChild('ClusterMaterial',true)if aq and aq:IsA
'Vector3Value'then aq.Value=Vector3.new(aq.Value.X,aq.Value.Y,(aq.Value.Z+1)%4)
end local ar=math.pi/2 if z.CurrentParts:IsA'Model'or z.CurrentParts:IsA'Tool'
then g(z.CurrentParts,ar)else z.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,
ar,0)*z.CurrentParts.CFrame end local at,au=w(ap,z)if at then n(au,z.
CurrentParts)return Q(ap)end elseif am=='c'then if E.InternalLine and E.
InternalLine.magnitude>0 and E.Dimensions<3 then E.MorePoints[E.Dimensions]=E.
End E.MoreLines[E.Dimensions]=E.InternalLine E.Dimensions=E.Dimensions+1 E.
NewHint=true end return E end end K=af.KeyDown:connect(function(am)return al(am,
af)end)local am am=function()if E then E.Start=nil E.End=nil E.InternalLine=nil
E.NewHint=true end end local ap ap=function()local aq=game.CoreGui if game:
FindFirstChild'Players'and game.Players['LocalPlayer']and game.Players.
LocalPlayer:FindFirstChild'PlayerGui'then aq=game.Players.LocalPlayer.PlayerGui
end if not z['ErrorBox']then return end z.ErrorBox.Parent=aq if z.CurrentParts:
IsA'Tool'then z.ErrorBox.Adornee=z.CurrentParts.Handle else z.ErrorBox.Adornee=z
.CurrentParts end return delay(0,function()for ar=1,3 do if z['ErrorBox']then z.
ErrorBox.Visible=true end wait(0.13)if z['ErrorBox']then z.ErrorBox.Visible=
false end wait(0.13)end if z['ErrorBox']then z.ErrorBox.Adornee=nil z.ErrorBox.
Parent=Tool end end)end local aq aq=function(ar)if not ar then error
'Error: RbxStamper.DoStamperMouseDown: Mouse is nil'return end if not ar:IsA
'Mouse'then error('Error: RbxStamper.DoStamperMouseDown: Mouse is of type',ar.
className,'should be of type Mouse')return end if not z then return end if O()
then if ar and E then local at,au=z.CurrentParts:FindFirstChild(
'MegaClusterCube',true),game.Workspace.Terrain if at then E.Dimensions=1 local
av=au:WorldToCell(at.CFrame.p)E.Start=au:CellCenterToWorld(av.X,av.Y,av.Z)return
else E.Dimensions=1 local av=au:WorldToCell(z.CurrentParts.CFrame.p)E.Start=au:
CellCenterToWorld(av.X,av.Y,av.Z)return end end end end local ar ar=function(at,
au)at.TopSurface=au[1]at.BottomSurface=au[2]at.LeftSurface=au[3]at.RightSurface=
au[4]at.FrontSurface=au[5]at.BackSurface=au[6]return at end local at at=function
(au,av)local aw={}aw[1]=au.TopSurface aw[2]=au.BottomSurface aw[3]=au.
LeftSurface aw[4]=au.RightSurface aw[5]=au.FrontSurface aw[6]=au.BackSurface av[
au]=aw end local au au=function(av)if not av then return nil end local aw,ax,ay,
R,S,T=0.7,1,av:Clone(),{},{},{}z={}z.DisabledScripts={}z.TransparencyTable={}z.
MaterialTable={}z.CanCollideTable={}z.AnchoredTable={}z.ArchivableTable={}z.
DecalTransparencyTable={}z.SurfaceTypeTable={}h(ay,S,R,T)if#S<=0 then return nil
,'no parts found in modelToStamp'end for U,V in pairs(R)do if not V.Disabled
then V.Disabled=true z.DisabledScripts[#z.DisabledScripts+1]=V end end for W,X
in pairs(S)do z.TransparencyTable[X]=X.Transparency X.Transparency=ax+(1-ax)*X.
Transparency z.MaterialTable[X]=X.Material X.Material=Enum.Material.Plastic z.
CanCollideTable[X]=X.CanCollide X.CanCollide=false z.AnchoredTable[X]=X.Anchored
X.Anchored=true z.ArchivableTable[X]=X.Archivable X.Archivable=false at(X,z.
SurfaceTypeTable)local Y,Z=0.5,0.5 delay(0,function()wait(Y)local az=tick()local
aA=az while(aA-az)<Z and X and X:IsA'BasePart'and X.Transparency>aw do local aB=
1-(((aA-az)/Z)*(ax-aw))if z['TransparencyTable']and z.TransparencyTable[X]then X
.Transparency=aB+(1-aB)*z.TransparencyTable[X]end wait(0.03)aA=tick()end if X
and X:IsA'BasePart'then if z['TransparencyTable']and z.TransparencyTable[X]then
X.Transparency=aw+(1-aw)*z.TransparencyTable[X]end end end)end for az,aA in
pairs(T)do z.DecalTransparencyTable[aA]=aA.Transparency aA.Transparency=aw+(1-aw
)*aA.Transparency end k(ay,true)k(ay,false)z.CurrentParts=ay if l(ay)then z.
CurrentParts:ResetOrientationToIdentity()y=0 else local aB=y*math.pi/2 if z.
CurrentParts:IsA'Model'or z.CurrentParts:IsA'Tool'then g(z.CurrentParts,aB)else
z.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,aB,0)*z.CurrentParts.CFrame
end end local aB=z.CurrentParts:FindFirstChild('ClusterMaterial',true)if aB and
aB:IsA'Vector3Value'then aB.Value=Vector3.new(aB.Value.X,aB.Value.Y,(aB.Value.Z+
y)%4)end local Y,Z=w(af,z)if Y then z.CurrentParts=n(Z,z.CurrentParts)end game.
JointsService:SetJoinAfterMoveInstance(z.CurrentParts)return ay,S end local av
av=function(aw,ax)local ay=game.Workspace.Terrain.CellCenterToWorld local az=ay(
game.Workspace.Terrain,aw.X,aw.Y,aw.Z)local aA,aB=game.Workspace:
FindPartsInRegion3(Region3.new(az-Vector3.new(2,2,2)+e,az+Vector3.new(2,2,2)-e),
z.CurrentParts,100),false for R=1,#aA do if u(aA[R])then aB=true break end end
if not aB then local R={}for S=1,#aA do if aA[S].Parent and not R[aA[S].Parent]
and aA[S].Parent:FindFirstChild(aA[S].Parent:FindFirstChild'Humanoid':IsA
'Humanoid')then local T=aA[S].Parent:FindFirstChild'Torso'R[aA[S].Parent]=true
if T then local V=az.Y+5 if v(T,V,z)then T.CFrame=T.CFrame+Vector3.new(0,V-T.
CFrame.p.Y,0)else aB=true break end end end end end if not aB then local R=true
if ax then if ak then aw=ay(game.Workspace.Terrain,aw.X,aw.Y,aw.Z)if(aw.X+2>ak.
CFrame.p.X+ak.Size.X/2)or(aw.X-2<ak.CFrame.p.X-ak.Size.X/2)or(aw.Y+2>ak.CFrame.p
.Y+ak.Size.Y/2)or(aw.Y-2<ak.CFrame.p.Y-ak.Size.Y/2)or(aw.Z+2>ak.CFrame.p.Z+ak.
Size.Z/2)or(aw.Z-2<ak.CFrame.p.Z-ak.Size.Z/2)then R=false end end end return R
end return false end local aw aw=function(ax)local ay,az,aA,aB,R,S,T,V,X=false,
game.Workspace.Terrain,E.InternalLine,game.Workspace.Terrain.MaxExtents.Max,game
.Workspace.Terrain.MaxExtents.Min,1,0,0,false if z.CurrentParts:FindFirstChild
'AutoWedge'then X=true end if z.CurrentParts:FindFirstChild('ClusterMaterial',
true)then S=z.CurrentParts:FindFirstChild('ClusterMaterial',true)if S:IsA
'Vector3Value'then T=S.Value.Y V=S.Value.Z S=S.Value.X elseif S:IsA'IntValue'
then S=S.Value end end if E.Adorn.Parent and E.Start and((E.Dimensions>1)or(aA
and aA.magnitude>0))then local Y,Z,aC,aD,aE,aF,aG,aH=game.Workspace.Terrain:
WorldToCell(E.Start),{0,0,0},{0,0,0},{0,0,0},{nil,nil,nil},{Vector3.new(0,0,0),
Vector3.new(0,0,0),Vector3.new(0,0,0)},{Vector3.new(1,0,0),Vector3.new(0,1,0),
Vector3.new(0,0,1)},{}if E.Dimensions>1 then table.insert(aH,E.MoreLines[1])end
if aA and aA.magnitude>0 then table.insert(aH,aA)end if E.Dimensions>2 then
table.insert(aH,E.MoreLines[2])end for aI=1,#aH do aH[aI]=Vector3.new(math.
floor(aH[aI].X+0.5),math.floor(aH[aI].Y+0.5),math.floor(aH[aI].Z+0.5))if aH[aI].
X>0 then Z[aI]=1 elseif aH[aI].X<0 then Z[aI]=-1 end if aH[aI].Y>0 then aC[aI]=1
elseif aH[aI].Y<0 then aC[aI]=-1 end if aH[aI].Z>0 then aD[aI]=1 elseif aH[aI].Z
<0 then aD[aI]=-1 end aE[aI]=Vector3.new(Z[aI],aC[aI],aD[aI])if aE[aI].magnitude
<0.9 then aE[aI]=nil end end if not aH[2]then aH[2]=Vector3.new(0,0,0)end if not
aH[3]then aH[3]=Vector3.new(0,0,0)end local aI,aJ=z.CurrentParts:FindFirstChild(
'WaterForceTag',true),z.CurrentParts:FindFirstChild('WaterForceDirectionTag',
true)while aF[3].magnitude*4<=aH[3].magnitude do local aK=1 while aK<4 do aF[2]=
Vector3.new(0,0,0)while aF[2].magnitude*4<=aH[2].magnitude do local aL=1 while
aL<4 do aF[1]=Vector3.new(0,0,0)while aF[1].magnitude*4<=aH[1].magnitude do
local aM=aF[1]+aF[2]+aF[3]local aN=Vector3int16.new(Y.X+aM.X,Y.Y+aM.Y,Y.Z+aM.Z)
if aN.X>=R.X and aN.Y>=R.Y and aN.Z>=R.Z and aN.X<aB.X and aN.Y<aB.Y and aN.Z<aB
.Z then local aO=av(aN,ax)if aO then if aI then az:SetWaterCell(aN.X,aN.Y,aN.Z,
Enum.WaterForce[aI.Value],Enum.WaterDirection[aJ.Value])else az:SetCell(aN.X,aN.
Y,aN.Z,S,T,V)end ay=true if X then game.Workspace.Terrain:AutowedgeCells(
Region3int16.new(Vector3int16.new(aN.x-1,aN.y-1,aN.z-1),Vector3int16.new(aN.x+1,
aN.y+1,aN.z+1)))end end end aF[1]=aF[1]+aE[1]end if aE[2]then while aL<4 and aG[
aL]:Dot(aE[2])==0 do aL=aL+1 end if aL<4 then aF[2]=aF[2]+aG[aL]*aG[aL]:Dot(aE[2
])end aL=aL+1 else aF[2]=Vector3.new(1,0,0)aL=4 end if aF[2].magnitude*4>aH[2].
magnitude then aL=4 end end end if aE[3]then while aK<4 and aG[aK]:Dot(aE[3])==0
do aK=aK+1 end if aK<4 then aF[3]=aF[3]+aG[aK]*aG[aK]:Dot(aE[3])end aK=aK+1 else
aF[3]=Vector3.new(1,0,0)aK=4 end if aF[3].magnitude*4>aH[3].magnitude then aK=4
end end end end E.Start=nil E.Adorn.Parent=nil if ay then z.CurrentParts.Parent=
nil pcall(function()return game:GetService'ChangeHistoryService':SetWaypoint
'StamperMulti'end)end return ay end local ax ax=function(ay)if not ay then error
'Error: RbxStamper.DoStamperMouseUp: Mouse is nil'return false end if not ay:IsA
'Mouse'then error('Error: RbxStamper.DoStamperMouseUp: Mouse is of type',ay.
className,'should be of type Mouse')return false end if not z.Dragger then error
[[Error: RbxStamper.DoStamperMouseUp: stampData.Dragger is nil]]return false end
if not E then return false end local az if aj then local aA,aB=nil,O()if aB and
E and E.Start and E.InternalLine and E.InternalLine.magnitude>0 then aA=true az=
true else aA,az=b.CanEditRegion(z.CurrentParts,ak)end if not aA then if x~=nil
then x()end return false end end if I then ap()return false end local aA aA,az=b
.CanEditRegion(z.CurrentParts,ak)if not aA then if x~=nil then x()end return
false end local aB,aC=r(z.CurrentParts)local aD,aE=w(ay,z)if aD and not E.Adorn.
Parent then if i(aB+e,aC-e)then ap()return false end local aF=game.Workspace:
FindPartsInRegion3(Region3.new(aB+e,aC-e),z.CurrentParts,100)for aG=1,#aF do if
u(aF[aG])then ap()return false end end local aG={}for aH=1,#aF do if aF[aH].
Parent and not aG[aF[aH].Parent]and aF[aH].Parent:FindFirstChild'Humanoid'and aF
[aH].Parent:FindFirstChild'Humanoid':IsA'Humanoid'then local aI=aF[aH].Parent:
FindFirstChild'Torso'aG[aF[aH].Parent]=true if aI then local aJ=aC.Y+3 if v(aI,
aJ,z)then aI.CFrame=aI.CFrame+Vector3.new(0,aJ-aI.CFrame.p.Y,0)else ap()return
false end end end end elseif(not aD)and not(E.Start and E.Adorn.Parent)then am()
return false end if game:FindFirstChild'Players'then if game.Players[
'LocalPlayer']then if game.Players.LocalPlayer['Character']then local aF=game.
Players.LocalPlayer.Character local aG=aF:FindFirstChild'StampTracker'if aG and
not aG.Value then aG.Value=true end end end end if E.Start and E.Adorn.Parent
and O()then if aw(az)or az then z.CurrentParts.Parent=nil return true end end E.
Start=nil E.Adorn.Parent=nil local aF=game.Workspace.Terrain if O()then local aG
if z.CurrentParts:IsA'Model'then aG=aF:WorldToCell(z.CurrentParts:
GetModelCFrame().p)else aG=aF:WorldToCell(z.CurrentParts.CFrame.p)end local aH,
aI=game.Workspace.Terrain.MaxExtents.Max,game.Workspace.Terrain.MaxExtents.Min
if av(aG,false)then local aJ,aK,aL=z.CurrentParts:FindFirstChild(
'ClusterMaterial',true),z.CurrentParts:FindFirstChild('WaterForceTag',true),z.
CurrentParts:FindFirstChild('WaterForceDirectionTag',true)if aG.X>=aI.X and aG.Y
>=aI.Y and aG.Z>=aI.Z and aG.X<aH.X and aG.Y<aH.Y and aG.Z<aH.Z then if aK then
aF:SetWaterCell(aG.X,aG.Y,aG.Z,Enum.WaterForce[aK.Value],Enum.WaterDirection[aL.
Value])elseif not aJ then aF:SetCell(aG.X,aG.Y,aG.Z,N.Material,N.clusterType,y%4
)elseif aJ:IsA'Vector3Value'then aF:SetCell(aG.X,aG.Y,aG.Z,aJ.Value.X,aJ.Value.Y
,aJ.Value.Z)else aF:SetCell(aG.X,aG.Y,aG.Z,aJ.Value,0,0)end local aM=false if z.
CurrentParts:FindFirstChild'AutoWedge'then aM=true end if aM then game.Workspace
.Terrain:AutowedgeCells(Region3int16.new(Vector3int16.new(aG.x-1,aG.y-1,aG.z-1),
Vector3int16.new(aG.x+1,aG.y+1,aG.z+1)))end z.CurrentParts.Parent=nil pcall(
function()return game:GetService'ChangeHistoryService':SetWaypoint
'StamperSingle'end)return true end else ap()return false end end local aG aG=
function()if game:FindFirstChild'Players'and game.Players['LocalPlayer']then
return game.Players.LocalPlayer end end if z.CurrentParts:IsA'Model'or z.
CurrentParts:IsA'Tool'then if z.CurrentParts:IsA'Model'then local aH,aI={},{}ac(
z.CurrentParts,aH,aI)z.CurrentParts:BreakJoints()z.CurrentParts:MakeJoints()ad(
aH,aI)end local aH,aI=z.CurrentParts:FindFirstChild'PlayerIdTag',z.CurrentParts:
FindFirstChild'PlayerNameTag'if(aH~=nil)then local aJ=aG()if(aJ~=nil)then aH.
Value=aJ.userId end end if(aI~=nil)then if game:FindFirstChild(game.Players[
'LocalPlayer'])then local aJ=game.Players.LocalPlayer if(aJ~=nil)then aI.Value=
aJ.Name end end end if not(z.CurrentParts:FindFirstChild'RobloxModel'~=nil)then
a('BoolValue','RobloxModel',{Parent=z.CurrentParts})if not(z.CurrentParts:
FindFirstChild'RobloxStamper'~=nil)then a('BoolValue','RobloxStamper',{Parent=z.
CurrentParts})end end else z.CurrentParts:BreakJoints()if not(z.CurrentParts:
FindFirstChild'RobloxStamper'~=nil)then a('BoolValue','RobloxStamper',{Parent=z.
CurrentParts})end end if not createJoints then game.JointsService:
CreateJoinAfterMoveJoints()end for aH,aI in pairs(z.TransparencyTable)do aH.
Transparency=aI end for aJ,aK in pairs(z.ArchivableTable)do aJ.Archivable=aK end
for aL,aM in pairs(z.MaterialTable)do aL.Material=aM end for aN,aO in pairs(z.
CanCollideTable)do aN.CanCollide=aO end for R,S in pairs(z.AnchoredTable)do R.
Anchored=S end for T,V in pairs(z.DecalTransparencyTable)do T.Transparency=V end
for X,Y in pairs(z.SurfaceTypeTable)do ar(X,Y)end if O()then z.CurrentParts.
Transparency=0 end k(z.CurrentParts,true)z.TransparencyTable=nil z.
ArchivableTable=nil z.MaterialTable=nil z.CanCollideTable=nil z.AnchoredTable=
nil z.SurfaceTypeTable=nil if not(z.CurrentParts:FindFirstChild'RobloxModel'~=
nil)then a('BoolValue','RobloxModel',{Parent=z.CurrentParts})end if
ghostRemovalScript then ghostRemovalScript.Parent=nil end for Z,aP in pairs(z.
DisabledScripts)do aP.Disabled=false end for aQ,aR in pairs(z.DisabledScripts)do
local aS=aR.Parent aR.Parent=nil aR:Clone().Parent=aS end z.DisabledScripts=nil
z.Dragger=nil z.CurrentParts=nil pcall(function()return game:GetService
'ChangeHistoryService':SetWaypoint'StampedObject'end)return true end local ay ay
=function()for az=1,#J do J[az]:disconnect()J[az]=nil end J={}if z and z.
CurrentParts then z.CurrentParts.Parent=nil z.CurrentParts:Remove()end am()
return game.JointsService:ClearJoinAfterMoveJoints()end local az az=function(aA,
aB,aC)local aD,aE={Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)},1
if aC<0 then aE=aE*(-1)aC=aC*(-1)end local aF=aE*aA:vectorToWorldSpace(aD[aC])
for aG=1,#aB do local aK=aB[aG]local aM=aK.CFrame:vectorToObjectSpace(aF)if math
.abs(aM.X)>math.abs(aM.Y)then if math.abs(aM.X)>math.abs(aM.Z)then if aM.X>0
then aK.RightSurface='Unjoinable'else aK.LeftSurface='Unjoinable'end else if aM.
Z>0 then aK.BackSurface='Unjoinable'else aK.FrontSurface='Unjoinable'end end
else if math.abs(aM.Y)>math.abs(aM.Z)then if aM.Y>0 then aK.TopSurface=
'Unjoinable'else aK.BottomSurface='Unjoinable'end else if aM.Z>0 then aK.
BackSurface='Unjoinable'else aK.FrontSurface='Unjoinable'end end end end end
local aA aA=function()local aB,aC=au(ae)if not aB or not aC then return end
local aD=aB:FindFirstChild('UnjoinableFaces',true)if aD then for aE in string.
gmatch(aD.Value,'[^,]*')do if tonumber(aE)then if aB:IsA'Model'then az(aB:
GetModelCFrame(),aC,tonumber(aE))else az(aB.CFrame,aC,tonumber(aE))end end end
end z.ErrorBox=B if aj then aB.Parent=aj else aB.Parent=game.Workspace end if aB
:FindFirstChild('ClusterMaterial',true)then local aE=aB:FindFirstChild(
'ClusterMaterial',true)if aE:IsA'Vector3Value'then N.Material=aE.Value.X N.
clusterType=aE.Value.Y N.clusterOrientation=aE.Value.Z elseif aE:IsA'IntValue'
then N.Material=aE.Value end end pcall(function()A=af.Target end)if A and not(A.
Parent:FindFirstChild'RobloxModel'~=nil)then game.JointsService:
SetJoinAfterMoveTarget(A)else game.JointsService:SetJoinAfterMoveTarget(nil)end
game.JointsService:ShowPermissibleJoints()for aE,aF in pairs(z.DisabledScripts)
do if aF.Name=='GhostRemovalScript'then aF.Parent=z.CurrentParts end end z.
Dragger=Instance.new'Dragger'z.Dragger:MouseDown(aC[1],Vector3.new(0,0,0,aC))z.
Dragger:MouseUp()Q(af)table.insert(J,af.Move:connect(function()if G or H then
return end G=true Q(af)G=false end))table.insert(J,af.Button1Down:connect(
function()return aq(af)end))table.insert(J,af.Button1Up:connect(function()H=true
while G do wait()end L.Value=ax(af)am()H=false end))L.Value=false end local aB
aB=function(aC)if aC then if not aC:IsA'Model'and not aC:IsA'BasePart'then error
[[resetStamperState: newModelToStamp (first arg) is not nil, but not a model or part!]]
end ae=aC end ay()return aA()end aB()F.Stamped=L F.Paused=false F.LoadNewModel=
function(aC)if aC and not aC:IsA'Model'and not aC:IsA'BasePart'then error
[[Control.LoadNewModel: newStampModel (first arg) is not a Model or Part!]]
return nil end return aB(aC)end F.ReloadModel=function()return aB()end F.Pause=
function()if not F.Paused then ay()F.Paused=true else return print
[[RbxStamper Warning: Tried to call Control.Pause! when already paused]]end end
F.Resume=function()if F.Paused then aA()F.Paused=false else return print
[[RbxStamper Warning: Tried to call Control.Resume! without Pausing First]]end
end F.ResetRotation=function()end F.Destroy=function()for aC=1,#J do J[aC]:
disconnect()J[aC]=nil end if K~=nil then K:disconnect()end game.JointsService:
ClearJoinAfterMoveJoints()if D~=nil then D:Destroy()end if C~=nil then C:
Destroy()end if B~=nil then B:Destroy()end if z~=nil then do local aC=z.Dragger
if aC~=nil then aC:Destroy()end end end if z~=nil then do local aC=z.
CurrentParts if aC~=nil then aC:Destroy()end end end if F and F['Stamped']then F
.Stamped:Destroy()end F=nil end return F end b.Help=function(ae)if
'GetStampModel'==ae or b.GetStampModel==ae then return
[[Function GetStampModel. Arguments: assetId, useAssetVersionId. assetId is the asset to load in, define useAssetVersionId as true if assetId is a version id instead of a relative assetId. Side effect: returns a model of the assetId, or a string with error message if something fails]]
elseif'SetupStamperDragger'==ae or b.SetupStamperDragger==ae then return
[[Function SetupStamperDragger. Side Effect: Creates 4x4 stamping mechanism for building out parts quickly. Arguments: ModelToStamp, Mouse, LegalStampCheckFunction. ModelToStamp should be a Model or Part, preferrably loaded from RbxStamper.GetStampModel and should have extents that are multiples of 4. Mouse should be a mouse object (obtained from things such as Tool.OnEquipped), used to drag parts around 'stamp' them out. LegalStampCheckFunction is optional, used as a callback with a table argument (table is full of instances about to be stamped). Function should return either true or false, false stopping the stamp action.]]
end end return b