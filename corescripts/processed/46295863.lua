local a a=function(b,c,d)if not(d~=nil)then d=c c=nil end local e=Instance.new(b
)if c then e.Name=c end local f for g,h in pairs(d)do if type(g)=='string'then
if g=='Parent'then f=h else e[g]=h end elseif type(g)=='number'and type(h)==
'userdata'then h.Parent=e end end e.Parent=f return e end local b b=function(c,d
)while not c:FindFirstChild(d)do c.ChildAdded:wait()end end local c c=function(d
,e)while not d[e]do d.Changed:wait()end end local d if script.Parent:
FindFirstChild'ControlFrame'then d=script.Parent:FindFirstChild'ControlFrame'
else d=script.Parent end local e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z=nil,
nil,nil,nil,nil,nil,nil,nil,0.2,'http://www.roblox.com/asset?id=54071825',
'http://www.roblox.com/Asset?id=45915798',game:GetService'CoreGui'.Version>=5,10
,false,nil,{},{},nil,UserSettings().GameSettings:InStudioMode(),false,pcall(
function()return not game.GuiService.IsWindows end)x=y and z local A A=function(
B,C,D)return Color3.new(B/255,C/255,D/255)end local B B=function(C)C.
RobloxLocked=true local D=C:GetChildren()if D then for E,F in ipairs(D)do B(F)
end end end local C C=function(D)D.Settings:TweenPosition(UDim2.new(0.5,-262,-
0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)return delay(m
,function()D.Visible=false for E=1,#u do u[E].Visible=false game.GuiService:
RemoveCenterDialog(u[E])end game.GuiService:RemoveCenterDialog(D)g.Active=true s
=nil t={}end)end local D D=function(E,F,G,H,I)if type(F)~='string'then return
end table.insert(t,s)if F=='GameMainMenu'then t={}end local J=E:GetChildren()for
K=1,#J do if J[K].Name==F then J[K].Visible=true s={container=E,name=F,direction
=G,lastSize=H}if H and I then J[K]:TweenSizeAndPosition(H,I,Enum.EasingDirection
.InOut,Enum.EasingStyle.Sine,m,true)elseif H then J[K]:TweenSizeAndPosition(H,
UDim2.new(0.5,-H.X.Offset/2,0.5,-H.Y.Offset/2),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,m,true)else J[K]:TweenPosition(UDim2.new(0,0,0,0),Enum.
EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)end else if G=='left'then J[K
]:TweenPosition(UDim2.new(-1,-525,0,0),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,m,true)elseif G=='right'then J[K]:TweenPosition(UDim2.new(1,525
,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)elseif G=='up'then
J[K]:TweenPosition(UDim2.new(0,0,-1,-400),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,m,true)elseif G=='down'then J[K]:TweenPosition(UDim2.new(0,0,1,
400),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)end delay(m,
function()J[K].Visible=false end)end end end local E E=function()local F=game.
Players.LocalPlayer if F then if F.Character and F.Character:FindFirstChild
'Humanoid'then F.Character.Humanoid.Health=0 end end end local F F=function(G,H,
I,J,K)return a('TextButton',{Font=Enum.Font.Arial,FontSize=I,Size=J,Position=K,
Style=H,TextColor3=Color3.new(1,1,1),Text=G})end local G G=function(H,I,J,K)if#I
<1 then error'Must have more than one button'end local L,M,N=1,{},nil N=function
(O)for P,Q in ipairs(M)do if Q==O then Q.Style=Enum.ButtonStyle.
RobloxButtonDefault else Q.Style=Enum.ButtonStyle.RobloxButton end end end for O
,P in ipairs(I)do local Q=a('TextButton','Button'..tostring(L),{Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size18,AutoButtonColor=true,Style=Enum.ButtonStyle.
RobloxButton,Text=P.Text,TextColor3=Color3.new(1,1,1)})Q.MouseButton1Click:
connect(function()N(Q)return P.Function()end)Q.Parent=H M[L]=Q L=L+1 end N(M[1])
local Q=L-1 if Q==1 then H.Button1.Position=UDim2.new(0.35,0,J.Scale,J.Offset)H.
Button1.Size=UDim2.new(0.4,0,K.Scale,K.Offset)elseif Q==2 then H.Button1.
Position=UDim2.new(0.1,0,J.Scale,J.Offset)H.Button1.Size=UDim2.new(0.35,0,K.
Scale,K.Offset)H.Button2.Position=UDim2.new(0.55,0,J.Scale,J.Offset)H.Button2.
Size=UDim2.new(0.35,0,K.Scale,K.Offset)elseif Q>=3 then local R,S=0.1/Q,0.9/Q L=
1 while L<=Q do M[L].Position=UDim2.new(R*L+(L-1)*S,0,J.Scale,J.Offset)M[L].Size
=UDim2.new(S,0,K.Scale,K.Offset)L=L+1 end end end local H H=function(I,J,K)if I
then J.Visible=true K.Text='Stop Recording'else J.Visible=false K.Text=
'Record Video'end end local I I=function(J,K)r=not r return H(r,K,J)end local J
J=function(K,L,M)K.Parent.Parent.Parent.Parent.Visible=false L.Visible=false for
N=1,#u do game.GuiService:RemoveCenterDialog(u[N])u[N].Visible=false end u={}
game.GuiService:RemoveCenterDialog(L)M.Active=true end local K K=function(L)if
not L then return end if L:IsA'TextLabel'then L.TextTransparency=0.9 elseif L:
IsA'TextButton'then L.TextTransparency=0.9 L.Active=false else if L['ClassName']
then return print(
[[setDisabledState() got object of unsupported type.  object type is ]],L.
ClassName)end end end local L L=function(M)if not(h~=nil)then if d:
FindFirstChild(d.TopLeftControl:FindFirstChild'Help')then h=d.TopLeftControl.
Help elseif d:FindFirstChild(d.BottomRightControl:FindFirstChild'Help')then h=d.
BottomRightControl.Help end end local N=a('Frame','HelpDialogShield',{Active=
true,Visible=false,Size=UDim2.new(1,0,1,0),BackgroundColor3=A(51,51,51),
BorderColor3=A(27,42,53),BackgroundTransparency=0.4,ZIndex=M+1})local O=a(
'Frame','HelpDialog',{Style=Enum.FrameStyle.RobloxRound,Position=UDim2.new(0.2,0
,0.2,0),Size=UDim2.new(0.6,0,0.6,0),Active=true,Parent=N,a('TextLabel','Title',{
Text='Keyboard & Mouse Controls',Font=Enum.Font.ArialBold,FontSize=Enum.FontSize
.Size36,Position=UDim2.new(0,0,0.025,0),Size=UDim2.new(1,0,0,40),TextColor3=
Color3.new(1,1,1),BackgroundTransparency=1})})local P,Q=a('Frame','Buttons',{
Position=UDim2.new(0.1,0,0.07,40),Size=UDim2.new(0.8,0,0,45),
BackgroundTransparency=1,Parent=O}),a('Frame','ImageFrame',{Position=UDim2.new(
0.05,0,0.075,80),Size=UDim2.new(0.9,0,0.9,-120),BackgroundTransparency=1,Parent=
O})local R,S=a('Frame','LayoutFrame',{Position=UDim2.new(0.5,0,0,0),Size=UDim2.
new(1.5,0,1,0),BackgroundTransparency=1,SizeConstraint=Enum.SizeConstraint.
RelativeYY,Parent=Q}),a('ImageLabel','Image')if UserSettings().GameSettings.
ControlMode==Enum.ControlMode['Mouse Lock Switch']then S.Image=n else S.Image=o
end S.Position=UDim2.new(-0.5,0,0,0)S.Size=UDim2.new(1,0,1,0)S.
BackgroundTransparency=1 S.Parent=R local T={}T[1]={}T[1].Text='Look'T[1].
Function=function()if UserSettings().GameSettings.ControlMode==Enum.ControlMode[
'Mouse Lock Switch']then S.Image=n else S.Image=imageclassicLookScreenUrl end
end T[2]={}T[2].Text='Move'T[2].Function=function()S.Image=
'http://www.roblox.com/Asset?id=45915811'end T[3]={}T[3].Text='Gear'T[3].
Function=function()S.Image='http://www.roblox.com/Asset?id=45917596'end T[4]={}T
[4].Text='Zoom'T[4].Function=function()S.Image=
'http://www.roblox.com/Asset?id=45915825'end G(P,T,UDim.new(0,0),UDim.new(1,0))
delay(0,function()b(d,'UserSettingsShield')b(d.UserSettingsShield,'Settings')b(d
.UserSettingsShield.Settings,'SettingsStyle')b(d.UserSettingsShield.Settings.
SettingsStyle,'GameSettingsMenu')b(d.UserSettingsShield.Settings.SettingsStyle.
GameSettingsMenu,'CameraField')b(d.UserSettingsShield.Settings.SettingsStyle.
GameSettingsMenu.CameraField,'DropDownMenuButton')return d.UserSettingsShield.
Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Changed:
connect(function(U)if U~='Text'then return end if P.Button1.Style==Enum.
ButtonStyle.RobloxButtonDefault then if d.UserSettingsShield.Settings.
SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Text=='Classic'
then S.Image=o else S.Image=n end end end)end)local U=a('TextButton','OkBtn',{
Text='OK',Modal=true,Size=UDim2.new(0.3,0,0,45),Position=UDim2.new(0.35,0,0.975,
-50),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,BackgroundTransparency=1
,TextColor3=Color3.new(1,1,1),Style=Enum.ButtonStyle.RobloxButtonDefault,Parent=
O})U.MouseButton1Click:connect(function()N.Visible=false return game.GuiService:
RemoveCenterDialog(N)end)B(N)return N end local M M=function(N,O)local P=a(
'Frame','LeaveConfirmationMenu',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0
),Position=UDim2.new(0,0,2,400),ZIndex=N+4,a('TextLabel','LeaveText',{Text=
'Leave this game?',Size=UDim2.new(1,0,0.8,0),TextWrap=true,TextColor3=Color3.
new(1,1,1),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,
BackgroundTransparency=1,ZIndex=N+4})})do local Q=F('Leave',Enum.ButtonStyle.
RobloxButton,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,313,0.8,0))Q
.Name='YesButton'Q.ZIndex=N+4 Q.Parent=P Q.Modal=true Q:SetVerb'Exit'end do
local Q=F('Stay',Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2
.new(0,128,0,50),UDim2.new(0,90,0.8,0))Q.Name='NoButton'Q.Parent=P Q.ZIndex=N+4
Q.MouseButton1Click:connect(function()D(O.Settings.SettingsStyle,'GameMainMenu',
'down',UDim2.new(0,525,0,430))return O.Settings:TweenSize(UDim2.new(0,525,0,430)
,Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)end)end return P end
local N N=function(O,P)local Q=a('Frame','ResetConfirmationMenu',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,2,400),
ZIndex=O+4})do local R=F('Reset',Enum.ButtonStyle.RobloxButtonDefault,Enum.
FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,313,0,299))R.Name='YesButton'R
.ZIndex=O+4 R.Parent=Q R.Modal=true R.MouseButton1Click:connect(function()C(P)
return E()end)end do local R=F('Cancel',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,90,0,299))R.Name='NoButton'R.
Parent=Q R.ZIndex=O+4 R.MouseButton1Click:connect(function()D(P.Settings.
SettingsStyle,'GameMainMenu','down',UDim2.new(0,525,0,430))return P.Settings:
TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.
Sine,m,true)end)end local R=a('TextLabel','ResetCharacterText',{Text=
'Are you sure you want to reset your character?',Size=UDim2.new(1,0,0.8,0),
TextWrap=true,TextColor3=Color3.new(1,1,1),Font=Enum.Font.ArialBold,FontSize=
Enum.FontSize.Size36,BackgroundTransparency=1,ZIndex=O+4,Parent=Q})do local S=R:
Clone()S.Name='FineResetCharacterText'S.Text=
'You will be put back on a spawn point'S.Size=UDim2.new(0,303,0,18)S.Position=
UDim2.new(0,109,0,215)S.FontSize=Enum.FontSize.Size18 S.Parent=Q end return Q
end local O O=function(P,Q)local R,S=a('Frame','GameMainMenu',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=P+4,Parent=i,a(
'TextLabel','Title',{Text='Game Menu',BackgroundTransparency=1,
TextStrokeTransparency=0,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,
Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,4),TextColor3=Color3.new(1,1,1
),ZIndex=P+4})}),F('Help',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,
UDim2.new(0,164,0,50),UDim2.new(0,82,0,256))S.Name='HelpButton'S.ZIndex=P+4 S.
Parent=R h=S local T=L(P)T.Parent=d h.MouseButton1Click:connect(function()table.
insert(u,T)return game.GuiService:AddCenterDialog(T,Enum.CenterDialogType.
ModalDialog,function()T.Visible=true v.Visible=false end,function()T.Visible=
false end)end)h.Active=true local U,V=a('TextLabel','HelpShortcutText',{Text=
'F1',Visible=false,BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size12,Position=UDim2.new(0,85,0,0),Size=UDim2.new(0,30,0,30),
TextColor3=Color3.new(0,1,0),ZIndex=P+4,Parent=S}),F('Screenshot',Enum.
ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.new(0,
254,0,256))V.Name='ScreenshotButton'V.ZIndex=P+4 V.Parent=R V.Visible=not x V:
SetVerb'Screenshot'do local W=U:clone()W.Name='ScreenshotShortcutText'W.Text=
'PrintSc'W.Position=UDim2.new(0,118,0,0)W.Visible=true W.Parent=V end local W=F(
'Record Video',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,
168,0,50),UDim2.new(0,254,0,306))W.Name='RecordVideoButton'W.ZIndex=P+4 W.Parent
=R W.Visible=not x W:SetVerb'RecordToggle'do local X=U:clone()X.Name=
'RecordVideoShortcutText'X.Visible=p X.Text='F12'X.Position=UDim2.new(0,120,0,0)
X.Parent=W end local X=a('ImageButton','StopRecordButton',{
BackgroundTransparency=1,Image='rbxasset://textures/ui/RecordStop.png',Size=
UDim2.new(0,59,0,27)})X:SetVerb'RecordToggle'X.MouseButton1Click:connect(
function()return I(W,X)end)X.Visible=false X.Parent=d local Y=F('Report Abuse',
Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,164,0,50),UDim2.
new(0,82,0,306))Y.Name='ReportAbuseButton'Y.ZIndex=P+4 Y.Parent=R do local Z=F(
'Leave Game',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,340,
0,50),UDim2.new(0,82,0,358))Z.Name='LeaveGameButton'Z.ZIndex=P+4 Z.Parent=R end
do local Z=F('Resume Game',Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.
Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,54))Z.Name='resumeGameButton'Z.
ZIndex=P+4 Z.Parent=R Z.Modal=true Z.MouseButton1Click:connect(function()return
C(Q)end)end local Z=F('Game Settings',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,156))Z.Name=
'SettingsButton'Z.ZIndex=P+4 Z.Parent=R if game:FindFirstChild(#game.
LoadingGuiService:GetChildren()>0)then Z=F('Game Instructions',Enum.ButtonStyle.
RobloxButton,Enum.FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,207))Z.
Name='GameInstructions'Z.ZIndex=P+4 Z.Parent=R Z.MouseButton1Click:connect(
function()if game:FindFirstChild(game.Players['LocalPlayer'])then local _=game.
Players.LocalPlayer:FindFirstChild'PlayerLoadingGui'if _ then _.Visible=true end
end end)end local _=F('Reset Character',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,105))_.Name='ResetButton'
_.ZIndex=P+4 _.Parent=R return R end local P P=function(Q,R)local S=a('Frame',
'GameSettingsMenu',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=Q+4,
a('TextLabel','Title',{Text='Settings',Size=UDim2.new(1,0,0,48),Position=UDim2.
new(0,9,0,-9),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,TextColor3=
Color3.new(1,1,1),ZIndex=Q+4,BackgroundTransparency=1}),a('TextLabel',
'FullscreenText',{Text='Fullscreen Mode',Size=UDim2.new(0,124,0,18),Position=
UDim2.new(0,62,0,145),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
TextColor3=Color3.new(1,1,1),ZIndex=Q+4,BackgroundTransparency=1})})local T,U=a(
'TextLabel','FullscreenShortcutText',{Visible=p,Text='F11',
BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size12,
Position=UDim2.new(0,186,0,141),Size=UDim2.new(0,30,0,30),TextColor3=Color3.new(
0,1,0),ZIndex=Q+4,Parent=S}),a('TextLabel','StudioText',{Visible=false,Text=
'Studio Mode',Size=UDim2.new(0,95,0,18),Position=UDim2.new(0,62,0,179),Font=Enum
.Font.Arial,FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),ZIndex=Q+
4,BackgroundTransparency=1,Parent=S})local V=T:clone()V.Name=
'StudioShortcutText'V.Visible=false V.Text='F2'V.Position=UDim2.new(0,154,0,175)
V.Parent=S local W if p then local X=a('TextLabel','QualityText',{Text=
'Graphics Quality',Size=UDim2.new(0,128,0,18),Position=UDim2.new(0,30,0,239),
Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),
ZIndex=Q+4,BackgroundTransparency=1,Parent=S,Visible=not w})local Y=X:clone()Y.
Name='AutoText'Y.Text='Auto'Y.Position=UDim2.new(0,183,0,214)Y.TextColor3=Color3
.new(0.5,0.5,0.5)Y.Size=UDim2.new(0,34,0,18)Y.Parent=S Y.Visible=not w local Z=Y
:clone()Z.Name='FasterText'Z.Text='Faster'Z.Position=UDim2.new(0,185,0,274)Z.
TextColor3=Color3.new(95,95,95)Z.FontSize=Enum.FontSize.Size14 Z.Parent=S Z.
Visible=not w local _=T:clone()_.Name='FasterShortcutText'_.Text='F10 + Shift'_.
Position=UDim2.new(0,185,0,283)_.Parent=S _.Visible=not w local aa=Y:clone()aa.
Name='BetterQualityText'aa.Text='Better Quality'aa.TextWrap=true aa.Size=UDim2.
new(0,41,0,28)aa.Position=UDim2.new(0,390,0,269)aa.TextColor3=Color3.new(95,95,
95)aa.FontSize=Enum.FontSize.Size14 aa.Parent=S aa.Visible=not w local ab,ac=T:
clone(){Name='BetterQualityShortcut',Text='F10',Position=UDim2.new(0,394,0,288),
Parent=S,Visible=not w},F('X',Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18
,UDim2.new(0,25,0,25),UDim2.new(0,187,0,239))ac.Name='AutoGraphicsButton'ac.
ZIndex=Q+4 ac.Parent=S ac.Visible=not w local ad,ae ad,ae=e.CreateSlider(q,150,
UDim2.new(0,230,0,280))ad.Parent=S ad.Bar.ZIndex=Q+4 ad.Bar.Slider.ZIndex=Q+5 ad
.Visible=not w ae.Value=math.floor((settings().Rendering:GetMaxQualityLevel()-1)
/2)local af,ag=a('TextBox','GraphicsSetter',{BackgroundColor3=Color3.new(0,0,0),
BorderColor3=Color3.new(0.5,0.5,0.5),Size=UDim2.new(0,50,0,25),Position=UDim2.
new(0,450,0,269),TextColor3=Color3.new(1,1,1),Font=Enum.Font.Arial,FontSize=Enum
.FontSize.Size18,Text='Auto',ZIndex=1,TextWrap=true,Parent=S,Visible=not w}),
true if not w then ag=UserSettings().GameSettings.SavedQualityLevel==Enum.
SavedQualitySetting.Automatic else settings().Rendering.EnableFRM=false end
local ah,ai=true,nil ai=function(aj)ag=aj if aj then ac.Text='X'aa.ZIndex=1 ab.
ZIndex=1 _.ZIndex=1 Z.ZIndex=1 ad.Bar.ZIndex=1 ad.Bar.Slider.ZIndex=1 af.ZIndex=
1 af.Text='Auto'else ac.Text=''ad.Bar.ZIndex=Q+4 ad.Bar.Slider.ZIndex=Q+5 ab.
ZIndex=Q+4 _.ZIndex=Q+4 aa.ZIndex=Q+4 Z.ZIndex=Q+4 af.ZIndex=Q+4 end end local
aj aj=function()ai(true)UserSettings().GameSettings.SavedQualityLevel=Enum.
SavedQualitySetting.Automatic settings().Rendering.QualityLevel=Enum.
QualityLevel.Automatic end local ak ak=function(al)local am=al/q local an=math.
floor((settings().Rendering:GetMaxQualityLevel()-1)*am)if an==20 then an=21
elseif al==1 then an=1 elseif an>settings().Rendering:GetMaxQualityLevel()then
an=settings().Rendering:GetMaxQualityLevel()-1 end UserSettings().GameSettings.
SavedQualityLevel=al settings().Rendering.QualityLevel=an end local al al=
function(am)ai(false)if am then ae.Value=am else ae.Value=math.floor((settings()
.Rendering.AutoFRMLevel/(settings().Rendering:GetMaxQualityLevel()-1)){q})end if
am==ae.Value then ak(ae.Value)end if not am then UserSettings().GameSettings.
SavedQualityLevel=ae.Value end af.Text=tostring(ae.Value)end local am am=
function()Y.ZIndex=Q+4 ac.ZIndex=Q+4 end local an an=function()Y.ZIndex=1 ac.
ZIndex=1 end local ao ao=function()ad.Bar.ZIndex=Q+4 ad.Bar.Slider.ZIndex=Q+5 ab
.ZIndex=Q+4 _.ZIndex=Q+4 aa.ZIndex=Q+4 Z.ZIndex=Q+4 af.ZIndex=Q+4 end local ap
ap=function()aa.ZIndex=1 ab.ZIndex=1 _.ZIndex=1 Z.ZIndex=1 ad.Bar.ZIndex=1 ad.
Bar.Slider.ZIndex=1 af.ZIndex=1 end local aq aq=function(ar)if Enum.
SavedQualitySetting.Automatic==ar then return 0 elseif Enum.SavedQualitySetting.
QualityLevel1==ar then return 1 elseif Enum.SavedQualitySetting.QualityLevel2==
ar then return 2 elseif Enum.SavedQualitySetting.QualityLevel3==ar then return 3
elseif Enum.SavedQualitySetting.QualityLevel4==ar then return 4 elseif Enum.
SavedQualitySetting.QualityLevel5==ar then return 5 elseif Enum.
SavedQualitySetting.QualityLevel6==ar then return 6 elseif Enum.
SavedQualitySetting.QualityLevel7==ar then return 7 elseif Enum.
SavedQualitySetting.QualityLevel8==ar then return 8 elseif Enum.
SavedQualitySetting.QualityLevel9==ar then return 9 elseif Enum.
SavedQualitySetting.QualityLevel10==ar then return 10 end end local ar ar=
function()settings().Rendering.EnableFRM=true ag=(UserSettings().GameSettings.
SavedQualityLevel==Enum.SavedQualitySetting.Automatic)if ag then am()return aj()
else am()ao()return al(aq(UserSettings().GameSettings.SavedQualityLevel))end end
local as as=function()ap()an()settings().Rendering.EnableFRM=false end af.
FocusLost:connect(function()if ag then af.Text=tostring(ae.Value)return end
local at=tonumber(af.Text)if not(at~=nil)then af.Text=tostring(ae.Value)return
end if at<1 then at=1 elseif at>=settings().Rendering:GetMaxQualityLevel()then
at=settings().Rendering:GetMaxQualityLevel()-1 end ae.Value=at ak(ae.Value)af.
Text=tostring(ae.Value)end)ae.Changed:connect(function(at)if ag then return end
if not ah then return end af.Text=tostring(ae.Value)return ak(ae.Value)end)if w
or UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.
Automatic then if w then settings().Rendering.EnableFRM=false as()else settings(
).Rendering.EnableFRM=true aj()end else settings().Rendering.EnableFRM=true al(
aq(UserSettings().GameSettings.SavedQualityLevel))end ac.MouseButton1Click:
connect(function()if w and not game.Players.LocalPlayer then return end if not
ag then return aj()else return al(ae.Value)end end)game.
GraphicsQualityChangeRequest:connect(function(at)if ag then return end if at
then if(ae.Value+1)>q then return end ae.Value=ae.Value+1 af.Text=tostring(ae.
Value)ak(ae.Value)return game:GetService'GuiService':SendNotification(
'Graphics Quality','Increased to ('..tostring(af.Text)..')','',2,function()end)
else if(ae.Value-1)<=0 then return end ae.Value=ae.Value-1 af.Text=tostring(ae.
Value)ak(ae.Value)return game:GetService'GuiService':SendNotification(
'Graphics Quality','Decreased to ('..tostring(af.Text)..')','',2,function()end)
end end)game.Players.PlayerAdded:connect(function(at)if at==game.Players.
LocalPlayer and w then return ar()end end)game.Players.PlayerRemoving:connect(
function(at)if at==game.Players.LocalPlayer and w then return as()end end)W=F(''
,Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.
new(0,30,0,176))W.Name='StudioCheckbox'W.ZIndex=Q+4 W:SetVerb'TogglePlayMode'W.
Visible=false local at=(settings().Rendering.QualityLevel~=Enum.QualityLevel.
Automatic)if w and not game.Players.LocalPlayer then W.Text='X'as()elseif w then
W.Text='X'ar()end if p then UserSettings().GameSettings.StudioModeChanged:
connect(function(au)w=au if au then at=(settings().Rendering.QualityLevel~=Enum.
QualityLevel.Automatic)aj()W.Text='X'ac.ZIndex=1 Y.ZIndex=1 else if at then al()
end W.Text=''ac.ZIndex=Q+4 Y.ZIndex=Q+4 end end)else W.MouseButton1Click:
connect(function()if not W.Active then return end if W.Text==''then W.Text='X'
else W.Text=''end end)end end local aa=F('',Enum.ButtonStyle.RobloxButton,Enum.
FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,30,0,144))aa.Name=
'FullscreenCheckbox'aa.ZIndex=Q+4 aa.Parent=S aa:SetVerb'ToggleFullScreen'if
UserSettings().GameSettings:InFullScreen()then aa.Text='X'end if p then
UserSettings().GameSettings.FullscreenChanged:connect(function(ab)if ab then aa.
Text='X'else aa.Text=''end end)else aa.MouseButton1Click:connect(function()if aa
.Text==''then aa.Text='X'else aa.Text=''end end)end if game:FindFirstChild
'NetworkClient'then K(U)K(V)K(W)end local ab if p then ab=F('OK',Enum.
ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2
.new(0,170,0,330))ab.Modal=true else ab=F('OK',Enum.ButtonStyle.
RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2.new(0,170,0
,270))ab.Modal=true end ab.Name='BackButton'ab.ZIndex=Q+4 ab.Parent=S if not x
then a('TextLabel','VideoCaptureLabel',{Text='After Capturing Video',Font=Enum.
Font.Arial,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0,32,0,100),Size=
UDim2.new(0,164,0,18),BackgroundTransparency=1,TextColor3=A(255,255,255),
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=Q+4,Parent=S})local ac,ad={},{}ac
[1]='Just Save to Disk'ad[ac[1]]=Enum.UploadSetting['Never']ac[2]=
'Upload to YouTube'ad[ac[2]]=Enum.UploadSetting['Ask me first']local ae ae,l=e.
CreateDropDownMenu(ac,function(af)UserSettings().GameSettings.
VideoUploadPromptBehavior=ad[af]end)ae.Name='VideoCaptureField'ae.ZIndex=Q+4 ae.
DropDownMenuButton.ZIndex=Q+4 ae.DropDownMenuButton.Icon.ZIndex=Q+4 ae.Position=
UDim2.new(0,270,0,94)ae.Size=UDim2.new(0,200,0,32)ae.Parent=S f=function()return
l((function()if UserSettings().GameSettings.VideoUploadPromptBehavior==Enum.
UploadSetting['Never']then return ac[1]elseif UserSettings().GameSettings.
VideoUploadPromptBehavior==Enum.UploadSetting['Ask me first']then return ac[2]
else UserSettings().GameSettings.VideoUploadPromptBehavior=Enum.UploadSetting[
'Ask me first']return ac[2]end end)())end end a('TextLabel','CameraLabel',{Text=
'Character & Camera Controls',Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18
,Position=UDim2.new(0,31,0,58),Size=UDim2.new(0,224,0,18),TextColor3=A(255,255,
255),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ZIndex=Q+4
,Parent=S})j=game.CoreGui.RobloxGui:FindFirstChild('MouseLockLabel',true)local
ac,ad,ae=Enum.ControlMode:GetEnumItems(),{},{}for af,ag in ipairs(ac)do ad[af]=
ag.Name ae[ag.Name]=ag end local ah ah,k=e.CreateDropDownMenu(ad,function(ai)
UserSettings().GameSettings.ControlMode=ae[ai]return pcall(function()if j and
UserSettings().GameSettings.ControlMode==Enum.ControlMode['Mouse Lock Switch']
then j.Visible=true elseif j then j.Visible=false end end)end)ah.Name=
'CameraField'ah.ZIndex=Q+4 ah.DropDownMenuButton.ZIndex=Q+4 ah.
DropDownMenuButton.Icon.ZIndex=Q+4 ah.Position=UDim2.new(0,270,0,52)ah.Size=
UDim2.new(0,200,0,32)ah.Parent=S return S end if LoadLibrary then e=LoadLibrary
'RbxGui'local aa=0 if UserSettings then local ab ab=function()b(d,
'BottomLeftControl')g=d.BottomLeftControl:FindFirstChild'SettingsButton'if not(g
~=nil)then g=a('ImageButton','SettingsButton',{Image=
'rbxasset://textures/ui/SettingsButton.png',BackgroundTransparency=1,Active=
false,Size=UDim2.new(0,54,0,46),Position=UDim2.new(0,2,0,50),Parent=d.
BottomLeftControl})end local ac=a('TextButton','UserSettingsShield',{Text='',
Active=true,AutoButtonColor=false,Visible=false,Size=UDim2.new(1,0,1,0),
BackgroundColor3=A(51,51,51),BorderColor3=A(27,42,53),BackgroundTransparency=0.4
,ZIndex=aa+2})v=ac local ad=a('Frame','Settings',{Position=UDim2.new(0.5,-262,-
0.5,-200),Size=UDim2.new(0,525,0,430),BackgroundTransparency=1,Active=true,
Parent=ac})i=a('Frame','SettingsStyle',{Size=UDim2.new(1,0,1,0),Style=Enum.
FrameStyle.RobloxRound,Active=true,ZIndex=aa+3,Parent=ad})local ae=O(aa,ac)ae.
Parent=i ae.ScreenshotButton.MouseButton1Click:connect(function()return J(ae.
ScreenshotButton,ac,g)end)ae.RecordVideoButton.MouseButton1Click:connect(
function()I(ae.RecordVideoButton,d.StopRecordButton)return J(ae.
RecordVideoButton,ac,g)end)if settings():FindFirstChild'Game Options'then pcall(
function()return settings():FindFirstChild'Game Options'.
VideoRecordingChangeRequest:connect(function(af)r=af return H(af,d.
StopRecordButton,ae.RecordVideoButton)end)end)end game.CoreGui.RobloxGui.Changed
:connect(function(af)if af=='AbsoluteSize'and r then return I(ae.
RecordVideoButton,d.StopRecordButton)end end)local af af=function()ae.
ResetButton.Visible=game.Players.LocalPlayer if game.Players.LocalPlayer then
settings().Rendering.EnableFRM=true elseif w then settings().Rendering.EnableFRM
=false end end ae.ResetButton.Visible=game.Players.LocalPlayer if(game.Players.
LocalPlayer~=nil)then game.Players.LocalPlayer.Changed:connect(function()return
af()end)else delay(0,function()c(game.Players,'LocalPlayer')ae.ResetButton.
Visible=game.Players.LocalPlayer return game.Players.LocalPlayer.Changed:
connect(function()return af()end)end)end ae.ReportAbuseButton.Visible=game:
FindFirstChild'NetworkClient'if not ae.ReportAbuseButton.Visible then game.
ChildAdded:connect(function(ag)if ag:IsA'NetworkClient'then ae.ReportAbuseButton
.Visible=game:FindFirstChild'NetworkClient'end end)end ae.ResetButton.
MouseButton1Click:connect(function()return D(i,'ResetConfirmationMenu','up',
UDim2.new(0,525,0,370))end)ae.LeaveGameButton.MouseButton1Click:connect(function
()return D(i,'LeaveConfirmationMenu','down',UDim2.new(0,525,0,300))end)if game.
CoreGui.Version>=4 then game:GetService'GuiService'.EscapeKeyPressed:connect(
function()if not(s~=nil)then return game.GuiService:AddCenterDialog(ac,Enum.
CenterDialogType.ModalDialog,function()g.Active=false k(UserSettings().
GameSettings.ControlMode.Name)if f~=nil then f()end D(i,'GameMainMenu','right',
UDim2.new(0,525,0,430))ac.Visible=true ac.Active=true i.Parent:TweenPosition(
UDim2.new(0.5,-262,0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,
true)return i.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut
,Enum.EasingStyle.Sine,m,true)end,function()i.Parent:TweenPosition(UDim2.new(0.5
,-262,-0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)i.
Parent:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,m,true)ac.Visible=false g.Active=true end)elseif#t>0 then if#u>
0 then for ag=1,#u do game.GuiService:RemoveCenterDialog(u[ag])u[ag].Visible=
false end u={}end D(t[#t]['container'],t[#t]['name'],t[#t]['direction'],t[#t][
'lastSize'])table.remove(t,#t)if#t==1 then t={}end else return C(ac)end end)end
local ag=P(aa,ac)ag.Visible=false ag.Parent=i ae.SettingsButton.
MouseButton1Click:connect(function()return D(i,'GameSettingsMenu','left',UDim2.
new(0,525,0,350))end)ag.BackButton.MouseButton1Click:connect(function()return D(
i,'GameMainMenu','right',UDim2.new(0,525,0,430))end)local ah=N(aa,ac)ah.Visible=
false ah.Parent=i local ai=M(aa,ac)ai.Visible=false ai.Parent=i B(ac)g.
MouseButton1Click:connect(function()return game.GuiService:AddCenterDialog(ac,
Enum.CenterDialogType.ModalDialog,function()g.Active=false k(UserSettings().
GameSettings.ControlMode.Name)if f~=nil then f()end D(i,'GameMainMenu','right',
UDim2.new(0,525,0,430))ac.Visible=true i.Parent:TweenPosition(UDim2.new(0.5,-262
,0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)return i.
Parent:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.
EasingStyle.Sine,m,true)end,function()i.Parent:TweenPosition(UDim2.new(0.5,-262,
-0.5,-200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,m,true)i.Parent:
TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.
Sine,m,true)ac.Visible=false g.Active=true end)end)return ac end delay(0,
function()ab().Parent=d d.BottomLeftControl.SettingsButton.Active=true d.
BottomLeftControl.SettingsButton.Position=UDim2.new(0,2,0,-2)if j and
UserSettings().GameSettings.ControlMode==Enum.ControlMode['Mouse Lock Switch']
then j.Visible=true elseif j then j.Visible=false end local ac=d.
BottomLeftControl:FindFirstChild'Exit'if ac then ac:Remove()end local ad=d:
FindFirstChild'TopLeftControl'if ad then ac=ad:FindFirstChild'Exit'if ac then ac
:Remove()end return ad:Remove()end end)end local ab ab=function()local ac,ad,ae,
af,ag,ah,ai=a('TextButton','SaveDialogShield',{Text='',AutoButtonColor=false,
Active=true,Visible=false,Size=UDim2.new(1,0,1,0),BackgroundColor3=A(51,51,51),
BorderColor3=A(27,42,53),BackgroundTransparency=0.4,ZIndex=aa+1}),nil,nil,nil,
nil,nil,{}ai[1]={}ai[1].Text='Save'ai[1].Style=Enum.ButtonStyle.
RobloxButtonDefault ai[1].Function=function()return ae()end ai[2]={}ai[2].Text=
'Cancel'ai[2].Function=function()return ah()end ai[3]={}ai[3].Text="Don't Save"
ai[3].Function=function()return ag()end local aj=e.CreateStyledMessageDialog(
'Unsaved Changes','Save your changes to Mercury before leaving?','Confirm',ai)aj
.Visible=true aj.Parent=ac local ak,al={},1 if game.LocalSaveEnabled then ak[al]
={}ak[al].Text='Save to Disk'ak[al].Function=function()return af()end al=al+1
end ak[al]={}ak[al].Text='Keep Playing'ak[al].Function=function()return ah()end
ak[al+1]={}ak[al+1].Text="Don't Save"ak[al+1].Function=function()return ag()end
local am=e.CreateStyledMessageDialog('Upload Failed',
'Sorry, we could not save your changes to Mercury.','Error',ak)am.Visible=false
am.Parent=ac local an=a('Frame','SpinnerDialog',{Style=Enum.FrameStyle.
RobloxRound,Size=UDim2.new(0,350,0,150),Position=UDim2.new(0.5,-175,0.5,-75),
Visible=false,Active=true,Parent=ac,a('TextLabel','WaitingLabel',{Text=
'Saving to Mercury...',Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0.5,25,0.5,0),TextColor3=Color3.new(1,1,1)})})local ao,ap,aq=
a('Frame','Spinner',{Size=UDim2.new(0,80,0,80),Position=UDim2.new(0.5,-150,0.5,-
40),BackgroundTransparency=1,Parent=an}),{},1 while aq<=8 do local ar=a(
'ImageLabel','Spinner'..tostring(aq),{Size=UDim2.new(0,16,0,16),Position=UDim2.
new(0.5+0.3*math.cos(math.rad(45*aq)),-8,0.5+0.3*math.sin(math.rad(45*aq)),-8),
BackgroundTransparency=1,Image='http://www.roblox.com/Asset?id=45880710',Parent=
ao})ap[aq]=ar aq=aq+1 end ae=function()aj.Visible=false an.Visible=true local ar
=true delay(0,function()local as=0 while ar do local at=0 while at<8 do ap[at+1]
.Image='http://www.roblox.com/Asset?id='..(function()if at==as or at==((as+1)%8)
then return 45880668 else return 45880710 end end)()at=at+1 end as=(as+1)%8
wait(0.2)end end)local as=game:SaveToRoblox()if not as then as=game:
SaveToRoblox()end an.Visible=false ar=false if as then game:FinishShutdown(false
)return ad()else am.Visible=true end end af=function()am.Visible=false game:
FinishShutdown(true)return ad()end ag=function()aj.Visible=false am.Visible=
false game:FinishShutdown(false)return ad()end ah=function()aj.Visible=false am.
Visible=false return ad()end ad=function()aj.Visible=true am.Visible=false an.
Visible=false ac.Visible=false return game.GuiService:RemoveCenterDialog(ac)end
B(ac)ac.Visible=false return ac end local ac ac=function()b(game,'NetworkClient'
)b(game,'Players')c(game.Players,'LocalPlayer')local ad,ae=game.Players.
LocalPlayer,nil b(d,'UserSettingsShield')b(d.UserSettingsShield,'Settings')b(d.
UserSettingsShield.Settings,'SettingsStyle')b(d.UserSettingsShield.Settings.
SettingsStyle,'GameMainMenu')b(d.UserSettingsShield.Settings.SettingsStyle.
GameMainMenu,'ReportAbuseButton')ae=d.UserSettingsShield.Settings.SettingsStyle.
GameMainMenu.ReportAbuseButton local af,ag,ah=a('TextButton','ReportAbuseShield'
,{Text='',AutoButtonColor=false,Active=true,Visible=false,Size=UDim2.new(1,0,1,0
),BackgroundColor3=A(51,51,51),BorderColor3=A(27,42,53),BackgroundTransparency=
0.4,ZIndex=aa+1}),nil,{}ah[1]={}ah[1].Text='Ok'ah[1].Modal=true ah[1].Function=
function()return ag()end local ai=e.CreateMessageDialog(
'Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.

If anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats]]
,ah)ai.Visible=false ai.Parent=af local aj=e.CreateMessageDialog(
'Thanks for your report!',"We've recorded your report for evaluation.",ah)aj.
Visible=false aj.Parent=af local ak=e.CreateMessageDialog(
'Thanks for your report!',
[[Our moderators will review the chat logs and determine what happened.]],ah)ak.
Visible=false ak.Parent=af local al=a('Frame','Settings',{Position=UDim2.new(0.5
,-250,0.5,-200),Size=UDim2.new(0,500,0,400),BackgroundTransparency=1,Active=true
,Parent=af})i=a('Frame','ReportAbuseStyle',{Size=UDim2.new(1,0,1,0),Style=Enum.
FrameStyle.RobloxRound,Active=true,ZIndex=aa+1,Parent=al,a('TextLabel','Title',{
Text='Report Abuse',TextColor3=A(221,221,221),Position=UDim2.new(0.5,0,0,30),
Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36,ZIndex=aa+2}),a(
'TextLabel','Description',{Text=
[[This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.]]
,TextColor3=A(221,221,221),Position=UDim2.new(0,0,0,55),Size=UDim2.new(1,0,0,40)
,BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
TextWrap=true,ZIndex=aa+2,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment
=Enum.TextYAlignment.Top}),a('TextLabel','PlayerLabel',{Text='Which player?',
BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0.025,0,0,100),Size=UDim2.new(0.4,0,0,36),TextColor3=A(255,
255,255),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=aa+2}),a('TextLabel',
'AbuseLabel',{Text='Type of Abuse:',Font=Enum.Font.Arial,BackgroundTransparency=
1,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0.025,0,0,140),Size=UDim2.
new(0.4,0,0,36),TextColor3=A(255,255,255),TextXAlignment=Enum.TextXAlignment.
Left,ZIndex=aa+2})})local am,an,ao,ap,aq aq=function()local ar,as,at=game:
GetService'Players',{},{}local au,Q=ar:GetChildren(),1 if au then for R,S in
ipairs(au)do if S:IsA'Player'and S~=ad then as[Q]=S.Name at[S.Name]=S Q=Q+1 end
end end local R R,ap=e.CreateDropDownMenu(as,function(S)am=at[S]if an and am
then ao.Active=true end end)R.Name='PlayersComboBox'R.ZIndex=aa+2 R.Position=
UDim2.new(0.425,0,0,102)R.Size=UDim2.new(0.55,0,0,32)return R end local ar,as,at
={'Swearing','Bullying','Scamming','Dating','Cheating/Exploiting',
'Personal Questions','Offsite Links','Bad Model or Script','Bad Username'},nil,
nil as,at=e.CreateDropDownMenu(ar,function(au)an=au if an and am then ao.Active=
true end end,true)as.Name='AbuseComboBox'as.ZIndex=aa+2 as.Position=UDim2.new(
0.425,0,0,142)as.Size=UDim2.new(0.55,0,0,32)as.Parent=i a('TextLabel',
'ShortDescriptionLabel',{Text='Short Description: (optional)',Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0.025,0,0,180),Size=UDim2
.new(0.95,0,0,36),TextColor3=A(255,255,255),TextXAlignment=Enum.TextXAlignment.
Left,BackgroundTransparency=1,ZIndex=aa+2,Parent=i})local au=a('Frame',
'ShortDescriptionWrapper',{Position=UDim2.new(0.025,0,0,220),Size=UDim2.new(0.95
,0,1,-310),BackgroundColor3=A(0,0,0),BorderSizePixel=0,ZIndex=aa+2,Parent=i})
local Q=a('TextBox','TextBox',{Text='',ClearTextOnFocus=false,Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0,3,0,3),Size=UDim2.new(1
,-6,1,-6),TextColor3=A(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,TextWrap=true,BackgroundColor3=A(0,0,0),
BorderSizePixel=0,ZIndex=aa+2,Parent=au})ao=a('TextButton','SubmitReportBtn',{
Active=false,Modal=true,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0.1,0,1,-80),Size=UDim2.new(0.35,0,0,50),AutoButtonColor=true
,Style=Enum.ButtonStyle.RobloxButtonDefault,Text='Submit Report',TextColor3=A(
255,255,255),ZIndex=aa+2,Parent=i})ao.MouseButton1Click:connect(function()if ao.
Active then if an and am then al.Visible=false game.Players:ReportAbuse(am,an,Q.
Text)if an=='Cheating/Exploiting'then aj.Visible=true elseif an=='Bullying'or an
=='Swearing'then ai.Visible=true else ak.Visible=true end else return ag()end
end end)local R=a('TextButton','CancelBtn',{Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size18,Position=UDim2.new(0.55,0,1,-80),Size=UDim2.new(0.35,0,0,50),
AutoButtonColor=true,Style=Enum.ButtonStyle.RobloxButtonDefault,Text='Cancel',
TextColor3=A(255,255,255),ZIndex=aa+2,Parent=i})ag=function()local S=i:
FindFirstChild'PlayersComboBox'if S then S.Parent=nil end am=nil ap(nil)an=nil
at(nil)ao.Active=false Q.Text=''al.Visible=true ai.Visible=false aj.Visible=
false ak.Visible=false af.Visible=false ae.Active=true return game.GuiService:
RemoveCenterDialog(af)end R.MouseButton1Click:connect(ag)ae.MouseButton1Click:
connect(function()aq().Parent=i table.insert(u,af)return game.GuiService:
AddCenterDialog(af,Enum.CenterDialogType.ModalDialog,function()ae.Active=false
af.Visible=true v.Visible=false end,function()ae.Active=true af.Visible=false
end)end)B(af)return af end local ad=pcall(function()end)if ad then delay(0,
function()local ae=ab()ae.Parent=d game.RequestShutdown=function()table.insert(u
,ae)game.GuiService:AddCenterDialog(ae,Enum.CenterDialogType.QuitDialog,function
()ae.Visible=true end,function()ae.Visible=false end)return true end end)end
delay(0,function()ac().Parent=d b(d,'UserSettingsShield')b(d.UserSettingsShield,
'Settings')b(d.UserSettingsShield.Settings,'SettingsStyle')b(d.
UserSettingsShield.Settings.SettingsStyle,'GameMainMenu')b(d.UserSettingsShield.
Settings.SettingsStyle.GameMainMenu,'ReportAbuseButton')d.UserSettingsShield.
Settings.SettingsStyle.GameMainMenu.ReportAbuseButton.Active=true end)pcall(
function()return game.GuiService.UseLuaChat end)local ae=41324860 return delay(0
,function()b(game,'NetworkClient')b(game,'Players')c(game.Players,'LocalPlayer')
c(game.Players.LocalPlayer,'Character')b(game.Players.LocalPlayer.Character,
'Humanoid')c(game,'PlaceId')if game.PlaceId==ae then game.Players.LocalPlayer.
Character.Humanoid:SetClickToWalkEnabled(false)return game.Players.LocalPlayer.
CharacterAdded:connect(function(af)b(af,'Humanoid')return af.Humanoid:
SetClickToWalkEnabled(false)end)end end)end