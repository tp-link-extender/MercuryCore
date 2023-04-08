function waitForProperty(a,b)while not a[b]do a.Changed:wait()end end function
waitForChild(a,b)while not a:FindFirstChild(b)do a.ChildAdded:wait()end end
local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u=nil,{},nil,{},nil,nil,nil,
'You are too far away to chat!',300,'Chat ended because you walked away',350,
"Chat ended because you didn't reply",350,nil,nil,nil,nil,nil,{},{},nil
waitForChild(game,'CoreGui')waitForChild(game.CoreGui,'RobloxGui')if game.
CoreGui.RobloxGui:FindFirstChild'ControlFrame'then u=game.CoreGui.RobloxGui.
ControlFrame else u=game.CoreGui.RobloxGui end function currentTone()if e then
return e.Tone else return Enum.DialogTone.Neutral end end function
createChatNotificationGui()o=Instance.new'BillboardGui'o.Name=
'ChatNotificationGui'o.ExtentsOffset=Vector3.new(0,1,0)o.Size=UDim2.new(4,0,
5.42857122,0)o.SizeOffset=Vector2.new(0,0)o.StudsOffset=Vector3.new(0.4,4.3,0)o.
Enabled=true o.RobloxLocked=true o.Active=true local v=Instance.new'ImageLabel'v
.Name='Image'v.Active=false v.BackgroundTransparency=1 v.Position=UDim2.new(0,0,
0,0)v.Size=UDim2.new(1,0,1,0)v.Image=''v.RobloxLocked=true v.Parent=o local w=
Instance.new'ImageButton'w.Name='Button'w.AutoButtonColor=false w.Position=UDim2
.new(0.0879999995,0,0.0529999994,0)w.Size=UDim2.new(0.829999983,0,0.460000008,0)
w.Image=''w.BackgroundTransparency=1 w.RobloxLocked=true w.Parent=v end function
getChatColor(v)if v==Enum.DialogTone.Neutral then return Enum.ChatColor.Blue
elseif v==Enum.DialogTone.Friendly then return Enum.ChatColor.Green elseif v==
Enum.DialogTone.Enemy then return Enum.ChatColor.Red end end function
styleChoices(v)for w,x in pairs(b)do resetColor(x,v)end resetColor(c,v)end
function styleMainFrame(v)if v==Enum.DialogTone.Neutral then a.Style=Enum.
FrameStyle.ChatBlue a.Tail.Image=
'rbxasset://textures/chatBubble_botBlue_tailRight.png'elseif v==Enum.DialogTone.
Friendly then a.Style=Enum.FrameStyle.ChatGreen a.Tail.Image=
'rbxasset://textures/chatBubble_botGreen_tailRight.png'elseif v==Enum.DialogTone
.Enemy then a.Style=Enum.FrameStyle.ChatRed a.Tail.Image=
'rbxasset://textures/chatBubble_botRed_tailRight.png'end styleChoices(v)end
function setChatNotificationTone(v,w,x)if x==Enum.DialogTone.Neutral then v.
Image.Image='rbxasset://textures/chatBubble_botBlue_notify_bkg.png'elseif x==
Enum.DialogTone.Friendly then v.Image.Image=
'rbxasset://textures/chatBubble_botGreen_notify_bkg.png'elseif x==Enum.
DialogTone.Enemy then v.Image.Image=
'rbxasset://textures/chatBubble_botRed_notify_bkg.png'end if w==Enum.
DialogPurpose.Quest then v.Image.Button.Image=
'rbxasset://textures/chatBubble_bot_notify_bang.png'elseif w==Enum.DialogPurpose
.Help then v.Image.Button.Image=
'rbxasset://textures/chatBubble_bot_notify_question.png'elseif w==Enum.
DialogPurpose.Shop then v.Image.Button.Image=
'rbxasset://textures/chatBubble_bot_notify_money.png'end end function
createMessageDialog()p=Instance.new'Frame'p.Name='DialogScriptMessage'p.Style=
Enum.FrameStyle.RobloxRound p.Visible=false local v=Instance.new'TextLabel'v.
Name='Text'v.Position=UDim2.new(0,0,0,-1)v.Size=UDim2.new(1,0,1,0)v.FontSize=
Enum.FontSize.Size14 v.BackgroundTransparency=1 v.TextColor3=Color3.new(1,1,1)v.
RobloxLocked=true v.Parent=p end function showMessage(v,w)p.Text.Text=v p.Size=
UDim2.new(0,w,0,40)p.Position=UDim2.new(0.5,-w/2,0.5,-40)p.Visible=true wait(2)p
.Visible=false end function variableDelay(v)local w=math.min(string.len(v),100)
wait(0.75+((w/75)*1.5))end function resetColor(v,w)if w==Enum.DialogTone.Neutral
then v.BackgroundColor3=Color3.new(0,0,0.7019607843137254)v.Number.TextColor3=
Color3.new(0.17647058823529413,0.5568627450980392,0.9607843137254902)elseif w==
Enum.DialogTone.Friendly then v.BackgroundColor3=Color3.new(0,
0.30196078431372547,0)v.Number.TextColor3=Color3.new(0,0.7450980392156863,0)
elseif w==Enum.DialogTone.Enemy then v.BackgroundColor3=Color3.new(
0.5490196078431373,0,0)v.Number.TextColor3=Color3.new(1,0.34509803921568627,
0.30980392156862746)end end function highlightColor(v,w)if w==Enum.DialogTone.
Neutral then v.BackgroundColor3=Color3.new(7.8431372549019605E-3,
0.4235294117647059,1)v.Number.TextColor3=Color3.new(1,1,1)elseif w==Enum.
DialogTone.Friendly then v.BackgroundColor3=Color3.new(0,0.5019607843137255,0)v.
Number.TextColor3=Color3.new(1,1,1)elseif w==Enum.DialogTone.Enemy then v.
BackgroundColor3=Color3.new(0.8,0,0)v.Number.TextColor3=Color3.new(1,1,1)end end
function endDialog()if g then g:Remove()g=nil end local v=e e=nil if v and v.
InUse then local w=r:Clone()w.archivable=false w.Disabled=false w.Parent=v end
for w,x in pairs(s)do if w and x then x.Enabled=not w.InUse end end f=nil end
function wanderDialog()print'Wander'a.Visible=false endDialog()showMessage(j,k)
end function timeoutDialog()print'Timeout'a.Visible=false endDialog()
showMessage(l,m)end function normalEndDialog()print'Done'endDialog()end function
sanitizeMessage(w)if string.len(w)==0 then return'...'else return w end end
function selectChoice(w)renewKillswitch(e)a.Visible=false if w==c then game.Chat
:Chat(game.Players.LocalPlayer.Character,'Goodbye!',getChatColor(currentTone()))
normalEndDialog()else local x=d[w]game.Chat:Chat(game.Players.LocalPlayer.
Character,sanitizeMessage(x.UserDialog),getChatColor(currentTone()))wait(1)e:
SignalDialogChoiceSelected(n,x)game.Chat:Chat(f,sanitizeMessage(x.ResponseDialog
),getChatColor(currentTone()))variableDelay(x.ResponseDialog)
presentDialogChoices(f,x:GetChildren())end end function newChoice(w)local x=
Instance.new'TextButton'x.BackgroundColor3=Color3.new(0,0,0.7019607843137254)x.
AutoButtonColor=false x.BorderSizePixel=0 x.Text=''x.MouseEnter:connect(function
()highlightColor(x,currentTone())end)x.MouseLeave:connect(function()resetColor(x
,currentTone())end)x.MouseButton1Click:connect(function()selectChoice(x)end)x.
RobloxLocked=true local y=Instance.new'TextLabel'y.Name='Number'y.TextColor3=
Color3.new(0.4980392156862745,0.8313725490196079,1)y.Text=w y.FontSize=Enum.
FontSize.Size14 y.BackgroundTransparency=1 y.Position=UDim2.new(0,4,0,2)y.Size=
UDim2.new(0,20,0,24)y.TextXAlignment=Enum.TextXAlignment.Left y.TextYAlignment=
Enum.TextYAlignment.Top y.RobloxLocked=true y.Parent=x local z=Instance.new
'TextLabel'z.Name='UserPrompt'z.BackgroundTransparency=1 z.TextColor3=Color3.
new(1,1,1)z.FontSize=Enum.FontSize.Size14 z.Position=UDim2.new(0,28,0,2)z.Size=
UDim2.new(1,-32,1,-4)z.TextXAlignment=Enum.TextXAlignment.Left z.TextYAlignment=
Enum.TextYAlignment.Top z.TextWrap=true z.RobloxLocked=true z.Parent=x return x
end function initialize(w)b[1]=newChoice'1)'b[2]=newChoice'2)'b[3]=newChoice'3)'
b[4]=newChoice'4)'c=newChoice'5)'c.UserPrompt.Text='Goodbye!'c.Size=UDim2.new(1,
0,0,28)a=Instance.new'Frame'a.Name='UserDialogArea'a.Size=UDim2.new(0,350,0,200)
a.Style=Enum.FrameStyle.ChatBlue a.Visible=false imageLabel=Instance.new
'ImageLabel'imageLabel.Name='Tail'imageLabel.Size=UDim2.new(0,62,0,53)imageLabel
.Position=UDim2.new(1,8,0.25)imageLabel.Image=
'rbxasset://textures/chatBubble_botBlue_tailRight.png'imageLabel.
BackgroundTransparency=1 imageLabel.RobloxLocked=true imageLabel.Parent=a for x,
y in pairs(b)do y.RobloxLocked=true y.Parent=a end c.RobloxLocked=true c.Parent=
a a.RobloxLocked=true a.Parent=w end function presentDialogChoices(w,x)if not e
then return end f=w sortedDialogChoices={}for y,z in pairs(x)do if z:IsA
'DialogChoice'then table.insert(sortedDialogChoices,z)end end table.sort(
sortedDialogChoices,function(A,B)return A.Name<B.Name end)if#sortedDialogChoices
==0 then normalEndDialog()return end local A,B=1,0 d={}for C,D in pairs(b)do D.
Visible=false end for E,F in pairs(sortedDialogChoices)do if A<=#b then b[A].
Size=UDim2.new(1,0,0,72)b[A].UserPrompt.Text=F.UserDialog local G=math.ceil(b[A]
.UserPrompt.TextBounds.Y/24)*24 b[A].Position=UDim2.new(0,0,0,B)b[A].Size=UDim2.
new(1,0,0,G)b[A].Visible=true d[b[A]]=F B=B+G A=A+1 end end c.Position=UDim2.
new(0,0,0,B)c.Number.Text=A..')'a.Size=UDim2.new(0,350,0,B+24+32)a.Position=
UDim2.new(0,20,0,-a.Size.Y.Offset-20)styleMainFrame(currentTone())a.Visible=true
end function doDialog(w)while not Instance.Lock(w,n)do wait()end if w.InUse then
Instance.Unlock(w)return else w.InUse=true Instance.Unlock(w)end e=w game.Chat:
Chat(w.Parent,w.InitialPrompt,getChatColor(w.Tone))variableDelay(w.InitialPrompt
)presentDialogChoices(w.Parent,w:GetChildren())end function renewKillswitch(w)if
g then g:Remove()g=nil end g=q:Clone()g.archivable=false g.Disabled=false g.
Parent=w end function checkForLeaveArea()while e do if e.Parent and(n:
DistanceFromCharacter(e.Parent.Position)>=e.ConversationDistance)then
wanderDialog()end wait(1)end end function startDialog(w)if w.Parent and w.Parent
:IsA'BasePart'then if n:DistanceFromCharacter(w.Parent.Position)>=w.
ConversationDistance then showMessage(h,i)return end for x,A in pairs(s)do if x
and A then A.Enabled=false end end renewKillswitch(x)delay(1,checkForLeaveArea)
doDialog(x)end end function removeDialog(w)if s[w]then s[w]:Remove()s[w]=nil end
if t[w]then t[w]:disconnect()t[w]=nil end end function addDialog(w)if w.Parent
then if w.Parent:IsA'BasePart'then local x=o:clone()x.Enabled=not w.InUse x.
Adornee=w.Parent x.RobloxLocked=true x.Parent=game.CoreGui x.Image.Button.
MouseButton1Click:connect(function()startDialog(w)end)setChatNotificationTone(x,
w.Purpose,w.Tone)s[w]=x t[w]=w.Changed:connect(function(A)if A=='Parent'and w.
Parent then removeDialog(w)addDialog(w)elseif A=='InUse'then x.Enabled=not e and
not w.InUse if w==e then timeoutDialog()end elseif A=='Tone'or A=='Purpose'then
setChatNotificationTone(x,w.Purpose,w.Tone)end end)else t[w]=w.Changed:connect(
function(x)if x=='Parent'and w.Parent then removeDialog(w)addDialog(w)end end)
end end end function fetchScripts()local w=game:GetService'InsertService':
LoadAsset(39226062)if type(w)=='string'then wait(0.1)w=game:GetService
'InsertService':LoadAsset(39226062)end if type(w)=='string'then return end
waitForChild(w,'TimeoutScript')q=w.TimeoutScript waitForChild(w,
'ReenableDialogScript')r=w.ReenableDialogScript end function onLoad()
waitForProperty(game.Players,'LocalPlayer')n=game.Players.LocalPlayer
waitForProperty(n,'Character')fetchScripts()createChatNotificationGui()
createMessageDialog()p.RobloxLocked=true p.Parent=u waitForChild(u,
'BottomLeftControl')local w=Instance.new'Frame'w.Name='DialogFrame'w.Position=
UDim2.new(0,0,0,0)w.Size=UDim2.new(0,0,0,0)w.BackgroundTransparency=1 w.
RobloxLocked=true w.Parent=u.BottomLeftControl initialize(w)game.
CollectionService.ItemAdded:connect(function(x)if x:IsA'Dialog'then addDialog(x)
end end)game.CollectionService.ItemRemoved:connect(function(x)if x:IsA'Dialog'
then removeDialog(x)end end)for x,A in pairs(game.CollectionService:
GetCollection'Dialog')do if A:IsA'Dialog'then addDialog(A)end end end onLoad()