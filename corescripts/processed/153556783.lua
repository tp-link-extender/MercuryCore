local a a=function(b,c,d)if not(d~=nil)then d=c c=nil end local e=Instance.new(b
)if c then e.Name=c end local f for g,h in pairs(d)do if type(g)=='string'then
if g=='Parent'then f=h else e[g]=h end elseif type(g)=='number'and type(h)==
'userdata'then h.Parent=e end end e.Parent=f return e end while not Game do
wait()end while not Game:FindFirstChild'Players'do wait()end while not Game.
Players.LocalPlayer do wait()end while not Game:FindFirstChild'CoreGui'do wait()
end while not Game.CoreGui:FindFirstChild'RobloxGui'do wait()end local b=Game:
GetService'UserInputService'local c=pcall(function()return b:IsLuaTouchControls(
)end)if not c then script:Destroy()end local d,e=Game:GetService'GuiService':
GetScreenResolution(),nil e=function()return d.y<=320 end local f,g=Game.Players
.LocalPlayer,120 if e()then g=70 end local h,i,j,k,l=
'rbxasset://textures/ui/TouchControlsSheet.png',5,0.92,{},90 if e()then l=70 end
local m,n,o={},nil,0.007 local p,q,r,s=o*16,0.03,0.2,nil Game:GetService
'ContentProvider':Preload(h)local t t=function(u,v)local w,x=v.x-u.x,v.y-u.y
return math.sqrt(w*w+x*x)end local u u=function(v,w)return UDim2.new(0,v.x-w.
AbsoluteSize.x/2,0,v.y-w.AbsoluteSize.y/2)end local v v=function(w,x,y)local z,A
,B=math.sin(y),math.cos(y),w B=Vector2.new(B.x-x.x,B.y-x.y)local C,D=B.x*A-B.y*z
,B.x*z+B.y*A B=Vector2.new(C+x.x,D+x.y)return B end local w w=function(x,y)
return x.x*y.x+x.y*y.y end local x x=function(y,z,A)local B=Vector2.new(z.
Position.X.Offset+z.AbsoluteSize.x/2,z.Position.Y.Offset+z.AbsoluteSize.y/2)
local C=t(A,B)if C>(g/2)then local D=Vector2.new(A.x-B.x,A.y-B.y)local E=D.unit
if E.x==math.nan or E.x==math.inf then E=Vector2.new(0,E.y)end if E.y==math.nan
or E.y==math.inf then E=Vector2.new(E.x,0)end local F=B+(E*(g/2))y.Position=u(F,
y)else y.Position=u(A,y)end return Vector2.new(y.Position.X.Offset-z.Position.X.
Offset,y.Position.Y.Offset-z.Position.Y.Offset)end local y y=function(z,A,B)
local C=Vector2.new(A.Position.X.Offset+A.AbsoluteSize.x/2,A.Position.Y.Offset+A
.AbsoluteSize.y/2)if t(B,C)>g/2 then local D=Vector2.new(z.Position.X.Offset+z.
AbsoluteSize.x/2,z.Position.Y.Offset+z.AbsoluteSize.y/2)local E,F=Vector2.new(B.
x-D.x,B.y-D.y).unit,Vector2.new(D.x-C.x,D.y-C.y)local G,H=F.unit,Vector2.new(B.x
-D.x,B.y-D.y)local I=(G.x*E.y)-(G.y*E.x)local J=math.atan2(I,w(G,E))local K=J*
math.min(H.magnitude/F.magnitude,1)if math.abs(K)>0.00001 then local L=v(C,D,K)A
.Position=u(Vector2.new(L.x,L.y),A)end A.Position=UDim2.new(0,A.Position.X.
Offset+H.x,0,A.Position.Y.Offset+H.y)end z.Position=u(B,z)local D,E=Vector2.new(
z.Position.X.Offset,z.Position.Y.Offset),Vector2.new(A.Position.X.Offset,A.
Position.Y.Offset)if t(D,E)>g/2 then local F=(E-D).unit*g/2 A.Position=UDim2.
new(0,D.x+F.x,0,D.y+F.y)end return Vector2.new(z.Position.X.Offset-A.Position.X.
Offset,z.Position.Y.Offset-A.Position.Y.Offset)end local z z=function(A)return(
math.abs(A.x)>i)or(math.abs(A.y)>i)end local A A=function(B,C,D)local E=a(
'Frame','ThumbstickFrame',{Active=true,Size=UDim2.new(0,g,0,g),Position=B,
BackgroundTransparency=1})a('ImageLabel','InnerThumbstick',{Image=h,
ImageRectOffset=Vector2.new(220,0),ImageRectSize=Vector2.new(111,111),
BackgroundTransparency=1,Size=UDim2.new(0,g/2,0,g/2),Position=UDim2.new(0,E.Size
.X.Offset/2-g/4,0,E.Size.Y.Offset/2-g/4),ZIndex=2,Parent=E})local F,G,H,I,J=a(
'ImageLabel','OuterThumbstick',{Image=h,ImageRectOffset=Vector2.new(0,0),
ImageRectSize=Vector2.new(220,220),BackgroundTransparency=1,Size=UDim2.new(0,g,0
,g),Position=B,Parent=Game.CoreGui.RobloxGui}),nil,nil,nil,nil J=function(K)if G
then return end if K==s then return end if K==n then return end if K.
UserInputType~=Enum.UserInputType.Touch then return end G=K table.insert(k,G)E.
Position=u(G.Position,E)F.Position=E.Position H=b.TouchMoved:connect(function(L)
if L==G then local M if D then M=x(E,F,Vector2.new(L.Position.x,L.Position.y))
else M=y(E,F,Vector2.new(L.Position.x,L.Position.y))end if C then return C(M,F.
Size.X.Offset/2)end end end)I=b.TouchEnded:connect(function(L)if L==G then if C
then C(Vector2.new(0,0),1)end I:disconnect()H:disconnect()E.Position=B F.
Position=B for M,N in pairs(k)do if N==G then table.remove(k,M)break end end G=
nil end end)end b.Changed:connect(function(K)if K=='ModalEnabled'then do local L
=not b.ModalEnabled E.Visible=L F.Visible=L end end end)E.InputBegan:connect(J)
return E end local B B=function(C)local D,E,F,G=nil,nil,f.MoveCharacter,nil G=
function(H,I)if f then if z(H)then D=H E=I if H.magnitude/I>j then I=H.magnitude
-1 end return F(f,H,I)else D=Vector2.new(0,0)E=1 return F(f,D,E)end end end
local H=UDim2.new(0,g/2,1,-g*1.75)if e()then H=UDim2.new(0,(g/2)-10,1,-g-20)end
local I=A(H,G,false)I.Name='CharacterThumbstick'I.Parent=C local J J=function()
if f and F and D and E then return F(f,D,E)end end return J end local C C=
function(D)local E,F,G=a('ImageButton','JumpButton',{BackgroundTransparency=1,
Image=h,ImageRectOffset=Vector2.new(176,222),ImageRectSize=Vector2.new(174,174),
Size=UDim2.new(0,l,0,l),Position=UDim2.new(1,(function()if e()then return-(l*
2.25),1,-l-20 else return-(l*2.75),1,-l-120 end end)())}),f.JumpCharacter,nil G=
function()while n do if f then F(f)end wait(1.6666666666666665E-2)end end E.
InputBegan:connect(function(H)if H.UserInputType~=Enum.UserInputType.Touch then
return end if n then return end if H==s then return end for I,J in pairs(m)do if
J==H then return end end n=H E.ImageRectOffset=Vector2.new(0,222)E.ImageRectSize
=Vector2.new(174,174)return G()end)E.InputEnded:connect(function(H)if H.
UserInputType~=Enum.UserInputType.Touch then return end E.ImageRectOffset=
Vector2.new(176,222)E.ImageRectSize=Vector2.new(174,174)if H==n then table.
insert(m,n)n=nil end end)b.InputEnded:connect(function(H)for I,J in pairs(m)do
if J==H then table.remove(m,I)break end end end)b.Changed:connect(function(H)if
H=='ModalEnabled'then E.Visible=not b.ModalEnabled end end)E.Parent=D end local
D D=function(E)if E==n then return true end for F,G in pairs(m)do if E==G then
return true end end return false end local E E=function(F)for G,H in pairs(k)do
if F==H then return true end end return false end local F F=function(G,H)local I
,J,K,L,M,N,O,P,Q,R=nil,false,b.RotateCamera,-1,false,nil,b.ZoomCamera,{},nil,nil
R=function()s=nil J=false I=nil end local S S=function()P={}N=nil M=false Q:
Destroy()Q=nil end local T T=function(U,V)if Q~=nil then Q:Destroy()end Q=a(
'Frame',{Name='PinchFrame',BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
Parent=G})Q.InputChanged:connect(function(W)if not M then S()return end R()if
not(N~=nil)then if W==U then N=(W.Position-V.Position).magnitude U=W elseif W==V
then N=(W.Position-U.Position).magnitude V=W end else local X=0 if W==U then X=(
W.Position-V.Position).magnitude U=W elseif W==V then X=(W.Position-U.Position).
magnitude V=W end if X~=0 then local Y=X-N if Y~=0 then O(b,(Y*q))end N=X end
end end)return Q.InputEnded:connect(function(W)if W==U or W==V then return S()
end end)end local U U=function(V)if#P<1 then table.insert(P,V)L=tick()M=false
elseif#P==1 then M=((tick()-L)<=r)if M then table.insert(P,V)return T(P[1],P[2])
else P={}end end end G.InputBegan:connect(function(V)if V.UserInputType~=Enum.
UserInputType.Touch then return end if D(V)then return end local W=E(V)if not W
then U(V)end if not(s~=nil)and not W then s=V I=Vector2.new(s.Position.x,s.
Position.y)end end)b.InputChanged:connect(function(V)if V.UserInputType~=Enum.
UserInputType.Touch then return end if s~=V then return end local W=Vector2.new(
s.Position.x,s.Position.y)local X=(I-W)*o if not J and(X.magnitude>p)then J=true
I=W end if J and(I~=W)then K(b,X)H()I=W end end)return b.InputEnded:connect(
function(V)if s==V or not(s~=nil)then R()end for W,X in pairs(P)do if X==V then
table.remove(P,W)end end end)end local G G=function()local H=a('Frame',
'TouchControlFrame',{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=
Game.CoreGui.RobloxGui})local I=B(H)C(H)F(H,I)return b.ProcessedEvent:connect(
function(J,K)if not K then return end if J==s and J.UserInputState==Enum.
UserInputState.Begin then s=nil end end)end return G()