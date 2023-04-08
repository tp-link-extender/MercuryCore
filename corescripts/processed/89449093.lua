if game.CoreGui.Version<7 then return end local function waitForChild(a,b)while
not a:FindFirstChild(b)do a.ChildAdded:wait()end return a:FindFirstChild(b)end
local function waitForProperty(a,b)while not a[b]do a.Changed:wait()end end
waitForChild(game,'Players')if#game.Players:GetChildren()<1 then game.Players.
ChildAdded:wait()end waitForProperty(game.Players,'LocalPlayer')local a,b=game.
Players.LocalPlayer,script.Parent waitForChild(b,'Gear')local c=script.Parent.
Parent assert(c:IsA'ScreenGui')waitForChild(b,'Tabs')waitForChild(b.Tabs,
'CloseButton')local d=b.Tabs.CloseButton waitForChild(b.Tabs,'InventoryButton')
local e=b.Tabs.InventoryButton if game.CoreGui.Version>=8 then waitForChild(b.
Tabs,'WardrobeButton')local f=b.Tabs.WardrobeButton end waitForChild(b.Parent,
'ControlFrame')local f,g,h=waitForChild(b.Parent.ControlFrame,'BackpackButton'),
'gear',waitForChild(b,'SearchFrame')waitForChild(b.SearchFrame,'SearchBoxFrame')
local i,j,k,l=waitForChild(b.SearchFrame.SearchBoxFrame,'SearchBox'),
waitForChild(b.SearchFrame,'SearchButton'),waitForChild(b.SearchFrame,
'ResetButton'),waitForChild(Game.CoreGui,'RobloxGui')local m=waitForChild(l,
'CurrentLoadout')local n,o,p,q,r,s,t,u,v,w,x,y,z=waitForChild(m,'Background'),
true,true,false,true,false,nil,nil,0.25,'Search...','~','`',UDim2.new(0,600,0,
400)if l.AbsoluteSize.Y<=320 then z=UDim2.new(0,200,0,140)end function
createPublicEvent(A)assert(A,'eventName is nil')assert(tostring(A),
'eventName is not a string')local B=Instance.new'BindableEvent'B.Name=tostring(A
)B.Parent=script return B end function createPublicFunction(A,B)assert(A,
'funcName is nil')assert(tostring(A),'funcName is not a string')assert(B,
'invokeFunc is nil')assert(type(B)=='function',
"invokeFunc should be of type 'function'")local C=Instance.new'BindableFunction'
C.Name=tostring(A)C.OnInvoke=B C.Parent=script return C end local A,B,C,D,E=
createPublicEvent'ResizeEvent',createPublicEvent'BackpackOpenEvent',
createPublicEvent'BackpackCloseEvent',createPublicEvent'TabClickedEvent',
createPublicEvent'SearchRequestedEvent'function deactivateBackpack()b.Visible=
false r=false end function activateBackpack()initHumanoidDiedConnections()r=true
b.Visible=q if q then toggleBackpack()end end function
initHumanoidDiedConnections()if t then t:disconnect()end waitForProperty(game.
Players.LocalPlayer,'Character')waitForChild(game.Players.LocalPlayer.Character,
'Humanoid')t=game.Players.LocalPlayer.Character.Humanoid.Died:connect(
deactivateBackpack)end local F=function()q=false p=false f.Selected=false
resetSearch()C:Fire(g)b.Tabs.Visible=false h.Visible=false b:
TweenSizeAndPosition(UDim2.new(0,z.X.Offset,0,0),UDim2.new(0.5,-z.X.Offset/2,1,-
85),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,v,true,function()game.
GuiService:RemoveCenterDialog(b)b.Visible=false f.Selected=false end)delay(v,
function()game.GuiService:RemoveCenterDialog(b)b.Visible=false f.Selected=false
p=true o=true end)end function showBackpack()game.GuiService:AddCenterDialog(b,
Enum.CenterDialogType.PlayerInitiatedDialog,function()b.Visible=true f.Selected=
true end,function()b.Visible=false f.Selected=false end)b.Visible=true f.
Selected=true b:TweenSizeAndPosition(z,UDim2.new(0.5,-z.X.Offset/2,1,-z.Y.Offset
-88),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,v,true)delay(v,function()b.
Tabs.Visible=false h.Visible=true B:Fire(g)o=true p=true f.Image=
'http://www.roblox.com/asset/?id=97644093'f.Position=UDim2.new(0.5,-60,1,-z.Y.
Offset-103)end)end function toggleBackpack()if not game.Players.LocalPlayer then
return end if not game.Players.LocalPlayer['Character']then return end if not o
then return end if not p then return end p=false o=false q=not q if q then n.
Image='http://www.roblox.com/asset/?id=97623721'n.Position=UDim2.new(-3E-2,0,-
0.17,0)n.Size=UDim2.new(1.05,0,1.25,0)n.ZIndex=2 n.Visible=true showBackpack()
else f.Position=UDim2.new(0.5,-60,1,-44)n.Visible=false f.Selected=false f.Image
='http://www.roblox.com/asset/?id=97617958'n.Image=
'http://www.roblox.com/asset/?id=96536002'n.Position=UDim2.new(-0.1,0,-0.1,0)n.
Size=UDim2.new(1.2,0,1.2,0)F()local G=m:GetChildren()for H=1,#G do if G[H]and G[
H]:IsA'Frame'then local I=G[H]if#I:GetChildren()>0 then f.Position=UDim2.new(0.5
,-60,1,-108)f.Visible=true n.Visible=true if I:GetChildren()[1]:IsA'ImageButton'
then local J=I:GetChildren()[1]J.Active=true J.Draggable=false end end end end
end end function closeBackpack()if q then toggleBackpack()end end function
setSelected(G)assert(G)assert(G:IsA'TextButton')G.BackgroundColor3=Color3.new(1,
1,1)G.TextColor3=Color3.new(0,0,0)G.Selected=true G.ZIndex=3 end function
setUnselected(G)assert(G)assert(G:IsA'TextButton')G.BackgroundColor3=Color3.new(
0,0,0)G.TextColor3=Color3.new(1,1,1)G.Selected=false G.ZIndex=1 end function
updateTabGui(G)assert(G)if G=='gear'then setSelected(e)setUnselected(
wardrobeButton)elseif G=='wardrobe'then setSelected(wardrobeButton)
setUnselected(e)end end function mouseLeaveTab(G)assert(G)assert(G:IsA
'TextButton')if G.Selected then return end G.BackgroundColor3=Color3.new(0,0,0)
end function mouseOverTab(G)assert(G)assert(G:IsA'TextButton')if G.Selected then
return end G.BackgroundColor3=Color3.new(0.15294117647058825,0.15294117647058825
,0.15294117647058825)end function newTabClicked(G)assert(G)G=string.lower(G)g=G
updateTabGui(G)D:Fire(G)resetSearch()end function trim(G)return(G:gsub(
'^%s*(.-)%s*$','%1'))end function splitByWhitespace(G)if type(G)~='string'then
return nil end local H={}for I in string.gmatch(G,'[^%s]+')do if string.len(I)>0
then table.insert(H,I)end end return H end function resetSearchBoxGui()k.Visible
=false i.Text=w end function doSearch()local G=i.Text if G==''then resetSearch()
return end G=trim(G)k.Visible=true termTable=splitByWhitespace(G)E:Fire(G)end
function resetSearch()resetSearchBoxGui()E:Fire()end local G=function()p=true
end function coreGuiChanged(H,I)if H==Enum.CoreGuiType.Backpack or H==Enum.
CoreGuiType.All then r=I s=not I if s then pcall(function()game:GetService
'GuiService':RemoveKey(x)game:GetService'GuiService':RemoveKey(y)end)else game:
GetService'GuiService':AddKey(x)game:GetService'GuiService':AddKey(y)end
resetSearch()h.Visible=I and q m.Visible=I b.Visible=I f.Visible=I end end
createPublicFunction('CloseBackpack',F)createPublicFunction('BackpackReady',G)
pcall(function()coreGuiChanged(Enum.CoreGuiType.Backpack,Game.StarterGui:
GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))Game.StarterGui.
CoreGuiChangedSignal:connect(coreGuiChanged)end)e.MouseButton1Click:connect(
function()newTabClicked'gear'end)e.MouseEnter:connect(function()mouseOverTab(e)
end)e.MouseLeave:connect(function()mouseLeaveTab(e)end)if game.CoreGui.Version>=
8 then wardrobeButton.MouseButton1Click:connect(function()newTabClicked
'wardrobe'end)wardrobeButton.MouseEnter:connect(function()mouseOverTab(
wardrobeButton)end)wardrobeButton.MouseLeave:connect(function()mouseLeaveTab(
wardrobeButton)end)end d.MouseButton1Click:connect(closeBackpack)c.Changed:
connect(function(H)if H=='AbsoluteSize'then A:Fire(c.AbsoluteSize)end end)game:
GetService'GuiService':AddKey(x)game:GetService'GuiService':AddKey(y)game:
GetService'GuiService'.KeyPressed:connect(function(H)if not r or s then return
end if H==x or H==y then toggleBackpack()end end)f.MouseButton1Click:connect(
function()if not r or s then return end toggleBackpack()end)if game.Players.
LocalPlayer['Character']then activateBackpack()end game.Players.LocalPlayer.
CharacterAdded:connect(activateBackpack)i.FocusLost:connect(function(H)if H or i
.Text~=''then doSearch()elseif i.Text==''then resetSearch()end end)j.
MouseButton1Click:connect(doSearch)k.MouseButton1Click:connect(resetSearch)if h
and l.AbsoluteSize.Y<=320 then h.RobloxLocked=false h:Destroy()end