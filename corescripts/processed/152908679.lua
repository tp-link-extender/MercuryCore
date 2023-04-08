local a,b,c,d,e,f,g,h,i,j=Game:GetService'ContextActionService',Game:GetService
'UserInputService'.TouchEnabled,{},{},nil,nil,
'http://www.banland.xyz/asset/?id=97166756',
'http://www.banland.xyz/asset/?id=97166444',{},{[1]=UDim2.new(0,123,0,70),[2]=
UDim2.new(0,30,0,60),[3]=UDim2.new(0,180,0,160),[4]=UDim2.new(0,85,0,-25),[5]=
UDim2.new(0,185,0,-25),[6]=UDim2.new(0,185,0,260),[7]=UDim2.new(0,216,0,65)}
local k=#j Game:GetService'ContentProvider':Preload(g)Game:GetService
'ContentProvider':Preload(h)while not Game.Players do wait()end while not Game.
Players.LocalPlayer do wait()end function createContextActionGui()if not e and b
then e=Instance.new'ScreenGui'e.Name='ContextActionGui'f=Instance.new'Frame'f.
BackgroundTransparency=1 f.Size=UDim2.new(0.3,0,0.5,0)f.Position=UDim2.new(0.7,0
,0.5,0)f.Name='ContextButtonFrame'f.Parent=e end end function
setButtonSizeAndPosition(l)local m,n,o,p=55,10,95,(game.CoreGui.RobloxGui.
AbsoluteSize.X<600)if not p then m=85 n=40 end l.Size=UDim2.new(0,m,0,m)end
function contextButtonDown(l,m,n)if m.UserInputType==Enum.UserInputType.Touch
then l.Image=g a:CallFunction(n,Enum.UserInputState.Begin,m)end end function
contextButtonMoved(l,m,n)if m.UserInputType==Enum.UserInputType.Touch then l.
Image=g a:CallFunction(n,Enum.UserInputState.Change,m)end end function
contextButtonUp(l,m,n)l.Image=h if m.UserInputType==Enum.UserInputType.Touch and
m.UserInputState==Enum.UserInputState.End then a:CallFunction(n,Enum.
UserInputState.End,m)end end function isSmallScreenDevice()return Game:
GetService'GuiService':GetScreenResolution().y<=320 end function createNewButton
(l,m)local n=Instance.new'ImageButton'n.Name='ContextActionButton'n.
BackgroundTransparency=1 n.Size=UDim2.new(0,90,0,90)n.Active=true if
isSmallScreenDevice()then n.Size=UDim2.new(0,70,0,70)end n.Image=h n.Parent=f
local o=nil Game:GetService'UserInputService'.InputEnded:connect(function(p)i[p]
=nil end)n.InputBegan:connect(function(p)if i[p]then return end if p.
UserInputState==Enum.UserInputState.Begin and o==nil then o=p contextButtonDown(
n,p,l)end end)n.InputChanged:connect(function(p)if i[p]then return end if o~=p
then return end contextButtonMoved(n,p,l)end)n.InputEnded:connect(function(p)if
i[p]then return end if o~=p then return end o=nil i[p]=true contextButtonUp(n,p,
l)end)local p=Instance.new'ImageLabel'p.Name='ActionIcon'p.Position=UDim2.new(
0.175,0,0.175,0)p.Size=UDim2.new(0.65,0,0.65,0)p.BackgroundTransparency=1 if m[
'image']and type(m['image'])=='string'then p.Image=m['image']end p.Parent=n
local q=Instance.new'TextLabel'q.Name='ActionTitle'q.Size=UDim2.new(1,0,1,0)q.
BackgroundTransparency=1 q.Font=Enum.Font.SourceSansBold q.TextColor3=Color3.
new(1,1,1)q.TextStrokeTransparency=0 q.FontSize=Enum.FontSize.Size18 q.
TextWrapped=true q.Text=''if m['title']and type(m['title'])=='string'then q.Text
=m['title']end q.Parent=n return n end function createButton(l,m)local n,o=
createNewButton(l,m),nil for p=1,#d do if d[p]=='empty'then o=p break end end if
not o then o=#d+1 end if o>k then return end d[o]=n c[l]['button']=n n.Position=
j[o]n.Parent=f if e and e.Parent==nil then e.Parent=Game.Players.LocalPlayer.
PlayerGui end end function removeAction(l)if not c[l]then return end local m=c[l
]['button']if m then m.Parent=nil for n=1,#d do if d[n]==m then d[n]='empty'
break end end m:Destroy()end c[l]=nil end function addAction(l,m,n)if c[l]then
removeAction(l)end c[l]={n}if m and b then createContextActionGui()createButton(
l,n)end end a.BoundActionChanged:connect(function(l,m,n)if c[l]and n then local
o=c[l]['button']if o then if m=='image'then o.ActionIcon.Image=n[m]elseif m==
'title'then o.ActionTitle.Text=n[m]elseif m=='description'then elseif m==
'position'then o.Position=n[m]end end end end)a.BoundActionAdded:connect(
function(l,m,n)addAction(l,m,n)end)a.BoundActionRemoved:connect(function(l,m)
removeAction(l)end)a.GetActionButtonEvent:connect(function(l)if c[l]then a:
FireActionButtonFoundSignal(l,c[l]['button'])end end)local l=a:
GetAllBoundActionInfo()for m,n in pairs(l)do addAction(m,n['createTouchButton'],
n)end