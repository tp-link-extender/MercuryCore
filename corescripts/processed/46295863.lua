local function waitForChild(a,b)while not a:FindFirstChild(b)do a.ChildAdded:
wait()end end local function waitForProperty(a,b)while not a[b]do a.Changed:
wait()end end local a if script.Parent:FindFirstChild'ControlFrame'then a=script
.Parent:FindFirstChild'ControlFrame'else a=script.Parent end local b,c,d,e,f,g,h
,i,j,k,l,m,n,o,p,q,r=nil,nil,nil,0.2,'http://www.roblox.com/asset?id=54071825',
'http://www.roblox.com/Asset?id=45915798',(game:GetService'CoreGui'.Version>=5),
10,false,nil,{},{},nil,UserSettings().GameSettings:InStudioMode(),false,pcall(
function()return not game.GuiService.IsWindows end)p=q and r local function
Color3I(s,t,u)return Color3.new(s/255,t/255,u/255)end local function robloxLock(
s)s.RobloxLocked=true local t=s:GetChildren()if t then for u,v in ipairs(t)do
robloxLock(v)end end end function resumeGameFunction(s)s.Settings:TweenPosition(
UDim2.new(0.5,-262,-0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e
,true)delay(e,function()s.Visible=false for t=1,#m do m[t].Visible=false game.
GuiService:RemoveCenterDialog(m[t])end game.GuiService:RemoveCenterDialog(s)
settingsButton.Active=true k=nil l={}end)end function goToMenu(s,t,u,v,w)if
type(t)~='string'then return end table.insert(l,k)if t=='GameMainMenu'then l={}
end local x=s:GetChildren()for y=1,#x do if x[y].Name==t then x[y].Visible=true
k={container=s,name=t,direction=u,lastSize=v}if v and w then x[y]:
TweenSizeAndPosition(v,w,Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true
)elseif v then x[y]:TweenSizeAndPosition(v,UDim2.new(0.5,-v.X.Offset/2,0.5,-v.Y.
Offset/2),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)else x[y]:
TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.
Sine,e,true)end else if u=='left'then x[y]:TweenPosition(UDim2.new(-1,-525,0,0),
Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)elseif u=='right'then x[
y]:TweenPosition(UDim2.new(1,525,0,0),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)elseif u=='up'then x[y]:TweenPosition(UDim2.new(0,0,-1,-
400),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)elseif u=='down'
then x[y]:TweenPosition(UDim2.new(0,0,1,400),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)end delay(e,function()x[y].Visible=false end)end end end
function resetLocalCharacter()local s=game.Players.LocalPlayer if s then if s.
Character and s.Character:FindFirstChild'Humanoid'then s.Character.Humanoid.
Health=0 end end end local function createTextButton(s,t,u,v,w)local x=Instance.
new'TextButton'x.Font=Enum.Font.Arial x.FontSize=u x.Size=v x.Position=w x.Style
=t x.TextColor3=Color3.new(1,1,1)x.Text=s return x end local function
CreateTextButtons(s,t,u,v)if#t<1 then error'Must have more than one button'end
local w,x=1,{}local function toggleSelection(y)for z,A in ipairs(x)do if A==y
then A.Style=Enum.ButtonStyle.RobloxButtonDefault else A.Style=Enum.ButtonStyle.
RobloxButton end end end for y,z in ipairs(t)do local A=Instance.new'TextButton'
A.Name='Button'..w A.Font=Enum.Font.Arial A.FontSize=Enum.FontSize.Size18 A.
AutoButtonColor=true A.Style=Enum.ButtonStyle.RobloxButton A.Text=z.Text A.
TextColor3=Color3.new(1,1,1)A.MouseButton1Click:connect(function()
toggleSelection(A)z.Function()end)A.Parent=s x[w]=A w=w+1 end toggleSelection(x[
1])local A=w-1 if A==1 then s.Button1.Position=UDim2.new(0.35,0,u.Scale,u.Offset
)s.Button1.Size=UDim2.new(0.4,0,v.Scale,v.Offset)elseif A==2 then s.Button1.
Position=UDim2.new(0.1,0,u.Scale,u.Offset)s.Button1.Size=UDim2.new(0.35,0,v.
Scale,v.Offset)s.Button2.Position=UDim2.new(0.55,0,u.Scale,u.Offset)s.Button2.
Size=UDim2.new(0.35,0,v.Scale,v.Offset)elseif A>=3 then local B,C=0.1/A,0.9/A w=
1 while w<=A do x[w].Position=UDim2.new(B*w+(w-1)*C,0,u.Scale,u.Offset)x[w].Size
=UDim2.new(C,0,v.Scale,v.Offset)w=w+1 end end end function setRecordGui(s,t,u)if
s then t.Visible=true u.Text='Stop Recording'else t.Visible=false u.Text=
'Record Video'end end function recordVideoClick(s,t)j=not j setRecordGui(j,t,s)
end function backToGame(s,t,u)s.Parent.Parent.Parent.Parent.Visible=false t.
Visible=false for v=1,#m do game.GuiService:RemoveCenterDialog(m[v])m[v].Visible
=false end m={}game.GuiService:RemoveCenterDialog(t)u.Active=true end function
setDisabledState(s)if not s then return end if s:IsA'TextLabel'then s.
TextTransparency=0.9 elseif s:IsA'TextButton'then s.TextTransparency=0.9 s.
Active=false else if s['ClassName']then print(
[[setDisabledState() got object of unsupported type.  object type is ]],s.
ClassName)end end end local function createHelpDialog(s)if b==nil then if a:
FindFirstChild'TopLeftControl'and a.TopLeftControl:FindFirstChild'Help'then b=a.
TopLeftControl.Help elseif a:FindFirstChild'BottomRightControl'and a.
BottomRightControl:FindFirstChild'Help'then b=a.BottomRightControl.Help end end
local t=Instance.new'Frame't.Name='HelpDialogShield't.Active=true t.Visible=
false t.Size=UDim2.new(1,0,1,0)t.BackgroundColor3=Color3I(51,51,51)t.
BorderColor3=Color3I(27,42,53)t.BackgroundTransparency=0.4 t.ZIndex=s+1 local u=
Instance.new'Frame'u.Name='HelpDialog'u.Style=Enum.FrameStyle.RobloxRound u.
Position=UDim2.new(0.2,0,0.2,0)u.Size=UDim2.new(0.6,0,0.6,0)u.Active=true u.
Parent=t local v=Instance.new'TextLabel'v.Name='Title'v.Text=
'Keyboard & Mouse Controls'v.Font=Enum.Font.ArialBold v.FontSize=Enum.FontSize.
Size36 v.Position=UDim2.new(0,0,0.025,0)v.Size=UDim2.new(1,0,0,40)v.TextColor3=
Color3.new(1,1,1)v.BackgroundTransparency=1 v.Parent=u local w=Instance.new
'Frame'w.Name='Buttons'w.Position=UDim2.new(0.1,0,0.07,40)w.Size=UDim2.new(0.8,0
,0,45)w.BackgroundTransparency=1 w.Parent=u local x=Instance.new'Frame'x.Name=
'ImageFrame'x.Position=UDim2.new(0.05,0,0.075,80)x.Size=UDim2.new(0.9,0,0.9,-120
)x.BackgroundTransparency=1 x.Parent=u local y=Instance.new'Frame'y.Name=
'LayoutFrame'y.Position=UDim2.new(0.5,0,0,0)y.Size=UDim2.new(1.5,0,1,0)y.
BackgroundTransparency=1 y.SizeConstraint=Enum.SizeConstraint.RelativeYY y.
Parent=x local z=Instance.new'ImageLabel'z.Name='Image'if UserSettings().
GameSettings.ControlMode==Enum.ControlMode['Mouse Lock Switch']then z.Image=f
else z.Image=g end z.Position=UDim2.new(-0.5,0,0,0)z.Size=UDim2.new(1,0,1,0)z.
BackgroundTransparency=1 z.Parent=y local A={}A[1]={}A[1].Text='Look'A[1].
Function=function()if UserSettings().GameSettings.ControlMode==Enum.ControlMode[
'Mouse Lock Switch']then z.Image=f else z.Image=g end end A[2]={}A[2].Text=
'Move'A[2].Function=function()z.Image='http://www.roblox.com/Asset?id=45915811'
end A[3]={}A[3].Text='Gear'A[3].Function=function()z.Image=
'http://www.roblox.com/Asset?id=45917596'end A[4]={}A[4].Text='Zoom'A[4].
Function=function()z.Image='http://www.roblox.com/Asset?id=45915825'end
CreateTextButtons(w,A,UDim.new(0,0),UDim.new(1,0))delay(0,function()
waitForChild(a,'UserSettingsShield')waitForChild(a.UserSettingsShield,'Settings'
)waitForChild(a.UserSettingsShield.Settings,'SettingsStyle')waitForChild(a.
UserSettingsShield.Settings.SettingsStyle,'GameSettingsMenu')waitForChild(a.
UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu,'CameraField')
waitForChild(a.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.
CameraField,'DropDownMenuButton')a.UserSettingsShield.Settings.SettingsStyle.
GameSettingsMenu.CameraField.DropDownMenuButton.Changed:connect(function(B)if B
~='Text'then return end if w.Button1.Style==Enum.ButtonStyle.RobloxButtonDefault
then if a.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField
.DropDownMenuButton.Text=='Classic'then z.Image=g else z.Image=f end end end)end
)local B=Instance.new'TextButton'B.Name='OkBtn'B.Text='OK'B.Modal=true B.Size=
UDim2.new(0.3,0,0,45)B.Position=UDim2.new(0.35,0,0.975,-50)B.Font=Enum.Font.
Arial B.FontSize=Enum.FontSize.Size18 B.BackgroundTransparency=1 B.TextColor3=
Color3.new(1,1,1)B.Style=Enum.ButtonStyle.RobloxButtonDefault B.
MouseButton1Click:connect(function()t.Visible=false game.GuiService:
RemoveCenterDialog(t)end)B.Parent=u robloxLock(t)return t end local function
createLeaveConfirmationMenu(s,t)local u=Instance.new'Frame'u.Name=
'LeaveConfirmationMenu'u.BackgroundTransparency=1 u.Size=UDim2.new(1,0,1,0)u.
Position=UDim2.new(0,0,2,400)u.ZIndex=s+4 local v=createTextButton('Leave',Enum.
ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,
313,0.8,0))v.Name='YesButton'v.ZIndex=s+4 v.Parent=u v.Modal=true v:SetVerb
'Exit'local w=createTextButton('Stay',Enum.ButtonStyle.RobloxButtonDefault,Enum.
FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,90,0.8,0))w.Name='NoButton'w.
Parent=u w.ZIndex=s+4 w.MouseButton1Click:connect(function()goToMenu(t.Settings.
SettingsStyle,'GameMainMenu','down',UDim2.new(0,525,0,430))t.Settings:TweenSize(
UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)
end)local x=Instance.new'TextLabel'x.Name='LeaveText'x.Text='Leave this game?'x.
Size=UDim2.new(1,0,0.8,0)x.TextWrap=true x.TextColor3=Color3.new(1,1,1)x.Font=
Enum.Font.ArialBold x.FontSize=Enum.FontSize.Size36 x.BackgroundTransparency=1 x
.ZIndex=s+4 x.Parent=u return u end local function createResetConfirmationMenu(s
,t)local u=Instance.new'Frame'u.Name='ResetConfirmationMenu'u.
BackgroundTransparency=1 u.Size=UDim2.new(1,0,1,0)u.Position=UDim2.new(0,0,2,400
)u.ZIndex=s+4 local v=createTextButton('Reset',Enum.ButtonStyle.
RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,313,0
,299))v.Name='YesButton'v.ZIndex=s+4 v.Parent=u v.Modal=true v.MouseButton1Click
:connect(function()resumeGameFunction(t)resetLocalCharacter()end)local w=
createTextButton('Cancel',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,
UDim2.new(0,128,0,50),UDim2.new(0,90,0,299))w.Name='NoButton'w.Parent=u w.ZIndex
=s+4 w.MouseButton1Click:connect(function()goToMenu(t.Settings.SettingsStyle,
'GameMainMenu','down',UDim2.new(0,525,0,430))t.Settings:TweenSize(UDim2.new(0,
525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)end)local x=
Instance.new'TextLabel'x.Name='ResetCharacterText'x.Text=
'Are you sure you want to reset your character?'x.Size=UDim2.new(1,0,0.8,0)x.
TextWrap=true x.TextColor3=Color3.new(1,1,1)x.Font=Enum.Font.ArialBold x.
FontSize=Enum.FontSize.Size36 x.BackgroundTransparency=1 x.ZIndex=s+4 x.Parent=u
local y=x:Clone()y.Name='FineResetCharacterText'y.Text=
'You will be put back on a spawn point'y.Size=UDim2.new(0,303,0,18)y.Position=
UDim2.new(0,109,0,215)y.FontSize=Enum.FontSize.Size18 y.Parent=u return u end
local function createGameMainMenu(s,t)local u=Instance.new'Frame'u.Name=
'GameMainMenu'u.BackgroundTransparency=1 u.Size=UDim2.new(1,0,1,0)u.ZIndex=s+4 u
.Parent=settingsFrame local v=Instance.new'TextLabel'v.Name='Title'v.Text=
'Game Menu'v.BackgroundTransparency=1 v.TextStrokeTransparency=0 v.Font=Enum.
Font.ArialBold v.FontSize=Enum.FontSize.Size36 v.Size=UDim2.new(1,0,0,36)v.
Position=UDim2.new(0,0,0,4)v.TextColor3=Color3.new(1,1,1)v.ZIndex=s+4 v.Parent=u
local w=createTextButton('Help',Enum.ButtonStyle.RobloxButton,Enum.FontSize.
Size18,UDim2.new(0,164,0,50),UDim2.new(0,82,0,256))w.Name='HelpButton'w.ZIndex=s
+4 w.Parent=u b=w local x=createHelpDialog(s)x.Parent=a b.MouseButton1Click:
connect(function()table.insert(m,x)game.GuiService:AddCenterDialog(x,Enum.
CenterDialogType.ModalDialog,function()x.Visible=true n.Visible=false end,
function()x.Visible=false end)end)b.Active=true local y=Instance.new'TextLabel'y
.Name='HelpShortcutText'y.Text='F1'y.Visible=false y.BackgroundTransparency=1 y.
Font=Enum.Font.Arial y.FontSize=Enum.FontSize.Size12 y.Position=UDim2.new(0,85,0
,0)y.Size=UDim2.new(0,30,0,30)y.TextColor3=Color3.new(0,1,0)y.ZIndex=s+4 y.
Parent=w local z=createTextButton('Screenshot',Enum.ButtonStyle.RobloxButton,
Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.new(0,254,0,256))z.Name=
'ScreenshotButton'z.ZIndex=s+4 z.Parent=u z.Visible=not p z:SetVerb'Screenshot'
local A=y:clone()A.Name='ScreenshotShortcutText'A.Text='PrintSc'A.Position=UDim2
.new(0,118,0,0)A.Visible=true A.Parent=z local B=createTextButton('Record Video'
,Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.
new(0,254,0,306))B.Name='RecordVideoButton'B.ZIndex=s+4 B.Parent=u B.Visible=not
p B:SetVerb'RecordToggle'local C=y:clone()C.Visible=h C.Name=
'RecordVideoShortcutText'C.Text='F12'C.Position=UDim2.new(0,120,0,0)C.Parent=B
local D=Instance.new'ImageButton'D.Name='StopRecordButton'D.
BackgroundTransparency=1 D.Image='rbxasset://textures/ui/RecordStop.png'D.Size=
UDim2.new(0,59,0,27)D:SetVerb'RecordToggle'D.MouseButton1Click:connect(function(
)recordVideoClick(B,D)end)D.Visible=false D.Parent=a local E=createTextButton(
'Report Abuse',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,
164,0,50),UDim2.new(0,82,0,306))E.Name='ReportAbuseButton'E.ZIndex=s+4 E.Parent=
u local F=createTextButton('Leave Game',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,358))F.Name=
'LeaveGameButton'F.ZIndex=s+4 F.Parent=u local G=createTextButton('Resume Game',
Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,340,0,50),
UDim2.new(0,82,0,54))G.Name='resumeGameButton'G.ZIndex=s+4 G.Parent=u G.Modal=
true G.MouseButton1Click:connect(function()resumeGameFunction(t)end)local H=
createTextButton('Game Settings',Enum.ButtonStyle.RobloxButton,Enum.FontSize.
Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,156))H.Name='SettingsButton'H.
ZIndex=s+4 H.Parent=u if game:FindFirstChild'LoadingGuiService'and#game.
LoadingGuiService:GetChildren()>0 then local I=createTextButton(
'Game Instructions',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.
new(0,340,0,50),UDim2.new(0,82,0,207))I.Name='GameInstructions'I.ZIndex=s+4 I.
Parent=u I.MouseButton1Click:connect(function()if game:FindFirstChild'Players'
and game.Players['LocalPlayer']then local J=game.Players.LocalPlayer:
FindFirstChild'PlayerLoadingGui'if J then J.Visible=true end end end)end local I
=createTextButton('Reset Character',Enum.ButtonStyle.RobloxButton,Enum.FontSize.
Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,105))I.Name='ResetButton'I.ZIndex=
s+4 I.Parent=u return u end local function createGameSettingsMenu(s,t)local u=
Instance.new'Frame'u.Name='GameSettingsMenu'u.BackgroundTransparency=1 u.Size=
UDim2.new(1,0,1,0)u.ZIndex=s+4 local v=Instance.new'TextLabel'v.Name='Title'v.
Text='Settings'v.Size=UDim2.new(1,0,0,48)v.Position=UDim2.new(0,9,0,-9)v.Font=
Enum.Font.ArialBold v.FontSize=Enum.FontSize.Size36 v.TextColor3=Color3.new(1,1,
1)v.ZIndex=s+4 v.BackgroundTransparency=1 v.Parent=u local w=Instance.new
'TextLabel'w.Name='FullscreenText'w.Text='Fullscreen Mode'w.Size=UDim2.new(0,124
,0,18)w.Position=UDim2.new(0,62,0,145)w.Font=Enum.Font.Arial w.FontSize=Enum.
FontSize.Size18 w.TextColor3=Color3.new(1,1,1)w.ZIndex=s+4 w.
BackgroundTransparency=1 w.Parent=u local x=Instance.new'TextLabel'x.Visible=h x
.Name='FullscreenShortcutText'x.Text='F11'x.BackgroundTransparency=1 x.Font=Enum
.Font.Arial x.FontSize=Enum.FontSize.Size12 x.Position=UDim2.new(0,186,0,141)x.
Size=UDim2.new(0,30,0,30)x.TextColor3=Color3.new(0,1,0)x.ZIndex=s+4 x.Parent=u
local y=Instance.new'TextLabel'y.Visible=false y.Name='StudioText'y.Text=
'Studio Mode'y.Size=UDim2.new(0,95,0,18)y.Position=UDim2.new(0,62,0,179)y.Font=
Enum.Font.Arial y.FontSize=Enum.FontSize.Size18 y.TextColor3=Color3.new(1,1,1)y.
ZIndex=s+4 y.BackgroundTransparency=1 y.Parent=u local z=x:clone()z.Name=
'StudioShortcutText'z.Visible=false z.Text='F2'z.Position=UDim2.new(0,154,0,175)
z.Parent=u local A=nil if h then local B=Instance.new'TextLabel'B.Name=
'QualityText'B.Text='Graphics Quality'B.Size=UDim2.new(0,128,0,18)B.Position=
UDim2.new(0,30,0,239)B.Font=Enum.Font.Arial B.FontSize=Enum.FontSize.Size18 B.
TextColor3=Color3.new(1,1,1)B.ZIndex=s+4 B.BackgroundTransparency=1 B.Parent=u B
.Visible=not o local C=B:clone()C.Name='AutoText'C.Text='Auto'C.Position=UDim2.
new(0,183,0,214)C.TextColor3=Color3.new(0.5019607843137255,0.5019607843137255,
0.5019607843137255)C.Size=UDim2.new(0,34,0,18)C.Parent=u C.Visible=not o local D
=C:clone()D.Name='FasterText'D.Text='Faster'D.Position=UDim2.new(0,185,0,274)D.
TextColor3=Color3.new(95,95,95)D.FontSize=Enum.FontSize.Size14 D.Parent=u D.
Visible=not o local E=x:clone()E.Name='FasterShortcutText'E.Text='F10 + Shift'E.
Position=UDim2.new(0,185,0,283)E.Parent=u E.Visible=not o local F=C:clone()F.
Name='BetterQualityText'F.Text='Better Quality'F.TextWrap=true F.Size=UDim2.new(
0,41,0,28)F.Position=UDim2.new(0,390,0,269)F.TextColor3=Color3.new(95,95,95)F.
FontSize=Enum.FontSize.Size14 F.Parent=u F.Visible=not o local G=x:clone()G.Name
='BetterQualityShortcut'G.Text='F10'G.Position=UDim2.new(0,394,0,288)G.Parent=u
G.Visible=not o local H=createTextButton('X',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,187,0,239))H.Name=
'AutoGraphicsButton'H.ZIndex=s+4 H.Parent=u H.Visible=not o local I,J=RbxGui.
CreateSlider(i,150,UDim2.new(0,230,0,280))I.Parent=u I.Bar.ZIndex=s+4 I.Bar.
Slider.ZIndex=s+5 I.Visible=not o J.Value=math.floor((settings().Rendering:
GetMaxQualityLevel()-1)/2)local K=Instance.new'TextBox'K.Name='GraphicsSetter'K.
BackgroundColor3=Color3.new(0,0,0)K.BorderColor3=Color3.new(0.5019607843137255,
0.5019607843137255,0.5019607843137255)K.Size=UDim2.new(0,50,0,25)K.Position=
UDim2.new(0,450,0,269)K.TextColor3=Color3.new(1,1,1)K.Font=Enum.Font.Arial K.
FontSize=Enum.FontSize.Size18 K.Text='Auto'K.ZIndex=1 K.TextWrap=true K.Parent=u
K.Visible=not o local L=true if not o then L=(UserSettings().GameSettings.
SavedQualityLevel==Enum.SavedQualitySetting.Automatic)else settings().Rendering.
EnableFRM=false end local M=true local function setAutoGraphicsGui(N)L=N if N
then H.Text='X'F.ZIndex=1 G.ZIndex=1 E.ZIndex=1 D.ZIndex=1 I.Bar.ZIndex=1 I.Bar.
Slider.ZIndex=1 K.ZIndex=1 K.Text='Auto'else H.Text=''I.Bar.ZIndex=s+4 I.Bar.
Slider.ZIndex=s+5 G.ZIndex=s+4 E.ZIndex=s+4 F.ZIndex=s+4 D.ZIndex=s+4 K.ZIndex=s
+4 end end local function goToAutoGraphics()setAutoGraphicsGui(true)
UserSettings().GameSettings.SavedQualityLevel=Enum.SavedQualitySetting.Automatic
settings().Rendering.QualityLevel=Enum.QualityLevel.Automatic end local function
setGraphicsQualityLevel(N)local O=N/i local P=math.floor((settings().Rendering:
GetMaxQualityLevel()-1)*O)if P==20 then P=21 elseif N==1 then P=1 elseif P>
settings().Rendering:GetMaxQualityLevel()then P=settings().Rendering:
GetMaxQualityLevel()-1 end UserSettings().GameSettings.SavedQualityLevel=N
settings().Rendering.QualityLevel=P end local function goToManualGraphics(N)
setAutoGraphicsGui(false)if N then J.Value=N else J.Value=math.floor((settings()
.Rendering.AutoFRMLevel/(settings().Rendering:GetMaxQualityLevel()-1))*i)end if
N==J.Value then setGraphicsQualityLevel(J.Value)end if not N then UserSettings()
.GameSettings.SavedQualityLevel=J.Value end K.Text=tostring(J.Value)end
local function showAutoGraphics()C.ZIndex=s+4 H.ZIndex=s+4 end local function
hideAutoGraphics()C.ZIndex=1 H.ZIndex=1 end local function showManualGraphics()I
.Bar.ZIndex=s+4 I.Bar.Slider.ZIndex=s+5 G.ZIndex=s+4 E.ZIndex=s+4 F.ZIndex=s+4 D
.ZIndex=s+4 K.ZIndex=s+4 end local function hideManualGraphics()F.ZIndex=1 G.
ZIndex=1 E.ZIndex=1 D.ZIndex=1 I.Bar.ZIndex=1 I.Bar.Slider.ZIndex=1 K.ZIndex=1
end local function translateSavedQualityLevelToInt(N)if N==Enum.
SavedQualitySetting.Automatic then return 0 elseif N==Enum.SavedQualitySetting.
QualityLevel1 then return 1 elseif N==Enum.SavedQualitySetting.QualityLevel2
then return 2 elseif N==Enum.SavedQualitySetting.QualityLevel3 then return 3
elseif N==Enum.SavedQualitySetting.QualityLevel4 then return 4 elseif N==Enum.
SavedQualitySetting.QualityLevel5 then return 5 elseif N==Enum.
SavedQualitySetting.QualityLevel6 then return 6 elseif N==Enum.
SavedQualitySetting.QualityLevel7 then return 7 elseif N==Enum.
SavedQualitySetting.QualityLevel8 then return 8 elseif N==Enum.
SavedQualitySetting.QualityLevel9 then return 9 elseif N==Enum.
SavedQualitySetting.QualityLevel10 then return 10 end end local function
enableGraphicsWidget()settings().Rendering.EnableFRM=true L=(UserSettings().
GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.Automatic)if L then
showAutoGraphics()goToAutoGraphics()else showAutoGraphics()showManualGraphics()
goToManualGraphics(translateSavedQualityLevelToInt(UserSettings().GameSettings.
SavedQualityLevel))end end local function disableGraphicsWidget()
hideManualGraphics()hideAutoGraphics()settings().Rendering.EnableFRM=false end K
.FocusLost:connect(function()if L then K.Text=tostring(J.Value)return end local
N=tonumber(K.Text)if N==nil then K.Text=tostring(J.Value)return end if N<1 then
N=1 elseif N>=settings().Rendering:GetMaxQualityLevel()then N=settings().
Rendering:GetMaxQualityLevel()-1 end J.Value=N setGraphicsQualityLevel(J.Value)K
.Text=tostring(J.Value)end)J.Changed:connect(function(N)if L then return end if
not M then return end K.Text=tostring(J.Value)setGraphicsQualityLevel(J.Value)
end)if o or UserSettings().GameSettings.SavedQualityLevel==Enum.
SavedQualitySetting.Automatic then if o then settings().Rendering.EnableFRM=
false disableGraphicsWidget()else settings().Rendering.EnableFRM=true
goToAutoGraphics()end else settings().Rendering.EnableFRM=true
goToManualGraphics(translateSavedQualityLevelToInt(UserSettings().GameSettings.
SavedQualityLevel))end H.MouseButton1Click:connect(function()if o and not game.
Players.LocalPlayer then return end if not L then goToAutoGraphics()else
goToManualGraphics(J.Value)end end)game.GraphicsQualityChangeRequest:connect(
function(N)if L then return end if N then if(J.Value+1)>i then return end J.
Value=J.Value+1 K.Text=tostring(J.Value)setGraphicsQualityLevel(J.Value)game:
GetService'GuiService':SendNotification('Graphics Quality','Increased to ('..K.
Text..')','',2,function()end)else if(J.Value-1)<=0 then return end J.Value=J.
Value-1 K.Text=tostring(J.Value)setGraphicsQualityLevel(J.Value)game:GetService
'GuiService':SendNotification('Graphics Quality','Decreased to ('..K.Text..')',
'',2,function()end)end end)game.Players.PlayerAdded:connect(function(N)if N==
game.Players.LocalPlayer and o then enableGraphicsWidget()end end)game.Players.
PlayerRemoving:connect(function(N)if N==game.Players.LocalPlayer and o then
disableGraphicsWidget()end end)A=createTextButton('',Enum.ButtonStyle.
RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,30,0,176))A.
Name='StudioCheckbox'A.ZIndex=s+4 A:SetVerb'TogglePlayMode'A.Visible=false local
N=(settings().Rendering.QualityLevel~=Enum.QualityLevel.Automatic)if o and not
game.Players.LocalPlayer then A.Text='X'disableGraphicsWidget()elseif o then A.
Text='X'enableGraphicsWidget()end if h then UserSettings().GameSettings.
StudioModeChanged:connect(function(O)o=O if O then N=(settings().Rendering.
QualityLevel~=Enum.QualityLevel.Automatic)goToAutoGraphics()A.Text='X'H.ZIndex=1
C.ZIndex=1 else if N then goToManualGraphics()end A.Text=''H.ZIndex=s+4 C.ZIndex
=s+4 end end)else A.MouseButton1Click:connect(function()if not A.Active then
return end if A.Text==''then A.Text='X'else A.Text=''end end)end end local B=
createTextButton('',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.
new(0,25,0,25),UDim2.new(0,30,0,144))B.Name='FullscreenCheckbox'B.ZIndex=s+4 B.
Parent=u B:SetVerb'ToggleFullScreen'if UserSettings().GameSettings:InFullScreen(
)then B.Text='X'end if h then UserSettings().GameSettings.FullscreenChanged:
connect(function(C)if C then B.Text='X'else B.Text=''end end)else B.
MouseButton1Click:connect(function()if B.Text==''then B.Text='X'else B.Text=''
end end)end if game:FindFirstChild'NetworkClient'then setDisabledState(y)
setDisabledState(z)setDisabledState(A)end local C if h then C=createTextButton(
'OK',Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0
,50),UDim2.new(0,170,0,330))C.Modal=true else C=createTextButton('OK',Enum.
ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2
.new(0,170,0,270))C.Modal=true end C.Name='BackButton'C.ZIndex=s+4 C.Parent=u
syncVideoCaptureSetting=nil if not p then local D=Instance.new'TextLabel'D.Name=
'VideoCaptureLabel'D.Text='After Capturing Video'D.Font=Enum.Font.Arial D.
FontSize=Enum.FontSize.Size18 D.Position=UDim2.new(0,32,0,100)D.Size=UDim2.new(0
,164,0,18)D.BackgroundTransparency=1 D.TextColor3=Color3I(255,255,255)D.
TextXAlignment=Enum.TextXAlignment.Left D.ZIndex=s+4 D.Parent=u local E,F={},{}E
[1]='Just Save to Disk'F[E[1]]=Enum.UploadSetting['Never']E[2]=
'Upload to YouTube'F[E[2]]=Enum.UploadSetting['Ask me first']local G=nil G,d=
RbxGui.CreateDropDownMenu(E,function(H)UserSettings().GameSettings.
VideoUploadPromptBehavior=F[H]end)G.Name='VideoCaptureField'G.ZIndex=s+4 G.
DropDownMenuButton.ZIndex=s+4 G.DropDownMenuButton.Icon.ZIndex=s+4 G.Position=
UDim2.new(0,270,0,94)G.Size=UDim2.new(0,200,0,32)G.Parent=u
syncVideoCaptureSetting=function()if UserSettings().GameSettings.
VideoUploadPromptBehavior==Enum.UploadSetting['Never']then d(E[1])elseif
UserSettings().GameSettings.VideoUploadPromptBehavior==Enum.UploadSetting[
'Ask me first']then d(E[2])else UserSettings().GameSettings.
VideoUploadPromptBehavior=Enum.UploadSetting['Ask me first']d(E[2])end end end
local D=Instance.new'TextLabel'D.Name='CameraLabel'D.Text=
'Character & Camera Controls'D.Font=Enum.Font.Arial D.FontSize=Enum.FontSize.
Size18 D.Position=UDim2.new(0,31,0,58)D.Size=UDim2.new(0,224,0,18)D.TextColor3=
Color3I(255,255,255)D.TextXAlignment=Enum.TextXAlignment.Left D.
BackgroundTransparency=1 D.ZIndex=s+4 D.Parent=u local E,F,G,H=game.CoreGui.
RobloxGui:FindFirstChild('MouseLockLabel',true),Enum.ControlMode:GetEnumItems(),
{},{}for I,J in ipairs(F)do G[I]=J.Name H[J.Name]=J end local K K,c=RbxGui.
CreateDropDownMenu(G,function(L)UserSettings().GameSettings.ControlMode=H[L]
pcall(function()if E and UserSettings().GameSettings.ControlMode==Enum.
ControlMode['Mouse Lock Switch']then E.Visible=true elseif E then E.Visible=
false end end)end)K.Name='CameraField'K.ZIndex=s+4 K.DropDownMenuButton.ZIndex=s
+4 K.DropDownMenuButton.Icon.ZIndex=s+4 K.Position=UDim2.new(0,270,0,52)K.Size=
UDim2.new(0,200,0,32)K.Parent=u return u end if LoadLibrary then RbxGui=
LoadLibrary'RbxGui'local s=0 if UserSettings then local t=function()
waitForChild(a,'BottomLeftControl')settingsButton=a.BottomLeftControl:
FindFirstChild'SettingsButton'if settingsButton==nil then settingsButton=
Instance.new'ImageButton'settingsButton.Name='SettingsButton'settingsButton.
Image='rbxasset://textures/ui/SettingsButton.png'settingsButton.
BackgroundTransparency=1 settingsButton.Active=false settingsButton.Size=UDim2.
new(0,54,0,46)settingsButton.Position=UDim2.new(0,2,0,50)settingsButton.Parent=a
.BottomLeftControl end local t=Instance.new'TextButton't.Text=''t.Name=
'UserSettingsShield't.Active=true t.AutoButtonColor=false t.Visible=false t.Size
=UDim2.new(1,0,1,0)t.BackgroundColor3=Color3I(51,51,51)t.BorderColor3=Color3I(27
,42,53)t.BackgroundTransparency=0.4 t.ZIndex=s+2 n=t local u=Instance.new'Frame'
u.Name='Settings'u.Position=UDim2.new(0.5,-262,-0.5,-200)u.Size=UDim2.new(0,525,
0,430)u.BackgroundTransparency=1 u.Active=true u.Parent=t local v=Instance.new
'Frame'v.Name='SettingsStyle'v.Size=UDim2.new(1,0,1,0)v.Style=Enum.FrameStyle.
RobloxRound v.Active=true v.ZIndex=s+3 v.Parent=u local w=createGameMainMenu(s,t
)w.Parent=v w.ScreenshotButton.MouseButton1Click:connect(function()backToGame(w.
ScreenshotButton,t,settingsButton)end)w.RecordVideoButton.MouseButton1Click:
connect(function()recordVideoClick(w.RecordVideoButton,a.StopRecordButton)
backToGame(w.RecordVideoButton,t,settingsButton)end)if settings():FindFirstChild
'Game Options'then pcall(function()settings():FindFirstChild'Game Options'.
VideoRecordingChangeRequest:connect(function(x)j=x setRecordGui(x,a.
StopRecordButton,w.RecordVideoButton)end)end)end game.CoreGui.RobloxGui.Changed:
connect(function(x)if x=='AbsoluteSize'and j then recordVideoClick(w.
RecordVideoButton,a.StopRecordButton)end end)function localPlayerChange()w.
ResetButton.Visible=game.Players.LocalPlayer if game.Players.LocalPlayer then
settings().Rendering.EnableFRM=true elseif o then settings().Rendering.EnableFRM
=false end end w.ResetButton.Visible=game.Players.LocalPlayer if game.Players.
LocalPlayer~=nil then game.Players.LocalPlayer.Changed:connect(function()
localPlayerChange()end)else delay(0,function()waitForProperty(game.Players,
'LocalPlayer')w.ResetButton.Visible=game.Players.LocalPlayer game.Players.
LocalPlayer.Changed:connect(function()localPlayerChange()end)end)end w.
ReportAbuseButton.Visible=game:FindFirstChild'NetworkClient'if not w.
ReportAbuseButton.Visible then game.ChildAdded:connect(function(x)if x:IsA
'NetworkClient'then w.ReportAbuseButton.Visible=game:FindFirstChild
'NetworkClient'end end)end w.ResetButton.MouseButton1Click:connect(function()
goToMenu(v,'ResetConfirmationMenu','up',UDim2.new(0,525,0,370))end)w.
LeaveGameButton.MouseButton1Click:connect(function()goToMenu(v,
'LeaveConfirmationMenu','down',UDim2.new(0,525,0,300))end)if game.CoreGui.
Version>=4 then game:GetService'GuiService'.EscapeKeyPressed:connect(function()
if k==nil then game.GuiService:AddCenterDialog(t,Enum.CenterDialogType.
ModalDialog,function()settingsButton.Active=false c(UserSettings().GameSettings.
ControlMode.Name)if syncVideoCaptureSetting then syncVideoCaptureSetting()end
goToMenu(v,'GameMainMenu','right',UDim2.new(0,525,0,430))t.Visible=true t.Active
=true v.Parent:TweenPosition(UDim2.new(0.5,-262,0.5,-200),Enum.EasingDirection.
InOut,Enum.EasingStyle.Sine,e,true)v.Parent:TweenSize(UDim2.new(0,525,0,430),
Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)end,function()v.Parent:
TweenPosition(UDim2.new(0.5,-262,-0.5,-200),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)v.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)t.Visible=false
settingsButton.Active=true end)elseif#l>0 then if#m>0 then for x=1,#m do game.
GuiService:RemoveCenterDialog(m[x])m[x].Visible=false end m={}end goToMenu(l[#l]
['container'],l[#l]['name'],l[#l]['direction'],l[#l]['lastSize'])table.remove(l,
#l)if#l==1 then l={}end else resumeGameFunction(t)end end)end local x=
createGameSettingsMenu(s,t)x.Visible=false x.Parent=v w.SettingsButton.
MouseButton1Click:connect(function()goToMenu(v,'GameSettingsMenu','left',UDim2.
new(0,525,0,350))end)x.BackButton.MouseButton1Click:connect(function()goToMenu(v
,'GameMainMenu','right',UDim2.new(0,525,0,430))end)local y=
createResetConfirmationMenu(s,t)y.Visible=false y.Parent=v local z=
createLeaveConfirmationMenu(s,t)z.Visible=false z.Parent=v robloxLock(t)
settingsButton.MouseButton1Click:connect(function()game.GuiService:
AddCenterDialog(t,Enum.CenterDialogType.ModalDialog,function()settingsButton.
Active=false c(UserSettings().GameSettings.ControlMode.Name)if
syncVideoCaptureSetting then syncVideoCaptureSetting()end goToMenu(v,
'GameMainMenu','right',UDim2.new(0,525,0,430))t.Visible=true v.Parent:
TweenPosition(UDim2.new(0.5,-262,0.5,-200),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)v.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)end,function()v.Parent:
TweenPosition(UDim2.new(0.5,-262,-0.5,-200),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)v.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)t.Visible=false
settingsButton.Active=true end)end)return t end delay(0,function()t().Parent=a a
.BottomLeftControl.SettingsButton.Active=true a.BottomLeftControl.SettingsButton
.Position=UDim2.new(0,2,0,-2)if mouseLockLabel and UserSettings().GameSettings.
ControlMode==Enum.ControlMode['Mouse Lock Switch']then mouseLockLabel.Visible=
true elseif mouseLockLabel then mouseLockLabel.Visible=false end local u=a.
BottomLeftControl:FindFirstChild'Exit'if u then u:Remove()end local v=a:
FindFirstChild'TopLeftControl'if v then u=v:FindFirstChild'Exit'if u then u:
Remove()end v:Remove()end end)end local t,u,v=function()local t=Instance.new
'TextButton't.Text=''t.AutoButtonColor=false t.Name='SaveDialogShield't.Active=
true t.Visible=false t.Size=UDim2.new(1,0,1,0)t.BackgroundColor3=Color3I(51,51,
51)t.BorderColor3=Color3I(27,42,53)t.BackgroundTransparency=0.4 t.ZIndex=s+1
local u,v,w,x,y,z=nil,nil,nil,nil,nil,{}z[1]={}z[1].Text='Save'z[1].Style=Enum.
ButtonStyle.RobloxButtonDefault z[1].Function=function()v()end z[2]={}z[2].Text=
'Cancel'z[2].Function=function()y()end z[3]={}z[3].Text="Don't Save"z[3].
Function=function()x()end local A=RbxGui.CreateStyledMessageDialog(
'Unsaved Changes','Save your changes to ROBLOX before leaving?','Confirm',z)A.
Visible=true A.Parent=t local B,C={},1 if game.LocalSaveEnabled then B[C]={}B[C]
.Text='Save to Disk'B[C].Function=function()w()end C=C+1 end B[C]={}B[C].Text=
'Keep Playing'B[C].Function=function()y()end B[C+1]={}B[C+1].Text="Don't Save"B[
C+1].Function=function()x()end local D=RbxGui.CreateStyledMessageDialog(
'Upload Failed','Sorry, we could not save your changes to ROBLOX.','Error',B)D.
Visible=false D.Parent=t local E=Instance.new'Frame'E.Name='SpinnerDialog'E.
Style=Enum.FrameStyle.RobloxRound E.Size=UDim2.new(0,350,0,150)E.Position=UDim2.
new(0.5,-175,0.5,-75)E.Visible=false E.Active=true E.Parent=t local F=Instance.
new'TextLabel'F.Name='WaitingLabel'F.Text='Saving to ROBLOX...'F.Font=Enum.Font.
ArialBold F.FontSize=Enum.FontSize.Size18 F.Position=UDim2.new(0.5,25,0.5,0)F.
TextColor3=Color3.new(1,1,1)F.Parent=E local G=Instance.new'Frame'G.Name=
'Spinner'G.Size=UDim2.new(0,80,0,80)G.Position=UDim2.new(0.5,-150,0.5,-40)G.
BackgroundTransparency=1 G.Parent=E local H,I={},1 while I<=8 do local J=
Instance.new'ImageLabel'J.Name='Spinner'..I J.Size=UDim2.new(0,16,0,16)J.
Position=UDim2.new(0.5+0.3*math.cos(math.rad(45*I)),-8,0.5+0.3*math.sin(math.
rad(45*I)),-8)J.BackgroundTransparency=1 J.Image=
'http://www.roblox.com/Asset?id=45880710'J.Parent=G H[I]=J I=I+1 end v=function(
)A.Visible=false E.Visible=true local J=true delay(0,function()local K=0 while J
do local L=0 while L<8 do if L==K or L==((K+1)%8)then H[L+1].Image=
'http://www.roblox.com/Asset?id=45880668'else H[L+1].Image=
'http://www.roblox.com/Asset?id=45880710'end L=L+1 end K=(K+1)%8 wait(0.2)end
end)local K=game:SaveToRoblox()if not K then K=game:SaveToRoblox()end E.Visible=
false J=false if K then game:FinishShutdown(false)u()else D.Visible=true end end
w=function()D.Visible=false game:FinishShutdown(true)u()end x=function()A.
Visible=false D.Visible=false game:FinishShutdown(false)u()end y=function()A.
Visible=false D.Visible=false u()end u=function()A.Visible=true D.Visible=false
E.Visible=false t.Visible=false game.GuiService:RemoveCenterDialog(t)end
robloxLock(t)t.Visible=false return t end,function()waitForChild(game,
'NetworkClient')waitForChild(game,'Players')waitForProperty(game.Players,
'LocalPlayer')local t,u=game.Players.LocalPlayer,nil waitForChild(a,
'UserSettingsShield')waitForChild(a.UserSettingsShield,'Settings')waitForChild(a
.UserSettingsShield.Settings,'SettingsStyle')waitForChild(a.UserSettingsShield.
Settings.SettingsStyle,'GameMainMenu')waitForChild(a.UserSettingsShield.Settings
.SettingsStyle.GameMainMenu,'ReportAbuseButton')u=a.UserSettingsShield.Settings.
SettingsStyle.GameMainMenu.ReportAbuseButton local v=Instance.new'TextButton'v.
Name='ReportAbuseShield'v.Text=''v.AutoButtonColor=false v.Active=true v.Visible
=false v.Size=UDim2.new(1,0,1,0)v.BackgroundColor3=Color3I(51,51,51)v.
BorderColor3=Color3I(27,42,53)v.BackgroundTransparency=0.4 v.ZIndex=s+1 local w,
x=nil,{}x[1]={}x[1].Text='Ok'x[1].Modal=true x[1].Function=function()w()end
local y=RbxGui.CreateMessageDialog('Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.

If anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats]]
,x)y.Visible=false y.Parent=v local z=RbxGui.CreateMessageDialog(
'Thanks for your report!',"We've recorded your report for evaluation.",x)z.
Visible=false z.Parent=v local A=RbxGui.CreateMessageDialog(
'Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened.]],x)A.
Visible=false A.Parent=v local B=Instance.new'Frame'B.Name='Settings'B.Position=
UDim2.new(0.5,-250,0.5,-200)B.Size=UDim2.new(0,500,0,400)B.
BackgroundTransparency=1 B.Active=true B.Parent=v local C=Instance.new'Frame'C.
Name='ReportAbuseStyle'C.Size=UDim2.new(1,0,1,0)C.Style=Enum.FrameStyle.
RobloxRound C.Active=true C.ZIndex=s+1 C.Parent=B local D=Instance.new
'TextLabel'D.Name='Title'D.Text='Report Abuse'D.TextColor3=Color3I(221,221,221)D
.Position=UDim2.new(0.5,0,0,30)D.Font=Enum.Font.ArialBold D.FontSize=Enum.
FontSize.Size36 D.ZIndex=s+2 D.Parent=C local E=Instance.new'TextLabel'E.Name=
'Description'E.Text=
[[This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.]]
E.TextColor3=Color3I(221,221,221)E.Position=UDim2.new(0,0,0,55)E.Size=UDim2.new(
1,0,0,40)E.BackgroundTransparency=1 E.Font=Enum.Font.Arial E.FontSize=Enum.
FontSize.Size18 E.TextWrap=true E.ZIndex=s+2 E.TextXAlignment=Enum.
TextXAlignment.Left E.TextYAlignment=Enum.TextYAlignment.Top E.Parent=C local F=
Instance.new'TextLabel'F.Name='PlayerLabel'F.Text='Which player?'F.
BackgroundTransparency=1 F.Font=Enum.Font.Arial F.FontSize=Enum.FontSize.Size18
F.Position=UDim2.new(0.025,0,0,100)F.Size=UDim2.new(0.4,0,0,36)F.TextColor3=
Color3I(255,255,255)F.TextXAlignment=Enum.TextXAlignment.Left F.ZIndex=s+2 F.
Parent=C local G,H,I,J=nil,nil,nil,nil local K,L=function()local K,L,M=game:
GetService'Players',{},{}local N,O=K:GetChildren(),1 if N then for P,Q in
ipairs(N)do if Q:IsA'Player'and Q~=t then L[O]=Q.Name M[Q.Name]=Q O=O+1 end end
end local P=nil P,J=RbxGui.CreateDropDownMenu(L,function(Q)G=M[Q]if H and G then
I.Active=true end end)P.Name='PlayersComboBox'P.ZIndex=s+2 P.Position=UDim2.new(
0.425,0,0,102)P.Size=UDim2.new(0.55,0,0,32)return P end,Instance.new'TextLabel'L
.Name='AbuseLabel'L.Text='Type of Abuse:'L.Font=Enum.Font.Arial L.
BackgroundTransparency=1 L.FontSize=Enum.FontSize.Size18 L.Position=UDim2.new(
0.025,0,0,140)L.Size=UDim2.new(0.4,0,0,36)L.TextColor3=Color3I(255,255,255)L.
TextXAlignment=Enum.TextXAlignment.Left L.ZIndex=s+2 L.Parent=C local M={
'Swearing','Bullying','Scamming','Dating','Cheating/Exploiting',
'Personal Questions','Offsite Links','Bad Model or Script','Bad Username'}local
N,O=RbxGui.CreateDropDownMenu(M,function(N)H=N if H and G then I.Active=true end
end,true)N.Name='AbuseComboBox'N.ZIndex=s+2 N.Position=UDim2.new(0.425,0,0,142)N
.Size=UDim2.new(0.55,0,0,32)N.Parent=C local P=Instance.new'TextLabel'P.Name=
'ShortDescriptionLabel'P.Text='Short Description: (optional)'P.Font=Enum.Font.
Arial P.FontSize=Enum.FontSize.Size18 P.Position=UDim2.new(0.025,0,0,180)P.Size=
UDim2.new(0.95,0,0,36)P.TextColor3=Color3I(255,255,255)P.TextXAlignment=Enum.
TextXAlignment.Left P.BackgroundTransparency=1 P.ZIndex=s+2 P.Parent=C local Q=
Instance.new'Frame'Q.Name='ShortDescriptionWrapper'Q.Position=UDim2.new(0.025,0,
0,220)Q.Size=UDim2.new(0.95,0,1,-310)Q.BackgroundColor3=Color3I(0,0,0)Q.
BorderSizePixel=0 Q.ZIndex=s+2 Q.Parent=C local R=Instance.new'TextBox'R.Name=
'TextBox'R.Text=''R.ClearTextOnFocus=false R.Font=Enum.Font.Arial R.FontSize=
Enum.FontSize.Size18 R.Position=UDim2.new(0,3,0,3)R.Size=UDim2.new(1,-6,1,-6)R.
TextColor3=Color3I(255,255,255)R.TextXAlignment=Enum.TextXAlignment.Left R.
TextYAlignment=Enum.TextYAlignment.Top R.TextWrap=true R.BackgroundColor3=
Color3I(0,0,0)R.BorderSizePixel=0 R.ZIndex=s+2 R.Parent=Q I=Instance.new
'TextButton'I.Name='SubmitReportBtn'I.Active=false I.Modal=true I.Font=Enum.Font
.Arial I.FontSize=Enum.FontSize.Size18 I.Position=UDim2.new(0.1,0,1,-80)I.Size=
UDim2.new(0.35,0,0,50)I.AutoButtonColor=true I.Style=Enum.ButtonStyle.
RobloxButtonDefault I.Text='Submit Report'I.TextColor3=Color3I(255,255,255)I.
ZIndex=s+2 I.Parent=C I.MouseButton1Click:connect(function()if I.Active then if
H and G then B.Visible=false game.Players:ReportAbuse(G,H,R.Text)if H==
'Cheating/Exploiting'then z.Visible=true elseif H=='Bullying'or H=='Swearing'
then y.Visible=true else A.Visible=true end else w()end end end)local S=Instance
.new'TextButton'S.Name='CancelBtn'S.Font=Enum.Font.Arial S.FontSize=Enum.
FontSize.Size18 S.Position=UDim2.new(0.55,0,1,-80)S.Size=UDim2.new(0.35,0,0,50)S
.AutoButtonColor=true S.Style=Enum.ButtonStyle.RobloxButtonDefault S.Text=
'Cancel'S.TextColor3=Color3I(255,255,255)S.ZIndex=s+2 S.Parent=C w=function()
local T=C:FindFirstChild'PlayersComboBox'if T then T.Parent=nil end G=nil J(nil)
H=nil O(nil)I.Active=false R.Text=''B.Visible=true y.Visible=false z.Visible=
false A.Visible=false v.Visible=false u.Active=true game.GuiService:
RemoveCenterDialog(v)end S.MouseButton1Click:connect(w)u.MouseButton1Click:
connect(function()K().Parent=C table.insert(m,v)game.GuiService:AddCenterDialog(
v,Enum.CenterDialogType.ModalDialog,function()u.Active=false v.Visible=true n.
Visible=false end,function()u.Active=true v.Visible=false end)end)robloxLock(v)
return v end,pcall(function()end)if v then delay(0,function()local w=t()w.Parent
=a game.RequestShutdown=function()table.insert(m,w)game.GuiService:
AddCenterDialog(w,Enum.CenterDialogType.QuitDialog,function()w.Visible=true end,
function()w.Visible=false end)return true end end)end delay(0,function()u().
Parent=a waitForChild(a,'UserSettingsShield')waitForChild(a.UserSettingsShield,
'Settings')waitForChild(a.UserSettingsShield.Settings,'SettingsStyle')
waitForChild(a.UserSettingsShield.Settings.SettingsStyle,'GameMainMenu')
waitForChild(a.UserSettingsShield.Settings.SettingsStyle.GameMainMenu,
'ReportAbuseButton')a.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.
ReportAbuseButton.Active=true end)pcall(function()return game.GuiService.
UseLuaChat end)local w=41324860 delay(0,function()waitForChild(game,
'NetworkClient')waitForChild(game,'Players')waitForProperty(game.Players,
'LocalPlayer')waitForProperty(game.Players.LocalPlayer,'Character')waitForChild(
game.Players.LocalPlayer.Character,'Humanoid')waitForProperty(game,'PlaceId')if
game.PlaceId==w then game.Players.LocalPlayer.Character.Humanoid:
SetClickToWalkEnabled(false)game.Players.LocalPlayer.CharacterAdded:connect(
function(x)waitForChild(x,'Humanoid')x.Humanoid:SetClickToWalkEnabled(false)end)
end end)end