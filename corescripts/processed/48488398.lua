function waitForProperty(a,b)while not a[b]do a.Changed:wait()end end function
waitForChild(a,b)while not a:FindFirstChild(b)do a.ChildAdded:wait()end end
waitForProperty(game.Players,'LocalPlayer')waitForChild(script.Parent,'Popup')
waitForChild(script.Parent.Popup,'AcceptButton')script.Parent.Popup.AcceptButton
.Modal=true local a,b,c,d,e=game.Players.LocalPlayer,nil,{},true,function()if
script.Parent.Popup then script.Parent.Popup.Visible=false end end function
makeFriend(f,g)local h=script.Parent:FindFirstChild'Popup'if h==nil then return
end if h.Visible then return end if c[f]then return end h.PopupText.Text=
'Accept Friend Request from '..tostring(f.Name)..'?'h.PopupImage.Image=
'http://www.roblox.com/thumbs/avatar.ashx?userId='..tostring(f.userId)..
'&x=352&y=352'showTwoButtons()h.Visible=true h.AcceptButton.Text='Accept'h.
DeclineButton.Text='Decline'h:TweenSize(UDim2.new(0,330,0,350),Enum.
EasingDirection.Out,Enum.EasingStyle.Quart,1,true)local i,j i=h.AcceptButton.
MouseButton1Click:connect(function()h.Visible=false g:RequestFriendship(f)if i
then i:disconnect()end if j then j:disconnect()end h:TweenSize(UDim2.new(0,0,0,0
),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true,e())end)j=h.
DeclineButton.MouseButton1Click:connect(function()h.Visible=false g:
RevokeFriendship(f)c[f]=true print'pop up blacklist'if i then i:disconnect()end
if j then j:disconnect()end h:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.
Out,Enum.EasingStyle.Quart,1,true,e())end)end game.Players.FriendRequestEvent:
connect(function(f,g,h)if f~=a and g~=a then return end if f==a then if h==Enum.
FriendRequestEvent.Accept then game:GetService'GuiService':SendNotification(
'You are Friends','With '..g.Name..'!',
'http://www.roblox.com/thumbs/avatar.ashx?userId='..tostring(g.userId)..
'&x=48&y=48',5,function()end)end elseif g==a then if h==Enum.FriendRequestEvent.
Issue then if c[f]then return end game:GetService'GuiService':SendNotification(
'Friend Request','From '..f.Name,
'http://www.roblox.com/thumbs/avatar.ashx?userId='..tostring(f.userId)..
'&x=48&y=48',8,function()makeFriend(f,g)end)elseif h==Enum.FriendRequestEvent.
Accept then game:GetService'GuiService':SendNotification('You are Friends',
'With '..f.Name..'!','http://www.roblox.com/thumbs/avatar.ashx?userId='..
tostring(f.userId)..'&x=48&y=48',5,function()end)end end end)function
showOneButton()local f=script.Parent:FindFirstChild'Popup'if f then f.OKButton.
Visible=true f.DeclineButton.Visible=false f.AcceptButton.Visible=false end end
function showTwoButtons()local f=script.Parent:FindFirstChild'Popup'if f then f.
OKButton.Visible=false f.DeclineButton.Visible=true f.AcceptButton.Visible=true
end end function showTeleportUI(f,g)if b~=nil then b:Remove()end waitForChild(a,
'PlayerGui')b=Instance.new'Message'b.Text=f b.Parent=a.PlayerGui if g>0 then
wait(g)b:Remove()end end function onTeleport(f,g,h)if game:GetService
'TeleportService'.CustomizedTeleportUI==false then if f==Enum.TeleportState.
Started then showTeleportUI('Teleport started...',0)elseif f==Enum.TeleportState
.WaitingForServer then showTeleportUI('Requesting server...',0)elseif f==Enum.
TeleportState.InProgress then showTeleportUI('Teleporting...',0)elseif f==Enum.
TeleportState.Failed then showTeleportUI(
[[Teleport failed. Insufficient privileges or target place does not exist.]],3)
end end end if d then a.OnTeleport:connect(onTeleport)game:GetService
'TeleportService'.ErrorCallback=function(f)local h=script.Parent:FindFirstChild
'Popup'showOneButton()h.PopupText.Text=f local i i=h.OKButton.MouseButton1Click:
connect(function()game:GetService'TeleportService':TeleportCancel()if i then i:
disconnect()end game.GuiService:RemoveCenterDialog(script.Parent:FindFirstChild
'Popup')h:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle
.Quart,1,true,e())end)game.GuiService:AddCenterDialog(script.Parent:
FindFirstChild'Popup',Enum.CenterDialogType.QuitDialog,function()showOneButton()
script.Parent:FindFirstChild'Popup'.Visible=true h:TweenSize(UDim2.new(0,330,0,
350),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end,function()h:
TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,
true,e())end)end game:GetService'TeleportService'.ConfirmationCallback=function(
f,h,i)local j=script.Parent:FindFirstChild'Popup'j.PopupText.Text=f j.PopupImage
.Image=''local k,l local function killCons()if k then k:disconnect()end if l
then l:disconnect()end game.GuiService:RemoveCenterDialog(script.Parent:
FindFirstChild'Popup')j:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,
Enum.EasingStyle.Quart,1,true,e())end k=j.AcceptButton.MouseButton1Click:
connect(function()killCons()local m,n=pcall(function()game:GetService
'TeleportService':TeleportImpl(h,i)end)if not m then showOneButton()j.PopupText.
Text=n local o o=j.OKButton.MouseButton1Click:connect(function()if o then o:
disconnect()end game.GuiService:RemoveCenterDialog(script.Parent:FindFirstChild
'Popup')j:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle
.Quart,1,true,e())end)game.GuiService:AddCenterDialog(script.Parent:
FindFirstChild'Popup',Enum.CenterDialogType.QuitDialog,function()showOneButton()
script.Parent:FindFirstChild'Popup'.Visible=true j:TweenSize(UDim2.new(0,330,0,
350),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end,function()j:
TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,
true,e())end)end end)l=j.DeclineButton.MouseButton1Click:connect(function()
killCons()pcall(function()game:GetService'TeleportService':TeleportCancel()end)
end)local m=pcall(function()game.GuiService:AddCenterDialog(script.Parent:
FindFirstChild'Popup',Enum.CenterDialogType.QuitDialog,function()showTwoButtons(
)j.AcceptButton.Text='Leave'j.DeclineButton.Text='Stay'script.Parent:
FindFirstChild'Popup'.Visible=true j:TweenSize(UDim2.new(0,330,0,350),Enum.
EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end,function()j:TweenSize(
UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true,e())
end)end)if m==false then script.Parent:FindFirstChild'Popup'.Visible=true j.
AcceptButton.Text='Leave'j.DeclineButton.Text='Stay'j:TweenSize(UDim2.new(0,330,
0,350),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end return true
end end