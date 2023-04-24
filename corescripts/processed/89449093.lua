print'[Mercury]: Loaded corescript 89449093'if game.CoreGui.Version<7 then
return end local a a=function(b,c)while not b:FindFirstChild(c)do b.ChildAdded:
wait()end return b:FindFirstChild(c)end local b b=function(c,d)while not c[d]do
c.Changed:wait()end end a(game,'Players')if#game.Players:GetChildren()<1 then
game.Players.ChildAdded:wait()end b(game.Players,'LocalPlayer')local c=script.
Parent a(c,'Gear')local d=script.Parent.Parent assert(d:IsA'ScreenGui')a(c,
'Tabs')a(c.Tabs,'CloseButton')local e=c.Tabs.CloseButton a(c.Tabs,
'InventoryButton')local f,g=c.Tabs.InventoryButton,nil if game.CoreGui.Version>=
8 then a(c.Tabs,'WardrobeButton')g=c.Tabs.WardrobeButton end a(c.Parent,
'ControlFrame')local h,i,j=a(c.Parent.ControlFrame,'BackpackButton'),'gear',a(c,
'SearchFrame')a(c.SearchFrame,'SearchBoxFrame')local k,l,m,n=a(c.SearchFrame.
SearchBoxFrame,'SearchBox'),a(c.SearchFrame,'SearchButton'),a(c.SearchFrame,
'ResetButton'),a(Game.CoreGui,'RobloxGui')local o=a(n,'CurrentLoadout')local p,q
,r,s,t,u,v,w,x,y,z,A=a(o,'Background'),true,true,false,true,false,nil,0.25,
'Search...','~','`',UDim2.new(0,600,0,400)if n.AbsoluteSize.Y<=320 then A=UDim2.
new(0,200,0,140)end local B B=function(C)assert(C,'eventName is nil')assert(
tostring(C),'eventName is not a string')local D=Instance.new'BindableEvent'D.
Name=tostring(C)D.Parent=script return D end local C C=function(D,E)assert(D,
'funcName is nil')assert(tostring(D),'funcName is not a string')assert(E,
'invokeFunc is nil')assert(type(E)=='function',
"invokeFunc should be of type 'function'")local F=Instance.new'BindableFunction'
F.Name=tostring(D)F.OnInvoke=E F.Parent=script return F end local D,E,F,G,H,I=B
'ResizeEvent',B'BackpackOpenEvent',B'BackpackCloseEvent',B'TabClickedEvent',B
'SearchRequestedEvent',nil I=function()m.Visible=false k.Text=x end local J J=
function()I()return H:Fire()end local K K=function()c.Visible=false t=false end
local L L=function()if v then v:disconnect()end b(game.Players.LocalPlayer,
'Character')a(game.Players.LocalPlayer.Character,'Humanoid')v=game.Players.
LocalPlayer.Character.Humanoid.Died:connect(K)end local M M=function()s=false r=
false h.Selected=false J()F:Fire(i)c.Tabs.Visible=false j.Visible=false c:
TweenSizeAndPosition(UDim2.new(0,A.X.Offset,0,0),UDim2.new(0.5,-A.X.Offset/2,1,-
85),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,w,true,function()game.
GuiService:RemoveCenterDialog(c)c.Visible=false h.Selected=false end)return
delay(w,function()game.GuiService:RemoveCenterDialog(c)c.Visible=false h.
Selected=false r=true q=true end)end local N N=function()game.GuiService:
AddCenterDialog(c,Enum.CenterDialogType.PlayerInitiatedDialog,function()c.
Visible=true h.Selected=true end,function()c.Visible=false h.Selected=false end)
c.Visible=true h.Selected=true c:TweenSizeAndPosition(A,UDim2.new(0.5,-A.X.
Offset/2,1,-A.Y.Offset-88),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,w,true
)return delay(w,function()c.Tabs.Visible=false j.Visible=true E:Fire(i)q=true r=
true h.Image='http://www.roblox.com/asset/?id=97644093'h.Position=UDim2.new(0.5,
-60,1,-A.Y.Offset-103)end)end local O O=function()if not game.Players.
LocalPlayer then return end if not game.Players.LocalPlayer['Character']then
return end if not q then return end if not r then return end r=false q=false s=
not s if s then p.Image='http://www.roblox.com/asset/?id=97623721'p.Position=
UDim2.new(-3E-2,0,-0.17,0)p.Size=UDim2.new(1.05,0,1.25,0)p.ZIndex=2 p.Visible=
true return N()else h.Position=UDim2.new(0.5,-60,1,-44)p.Visible=false h.
Selected=false h.Image='http://www.roblox.com/asset/?id=97617958'p.Image=
'http://www.roblox.com/asset/?id=96536002'p.Position=UDim2.new(-0.1,0,-0.1,0)p.
Size=UDim2.new(1.2,0,1.2,0)M()local P=o:GetChildren()for Q=1,#P do if P[Q]and P[
Q]:IsA'Frame'then local R=P[Q]if#R:GetChildren()>0 then h.Position=UDim2.new(0.5
,-60,1,-108)h.Visible=true p.Visible=true if R:GetChildren()[1]:IsA'ImageButton'
then local S=R:GetChildren()[1]S.Active=true S.Draggable=false end end end end
end end local P P=function()L()t=true c.Visible=s if s then return O()end end
local Q Q=function()if s then return O()end end local R R=function(S)assert(S)
assert(S:IsA'TextButton')S.BackgroundColor3=Color3.new(1,1,1)S.TextColor3=Color3
.new(0,0,0)S.Selected=true S.ZIndex=3 return S end local S S=function(T)assert(T
)assert(T:IsA'TextButton')T.BackgroundColor3=Color3.new(0,0,0)T.TextColor3=
Color3.new(1,1,1)T.Selected=false T.ZIndex=1 return T end local T T=function(U)
assert(U)if U=='gear'then R(f)return S(g)elseif U=='wardrobe'then R(g)return S(f
)end end local U U=function(V)assert(V)assert(V:IsA'TextButton')if V.Selected
then return end V.BackgroundColor3=Color3.new(0,0,0)end local V V=function(W)
assert(W)assert(W:IsA'TextButton')if W.Selected then return end W.
BackgroundColor3=Color3.new(0.15294117647058825,0.15294117647058825,
0.15294117647058825)end local W W=function(X)assert(X)X=string.lower(X)i=X T(X)G
:Fire(X)return J()end local X X=function(Y)return Y:gsub('^%s*(.-)%s*$','%1')end
local Y Y=function()local Z=k.Text if Z==''then J()return end Z=X(Z)m.Visible=
true return H:Fire(Z)end local Z Z=function()r=true end local _ _=function(aa,ab
)if aa==Enum.CoreGuiType.Backpack or aa==Enum.CoreGuiType.All then t=ab u=not ab
do local ac=game:GetService'GuiService'if u then pcall(function()ac:RemoveKey(y)
return ac:RemoveKey(z)end)else ac:AddKey(y)ac:AddKey(z)end end J()j.Visible=ab
and s o.Visible=ab c.Visible=ab h.Visible=ab end end C('CloseBackpack',M)C(
'BackpackReady',Z)pcall(function()_(Enum.CoreGuiType.Backpack,Game.StarterGui:
GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))return Game.StarterGui.
CoreGuiChangedSignal:connect(_)end)f.MouseButton1Click:connect(function()return
W'gear'end)f.MouseEnter:connect(function()return V(f)end)f.MouseLeave:connect(
function()return U(f)end)if game.CoreGui.Version>=8 then g.MouseButton1Click:
connect(function()return W'wardrobe'end)g.MouseEnter:connect(function()return V(
g)end)g.MouseLeave:connect(function()return U(g)end)end e.MouseButton1Click:
connect(Q)d.Changed:connect(function(aa)if aa=='AbsoluteSize'then return D:Fire(
d.AbsoluteSize)end end)do local aa=game:GetService'GuiService'aa:AddKey(y)aa:
AddKey(z)aa.KeyPressed:connect(function(ab)if not t or u then return end if ab==
y or ab==z then return O()end end)end h.MouseButton1Click:connect(function()if
not t or u then return end return O()end)if game.Players.LocalPlayer['Character'
]then P()end game.Players.LocalPlayer.CharacterAdded:connect(P)k.FocusLost:
connect(function(aa)if aa or k.Text~=''then return Y()elseif k.Text==''then
return J()end end)l.MouseButton1Click:connect(Y)m.MouseButton1Click:connect(J)if
j and n.AbsoluteSize.Y<=320 then j.RobloxLocked=false return j:Destroy()end