if game.CoreGui.Version<7 then return end local function waitForChild(a,b)while
not a:FindFirstChild(b)do a.ChildAdded:wait()end return a:FindFirstChild(b)end
local function waitForProperty(a,b)while not a[b]do a.Changed:wait()end end
waitForChild(game,'Players')if#game.Players:GetChildren()<1 then game.Players.
ChildAdded:wait()end waitForProperty(game.Players,'LocalPlayer')local a=script.
Parent waitForChild(a,'Gear')local b=script.Parent.Parent assert(b:IsA
'ScreenGui')waitForChild(a,'Tabs')waitForChild(a.Tabs,'CloseButton')local c=a.
Tabs.CloseButton waitForChild(a.Tabs,'InventoryButton')local d,e=a.Tabs.
InventoryButton,nil if game.CoreGui.Version>=8 then waitForChild(a.Tabs,
'WardrobeButton')e=a.Tabs.WardrobeButton end waitForChild(a.Parent,
'ControlFrame')local f,g,h=waitForChild(a.Parent.ControlFrame,'BackpackButton'),
'gear',waitForChild(a,'SearchFrame')waitForChild(a.SearchFrame,'SearchBoxFrame')
local i,j,k,l=waitForChild(a.SearchFrame.SearchBoxFrame,'SearchBox'),
waitForChild(a.SearchFrame,'SearchButton'),waitForChild(a.SearchFrame,
'ResetButton'),waitForChild(Game.CoreGui,'RobloxGui')local m=waitForChild(l,
'CurrentLoadout')local n,o,p,q,r,s,t,u,v,w,x,y=waitForChild(m,'Background'),true
,true,false,true,false,nil,0.25,'Search...','~','`',UDim2.new(0,600,0,400)if l.
AbsoluteSize.Y<=320 then y=UDim2.new(0,200,0,140)end function createPublicEvent(
z)assert(z,'eventName is nil')assert(tostring(z),'eventName is not a string')
local A=Instance.new'BindableEvent'A.Name=tostring(z)A.Parent=script return A
end function createPublicFunction(z,A)assert(z,'funcName is nil')assert(
tostring(z),'funcName is not a string')assert(A,'invokeFunc is nil')assert(type(
A)=='function',"invokeFunc should be of type 'function'")local B=Instance.new
'BindableFunction'B.Name=tostring(z)B.OnInvoke=A B.Parent=script return B end
local z,A,B,C,D=createPublicEvent'ResizeEvent',createPublicEvent
'BackpackOpenEvent',createPublicEvent'BackpackCloseEvent',createPublicEvent
'TabClickedEvent',createPublicEvent'SearchRequestedEvent'function
deactivateBackpack()a.Visible=false r=false end function
initHumanoidDiedConnections()if t then t:disconnect()end waitForProperty(game.
Players.LocalPlayer,'Character')waitForChild(game.Players.LocalPlayer.Character,
'Humanoid')t=game.Players.LocalPlayer.Character.Humanoid.Died:connect(
deactivateBackpack)end function activateBackpack()initHumanoidDiedConnections()r
=true a.Visible=q if q then toggleBackpack()end end local E=function()q=false p=
false f.Selected=false resetSearch()B:Fire(g)a.Tabs.Visible=false h.Visible=
false a:TweenSizeAndPosition(UDim2.new(0,y.X.Offset,0,0),UDim2.new(0.5,-y.X.
Offset/2,1,-85),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,u,true,function()
game.GuiService:RemoveCenterDialog(a)a.Visible=false f.Selected=false end)delay(
u,function()game.GuiService:RemoveCenterDialog(a)a.Visible=false f.Selected=
false p=true o=true end)end function showBackpack()game.GuiService:
AddCenterDialog(a,Enum.CenterDialogType.PlayerInitiatedDialog,function()a.
Visible=true f.Selected=true end,function()a.Visible=false f.Selected=false end)
a.Visible=true f.Selected=true a:TweenSizeAndPosition(y,UDim2.new(0.5,-y.X.
Offset/2,1,-y.Y.Offset-88),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,u,true
)delay(u,function()a.Tabs.Visible=false h.Visible=true A:Fire(g)o=true p=true f.
Image='http://www.roblox.com/asset/?id=97644093'f.Position=UDim2.new(0.5,-60,1,-
y.Y.Offset-103)end)end function toggleBackpack()if not game.Players.LocalPlayer
then return end if not game.Players.LocalPlayer['Character']then return end if
not o then return end if not p then return end p=false o=false q=not q if q then
n.Image='http://www.roblox.com/asset/?id=97623721'n.Position=UDim2.new(-3E-2,0,-
0.17,0)n.Size=UDim2.new(1.05,0,1.25,0)n.ZIndex=2 n.Visible=true showBackpack()
else f.Position=UDim2.new(0.5,-60,1,-44)n.Visible=false f.Selected=false f.Image
='http://www.roblox.com/asset/?id=97617958'n.Image=
'http://www.roblox.com/asset/?id=96536002'n.Position=UDim2.new(-0.1,0,-0.1,0)n.
Size=UDim2.new(1.2,0,1.2,0)E()local F=m:GetChildren()for G=1,#F do if F[G]and F[
G]:IsA'Frame'then local H=F[G]if#H:GetChildren()>0 then f.Position=UDim2.new(0.5
,-60,1,-108)f.Visible=true n.Visible=true if H:GetChildren()[1]:IsA'ImageButton'
then local I=H:GetChildren()[1]I.Active=true I.Draggable=false end end end end
end end function closeBackpack()if q then toggleBackpack()end end function
setSelected(F)assert(F)assert(F:IsA'TextButton')F.BackgroundColor3=Color3.new(1,
1,1)F.TextColor3=Color3.new(0,0,0)F.Selected=true F.ZIndex=3 end function
setUnselected(F)assert(F)assert(F:IsA'TextButton')F.BackgroundColor3=Color3.new(
0,0,0)F.TextColor3=Color3.new(1,1,1)F.Selected=false F.ZIndex=1 end function
updateTabGui(F)assert(F)if F=='gear'then setSelected(d)setUnselected(e)elseif F
=='wardrobe'then setSelected(e)setUnselected(d)end end function mouseLeaveTab(F)
assert(F)assert(F:IsA'TextButton')if F.Selected then return end F.
BackgroundColor3=Color3.new(0,0,0)end function mouseOverTab(F)assert(F)assert(F:
IsA'TextButton')if F.Selected then return end F.BackgroundColor3=Color3.new(
0.15294117647058825,0.15294117647058825,0.15294117647058825)end function
newTabClicked(F)assert(F)F=string.lower(F)g=F updateTabGui(F)C:Fire(F)
resetSearch()end function trim(F)return(F:gsub('^%s*(.-)%s*$','%1'))end function
resetSearchBoxGui()k.Visible=false i.Text=v end function doSearch()local F=i.
Text if F==''then resetSearch()return end F=trim(F)k.Visible=true D:Fire(F)end
function resetSearch()resetSearchBoxGui()D:Fire()end local F=function()p=true
end function coreGuiChanged(G,H)if G==Enum.CoreGuiType.Backpack or G==Enum.
CoreGuiType.All then r=H s=not H if s then pcall(function()game:GetService
'GuiService':RemoveKey(w)game:GetService'GuiService':RemoveKey(x)end)else game:
GetService'GuiService':AddKey(w)game:GetService'GuiService':AddKey(x)end
resetSearch()h.Visible=H and q m.Visible=H a.Visible=H f.Visible=H end end
createPublicFunction('CloseBackpack',E)createPublicFunction('BackpackReady',F)
pcall(function()coreGuiChanged(Enum.CoreGuiType.Backpack,Game.StarterGui:
GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))Game.StarterGui.
CoreGuiChangedSignal:connect(coreGuiChanged)end)d.MouseButton1Click:connect(
function()newTabClicked'gear'end)d.MouseEnter:connect(function()mouseOverTab(d)
end)d.MouseLeave:connect(function()mouseLeaveTab(d)end)if game.CoreGui.Version>=
8 then e.MouseButton1Click:connect(function()newTabClicked'wardrobe'end)e.
MouseEnter:connect(function()mouseOverTab(e)end)e.MouseLeave:connect(function()
mouseLeaveTab(e)end)end c.MouseButton1Click:connect(closeBackpack)b.Changed:
connect(function(G)if G=='AbsoluteSize'then z:Fire(b.AbsoluteSize)end end)game:
GetService'GuiService':AddKey(w)game:GetService'GuiService':AddKey(x)game:
GetService'GuiService'.KeyPressed:connect(function(G)if not r or s then return
end if G==w or G==x then toggleBackpack()end end)f.MouseButton1Click:connect(
function()if not r or s then return end toggleBackpack()end)if game.Players.
LocalPlayer['Character']then activateBackpack()end game.Players.LocalPlayer.
CharacterAdded:connect(activateBackpack)i.FocusLost:connect(function(G)if G or i
.Text~=''then doSearch()elseif i.Text==''then resetSearch()end end)j.
MouseButton1Click:connect(doSearch)k.MouseButton1Click:connect(resetSearch)if h
and l.AbsoluteSize.Y<=320 then h.RobloxLocked=false h:Destroy()end