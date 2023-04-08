local a={}function waitForChild(b,c)while not b:FindFirstChild(c)do b.ChildAdded
:wait()end end function PlaneIntersection(b)local c,d=false,game.Workspace.
CurrentCamera local e,f,g,h=Vector3.new(d.CoordinateFrame.p.X,d.CoordinateFrame.
p.Y,d.CoordinateFrame.p.Z),Vector3.new(b.X,b.Y,b.Z),Vector3.new(0,1,0),Vector3.
new(0,0,0)local i,j=g:Dot(f-e),b if i~=0 then local k=g:Dot(h-e)/i if k>=0 and k
<=1 then local l=((f-e)*k)+e j=game.Workspace.Terrain:WorldToCell(l)c=true end
end return j,c end function GetTerrainForMouse(b)local c,d=game.Workspace.
Terrain:WorldToCellPreferSolid(Vector3.new(b.hit.x,b.hit.y,b.hit.z)),nil if 0==
game.Workspace.Terrain:GetCell(c.X,c.Y,c.Z).Value then c=nil d,hit=
PlaneIntersection(Vector3.new(b.hit.x,b.hit.y,b.hit.z))if hit then c=d end end
return c end local b=Vector3.new(0.3,0.3,0.3)local function
rotatePartAndChildren(c,d,e)if c:IsA'BasePart'then c.CFrame=(d*(c.CFrame-e))+e
end local f=c:GetChildren()for g=1,#f do rotatePartAndChildren(f[g],d,e)end end
local function modelRotate(c,d)local e,f=CFrame.Angles(0,d,0),c:GetModelCFrame()
.p rotatePartAndChildren(c,e,f)end local function collectParts(c,d,e,f)if c:IsA
'BasePart'then d[#d+1]=c elseif c:IsA'Script'then e[#e+1]=c elseif c:IsA'Decal'
then f[#f+1]=c end for g,h in pairs(c:GetChildren())do collectParts(h,d,e,f)end
end local function clusterPartsInRegion(c,d)local e=game.Workspace:
FindFirstChild'Terrain'local f,g=e:WorldToCell(c),e:WorldToCell(d)local h,i,j,k,
l,m=f.X,f.Y,f.Z,g.X,g.Y,g.Z if h<e.MaxExtents.Min.X then h=e.MaxExtents.Min.X
end if i<e.MaxExtents.Min.Y then i=e.MaxExtents.Min.Y end if j<e.MaxExtents.Min.
Z then j=e.MaxExtents.Min.Z end if k>e.MaxExtents.Max.X then k=e.MaxExtents.Max.
X end if l>e.MaxExtents.Max.Y then l=e.MaxExtents.Max.Y end if m>e.MaxExtents.
Max.Z then m=e.MaxExtents.Max.Z end for n=h,k do for o=i,l do for p=j,m do if e:
GetCell(n,o,p).Value>0 then return true end end end end return false end
local function findSeatsInModel(c,d)if not c then return end if c.className==
'Seat'or c.className=='VehicleSeat'then table.insert(d,c)end local e=c:
GetChildren()for f=1,#e do findSeatsInModel(e[f],d)end end local function
setSeatEnabledStatus(c,d)local e={}findSeatsInModel(c,e)if d then for f=1,#e do
local g=e[f]:FindFirstChild'SeatWeld'while g do g:Remove()g=e[f]:FindFirstChild
'SeatWeld'end end else for f=1,#e do local g=Instance.new'Weld'g.Name='SeatWeld'
g.Parent=e[f]end end end local function autoAlignToFace(c)local d=c:
FindFirstChild'AutoAlignToFace'if d then return d.Value else return false end
end local function getClosestAlignedWorldDirection(c)local d,e,f=Vector3.new(1,0
,0),Vector3.new(0,1,0),Vector3.new(0,0,1)local g,h,i=c.x*d.x+c.y*d.y+c.z*d.z,c.x
*e.x+c.y*e.y+c.z*e.z,c.x*f.x+c.y*f.y+c.z*f.z if math.abs(g)>math.abs(h)and math.
abs(g)>math.abs(i)then if g>0 then return 0 else return 3 end elseif math.abs(h)
>math.abs(g)and math.abs(h)>math.abs(i)then if h>0 then return 1 else return 4
end else if i>0 then return 2 else return 5 end end end local function
positionPartsAtCFrame3(c,d)local e=nil if not d then return d end if d and(d:IsA
'Model'or d:IsA'Tool')then e=d:GetModelCFrame()d:TranslateBy(c.p-e.p)else d.
CFrame=c end return d end local function calcRayHitTime(c,d,e)if math.abs(d)<
0.01 then return 0 end return(e-c)/d end local function modelTargetSurface(c,d,e
)if not c then return 0 end local f,g=nil,nil if c:IsA'Model'then f=c:
GetModelCFrame()g=c:GetModelSize()else f=c.CFrame g=c.Size end local h,i=f:
pointToObjectSpace(d),f:pointToObjectSpace(e)local j,k,l,m=i-h,1,1,1 if j.X>0
then k=-1 end if j.Y>0 then l=-1 end if j.Z>0 then m=-1 end local n,o,p,q=
calcRayHitTime(h.X,j.X,g.X/2*k),calcRayHitTime(h.Y,j.Y,g.Y/2*l),calcRayHitTime(h
.Z,j.Z,g.Z/2*m),0 if n>o then if n>p then q=1*k else q=3*m end else if o>p then
q=2*l else q=3*m end end return q end local function getBoundingBox2(c)local d,e
=Vector3.new(math.huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-
math.huge)if c:IsA'Terrain'then d=Vector3.new(-2,-2,-2)e=Vector3.new(2,2,2)
elseif c:IsA'BasePart'then d=-0.5*c.Size e=-d else e=c:GetModelSize()*0.5 d=-e
end local f=c:FindFirstChild'Justification'if f~=nil then justify=f.Value two=
Vector3.new(2,2,2)actualBox=e-d-Vector3.new(0.01,0.01,0.01)containingGridBox=
Vector3.new(4*math.ceil(actualBox.x/4),4*math.ceil(actualBox.y/4),4*math.ceil(
actualBox.z/4))adjustment=containingGridBox-actualBox d=d-0.5*adjustment*justify
e=e+0.5*adjustment*(two-justify)end return d,e end local function
getBoundingBoxInWorldCoordinates(c)local d,e=Vector3.new(math.huge,math.huge,
math.huge),Vector3.new(-math.huge,-math.huge,-math.huge)if c:IsA'BasePart'and
not c:IsA'Terrain'then vec1=c.CFrame:pointToWorldSpace(-0.5*c.Size)vec2=c.CFrame
:pointToWorldSpace(0.5*c.Size)d=Vector3.new(math.min(vec1.X,vec2.X),math.min(
vec1.Y,vec2.Y),math.min(vec1.Z,vec2.Z))e=Vector3.new(math.max(vec1.X,vec2.X),
math.max(vec1.Y,vec2.Y),math.max(vec1.Z,vec2.Z))elseif c:IsA'Terrain'then else
vec1=c:GetModelCFrame():pointToWorldSpace(-0.5*c:GetModelSize())vec2=c:
GetModelCFrame():pointToWorldSpace(0.5*c:GetModelSize())d=Vector3.new(math.min(
vec1.X,vec2.X),math.min(vec1.Y,vec2.Y),math.min(vec1.Z,vec2.Z))e=Vector3.new(
math.max(vec1.X,vec2.X),math.max(vec1.Y,vec2.Y),math.max(vec1.Z,vec2.Z))end
return d,e end local function getTargetPartBoundingBox(c)if c.Parent:
FindFirstChild'RobloxModel'~=nil then return getBoundingBox2(c.Parent)else
return getBoundingBox2(c)end end local function getMouseTargetCFrame(c)if c.
Parent:FindFirstChild'RobloxModel'~=nil then if c.Parent:IsA'Tool'then return c.
Parent.Handle.CFrame else return c.Parent:GetModelCFrame()end else return c.
CFrame end end local function isBlocker(c)if not c then return false end if not
c.Parent then return false end if c:FindFirstChild'Humanoid'then return false
end if c:FindFirstChild'RobloxStamper'or c:FindFirstChild'RobloxModel'then
return true end if c:IsA'Part'and not c.CanCollide then return false end if c==
game.Lighting then return false end return isBlocker(c.Parent)end local function
spaceAboveCharacter(c,d,e)local f=game.Workspace:FindPartsInRegion3(Region3.new(
Vector3.new(c.Position.X,d,c.Position.Z)-Vector3.new(0.75,2.75,0.75),Vector3.
new(c.Position.X,d,c.Position.Z)+Vector3.new(0.75,1.75,0.75)),c.Parent,100)for g
=1,#f do if f[g].CanCollide and not f[g]:IsDescendantOf(e.CurrentParts)then
return false end end if clusterPartsInRegion(Vector3.new(c.Position.X,d,c.
Position.Z)-Vector3.new(0.75,2.75,0.75),Vector3.new(c.Position.X,d,c.Position.Z)
+Vector3.new(0.75,1.75,0.75))then return false end return true end
local function findConfigAtMouseTarget(c,d)if not c then return nil end if not d
then error'findConfigAtMouseTarget: stampData is nil'return nil end if not d[
'CurrentParts']then return nil end local e,f,g,h,i=4,false,CFrame.new(0,0,0),
getBoundingBox2(d.CurrentParts)local j,k=i-h,nil if d.CurrentParts:IsA'Model'or
d.CurrentParts:IsA'Tool'then k=d.CurrentParts:GetModelCFrame()else k=d.
CurrentParts.CFrame end if c then if d.CurrentParts:IsA'Tool'then c.TargetFilter
=d.CurrentParts.Handle else c.TargetFilter=d.CurrentParts end end local l,m=
false,nil local n=pcall(function()m=c.Target end)if not n then return f,g end
local o=Vector3.new(0,0,0)if c then o=Vector3.new(c.Hit.x,c.Hit.y,c.Hit.z)end
local p=nil if nil==m then p=GetTerrainForMouse(c)if nil==p then l=false return
f,g else m=game.Workspace.Terrain l=true p=Vector3.new(p.X-1,p.Y,p.Z)o=game.
Workspace.Terrain:CellCenterToWorld(p.x,p.y,p.z)end end local q,r=
getTargetPartBoundingBox(m)local s,t=r-q,getMouseTargetCFrame(m)if m:IsA
'Terrain'then if not cluster then cluster=game.Workspace:FindFirstChild'Terrain'
end local u=cluster:WorldToCellPreferSolid(o)if l then u=p end t=CFrame.new(game
.Workspace.Terrain:CellCenterToWorld(u.x,u.y,u.z))end local u,v=t:
pointToObjectSpace(o),Vector3.new(0,0,0)if c then v=m.CFrame:vectorToWorldSpace(
Vector3.FromNormalId(c.TargetSurface))end local w,x if
getClosestAlignedWorldDirection(v)==0 then w=t:vectorToObjectSpace(Vector3.new(1
,-1,1))insertRefPointInInsert=k:vectorToObjectSpace(Vector3.new(-1,-1,1))x=
Vector3.new(0,1,1)elseif getClosestAlignedWorldDirection(v)==3 then w=t:
vectorToObjectSpace(Vector3.new(-1,-1,-1))insertRefPointInInsert=k:
vectorToObjectSpace(Vector3.new(1,-1,-1))x=Vector3.new(0,1,1)elseif
getClosestAlignedWorldDirection(v)==1 then w=t:vectorToObjectSpace(Vector3.new(-
1,1,1))insertRefPointInInsert=k:vectorToObjectSpace(Vector3.new(-1,-1,1))x=
Vector3.new(1,0,1)elseif getClosestAlignedWorldDirection(v)==4 then w=t:
vectorToObjectSpace(Vector3.new(-1,-1,1))insertRefPointInInsert=k:
vectorToObjectSpace(Vector3.new(-1,1,1))x=Vector3.new(1,0,1)elseif
getClosestAlignedWorldDirection(v)==2 then w=t:vectorToObjectSpace(Vector3.new(-
1,-1,1))insertRefPointInInsert=k:vectorToObjectSpace(Vector3.new(-1,-1,-1))x=
Vector3.new(1,1,0)else w=t:vectorToObjectSpace(Vector3.new(1,-1,-1))
insertRefPointInInsert=k:vectorToObjectSpace(Vector3.new(1,-1,1))x=Vector3.new(1
,1,0)end w=w*(0.5*s)+0.5*(r+q)insertRefPointInInsert=insertRefPointInInsert*(0.5
*j)+0.5*(i+h)local y=u-w local z=Vector3.new(e*math.modf(y.x/e),e*math.modf(y.y/
e),e*math.modf(y.z/e))z=z*x local A=z+w local B,C=t:pointToWorldSpace(A),k:
vectorToWorldSpace(insertRefPointInInsert)local D,E,F,G,H,I,J,K,L,M,N,O,P=B-C,k:
components()g=CFrame.new(D.x,D.y,D.z,H,I,J,K,L,M,N,O,P)f=true return f,g,
getClosestAlignedWorldDirection(v)end local function truncateToCircleEighth(c,d)
local e,f=math.abs(c),math.abs(d)local g=math.sqrt(e*e+f*f)local h,i,j=f/g,1,1
if c<0 then i=-1 end if d<0 then j=-1 end if h>0.382683432 then return
0.707106781*g*i,0.707106781*g*j else return g*i,0 end end local function
saveTheWelds(c,d,e)if c:IsA'ManualWeld'or c:IsA'Rotate'then table.insert(d,c)
table.insert(e,c.Parent)else local f=c:GetChildren()for g=1,#f do saveTheWelds(f
[g],d,e)end end end local function restoreTheWelds(c,d)for e=1,#c do c[e].Parent
=d[e]end end a.CanEditRegion=function(c,d)if not d then return true,false end
local e,f=getBoundingBoxInWorldCoordinates(c)if e.X<d.CFrame.p.X-d.Size.X/2 or e
.Y<d.CFrame.p.Y-d.Size.Y/2 or e.Z<d.CFrame.p.Z-d.Size.Z/2 then return false,
false end if f.X>d.CFrame.p.X+d.Size.X/2 or f.Y>d.CFrame.p.Y+d.Size.Y/2 or f.Z>d
.CFrame.p.Z+d.Size.Z/2 then return false,false end return true,false end a.
GetStampModel=function(c,d,e)if c==0 then return nil,'No Asset'end if c<0 then
return nil,'Negative Asset'end local function UnlockInstances(f)if f:IsA
'BasePart'then f.Locked=false end for g,h in pairs(f:GetChildren())do
UnlockInstances(h)end end local function getClosestColorToTerrainMaterial(f)if f
==1 then return BrickColor.new'Bright green'elseif f==2 then return BrickColor.
new'Bright yellow'elseif f==3 then return BrickColor.new'Bright red'elseif f==4
then return BrickColor.new'Sand red'elseif f==5 then return BrickColor.new
'Black'elseif f==6 then return BrickColor.new'Dark stone grey'elseif f==7 then
return BrickColor.new'Sand blue'elseif f==8 then return BrickColor.new
'Deep orange'elseif f==9 then return BrickColor.new'Dark orange'elseif f==10
then return BrickColor.new'Reddish brown'elseif f==11 then return BrickColor.new
'Light orange'elseif f==12 then return BrickColor.new'Light stone grey'elseif f
==13 then return BrickColor.new'Sand green'elseif f==14 then return BrickColor.
new'Medium stone grey'elseif f==15 then return BrickColor.new'Really red'elseif
f==16 then return BrickColor.new'Really blue'elseif f==17 then return BrickColor
.new'Bright blue'else return BrickColor.new'Bright green'end end local function
setupFakeTerrainPart(f,g,h)local i=nil if g==1 or g==4 then i=Instance.new
'WedgePart'i.formFactor='Custom'elseif g==2 then i=Instance.new'CornerWedgePart'
else i=Instance.new'Part'i.formFactor='Custom'end i.Name='MegaClusterCube'i.Size
=Vector3.new(4,4,4)i.BottomSurface='Smooth'i.TopSurface='Smooth'i.BrickColor=
getClosestColorToTerrainMaterial(f)local j,k=0,math.pi if g==4 then j=-math.pi/2
end if g==2 or g==3 then k=0 end i.CFrame=CFrame.Angles(0,math.pi/2*h+k,j)if g==
3 then local l=Instance.new'SpecialMesh'l.MeshType='FileMesh'l.MeshId=
'http://www.roblox.com/asset?id=66832495'l.Scale=Vector3.new(2,2,2)l.Parent=i
end local l=Instance.new'Vector3Value'l.Value=Vector3.new(f,g,h)l.Name=
'ClusterMaterial'l.Parent=i return i end local f,g loading=true if e then g=
coroutine.create(function()f=game:GetService'InsertService':LoadAssetVersion(c)
loading=false end)coroutine.resume(g)else g=coroutine.create(function()f=game:
GetService'InsertService':LoadAsset(c)loading=false end)coroutine.resume(g)end
local h,i,j=0,0,8 while loading and i<j do h=tick()wait(1)i=i+tick()-h end
loading=false if i>=j then return nil,'Load Time Fail'end if f==nil then return
nil,'Load Asset Fail'end if not f:IsA'Model'then return nil,'Load Type Fail'end
local k=f:GetChildren()if#k==0 then return nil,'Empty Model Fail'end
UnlockInstances(f)f=f:GetChildren()[1]for l,m in pairs(k)do if m:IsA'Team'then m
.Parent=game:GetService'Teams'elseif m:IsA'Sky'then local n=game:GetService
'Lighting'for o,p in pairs(n:GetChildren())do if p:IsA'Sky'then p:Remove()end
end m.Parent=n return end end if f:FindFirstChild'RobloxModel'==nil then local n
=Instance.new'BoolValue'n.Name='RobloxModel'n.Parent=f if f:FindFirstChild
'RobloxStamper'==nil then local o=Instance.new'BoolValue'o.Name='RobloxStamper'o
.Parent=f end end if d then if f.Name=='MegaClusterCube'then if d==6 then local
n=Instance.new'BoolValue'n.Name='AutoWedge'n.Parent=f else local n=f:
FindFirstChild'ClusterMaterial'if n then if n:IsA'Vector3Value'then f=
setupFakeTerrainPart(n.Value.X,d,n.Value.Z)else f=setupFakeTerrainPart(n.Value,d
,0)end else f=setupFakeTerrainPart(1,d,0)end end end end return f end a.
SetupStamperDragger=function(c,d,e,f,g)if not c then error
[[SetupStamperDragger: modelToStamp (first arg) is nil!  Should be a stamper model]]
return nil end if not c:IsA'Model'and not c:IsA'BasePart'then error
[[SetupStamperDragger: modelToStamp (first arg) is neither a Model or Part!]]
return nil end if not d then error
[[SetupStamperDragger: Mouse (second arg) is nil!  Should be a mouse object]]
return nil end if not d:IsA'Mouse'then error
[[SetupStamperDragger: Mouse (second arg) is not of type Mouse!]]return nil end
local h,i,j=nil,nil,nil if e then if not e:IsA'Model'then error
[[SetupStamperDragger: StampInModel (optional third arg) is not of type 'Model']]
return nil end if not f then error
[[SetupStamperDragger: AllowedStampRegion (optional fourth arg) is nil when StampInModel (optional third arg) is defined]]
return nil end j=g h=e i=f end local k,l,m,n=0,nil,nil,Instance.new
'SelectionBox'n.Color=BrickColor.new'Bright red'n.Transparency=0 n.Archivable=
false local o=Instance.new'Part'o.Parent=nil o.formFactor='Custom'o.Size=Vector3
.new(4,4,4)o.CFrame=CFrame.new()o.Archivable=false local p=Instance.new
'SelectionBox'p.Color=BrickColor.new'Toothpaste'p.Adornee=o p.Visible=true p.
Transparency=0 p.Name='HighScalabilityStamperLine'p.Archivable=false local q={}q
.Start=nil q.End=nil q.Adorn=p q.AdornPart=o q.InternalLine=nil q.NewHint=true q
.MorePoints={nil,nil}q.MoreLines={nil,nil}q.Dimensions=1 local r,s,t,u,v,w,x={},
false,false,false,{},nil,Instance.new'BoolValue'x.Archivable=false x.Value=false
local y={}y.TerrainOrientation=0 y.CFrame=0 local z={}z.Material=1 z.clusterType
=0 z.clusterOrientation=0 local function isMegaClusterPart()if not l then return
false end if not l.CurrentParts then return false end return(l.CurrentParts:
FindFirstChild('ClusterMaterial',true)or(l.CurrentParts.Name=='MegaClusterCube')
)end local function DoHighScalabilityRegionSelect()local A=l.CurrentParts:
FindFirstChild'MegaClusterCube'if not A then if not l.CurrentParts.Name==
'MegaClusterCube'then return else A=l.CurrentParts end end q.End=A.CFrame.p
local B,C,D=nil,Vector3.new(0,0,0),Vector3.new(0,0,0)if q.Dimensions==1 then B=(
q.End-q.Start)if math.abs(B.X)<math.abs(B.Y)then if math.abs(B.X)<math.abs(B.Z)
then local E,F if math.abs(B.Y)>math.abs(B.Z)then E,F=truncateToCircleEighth(B.Y
,B.Z)else F,E=truncateToCircleEighth(B.Z,B.Y)end B=Vector3.new(0,E,F)else local
E,F=truncateToCircleEighth(B.Y,B.X)B=Vector3.new(F,E,0)end else if math.abs(B.Y)
<math.abs(B.Z)then local E,F if math.abs(B.X)>math.abs(B.Z)then E,F=
truncateToCircleEighth(B.X,B.Z)else F,E=truncateToCircleEighth(B.Z,B.X)end B=
Vector3.new(E,0,F)else local E,F=truncateToCircleEighth(B.X,B.Y)B=Vector3.new(E,
F,0)end end q.InternalLine=B elseif q.Dimensions==2 then B=q.MoreLines[1]C=q.End
-q.MorePoints[1]C=C-B.unit*B.unit:Dot(C)tempCFrame=CFrame.new(q.Start,q.Start+B)
local E,F=tempCFrame:vectorToWorldSpace(Vector3.new(0,1,0)),tempCFrame:
vectorToWorldSpace(Vector3.new(1,0,0))local G,H=F:Dot(C),E:Dot(C)if math.abs(H)>
math.abs(G)then C=C-F*G else C=C-E*H end q.InternalLine=C elseif q.Dimensions==3
then B=q.MoreLines[1]C=q.MoreLines[2]D=q.End-q.MorePoints[2]D=D-B.unit*B.unit:
Dot(D)D=D-C.unit*C.unit:Dot(D)q.InternalLine=D end tempCFrame=CFrame.new(q.Start
,q.Start+B)if q.Dimensions==1 then q.AdornPart.Size=Vector3.new(4,4,B.magnitude+
4)q.AdornPart.CFrame=tempCFrame+tempCFrame:vectorToWorldSpace(Vector3.new(2,2,2)
-q.AdornPart.Size/2)else local E=tempCFrame:vectorToObjectSpace(B+C+D)q.
AdornPart.Size=Vector3.new(4,4,4)+Vector3.new(math.abs(E.X),math.abs(E.Y),math.
abs(E.Z))q.AdornPart.CFrame=tempCFrame+tempCFrame:vectorToWorldSpace(E/2)end
local E=nil if game.Players['LocalPlayer']then E=game.Players.LocalPlayer:
FindFirstChild'PlayerGui'if E and E:IsA'PlayerGui'then if q.Dimensions==1 and B.
magnitude>3 then q.Adorn.Parent=E elseif q.Dimensions>1 then q.Adorn.Parent=E
end end end if E==nil then E=game:GetService'CoreGui'if q.Dimensions==1 and B.
magnitude>3 then q.Adorn.Parent=E elseif q.Dimensions>1 then q.Adorn.Parent=E
end end end local function DoStamperMouseMove(A)if not A then error
'Error: RbxStamper.DoStamperMouseMove: Mouse is nil'return end if not A:IsA
'Mouse'then error('Error: RbxStamper.DoStamperMouseMove: Mouse is of type',A.
className,'should be of type Mouse')return end if not A.Target then local B=
GetTerrainForMouse(A)if nil==B then return end end if not l then return end
configFound,targetCFrame,targetSurface=findConfigAtMouseTarget(A,l)if not
configFound then error'RbxStamper.DoStamperMouseMove No configFound, returning'
return end local B=0 if autoAlignToFace(l.CurrentParts)and targetSurface~=1 and
targetSurface~=4 then if targetSurface==3 then B=0-k+autoAlignToFace(l.
CurrentParts)elseif targetSurface==0 then B=2-k+autoAlignToFace(l.CurrentParts)
elseif targetSurface==5 then B=3-k+autoAlignToFace(l.CurrentParts)elseif
targetSurface==2 then B=1-k+autoAlignToFace(l.CurrentParts)end end local C=math.
pi/2 k=k+B if l.CurrentParts:IsA'Model'or l.CurrentParts:IsA'Tool'then
modelRotate(l.CurrentParts,C*B)else l.CurrentParts.CFrame=CFrame.
fromEulerAnglesXYZ(0,C*B,0)*l.CurrentParts.CFrame end local D,E=
getBoundingBoxInWorldCoordinates(l.CurrentParts)local F=nil if l.CurrentParts:
IsA'Model'then F=l.CurrentParts:GetModelCFrame()else F=l.CurrentParts.CFrame end
D=D+targetCFrame.p-F.p E=E+targetCFrame.p-F.p if clusterPartsInRegion(D+b,E-b)
then if y.CFrame then if l.CurrentParts:FindFirstChild('ClusterMaterial',true)
then local G=l.CurrentParts:FindFirstChild('ClusterMaterial',true)if G:IsA
'Vector3Value'then local H=l.CurrentParts:FindFirstChild('ClusterMaterial',true)
if H then H=clusterMat end end end end return end if isMegaClusterPart()then
local G=game.Workspace.Terrain:WorldToCell(targetCFrame.p)local H,I,J,K,L,M,N,O,
P,Q,R,S,T=game.Workspace.Terrain:CellCenterToWorld(G.X,G.Y,G.Z),targetCFrame:
components()targetCFrame=CFrame.new(H.X,H.Y,H.Z,L,M,N,O,P,Q,R,S,T)end
positionPartsAtCFrame3(targetCFrame,l.CurrentParts)y.CFrame=targetCFrame if l.
CurrentParts:FindFirstChild('ClusterMaterial',true)then local G=l.CurrentParts:
FindFirstChild('ClusterMaterial',true)if G:IsA'Vector3Value'then y.
TerrainOrientation=G.Value.Z end end if A and A.Target and A.Target.Parent then
local G=A.Target:FindFirstChild'RobloxModel'if not G then G=A.Target.Parent:
FindFirstChild'RobloxModel'end local H=l.CurrentParts:FindFirstChild
'UnstampableFaces'do local I,J='',''if G and G.Parent:FindFirstChild
'UnstampableFaces'then I=G.Parent.UnstampableFaces.Value end if H then J=H.Value
end local K=0 if G then K=modelTargetSurface(G.Parent,game.Workspace.
CurrentCamera.CoordinateFrame.p,A.Hit.p)end for L in string.gmatch(I,'[^,]+')do
if K==tonumber(L)then u=true game.JointsService:ClearJoinAfterMoveJoints()return
end end K=modelTargetSurface(l.CurrentParts,A.Hit.p,game.Workspace.CurrentCamera
.CoordinateFrame.p)for M in string.gmatch(J,'[^,]+')do if K==tonumber(M)then u=
true game.JointsService:ClearJoinAfterMoveJoints()return end end end end u=false
game.JointsService:SetJoinAfterMoveInstance(l.CurrentParts)if not pcall(function
()if A and A.Target and A.Target.Parent:FindFirstChild'RobloxModel'==nil then
return else return end end)then error
[[Error: RbxStamper.DoStamperMouseMove Mouse is nil on second check]]game.
JointsService:ClearJoinAfterMoveJoints()A=nil return end if A and A.Target and A
.Target.Parent:FindFirstChild'RobloxModel'==nil then game.JointsService:
SetJoinAfterMoveTarget(A.Target)else game.JointsService:SetJoinAfterMoveTarget(
nil)end game.JointsService:ShowPermissibleJoints()if isMegaClusterPart()and q
and q.Start then DoHighScalabilityRegionSelect()end end local function
setupKeyListener(A,B)if r and r['Paused']then return end A=string.lower(A)if A==
'r'and not autoAlignToFace(l.CurrentParts)then k=k+1 local C=l.CurrentParts:
FindFirstChild('ClusterMaterial',true)if C and C:IsA'Vector3Value'then C.Value=
Vector3.new(C.Value.X,C.Value.Y,(C.Value.Z+1)%4)end local D=math.pi/2 if l.
CurrentParts:IsA'Model'or l.CurrentParts:IsA'Tool'then modelRotate(l.
CurrentParts,D)else l.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,D,0)*l.
CurrentParts.CFrame end configFound,targetCFrame=findConfigAtMouseTarget(B,l)if
configFound then positionPartsAtCFrame3(targetCFrame,l.CurrentParts)
DoStamperMouseMove(B)end elseif A=='c'then if q.InternalLine and q.InternalLine.
magnitude>0 and q.Dimensions<3 then q.MorePoints[q.Dimensions]=q.End q.MoreLines
[q.Dimensions]=q.InternalLine q.Dimensions=q.Dimensions+1 q.NewHint=true end end
end w=d.KeyDown:connect(function(A)setupKeyListener(A,d)end)local function
resetHighScalabilityLine()if q then q.Start=nil q.End=nil q.InternalLine=nil q.
NewHint=true end end local function flashRedBox()local A=game.CoreGui if game:
FindFirstChild'Players'then if game.Players['LocalPlayer']then if game.Players.
LocalPlayer:FindFirstChild'PlayerGui'then A=game.Players.LocalPlayer.PlayerGui
end end end if not l['ErrorBox']then return end l.ErrorBox.Parent=A if l.
CurrentParts:IsA'Tool'then l.ErrorBox.Adornee=l.CurrentParts.Handle else l.
ErrorBox.Adornee=l.CurrentParts end delay(0,function()for B=1,3 do if l[
'ErrorBox']then l.ErrorBox.Visible=true end wait(0.13)if l['ErrorBox']then l.
ErrorBox.Visible=false end wait(0.13)end if l['ErrorBox']then l.ErrorBox.Adornee
=nil l.ErrorBox.Parent=Tool end end)end local function DoStamperMouseDown(A)if
not A then error'Error: RbxStamper.DoStamperMouseDown: Mouse is nil'return end
if not A:IsA'Mouse'then error(
'Error: RbxStamper.DoStamperMouseDown: Mouse is of type',A.className,
'should be of type Mouse')return end if not l then return end if
isMegaClusterPart()then if A and q then local B,C=l.CurrentParts:FindFirstChild(
'MegaClusterCube',true),game.Workspace.Terrain if B then q.Dimensions=1 local D=
C:WorldToCell(B.CFrame.p)q.Start=C:CellCenterToWorld(D.X,D.Y,D.Z)return else q.
Dimensions=1 local D=C:WorldToCell(l.CurrentParts.CFrame.p)q.Start=C:
CellCenterToWorld(D.X,D.Y,D.Z)return end end end end local function
loadSurfaceTypes(A,B)A.TopSurface=B[1]A.BottomSurface=B[2]A.LeftSurface=B[3]A.
RightSurface=B[4]A.FrontSurface=B[5]A.BackSurface=B[6]end local function
saveSurfaceTypes(A,B)local C={}C[1]=A.TopSurface C[2]=A.BottomSurface C[3]=A.
LeftSurface C[4]=A.RightSurface C[5]=A.FrontSurface C[6]=A.BackSurface B[A]=C
end local function makeSurfaceUnjoinable(A,B)end local function prepareModel(A)
if not A then return nil end local B,C,D,E,F,G=0.7,1,A:Clone(),{},{},{}l={}l.
DisabledScripts={}l.TransparencyTable={}l.MaterialTable={}l.CanCollideTable={}l.
AnchoredTable={}l.ArchivableTable={}l.DecalTransparencyTable={}l.
SurfaceTypeTable={}collectParts(D,F,E,G)if#F<=0 then return nil,
'no parts found in modelToStamp'end for H,I in pairs(E)do if not I.Disabled then
I.Disabled=true l.DisabledScripts[#l.DisabledScripts+1]=I end end for J,K in
pairs(F)do l.TransparencyTable[K]=K.Transparency K.Transparency=C+(1-C)*K.
Transparency l.MaterialTable[K]=K.Material K.Material=Enum.Material.Plastic l.
CanCollideTable[K]=K.CanCollide K.CanCollide=false l.AnchoredTable[K]=K.Anchored
K.Anchored=true l.ArchivableTable[K]=K.Archivable K.Archivable=false
saveSurfaceTypes(K,l.SurfaceTypeTable)local M,N=0.5,0.5 delay(0,function()wait(M
)local O=tick()local P=O while(P-O)<N and K and K:IsA'BasePart'and K.
Transparency>B do local Q=1-(((P-O)/N)*(C-B))if l['TransparencyTable']and l.
TransparencyTable[K]then K.Transparency=Q+(1-Q)*l.TransparencyTable[K]end wait(
0.03)P=tick()end if K and K:IsA'BasePart'then if l['TransparencyTable']and l.
TransparencyTable[K]then K.Transparency=B+(1-B)*l.TransparencyTable[K]end end
end)end for M,N in pairs(G)do l.DecalTransparencyTable[N]=N.Transparency N.
Transparency=B+(1-B)*N.Transparency end setSeatEnabledStatus(D,true)
setSeatEnabledStatus(D,false)l.CurrentParts=D if autoAlignToFace(D)then l.
CurrentParts:ResetOrientationToIdentity()k=0 else local O=k*math.pi/2 if l.
CurrentParts:IsA'Model'or l.CurrentParts:IsA'Tool'then modelRotate(l.
CurrentParts,O)else l.CurrentParts.CFrame=CFrame.fromEulerAnglesXYZ(0,O,0)*l.
CurrentParts.CFrame end end local O=l.CurrentParts:FindFirstChild(
'ClusterMaterial',true)if O and O:IsA'Vector3Value'then O.Value=Vector3.new(O.
Value.X,O.Value.Y,(O.Value.Z+k)%4)end local P,Q=findConfigAtMouseTarget(d,l)if P
then l.CurrentParts=positionPartsAtCFrame3(Q,l.CurrentParts)end game.
JointsService:SetJoinAfterMoveInstance(l.CurrentParts)return D,F end
local function checkTerrainBlockCollisions(A,B)local C=game.Workspace.Terrain.
CellCenterToWorld local D=C(game.Workspace.Terrain,A.X,A.Y,A.Z)local E,F=game.
Workspace:FindPartsInRegion3(Region3.new(D-Vector3.new(2,2,2)+b,D+Vector3.new(2,
2,2)-b),l.CurrentParts,100),false for G=1,#E do if isBlocker(E[G])then F=true
break end end if not F then local G={}for I=1,#E do if E[I].Parent and not G[E[I
].Parent]and E[I].Parent:FindFirstChild'Humanoid'and E[I].Parent:FindFirstChild
'Humanoid':IsA'Humanoid'then local K=E[I].Parent:FindFirstChild'Torso'G[E[I].
Parent]=true if K then local M=D.Y+5 if spaceAboveCharacter(K,M,l)then K.CFrame=
K.CFrame+Vector3.new(0,M-K.CFrame.p.Y,0)else F=true break end end end end end if
not F then local G=true if B then if i then local I=C(game.Workspace.Terrain,A.X
,A.Y,A.Z)if I.X+2>i.CFrame.p.X+i.Size.X/2 then G=false elseif I.X-2<i.CFrame.p.X
-i.Size.X/2 then G=false elseif I.Y+2>i.CFrame.p.Y+i.Size.Y/2 then G=false
elseif I.Y-2<i.CFrame.p.Y-i.Size.Y/2 then G=false elseif I.Z+2>i.CFrame.p.Z+i.
Size.Z/2 then G=false elseif I.Z-2<i.CFrame.p.Z-i.Size.Z/2 then G=false end end
end return G end return false end local function ResolveMegaClusterStamp(A)local
B,C,D,E,F,G,I,K,M=false,game.Workspace.Terrain,q.InternalLine,game.Workspace.
Terrain.MaxExtents.Max,game.Workspace.Terrain.MaxExtents.Min,1,0,0,false if l.
CurrentParts:FindFirstChild'AutoWedge'then M=true end if l.CurrentParts:
FindFirstChild('ClusterMaterial',true)then G=l.CurrentParts:FindFirstChild(
'ClusterMaterial',true)if G:IsA'Vector3Value'then I=G.Value.Y K=G.Value.Z G=G.
Value.X elseif G:IsA'IntValue'then G=G.Value end end if q.Adorn.Parent and q.
Start and((q.Dimensions>1)or(D and D.magnitude>0))then local N,O,P,Q,R,S,T,U,V=
game.Workspace.Terrain:WorldToCell(q.Start),{0,0,0},{0,0,0},{0,0,0},game.
Workspace.Terrain,{nil,nil,nil},{Vector3.new(0,0,0),Vector3.new(0,0,0),Vector3.
new(0,0,0)},{Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)},{}if q.
Dimensions>1 then table.insert(V,q.MoreLines[1])end if D and D.magnitude>0 then
table.insert(V,D)end if q.Dimensions>2 then table.insert(V,q.MoreLines[2])end
for W=1,#V do V[W]=Vector3.new(math.floor(V[W].X+0.5),math.floor(V[W].Y+0.5),
math.floor(V[W].Z+0.5))if V[W].X>0 then O[W]=1 elseif V[W].X<0 then O[W]=-1 end
if V[W].Y>0 then P[W]=1 elseif V[W].Y<0 then P[W]=-1 end if V[W].Z>0 then Q[W]=1
elseif V[W].Z<0 then Q[W]=-1 end S[W]=Vector3.new(O[W],P[W],Q[W])if S[W].
magnitude<0.9 then S[W]=nil end end if not V[2]then V[2]=Vector3.new(0,0,0)end
if not V[3]then V[3]=Vector3.new(0,0,0)end local W,X=l.CurrentParts:
FindFirstChild('WaterForceTag',true),l.CurrentParts:FindFirstChild(
'WaterForceDirectionTag',true)while T[3].magnitude*4<=V[3].magnitude do local Y=
1 while Y<4 do T[2]=Vector3.new(0,0,0)while T[2].magnitude*4<=V[2].magnitude do
local Z=1 while Z<4 do T[1]=Vector3.new(0,0,0)while T[1].magnitude*4<=V[1].
magnitude do local _=T[1]+T[2]+T[3]local aa=Vector3int16.new(N.X+_.X,N.Y+_.Y,N.Z
+_.Z)if aa.X>=F.X and aa.Y>=F.Y and aa.Z>=F.Z and aa.X<E.X and aa.Y<E.Y and aa.Z
<E.Z then local ab=checkTerrainBlockCollisions(aa,A)if ab then if W then R:
SetWaterCell(aa.X,aa.Y,aa.Z,Enum.WaterForce[W.Value],Enum.WaterDirection[X.Value
])else R:SetCell(aa.X,aa.Y,aa.Z,G,I,K)end B=true if M then game.Workspace.
Terrain:AutowedgeCells(Region3int16.new(Vector3int16.new(aa.x-1,aa.y-1,aa.z-1),
Vector3int16.new(aa.x+1,aa.y+1,aa.z+1)))end end end T[1]=T[1]+S[1]end if S[2]
then while Z<4 and U[Z]:Dot(S[2])==0 do Z=Z+1 end if Z<4 then T[2]=T[2]+U[Z]*U[Z
]:Dot(S[2])end Z=Z+1 else T[2]=Vector3.new(1,0,0)Z=4 end if T[2].magnitude*4>V[2
].magnitude then Z=4 end end end if S[3]then while Y<4 and U[Y]:Dot(S[3])==0 do
Y=Y+1 end if Y<4 then T[3]=T[3]+U[Y]*U[Y]:Dot(S[3])end Y=Y+1 else T[3]=Vector3.
new(1,0,0)Y=4 end if T[3].magnitude*4>V[3].magnitude then Y=4 end end end end q.
Start=nil q.Adorn.Parent=nil if B then l.CurrentParts.Parent=nil pcall(function(
)game:GetService'ChangeHistoryService':SetWaypoint'StamperMulti'end)end return B
end local function DoStamperMouseUp(aa)if not aa then error
'Error: RbxStamper.DoStamperMouseUp: Mouse is nil'return false end if not aa:IsA
'Mouse'then error('Error: RbxStamper.DoStamperMouseUp: Mouse is of type',aa.
className,'should be of type Mouse')return false end if not l.Dragger then error
[[Error: RbxStamper.DoStamperMouseUp: stampData.Dragger is nil]]return false end
if not q then return false end local ab=nil if h then local A,B=nil,
isMegaClusterPart()if B and q and q.Start and q.InternalLine and q.InternalLine.
magnitude>0 then A=true ab=true else A,ab=a.CanEditRegion(l.CurrentParts,i)end
if not A then if j then j()end return false end end if u then flashRedBox()
return false end canStamp,ab=a.CanEditRegion(l.CurrentParts,i)if not canStamp
then if j then j()end return false end local A,B=
getBoundingBoxInWorldCoordinates(l.CurrentParts)configFound,targetCFrame=
findConfigAtMouseTarget(aa,l)if configFound and not q.Adorn.Parent then if
clusterPartsInRegion(A+b,B-b)then flashRedBox()return false end local C=game.
Workspace:FindPartsInRegion3(Region3.new(A+b,B-b),l.CurrentParts,100)for D=1,#C
do if isBlocker(C[D])then flashRedBox()return false end end local D={}for E=1,#C
do if C[E].Parent and not D[C[E].Parent]and C[E].Parent:FindFirstChild'Humanoid'
and C[E].Parent:FindFirstChild'Humanoid':IsA'Humanoid'then local F=C[E].Parent:
FindFirstChild'Torso'D[C[E].Parent]=true if F then local G=B.Y+3 if
spaceAboveCharacter(F,G,l)then F.CFrame=F.CFrame+Vector3.new(0,G-F.CFrame.p.Y,0)
else flashRedBox()return false end end end end elseif(not configFound)and not(q.
Start and q.Adorn.Parent)then resetHighScalabilityLine()return false end if game
:FindFirstChild'Players'then if game.Players['LocalPlayer']then if game.Players.
LocalPlayer['Character']then local C=game.Players.LocalPlayer.Character local D=
C:FindFirstChild'StampTracker'if D and not D.Value then D.Value=true end end end
end if q.Start and q.Adorn.Parent and isMegaClusterPart()then if
ResolveMegaClusterStamp(ab)or ab then l.CurrentParts.Parent=nil return true end
end q.Start=nil q.Adorn.Parent=nil local C=game.Workspace.Terrain if
isMegaClusterPart()then local D if l.CurrentParts:IsA'Model'then D=C:
WorldToCell(l.CurrentParts:GetModelCFrame().p)else D=C:WorldToCell(l.
CurrentParts.CFrame.p)end local E,F=game.Workspace.Terrain.MaxExtents.Max,game.
Workspace.Terrain.MaxExtents.Min if checkTerrainBlockCollisions(D,false)then
local G,I,K=l.CurrentParts:FindFirstChild('ClusterMaterial',true),l.CurrentParts
:FindFirstChild('WaterForceTag',true),l.CurrentParts:FindFirstChild(
'WaterForceDirectionTag',true)if D.X>=F.X and D.Y>=F.Y and D.Z>=F.Z and D.X<E.X
and D.Y<E.Y and D.Z<E.Z then if I then C:SetWaterCell(D.X,D.Y,D.Z,Enum.
WaterForce[I.Value],Enum.WaterDirection[K.Value])elseif not G then C:SetCell(D.X
,D.Y,D.Z,z.Material,z.clusterType,k%4)elseif G:IsA'Vector3Value'then C:SetCell(D
.X,D.Y,D.Z,G.Value.X,G.Value.Y,G.Value.Z)else C:SetCell(D.X,D.Y,D.Z,G.Value,0,0)
end local M=false if l.CurrentParts:FindFirstChild'AutoWedge'then M=true end if
M then game.Workspace.Terrain:AutowedgeCells(Region3int16.new(Vector3int16.new(D
.x-1,D.y-1,D.z-1),Vector3int16.new(D.x+1,D.y+1,D.z+1)))end l.CurrentParts.Parent
=nil pcall(function()game:GetService'ChangeHistoryService':SetWaypoint
'StamperSingle'end)return true end else flashRedBox()return false end end
local function getPlayer()if game:FindFirstChild'Players'then if game.Players[
'LocalPlayer']then return game.Players.LocalPlayer end end return nil end if l.
CurrentParts:IsA'Model'or l.CurrentParts:IsA'Tool'then if l.CurrentParts:IsA
'Model'then local D,E={},{}saveTheWelds(l.CurrentParts,D,E)l.CurrentParts:
BreakJoints()l.CurrentParts:MakeJoints()restoreTheWelds(D,E)end playerIdTag=l.
CurrentParts:FindFirstChild'PlayerIdTag'playerNameTag=l.CurrentParts:
FindFirstChild'PlayerNameTag'if playerIdTag~=nil then tempPlayerValue=getPlayer(
)if tempPlayerValue~=nil then playerIdTag.Value=tempPlayerValue.userId end end
if playerNameTag~=nil then if game:FindFirstChild'Players'and game.Players[
'LocalPlayer']then tempPlayerValue=game.Players.LocalPlayer if tempPlayerValue~=
nil then playerNameTag.Value=tempPlayerValue.Name end end end if l.CurrentParts:
FindFirstChild'RobloxModel'==nil then local D=Instance.new'BoolValue'D.Name=
'RobloxModel'D.Parent=l.CurrentParts if l.CurrentParts:FindFirstChild
'RobloxStamper'==nil then local E=Instance.new'BoolValue'E.Name='RobloxStamper'E
.Parent=l.CurrentParts end end else l.CurrentParts:BreakJoints()if l.
CurrentParts:FindFirstChild'RobloxStamper'==nil then local D=Instance.new
'BoolValue'D.Name='RobloxStamper'D.Parent=l.CurrentParts end end if not
createJoints then game.JointsService:CreateJoinAfterMoveJoints()end for D,E in
pairs(l.TransparencyTable)do D.Transparency=E end for F,G in pairs(l.
ArchivableTable)do F.Archivable=G end for I,K in pairs(l.MaterialTable)do I.
Material=K end for M,N in pairs(l.CanCollideTable)do M.CanCollide=N end for O,P
in pairs(l.AnchoredTable)do O.Anchored=P end for Q,R in pairs(l.
DecalTransparencyTable)do Q.Transparency=R end for S,T in pairs(l.
SurfaceTypeTable)do loadSurfaceTypes(S,T)end if isMegaClusterPart()then l.
CurrentParts.Transparency=0 end setSeatEnabledStatus(l.CurrentParts,true)l.
TransparencyTable=nil l.ArchivableTable=nil l.MaterialTable=nil l.
CanCollideTable=nil l.AnchoredTable=nil l.SurfaceTypeTable=nil if l.CurrentParts
:FindFirstChild'RobloxModel'==nil then local U=Instance.new'BoolValue'U.Name=
'RobloxModel'U.Parent=l.CurrentParts end if ghostRemovalScript then
ghostRemovalScript.Parent=nil end for U,V in pairs(l.DisabledScripts)do V.
Disabled=false end for W,X in pairs(l.DisabledScripts)do local Y=X.Parent X.
Parent=nil X:Clone().Parent=Y end l.DisabledScripts=nil l.Dragger=nil l.
CurrentParts=nil pcall(function()game:GetService'ChangeHistoryService':
SetWaypoint'StampedObject'end)return true end local function pauseStamper()for
aa=1,#v do v[aa]:disconnect()v[aa]=nil end v={}if l and l.CurrentParts then l.
CurrentParts.Parent=nil l.CurrentParts:Remove()end resetHighScalabilityLine()
game.JointsService:ClearJoinAfterMoveJoints()end local function
prepareUnjoinableSurfaces(aa,ab,A)local B,C={Vector3.new(1,0,0),Vector3.new(0,1,
0),Vector3.new(0,0,1)},1 if A<0 then C=C*-1 A=A*-1 end local G=C*aa:
vectorToWorldSpace(B[A])for K=1,#ab do local N=ab[K]local P=N.CFrame:
vectorToObjectSpace(G)if math.abs(P.X)>math.abs(P.Y)then if math.abs(P.X)>math.
abs(P.Z)then if P.X>0 then N.RightSurface='Unjoinable'else N.LeftSurface=
'Unjoinable'end else if P.Z>0 then N.BackSurface='Unjoinable'else N.FrontSurface
='Unjoinable'end end else if math.abs(P.Y)>math.abs(P.Z)then if P.Y>0 then N.
TopSurface='Unjoinable'else N.BottomSurface='Unjoinable'end else if P.Z>0 then N
.BackSurface='Unjoinable'else N.FrontSurface='Unjoinable'end end end end end
local function resumeStamper()clone,parts=prepareModel(c)if not clone or not
parts then return end local aa=clone:FindFirstChild('UnjoinableFaces',true)if aa
then for ab in string.gmatch(aa.Value,'[^,]*')do if tonumber(ab)then if clone:
IsA'Model'then prepareUnjoinableSurfaces(clone:GetModelCFrame(),parts,tonumber(
ab))else prepareUnjoinableSurfaces(clone.CFrame,parts,tonumber(ab))end end end
end l.ErrorBox=n if h then clone.Parent=h else clone.Parent=game.Workspace end
if clone:FindFirstChild('ClusterMaterial',true)then clusterMaterial=clone:
FindFirstChild('ClusterMaterial',true)if clusterMaterial:IsA'Vector3Value'then z
.Material=clusterMaterial.Value.X z.clusterType=clusterMaterial.Value.Y z.
clusterOrientation=clusterMaterial.Value.Z elseif clusterMaterial:IsA'IntValue'
then z.Material=clusterMaterial.Value end end pcall(function()m=d.Target end)if
m and m.Parent:FindFirstChild'RobloxModel'==nil then game.JointsService:
SetJoinAfterMoveTarget(m)else game.JointsService:SetJoinAfterMoveTarget(nil)end
game.JointsService:ShowPermissibleJoints()for ab,A in pairs(l.DisabledScripts)do
if A.Name=='GhostRemovalScript'then A.Parent=l.CurrentParts end end l.Dragger=
Instance.new'Dragger'l.Dragger:MouseDown(parts[1],Vector3.new(0,0,0),parts)l.
Dragger:MouseUp()DoStamperMouseMove(d)table.insert(v,d.Move:connect(function()if
s or t then return end s=true DoStamperMouseMove(d)s=false end))table.insert(v,d
.Button1Down:connect(function()DoStamperMouseDown(d)end))table.insert(v,d.
Button1Up:connect(function()t=true while s do wait()end x.Value=
DoStamperMouseUp(d)resetHighScalabilityLine()t=false end))x.Value=false end
local function resetStamperState(aa)if aa then if not aa:IsA'Model'and not aa:
IsA'BasePart'then error
[[resetStamperState: newModelToStamp (first arg) is not nil, but not a model or part!]]
end c=aa end pauseStamper()resumeStamper()end resetStamperState()r.Stamped=x r.
Paused=false r.LoadNewModel=function(aa)if aa and not aa:IsA'Model'and not aa:
IsA'BasePart'then error
[[Control.LoadNewModel: newStampModel (first arg) is not a Model or Part!]]
return nil end resetStamperState(aa)end r.ReloadModel=function()
resetStamperState()end r.Pause=function()if not r.Paused then pauseStamper()r.
Paused=true else print
[[RbxStamper Warning: Tried to call Control.Pause() when already paused]]end end
r.Resume=function()if r.Paused then resumeStamper()r.Paused=false else print
[[RbxStamper Warning: Tried to call Control.Resume() without Pausing First]]end
end r.ResetRotation=function()end r.Destroy=function()for aa=1,#v do v[aa]:
disconnect()v[aa]=nil end if w then w:disconnect()end game.JointsService:
ClearJoinAfterMoveJoints()if p then p:Destroy()end if o then o:Destroy()end if n
then n:Destroy()end if l then if l['Dragger']then l.Dragger:Destroy()end if l.
CurrentParts then l.CurrentParts:Destroy()end end if r and r['Stamped']then r.
Stamped:Destroy()end r=nil end return r end a.Help=function(aa)if aa==
'GetStampModel'or aa==a.GetStampModel then return
[[Function GetStampModel.  Arguments: assetId, useAssetVersionId.  assetId is the asset to load in, define useAssetVersionId as true if assetId is a version id instead of a relative assetId.  Side effect: returns a model of the assetId, or a string with error message if something fails]]
end if aa=='SetupStamperDragger'or aa==a.SetupStamperDragger then return
[[Function SetupStamperDragger. Side Effect: Creates 4x4 stamping mechanism for building out parts quickly. Arguments: ModelToStamp, Mouse, LegalStampCheckFunction. ModelToStamp should be a Model or Part, preferrably loaded from RbxStamper.GetStampModel and should have extents that are multiples of 4.  Mouse should be a mouse object (obtained from things such as Tool.OnEquipped), used to drag parts around 'stamp' them out. LegalStampCheckFunction is optional, used as a callback with a table argument (table is full of instances about to be stamped). Function should return either true or false, false stopping the stamp action.]]
end end return a