local a a=function(b,c)while not b[c]do b.Changed:wait()end end local b b=
function(c,d)while not c:FindFirstChild(d)do c.ChildAdded:wait()end end a(game.
Players,'LocalPlayer')b(script.Parent,'Popup')b(script.Parent.Popup,
'AcceptButton')script.Parent.Popup.AcceptButton.Modal=true local c,d,e,f,g=game.
Players.LocalPlayer,nil,{},true,nil g=function()local h=script.Parent:
FindFirstChild'Popup'if h then h.OKButton.Visible=true h.DeclineButton.Visible=
false h.AcceptButton.Visible=false end return h end local h h=function()local i=
script.Parent:FindFirstChild'Popup'if i then i.OKButton.Visible=false i.
DeclineButton.Visible=true i.AcceptButton.Visible=true end return i end local i
i=function()if script.Parent.Popup then script.Parent.Popup.Visible=false end
end local j j=function(k,l)local m=script.Parent:FindFirstChild'Popup'if not(m~=
nil)then return end if m.Visible then return end if e[k]then return end m.
PopupText.Text='Accept Friend Request from '..tostring(k.Name)..'?'m.PopupImage.
Image='http://www.roblox.com/thumbs/avatar.ashx?userId='..tostring(k.userId)..
'&x=352&y=352'h()m.Visible=true m.AcceptButton.Text='Accept'm.DeclineButton.Text
='Decline'm:TweenSize(UDim2.new(0,330,0,350),Enum.EasingDirection.Out,Enum.
EasingStyle.Quart,1,true)local n,o n=m.AcceptButton.MouseButton1Click:connect(
function()m.Visible=false l:RequestFriendship(k)if n~=nil then n:disconnect()end
if o~=nil then o:disconnect()end return m:TweenSize(UDim2.new(0,0,0,0),Enum.
EasingDirection.Out,Enum.EasingStyle.Quart,1,true,i())end)o=m.DeclineButton.
MouseButton1Click:connect(function()m.Visible=false l:RevokeFriendship(k)e[k]=
true print'pop up blacklist'if n~=nil then n:disconnect()end if o~=nil then o:
disconnect()end return m:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,
Enum.EasingStyle.Quart,1,true,i())end)end game.Players.FriendRequestEvent:
connect(function(k,l,m)if k~=c and l~=c then return end if k==c then if m==Enum.
FriendRequestEvent.Accept then return game:GetService'GuiService':
SendNotification('You are Friends','With '..tostring(l.Name)..'!',
'http://www.roblox.com/thumbs/avatar.ashx?userId='..tostring(l.userId)..
'&x=48&y=48',5,function()end)end elseif l==c then if m==Enum.FriendRequestEvent.
Issue then if e[k]then return end return game:GetService'GuiService':
SendNotification('Friend Request','From '..tostring(k.Name),
'http://www.roblox.com/thumbs/avatar.ashx?userId='..tostring(k.userId)..
'&x=48&y=48',8,function()return j(k,l)end)elseif m==Enum.FriendRequestEvent.
Accept then return game:GetService'GuiService':SendNotification(
'You are Friends','With '..tostring(k.Name)..'!',
'http://www.roblox.com/thumbs/avatar.ashx?userId='..tostring(k.userId)..
'&x=48&y=48',5,function()end)end end end)local k k=function(l,m)if d~=nil then d
:Remove()end b(c,'PlayerGui')local n=Instance.new'Message'n.Text=l n.Parent=c.
PlayerGui if m>0 then wait(m)n:Remove()end return n end local l l=function(m,n,o
)if game:GetService'TeleportService'.CustomizedTeleportUI==false then return k((
function()if Enum.TeleportState.Started==m then return'Teleport started...',0
elseif Enum.TeleportState.WaitingForServer==m then return'Requesting server...',
0 elseif Enum.TeleportState.InProgress==m then return'Teleporting...',0 elseif
Enum.TeleportState.Failed==m then return
[[Teleport failed. Insufficient privileges or target place does not exist.]],3
end end)())end end if f then c.OnTeleport:connect(l)game:GetService
'TeleportService'.ErrorCallback=function(m)local o=script.Parent:FindFirstChild
'Popup'g()o.PopupText.Text=m local p p=o.OKButton.MouseButton1Click:connect(
function()game:GetService'TeleportService':TeleportCancel()if p then p:
disconnect()end game.GuiService:RemoveCenterDialog(script.Parent:FindFirstChild
'Popup')return o:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.
EasingStyle.Quart,1,true,i())end)return game.GuiService:AddCenterDialog(script.
Parent:FindFirstChild('Popup',Enum.CenterDialogType.QuitDialog),function()g()
script.Parent:FindFirstChild'Popup'.Visible=true return o:TweenSize(UDim2.new(0,
330,0,350),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end,function()
return o:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.
Quart,1,true,i())end)end game:GetService'TeleportService'.ConfirmationCallback=
function(m,o,p)local q=script.Parent:FindFirstChild'Popup'q.PopupText.Text=m q.
PopupImage.Image=''local r,s,t t=function()if r~=nil then r:disconnect()end if s
~=nil then s:disconnect()end game.GuiService:RemoveCenterDialog(script.Parent:
FindFirstChild'Popup')return q:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection
.Out,Enum.EasingStyle.Quart,1,true,i())end r=q.AcceptButton.MouseButton1Click:
connect(function()t()local u,v u,v=pcall(function()return game:GetService
'TeleportService':TeleportImpl(o,p)end)if not u then g()q.PopupText.Text=v local
w w=q.OKButton.MouseButton1Click:connect(function()if w~=nil then w:disconnect()
end game.GuiService:RemoveCenterDialog(script.Parent:FindFirstChild'Popup')
return q:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.
Quart,1,true,i())end)return game.GuiService:AddCenterDialog(script.Parent:
FindFirstChild('Popup',Enum.CenterDialogType.QuitDialog),function()g()script.
Parent:FindFirstChild'Popup'.Visible=true return q:TweenSize(UDim2.new(0,330,0,
350),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end,function()return
q:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1
,true,i())end)end end)s=q.DeclineButton.MouseButton1Click:connect(function()t()
return pcall(function()return game:GetService'TeleportService':TeleportCancel()
end)end)local u=pcall(function()return game.GuiService:AddCenterDialog(script.
Parent:FindFirstChild('Popup',Enum.CenterDialogType.QuitDialog),function()h()q.
AcceptButton.Text='Leave'q.DeclineButton.Text='Stay'script.Parent:FindFirstChild
'Popup'.Visible=true return q:TweenSize(UDim2.new(0,330,0,350),Enum.
EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end,function()return q:
TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,
true,i())end)end)if u==false then script.Parent:FindFirstChild'Popup'.Visible=
true q.AcceptButton.Text='Leave'q.DeclineButton.Text='Stay'q:TweenSize(UDim2.
new(0,330,0,350),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)end
return true end end