print'[Mercury]: Loaded corescript 73157242'local a,b={},nil b=function(c)local
d,e,f=false,game.Workspace.CurrentCamera,nil do local g=e.CoordinateFrame.p f=
Vector3.new(g.X,g.Y,g.Z)end local g,h,i=Vector3.new(c.X,c.Y,c.Z),Vector3.new(0,1
,0),Vector3.new(0,0,0)local j,k=h:Dot(g-f),c if j~=0 then a=h:Dot(i-f)/j if a>=0
and a<=1 then local l=((g-f)*a)+f k=game.Workspace.Terrain:WorldToCell(l)d=true
end end return k,d end local c c=function(d)local e,f=game.Workspace.Terrain:
WorldToCellPreferSolid(Vector3.new(d.hit.x,d.hit.y,d.hit.z)),nil if 0==game.
Workspace.Terrain:GetCell(e.X,e.Y,e.Z).Value then e=nil local g f,g=b(Vector3.
new(d.hit.x,d.hit.y,d.hit.z))if g then e=f end end return e end local d,e=
Vector3.new(0.3,0.3,0.3),nil e=function(f,g,h)if f:IsA'BasePart'then f.CFrame=(g
*(f.CFrame-h))+h end local i=f:GetChildren()for j=1,#i do e(i[j],g,h)end end
local f f=function(g,h)local i,j=CFrame.Angles(0,h,0),g:GetModelCFrame().p
return e(g,i,j)end local g g=function(h,i,j,k)if h:IsA'BasePart'then i[#i+1]=h
elseif h:IsA'Script'then j[#j+1]=h elseif h:IsA'Decal'then k[#k+1]=h end for l,m
in pairs(h:GetChildren())do g(m,i,j,k)end end local h h=function(i,j)local k=
game.Workspace:FindFirstChild'Terrain'local l,m=k:WorldToCell(i),k:WorldToCell(j
)local n,o,p,q,r,s=l.X,l.Y,l.Z,m.X,m.Y,m.Z if n<k.MaxExtents.Min.X then n=k.
MaxExtents.Min.X end if o<k.MaxExtents.Min.Y then o=k.MaxExtents.Min.Y end if p<
k.MaxExtents.Min.Z then p=k.MaxExtents.Min.Z end if q>k.MaxExtents.Max.X then q=
k.MaxExtents.Max.X end if r>k.MaxExtents.Max.Y then r=k.MaxExtents.Max.Y end if
s>k.MaxExtents.Max.Z then s=k.MaxExtents.Max.Z end for t=n,q do for u=o,r do for
v=p,s do if k:GetCell(t,u,v).Value>0 then return true end end end end return
false end local i i=function(j,k)if not j then return end if j.className=='Seat'
or j.className=='VehicleSeat'then table.insert(k,j)end local l=j:GetChildren()
for m=1,#l do i(l[m],k)end end local j j=function(k,l)local m={}i(k,m)if l then
for n=1,#m do local o=m[n]:FindFirstChild'SeatWeld'while o do o:Remove()o=m[n]:
FindFirstChild'SeatWeld'end end else for n=1,#m do local o=Instance.new'Weld'o.
Name='SeatWeld'o.Parent=m[n]end end end local k k=function(l)local m=l:
FindFirstChild'AutoAlignToFace'if m then return m.Value else return false end
end local l l=function(m)local n,o,p=Vector3.new(1,0,0),Vector3.new(0,1,0),
Vector3.new(0,0,1)local q,r,s=m.x*n.x+m.y*n.y+m.z*n.z,m.x*o.x+m.y*o.y+m.z*o.z,m.
x*p.x+m.y*p.y+m.z*p.z if math.abs(q)>math.abs(r)and math.abs(q)>math.abs(s)then
if q>0 then return 0 else return 3 end elseif math.abs(r)>math.abs(q)and math.
abs(r)>math.abs(s)then if r>0 then return 1 else return 4 end else if s>0 then
return 2 else return 5 end end end local m m=function(n,o)local p if not o then
return o end if o and(o:IsA'Model'or o:IsA'Tool')then p=o:GetModelCFrame()o:
TranslateBy(n.p-p.p)else o.CFrame=n end return o end local n n=function(o,p,q)if
math.abs(p)<0.01 then return 0 end return(q-o)/p end local o o=function(p,q,r)if
not p then return 0 end local s,t if p:IsA'Model'then s=p:GetModelCFrame()t=p:
GetModelSize()else s=p.CFrame t=p.Size end local u,v=s:pointToObjectSpace(q),s:
pointToObjectSpace(r)local w,x,y,z=v-u,1,1,1 if w.X>0 then x=-1 end if w.Y>0
then y=-1 end if w.Z>0 then z=-1 end local A,B,C,D=n(u.X,w.X,t.X/2*x),n(u.Y,w.Y,
t.Y/2*y),n(u.Z,w.Z,t.Z/2*z),0 if A>B then if A>C then D=1*x else D=3*z end else
if B>C then D=2*y else D=3*z end end return D end local p p=function(q)local r,s
=Vector3.new(math.huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-
math.huge)if q:IsA'Terrain'then r=Vector3.new(-2,-2,-2)s=Vector3.new(2,2,2)
elseif q:IsA'BasePart'then r=-0.5*q.Size s=-r else s=q:GetModelSize()*0.5 r=-s
end local t=q:FindFirstChild'Justification'if(t~=nil)then local u,v,w=t.Value,
Vector3.new(2,2,2),s-r-Vector3.new(0.01,0.01,0.01)local x=Vector3.new(4*math.
ceil(w.x/4),4*math.ceil(w.y/4),4*math.ceil(w.z/4))local y=x-w r=r-(0.5*y*u)s=s+(
0.5*y*(v-u))end return r,s end local q q=function(r)local s,t=Vector3.new(math.
huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-math.huge)if r:IsA
'BasePart'and not r:IsA'Terrain'then local u,v=r.CFrame:pointToWorldSpace(-0.5*r
.Size),r.CFrame:pointToWorldSpace(0.5*r.Size)s=Vector3.new(math.min(u.X,v.X),
math.min(u.Y,v.Y),math.min(u.Z,v.Z))t=Vector3.new(math.max(u.X,v.X),math.max(u.Y
,v.Y),math.max(u.Z,v.Z))elseif not r:IsA'Terrain'then local u,v=r:
GetModelCFrame():pointToWorldSpace(-0.5*r:GetModelSize()),r:GetModelCFrame():
pointToWorldSpace(0.5*r:GetModelSize())s=Vector3.new(math.min(u.X,v.X),math.min(
u.Y,v.Y),math.min(u.Z,v.Z))t=Vector3.new(math.max(u.X,v.X),math.max(u.Y,v.Y),
math.max(u.Z,v.Z))end return s,t end local r r=function(s)return p((function()if
(s.Parent:FindFirstChild'RobloxModel'~=nil)then return s.Parent else return s
end end)())end local s s=function(t)if(t.Parent:FindFirstChild'RobloxModel'~=nil
)then if t.Parent:IsA'Tool'then return t.Parent.Handle.CFrame else return t.
Parent:GetModelCFrame()end else return t.CFrame end end local t t=function(u)if
not u then return false end if not u.Parent then return false end if u:
FindFirstChild'Humanoid'then return false end if u:FindFirstChild'RobloxStamper'
then return true end if u:IsA'Part'and not u.CanCollide then return false end if
u==game.Lighting then return false end return t(u.Parent)end local u u=function(
v,w,x)local y=game.Workspace:FindPartsInRegion3(Region3.new(Vector3.new(v.
Position.X,w,v.Position.Z)-Vector3.new(0.75,2.75,0.75),Vector3.new(v.Position.X,
w,v.Position.Z)+Vector3.new(0.75,1.75,0.75)),v.Parent,100)for z=1,#y do if y[z].
CanCollide and not y[z]:IsDescendantOf(x.CurrentParts)then return false end end
if h(Vector3.new(v.Position.X,w,v.Position.Z)-Vector3.new(0.75,2.75,0.75),
Vector3.new(v.Position.X,w,v.Position.Z)+Vector3.new(0.75,1.75,0.75))then return
false end return true end local v v=function(w,x)if not w then return end if not
x then return error'findConfigAtMouseTarget: stampData is nil'end if not x[
'CurrentParts']then return end local y,z,A,B,C=4,false,CFrame.new(0,0,0),p(x.
CurrentParts)local D,E=C-B,nil if x.CurrentParts:IsA'Model'or x.CurrentParts:IsA
'Tool'then E=x.CurrentParts:GetModelCFrame()else E=x.CurrentParts.CFrame end if
w then if x.CurrentParts:IsA'Tool'then w.TargetFilter=x.CurrentParts.Handle else
w.TargetFilter=x.CurrentParts end end local F,G=false,nil local H=pcall(function
()G=w.Target end)if not H then return z,A end local I=Vector3.new(0,0,0)if w
then I=Vector3.new(w.Hit.x,w.Hit.y,w.Hit.z)end local J if nil==G then J=c(w)if
nil==J then F=false return z,A else G=game.Workspace.Terrain F=true J=Vector3.
new(J.X-1,J.Y,J.Z)I=game.Workspace.Terrain:CellCenterToWorld(J.x,J.y,J.z)end end
local K,L=r(G)local M,N=L-K,s(G)if G:IsA'Terrain'then if not cluster then
cluster=game.Workspace:FindFirstChild'Terrain'end local O=cluster:
WorldToCellPreferSolid(I)if F then O=J end N=CFrame.new(game.Workspace.Terrain:
CellCenterToWorld(O.x,O.y,O.z))end local O,P=N:pointToObjectSpace(I),Vector3.
new(0,0,0)if w then P=G.CFrame:vectorToWorldSpace(Vector3.FromNormalId(w.
TargetSurface))end local Q,R,S if l(P)==0 then Q=N:vectorToObjectSpace(Vector3.
new(1,-1,1))R=E:vectorToObjectSpace(Vector3.new(-1,-1,1))S=Vector3.new(0,1,1)
elseif l(P)==3 then Q=N:vectorToObjectSpace(Vector3.new(-1,-1,-1))R=E:
vectorToObjectSpace(Vector3.new(1,-1,-1))S=Vector3.new(0,1,1)elseif l(P)==1 then
Q=N:vectorToObjectSpace(Vector3.new(-1,1,1))R=E:vectorToObjectSpace(Vector3.new(
-1,-1,1))S=Vector3.new(1,0,1)elseif l(P)==4 then Q=N:vectorToObjectSpace(Vector3
.new(-1,-1,1))R=E:vectorToObjectSpace(Vector3.new(-1,1,1))S=Vector3.new(1,0,1)
elseif l(P)==2 then Q=N:vectorToObjectSpace(Vector3.new(-1,-1,1))R=E:
vectorToObjectSpace(Vector3.new(-1,-1,-1))S=Vector3.new(1,1,0)else Q=N:
vectorToObjectSpace(Vector3.new(1,-1,-1))R=E:vectorToObjectSpace(Vector3.new(1,-
1,1))S=Vector3.new(1,1,0)end Q=Q*((0.5*M)+0.5*(L+K))R=R*((0.5*D)+0.5*(C+B))local
T=O-Q local U=Vector3.new(y*math.modf(T.x/y),y*math.modf(T.y/y),y*math.modf(T.z/
y))U=U*S local V=U+Q local W,X=N:pointToWorldSpace(V),E:vectorToWorldSpace(R)
local Y,Z,_,aa,ab,ac,ad,ae,af,ag,ah,ai,aj=W-X,E:components()A=CFrame.new(Y.x,Y.y
,Y.z,ab,ac,ad,ae,af,ag,ah,ai,aj)z=true return z,A,l(P)end local aa aa=function(
ab,ac)local ad,ae=math.abs(ab),math.abs(ac)local af=math.sqrt(ad*ad+ae*ae)local
ag,ah,ai=ae/af,1,1 if ab<0 then ah=-1 end if ac<0 then ai=-1 end if ag>
0.382683432 then return 0.707106781*af*ah,0.707106781*af*ai else return af*ah,0
end end local ab ab=function(ac,ad,ae)if ac:IsA'ManualWeld'or ac:IsA'Rotate'then
table.insert(ad,ac)return table.insert(ae,ac.Parent)else local af=ac:
GetChildren()for ag=1,#af do ab(af[ag],ad,ae)end end end local ac ac=function(ad
,ae)for af=1,#ad do ad[af].Parent=ae[af]end end a.CanEditRegion=function(ad,ae)
if not ae then return true,false end local af,ag=q(ad)if af.X<ae.CFrame.p.X-ae.
Size.X/2 or af.Y<ae.CFrame.p.Y-ae.Size.Y/2 or af.Z<ae.CFrame.p.Z-ae.Size.Z/2
then return false,false end if ag.X>ae.CFrame.p.X+ae.Size.X/2 or ag.Y>ae.CFrame.
p.Y+ae.Size.Y/2 or ag.Z>ae.CFrame.p.Z+ae.Size.Z/2 then return false,false end
return true,false end a.GetStampModel=function(ad,ae,af)if ad==0 then return nil
,'No Asset'end if ad<0 then return nil,'Negative Asset'end local ag ag=function(
ah)if ah:IsA'BasePart'then ah.Locked=false end for ai,aj in pairs(ah:
GetChildren())do ag(aj)end end local ah ah=function(ai)return BrickColor.new((
function()if 1==ai then return'Bright green'elseif 2==ai then return
'Bright yellow'elseif 3==ai then return'Bright red'elseif 4==ai then return
'Sand red'elseif 5==ai then return'Black'elseif 6==ai then return
'Dark stone grey'elseif 7==ai then return'Sand blue'elseif 8==ai then return
'Deep orange'elseif 9==ai then return'Dark orange'elseif 10==ai then return
'Reddish brown'elseif 11==ai then return'Light orange'elseif 12==ai then return
'Light stone grey'elseif 13==ai then return'Sand green'elseif 14==ai then return
'Medium stone grey'elseif 15==ai then return'Really red'elseif 16==ai then
return'Really blue'elseif 17==ai then return'Bright blue'else return
'Bright green'end end)())end local ai ai=function(aj,w,x)local y if w==1 or w==4
then y=Instance.new'WedgePart'y.formFactor='Custom'elseif w==2 then y=Instance.
new'CornerWedgePart'else y=Instance.new'Part'y.formFactor='Custom'end y.Name=
'MegaClusterCube'y.Size=Vector3.new(4,4,4)y.BottomSurface='Smooth'y.TopSurface=
'Smooth'y.BrickColor=ah(aj)local z,A=0,math.pi if w==4 then z=-math.pi/2 end if
w==2 or w==3 then A=0 end y.CFrame=CFrame.Angles(0,math.pi/2*x+A,z)if w==3 then
local B=Instance.new'SpecialMesh'B.MeshType='FileMesh'B.MeshId=
'http://www.roblox.com/asset?id=66832495'B.Scale=Vector3.new(2,2,2)B.Parent=y
end local B=Instance.new'Vector3Value'B.Value=Vector3.new(aj,w,x)B.Name=
'ClusterMaterial'B.Parent=y return y end local aj,w,x=nil,nil,true if af then w=
coroutine.create(function()aj=game:GetService'InsertService':LoadAssetVersion(ad
)x=false end)coroutine.resume(w)else w=coroutine.create(function()aj=game:
GetService'InsertService':LoadAsset(ad)x=false end)coroutine.resume(w)end local
y,z,A=0,0,8 while x and z<A do y=tick()wait(1)z=z+(tick()-y)end x=false if z>=A
then return nil,'Load Time Fail'end if aj==nil then return nil,'Load Asset Fail'
end if not aj:IsA'Model'then return nil,'Load Type Fail'end local B=aj:
GetChildren()if#B==0 then return nil,'Empty Model Fail'end ag(aj)aj=aj:
GetChildren()[1]for C,D in pairs(B)do if D:IsA'Team'then D.Parent=game:
GetService'Teams'elseif D:IsA'Sky'then local E=game:GetService'Lighting'for F,G
in pairs(E:GetChildren())do if G:IsA'Sky'then G:Remove()end end D.Parent=E
return end end if not(aj:FindFirstChild'RobloxModel'~=nil)then local E=Instance.
new'BoolValue'E.Name='RobloxModel'E.Parent=aj if not(aj:FindFirstChild
'RobloxStamper'~=nil)then local F=Instance.new'BoolValue'F.Name='RobloxStamper'F
.Parent=aj end end if ae then if aj.Name=='MegaClusterCube'then if ae==6 then
local E=Instance.new'BoolValue'E.Name='AutoWedge'E.Parent=aj else local E=aj:
FindFirstChild'ClusterMaterial'if E then if E:IsA'Vector3Value'then aj=ai(E.
Value.X,ae,E.Value.Z)else aj=ai(E.Value,ae,0)end else aj=ai(1,ae,0)end end end
end return aj end a.SetupStamperDragger=function(ad,ae,af,ag,ah)if not ad then
error
[[SetupStamperDragger: modelToStamp (first arg) is nil! Should be a stamper model]]
return nil end if not ad:IsA'Model'and not ad:IsA'BasePart'then error
[[SetupStamperDragger: modelToStamp (first arg) is neither a Model or Part!]]
return nil end if not ae then error
[[SetupStamperDragger: Mouse (second arg) is nil! Should be a mouse object]]
return nil end if not ae:IsA'Mouse'then error
[[SetupStamperDragger: Mouse (second arg) is not of type Mouse!]]return nil end
local ai,aj,w if af then if not af:IsA'Model'then error
[[SetupStamperDragger: StampInModel (optional third arg) is not of type 'Model']]
return nil end if not ag then error
[[SetupStamperDragger: AllowedStampRegion (optional fourth arg) is nil when StampInModel (optional third arg) is defined]]
return nil end w=ah ai=af aj=ag end local x,y,z,A=0,nil,nil,Instance.new
'SelectionBox'A.Color=BrickColor.new'Bright red'A.Transparency=0 A.Archivable=
false local B=Instance.new'Part'B.Parent=nil B.formFactor='Custom'B.Size=Vector3
.new(4,4,4)B.CFrame=CFrame.new()B.Archivable=false local C=Instance.new
'SelectionBox'C.Color=BrickColor.new'Toothpaste'C.Adornee=B C.Visible=true C.
Transparency=0 C.Name='HighScalabilityStamperLine'C.Archivable=false local D={}D
.Start=nil D.End=nil D.Adorn=C D.AdornPart=B D.InternalLine=nil D.NewHint=true D
.MorePoints={nil,nil}D.MoreLines={nil,nil}D.Dimensions=1 local E,F,G,H,I,J,K={},
false,false,false,{},nil,Instance.new'BoolValue'K.Archivable=false K.Value=false
local L={}L.TerrainOrientation=0 L.CFrame=0 local M={}M.Material=1 M.clusterType
=0 M.clusterOrientation=0 local N N=function()if not y then return false end if
not y.CurrentParts then return false end return y.CurrentParts:FindFirstChild(
'ClusterMaterial',true)or(y.CurrentParts.Name=='MegaClusterCube')end local O O=
function()local P=y.CurrentParts:FindFirstChild'MegaClusterCube'if not P then if
not y.CurrentParts.Name=='MegaClusterCube'then return else P=y.CurrentParts end
end D.End=P.CFrame.p local Q,R,S=nil,Vector3.new(0,0,0),Vector3.new(0,0,0)if D.
Dimensions==1 then Q=(D.End-D.Start)if math.abs(Q.X)<math.abs(Q.Y)then if math.
abs(Q.X)<math.abs(Q.Z)then local T,U if math.abs(Q.Y)>math.abs(Q.Z)then T,U=aa(Q
.Y,Q.Z)else U,T=aa(Q.Z,Q.Y)end Q=Vector3.new(0,T,U)else local T,U=aa(Q.Y,Q.X)Q=
Vector3.new(U,T,0)end else if math.abs(Q.Y)<math.abs(Q.Z)then local T,U if math.
abs(Q.X)>math.abs(Q.Z)then T,U=aa(Q.X,Q.Z)else U,T=aa(Q.Z,Q.X)end Q=Vector3.new(
T,0,U)else local T,U=aa(Q.X,Q.Y)Q=Vector3.new(T,U,0)end end D.InternalLine=Q
elseif D.Dimensions==2 then Q=D.MoreLines[1]R=D.End-D.MorePoints[1]R=R-(Q.unit*Q
.unit:Dot(R))local T=CFrame.new(D.Start,D.Start+Q)local U,V=T:
vectorToWorldSpace(Vector3.new(0,1,0)),T:vectorToWorldSpace(Vector3.new(1,0,0))
local W,X=V:Dot(R),U:Dot(R)if math.abs(X)>math.abs(W)then R=R-(V*W)else R=R-(U*X
)end D.InternalLine=R elseif D.Dimensions==3 then Q=D.MoreLines[1]R=D.MoreLines[
2]S=D.End-D.MorePoints[2]S=S-(Q.unit*Q.unit:Dot(S))S=S-(R.unit*R.unit:Dot(S))D.
InternalLine=S end local T=CFrame.new(D.Start,D.Start+Q)if D.Dimensions==1 then
D.AdornPart.Size=Vector3.new(4,4,Q.magnitude+4)D.AdornPart.CFrame=T+T:
vectorToWorldSpace(Vector3.new(2,2,2)-D.AdornPart.Size/2)else local U=T:
vectorToObjectSpace(Q+R+S)D.AdornPart.Size=Vector3.new(4,4,4)+Vector3.new(math.
abs(U.X),math.abs(U.Y),math.abs(U.Z))D.AdornPart.CFrame=T+T:vectorToWorldSpace(U
/2)end local U if game.Players['LocalPlayer']then U=game.Players.LocalPlayer:
FindFirstChild'PlayerGui'if U and U:IsA'PlayerGui'then if(D.Dimensions==1 and Q.
magnitude>3)or D.Dimensions>1 then D.Adorn.Parent=U end end end if not(U~=nil)
then U=game:GetService'CoreGui'if(D.Dimensions==1 and Q.magnitude>3)or D.
Dimensions>1 then D.Adorn.Parent=U end end end local P P=function(Q)if not Q
then error'Error: RbxStamper.DoStamperMouseMove: Mouse is nil'return end if not
Q:IsA'Mouse'then error('Error: RbxStamper.DoStamperMouseMove: Mouse is of type',
Q.className,'should be of type Mouse')return end if not Q.Target then local R=c(
Q)if nil==R then return end end if not y then return end local R,S,T=v(Q,y)if
not R then error'RbxStamper.DoStamperMouseMove No configFound, returning'return
end local U=0 if k(y.CurrentParts)and T~=1 and T~=4 then if T==3 then U=0-x+k(y.
CurrentParts)elseif T==0 then U=2-x+k(y.CurrentParts)elseif T==5 then U=3-x+k(y.
CurrentParts)elseif T==2 then U=1-x+k(y.CurrentParts)end end local V=math.pi/2 x
=x+U if y.CurrentParts:IsA'Model'or y.CurrentParts:IsA'Tool'then f(y.
CurrentParts,V*U)else y.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,V*U,0){y
.CurrentParts.CFrame}end local W,X=q(y.CurrentParts)local Y if y.CurrentParts:
IsA'Model'then Y=y.CurrentParts:GetModelCFrame()else Y=y.CurrentParts.CFrame end
W=W+(S.p-Y.p)X=X+(S.p-Y.p)if h(W+d,X-d)then if L.CFrame then if y.CurrentParts:
FindFirstChild('ClusterMaterial',true)then local ak=y.CurrentParts:
FindFirstChild('ClusterMaterial',true)if ak:IsA'Vector3Value'then local al=y.
CurrentParts:FindFirstChild('ClusterMaterial',true)if al then al=clusterMat end
end end end return end if N()then local ak=game.Workspace.Terrain:WorldToCell(S.
p)local al,am,an,ao,ap,aq,ar,as,at,au,av,aw,ax=game.Workspace.Terrain:
CellCenterToWorld(ak.X,ak.Y,ak.Z),S:components()S=CFrame.new(al.X,al.Y,al.Z,ap,
aq,ar,as,at,au,av,aw,ax)end m(S,y.CurrentParts)L.CFrame=S if y.CurrentParts:
FindFirstChild('ClusterMaterial',true)then local ak=y.CurrentParts:
FindFirstChild('ClusterMaterial',true)if ak:IsA'Vector3Value'then L.
TerrainOrientation=ak.Value.Z end end if Q and Q.Target and Q.Target.Parent then
local ak=Q.Target:FindFirstChild'RobloxModel'if not ak then ak=Q.Target.Parent:
FindFirstChild'RobloxModel'end local al=y.CurrentParts:FindFirstChild
'UnstampableFaces'do local ao,ap='',''if ak and ak.Parent:FindFirstChild
'UnstampableFaces'then ao=ak.Parent.UnstampableFaces.Value end if al then ap=al.
Value end local aq=0 if ak then aq=o(ak.Parent,game.Workspace.CurrentCamera.
CoordinateFrame.p,Q.Hit.p)end for ar in string.gmatch(ao,'[^,]+')do if aq==
tonumber(ar)then H=true game.JointsService:ClearJoinAfterMoveJoints()return end
end aq=o(y.CurrentParts,Q.Hit.p,game.Workspace.CurrentCamera.CoordinateFrame.p)
for as in string.gmatch(ap,'[^,]+')do if aq==tonumber(as)then H=true game.
JointsService:ClearJoinAfterMoveJoints()return end end end end H=false game.
JointsService:SetJoinAfterMoveInstance(y.CurrentParts)if(not pcall(function()if
Q and Q.Target and not(Q.Target.Parent:FindFirstChild'RobloxModel'~=nil)then
return else return end end))then error
[[Error: RbxStamper.DoStamperMouseMove Mouse is nil on second check]]game.
JointsService:ClearJoinAfterMoveJoints()Q=nil return end if Q and Q.Target and
not(Q.Target.Parent:FindFirstChild'RobloxModel'~=nil)then game.JointsService:
SetJoinAfterMoveTarget(Q.Target)else game.JointsService:SetJoinAfterMoveTarget(
nil)end game.JointsService:ShowPermissibleJoints()if N()and D and D.Start then
return O()end end local ak ak=function(al,ao)if E and E['Paused']then return end
al=string.lower(al)if al=='r'and not k(y.CurrentParts)then x=x+1 local ap=y.
CurrentParts:FindFirstChild('ClusterMaterial',true)if ap and ap:IsA
'Vector3Value'then ap.Value=Vector3.new(ap.Value.X,ap.Value.Y,(ap.Value.Z+1)%4)
end local aq=math.pi/2 if y.CurrentParts:IsA'Model'or y.CurrentParts:IsA'Tool'
then f(y.CurrentParts,aq)else y.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,
aq,0)*y.CurrentParts.CFrame end local as,at=v(ao,y)if as then m(at,y.
CurrentParts)return P(ao)end elseif al=='c'then if D.InternalLine and D.
InternalLine.magnitude>0 and D.Dimensions<3 then D.MorePoints[D.Dimensions]=D.
End D.MoreLines[D.Dimensions]=D.InternalLine D.Dimensions=D.Dimensions+1 D.
NewHint=true end end end J=ae.KeyDown:connect(function(al)return ak(al,ae)end)
local al al=function()if D then D.Start=nil D.End=nil D.InternalLine=nil D.
NewHint=true end end local ao ao=function()local ap=game.CoreGui if game:
FindFirstChild'Players'then if game.Players['LocalPlayer']then if game.Players.
LocalPlayer:FindFirstChild'PlayerGui'then ap=game.Players.LocalPlayer.PlayerGui
end end end if not y['ErrorBox']then return end y.ErrorBox.Parent=ap if y.
CurrentParts:IsA'Tool'then y.ErrorBox.Adornee=y.CurrentParts.Handle else y.
ErrorBox.Adornee=y.CurrentParts end return delay(0,function()for aq=1,3 do if y[
'ErrorBox']then y.ErrorBox.Visible=true end wait(0.13)if y['ErrorBox']then y.
ErrorBox.Visible=false end wait(0.13)end if y['ErrorBox']then y.ErrorBox.Adornee
=nil y.ErrorBox.Parent=Tool end end)end local ap ap=function(aq)if not aq then
error'Error: RbxStamper.DoStamperMouseDown: Mouse is nil'return end if not aq:
IsA'Mouse'then error('Error: RbxStamper.DoStamperMouseDown: Mouse is of type',aq
.className,'should be of type Mouse')return end if not y then return end if N()
then if aq and D then local as,at=y.CurrentParts:FindFirstChild(
'MegaClusterCube',true),game.Workspace.Terrain if as then D.Dimensions=1 local
au=at:WorldToCell(as.CFrame.p)D.Start=at:CellCenterToWorld(au.X,au.Y,au.Z)return
else D.Dimensions=1 local au=at:WorldToCell(y.CurrentParts.CFrame.p)D.Start=at:
CellCenterToWorld(au.X,au.Y,au.Z)return end end end end local aq aq=function(as,
at)as.TopSurface=at[1]as.BottomSurface=at[2]as.LeftSurface=at[3]as.RightSurface=
at[4]as.FrontSurface=at[5]as.BackSurface=at[6]return as end local as as=function
(at,au)local av={}av[1]=at.TopSurface av[2]=at.BottomSurface av[3]=at.
LeftSurface av[4]=at.RightSurface av[5]=at.FrontSurface av[6]=at.BackSurface au[
at]=av end local at at=function(au)if not au then return nil end local av,aw,ax,
Q,R,S=0.7,1,au:Clone(),{},{},{}y={}y.DisabledScripts={}y.TransparencyTable={}y.
MaterialTable={}y.CanCollideTable={}y.AnchoredTable={}y.ArchivableTable={}y.
DecalTransparencyTable={}y.SurfaceTypeTable={}g(ax,R,Q,S)if#R<=0 then return nil
,'no parts found in modelToStamp'end for T,U in pairs(Q)do if not U.Disabled
then U.Disabled=true y.DisabledScripts[#y.DisabledScripts+1]=U end end for V,W
in pairs(R)do y.TransparencyTable[W]=W.Transparency W.Transparency=aw+(1-aw)*W.
Transparency y.MaterialTable[W]=W.Material W.Material=Enum.Material.Plastic y.
CanCollideTable[W]=W.CanCollide W.CanCollide=false y.AnchoredTable[W]=W.Anchored
W.Anchored=true y.ArchivableTable[W]=W.Archivable W.Archivable=false as(W,y.
SurfaceTypeTable)local X,Y=0.5,0.5 delay(0,function()wait(X)local ay=tick()local
az=ay while(az-ay)<Y and W and W:IsA'BasePart'and W.Transparency>av do local aA=
1-(((az-ay)/Y)*(aw-av))if y['TransparencyTable']and y.TransparencyTable[W]then W
.Transparency=aA+(1-aA)*y.TransparencyTable[W]end wait(0.03)az=tick()end if W
and W:IsA'BasePart'then if y['TransparencyTable']and y.TransparencyTable[W]then
W.Transparency=av+(1-av)*y.TransparencyTable[W]end end end)end for ay,az in
pairs(S)do y.DecalTransparencyTable[az]=az.Transparency az.Transparency=av+(1-av
)*az.Transparency end j(ax,true)j(ax,false)y.CurrentParts=ax if k(ax)then y.
CurrentParts:ResetOrientationToIdentity()x=0 else local aA=x*math.pi/2 if y.
CurrentParts:IsA'Model'or y.CurrentParts:IsA'Tool'then f(y.CurrentParts,aA)else
y.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,aA,0)*y.CurrentParts.CFrame
end end local aA=y.CurrentParts:FindFirstChild('ClusterMaterial',true)if aA and
aA:IsA'Vector3Value'then aA.Value=Vector3.new(aA.Value.X,aA.Value.Y,(aA.Value.Z+
x)%4)end local X,Y=v(ae,y)if X then y.CurrentParts=m(Y,y.CurrentParts)end game.
JointsService:SetJoinAfterMoveInstance(y.CurrentParts)return ax,R end local au
au=function(av,aw)local ax=game.Workspace.Terrain.CellCenterToWorld local ay=ax(
game.Workspace.Terrain,av.X,av.Y,av.Z)local az,aA=game.Workspace:
FindPartsInRegion3(Region3.new(ay-Vector3.new(2,2,2)+d,ay+Vector3.new(2,2,2)-d),
y.CurrentParts,100),false for Q=1,#az do if t(az[Q])then aA=true break end end
if not aA then local Q={}for R=1,#az do if az[R].Parent and not Q[az[R].Parent]
and az[R].Parent:FindFirstChild(az[R].Parent:FindFirstChild'Humanoid':IsA
'Humanoid')then local S=az[R].Parent:FindFirstChild'Torso'Q[az[R].Parent]=true
if S then local U=ay.Y+5 if u(S,U,y)then S.CFrame=S.CFrame+Vector3.new(0,U-S.
CFrame.p.Y,0)else aA=true break end end end end end if not aA then local Q=true
if aw then if aj then av=ax(game.Workspace.Terrain,av.X,av.Y,av.Z)if(av.X+2>aj.
CFrame.p.X+aj.Size.X/2)or(av.X-2<aj.CFrame.p.X-aj.Size.X/2)or(av.Y+2>aj.CFrame.p
.Y+aj.Size.Y/2)or(av.Y-2<aj.CFrame.p.Y-aj.Size.Y/2)or(av.Z+2>aj.CFrame.p.Z+aj.
Size.Z/2)or(av.Z-2<aj.CFrame.p.Z-aj.Size.Z/2)then Q=false end end end return Q
end return false end local av av=function(aw)local ax,ay,az,aA,Q,R,S,U,W=false,
game.Workspace.Terrain,D.InternalLine,game.Workspace.Terrain.MaxExtents.Max,game
.Workspace.Terrain.MaxExtents.Min,1,0,0,false if y.CurrentParts:FindFirstChild
'AutoWedge'then W=true end if y.CurrentParts:FindFirstChild('ClusterMaterial',
true)then R=y.CurrentParts:FindFirstChild('ClusterMaterial',true)if R:IsA
'Vector3Value'then S=R.Value.Y U=R.Value.Z R=R.Value.X elseif R:IsA'IntValue'
then R=R.Value end end if D.Adorn.Parent and D.Start and((D.Dimensions>1)or(az
and az.magnitude>0))then local X,Y,aB,aC,aD,aE,aF,aG=game.Workspace.Terrain:
WorldToCell(D.Start),{0,0,0},{0,0,0},{0,0,0},{nil,nil,nil},{Vector3.new(0,0,0),
Vector3.new(0,0,0),Vector3.new(0,0,0)},{Vector3.new(1,0,0),Vector3.new(0,1,0),
Vector3.new(0,0,1)},{}if D.Dimensions>1 then table.insert(aG,D.MoreLines[1])end
if az and az.magnitude>0 then table.insert(aG,az)end if D.Dimensions>2 then
table.insert(aG,D.MoreLines[2])end for aH=1,#aG do aG[aH]=Vector3.new(math.
floor(aG[aH].X+0.5),math.floor(aG[aH].Y+0.5),math.floor(aG[aH].Z+0.5))if aG[aH].
X>0 then Y[aH]=1 elseif aG[aH].X<0 then Y[aH]=-1 end if aG[aH].Y>0 then aB[aH]=1
elseif aG[aH].Y<0 then aB[aH]=-1 end if aG[aH].Z>0 then aC[aH]=1 elseif aG[aH].Z
<0 then aC[aH]=-1 end aD[aH]=Vector3.new(Y[aH],aB[aH],aC[aH])if aD[aH].magnitude
<0.9 then aD[aH]=nil end end if not aG[2]then aG[2]=Vector3.new(0,0,0)end if not
aG[3]then aG[3]=Vector3.new(0,0,0)end local aH,aI=y.CurrentParts:FindFirstChild(
'WaterForceTag',true),y.CurrentParts:FindFirstChild('WaterForceDirectionTag',
true)while aE[3].magnitude*4<=aG[3].magnitude do local aJ=1 while aJ<4 do aE[2]=
Vector3.new(0,0,0)while aE[2].magnitude*4<=aG[2].magnitude do local aK=1 while
aK<4 do aE[1]=Vector3.new(0,0,0)while aE[1].magnitude*4<=aG[1].magnitude do
local aL=aE[1]+aE[2]+aE[3]local aM=Vector3int16.new(X.X+aL.X,X.Y+aL.Y,X.Z+aL.Z)
if aM.X>=Q.X and aM.Y>=Q.Y and aM.Z>=Q.Z and aM.X<aA.X and aM.Y<aA.Y and aM.Z<aA
.Z then local aN=au(aM,aw)if aN then if aH then ay:SetWaterCell(aM.X,aM.Y,aM.Z,
Enum.WaterForce[aH.Value],Enum.WaterDirection[aI.Value])else ay:SetCell(aM.X,aM.
Y,aM.Z,R,S,U)end ax=true if W then game.Workspace.Terrain:AutowedgeCells(
Region3int16.new(Vector3int16.new(aM.x-1,aM.y-1,aM.z-1),Vector3int16.new(aM.x+1,
aM.y+1,aM.z+1)))end end end aE[1]=aE[1]+aD[1]end if aD[2]then while aK<4 and aF[
aK]:Dot(aD[2])==0 do aK=aK+1 end if aK<4 then aE[2]=aE[2]+aF[aK]*aF[aK]:Dot(aD[2
])end aK=aK+1 else aE[2]=Vector3.new(1,0,0)aK=4 end if aE[2].magnitude*4>aG[2].
magnitude then aK=4 end end end if aD[3]then while aJ<4 and aF[aJ]:Dot(aD[3])==0
do aJ=aJ+1 end if aJ<4 then aE[3]=aE[3]+aF[aJ]*aF[aJ]:Dot(aD[3])end aJ=aJ+1 else
aE[3]=Vector3.new(1,0,0)aJ=4 end if aE[3].magnitude*4>aG[3].magnitude then aJ=4
end end end end D.Start=nil D.Adorn.Parent=nil if ax then y.CurrentParts.Parent=
nil pcall(function()return game:GetService'ChangeHistoryService':SetWaypoint
'StamperMulti'end)end return ax end local aw aw=function(ax)if not ax then error
'Error: RbxStamper.DoStamperMouseUp: Mouse is nil'return false end if not ax:IsA
'Mouse'then error('Error: RbxStamper.DoStamperMouseUp: Mouse is of type',ax.
className,'should be of type Mouse')return false end if not y.Dragger then error
[[Error: RbxStamper.DoStamperMouseUp: stampData.Dragger is nil]]return false end
if not D then return false end local ay if ai then local az,aA=nil,N()if aA and
D and D.Start and D.InternalLine and D.InternalLine.magnitude>0 then az=true ay=
true else az,ay=a.CanEditRegion(y.CurrentParts,aj)end if not az then if w then
w()end return false end end if H then ao()return false end local az az,ay=a.
CanEditRegion(y.CurrentParts,aj)if not az then if w then w()end return false end
local aA,aB=q(y.CurrentParts)local aC,aD=v(ax,y)if aC and not D.Adorn.Parent
then if h(aA+d,aB-d)then ao()return false end local aE=game.Workspace:
FindPartsInRegion3(Region3.new(aA+d,aB-d),y.CurrentParts,100)for aF=1,#aE do if
t(aE[aF])then ao()return false end end local aF={}for aG=1,#aE do if aE[aG].
Parent and not aF[aE[aG].Parent]and aE[aG].Parent:FindFirstChild'Humanoid'and aE
[aG].Parent:FindFirstChild'Humanoid':IsA'Humanoid'then local aH=aE[aG].Parent:
FindFirstChild'Torso'aF[aE[aG].Parent]=true if aH then local aI=aB.Y+3 if u(aH,
aI,y)then aH.CFrame=aH.CFrame+Vector3.new(0,aI-aH.CFrame.p.Y,0)else ao()return
false end end end end elseif(not aC)and not(D.Start and D.Adorn.Parent)then al()
return false end if game:FindFirstChild'Players'then if game.Players[
'LocalPlayer']then if game.Players.LocalPlayer['Character']then local aE=game.
Players.LocalPlayer.Character local aF=aE:FindFirstChild'StampTracker'if aF and
not aF.Value then aF.Value=true end end end end if D.Start and D.Adorn.Parent
and N()then if av(ay)or ay then y.CurrentParts.Parent=nil return true end end D.
Start=nil D.Adorn.Parent=nil local aE=game.Workspace.Terrain if N()then local aF
if y.CurrentParts:IsA'Model'then aF=aE:WorldToCell(y.CurrentParts:
GetModelCFrame().p)else aF=aE:WorldToCell(y.CurrentParts.CFrame.p)end local aG,
aH=game.Workspace.Terrain.MaxExtents.Max,game.Workspace.Terrain.MaxExtents.Min
if au(aF,false)then local aI,aJ,aK=y.CurrentParts:FindFirstChild(
'ClusterMaterial',true),y.CurrentParts:FindFirstChild('WaterForceTag',true),y.
CurrentParts:FindFirstChild('WaterForceDirectionTag',true)if aF.X>=aH.X and aF.Y
>=aH.Y and aF.Z>=aH.Z and aF.X<aG.X and aF.Y<aG.Y and aF.Z<aG.Z then if aJ then
aE:SetWaterCell(aF.X,aF.Y,aF.Z,Enum.WaterForce[aJ.Value],Enum.WaterDirection[aK.
Value])elseif not aI then aE:SetCell(aF.X,aF.Y,aF.Z,M.Material,M.clusterType,x%4
)elseif aI:IsA'Vector3Value'then aE:SetCell(aF.X,aF.Y,aF.Z,aI.Value.X,aI.Value.Y
,aI.Value.Z)else aE:SetCell(aF.X,aF.Y,aF.Z,aI.Value,0,0)end local aL=false if y.
CurrentParts:FindFirstChild'AutoWedge'then aL=true end if aL then game.Workspace
.Terrain:AutowedgeCells(Region3int16.new(Vector3int16.new(aF.x-1,aF.y-1,aF.z-1),
Vector3int16.new(aF.x+1,aF.y+1,aF.z+1)))end y.CurrentParts.Parent=nil pcall(
function()return game:GetService'ChangeHistoryService':SetWaypoint
'StamperSingle'end)return true end else ao()return false end end local aF aF=
function()if game:FindFirstChild'Players'then if game.Players['LocalPlayer']then
return game.Players.LocalPlayer end end return nil end if y.CurrentParts:IsA
'Model'or y.CurrentParts:IsA'Tool'then if y.CurrentParts:IsA'Model'then local aG
,aH={},{}ab(y.CurrentParts,aG,aH)y.CurrentParts:BreakJoints()y.CurrentParts:
MakeJoints()ac(aG,aH)end local aG,aH=y.CurrentParts:FindFirstChild'PlayerIdTag',
y.CurrentParts:FindFirstChild'PlayerNameTag'if(aG~=nil)then local aI=aF()if(aI~=
nil)then aG.Value=aI.userId end end if(aH~=nil)then if game:FindFirstChild(game.
Players['LocalPlayer'])then local aI=game.Players.LocalPlayer if(aI~=nil)then aH
.Value=aI.Name end end end if not(y.CurrentParts:FindFirstChild'RobloxModel'~=
nil)then local aI=Instance.new'BoolValue'aI.Name='RobloxModel'aI.Parent=y.
CurrentParts if not(y.CurrentParts:FindFirstChild'RobloxStamper'~=nil)then local
aJ=Instance.new'BoolValue'aJ.Name='RobloxStamper'aJ.Parent=y.CurrentParts end
end else y.CurrentParts:BreakJoints()if not(y.CurrentParts:FindFirstChild
'RobloxStamper'~=nil)then local aG=Instance.new'BoolValue'aG.Name=
'RobloxStamper'aG.Parent=y.CurrentParts end end if not createJoints then game.
JointsService:CreateJoinAfterMoveJoints()end for aG,aH in pairs(y.
TransparencyTable)do aG.Transparency=aH end for aI,aJ in pairs(y.ArchivableTable
)do aI.Archivable=aJ end for aK,aL in pairs(y.MaterialTable)do aK.Material=aL
end for aM,aN in pairs(y.CanCollideTable)do aM.CanCollide=aN end for Q,R in
pairs(y.AnchoredTable)do Q.Anchored=R end for S,U in pairs(y.
DecalTransparencyTable)do S.Transparency=U end for W,X in pairs(y.
SurfaceTypeTable)do aq(W,X)end if N()then y.CurrentParts.Transparency=0 end j(y.
CurrentParts,true)y.TransparencyTable=nil y.ArchivableTable=nil y.MaterialTable=
nil y.CanCollideTable=nil y.AnchoredTable=nil y.SurfaceTypeTable=nil if not(y.
CurrentParts:FindFirstChild'RobloxModel'~=nil)then local Y=Instance.new
'BoolValue'Y.Name='RobloxModel'Y.Parent=y.CurrentParts end if ghostRemovalScript
then ghostRemovalScript.Parent=nil end for Y,aO in pairs(y.DisabledScripts)do aO
.Disabled=false end for aP,aQ in pairs(y.DisabledScripts)do local aR=aQ.Parent
aQ.Parent=nil aQ:Clone().Parent=aR end y.DisabledScripts=nil y.Dragger=nil y.
CurrentParts=nil pcall(function()return game:GetService'ChangeHistoryService':
SetWaypoint'StampedObject'end)return true end local ax ax=function()for ay=1,#I
do I[ay]:disconnect()I[ay]=nil end I={}if y and y.CurrentParts then y.
CurrentParts.Parent=nil y.CurrentParts:Remove()end al()return game.JointsService
:ClearJoinAfterMoveJoints()end local ay ay=function(az,aA,aB)local aC,aD={
Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)},1 if aB<0 then aD=aD*(
-1)aB=aB*(-1)end local aE=aD*az:vectorToWorldSpace(aC[aB])for aF=1,#aA do local
aJ=aA[aF]local aL=aJ.CFrame:vectorToObjectSpace(aE)if math.abs(aL.X)>math.abs(aL
.Y)then if math.abs(aL.X)>math.abs(aL.Z)then if aL.X>0 then aJ.RightSurface=
'Unjoinable'else aJ.LeftSurface='Unjoinable'end else if aL.Z>0 then aJ.
BackSurface='Unjoinable'else aJ.FrontSurface='Unjoinable'end end else if math.
abs(aL.Y)>math.abs(aL.Z)then if aL.Y>0 then aJ.TopSurface='Unjoinable'else aJ.
BottomSurface='Unjoinable'end else if aL.Z>0 then aJ.BackSurface='Unjoinable'
else aJ.FrontSurface='Unjoinable'end end end end end local az az=function()local
aA,aB=at(ad)if not aA or not aB then return end local aC=aA:FindFirstChild(
'UnjoinableFaces',true)if aC then for aD in string.gmatch(aC.Value,'[^,]*')do if
tonumber(aD)then if aA:IsA'Model'then ay(aA:GetModelCFrame(),aB,tonumber(aD))
else ay(aA.CFrame,aB,tonumber(aD))end end end end y.ErrorBox=A if ai then aA.
Parent=ai else aA.Parent=game.Workspace end if aA:FindFirstChild(
'ClusterMaterial',true)then local aD=aA:FindFirstChild('ClusterMaterial',true)if
aD:IsA'Vector3Value'then M.Material=aD.Value.X M.clusterType=aD.Value.Y M.
clusterOrientation=aD.Value.Z elseif aD:IsA'IntValue'then M.Material=aD.Value
end end pcall(function()z=ae.Target end)if z and not(z.Parent:FindFirstChild
'RobloxModel'~=nil)then game.JointsService:SetJoinAfterMoveTarget(z)else game.
JointsService:SetJoinAfterMoveTarget(nil)end game.JointsService:
ShowPermissibleJoints()for aD,aE in pairs(y.DisabledScripts)do if aE.Name==
'GhostRemovalScript'then aE.Parent=y.CurrentParts end end y.Dragger=Instance.new
'Dragger'y.Dragger:MouseDown(aB[1],Vector3.new(0,0,0,aB))y.Dragger:MouseUp()P(ae
)table.insert(I,ae.Move:connect(function()if F or G then return end F=true P(ae)
F=false end))table.insert(I,ae.Button1Down:connect(function()return ap(ae)end))
table.insert(I,ae.Button1Up:connect(function()G=true while F do wait()end K.
Value=aw(ae)al()G=false end))K.Value=false end local aA aA=function(aB)if aB
then if not aB:IsA'Model'and not aB:IsA'BasePart'then error
[[resetStamperState: newModelToStamp (first arg) is not nil, but not a model or part!]]
end ad=aB end ax()return az()end aA()E.Stamped=K E.Paused=false E.LoadNewModel=
function(aB)if aB and not aB:IsA'Model'and not aB:IsA'BasePart'then error
[[Control.LoadNewModel: newStampModel (first arg) is not a Model or Part!]]
return nil end return aA(aB)end E.ReloadModel=function()return aA()end E.Pause=
function()if not E.Paused then ax()E.Paused=true else return print
[[RbxStamper Warning: Tried to call Control.Pause! when already paused]]end end
E.Resume=function()if E.Paused then az()E.Paused=false else return print
[[RbxStamper Warning: Tried to call Control.Resume! without Pausing First]]end
end E.ResetRotation=function()end E.Destroy=function()for aB=1,#I do I[aB]:
disconnect()I[aB]=nil end if J~=nil then J:disconnect()end game.JointsService:
ClearJoinAfterMoveJoints()if C~=nil then C:Destroy()end if B~=nil then B:
Destroy()end if A~=nil then A:Destroy()end if y~=nil then do local aB=y.Dragger
if aB~=nil then aB:Destroy()end end end if y~=nil then do local aB=y.
CurrentParts if aB~=nil then aB:Destroy()end end end if E and E['Stamped']then E
.Stamped:Destroy()end E=nil end return E end a.Help=function(ad)if
'GetStampModel'==ad or a.GetStampModel==ad then return
[[Function GetStampModel. Arguments: assetId, useAssetVersionId. assetId is the asset to load in, define useAssetVersionId as true if assetId is a version id instead of a relative assetId. Side effect: returns a model of the assetId, or a string with error message if something fails]]
elseif'SetupStamperDragger'==ad or a.SetupStamperDragger==ad then return
[[Function SetupStamperDragger. Side Effect: Creates 4x4 stamping mechanism for building out parts quickly. Arguments: ModelToStamp, Mouse, LegalStampCheckFunction. ModelToStamp should be a Model or Part, preferrably loaded from RbxStamper.GetStampModel and should have extents that are multiples of 4. Mouse should be a mouse object (obtained from things such as Tool.OnEquipped), used to drag parts around 'stamp' them out. LegalStampCheckFunction is optional, used as a callback with a table argument (table is full of instances about to be stamped). Function should return either true or false, false stopping the stamp action.]]
end end return a