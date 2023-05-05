print'[Mercury]: Loaded corescript 46295863'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b b=function(c,d)while not c:FindFirstChild(d)do c.
ChildAdded:wait()end end local c c=function(d,e)while not d[e]do d.Changed:wait(
)end end local d if script.Parent:FindFirstChild'ControlFrame'then d=script.
Parent:FindFirstChild'ControlFrame'else d=script.Parent end local e,f,g,h,i,j,k,
l,m,n,o,p,q,r,s,t,u=nil,nil,nil,0.2,'http://www.roblox.com/asset?id=54071825',
'http://www.roblox.com/Asset?id=45915798',game:GetService'CoreGui'.Version>=5,10
,false,nil,{},{},nil,UserSettings().GameSettings:InStudioMode(),false,pcall(
function()return not game.GuiService.IsWindows end)s=t and u local v v=function(
w,x,y)return Color3.new(w/255,x/255,y/255)end local w w=function(x)x.
RobloxLocked=true local y=x:GetChildren()if y then for z,A in ipairs(y)do w(A)
end end end local x x=function(y)y.Settings:TweenPosition(UDim2.new(0.5,-262,-
0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)return delay(h
,function()y.Visible=false for z=1,#p do p[z].Visible=false game.GuiService:
RemoveCenterDialog(p[z])end game.GuiService:RemoveCenterDialog(y)settingsButton.
Active=true n=nil o={}end)end local y y=function(z,A,B,C,D)if type(A)~='string'
then return end table.insert(o,n)if A=='GameMainMenu'then o={}end local E=z:
GetChildren()for F=1,#E do if E[F].Name==A then E[F].Visible=true n={container=z
,name=A,direction=B,lastSize=C}if C and D then E[F]:TweenSizeAndPosition(C,D,
Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)elseif C then E[F]:
TweenSizeAndPosition(C,UDim2.new(0.5,-C.X.Offset/2,0.5,-C.Y.Offset/2),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)else E[F]:TweenPosition(UDim2
.new(0,0,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)end else
if B=='left'then E[F]:TweenPosition(UDim2.new(-1,-525,0,0),Enum.EasingDirection.
InOut,Enum.EasingStyle.Sine,h,true)elseif B=='right'then E[F]:TweenPosition(
UDim2.new(1,525,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)
elseif B=='up'then E[F]:TweenPosition(UDim2.new(0,0,-1,-400),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)elseif B=='down'then E[F]:
TweenPosition(UDim2.new(0,0,1,400),Enum.EasingDirection.InOut,Enum.EasingStyle.
Sine,h,true)end delay(h,function()E[F].Visible=false end)end end end local z z=
function()local A=game.Players.LocalPlayer if A and A.Character and A.Character:
FindFirstChild'Humanoid'then A.Character.Humanoid.Health=0 end end local A A=
function(B,C,D,E,F)return a('TextButton',{Font=Enum.Font.Arial,FontSize=D,Size=E
,Position=F,Style=C,TextColor3=Color3.new(1,1,1),Text=B})end local B B=function(
C,D,E,F)if#D<1 then error'Must have more than one button'end local G,H,I=1,{},
nil I=function(J)for K,L in ipairs(H)do if L==J then L.Style=Enum.ButtonStyle.
RobloxButtonDefault else L.Style=Enum.ButtonStyle.RobloxButton end end end for J
,K in ipairs(D)do local L=a('TextButton','Button'..tostring(G),{Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size18,AutoButtonColor=true,Style=Enum.ButtonStyle.
RobloxButton,Text=K.Text,TextColor3=Color3.new(1,1,1),Parent=C})L.
MouseButton1Click:connect(function()I(L)return K.Function()end)H[G]=L G=G+1 end
I(H[1])local L=G-1 if L==1 then C.Button1.Position=UDim2.new(0.35,0,E.Scale,E.
Offset)C.Button1.Size=UDim2.new(0.4,0,F.Scale,F.Offset)elseif L==2 then C.
Button1.Position=UDim2.new(0.1,0,E.Scale,E.Offset)C.Button1.Size=UDim2.new(0.35,
0,F.Scale,F.Offset)C.Button2.Position=UDim2.new(0.55,0,E.Scale,E.Offset)C.
Button2.Size=UDim2.new(0.35,0,F.Scale,F.Offset)elseif L>=3 then local M,N=0.1/L,
0.9/L G=1 while G<=L do H[G].Position=UDim2.new(M*G+(G-1)*N,0,E.Scale,E.Offset)H
[G].Size=UDim2.new(N,0,F.Scale,F.Offset)G=G+1 end end end local C C=function(D,E
,F)if D then E.Visible=true F.Text='Stop Recording'else E.Visible=false F.Text=
'Record Video'end end local D D=function(E,F)m=not m return C(m,F,E)end local E
E=function(F,G,H)F.Parent.Parent.Parent.Parent.Visible=false G.Visible=false for
I=1,#p do game.GuiService:RemoveCenterDialog(p[I])p[I].Visible=false end p={}
game.GuiService:RemoveCenterDialog(G)H.Active=true end local F F=function(G)if
not G then return end if G:IsA'TextLabel'then G.TextTransparency=0.9 elseif G:
IsA'TextButton'then G.TextTransparency=0.9 G.Active=false else if G['ClassName']
then return print(
[[setDisabledState! got object of unsupported type. object type is ]],G.
ClassName)end end end local G G=function(H)if e==nil then if d:FindFirstChild(d.
TopLeftControl:FindFirstChild'Help')then e=d.TopLeftControl.Help elseif d:
FindFirstChild(d.BottomRightControl:FindFirstChild'Help')then e=d.
BottomRightControl.Help end end local I=a('Frame','HelpDialogShield',{Active=
true,Visible=false,Size=UDim2.new(1,0,1,0),BackgroundColor3=v(51,51,51),
BorderColor3=v(27,42,53),BackgroundTransparency=0.4,ZIndex=H+1})local J=a(
'Frame','HelpDialog',{Style=Enum.FrameStyle.RobloxRound,Position=UDim2.new(0.2,0
,0.2,0),Size=UDim2.new(0.6,0,0.6,0),Active=true,Parent=I,a('TextLabel','Title',{
Text='Keyboard & Mouse Controls',Font=Enum.Font.ArialBold,FontSize=Enum.FontSize
.Size36,Position=UDim2.new(0,0,0.025,0),Size=UDim2.new(1,0,0,40),TextColor3=
Color3.new(1,1,1),BackgroundTransparency=1}),a('Frame','Buttons',{Position=UDim2
.new(0.1,0,0.07,40),Size=UDim2.new(0.8,0,0,45),BackgroundTransparency=1}),a(
'Frame','ImageFrame',{Position=UDim2.new(0.05,0,0.075,80),Size=UDim2.new(0.9,0,
0.9,-120),BackgroundTransparency=1,a('Frame','LayoutFrame',{Position=UDim2.new(
0.5,0,0,0),Size=UDim2.new(1.5,0,1,0),BackgroundTransparency=1,SizeConstraint=
Enum.SizeConstraint.RelativeYY,a('ImageLabel','Image',{Image=(function()if
UserSettings().GameSettings.ControlMode==Enum.ControlMode['Mouse Lock Switch']
then return i else return j end end)(),Position=UDim2.new(-0.5,0,0,0),Size=UDim2
.new(1,0,1,0),BackgroundTransparency=1})})})})local K,L,M=J.Buttons,J.ImageFrame
.LayoutFrame.Image,{}M[1]={}M[1].Text='Look'M[1].Function=function()if
UserSettings().GameSettings.ControlMode==Enum.ControlMode['Mouse Lock Switch']
then L.Image=i else L.Image=j end end M[2]={}M[2].Text='Move'M[2].Function=
function()L.Image='http://www.roblox.com/Asset?id=45915811'end M[3]={}M[3].Text=
'Gear'M[3].Function=function()L.Image='http://www.roblox.com/Asset?id=45917596'
end M[4]={}M[4].Text='Zoom'M[4].Function=function()L.Image=
'http://www.roblox.com/Asset?id=45915825'end B(K,M,UDim.new(0,0),UDim.new(1,0))
delay(0,function()b(d,'UserSettingsShield')b(d.UserSettingsShield,'Settings')b(d
.UserSettingsShield.Settings,'SettingsStyle')b(d.UserSettingsShield.Settings.
SettingsStyle,'GameSettingsMenu')b(d.UserSettingsShield.Settings.SettingsStyle.
GameSettingsMenu,'CameraField')b(d.UserSettingsShield.Settings.SettingsStyle.
GameSettingsMenu.CameraField,'DropDownMenuButton')return d.UserSettingsShield.
Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Changed:
connect(function(N)if N~='Text'then return end if K.Button1.Style==Enum.
ButtonStyle.RobloxButtonDefault then if d.UserSettingsShield.Settings.
SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Text=='Classic'
then L.Image=j else L.Image=i end end end)end)local N=a('TextButton','OkBtn',{
Text='OK',Modal=true,Size=UDim2.new(0.3,0,0,45),Position=UDim2.new(0.35,0,0.975,
-50),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,BackgroundTransparency=1
,TextColor3=Color3.new(1,1,1),Style=Enum.ButtonStyle.RobloxButtonDefault,Parent=
J})N.MouseButton1Click:connect(function()I.Visible=false return game.GuiService:
RemoveCenterDialog(I)end)w(I)return I end local H H=function(I,J)local K,L=a(
'Frame','LeaveConfirmationMenu',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0
),Position=UDim2.new(0,0,2,400),ZIndex=I+4,a('TextLabel','LeaveText',{Text=
'Leave this game?',Size=UDim2.new(1,0,0.8,0),TextWrap=true,TextColor3=Color3.
new(1,1,1),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,
BackgroundTransparency=1,ZIndex=I+4})}),A('Leave',Enum.ButtonStyle.RobloxButton,
Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,313,0.8,0))L.Name=
'YesButton'L.ZIndex=I+4 L.Parent=K L.Modal=true L:SetVerb'Exit'local M=A('Stay',
Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,128,0,50),
UDim2.new(0,90,0.8,0))M.Name='NoButton'M.Parent=K M.ZIndex=I+4 M.
MouseButton1Click:connect(function()y(J.Settings.SettingsStyle,'GameMainMenu',
'down',UDim2.new(0,525,0,430))return J.Settings:TweenSize(UDim2.new(0,525,0,430)
,Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)end)return K end local
I I=function(J,K)local L,M=a('Frame','ResetConfirmationMenu',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,2,400),
ZIndex=J+4}),A('Reset',Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24
,UDim2.new(0,128,0,50),UDim2.new(0,313,0,299))M.Name='YesButton'M.ZIndex=J+4 M.
Parent=L M.Modal=true M.MouseButton1Click:connect(function()x(K)return z()end)
local N=A('Cancel',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(
0,128,0,50),UDim2.new(0,90,0,299))N.Name='NoButton'N.Parent=L N.ZIndex=J+4 N.
MouseButton1Click:connect(function()y(K.Settings.SettingsStyle,'GameMainMenu',
'down',UDim2.new(0,525,0,430))return K.Settings:TweenSize(UDim2.new(0,525,0,430)
,Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)end)local O=a(
'TextLabel','ResetCharacterText',{Text=
'Are you sure you want to reset your character?',Size=UDim2.new(1,0,0.8,0),
TextWrap=true,TextColor3=Color3.new(1,1,1),Font=Enum.Font.ArialBold,FontSize=
Enum.FontSize.Size36,BackgroundTransparency=1,ZIndex=J+4,Parent=L})do local P=O:
Clone()P.Name='FineResetCharacterText'P.Text=
'You will be put back on a spawn point'P.Size=UDim2.new(0,303,0,18)P.Position=
UDim2.new(0,109,0,215)P.FontSize=Enum.FontSize.Size18 P.Parent=L end return L
end local J J=function(K,L)local M,N=a('Frame','GameMainMenu',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=K+4,Parent=settingsFrame
,a('TextLabel','Title',{Text='Game Menu',BackgroundTransparency=1,
TextStrokeTransparency=0,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,
Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,4),TextColor3=Color3.new(1,1,1
),ZIndex=K+4})}),A('Help',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,
UDim2.new(0,164,0,50),UDim2.new(0,82,0,256))N.Name='HelpButton'N.ZIndex=K+4 N.
Parent=M e=N local O=G(K)O.Parent=d e.MouseButton1Click:connect(function()table.
insert(p,O)return game.GuiService:AddCenterDialog(O,Enum.CenterDialogType.
ModalDialog,function()O.Visible=true q.Visible=false end,function()O.Visible=
false end)end)e.Active=true local P,Q=a('TextLabel','HelpShortcutText',{Text=
'F1',Visible=false,BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size12,Position=UDim2.new(0,85,0,0),Size=UDim2.new(0,30,0,30),
TextColor3=Color3.new(0,1,0),ZIndex=K+4,Parent=N}),A('Screenshot',Enum.
ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.new(0,
254,0,256))Q.Name='ScreenshotButton'Q.ZIndex=K+4 Q.Parent=M Q.Visible=not s Q:
SetVerb'Screenshot'do local R=P:clone()R.Name='ScreenshotShortcutText'R.Text=
'PrintSc'R.Position=UDim2.new(0,118,0,0)R.Visible=true R.Parent=Q end local R=A(
'Record Video',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,
168,0,50),UDim2.new(0,254,0,306))R.Name='RecordVideoButton'R.ZIndex=K+4 R.Parent
=M R.Visible=not s R:SetVerb'RecordToggle'do local S=P:clone()S.Visible=k S.Name
='RecordVideoShortcutText'S.Text='F12'S.Position=UDim2.new(0,120,0,0)S.Parent=R
end local S=a('ImageButton','StopRecordButton',{BackgroundTransparency=1,Image=
'rbxasset://textures/ui/RecordStop.png',Size=UDim2.new(0,59,0,27)})S:SetVerb
'RecordToggle'S.MouseButton1Click:connect(function()return D(R,S)end)S.Visible=
false S.Parent=d local T=A('Report Abuse',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size18,UDim2.new(0,164,0,50),UDim2.new(0,82,0,306))T.Name=
'ReportAbuseButton'T.ZIndex=K+4 T.Parent=M local U=A('Leave Game',Enum.
ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,
82,0,358))U.Name='LeaveGameButton'U.ZIndex=K+4 U.Parent=M local V=A(
'Resume Game',Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.
new(0,340,0,50),UDim2.new(0,82,0,54))V.Name='resumeGameButton'V.ZIndex=K+4 V.
Parent=M V.Modal=true V.MouseButton1Click:connect(function()return x(L)end)local
W=A('Game Settings',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.
new(0,340,0,50),UDim2.new(0,82,0,156))W.Name='SettingsButton'W.ZIndex=K+4 W.
Parent=M if game:FindFirstChild'LoadingGuiService'and#game.LoadingGuiService:
GetChildren()>0 then W=A('Game Instructions',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,207))W.Name=
'GameInstructions'W.ZIndex=K+4 W.Parent=M W.MouseButton1Click:connect(function()
if game:FindFirstChild(game.Players['LocalPlayer'])then do local X=game.Players.
LocalPlayer:FindFirstChild'PlayerLoadingGui'if X then X.Visible=true end end end
end)end local X=A('Reset Character',Enum.ButtonStyle.RobloxButton,Enum.FontSize.
Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,105))X.Name='ResetButton'X.ZIndex=
K+4 X.Parent=M return M end local K K=function(L,M)local N=a('Frame',
'GameSettingsMenu',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=L+4,
a('TextLabel','Title',{Text='Settings',Size=UDim2.new(1,0,0,48),Position=UDim2.
new(0,9,0,-9),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,TextColor3=
Color3.new(1,1,1),ZIndex=L+4,BackgroundTransparency=1}),a('TextLabel',
'FullscreenText',{Text='Fullscreen Mode',Size=UDim2.new(0,124,0,18),Position=
UDim2.new(0,62,0,145),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
TextColor3=Color3.new(1,1,1),ZIndex=L+4,BackgroundTransparency=1})})local O,P=a(
'TextLabel','FullscreenShortcutText',{Visible=k,Text='F11',
BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size12,
Position=UDim2.new(0,186,0,141),Size=UDim2.new(0,30,0,30),TextColor3=Color3.new(
0,1,0),ZIndex=L+4,Parent=N}),a('TextLabel','StudioText',{Visible=false,Text=
'Studio Mode',Size=UDim2.new(0,95,0,18),Position=UDim2.new(0,62,0,179),Font=Enum
.Font.Arial,FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),ZIndex=L+
4,BackgroundTransparency=1,Parent=N})local Q=O:clone()Q.Name=
'StudioShortcutText'Q.Visible=false Q.Text='F2'Q.Position=UDim2.new(0,154,0,175)
Q.Parent=N local R if k then local S=a('TextLabel','QualityText',{Text=
'Graphics Quality',Size=UDim2.new(0,128,0,18),Position=UDim2.new(0,30,0,239),
Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),
ZIndex=L+4,BackgroundTransparency=1,Parent=N,Visible=not r})local T=S:clone()T.
Name='AutoText'T.Text='Auto'T.Position=UDim2.new(0,183,0,214)T.TextColor3=Color3
.new(0.5019607843137255,0.5019607843137255,0.5019607843137255)T.Size=UDim2.new(0
,34,0,18)T.Parent=N T.Visible=not r local U=T:clone()U.Name='FasterText'U.Text=
'Faster'U.Position=UDim2.new(0,185,0,274)U.TextColor3=Color3.new(95,95,95)U.
FontSize=Enum.FontSize.Size14 U.Parent=N U.Visible=not r local V=O:clone()V.Name
='FasterShortcutText'V.Text='F10 + Shift'V.Position=UDim2.new(0,185,0,283)V.
Parent=N V.Visible=not r local W=T:clone()W.Name='BetterQualityText'W.Text=
'Better Quality'W.TextWrap=true W.Size=UDim2.new(0,41,0,28)W.Position=UDim2.new(
0,390,0,269)W.TextColor3=Color3.new(95,95,95)W.FontSize=Enum.FontSize.Size14 W.
Parent=N W.Visible=not r local X=O:clone()X.Name='BetterQualityShortcut'X.Text=
'F10'X.Position=UDim2.new(0,394,0,288)X.Parent=N X.Visible=not r local Y=A('X',
Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.
new(0,187,0,239))Y.Name='AutoGraphicsButton'Y.ZIndex=L+4 Y.Parent=N Y.Visible=
not r local Z,_=RbxGui.CreateSlider(l,150,UDim2.new(0,230,0,280))Z.Parent=N Z.
Bar.ZIndex=L+4 Z.Bar.Slider.ZIndex=L+5 Z.Visible=not r _.Value=math.floor((
settings().Rendering:GetMaxQualityLevel()-1)/2)local aa,ab=a('TextBox',
'GraphicsSetter',{BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(
0.5019607843137255,0.5019607843137255,0.5019607843137255),Size=UDim2.new(0,50,0,
25),Position=UDim2.new(0,450,0,269),TextColor3=Color3.new(1,1,1),Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size18,Text='Auto',ZIndex=1,TextWrap=true,Parent=N,
Visible=not r}),true if not r then ab=(UserSettings().GameSettings.
SavedQualityLevel==Enum.SavedQualitySetting.Automatic)else settings().Rendering.
EnableFRM=false end local ac,ad=true,nil ad=function(ae)ab=ae if ae then Y.Text=
'X'W.ZIndex=1 X.ZIndex=1 V.ZIndex=1 U.ZIndex=1 Z.Bar.ZIndex=1 Z.Bar.Slider.
ZIndex=1 aa.ZIndex=1 aa.Text='Auto'else Y.Text=''Z.Bar.ZIndex=L+4 Z.Bar.Slider.
ZIndex=L+5 X.ZIndex=L+4 V.ZIndex=L+4 W.ZIndex=L+4 U.ZIndex=L+4 aa.ZIndex=L+4 end
end local ae ae=function()ad(true)UserSettings().GameSettings.SavedQualityLevel=
Enum.SavedQualitySetting.Automatic settings().Rendering.QualityLevel=Enum.
QualityLevel.Automatic end local af af=function(ag)local ah=ag/l local ai=math.
floor((settings().Rendering:GetMaxQualityLevel()-1)*ah)if ai==20 then ai=21
elseif ag==1 then ai=1 elseif ai>settings().Rendering:GetMaxQualityLevel()then
ai=settings().Rendering:GetMaxQualityLevel()-1 end UserSettings().GameSettings.
SavedQualityLevel=ag settings().Rendering.QualityLevel=ai end local ag ag=
function(ah)ad(false)if ah then _.Value=ah else _.Value=math.floor((settings().
Rendering.AutoFRMLevel/(settings().Rendering:GetMaxQualityLevel()-1)){l})end if
ah==_.Value then af(_.Value)end if not ah then UserSettings().GameSettings.
SavedQualityLevel=_.Value end aa.Text=tostring(_.Value)end local ah ah=function(
)T.ZIndex=L+4 Y.ZIndex=L+4 end local ai ai=function()T.ZIndex=1 Y.ZIndex=1 end
local aj aj=function()Z.Bar.ZIndex=L+4 Z.Bar.Slider.ZIndex=L+5 X.ZIndex=L+4 V.
ZIndex=L+4 W.ZIndex=L+4 U.ZIndex=L+4 aa.ZIndex=L+4 end local ak ak=function()W.
ZIndex=1 X.ZIndex=1 V.ZIndex=1 U.ZIndex=1 Z.Bar.ZIndex=1 Z.Bar.Slider.ZIndex=1
aa.ZIndex=1 end local al al=function(am)if Enum.SavedQualitySetting.Automatic==
am then return 0 elseif Enum.SavedQualitySetting.QualityLevel1==am then return 1
elseif Enum.SavedQualitySetting.QualityLevel2==am then return 2 elseif Enum.
SavedQualitySetting.QualityLevel3==am then return 3 elseif Enum.
SavedQualitySetting.QualityLevel4==am then return 4 elseif Enum.
SavedQualitySetting.QualityLevel5==am then return 5 elseif Enum.
SavedQualitySetting.QualityLevel6==am then return 6 elseif Enum.
SavedQualitySetting.QualityLevel7==am then return 7 elseif Enum.
SavedQualitySetting.QualityLevel8==am then return 8 elseif Enum.
SavedQualitySetting.QualityLevel9==am then return 9 elseif Enum.
SavedQualitySetting.QualityLevel10==am then return 10 end end local am am=
function()settings().Rendering.EnableFRM=true ab=UserSettings().GameSettings.
SavedQualityLevel==Enum.SavedQualitySetting.Automatic if ab then ah()return ae()
else ah()aj()return ag(al(UserSettings().GameSettings.SavedQualityLevel))end end
local an an=function()ak()ai()settings().Rendering.EnableFRM=false end aa.
FocusLost:connect(function()if ab then aa.Text=tostring(_.Value)return end local
ao=tonumber(aa.Text)if ao==nil then aa.Text=tostring(_.Value)return end if ao<1
then ao=1 elseif ao>=settings().Rendering:GetMaxQualityLevel()then ao=settings()
.Rendering:GetMaxQualityLevel()-1 end _.Value=ao af(_.Value)aa.Text=tostring(_.
Value)end)_.Changed:connect(function(ao)if ab then return end if not ac then
return end aa.Text=tostring(_.Value)return af(_.Value)end)if r or UserSettings()
.GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.Automatic then if r
then settings().Rendering.EnableFRM=false an()else settings().Rendering.
EnableFRM=true ae()end else settings().Rendering.EnableFRM=true ag(al(
UserSettings().GameSettings.SavedQualityLevel))end Y.MouseButton1Click:connect(
function()if r and not game.Players.LocalPlayer then return end if not ab then
return ae()else return ag(_.Value)end end)game.GraphicsQualityChangeRequest:
connect(function(ao)if ab then return end if ao then if(_.Value+1)>l then return
end _.Value=_.Value+1 aa.Text=tostring(_.Value)af(_.Value)return game:GetService
'GuiService':SendNotification('Graphics Quality','Increased to ('..tostring(aa.
Text)..')','',2,function()end)else if(_.Value-1)<=0 then return end _.Value=_.
Value-1 aa.Text=tostring(_.Value)af(_.Value)return game:GetService'GuiService':
SendNotification('Graphics Quality','Decreased to ('..tostring(aa.Text)..')','',
2,function()end)end end)game.Players.PlayerAdded:connect(function(ao)if ao==game
.Players.LocalPlayer and r then return am()end end)game.Players.PlayerRemoving:
connect(function(ao)if ao==game.Players.LocalPlayer and r then return an()end
end)R=A('',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,
25),UDim2.new(0,30,0,176))R.Name='StudioCheckbox'R.ZIndex=L+4 R:SetVerb
'TogglePlayMode'R.Visible=false local ao=(settings().Rendering.QualityLevel~=
Enum.QualityLevel.Automatic)if r and not game.Players.LocalPlayer then R.Text=
'X'an()elseif r then R.Text='X'am()end if k then UserSettings().GameSettings.
StudioModeChanged:connect(function(ap)r=ap if ap then ao=(settings().Rendering.
QualityLevel~=Enum.QualityLevel.Automatic)ae()R.Text='X'Y.ZIndex=1 T.ZIndex=1
else if ao then ag()end R.Text=''Y.ZIndex=L+4 T.ZIndex=L+4 end end)else R.
MouseButton1Click:connect(function()if not R.Active then return end if R.Text==
''then R.Text='X'else R.Text=''end end)end end local aa=A('',Enum.ButtonStyle.
RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,30,0,144))aa.
Name='FullscreenCheckbox'aa.ZIndex=L+4 aa.Parent=N aa:SetVerb'ToggleFullScreen'
if UserSettings().GameSettings:InFullScreen()then aa.Text='X'end if k then
UserSettings().GameSettings.FullscreenChanged:connect(function(ab)if ab then aa.
Text='X'else aa.Text=''end end)else aa.MouseButton1Click:connect(function()if aa
.Text==''then aa.Text='X'else aa.Text=''end end)end if game:FindFirstChild
'NetworkClient'then F(P)F(Q)F(R)end local ab if k then ab=A('OK',Enum.
ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2
.new(0,170,0,330))ab.Modal=true else ab=A('OK',Enum.ButtonStyle.
RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2.new(0,170,0
,270))ab.Modal=true end ab.Name='BackButton'ab.ZIndex=L+4 ab.Parent=N
syncVideoCaptureSetting=nil if not s then a('TextLabel','VideoCaptureLabel',{
Text='After Capturing Video',Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0,32,0,100),Size=UDim2.new(0,164,0,18),BackgroundTransparency
=1,TextColor3=v(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=L+4,
Parent=N})local ac,ad={},{}ac[1]='Just Save to Disk'ad[ac[1]]=Enum.UploadSetting
['Never']ac[2]='Upload to YouTube'ad[ac[2]]=Enum.UploadSetting['Ask me first']
local ae ae,g=RbxGui.CreateDropDownMenu(ac,function(af)UserSettings().
GameSettings.VideoUploadPromptBehavior=ad[af]end)ae.Name='VideoCaptureField'ae.
ZIndex=L+4 ae.DropDownMenuButton.ZIndex=L+4 ae.DropDownMenuButton.Icon.ZIndex=L+
4 ae.Position=UDim2.new(0,270,0,94)ae.Size=UDim2.new(0,200,0,32)ae.Parent=N
syncVideoCaptureSetting=function()return g((function()if UserSettings().
GameSettings.VideoUploadPromptBehavior==Enum.UploadSetting['Never']then return
ac[1]elseif UserSettings().GameSettings.VideoUploadPromptBehavior==Enum.
UploadSetting['Ask me first']then return ac[2]else UserSettings().GameSettings.
VideoUploadPromptBehavior=Enum.UploadSetting['Ask me first']return ac[2]end end
)())end end a('TextLabel','CameraLabel',{Text='Character & Camera Controls',Font
=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0,31,0,58),
Size=UDim2.new(0,224,0,18),TextColor3=v(255,255,255),TextXAlignment=Enum.
TextXAlignment.Left,BackgroundTransparency=1,ZIndex=L+4,Parent=N})local ac,ad,ae
,af=game.CoreGui.RobloxGui:FindFirstChild('MouseLockLabel',true),Enum.
ControlMode:GetEnumItems(),{},{}for ag,ah in ipairs(ad)do ae[ag]=ah.Name af[ah.
Name]=ah end local ai ai,f=RbxGui.CreateDropDownMenu(ae,function(aj)
UserSettings().GameSettings.ControlMode=af[aj]return pcall(function()if ac and
UserSettings().GameSettings.ControlMode==Enum.ControlMode['Mouse Lock Switch']
then ac.Visible=true elseif ac then ac.Visible=false end end)end)ai.Name=
'CameraField'ai.ZIndex=L+4 ai.DropDownMenuButton.ZIndex=L+4 ai.
DropDownMenuButton.Icon.ZIndex=L+4 ai.Position=UDim2.new(0,270,0,52)ai.Size=
UDim2.new(0,200,0,32)ai.Parent=N return N end if LoadLibrary then RbxGui=
LoadLibrary'RbxGui'local aa=0 if UserSettings then local ab ab=function()b(d,
'BottomLeftControl')settingsButton=d.BottomLeftControl:FindFirstChild
'SettingsButton'if settingsButton==nil then settingsButton=a('ImageButton',
'SettingsButton',{Image='rbxasset://textures/ui/SettingsButton.png',
BackgroundTransparency=1,Active=false,Size=UDim2.new(0,54,0,46),Position=UDim2.
new(0,2,0,50),Parent=d.BottomLeftControl})end local ac=a('TextButton',
'UserSettingsShield',{Text='',Active=true,AutoButtonColor=false,Visible=false,
Size=UDim2.new(1,0,1,0),BackgroundColor3=v(51,51,51),BorderColor3=v(27,42,53),
BackgroundTransparency=0.4,ZIndex=aa+2})q=ac local ad=a('Frame','Settings',{
Position=UDim2.new(0.5,-262,-0.5,-200),Size=UDim2.new(0,525,0,430),
BackgroundTransparency=1,Active=true,Parent=ac})local ae,af=a('Frame',
'SettingsStyle',{Size=UDim2.new(1,0,1,0),Style=Enum.FrameStyle.RobloxRound,
Active=true,ZIndex=aa+3,Parent=ad}),J(aa,ac)af.Parent=ae af.ScreenshotButton.
MouseButton1Click:connect(function()return E(af.ScreenshotButton,ac,
settingsButton)end)af.RecordVideoButton.MouseButton1Click:connect(function()D(af
.RecordVideoButton,d.StopRecordButton)return E(af.RecordVideoButton,ac,
settingsButton)end)if settings():FindFirstChild'Game Options'then pcall(function
()return settings():FindFirstChild'Game Options'.VideoRecordingChangeRequest:
connect(function(ag)m=ag return C(ag,d.StopRecordButton,af.RecordVideoButton)end
)end)end game.CoreGui.RobloxGui.Changed:connect(function(ag)if ag==
'AbsoluteSize'and m then return D(af.RecordVideoButton,d.StopRecordButton)end
end)local ag ag=function()af.ResetButton.Visible=game.Players.LocalPlayer if
game.Players.LocalPlayer then settings().Rendering.EnableFRM=true elseif r then
settings().Rendering.EnableFRM=false end end af.ResetButton.Visible=game.Players
.LocalPlayer if(game.Players.LocalPlayer~=nil)then game.Players.LocalPlayer.
Changed:connect(function()return ag()end)else delay(0,function()c(game.Players,
'LocalPlayer')af.ResetButton.Visible=game.Players.LocalPlayer return game.
Players.LocalPlayer.Changed:connect(function()return ag()end)end)end af.
ReportAbuseButton.Visible=game:FindFirstChild'NetworkClient'if not af.
ReportAbuseButton.Visible then game.ChildAdded:connect(function(ah)if ah:IsA
'NetworkClient'then af.ReportAbuseButton.Visible=game:FindFirstChild
'NetworkClient'end end)end af.ResetButton.MouseButton1Click:connect(function()
return y(ae,'ResetConfirmationMenu','up',UDim2.new(0,525,0,370))end)af.
LeaveGameButton.MouseButton1Click:connect(function()return y(ae,
'LeaveConfirmationMenu','down',UDim2.new(0,525,0,300))end)if game.CoreGui.
Version>=4 then game:GetService'GuiService'.EscapeKeyPressed:connect(function()
if n==nil then return game.GuiService:AddCenterDialog(ac,Enum.CenterDialogType.
ModalDialog,function()settingsButton.Active=false f(UserSettings().GameSettings.
ControlMode.Name)if syncVideoCaptureSetting then syncVideoCaptureSetting()end y(
ae,'GameMainMenu','right',UDim2.new(0,525,0,430))ac.Visible=true ac.Active=true
ae.Parent:TweenPosition(UDim2.new(0.5,-262,0.5,-200),Enum.EasingDirection.InOut,
Enum.EasingStyle.Sine,h,true)return ae.Parent:TweenSize(UDim2.new(0,525,0,430),
Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)end,function()ae.Parent:
TweenPosition(UDim2.new(0.5,-262,-0.5,-200),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,h,true)ae.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)ac.Visible=false
settingsButton.Active=true end)elseif#o>0 then if#p>0 then for ah=1,#p do game.
GuiService:RemoveCenterDialog(p[ah])p[ah].Visible=false end p={}end y(o[#o][
'container'],o[#o]['name'],o[#o]['direction'],o[#o]['lastSize'])table.remove(o,#
o)if#o==1 then o={}end else return x(ac)end end)end local ah=K(aa,ac)ah.Visible=
false ah.Parent=ae af.SettingsButton.MouseButton1Click:connect(function()return
y(ae,'GameSettingsMenu','left',UDim2.new(0,525,0,350))end)ah.BackButton.
MouseButton1Click:connect(function()return y(ae,'GameMainMenu','right',UDim2.
new(0,525,0,430))end)local ai=I(aa,ac)ai.Visible=false ai.Parent=ae local aj=H(
aa,ac)aj.Visible=false aj.Parent=ae w(ac)settingsButton.MouseButton1Click:
connect(function()return game.GuiService:AddCenterDialog(ac,Enum.
CenterDialogType.ModalDialog,function()settingsButton.Active=false f(
UserSettings().GameSettings.ControlMode.Name)if syncVideoCaptureSetting then
syncVideoCaptureSetting()end y(ae,'GameMainMenu','right',UDim2.new(0,525,0,430))
ac.Visible=true ae.Parent:TweenPosition(UDim2.new(0.5,-262,0.5,-200),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)return ae.Parent:TweenSize(
UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)
end,function()ae.Parent:TweenPosition(UDim2.new(0.5,-262,-0.5,-200),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)ae.Parent:TweenSize(UDim2.
new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,h,true)ac.
Visible=false settingsButton.Active=true end)end)return ac end delay(0,function(
)ab().Parent=d d.BottomLeftControl.SettingsButton.Active=true d.
BottomLeftControl.SettingsButton.Position=UDim2.new(0,2,0,-2)if mouseLockLabel
and UserSettings().GameSettings.ControlMode==Enum.ControlMode[
'Mouse Lock Switch']then mouseLockLabel.Visible=true elseif mouseLockLabel then
mouseLockLabel.Visible=false end local ac=d.BottomLeftControl:FindFirstChild
'Exit'if ac~=nil then ac:Remove()end local ad=d:FindFirstChild'TopLeftControl'if
ad then ac=ad:FindFirstChild'Exit'if ac~=nil then ac:Remove()end return ad:
Remove()end end)end local ab ab=function()local ac,ad,ae,af,ag,ah,ai=a(
'TextButton','SaveDialogShield',{Text='',AutoButtonColor=false,Active=true,
Visible=false,Size=UDim2.new(1,0,1,0),BackgroundColor3=v(51,51,51),BorderColor3=
v(27,42,53),BackgroundTransparency=0.4,ZIndex=aa+1}),nil,nil,nil,nil,nil,{}ai[1]
={}ai[1].Text='Save'ai[1].Style=Enum.ButtonStyle.RobloxButtonDefault ai[1].
Function=function()return ae()end ai[2]={}ai[2].Text='Cancel'ai[2].Function=
function()return ah()end ai[3]={}ai[3].Text="Don't Save"ai[3].Function=function(
)return ag()end local aj=RbxGui.CreateStyledMessageDialog('Unsaved Changes',
'Save your changes to Mercury before leaving?','Confirm',ai)aj.Visible=true aj.
Parent=ac local ak,al={},1 if game.LocalSaveEnabled then ak[al]={}ak[al].Text=
'Save to Disk'ak[al].Function=function()return af()end al=al+1 end ak[al]={}ak[
al].Text='Keep Playing'ak[al].Function=function()return ah()end ak[al+1]={}ak[al
+1].Text="Don't Save"ak[al+1].Function=function()return ag()end local am=RbxGui.
CreateStyledMessageDialog('Upload Failed',
'Sorry, we could not save your changes to Mercury.','Error',ak)am.Visible=false
am.Parent=ac local an=a('Frame','SpinnerDialog',{Style=Enum.FrameStyle.
RobloxRound,Size=UDim2.new(0,350,0,150),Position=UDim2.new(0.5,-175,0.5,-75),
Visible=false,Active=true,Parent=ac,a('TextLabel','WaitingLabel',{Text=
'Saving to Mercury...',Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0.5,25,0.5,0),TextColor3=Color3.new(1,1,1)})})local ao,ap,L=
a('Frame','Spinner',{Size=UDim2.new(0,80,0,80),Position=UDim2.new(0.5,-150,0.5,-
40),BackgroundTransparency=1,Parent=an}),{},1 while L<=8 do local M=a(
'ImageLabel','Spinner'..tostring(L),{Size=UDim2.new(0,16,0,16),Position=UDim2.
new(0.5+0.3*math.cos(math.rad(45*L)),-8,0.5+0.3*math.sin(math.rad(45*L)),-8),
BackgroundTransparency=1,Image='http://www.roblox.com/Asset?id=45880710',Parent=
ao})ap[L]=M L=L+1 end ae=function()aj.Visible=false an.Visible=true local M=true
delay(0,function()local N=0 while M do local O=0 while O<8 do if O==N or O==((N+
1)%8)then ap[O+1].Image='http://www.roblox.com/Asset?id=45880668'else ap[O+1].
Image='http://www.roblox.com/Asset?id=45880710'end O=O+1 end N=(N+1)%8 wait(0.2)
end end)local N=game:SaveToRoblox()if not N then N=game:SaveToRoblox()end an.
Visible=false M=false if N then game:FinishShutdown(false)return ad()else am.
Visible=true end end ae=function()am.Visible=false game:FinishShutdown(true)
return ad()end ag=function()aj.Visible=false am.Visible=false game:
FinishShutdown(false)return ad()end ah=function()aj.Visible=false am.Visible=
false return ad()end ad=function()aj.Visible=true am.Visible=false an.Visible=
false ac.Visible=false return game.GuiService:RemoveCenterDialog(ac)end w(ac)ac.
Visible=false return ac end local ac ac=function()b(game,'NetworkClient')b(game,
'Players')c(game.Players,'LocalPlayer')local ad,ae=game.Players.LocalPlayer,nil
b(d,'UserSettingsShield')b(d.UserSettingsShield,'Settings')b(d.
UserSettingsShield.Settings,'SettingsStyle')b(d.UserSettingsShield.Settings.
SettingsStyle,'GameMainMenu')b(d.UserSettingsShield.Settings.SettingsStyle.
GameMainMenu,'ReportAbuseButton')ae=d.UserSettingsShield.Settings.SettingsStyle.
GameMainMenu.ReportAbuseButton local af,ag,ah=a('TextButton','ReportAbuseShield'
,{Text='',AutoButtonColor=false,Active=true,Visible=false,Size=UDim2.new(1,0,1,0
),BackgroundColor3=v(51,51,51),BorderColor3=v(27,42,53),BackgroundTransparency=
0.4,ZIndex=aa+1}),nil,{}ah[1]={}ah[1].Text='Ok'ah[1].Modal=true ah[1].Function=
function()return ag()end local ai=RbxGui.CreateMessageDialog(
'Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened. The other user is probably just trying to make you mad.

If anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats]]
,ah)ai.Visible=false ai.Parent=af local aj=RbxGui.CreateMessageDialog(
'Thanks for your report!',"We've recorded your report for evaluation.",ah)aj.
Visible=false aj.Parent=af local ak=RbxGui.CreateMessageDialog(
'Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened.]],ah)ak.
Visible=false ak.Parent=af local al=a('Frame','Settings',{Position=UDim2.new(0.5
,-250,0.5,-200),Size=UDim2.new(0,500,0,400),BackgroundTransparency=1,Active=true
,Parent=af})local am,an,ao,ap,L,M=a('Frame','ReportAbuseStyle',{Size=UDim2.new(1
,0,1,0),Style=Enum.FrameStyle.RobloxRound,Active=true,ZIndex=aa+1,Parent=al,a(
'TextLabel','Title',{Text='Report Abuse',TextColor3=v(221,221,221),Position=
UDim2.new(0.5,0,0,30),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,
ZIndex=aa+2}),a('TextLabel','Description',{Text=
[[This will send a complete report to a moderator. The moderator will review the chat log and take appropriate action.]]
,TextColor3=v(221,221,221),Position=UDim2.new(0,0,0,55),Size=UDim2.new(1,0,0,40)
,BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
TextWrap=true,ZIndex=aa+2,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment
=Enum.TextYAlignment.Top}),a('TextLabel','PlayerLabel',{Text='Which player?',
BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0.025,0,0,100),Size=UDim2.new(0.4,0,0,36),TextColor3=v(255,
255,255),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=aa+2}),a('TextLabel',
'AbuseLabel',{Text='Type of Abuse:',Font=Enum.Font.Arial,BackgroundTransparency=
1,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0.025,0,0,140),Size=UDim2.
new(0.4,0,0,36),TextColor3=v(255,255,255),TextXAlignment=Enum.TextXAlignment.
Left,ZIndex=aa+2})}),nil,nil,nil,nil,nil M=function()local N,O,P=game:GetService
'Players',{},{}local Q,R=N:GetChildren(),1 if Q then for S,T in ipairs(Q)do if T
:IsA'Player'and T~=ad then O[R]=T.Name P[T.Name]=T R=R+1 end end end local S S,L
=RbxGui.CreateDropDownMenu(O,function(T)an=P[T]if ao and an then ap.Active=true
end end)S.Name='PlayersComboBox'S.ZIndex=aa+2 S.Position=UDim2.new(0.425,0,0,102
)S.Size=UDim2.new(0.55,0,0,32)return S end local N={'Swearing','Bullying',
'Scamming','Dating','Cheating/Exploiting','Personal Questions','Offsite Links',
'Bad Model or Script','Bad Username'}local O,P=RbxGui.CreateDropDownMenu(N,
function(O)ao=O if ao and an then ap.Active=true end end,true)O.Name=
'AbuseComboBox'O.ZIndex=aa+2 O.Position=UDim2.new(0.425,0,0,142)O.Size=UDim2.
new(0.55,0,0,32)O.Parent=am a('TextLabel','ShortDescriptionLabel',{Text=
'Short Description: (optional)',Font=Enum.Font.Arial,FontSize=Enum.FontSize.
Size18,Position=UDim2.new(0.025,0,0,180),Size=UDim2.new(0.95,0,0,36),TextColor3=
v(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,
ZIndex=aa+2,Parent=am})local Q=a('Frame','ShortDescriptionWrapper',{Position=
UDim2.new(0.025,0,0,220),Size=UDim2.new(0.95,0,1,-310),BackgroundColor3=v(0,0,0)
,BorderSizePixel=0,ZIndex=aa+2,Parent=am})local R=a('TextBox','TextBox',{Text=''
,ClearTextOnFocus=false,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0,3,0,3),Size=UDim2.new(1,-6,1,-6),TextColor3=v(255,255,255),
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
TextWrap=true,BackgroundColor3=v(0,0,0),BorderSizePixel=0,ZIndex=aa+2,Parent=Q})
ap=a('TextButton','SubmitReportBtn',{Active=false,Modal=true,Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0.1,0,1,-80),Size=UDim2.
new(0.35,0,0,50),AutoButtonColor=true,Style=Enum.ButtonStyle.RobloxButtonDefault
,Text='Submit Report',TextColor3=v(255,255,255),ZIndex=aa+2,Parent=am})ap.
MouseButton1Click:connect(function()if ap.Active then if ao and an then al.
Visible=false game.Players:ReportAbuse(an,ao,R.Text)if ao=='Cheating/Exploiting'
then aj.Visible=true elseif ao=='Bullying'or ao=='Swearing'then ai.Visible=true
else ak.Visible=true end else return ag()end end end)local S=a('TextButton',
'CancelBtn',{Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,Position=UDim2.
new(0.55,0,1,-80),Size=UDim2.new(0.35,0,0,50),AutoButtonColor=true,Style=Enum.
ButtonStyle.RobloxButtonDefault,Text='Cancel',TextColor3=v(255,255,255),ZIndex=
aa+2,Parent=am})ag=function()local T=am:FindFirstChild'PlayersComboBox'if T then
T.Parent=nil end an=nil L(nil)ao=nil P(nil)ap.Active=false R.Text=''al.Visible=
true ai.Visible=false aj.Visible=false ak.Visible=false af.Visible=false ae.
Active=true return game.GuiService:RemoveCenterDialog(af)end S.MouseButton1Click
:connect(ag)ae.MouseButton1Click:connect(function()M().Parent=am table.insert(p,
af)return game.GuiService:AddCenterDialog(af,Enum.CenterDialogType.ModalDialog,
function()ae.Active=false af.Visible=true q.Visible=false end,function()ae.
Active=true af.Visible=false end)end)w(af)return af end local ad=pcall(function(
)end)if ad then delay(0,function()local ae=ab()ae.Parent=d game.RequestShutdown=
function()table.insert(p,ae)game.GuiService:AddCenterDialog(ae,Enum.
CenterDialogType.QuitDialog,function()ae.Visible=true end,function()ae.Visible=
false end)return true end end)end delay(0,function()ac().Parent=d b(d,
'UserSettingsShield')b(d.UserSettingsShield,'Settings')b(d.UserSettingsShield.
Settings,'SettingsStyle')b(d.UserSettingsShield.Settings.SettingsStyle,
'GameMainMenu')b(d.UserSettingsShield.Settings.SettingsStyle.GameMainMenu,
'ReportAbuseButton')d.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.
ReportAbuseButton.Active=true end)pcall(function()return game.GuiService.
UseLuaChat end)local ae=41324860 return delay(0,function()b(game,'NetworkClient'
)b(game,'Players')c(game.Players,'LocalPlayer')c(game.Players.LocalPlayer,
'Character')b(game.Players.LocalPlayer.Character,'Humanoid')c(game,'PlaceId')if
game.PlaceId==ae then game.Players.LocalPlayer.Character.Humanoid:
SetClickToWalkEnabled(false)return game.Players.LocalPlayer.CharacterAdded:
connect(function(af)b(af,'Humanoid')return af.Humanoid:SetClickToWalkEnabled(
false)end)end end)end