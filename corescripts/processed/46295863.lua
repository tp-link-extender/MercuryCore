local function waitForChild(a,b)while not a:FindFirstChild(b)do a.ChildAdded:
wait()end end local function waitForProperty(a,b)while not a[b]do a.Changed:
wait()end end local a if script.Parent:FindFirstChild'ControlFrame'then a=script
.Parent:FindFirstChild'ControlFrame'else a=script.Parent end local b,c,d,e,f,g,h
,i,j,k,l,m,n,o,p,q,r,s,t=nil,nil,nil,0.2,
'http://www.roblox.com/asset?id=54071825',
'http://www.roblox.com/Asset?id=45915798',(game:GetService'CoreGui'.Version>=5),
10,false,nil,{},UDim2.new(0,0,0,0),{0,41324860},{},nil,UserSettings().
GameSettings:InStudioMode(),false,pcall(function()return not game.GuiService.
IsWindows end)r=s and t local function Color3I(u,v,w)return Color3.new(u/255,v/
255,w/255)end local function robloxLock(u)u.RobloxLocked=true children=u:
GetChildren()if children then for v,w in ipairs(children)do robloxLock(w)end end
end function resumeGameFunction(u)u.Settings:TweenPosition(UDim2.new(0.5,-262,-
0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)delay(e,
function()u.Visible=false for v=1,#o do o[v].Visible=false game.GuiService:
RemoveCenterDialog(o[v])end game.GuiService:RemoveCenterDialog(u)settingsButton.
Active=true k=nil l={}end)end function goToMenu(u,v,w,x,y)if type(v)~='string'
then return end table.insert(l,k)if v=='GameMainMenu'then l={}end local z=u:
GetChildren()for A=1,#z do if z[A].Name==v then z[A].Visible=true k={container=u
,name=v,direction=w,lastSize=x}if x and y then z[A]:TweenSizeAndPosition(x,y,
Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)elseif x then z[A]:
TweenSizeAndPosition(x,UDim2.new(0.5,-x.X.Offset/2,0.5,-x.Y.Offset/2),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)else z[A]:TweenPosition(UDim2
.new(0,0,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)end else
if w=='left'then z[A]:TweenPosition(UDim2.new(-1,-525,0,0),Enum.EasingDirection.
InOut,Enum.EasingStyle.Sine,e,true)elseif w=='right'then z[A]:TweenPosition(
UDim2.new(1,525,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)
elseif w=='up'then z[A]:TweenPosition(UDim2.new(0,0,-1,-400),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)elseif w=='down'then z[A]:
TweenPosition(UDim2.new(0,0,1,400),Enum.EasingDirection.InOut,Enum.EasingStyle.
Sine,e,true)end delay(e,function()z[A].Visible=false end)end end end function
resetLocalCharacter()local u=game.Players.LocalPlayer if u then if u.Character
and u.Character:FindFirstChild'Humanoid'then u.Character.Humanoid.Health=0 end
end end local function createTextButton(u,v,w,x,y)local z=Instance.new
'TextButton'z.Font=Enum.Font.Arial z.FontSize=w z.Size=x z.Position=y z.Style=v
z.TextColor3=Color3.new(1,1,1)z.Text=u return z end local function
CreateTextButtons(u,v,w,x)if#v<1 then error'Must have more than one button'end
local y,z=1,{}local function toggleSelection(A)for B,C in ipairs(z)do if C==A
then C.Style=Enum.ButtonStyle.RobloxButtonDefault else C.Style=Enum.ButtonStyle.
RobloxButton end end end for A,B in ipairs(v)do local C=Instance.new'TextButton'
C.Name='Button'..y C.Font=Enum.Font.Arial C.FontSize=Enum.FontSize.Size18 C.
AutoButtonColor=true C.Style=Enum.ButtonStyle.RobloxButton C.Text=B.Text C.
TextColor3=Color3.new(1,1,1)C.MouseButton1Click:connect(function()
toggleSelection(C)B.Function()end)C.Parent=u z[y]=C y=y+1 end toggleSelection(z[
1])local C=y-1 if C==1 then u.Button1.Position=UDim2.new(0.35,0,w.Scale,w.Offset
)u.Button1.Size=UDim2.new(0.4,0,x.Scale,x.Offset)elseif C==2 then u.Button1.
Position=UDim2.new(0.1,0,w.Scale,w.Offset)u.Button1.Size=UDim2.new(0.35,0,x.
Scale,x.Offset)u.Button2.Position=UDim2.new(0.55,0,w.Scale,w.Offset)u.Button2.
Size=UDim2.new(0.35,0,x.Scale,x.Offset)elseif C>=3 then local D,E=0.1/C,0.9/C y=
1 while y<=C do z[y].Position=UDim2.new(D*y+(y-1)*E,0,w.Scale,w.Offset)z[y].Size
=UDim2.new(E,0,x.Scale,x.Offset)y=y+1 end end end function setRecordGui(u,v,w)if
u then v.Visible=true w.Text='Stop Recording'else v.Visible=false w.Text=
'Record Video'end end function recordVideoClick(u,v)j=not j setRecordGui(j,v,u)
end function backToGame(u,v,w)u.Parent.Parent.Parent.Parent.Visible=false v.
Visible=false for x=1,#o do game.GuiService:RemoveCenterDialog(o[x])o[x].Visible
=false end o={}game.GuiService:RemoveCenterDialog(v)w.Active=true end function
setDisabledState(u)if not u then return end if u:IsA'TextLabel'then u.
TextTransparency=0.9 elseif u:IsA'TextButton'then u.TextTransparency=0.9 u.
Active=false else if u['ClassName']then print(
[[setDisabledState() got object of unsupported type.  object type is ]],u.
ClassName)end end end local function createHelpDialog(u)if b==nil then if a:
FindFirstChild'TopLeftControl'and a.TopLeftControl:FindFirstChild'Help'then b=a.
TopLeftControl.Help elseif a:FindFirstChild'BottomRightControl'and a.
BottomRightControl:FindFirstChild'Help'then b=a.BottomRightControl.Help end end
local v=Instance.new'Frame'v.Name='HelpDialogShield'v.Active=true v.Visible=
false v.Size=UDim2.new(1,0,1,0)v.BackgroundColor3=Color3I(51,51,51)v.
BorderColor3=Color3I(27,42,53)v.BackgroundTransparency=0.4 v.ZIndex=u+1 local w=
Instance.new'Frame'w.Name='HelpDialog'w.Style=Enum.FrameStyle.RobloxRound w.
Position=UDim2.new(0.2,0,0.2,0)w.Size=UDim2.new(0.6,0,0.6,0)w.Active=true w.
Parent=v local x=Instance.new'TextLabel'x.Name='Title'x.Text=
'Keyboard & Mouse Controls'x.Font=Enum.Font.ArialBold x.FontSize=Enum.FontSize.
Size36 x.Position=UDim2.new(0,0,0.025,0)x.Size=UDim2.new(1,0,0,40)x.TextColor3=
Color3.new(1,1,1)x.BackgroundTransparency=1 x.Parent=w local y=Instance.new
'Frame'y.Name='Buttons'y.Position=UDim2.new(0.1,0,0.07,40)y.Size=UDim2.new(0.8,0
,0,45)y.BackgroundTransparency=1 y.Parent=w local z=Instance.new'Frame'z.Name=
'ImageFrame'z.Position=UDim2.new(0.05,0,0.075,80)z.Size=UDim2.new(0.9,0,0.9,-120
)z.BackgroundTransparency=1 z.Parent=w local A=Instance.new'Frame'A.Name=
'LayoutFrame'A.Position=UDim2.new(0.5,0,0,0)A.Size=UDim2.new(1.5,0,1,0)A.
BackgroundTransparency=1 A.SizeConstraint=Enum.SizeConstraint.RelativeYY A.
Parent=z local B=Instance.new'ImageLabel'B.Name='Image'if UserSettings().
GameSettings.ControlMode==Enum.ControlMode['Mouse Lock Switch']then B.Image=f
else B.Image=g end B.Position=UDim2.new(-0.5,0,0,0)B.Size=UDim2.new(1,0,1,0)B.
BackgroundTransparency=1 B.Parent=A local C={}C[1]={}C[1].Text='Look'C[1].
Function=function()if UserSettings().GameSettings.ControlMode==Enum.ControlMode[
'Mouse Lock Switch']then B.Image=f else B.Image=g end end C[2]={}C[2].Text=
'Move'C[2].Function=function()B.Image='http://www.roblox.com/Asset?id=45915811'
end C[3]={}C[3].Text='Gear'C[3].Function=function()B.Image=
'http://www.roblox.com/Asset?id=45917596'end C[4]={}C[4].Text='Zoom'C[4].
Function=function()B.Image='http://www.roblox.com/Asset?id=45915825'end
CreateTextButtons(y,C,UDim.new(0,0),UDim.new(1,0))delay(0,function()
waitForChild(a,'UserSettingsShield')waitForChild(a.UserSettingsShield,'Settings'
)waitForChild(a.UserSettingsShield.Settings,'SettingsStyle')waitForChild(a.
UserSettingsShield.Settings.SettingsStyle,'GameSettingsMenu')waitForChild(a.
UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu,'CameraField')
waitForChild(a.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.
CameraField,'DropDownMenuButton')a.UserSettingsShield.Settings.SettingsStyle.
GameSettingsMenu.CameraField.DropDownMenuButton.Changed:connect(function(D)if D
~='Text'then return end if y.Button1.Style==Enum.ButtonStyle.RobloxButtonDefault
then if a.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField
.DropDownMenuButton.Text=='Classic'then B.Image=g else B.Image=f end end end)end
)local D=Instance.new'TextButton'D.Name='OkBtn'D.Text='OK'D.Modal=true D.Size=
UDim2.new(0.3,0,0,45)D.Position=UDim2.new(0.35,0,0.975,-50)D.Font=Enum.Font.
Arial D.FontSize=Enum.FontSize.Size18 D.BackgroundTransparency=1 D.TextColor3=
Color3.new(1,1,1)D.Style=Enum.ButtonStyle.RobloxButtonDefault D.
MouseButton1Click:connect(function()v.Visible=false game.GuiService:
RemoveCenterDialog(v)end)D.Parent=w robloxLock(v)return v end local function
createLeaveConfirmationMenu(u,v)local w=Instance.new'Frame'w.Name=
'LeaveConfirmationMenu'w.BackgroundTransparency=1 w.Size=UDim2.new(1,0,1,0)w.
Position=UDim2.new(0,0,2,400)w.ZIndex=u+4 local x=createTextButton('Leave',Enum.
ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,
313,0.8,0))x.Name='YesButton'x.ZIndex=u+4 x.Parent=w x.Modal=true x:SetVerb
'Exit'local y=createTextButton('Stay',Enum.ButtonStyle.RobloxButtonDefault,Enum.
FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,90,0.8,0))y.Name='NoButton'y.
Parent=w y.ZIndex=u+4 y.MouseButton1Click:connect(function()goToMenu(v.Settings.
SettingsStyle,'GameMainMenu','down',UDim2.new(0,525,0,430))v.Settings:TweenSize(
UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)
end)local z=Instance.new'TextLabel'z.Name='LeaveText'z.Text='Leave this game?'z.
Size=UDim2.new(1,0,0.8,0)z.TextWrap=true z.TextColor3=Color3.new(1,1,1)z.Font=
Enum.Font.ArialBold z.FontSize=Enum.FontSize.Size36 z.BackgroundTransparency=1 z
.ZIndex=u+4 z.Parent=w return w end local function createResetConfirmationMenu(u
,v)local w=Instance.new'Frame'w.Name='ResetConfirmationMenu'w.
BackgroundTransparency=1 w.Size=UDim2.new(1,0,1,0)w.Position=UDim2.new(0,0,2,400
)w.ZIndex=u+4 local x=createTextButton('Reset',Enum.ButtonStyle.
RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,313,0
,299))x.Name='YesButton'x.ZIndex=u+4 x.Parent=w x.Modal=true x.MouseButton1Click
:connect(function()resumeGameFunction(v)resetLocalCharacter()end)local y=
createTextButton('Cancel',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,
UDim2.new(0,128,0,50),UDim2.new(0,90,0,299))y.Name='NoButton'y.Parent=w y.ZIndex
=u+4 y.MouseButton1Click:connect(function()goToMenu(v.Settings.SettingsStyle,
'GameMainMenu','down',UDim2.new(0,525,0,430))v.Settings:TweenSize(UDim2.new(0,
525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)end)local z=
Instance.new'TextLabel'z.Name='ResetCharacterText'z.Text=
'Are you sure you want to reset your character?'z.Size=UDim2.new(1,0,0.8,0)z.
TextWrap=true z.TextColor3=Color3.new(1,1,1)z.Font=Enum.Font.ArialBold z.
FontSize=Enum.FontSize.Size36 z.BackgroundTransparency=1 z.ZIndex=u+4 z.Parent=w
local A=z:Clone()A.Name='FineResetCharacterText'A.Text=
'You will be put back on a spawn point'A.Size=UDim2.new(0,303,0,18)A.Position=
UDim2.new(0,109,0,215)A.FontSize=Enum.FontSize.Size18 A.Parent=w return w end
local function createGameMainMenu(u,v)local w=Instance.new'Frame'w.Name=
'GameMainMenu'w.BackgroundTransparency=1 w.Size=UDim2.new(1,0,1,0)w.ZIndex=u+4 w
.Parent=settingsFrame local x=Instance.new'TextLabel'x.Name='Title'x.Text=
'Game Menu'x.BackgroundTransparency=1 x.TextStrokeTransparency=0 x.Font=Enum.
Font.ArialBold x.FontSize=Enum.FontSize.Size36 x.Size=UDim2.new(1,0,0,36)x.
Position=UDim2.new(0,0,0,4)x.TextColor3=Color3.new(1,1,1)x.ZIndex=u+4 x.Parent=w
local y=createTextButton('Help',Enum.ButtonStyle.RobloxButton,Enum.FontSize.
Size18,UDim2.new(0,164,0,50),UDim2.new(0,82,0,256))y.Name='HelpButton'y.ZIndex=u
+4 y.Parent=w b=y local z=createHelpDialog(u)z.Parent=a b.MouseButton1Click:
connect(function()table.insert(o,z)game.GuiService:AddCenterDialog(z,Enum.
CenterDialogType.ModalDialog,function()z.Visible=true p.Visible=false end,
function()z.Visible=false end)end)b.Active=true local A=Instance.new'TextLabel'A
.Name='HelpShortcutText'A.Text='F1'A.Visible=false A.BackgroundTransparency=1 A.
Font=Enum.Font.Arial A.FontSize=Enum.FontSize.Size12 A.Position=UDim2.new(0,85,0
,0)A.Size=UDim2.new(0,30,0,30)A.TextColor3=Color3.new(0,1,0)A.ZIndex=u+4 A.
Parent=y local B=createTextButton('Screenshot',Enum.ButtonStyle.RobloxButton,
Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.new(0,254,0,256))B.Name=
'ScreenshotButton'B.ZIndex=u+4 B.Parent=w B.Visible=not r B:SetVerb'Screenshot'
local C=A:clone()C.Name='ScreenshotShortcutText'C.Text='PrintSc'C.Position=UDim2
.new(0,118,0,0)C.Visible=true C.Parent=B local D=createTextButton('Record Video'
,Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.
new(0,254,0,306))D.Name='RecordVideoButton'D.ZIndex=u+4 D.Parent=w D.Visible=not
r D:SetVerb'RecordToggle'local E=A:clone()E.Visible=h E.Name=
'RecordVideoShortcutText'E.Text='F12'E.Position=UDim2.new(0,120,0,0)E.Parent=D
local F=Instance.new'ImageButton'F.Name='StopRecordButton'F.
BackgroundTransparency=1 F.Image='rbxasset://textures/ui/RecordStop.png'F.Size=
UDim2.new(0,59,0,27)F:SetVerb'RecordToggle'F.MouseButton1Click:connect(function(
)recordVideoClick(D,F)end)F.Visible=false F.Parent=a local G=createTextButton(
'Report Abuse',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,
164,0,50),UDim2.new(0,82,0,306))G.Name='ReportAbuseButton'G.ZIndex=u+4 G.Parent=
w local H=createTextButton('Leave Game',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,358))H.Name=
'LeaveGameButton'H.ZIndex=u+4 H.Parent=w local I=createTextButton('Resume Game',
Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,340,0,50),
UDim2.new(0,82,0,54))I.Name='resumeGameButton'I.ZIndex=u+4 I.Parent=w I.Modal=
true I.MouseButton1Click:connect(function()resumeGameFunction(v)end)local J=
createTextButton('Game Settings',Enum.ButtonStyle.RobloxButton,Enum.FontSize.
Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,156))J.Name='SettingsButton'J.
ZIndex=u+4 J.Parent=w if game:FindFirstChild'LoadingGuiService'and#game.
LoadingGuiService:GetChildren()>0 then local K=createTextButton(
'Game Instructions',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.
new(0,340,0,50),UDim2.new(0,82,0,207))K.Name='GameInstructions'K.ZIndex=u+4 K.
Parent=w K.MouseButton1Click:connect(function()if game:FindFirstChild'Players'
and game.Players['LocalPlayer']then local L=game.Players.LocalPlayer:
FindFirstChild'PlayerLoadingGui'if L then L.Visible=true end end end)end local K
=createTextButton('Reset Character',Enum.ButtonStyle.RobloxButton,Enum.FontSize.
Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,105))K.Name='ResetButton'K.ZIndex=
u+4 K.Parent=w return w end local function createGameSettingsMenu(u,v)local w=
Instance.new'Frame'w.Name='GameSettingsMenu'w.BackgroundTransparency=1 w.Size=
UDim2.new(1,0,1,0)w.ZIndex=u+4 local x=Instance.new'TextLabel'x.Name='Title'x.
Text='Settings'x.Size=UDim2.new(1,0,0,48)x.Position=UDim2.new(0,9,0,-9)x.Font=
Enum.Font.ArialBold x.FontSize=Enum.FontSize.Size36 x.TextColor3=Color3.new(1,1,
1)x.ZIndex=u+4 x.BackgroundTransparency=1 x.Parent=w local y=Instance.new
'TextLabel'y.Name='FullscreenText'y.Text='Fullscreen Mode'y.Size=UDim2.new(0,124
,0,18)y.Position=UDim2.new(0,62,0,145)y.Font=Enum.Font.Arial y.FontSize=Enum.
FontSize.Size18 y.TextColor3=Color3.new(1,1,1)y.ZIndex=u+4 y.
BackgroundTransparency=1 y.Parent=w local z=Instance.new'TextLabel'z.Visible=h z
.Name='FullscreenShortcutText'z.Text='F11'z.BackgroundTransparency=1 z.Font=Enum
.Font.Arial z.FontSize=Enum.FontSize.Size12 z.Position=UDim2.new(0,186,0,141)z.
Size=UDim2.new(0,30,0,30)z.TextColor3=Color3.new(0,1,0)z.ZIndex=u+4 z.Parent=w
local A=Instance.new'TextLabel'A.Visible=false A.Name='StudioText'A.Text=
'Studio Mode'A.Size=UDim2.new(0,95,0,18)A.Position=UDim2.new(0,62,0,179)A.Font=
Enum.Font.Arial A.FontSize=Enum.FontSize.Size18 A.TextColor3=Color3.new(1,1,1)A.
ZIndex=u+4 A.BackgroundTransparency=1 A.Parent=w local B=z:clone()B.Name=
'StudioShortcutText'B.Visible=false B.Text='F2'B.Position=UDim2.new(0,154,0,175)
B.Parent=w local C=nil if h then local D=Instance.new'TextLabel'D.Name=
'QualityText'D.Text='Graphics Quality'D.Size=UDim2.new(0,128,0,18)D.Position=
UDim2.new(0,30,0,239)D.Font=Enum.Font.Arial D.FontSize=Enum.FontSize.Size18 D.
TextColor3=Color3.new(1,1,1)D.ZIndex=u+4 D.BackgroundTransparency=1 D.Parent=w D
.Visible=not q local E=D:clone()E.Name='AutoText'E.Text='Auto'E.Position=UDim2.
new(0,183,0,214)E.TextColor3=Color3.new(0.5019607843137255,0.5019607843137255,
0.5019607843137255)E.Size=UDim2.new(0,34,0,18)E.Parent=w E.Visible=not q local F
=E:clone()F.Name='FasterText'F.Text='Faster'F.Position=UDim2.new(0,185,0,274)F.
TextColor3=Color3.new(95,95,95)F.FontSize=Enum.FontSize.Size14 F.Parent=w F.
Visible=not q local G=z:clone()G.Name='FasterShortcutText'G.Text='F10 + Shift'G.
Position=UDim2.new(0,185,0,283)G.Parent=w G.Visible=not q local H=E:clone()H.
Name='BetterQualityText'H.Text='Better Quality'H.TextWrap=true H.Size=UDim2.new(
0,41,0,28)H.Position=UDim2.new(0,390,0,269)H.TextColor3=Color3.new(95,95,95)H.
FontSize=Enum.FontSize.Size14 H.Parent=w H.Visible=not q local I=z:clone()I.Name
='BetterQualityShortcut'I.Text='F10'I.Position=UDim2.new(0,394,0,288)I.Parent=w
I.Visible=not q local J=createTextButton('X',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,187,0,239))J.Name=
'AutoGraphicsButton'J.ZIndex=u+4 J.Parent=w J.Visible=not q local K,L=RbxGui.
CreateSlider(i,150,UDim2.new(0,230,0,280))K.Parent=w K.Bar.ZIndex=u+4 K.Bar.
Slider.ZIndex=u+5 K.Visible=not q L.Value=math.floor((settings().Rendering:
GetMaxQualityLevel()-1)/2)local M=Instance.new'TextBox'M.Name='GraphicsSetter'M.
BackgroundColor3=Color3.new(0,0,0)M.BorderColor3=Color3.new(0.5019607843137255,
0.5019607843137255,0.5019607843137255)M.Size=UDim2.new(0,50,0,25)M.Position=
UDim2.new(0,450,0,269)M.TextColor3=Color3.new(1,1,1)M.Font=Enum.Font.Arial M.
FontSize=Enum.FontSize.Size18 M.Text='Auto'M.ZIndex=1 M.TextWrap=true M.Parent=w
M.Visible=not q local N=true if not q then N=(UserSettings().GameSettings.
SavedQualityLevel==Enum.SavedQualitySetting.Automatic)else settings().Rendering.
EnableFRM=false end local O=true local function setAutoGraphicsGui(P)N=P if P
then J.Text='X'H.ZIndex=1 I.ZIndex=1 G.ZIndex=1 F.ZIndex=1 K.Bar.ZIndex=1 K.Bar.
Slider.ZIndex=1 M.ZIndex=1 M.Text='Auto'else J.Text=''K.Bar.ZIndex=u+4 K.Bar.
Slider.ZIndex=u+5 I.ZIndex=u+4 G.ZIndex=u+4 H.ZIndex=u+4 F.ZIndex=u+4 M.ZIndex=u
+4 end end local function goToAutoGraphics()setAutoGraphicsGui(true)
UserSettings().GameSettings.SavedQualityLevel=Enum.SavedQualitySetting.Automatic
settings().Rendering.QualityLevel=Enum.QualityLevel.Automatic end local function
setGraphicsQualityLevel(P)local Q=P/i local R=math.floor((settings().Rendering:
GetMaxQualityLevel()-1)*Q)if R==20 then R=21 elseif P==1 then R=1 elseif R>
settings().Rendering:GetMaxQualityLevel()then R=settings().Rendering:
GetMaxQualityLevel()-1 end UserSettings().GameSettings.SavedQualityLevel=P
settings().Rendering.QualityLevel=R end local function goToManualGraphics(P)
setAutoGraphicsGui(false)if P then L.Value=P else L.Value=math.floor((settings()
.Rendering.AutoFRMLevel/(settings().Rendering:GetMaxQualityLevel()-1))*i)end if
P==L.Value then setGraphicsQualityLevel(L.Value)end if not P then UserSettings()
.GameSettings.SavedQualityLevel=L.Value end M.Text=tostring(L.Value)end
local function showAutoGraphics()E.ZIndex=u+4 J.ZIndex=u+4 end local function
hideAutoGraphics()E.ZIndex=1 J.ZIndex=1 end local function showManualGraphics()K
.Bar.ZIndex=u+4 K.Bar.Slider.ZIndex=u+5 I.ZIndex=u+4 G.ZIndex=u+4 H.ZIndex=u+4 F
.ZIndex=u+4 M.ZIndex=u+4 end local function hideManualGraphics()H.ZIndex=1 I.
ZIndex=1 G.ZIndex=1 F.ZIndex=1 K.Bar.ZIndex=1 K.Bar.Slider.ZIndex=1 M.ZIndex=1
end local function translateSavedQualityLevelToInt(P)if P==Enum.
SavedQualitySetting.Automatic then return 0 elseif P==Enum.SavedQualitySetting.
QualityLevel1 then return 1 elseif P==Enum.SavedQualitySetting.QualityLevel2
then return 2 elseif P==Enum.SavedQualitySetting.QualityLevel3 then return 3
elseif P==Enum.SavedQualitySetting.QualityLevel4 then return 4 elseif P==Enum.
SavedQualitySetting.QualityLevel5 then return 5 elseif P==Enum.
SavedQualitySetting.QualityLevel6 then return 6 elseif P==Enum.
SavedQualitySetting.QualityLevel7 then return 7 elseif P==Enum.
SavedQualitySetting.QualityLevel8 then return 8 elseif P==Enum.
SavedQualitySetting.QualityLevel9 then return 9 elseif P==Enum.
SavedQualitySetting.QualityLevel10 then return 10 end end local function
enableGraphicsWidget()settings().Rendering.EnableFRM=true N=(UserSettings().
GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.Automatic)if N then
showAutoGraphics()goToAutoGraphics()else showAutoGraphics()showManualGraphics()
goToManualGraphics(translateSavedQualityLevelToInt(UserSettings().GameSettings.
SavedQualityLevel))end end local function disableGraphicsWidget()
hideManualGraphics()hideAutoGraphics()settings().Rendering.EnableFRM=false end M
.FocusLost:connect(function()if N then M.Text=tostring(L.Value)return end local
P=tonumber(M.Text)if P==nil then M.Text=tostring(L.Value)return end if P<1 then
P=1 elseif P>=settings().Rendering:GetMaxQualityLevel()then P=settings().
Rendering:GetMaxQualityLevel()-1 end L.Value=P setGraphicsQualityLevel(L.Value)M
.Text=tostring(L.Value)end)L.Changed:connect(function(P)if N then return end if
not O then return end M.Text=tostring(L.Value)setGraphicsQualityLevel(L.Value)
end)if q or UserSettings().GameSettings.SavedQualityLevel==Enum.
SavedQualitySetting.Automatic then if q then settings().Rendering.EnableFRM=
false disableGraphicsWidget()else settings().Rendering.EnableFRM=true
goToAutoGraphics()end else settings().Rendering.EnableFRM=true
goToManualGraphics(translateSavedQualityLevelToInt(UserSettings().GameSettings.
SavedQualityLevel))end J.MouseButton1Click:connect(function()if q and not game.
Players.LocalPlayer then return end if not N then goToAutoGraphics()else
goToManualGraphics(L.Value)end end)game.GraphicsQualityChangeRequest:connect(
function(P)if N then return end if P then if(L.Value+1)>i then return end L.
Value=L.Value+1 M.Text=tostring(L.Value)setGraphicsQualityLevel(L.Value)game:
GetService'GuiService':SendNotification('Graphics Quality','Increased to ('..M.
Text..')','',2,function()end)else if(L.Value-1)<=0 then return end L.Value=L.
Value-1 M.Text=tostring(L.Value)setGraphicsQualityLevel(L.Value)game:GetService
'GuiService':SendNotification('Graphics Quality','Decreased to ('..M.Text..')',
'',2,function()end)end end)game.Players.PlayerAdded:connect(function(P)if P==
game.Players.LocalPlayer and q then enableGraphicsWidget()end end)game.Players.
PlayerRemoving:connect(function(P)if P==game.Players.LocalPlayer and q then
disableGraphicsWidget()end end)C=createTextButton('',Enum.ButtonStyle.
RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,30,0,176))C.
Name='StudioCheckbox'C.ZIndex=u+4 C:SetVerb'TogglePlayMode'C.Visible=false local
P=(settings().Rendering.QualityLevel~=Enum.QualityLevel.Automatic)if q and not
game.Players.LocalPlayer then C.Text='X'disableGraphicsWidget()elseif q then C.
Text='X'enableGraphicsWidget()end if h then UserSettings().GameSettings.
StudioModeChanged:connect(function(Q)q=Q if Q then P=(settings().Rendering.
QualityLevel~=Enum.QualityLevel.Automatic)goToAutoGraphics()C.Text='X'J.ZIndex=1
E.ZIndex=1 else if P then goToManualGraphics()end C.Text=''J.ZIndex=u+4 E.ZIndex
=u+4 end end)else C.MouseButton1Click:connect(function()if not C.Active then
return end if C.Text==''then C.Text='X'else C.Text=''end end)end end local D=
createTextButton('',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.
new(0,25,0,25),UDim2.new(0,30,0,144))D.Name='FullscreenCheckbox'D.ZIndex=u+4 D.
Parent=w D:SetVerb'ToggleFullScreen'if UserSettings().GameSettings:InFullScreen(
)then D.Text='X'end if h then UserSettings().GameSettings.FullscreenChanged:
connect(function(E)if E then D.Text='X'else D.Text=''end end)else D.
MouseButton1Click:connect(function()if D.Text==''then D.Text='X'else D.Text=''
end end)end if game:FindFirstChild'NetworkClient'then setDisabledState(A)
setDisabledState(B)setDisabledState(C)end local E if h then E=createTextButton(
'OK',Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0
,50),UDim2.new(0,170,0,330))E.Modal=true else E=createTextButton('OK',Enum.
ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2
.new(0,170,0,270))E.Modal=true end E.Name='BackButton'E.ZIndex=u+4 E.Parent=w
local F if not r then local G=Instance.new'TextLabel'G.Name='VideoCaptureLabel'G
.Text='After Capturing Video'G.Font=Enum.Font.Arial G.FontSize=Enum.FontSize.
Size18 G.Position=UDim2.new(0,32,0,100)G.Size=UDim2.new(0,164,0,18)G.
BackgroundTransparency=1 G.TextColor3=Color3I(255,255,255)G.TextXAlignment=Enum.
TextXAlignment.Left G.ZIndex=u+4 G.Parent=w local H,I={},{}H[1]=
'Just Save to Disk'I[H[1]]=Enum.UploadSetting['Never']H[2]='Upload to YouTube'I[
H[2]]=Enum.UploadSetting['Ask me first']local J=nil J,d=RbxGui.
CreateDropDownMenu(H,function(K)UserSettings().GameSettings.
VideoUploadPromptBehavior=I[K]end)J.Name='VideoCaptureField'J.ZIndex=u+4 J.
DropDownMenuButton.ZIndex=u+4 J.DropDownMenuButton.Icon.ZIndex=u+4 J.Position=
UDim2.new(0,270,0,94)J.Size=UDim2.new(0,200,0,32)J.Parent=w F=function()if
UserSettings().GameSettings.VideoUploadPromptBehavior==Enum.UploadSetting[
'Never']then d(H[1])elseif UserSettings().GameSettings.VideoUploadPromptBehavior
==Enum.UploadSetting['Ask me first']then d(H[2])else UserSettings().GameSettings
.VideoUploadPromptBehavior=Enum.UploadSetting['Ask me first']d(H[2])end end end
local G=Instance.new'TextLabel'G.Name='CameraLabel'G.Text=
'Character & Camera Controls'G.Font=Enum.Font.Arial G.FontSize=Enum.FontSize.
Size18 G.Position=UDim2.new(0,31,0,58)G.Size=UDim2.new(0,224,0,18)G.TextColor3=
Color3I(255,255,255)G.TextXAlignment=Enum.TextXAlignment.Left G.
BackgroundTransparency=1 G.ZIndex=u+4 G.Parent=w local H,I,J,K=game.CoreGui.
RobloxGui:FindFirstChild('MouseLockLabel',true),Enum.ControlMode:GetEnumItems(),
{},{}for L,M in ipairs(I)do J[L]=M.Name K[M.Name]=M end local N N,c=RbxGui.
CreateDropDownMenu(J,function(O)UserSettings().GameSettings.ControlMode=K[O]
pcall(function()if H and UserSettings().GameSettings.ControlMode==Enum.
ControlMode['Mouse Lock Switch']then H.Visible=true elseif H then H.Visible=
false end end)end)N.Name='CameraField'N.ZIndex=u+4 N.DropDownMenuButton.ZIndex=u
+4 N.DropDownMenuButton.Icon.ZIndex=u+4 N.Position=UDim2.new(0,270,0,52)N.Size=
UDim2.new(0,200,0,32)N.Parent=w return w end if LoadLibrary then RbxGui=
LoadLibrary'RbxGui'local u=0 if UserSettings then local v=function()
waitForChild(a,'BottomLeftControl')settingsButton=a.BottomLeftControl:
FindFirstChild'SettingsButton'if settingsButton==nil then settingsButton=
Instance.new'ImageButton'settingsButton.Name='SettingsButton'settingsButton.
Image='rbxasset://textures/ui/SettingsButton.png'settingsButton.
BackgroundTransparency=1 settingsButton.Active=false settingsButton.Size=UDim2.
new(0,54,0,46)settingsButton.Position=UDim2.new(0,2,0,50)settingsButton.Parent=a
.BottomLeftControl end local v=Instance.new'TextButton'v.Text=''v.Name=
'UserSettingsShield'v.Active=true v.AutoButtonColor=false v.Visible=false v.Size
=UDim2.new(1,0,1,0)v.BackgroundColor3=Color3I(51,51,51)v.BorderColor3=Color3I(27
,42,53)v.BackgroundTransparency=0.4 v.ZIndex=u+2 p=v local w=Instance.new'Frame'
w.Name='Settings'w.Position=UDim2.new(0.5,-262,-0.5,-200)w.Size=UDim2.new(0,525,
0,430)w.BackgroundTransparency=1 w.Active=true w.Parent=v local x=Instance.new
'Frame'x.Name='SettingsStyle'x.Size=UDim2.new(1,0,1,0)x.Style=Enum.FrameStyle.
RobloxRound x.Active=true x.ZIndex=u+3 x.Parent=w local y=createGameMainMenu(u,v
)y.Parent=x y.ScreenshotButton.MouseButton1Click:connect(function()backToGame(y.
ScreenshotButton,v,settingsButton)end)y.RecordVideoButton.MouseButton1Click:
connect(function()recordVideoClick(y.RecordVideoButton,a.StopRecordButton)
backToGame(y.RecordVideoButton,v,settingsButton)end)if settings():FindFirstChild
'Game Options'then pcall(function()settings():FindFirstChild'Game Options'.
VideoRecordingChangeRequest:connect(function(z)j=z setRecordGui(z,a.
StopRecordButton,y.RecordVideoButton)end)end)end game.CoreGui.RobloxGui.Changed:
connect(function(z)if z=='AbsoluteSize'and j then recordVideoClick(y.
RecordVideoButton,a.StopRecordButton)end end)function localPlayerChange()y.
ResetButton.Visible=game.Players.LocalPlayer if game.Players.LocalPlayer then
settings().Rendering.EnableFRM=true elseif q then settings().Rendering.EnableFRM
=false end end y.ResetButton.Visible=game.Players.LocalPlayer if game.Players.
LocalPlayer~=nil then game.Players.LocalPlayer.Changed:connect(function()
localPlayerChange()end)else delay(0,function()waitForProperty(game.Players,
'LocalPlayer')y.ResetButton.Visible=game.Players.LocalPlayer game.Players.
LocalPlayer.Changed:connect(function()localPlayerChange()end)end)end y.
ReportAbuseButton.Visible=game:FindFirstChild'NetworkClient'if not y.
ReportAbuseButton.Visible then game.ChildAdded:connect(function(z)if z:IsA
'NetworkClient'then y.ReportAbuseButton.Visible=game:FindFirstChild
'NetworkClient'end end)end y.ResetButton.MouseButton1Click:connect(function()
goToMenu(x,'ResetConfirmationMenu','up',UDim2.new(0,525,0,370))end)y.
LeaveGameButton.MouseButton1Click:connect(function()goToMenu(x,
'LeaveConfirmationMenu','down',UDim2.new(0,525,0,300))end)if game.CoreGui.
Version>=4 then game:GetService'GuiService'.EscapeKeyPressed:connect(function()
if k==nil then game.GuiService:AddCenterDialog(v,Enum.CenterDialogType.
ModalDialog,function()settingsButton.Active=false c(UserSettings().GameSettings.
ControlMode.Name)if syncVideoCaptureSetting then syncVideoCaptureSetting()end
goToMenu(x,'GameMainMenu','right',UDim2.new(0,525,0,430))v.Visible=true v.Active
=true x.Parent:TweenPosition(UDim2.new(0.5,-262,0.5,-200),Enum.EasingDirection.
InOut,Enum.EasingStyle.Sine,e,true)x.Parent:TweenSize(UDim2.new(0,525,0,430),
Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)end,function()x.Parent:
TweenPosition(UDim2.new(0.5,-262,-0.5,-200),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)x.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)v.Visible=false
settingsButton.Active=true end)elseif#l>0 then if#o>0 then for z=1,#o do game.
GuiService:RemoveCenterDialog(o[z])o[z].Visible=false end o={}end goToMenu(l[#l]
['container'],l[#l]['name'],l[#l]['direction'],l[#l]['lastSize'])table.remove(l,
#l)if#l==1 then l={}end else resumeGameFunction(v)end end)end local z=
createGameSettingsMenu(u,v)z.Visible=false z.Parent=x y.SettingsButton.
MouseButton1Click:connect(function()goToMenu(x,'GameSettingsMenu','left',UDim2.
new(0,525,0,350))end)z.BackButton.MouseButton1Click:connect(function()goToMenu(x
,'GameMainMenu','right',UDim2.new(0,525,0,430))end)local A=
createResetConfirmationMenu(u,v)A.Visible=false A.Parent=x local B=
createLeaveConfirmationMenu(u,v)B.Visible=false B.Parent=x robloxLock(v)
settingsButton.MouseButton1Click:connect(function()game.GuiService:
AddCenterDialog(v,Enum.CenterDialogType.ModalDialog,function()settingsButton.
Active=false c(UserSettings().GameSettings.ControlMode.Name)if
syncVideoCaptureSetting then syncVideoCaptureSetting()end goToMenu(x,
'GameMainMenu','right',UDim2.new(0,525,0,430))v.Visible=true x.Parent:
TweenPosition(UDim2.new(0.5,-262,0.5,-200),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)x.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)end,function()x.Parent:
TweenPosition(UDim2.new(0.5,-262,-0.5,-200),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,e,true)x.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,e,true)v.Visible=false
settingsButton.Active=true end)end)return v end delay(0,function()v().Parent=a a
.BottomLeftControl.SettingsButton.Active=true a.BottomLeftControl.SettingsButton
.Position=UDim2.new(0,2,0,-2)if mouseLockLabel and UserSettings().GameSettings.
ControlMode==Enum.ControlMode['Mouse Lock Switch']then mouseLockLabel.Visible=
true elseif mouseLockLabel then mouseLockLabel.Visible=false end local w=a.
BottomLeftControl:FindFirstChild'Exit'if w then w:Remove()end local x=a:
FindFirstChild'TopLeftControl'if x then w=x:FindFirstChild'Exit'if w then w:
Remove()end x:Remove()end end)end local v,w,x,y=function()local v=Instance.new
'TextButton'v.Text=''v.AutoButtonColor=false v.Name='SaveDialogShield'v.Active=
true v.Visible=false v.Size=UDim2.new(1,0,1,0)v.BackgroundColor3=Color3I(51,51,
51)v.BorderColor3=Color3I(27,42,53)v.BackgroundTransparency=0.4 v.ZIndex=u+1
local w,x,y,z,A,B=nil,nil,nil,nil,nil,{}B[1]={}B[1].Text='Save'B[1].Style=Enum.
ButtonStyle.RobloxButtonDefault B[1].Function=function()x()end B[2]={}B[2].Text=
'Cancel'B[2].Function=function()A()end B[3]={}B[3].Text="Don't Save"B[3].
Function=function()z()end local C=RbxGui.CreateStyledMessageDialog(
'Unsaved Changes','Save your changes to ROBLOX before leaving?','Confirm',B)C.
Visible=true C.Parent=v local D,E={},1 if game.LocalSaveEnabled then D[E]={}D[E]
.Text='Save to Disk'D[E].Function=function()y()end E=E+1 end D[E]={}D[E].Text=
'Keep Playing'D[E].Function=function()A()end D[E+1]={}D[E+1].Text="Don't Save"D[
E+1].Function=function()z()end local F=RbxGui.CreateStyledMessageDialog(
'Upload Failed','Sorry, we could not save your changes to ROBLOX.','Error',D)F.
Visible=false F.Parent=v local G=Instance.new'Frame'G.Name='SpinnerDialog'G.
Style=Enum.FrameStyle.RobloxRound G.Size=UDim2.new(0,350,0,150)G.Position=UDim2.
new(0.5,-175,0.5,-75)G.Visible=false G.Active=true G.Parent=v local H=Instance.
new'TextLabel'H.Name='WaitingLabel'H.Text='Saving to ROBLOX...'H.Font=Enum.Font.
ArialBold H.FontSize=Enum.FontSize.Size18 H.Position=UDim2.new(0.5,25,0.5,0)H.
TextColor3=Color3.new(1,1,1)H.Parent=G local I=Instance.new'Frame'I.Name=
'Spinner'I.Size=UDim2.new(0,80,0,80)I.Position=UDim2.new(0.5,-150,0.5,-40)I.
BackgroundTransparency=1 I.Parent=G local J,K={},1 while K<=8 do local L=
Instance.new'ImageLabel'L.Name='Spinner'..K L.Size=UDim2.new(0,16,0,16)L.
Position=UDim2.new(0.5+0.3*math.cos(math.rad(45*K)),-8,0.5+0.3*math.sin(math.
rad(45*K)),-8)L.BackgroundTransparency=1 L.Image=
'http://www.roblox.com/Asset?id=45880710'L.Parent=I J[K]=L K=K+1 end x=function(
)C.Visible=false G.Visible=true local L=true delay(0,function()local M=0 while L
do local N=0 while N<8 do if N==M or N==((M+1)%8)then J[N+1].Image=
'http://www.roblox.com/Asset?id=45880668'else J[N+1].Image=
'http://www.roblox.com/Asset?id=45880710'end N=N+1 end M=(M+1)%8 wait(0.2)end
end)local M=game:SaveToRoblox()if not M then M=game:SaveToRoblox()end G.Visible=
false L=false if M then game:FinishShutdown(false)w()else F.Visible=true end end
y=function()F.Visible=false game:FinishShutdown(true)w()end z=function()C.
Visible=false F.Visible=false game:FinishShutdown(false)w()end A=function()C.
Visible=false F.Visible=false w()end w=function()C.Visible=true F.Visible=false
G.Visible=false v.Visible=false game.GuiService:RemoveCenterDialog(v)end
robloxLock(v)v.Visible=false return v end,function()waitForChild(game,
'NetworkClient')waitForChild(game,'Players')waitForProperty(game.Players,
'LocalPlayer')local v,w=game.Players.LocalPlayer,nil waitForChild(a,
'UserSettingsShield')waitForChild(a.UserSettingsShield,'Settings')waitForChild(a
.UserSettingsShield.Settings,'SettingsStyle')waitForChild(a.UserSettingsShield.
Settings.SettingsStyle,'GameMainMenu')waitForChild(a.UserSettingsShield.Settings
.SettingsStyle.GameMainMenu,'ReportAbuseButton')w=a.UserSettingsShield.Settings.
SettingsStyle.GameMainMenu.ReportAbuseButton local x=Instance.new'TextButton'x.
Name='ReportAbuseShield'x.Text=''x.AutoButtonColor=false x.Active=true x.Visible
=false x.Size=UDim2.new(1,0,1,0)x.BackgroundColor3=Color3I(51,51,51)x.
BorderColor3=Color3I(27,42,53)x.BackgroundTransparency=0.4 x.ZIndex=u+1 local y,
z=nil,{}z[1]={}z[1].Text='Ok'z[1].Modal=true z[1].Function=function()
closeAndResetDialog()end local A=RbxGui.CreateMessageDialog(
'Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.

If anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats]]
,z)A.Visible=false A.Parent=x local B=RbxGui.CreateMessageDialog(
'Thanks for your report!',"We've recorded your report for evaluation.",z)B.
Visible=false B.Parent=x local C=RbxGui.CreateMessageDialog(
'Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened.]],z)C.
Visible=false C.Parent=x local D=Instance.new'Frame'D.Name='Settings'D.Position=
UDim2.new(0.5,-250,0.5,-200)D.Size=UDim2.new(0,500,0,400)D.
BackgroundTransparency=1 D.Active=true D.Parent=x local E=Instance.new'Frame'E.
Name='ReportAbuseStyle'E.Size=UDim2.new(1,0,1,0)E.Style=Enum.FrameStyle.
RobloxRound E.Active=true E.ZIndex=u+1 E.Parent=D local F=Instance.new
'TextLabel'F.Name='Title'F.Text='Report Abuse'F.TextColor3=Color3I(221,221,221)F
.Position=UDim2.new(0.5,0,0,30)F.Font=Enum.Font.ArialBold F.FontSize=Enum.
FontSize.Size36 F.ZIndex=u+2 F.Parent=E local G=Instance.new'TextLabel'G.Name=
'Description'G.Text=
[[This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.]]
G.TextColor3=Color3I(221,221,221)G.Position=UDim2.new(0,0,0,55)G.Size=UDim2.new(
1,0,0,40)G.BackgroundTransparency=1 G.Font=Enum.Font.Arial G.FontSize=Enum.
FontSize.Size18 G.TextWrap=true G.ZIndex=u+2 G.TextXAlignment=Enum.
TextXAlignment.Left G.TextYAlignment=Enum.TextYAlignment.Top G.Parent=E local H=
Instance.new'TextLabel'H.Name='PlayerLabel'H.Text='Which player?'H.
BackgroundTransparency=1 H.Font=Enum.Font.Arial H.FontSize=Enum.FontSize.Size18
H.Position=UDim2.new(0.025,0,0,100)H.Size=UDim2.new(0.4,0,0,36)H.TextColor3=
Color3I(255,255,255)H.TextXAlignment=Enum.TextXAlignment.Left H.ZIndex=u+2 H.
Parent=E local I,J,K,L=nil,nil,nil,nil local M,N=function()local M,N,O=game:
GetService'Players',{},{}local P,Q=M:GetChildren(),1 if P then for R,S in
ipairs(P)do if S:IsA'Player'and S~=v then N[Q]=S.Name O[S.Name]=S Q=Q+1 end end
end local R=nil R,L=RbxGui.CreateDropDownMenu(N,function(S)I=O[S]if J and I then
K.Active=true end end)R.Name='PlayersComboBox'R.ZIndex=u+2 R.Position=UDim2.new(
0.425,0,0,102)R.Size=UDim2.new(0.55,0,0,32)return R end,Instance.new'TextLabel'N
.Name='AbuseLabel'N.Text='Type of Abuse:'N.Font=Enum.Font.Arial N.
BackgroundTransparency=1 N.FontSize=Enum.FontSize.Size18 N.Position=UDim2.new(
0.025,0,0,140)N.Size=UDim2.new(0.4,0,0,36)N.TextColor3=Color3I(255,255,255)N.
TextXAlignment=Enum.TextXAlignment.Left N.ZIndex=u+2 N.Parent=E local O={
'Swearing','Bullying','Scamming','Dating','Cheating/Exploiting',
'Personal Questions','Offsite Links','Bad Model or Script','Bad Username'}local
P,Q=RbxGui.CreateDropDownMenu(O,function(P)J=P if J and I then K.Active=true end
end,true)P.Name='AbuseComboBox'P.ZIndex=u+2 P.Position=UDim2.new(0.425,0,0,142)P
.Size=UDim2.new(0.55,0,0,32)P.Parent=E local R=Instance.new'TextLabel'R.Name=
'ShortDescriptionLabel'R.Text='Short Description: (optional)'R.Font=Enum.Font.
Arial R.FontSize=Enum.FontSize.Size18 R.Position=UDim2.new(0.025,0,0,180)R.Size=
UDim2.new(0.95,0,0,36)R.TextColor3=Color3I(255,255,255)R.TextXAlignment=Enum.
TextXAlignment.Left R.BackgroundTransparency=1 R.ZIndex=u+2 R.Parent=E local S=
Instance.new'Frame'S.Name='ShortDescriptionWrapper'S.Position=UDim2.new(0.025,0,
0,220)S.Size=UDim2.new(0.95,0,1,-310)S.BackgroundColor3=Color3I(0,0,0)S.
BorderSizePixel=0 S.ZIndex=u+2 S.Parent=E local T=Instance.new'TextBox'T.Name=
'TextBox'T.Text=''T.ClearTextOnFocus=false T.Font=Enum.Font.Arial T.FontSize=
Enum.FontSize.Size18 T.Position=UDim2.new(0,3,0,3)T.Size=UDim2.new(1,-6,1,-6)T.
TextColor3=Color3I(255,255,255)T.TextXAlignment=Enum.TextXAlignment.Left T.
TextYAlignment=Enum.TextYAlignment.Top T.TextWrap=true T.BackgroundColor3=
Color3I(0,0,0)T.BorderSizePixel=0 T.ZIndex=u+2 T.Parent=S K=Instance.new
'TextButton'K.Name='SubmitReportBtn'K.Active=false K.Modal=true K.Font=Enum.Font
.Arial K.FontSize=Enum.FontSize.Size18 K.Position=UDim2.new(0.1,0,1,-80)K.Size=
UDim2.new(0.35,0,0,50)K.AutoButtonColor=true K.Style=Enum.ButtonStyle.
RobloxButtonDefault K.Text='Submit Report'K.TextColor3=Color3I(255,255,255)K.
ZIndex=u+2 K.Parent=E K.MouseButton1Click:connect(function()if K.Active then if
J and I then D.Visible=false game.Players:ReportAbuse(I,J,T.Text)if J==
'Cheating/Exploiting'then B.Visible=true elseif J=='Bullying'or J=='Swearing'
then A.Visible=true else C.Visible=true end else closeAndResetDialog()end end
end)local U=Instance.new'TextButton'U.Name='CancelBtn'U.Font=Enum.Font.Arial U.
FontSize=Enum.FontSize.Size18 U.Position=UDim2.new(0.55,0,1,-80)U.Size=UDim2.
new(0.35,0,0,50)U.AutoButtonColor=true U.Style=Enum.ButtonStyle.
RobloxButtonDefault U.Text='Cancel'U.TextColor3=Color3I(255,255,255)U.ZIndex=u+2
U.Parent=E closeAndResetDialog=function()local V=E:FindFirstChild
'PlayersComboBox'if V then V.Parent=nil end I=nil L(nil)J=nil Q(nil)K.Active=
false T.Text=''D.Visible=true A.Visible=false B.Visible=false C.Visible=false x.
Visible=false w.Active=true game.GuiService:RemoveCenterDialog(x)end U.
MouseButton1Click:connect(closeAndResetDialog)w.MouseButton1Click:connect(
function()M().Parent=E table.insert(o,x)game.GuiService:AddCenterDialog(x,Enum.
CenterDialogType.ModalDialog,function()w.Active=false x.Visible=true p.Visible=
false end,function()w.Active=true x.Visible=false end)end)robloxLock(x)return x
end,function()waitForChild(game,'NetworkClient')waitForChild(game,'Players')
waitForProperty(game.Players,'LocalPlayer')local v=Instance.new'Frame'v.Name=
'ChatBar'v.Size=UDim2.new(1,0,0,22)v.Position=UDim2.new(0,0,1,0)v.
BackgroundColor3=Color3.new(0,0,0)v.BorderSizePixel=0 local w=Instance.new
'TextBox'w.Text=''w.Visible=false w.Size=UDim2.new(1,-4,1,0)w.Position=UDim2.
new(0,2,0,0)w.TextXAlignment=Enum.TextXAlignment.Left w.Font=Enum.Font.Arial w.
ClearTextOnFocus=false w.FontSize=Enum.FontSize.Size14 w.TextColor3=Color3.new(1
,1,1)w.BackgroundTransparency=1 local x=Instance.new'TextButton'x.Size=UDim2.
new(1,-4,1,0)x.Position=UDim2.new(0,2,0,0)x.AutoButtonColor=false x.Text=
'To chat click here or press "/" key'x.TextXAlignment=Enum.TextXAlignment.Left x
.Font=Enum.Font.Arial x.FontSize=Enum.FontSize.Size14 x.TextColor3=Color3.new(1,
1,1)x.BackgroundTransparency=1 local y=function()if w.Visible then return end x.
Visible=false w.Text=''w.Visible=true w:CaptureFocus()end x.MouseButton1Click:
connect(y)local z=function(z)end pcall(function()end)w.FocusLost:connect(
function(A)if A then if w.Text~=''then local B=w.Text if string.sub(B,1,1)=='%'
then game.Players:TeamChat(string.sub(B,2))else game.Players:Chat(B)end end end
w.Text=''w.Visible=false x.Visible=true end)robloxLock(v)return v,z end,pcall(
function()end)if y then delay(0,function()local z=v()z.Parent=a game.
RequestShutdown=function()table.insert(o,z)game.GuiService:AddCenterDialog(z,
Enum.CenterDialogType.QuitDialog,function()z.Visible=true end,function()z.
Visible=false end)return true end end)end delay(0,function()w().Parent=a
waitForChild(a,'UserSettingsShield')waitForChild(a.UserSettingsShield,'Settings'
)waitForChild(a.UserSettingsShield.Settings,'SettingsStyle')waitForChild(a.
UserSettingsShield.Settings.SettingsStyle,'GameMainMenu')waitForChild(a.
UserSettingsShield.Settings.SettingsStyle.GameMainMenu,'ReportAbuseButton')a.
UserSettingsShield.Settings.SettingsStyle.GameMainMenu.ReportAbuseButton.Active=
true end)pcall(function()return game.GuiService.UseLuaChat end)local z=41324860
delay(0,function()waitForChild(game,'NetworkClient')waitForChild(game,'Players')
waitForProperty(game.Players,'LocalPlayer')waitForProperty(game.Players.
LocalPlayer,'Character')waitForChild(game.Players.LocalPlayer.Character,
'Humanoid')waitForProperty(game,'PlaceId')if game.PlaceId==z then game.Players.
LocalPlayer.Character.Humanoid:SetClickToWalkEnabled(false)game.Players.
LocalPlayer.CharacterAdded:connect(function(A)waitForChild(A,'Humanoid')A.
Humanoid:SetClickToWalkEnabled(false)end)end end)end