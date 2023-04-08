while not Game do wait()end while not Game:FindFirstChild'Players'do wait()end
while not Game.Players.LocalPlayer do wait()end while not Game:FindFirstChild
'CoreGui'do wait()end while not Game.CoreGui:FindFirstChild'RobloxGui'do wait()
end local a=Game:GetService'UserInputService'local b=pcall(function()a:
IsLuaTouchControls()end)if not b then script:Destroy()end local c=Game:
GetService'GuiService':GetScreenResolution()function isSmallScreenDevice()return
c.y<=320 end local d,e=Game.Players.LocalPlayer,120 if isSmallScreenDevice()then
e=70 end local f,g,h,i,j='rbxasset://textures/ui/TouchControlsSheet.png',5,0.92,
{},90 if isSmallScreenDevice()then j=70 end local k,l,m={},nil,0.007 local n,o,p
,q=m*16,0.03,0.2,nil Game:GetService'ContentProvider':Preload(f)function
DistanceBetweenTwoPoints(r,s)local t,u=s.x-r.x,s.y-r.y return math.sqrt((t*t)+(u
*u))end function transformFromCenterToTopLeft(r,s)return UDim2.new(0,r.x-s.
AbsoluteSize.x/2,0,r.y-s.AbsoluteSize.y/2)end function rotatePointAboutLocation(
r,s,t)local u,v,w=math.sin(t),math.cos(t),r w=Vector2.new(w.x-s.x,w.y-s.y)local
x,y=w.x*v-w.y*u,w.x*u+w.y*v w=Vector2.new(x+s.x,y+s.y)return w end function
dotProduct(r,s)return((r.x*s.x)+(r.y*s.y))end function
stationaryThumbstickTouchMove(r,s,t)local u=Vector2.new(s.Position.X.Offset+s.
AbsoluteSize.x/2,s.Position.Y.Offset+s.AbsoluteSize.y/2)local v=
DistanceBetweenTwoPoints(t,u)if v>(e/2)then local w=Vector2.new(t.x-u.x,t.y-u.y)
local x=w.unit if x.x==math.nan or x.x==math.inf then x=Vector2.new(0,x.y)end if
x.y==math.nan or x.y==math.inf then x=Vector2.new(x.x,0)end local y=u+(x*(e/2))r
.Position=transformFromCenterToTopLeft(y,r)else r.Position=
transformFromCenterToTopLeft(t,r)end return Vector2.new(r.Position.X.Offset-s.
Position.X.Offset,r.Position.Y.Offset-s.Position.Y.Offset)end function
followThumbstickTouchMove(r,s,t)local u=Vector2.new(s.Position.X.Offset+s.
AbsoluteSize.x/2,s.Position.Y.Offset+s.AbsoluteSize.y/2)if
DistanceBetweenTwoPoints(t,u)>e/2 then local v=Vector2.new(r.Position.X.Offset+r
.AbsoluteSize.x/2,r.Position.Y.Offset+r.AbsoluteSize.y/2)local w,x=Vector2.new(t
.x-v.x,t.y-v.y).unit,Vector2.new(v.x-u.x,v.y-u.y)local y,z=x.unit,Vector2.new(t.
x-v.x,t.y-v.y)local A=(y.x*w.y)-(y.y*w.x)local B=math.atan2(A,dotProduct(y,w))
local C=B*math.min(z.magnitude/x.magnitude,1)if math.abs(C)>0.00001 then local D
=rotatePointAboutLocation(u,v,C)s.Position=transformFromCenterToTopLeft(Vector2.
new(D.x,D.y),s)end s.Position=UDim2.new(0,s.Position.X.Offset+z.x,0,s.Position.Y
.Offset+z.y)end r.Position=transformFromCenterToTopLeft(t,r)
thumbstickFramePosition=Vector2.new(r.Position.X.Offset,r.Position.Y.Offset)
thumbstickOuterPosition=Vector2.new(s.Position.X.Offset,s.Position.Y.Offset)if
DistanceBetweenTwoPoints(thumbstickFramePosition,thumbstickOuterPosition)>e/2
then local v=(thumbstickOuterPosition-thumbstickFramePosition).unit*e/2 s.
Position=UDim2.new(0,thumbstickFramePosition.x+v.x,0,thumbstickFramePosition.y+v
.y)end return Vector2.new(r.Position.X.Offset-s.Position.X.Offset,r.Position.Y.
Offset-s.Position.Y.Offset)end function movementOutsideDeadZone(r)return((math.
abs(r.x)>g)or(math.abs(r.y)>g))end function constructThumbstick(r,s,t)local u=
Instance.new'Frame'u.Name='ThumbstickFrame'u.Active=true u.Size=UDim2.new(0,e,0,
e)u.Position=r u.BackgroundTransparency=1 local v=Instance.new'ImageLabel'v.Name
='OuterThumbstick'v.Image=f v.ImageRectOffset=Vector2.new(0,0)v.ImageRectSize=
Vector2.new(220,220)v.BackgroundTransparency=1 v.Size=UDim2.new(0,e,0,e)v.
Position=r v.Parent=Game.CoreGui.RobloxGui local w=Instance.new'ImageLabel'w.
Name='InnerThumbstick'w.Image=f w.ImageRectOffset=Vector2.new(220,0)w.
ImageRectSize=Vector2.new(111,111)w.BackgroundTransparency=1 w.Size=UDim2.new(0,
e/2,0,e/2)w.Position=UDim2.new(0,u.Size.X.Offset/2-e/4,0,u.Size.Y.Offset/2-e/4)w
.Parent=u w.ZIndex=2 local x,y,z=nil,nil,nil local A=function(A)if x then return
end if A==q then return end if A==l then return end if A.UserInputType~=Enum.
UserInputType.Touch then return end x=A table.insert(i,x)u.Position=
transformFromCenterToTopLeft(x.Position,u)v.Position=u.Position y=a.TouchMoved:
connect(function(B)if B==x then local C=nil if t then C=
stationaryThumbstickTouchMove(u,v,Vector2.new(B.Position.x,B.Position.y))else C=
followThumbstickTouchMove(u,v,Vector2.new(B.Position.x,B.Position.y))end if s
then s(C,v.Size.X.Offset/2)end end end)z=a.TouchEnded:connect(function(B)if B==x
then if s then s(Vector2.new(0,0),1)end z:disconnect()y:disconnect()u.Position=r
v.Position=r for C,D in pairs(i)do if D==x then table.remove(i,C)break end end x
=nil end end)end a.Changed:connect(function(B)if B=='ModalEnabled'then u.Visible
=not a.ModalEnabled v.Visible=not a.ModalEnabled end end)u.InputBegan:connect(A)
return u end function setupCharacterMovement(r)local s,t=nil local u=d.
MoveCharacter local v,w=function(v,w)if d then if movementOutsideDeadZone(v)then
s=v t=w if v.magnitude/w>h then w=v.magnitude-1 end u(d,v,w)else s=Vector2.new(0
,0)t=1 u(d,s,t)end end end,UDim2.new(0,e/2,1,-e*1.75)if isSmallScreenDevice()
then w=UDim2.new(0,(e/2)-10,1,-e-20)end local x=constructThumbstick(w,v,false)x.
Name='CharacterThumbstick'x.Parent=r local y=function()if d and u and s and t
then u(d,s,t)end end return y end function setupJumpButton(r)local s=Instance.
new'ImageButton's.Name='JumpButton's.BackgroundTransparency=1 s.Image=f s.
ImageRectOffset=Vector2.new(176,222)s.ImageRectSize=Vector2.new(174,174)s.Size=
UDim2.new(0,j,0,j)if isSmallScreenDevice()then s.Position=UDim2.new(1,-(j*2.25),
1,-j-20)else s.Position=UDim2.new(1,-(j*2.75),1,-j-120)end local t=d.
JumpCharacter local u=function()while l do if d then t(d)end wait(
1.6666666666666665E-2)end end s.InputBegan:connect(function(v)if v.UserInputType
~=Enum.UserInputType.Touch then return end if l then return end if v==q then
return end for w,x in pairs(k)do if x==v then return end end l=v s.
ImageRectOffset=Vector2.new(0,222)s.ImageRectSize=Vector2.new(174,174)u()end)s.
InputEnded:connect(function(v)if v.UserInputType~=Enum.UserInputType.Touch then
return end s.ImageRectOffset=Vector2.new(176,222)s.ImageRectSize=Vector2.new(174
,174)if v==l then table.insert(k,l)l=nil end end)a.InputEnded:connect(function(v
)for w,x in pairs(k)do if x==v then table.remove(k,w)break end end end)a.Changed
:connect(function(v)if v=='ModalEnabled'then s.Visible=not a.ModalEnabled end
end)s.Parent=r end function isTouchUsedByJumpButton(r)if r==l then return true
end for s,t in pairs(k)do if r==t then return true end end return false end
function isTouchUsedByThumbstick(r)for s,t in pairs(i)do if r==t then return
true end end return false end function setupCameraControl(r,s)local t,u,v,w,x,y,
z,A,B=nil,false,a.RotateCamera,-1,false,nil,a.ZoomCamera,{},nil local C,D=
function()q=nil u=false t=nil end,function()A={}y=nil x=false B:Destroy()B=nil
end local E=function(E,F)if B then B:Destroy()end B=Instance.new'Frame'B.Name=
'PinchFrame'B.BackgroundTransparency=1 B.Parent=r B.Size=UDim2.new(1,0,1,0)B.
InputChanged:connect(function(G)if not x then D()return end C()if y==nil then if
G==E then y=(G.Position-F.Position).magnitude E=G elseif G==F then y=(G.Position
-E.Position).magnitude F=G end else local H=0 if G==E then H=(G.Position-F.
Position).magnitude E=G elseif G==F then H=(G.Position-E.Position).magnitude F=G
end if H~=0 then local I=H-y if I~=0 then z(a,(I*o))end y=H end end end)B.
InputEnded:connect(function(G)if G==E or G==F then D()end end)end local F=
function(F)if#A<1 then table.insert(A,F)w=tick()x=false elseif#A==1 then x=((
tick()-w)<=p)if x then table.insert(A,F)E(A[1],A[2])else A={}end end end r.
InputBegan:connect(function(G)if G.UserInputType~=Enum.UserInputType.Touch then
return end if isTouchUsedByJumpButton(G)then return end local H=
isTouchUsedByThumbstick(G)if not H then F(G)end if q==nil and not H then q=G t=
Vector2.new(q.Position.x,q.Position.y)lastTick=tick()end end)a.InputChanged:
connect(function(G)if G.UserInputType~=Enum.UserInputType.Touch then return end
if q~=G then return end local H=Vector2.new(q.Position.x,q.Position.y)local I=(t
-H)*m if not u and(I.magnitude>n)then u=true t=H end if u and(t~=H)then v(a,I)s(
)t=H end end)a.InputEnded:connect(function(G)if q==G or q==nil then C()end for H
,I in pairs(A)do if I==G then table.remove(A,H)end end end)end function
setupTouchControls()local r=Instance.new'Frame'r.Name='TouchControlFrame'r.Size=
UDim2.new(1,0,1,0)r.BackgroundTransparency=1 r.Parent=Game.CoreGui.RobloxGui
local s=setupCharacterMovement(r)setupJumpButton(r)setupCameraControl(r,s)a.
ProcessedEvent:connect(function(t,u)if not u then return end if t==q and t.
UserInputState==Enum.UserInputState.Begin then q=nil end end)end do
setupTouchControls()end