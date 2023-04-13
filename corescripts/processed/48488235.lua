local a,b,c,d,e={taskmanager=1,Heliodex=1,multako=
'http://www.roblox.com/asset/?id=6923328292',mercury=1,pizzaboxer=
'http://www.roblox.com/asset/?id=6917566633'},{bottomDark='94691904',bottomLight
='94691940',midDark='94691980',midLight='94692025',LargeDark='96098866',
LargeLight='96098920',LargeHeader='96097470',NormalHeader='94692054',LargeBottom
='96397271',NormalBottom='94754966',DarkBluePopupMid='97114905',
LightBluePopupMid='97114905',DarkPopupMid='97112126',LightPopupMid='97109338',
DarkBluePopupTop='97114838',DarkBluePopupBottom='97114758',DarkPopupBottom=
'100869219',LightPopupBottom='97109175'},0.25,15,{}function e.Create(f)return
function(g)local h=Instance.new(f)for i,j in pairs(g)do if type(i)=='number'then
j.Parent=h else h[i]=j end end return h end end function MakeBackgroundGuiObj(f)
return e.Create'ImageLabel'{Name='Background',BackgroundTransparency=1,Image=f,
Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0)}end function Color3I(f,g,h)
return Color3.new(f/255,g/255,h/255)end function getMembershipTypeIcon(f,g)if a[
string.lower(g)]~=nil then if a[string.lower(g)]==1 then return
'http://www.roblox.com/asset/?id=6923330951'else return a[string.lower(g)]end
elseif f==Enum.MembershipType.None then return''elseif f==Enum.MembershipType.
BuildersClub then return'rbxasset://textures/ui/TinyBcIcon.png'elseif f==Enum.
MembershipType.TurboBuildersClub then return
'rbxasset://textures/ui/TinyTbcIcon.png'elseif f==Enum.MembershipType.
OutrageousBuildersClub then return'rbxasset://textures/ui/TinyObcIcon.png'else
error('Unknown membershipType'..f)end end local function getFriendStatusIcon(f)
if f==Enum.FriendStatus.Unknown or f==Enum.FriendStatus.NotFriend then return''
elseif f==Enum.FriendStatus.Friend then return
'http://www.roblox.com/asset/?id=99749771'elseif f==Enum.FriendStatus.
FriendRequestSent then return'http://www.roblox.com/asset/?id=99776888'elseif f
==Enum.FriendStatus.FriendRequestReceived then return
'http://www.roblox.com/asset/?id=99776838'else error('Unknown FriendStatus: '..f
)end end function MakePopupButton(f,g,h,i)local j=e.Create'ImageButton'{Name=
'ReportButton',BackgroundTransparency=1,Position=UDim2.new(0,0,1*h,0),Size=UDim2
.new(1,0,1,0),ZIndex=7,e.Create'TextLabel'{Name='ButtonText',
BackgroundTransparency=1,Position=UDim2.new(0.07,0,0.07,0),Size=UDim2.new(0.86,0
,0.86,0),Parent=HeaderFrame,Font='ArialBold',Text=g,FontSize='Size14',TextScaled
=true,TextColor3=Color3.new(1,1,1),TextStrokeTransparency=1,ZIndex=7},Parent=f}
if h==0 then j.Image='http://www.roblox.com/asset/?id=97108784'elseif i then if
h%2==1 then j.Image='http://www.roblox.com/asset/?id='..b['LightPopupBottom']
else j.Image='http://www.roblox.com/asset/?id='..b['DarkPopupBottom']end else if
h%2==1 then j.Image='http://www.roblox.com/asset/?id=97112126'else j.Image=
'http://www.roblox.com/asset/?id=97109338'end end return j end function
WaitForChild(f,g)while not f:FindFirstChild(g)do wait()debugprint(' child '..f.
Name..' waiting for '..g)end return f[g]end local f=game:GetService'Players'
while not f.LocalPlayer do f.Changed:wait()end local g=f.LocalPlayer local h,i=g
:GetMouse(),e.Create'Frame'{Name='PlayerListScreen',Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,Parent=script.Parent}local j=e.Create'Frame'{Name=
'LeaderBoardFrame',Position=UDim2.new(1,-150,0.005,0),Size=UDim2.new(0,150,0,800
),BackgroundTransparency=1,Parent=i}local k,l=e.Create'Frame'{Name='FocusFrame',
Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,100),BackgroundTransparency=1,
Active=true,Parent=j},e.Create'Frame'{Name='Header',BackgroundTransparency=1,
Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0.07,0),Parent=j,
MakeBackgroundGuiObj'http://www.roblox.com/asset/?id=94692054'}local m,n,o,p=l.
Size.Y.Scale,e.Create'ImageButton'{Name='MaximizeButton',Active=true,
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
Parent=l},e.Create'TextLabel'{Name='PlayerName',BackgroundTransparency=1,
Position=UDim2.new(0,0,0.01,0),Size=UDim2.new(0.98,0,0.38,0),Parent=l,Font=
'ArialBold',Text=g.Name,FontSize='Size24',TextColor3=Color3.new(1,1,1),
TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0,TextXAlignment=
'Right',TextYAlignment='Center'},e.Create'TextLabel'{Name='PlayerScore',
BackgroundTransparency=1,Position=UDim2.new(0,0,0.4,0),Size=UDim2.new(0.98,0,0,
30),Parent=l,Font='ArialBold',Text='',FontSize='Size24',TextYAlignment='Top',
TextColor3=Color3.new(1,1,1),TextStrokeTransparency=1,TextXAlignment='Right'}
local q=e.Create'Frame'{Name='BottomShiftFrame',BackgroundTransparency=1,
Position=UDim2.new(0,0,m,0),Size=UDim2.new(1,0,1,0),Parent=j}local r=e.Create
'Frame'{Name='Bottom',BackgroundTransparency=1,Position=UDim2.new(0,0,0.07,0),
Size=UDim2.new(1,0,0.03,0),Parent=q,MakeBackgroundGuiObj
'http://www.roblox.com/asset/?id=94754966'}local s,t,u=e.Create'ImageButton'{
Name='bigbutton',Active=true,BackgroundTransparency=1,Position=UDim2.new(0,0,0,0
),Size=UDim2.new(1,0,1.5,0),ZIndex=3,Parent=r},e.Create'ImageButton'{Name=
'extendTab',Active=true,BackgroundTransparency=1,Image=
'http://www.roblox.com/asset/?id=94692731',Position=UDim2.new(0.608,0,0.3,0),
Size=UDim2.new(0.3,0,0.7,0),Parent=r},e.Create'Frame'{Name='ListFrame',
BackgroundTransparency=1,Position=UDim2.new(-1,0,0.07,0),Size=UDim2.new(2,0,1,0)
,Parent=j,ClipsDescendants=true}local v=e.Create'Frame'{Name='BottomFrame',
BackgroundTransparency=1,Position=UDim2.new(0,0,-0.8,0),Size=UDim2.new(1,0,1,0),
Parent=u,ClipsDescendants=true}local w=e.Create'Frame'{Name='ScrollBarFrame',
BackgroundTransparency=1,Position=UDim2.new(0.987,0,0.8,0),Size=UDim2.new(0.01,0
,0.2,0),Parent=v}local x,y,z,A=e.Create'Frame'{Name='ScrollBar',
BackgroundTransparency=0,BackgroundColor3=Color3.new(0.2,0.2,0.2),Position=UDim2
.new(0,0,0,0),Size=UDim2.new(1,0,0.5,0),ZIndex=5,Parent=w},e.Create'Frame'{Name=
'SubFrame',BackgroundTransparency=1,Position=UDim2.new(0,0,0.8,0),Size=UDim2.
new(1,0,1,0),Parent=v},e.Create'Frame'{Name='PopUpFrame',BackgroundTransparency=
1,SizeConstraint='RelativeXX',Position=j.Position+UDim2.new(0,-150,0,0),Size=
UDim2.new(0,150,0,800),Parent=j,ClipsDescendants=true,ZIndex=7},nil local B,C,D,
E,F,G,H,I,J=e.Create'Frame'{Name='Panel',BackgroundTransparency=1,Position=UDim2
.new(1,0,0,0),Size=UDim2.new(1,0,0.032,0),Parent=z},e.Create'Frame'{Name=
'StatTitles',BackgroundTransparency=1,Position=UDim2.new(0,0,1,-10),Size=UDim2.
new(1,0,0,0),Parent=l},Instance.new'BoolValue',Instance.new'BoolValue',Instance.
new'BoolValue',Instance.new'BoolValue',e.Create'Frame'{Name='MidTemplate',
BackgroundTransparency=1,Position=UDim2.new(100,0,0.07,0),Size=UDim2.new(0.5,0,
0.025,0),e.Create'ImageLabel'{Name='BCLabel',Active=true,BackgroundTransparency=
1,Position=UDim2.new(0.005,5,0.2,0),Size=UDim2.new(0,16,0,16),SizeConstraint=
'RelativeYY',Image='',ZIndex=3},e.Create'ImageLabel'{Name='FriendLabel',Active=
true,BackgroundTransparency=1,Position=UDim2.new(0.005,5,0.15,0),Size=UDim2.new(
0,16,0,16),SizeConstraint='RelativeYY',Image='',ZIndex=3},e.Create'ImageButton'{
Name='ClickListener',Active=true,BackgroundTransparency=1,Position=UDim2.new(
0.005,1,0,0),Size=UDim2.new(0.96,0,1,0),ZIndex=3},e.Create'Frame'{Name=
'TitleFrame',BackgroundTransparency=1,Position=UDim2.new(0.01,0,0,0),Size=UDim2.
new(0,140,1,0),ClipsDescendants=true,e.Create'TextLabel'{Name='Title',
BackgroundTransparency=1,Position=UDim2.new(0,5,0,0),Size=UDim2.new(100,0,1,0),
Font='Arial',FontSize='Size14',TextColor3=Color3.new(1,1,1),TextXAlignment=
'Left',TextYAlignment='Center',ZIndex=3}},e.Create'TextLabel'{Name='PlayerScore'
,BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
Font='ArialBold',Text='',FontSize='Size14',TextColor3=Color3.new(1,1,1),
TextXAlignment='Right',TextYAlignment='Center',ZIndex=3},ZIndex=3},e.Create
'Frame'{Name='MidBGTemplate',BackgroundTransparency=1,Position=UDim2.new(100,0,
0.07,0),Size=UDim2.new(0.5,0,0.025,0),MakeBackgroundGuiObj
'http://www.roblox.com/asset/?id=94692025'},e.Create'TextButton'{Name=
'ReportAbuseShield',Text='',AutoButtonColor=false,Active=true,Visible=true,Size=
UDim2.new(1,0,1,0),BackgroundColor3=Color3I(51,51,51),BorderColor3=Color3I(27,42
,53),BackgroundTransparency=1}local K=e.Create'Frame'{Name='Settings',Position=
UDim2.new(0.5,-250,0.5,-200),Size=UDim2.new(0,500,0,400),BackgroundTransparency=
1,Active=true,Parent=J}local L=e.Create'Frame'{Name='ReportAbuseStyle',Size=
UDim2.new(1,0,1,0),Active=true,BackgroundTransparency=1,MakeBackgroundGuiObj
'http://www.roblox.com/asset/?id=96488767',e.Create'TextLabel'{Name='Title',Text
='Report Abuse',TextColor3=Color3I(221,221,221),Position=UDim2.new(0.5,0,0,30),
Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36},e.Create'TextLabel'{Name
='Description',Text=
[[This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.]]
,TextColor3=Color3I(221,221,221),Position=UDim2.new(0.01,0,0,55),Size=UDim2.new(
0.99,0,0,40),BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size18,TextWrap=true,TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top},e.Create'TextLabel'{Name='AbuseLabel',
Text='What did they do?',Font=Enum.Font.Arial,BackgroundTransparency=1,FontSize=
Enum.FontSize.Size18,Position=UDim2.new(0.025,0,0,140),Size=UDim2.new(0.4,0,0,36
),TextColor3=Color3I(255,255,255),TextXAlignment=Enum.TextXAlignment.Left},e.
Create'TextLabel'{Name='ShortDescriptionLabel',Text=
'Short Description: (optional)',Font=Enum.Font.Arial,FontSize=Enum.FontSize.
Size18,Position=UDim2.new(0.025,0,0,180),Size=UDim2.new(0.95,0,0,36),TextColor3=
Color3I(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,
BackgroundTransparency=1},e.Create'TextLabel'{Name='ReportingPlayerLabel',Text=
'Reporting Player',BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size18,Position=UDim2.new(0.025,0,0,100),Size=UDim2.new(0.95,0,0,36),
TextColor3=Color3I(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,Parent=
AbuseSettingsFrame},Parent=K}local M,N,O,P,Q,R,S,T,U=e.Create'TextLabel'{Name=
'PlayerLabel',Text='',BackgroundTransparency=1,Font=Enum.Font.ArialBold,FontSize
=Enum.FontSize.Size18,Position=UDim2.new(0.025,0,0,100),Size=UDim2.new(0.95,0,0,
36),TextColor3=Color3I(255,255,255),TextXAlignment=Enum.TextXAlignment.Right,
Parent=L},e.Create'ImageButton'{Name='SubmitReportBtn',Active=false,
BackgroundTransparency=1,Position=UDim2.new(0.5,-200,1,-80),Size=UDim2.new(0,150
,0,50),AutoButtonColor=false,Image='http://www.roblox.com/asset/?id=96502438',
Parent=L},e.Create'ImageButton'{Name='CancelBtn',BackgroundTransparency=1,
Position=UDim2.new(0.5,50,1,-80),Size=UDim2.new(0,150,0,50),AutoButtonColor=true
,Image='http://www.roblox.com/asset/?id=96500683',Parent=L},e.Create'Frame'{Name
='AbuseDescriptionWrapper',Position=UDim2.new(0.025,0,0,220),Size=UDim2.new(0.95
,0,1,-310),BackgroundColor3=Color3I(0,0,0),BorderSizePixel=0,Parent=L},nil,e.
Create'TextBox'{Name='TextBox',Text='',ClearTextOnFocus=false,Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0,3,0,3),Size=UDim2.new(1
,-6,1,-6),TextColor3=Color3I(255,255,255),TextXAlignment=Enum.TextXAlignment.
Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrap=true,BackgroundColor3=
Color3I(0,0,0),BorderSizePixel=0},e.Create'Frame'{Name='AbuseFeedbackBox',
BackgroundTransparency=1,Position=UDim2.new(0.25,0,0.300000012,0),Size=UDim2.
new(0.5,0,0.370000005,0),MakeBackgroundGuiObj
'http://www.roblox.com/asset/?id=96506233',e.Create'TextLabel'{Name='Header',
Position=UDim2.new(0,10,0.05,0),Size=UDim2.new(1,-30,0.15,0),TextScaled=true,
BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Center,
TextYAlignment=Enum.TextYAlignment.Top,Text='Thanks for your report!',TextColor3
=Color3.new(1,1,1),FontSize=Enum.FontSize.Size48,Font='ArialBold'},e.Create
'TextLabel'{Name='content',Position=UDim2.new(0,10,0.2,0),Size=UDim2.new(1,-30,
0.4,0),TextScaled=true,BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),
Text=
[[Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.

If anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats]]
,TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,FontSize=Enum.FontSize.
Size24,Font='Arial'},e.Create'ImageButton'{Name='OkButton',
BackgroundTransparency=1,Position=UDim2.new(0.5,-75,1,-80),Size=UDim2.new(0,150,
0,50),AutoButtonColor=true,Image='http://www.roblox.com/asset/?id=96507959'}},e.
Create'Frame'{Name='AbuseFeedbackBox',BackgroundTransparency=1,Position=UDim2.
new(0.25,0,0.300000012,0),Size=UDim2.new(0.5,0,0.370000005,0),
MakeBackgroundGuiObj'http://www.roblox.com/asset/?id=96506233',e.Create
'TextLabel'{Name='Header',Position=UDim2.new(0,10,0.05,0),Size=UDim2.new(1,-30,
0.15,0),TextScaled=true,BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),
TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Top
,Text='Thanks for your report!',FontSize=Enum.FontSize.Size48,Font='ArialBold'},
e.Create'TextLabel'{Name='content',Position=UDim2.new(0,10,0.2,0),Size=UDim2.
new(1,-30,0.15,0),TextScaled=true,BackgroundTransparency=1,TextColor3=Color3.
new(1,1,1),Text=
[[Our moderators will review the chat logs and determine what happened.]],
TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,FontSize=Enum.FontSize.
Size24,Font='Arial'},e.Create'ImageButton'{Name='OkButton',
BackgroundTransparency=1,Position=UDim2.new(0.5,-75,1,-80),Size=UDim2.new(0,150,
0,50),AutoButtonColor=true,Image='http://www.roblox.com/asset/?id=96507959'}},
Instance.new'ImageButton'U.Size=UDim2.new(1,0,1,0)U.BackgroundTransparency=1 U.
ZIndex=8 U.Visible=false U.Parent=i local V=e.Create'Frame'{Name='debugframe',
BackgroundTransparency=1,Position=UDim2.new(0.25,0,0.300000012,0),Size=UDim2.
new(0.5,0,0.370000005,0),MakeBackgroundGuiObj
'http://www.roblox.com/asset/?id=96506233'}local W,X,Y=e.Create'TextLabel'{
BackgroundTransparency=0.8,Position=UDim2.new(0,0,0.01,0),Size=UDim2.new(1,0,0.5
,0),Parent=V,Font='ArialBold',Text='--',FontSize='Size14',TextWrapped=true,
TextColor3=Color3.new(1,1,1),TextStrokeColor3=Color3.new(0,0,0),
TextStrokeTransparency=0,TextXAlignment='Right',TextYAlignment='Center'},e.
Create'TextLabel'{BackgroundTransparency=0.8,Position=UDim2.new(0,0,0.5,0),Size=
UDim2.new(1,0,0.5,0),Parent=V,Font='ArialBold',Text='--',FontSize='Size14',
TextWrapped=true,TextColor3=Color3.new(1,1,1),TextStrokeColor3=Color3.new(0,0,0)
,TextStrokeTransparency=0,TextXAlignment='Right',TextYAlignment='Center'},true
function debugprint(Z)if Y then X.Text=Z end end local Z,_=assert(LoadLibrary
'RbxGui'),8 for aa,ab in pairs(b)do Game:GetService'ContentProvider':Preload(
'http://www.roblox.com/asset/?id='..ab)end local ac,ad,ae,af,ag,ah,ai,aj,ak,al={
},0,{},{},nil,{},{},0,0.25,false pcall(function()al=Game:GetService
'UserInputService'.TouchEnabled end)local am,an,ao,ap=150,10,UDim2.new(0.5,0,1,0
),UDim2.new(0.25,0,0.1,0)local aq,ar,as,at,au,av,aw,ax,ay,az,aA,aB,aC,aD,aE=
UDim2.new(0,am,0,800),UDim2.new(1,-am,0.005,0),-4E-2,v.Position.Y.Scale,nil,nil,
false,false,false,false,false,false,false,{},8 if not al then aE=12 end local aF
,aG,aH,aI,aJ,aK,aL=false,nil,{'Bad Words or Threats','Bad Username',
'Talking about Dating','Account Trading or Sharing','Asking Personal Questions',
'Rude or Mean Behavior','False Reporting Me'},nil,nil,{Owner=255,Admin=240,
Member=128,Visitor=10,Banned=0},not not game.Workspace:FindFirstChild
'PSVariable'game.Workspace.ChildAdded:connect(function(aM)if aM.Name==
'PSVariable'and aM:IsA'BoolValue'then aL=true end end)function
AreAllEntriesOnScreen()return#ai*H.Size.Y.Scale<=1+at end function GetMaxScroll(
)return at*-1 end function GetMinScroll()if AreAllEntriesOnScreen()then return
GetMaxScroll()else return(GetMaxScroll()-(#ai*H.Size.Y.Scale))+(1+at)end end
function AbsoluteToPercent(aM,aN)return Vector2.new(aM,aN)/i.AbsoluteSize end
function TweenProperty(aM,aN,aO,aP,aQ)local aR=tick()while tick()-aR<aQ do aM[aN
]=((aP-aO)*((tick()-aR)/aQ))+aO wait(3.333333333333333E-2)end aM[aN]=aP end
function WaitForClick(aM,aN,aO)if az then return end az=true local aP,aQ aP=U.
MouseButton1Up:connect(function(aR,aS)aO(aR,aS)U.Visible=false aP:disconnect()if
aQ then aQ:disconnect()end end)aQ=U.MouseMoved:connect(function(aR,aS)aN(aR,aS)
end)U.Visible=true U.Active=true U.Parent=aM aM.AncestryChanged:connect(function
(aR,aS)if aR==aM and aS==nil then aO(nx,ny)U.Visible=false aP:disconnect()aQ:
disconnect()debugprint'forced out of wait for click'end end)az=false end
function SetPrivilegeRank(aM,aN)while aM.PersonalServerRank<aN do game:
GetService'PersonalServerService':Promote(aM)end while aM.PersonalServerRank>aN
do game:GetService'PersonalServerService':Demote(aM)end end function
OnPrivilegeLevelSelect(aM,aN,aO,aP,aQ,aR)debugprint'setting privilege level'
SetPrivilegeRank(aM,aN)HighlightMyRank(aM,aO,aP,aQ,aR)end function
HighlightMyRank(aM,aN,aO,aP,aQ)aN.Image='http://www.roblox.com/asset/?id='..b[
'LightPopupMid']aO.Image='http://www.roblox.com/asset/?id='..b['DarkPopupMid']aP
.Image='http://www.roblox.com/asset/?id='..b['LightPopupMid']aQ.Image=
'http://www.roblox.com/asset/?id='..b['DarkPopupBottom']local aR=aM.
PersonalServerRank if aR<=aK['Banned']then aN.Image=
'http://www.roblox.com/asset/?id='..b['LightBluePopupMid']elseif aR<=aK[
'Visitor']then aO.Image='http://www.roblox.com/asset/?id='..b['DarkBluePopupMid'
]elseif aR<=aK['Member']then aP.Image='http://www.roblox.com/asset/?id='..b[
'LightBluePopupMid']elseif aR<=aK['Admin']then aQ.Image=
'http://www.roblox.com/asset/?id='..b['DarkBluePopupBottom']end end function
OnSubmitAbuse()if N.Active then if aG and av then L.Visible=false game.Players:
ReportAbuse(av,aG,Q.Text)if aG=='Rude or Mean Behavior'or aG==
'False Reporting Me'then S.Parent=J else debugprint'opening abuse box'T.Parent=J
end else CloseAbuseDialog()end end end function OpenAbuseDialog()debugprint
'adding report dialog'M.Text=av.Name A:TweenPosition(UDim2.new(1,0,0,0),'Out',
'Linear',c,true)Q=R:Clone()Q.Parent=P J.Parent=i ClosePopUpPanel()end function
CloseAbuseDialog()aG=nil N.Active=false N.Image=
'http://www.roblox.com/asset/?id=96502438'Q:Destroy()S.Parent=nil T.Parent=nil J
.Parent=nil L.Visible=true end function InitReportAbuse()aI=function(aM)aG=aM if
aG and av then N.Active=true N.Image='http://www.roblox.com/asset/?id=96501119'
end end aJ,aa=Z.CreateDropDownMenu(aH,aI,true)aJ.Name='AbuseComboBox'aJ.Position
=UDim2.new(0.425,0,0,142)aJ.Size=UDim2.new(0.55,0,0,32)aJ.Parent=L O.
MouseButton1Click:connect(CloseAbuseDialog)N.MouseButton1Click:connect(
OnSubmitAbuse)S:FindFirstChild'OkButton'.MouseButton1Down:connect(
CloseAbuseDialog)T:FindFirstChild'OkButton'.MouseButton1Down:connect(
CloseAbuseDialog)end local function GetFriendStatus(aM)if aM==game.Players.
LocalPlayer then return Enum.FriendStatus.NotFriend else local aN,aO=pcall(
function()return game.Players.LocalPlayer:GetFriendStatus(aM)end)if aN then
return aO else return Enum.FriendStatus.NotFriend end end end function
OnFriendButtonSelect()local aM=GetFriendStatus(av)if aM==Enum.FriendStatus.
Friend then g:RevokeFriendship(av)elseif aM==Enum.FriendStatus.Unknown or aM==
Enum.FriendStatus.NotFriend or aM==Enum.FriendStatus.FriendRequestSent or aM==
Enum.FriendStatus.FriendRequestReceived then g:RequestFriendship(av)end
ClosePopUpPanel()end function OnFriendRefuseButtonSelect()g:RevokeFriendship(av)
ClosePopUpPanel()A:TweenPosition(UDim2.new(1,0,0,0),'Out','Linear',c,true)end
function PlayerSortFunction(aM,aN)if aM['Score']==aN['Score']then return aM[
'Player'].Name:upper()<aN['Player'].Name:upper()end if not aM['Score']then
return false end if not aN['Score']then return true end return aM['Score']<aN[
'Score']end function BlowThisPopsicleStand()Tabify()end function StatSort(aM,aN)
if aM.IsPrimary~=aN.IsPrimary then return aM.IsPrimary end if aM.Priority==aN.
Priority then return aM.AddId<aN.AddId end return aM.Priority<aN.Priority end
function StatChanged(aM,aN)BaseUpdate()end function StatAdded(aN,aO)while ax do
debugprint'in stat added function lock'wait(3.333333333333333E-2)end ax=true if
not(aN:IsA'StringValue'or aN:IsA'IntValue'or aN:IsA'BoolValue'or aN:IsA
'NumberValue'or aN:IsA'DoubleConstrainedValue'or aN:IsA'IntConstrainedValue')
then BlowThisPopsicleStand()else local aP=false for aQ,aR in pairs(ac)do if aR[
'Name']==aN.Name then aP=true end end if not aP then local aS={}aS['Name']=aN.
Name aS['Priority']=0 if aN:FindFirstChild'Priority'then aS['Priority']=aN.
Priority end aS['IsPrimary']=false if aN:FindFirstChild'IsPrimary'then aS[
'IsPrimary']=true end aS.AddId=ad ad=ad+1 table.insert(ac,aS)table.sort(ac,
StatSort)if not C:FindFirstChild(aS['Name'])then CreateStatTitle(aS['Name'])end
UpdateMaximize()end end ax=false StatChanged(aO)aN.Changed:connect(function(aP)
StatChanged(aO,aP)end)end function DoesStatExist(aN,aO)for aP,aQ in pairs(ae)do
if aQ['Player']~=aO and aQ['Player']:FindFirstChild'leaderstats'and aQ['Player']
.leaderstats:FindFirstChild(aN)then return true end end return false end
function StatRemoved(aN,aO)while ax do debugprint'In Adding Stat Lock1'wait(
3.333333333333333E-2)end ax=true if aO['Frame']:FindFirstChild(aN.Name)then
debugprint'Destroyed frame!'aO['Frame'][aN.Name].Parent=nil end if not
DoesStatExist(aN.Name,aO['Player'])then for aP,aQ in ipairs(ac)do if aQ['Name']
==aN.Name then table.remove(ac,aP)if C:FindFirstChild(aN.Name)then C[aN.Name]:
Destroy()end for aR,aS in pairs(af)do if aS['Frame']:FindFirstChild(aN.Name)then
aS['Frame'][aN.Name]:Destroy()end end end end end ax=false StatChanged(aO)end
function RemoveAllStats(aN)for aO,aP in ipairs(ac)do StatRemoved(aP,aN)end end
function GetScoreValue(aN)if aN:IsA'DoubleConstrainedValue'or aN:IsA
'IntConstrainedValue'then return aN.ConstrainedValue elseif aN:IsA'BoolValue'
then if aN.Value then return 1 else return 0 end else return aN.Value end end
function MakeScoreEntry(aN,aO,aP)if not aP:FindFirstChild'PlayerScore'then
return end local aQ,aR=aP:FindFirstChild'PlayerScore':Clone(),nil wait()if aN[
'Player']:FindFirstChild'leaderstats'and aN['Player'].leaderstats:
FindFirstChild(aO['Name'])then aR=aN['Player']:FindFirstChild'leaderstats':
FindFirstChild(aO['Name'])else return end if not aN['Player'].Parent then return
end aQ.Name=aO['Name']aQ.Text=tostring(GetScoreValue(aR))if aO['Name']==ac[1][
'Name']then debugprint'changing score'aN['Score']=GetScoreValue(aR)if aN[
'Player']==g then p.Text=tostring(GetScoreValue(aR))end end aR.Changed:connect(
function()if not aR.Parent then return end if aO['Name']==ac[1]['Name']then aN[
'Score']=GetScoreValue(aR)if aN['Player']==g then p.Text=tostring(GetScoreValue(
aR))end end aQ.Text=tostring(GetScoreValue(aR))BaseUpdate()end)return aQ end
function CreateStatTitle(aN)local aO=H:FindFirstChild'PlayerScore':Clone()aO.
Name=aN aO.Text=aN if E.Value then aO.TextTransparency=0 else aO.
TextTransparency=1 end aO.Parent=C end function RecreateScoreColumns(aN)while ax
do debugprint'In Adding Stat Lock2'wait(3.333333333333333E-2)end ax=true local
aO=5 local aP,aQ=aO,0 for aR=#ac,1,-1 do local aS=ac[aR]aQ=0 for aT,aU in
ipairs(aN)do local aV,aW=aU['Frame'],aU['Player']if not aV:FindFirstChild(aS[
'Name'])then local aX=MakeScoreEntry(aU,aS,aV)if aX then debugprint('adding '..
aX.Name..' to '..aU['Player'].Name)aX.Parent=aV if aU['MyTeam']and aU['MyTeam']
~=ag and not aU['MyTeam']['Frame']:FindFirstChild(aS['Name'])then local aY=aX:
Clone()aY.Parent=aU['MyTeam']['Frame']end end end aS['XOffset']=aO if aV:
FindFirstChild(aS['Name'])then aQ=math.max(aQ,aV[aS['Name']].TextBounds.X)end
end if G.Value then aQ=math.max(aQ,C[aS['Name']].TextBounds.X)C[aS['Name']]:
TweenPosition(UDim2.new(as,-aO,0,0),'Out','Linear',c,true)else C[aS['Name']]:
TweenPosition(UDim2.new((0.4+((0.6/#ac)*(aR-1)))-1,0,0,0),'Out','Linear',c,true)
end aS['ColumnSize']=aQ aO=aO+an+aQ aP=math.max(aO,aP)end aq=UDim2.new(0,am+aP-
an,0,800)ar=UDim2.new(1,-aq.X.Offset,ar.Y.Scale,0)UpdateHeaderNameSize()
UpdateMaximize()ax=false end function ToggleMinimize()D.Value=not D.Value
UpdateStatNames()end function ToggleMaximize()E.Value=not E.Value
RecreateScoreColumns(ae)end function Tabify()F.Value=true E.Value=false D.Value=
true UpdateMinimize()F.Value=true i:TweenPosition(UDim2.new(aq.X.Scale,aq.X.
Offset-10,0,0),'Out','Linear',c*1.2,true)end function UnTabify()if F.Value then
F.Value=false i:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',c*1.2,true)end
end function UpdateMinimize()if D.Value then if E.Value then ToggleMaximize()end
if not F.Value then j:TweenSizeAndPosition(UDim2.new(0.01,o.TextBounds.X,aq.Y.
Scale,aq.Y.Offset),UDim2.new(0.99,-o.TextBounds.X,ar.Y.Scale,0),'Out','Linear',c
*1.2,true)else j:TweenSizeAndPosition(aq,ar,'Out','Linear',c*1.2,true)end v:
TweenPosition(UDim2.new(0,0,-1,0),'Out','Linear',c*1.2,true)r:TweenPosition(
UDim2.new(0,0,0,0),'Out','Linear',c*1.2,true)k.Size=UDim2.new(1,0,m,0)t.Image=
'http://www.roblox.com/asset/?id=94692731'else if not E.Value then j:
TweenSizeAndPosition(aq,ar,'Out','Linear',c*1.2,true)end at=math.min(math.max(at
,-1),-1+(#ai*I.Size.Y.Scale))UpdateScrollPosition()v.Position=UDim2.new(0,0,at,0
)local aN=(at+v.Size.Y.Scale)r.Position=UDim2.new(0,0,aN,0)k.Size=UDim2.new(1,0,
aN+m,0)t.Image='http://www.roblox.com/asset/?id=94825585'end end function
UpdateMaximize()if E.Value then for aN=1,#ac,1 do local aO=ac[aN]C[aO['Name']]:
TweenPosition(UDim2.new(0.4+((0.6/#ac)*(aN-1))-1,0,0,0),'Out','Linear',c,true)
end if D.Value then ToggleMinimize()else UpdateMinimize()end j:
TweenSizeAndPosition(ao,ap,'Out','Linear',c*1.2,true)p:TweenPosition(UDim2.new(0
,0,o.Position.Y.Scale,0),'Out','Linear',c*1.2,true)o:TweenPosition(UDim2.new(-
0.1,-p.TextBounds.x,o.Position.Y.Scale,0),'Out','Linear',c*1.2,true)l.Background
.Image='http://www.roblox.com/asset/?id='..b['LargeHeader']r.Background.Image=
'http://www.roblox.com/asset/?id='..b['LargeBottom']for aN,aO in ipairs(ai)do if
(aN%2)~=1 then aO.Background.Image='http://www.roblox.com/asset/?id='..b[
'LargeDark']else aO.Background.Image='http://www.roblox.com/asset/?id='..b[
'LargeLight']end end for aP,aQ in ipairs(ah)do if aQ:FindFirstChild
'ClickListener'then aQ.ClickListener.Size=UDim2.new(0.974,0,aQ.ClickListener.
Size.Y.Scale,0)end for aR=1,#ac,1 do local aS=ac[aR]if aQ:FindFirstChild(aS[
'Name'])then aQ[aS['Name']]:TweenPosition(UDim2.new(0.4+((0.6/#ac)*(aR-1))-1,0,0
,0),'Out','Linear',c,true)end end end for aR,aS in ipairs(ae)do WaitForChild(aS[
'Frame'],'TitleFrame').Size=UDim2.new(0.38,0,aS['Frame'].TitleFrame.Size.Y.Scale
,0)end for aT,aU in ipairs(af)do WaitForChild(aU['Frame'],'TitleFrame').Size=
UDim2.new(0.38,0,aU['Frame'].TitleFrame.Size.Y.Scale,0)end else if not D.Value
then j:TweenSizeAndPosition(aq,ar,'Out','Linear',c*1.2,true)end p:TweenPosition(
UDim2.new(0,0,0.4,0),'Out','Linear',c*1.2,true)o:TweenPosition(UDim2.new(0,0,o.
Position.Y.Scale,0),'Out','Linear',c*1.2,true)l.Background.Image=
'http://www.roblox.com/asset/?id='..b['NormalHeader']r.Background.Image=
'http://www.roblox.com/asset/?id='..b['NormalBottom']for aN,aQ in ipairs(ai)do
if aN%2~=1 then aQ.Background.Image='http://www.roblox.com/asset/?id='..b[
'midDark']else aQ.Background.Image='http://www.roblox.com/asset/?id='..b[
'midLight']end end for aT,aU in ipairs(ah)do if aU:FindFirstChild'ClickListener'
then aU.ClickListener.Size=UDim2.new(0.96,0,aU.ClickListener.Size.Y.Scale,0)for
aV=1,#ac,1 do local aW=ac[aV]if aU:FindFirstChild(aW['Name'])and aW['XOffset']
then aU[aW['Name']]:TweenPosition(UDim2.new(as,-aW['XOffset'],0,0),'Out',
'Linear',c,true)end end end end for aV,aW in ipairs(af)do WaitForChild(aW[
'Frame'],'TitleFrame').Size=UDim2.new(0,am*0.9,aW['Frame'].TitleFrame.Size.Y.
Scale,0)end for aX,aY in ipairs(ae)do WaitForChild(aY['Frame'],'TitleFrame').
Size=UDim2.new(0,am*0.9,aY['Frame'].TitleFrame.Size.Y.Scale,0)end end end
function ExpandNames()if#ac~=0 then for aN,aU in pairs(C:GetChildren())do Spawn(
function()TweenProperty(aU,'TextTransparency',aU.TextTransparency,0,c)end)end m=
0.09 l:TweenSizeAndPosition(UDim2.new(l.Size.X.Scale,l.Size.X.Offset,m,0),l.
Position,'Out','Linear',c*1.2,true)u:TweenPosition(UDim2.new(u.Position.X.Scale,
0,m,0),'Out','Linear',c*1.2,true)q:TweenPosition(UDim2.new(0,0,m,0),'Out',
'Linear',c*1.2,true)end end function CloseNames()if#ac~=0 then m=0.07 if not E.
Value then for aN,aU in pairs(C:GetChildren())do Spawn(function()TweenProperty(
aU,'TextTransparency',aU.TextTransparency,1,c)end)end end q:TweenPosition(UDim2.
new(0,0,m,0),'Out','Linear',c*1.2,true)l:TweenSizeAndPosition(UDim2.new(l.Size.X
.Scale,l.Size.X.Offset,m,0),l.Position,'Out','Linear',c*1.2,true)u:
TweenPosition(UDim2.new(u.Position.X.Scale,0,m,0),'Out','Linear',c*1.2,true)end
end function UpdateStatNames()if not G.Value or D.Value then CloseNames()else
ExpandNames()end end function OnScrollWheelMove(aN)if not(F.Value or D.Value or
aA)then local aU=y.Position local aX=math.max(math.min(aU.Y.Scale+aN,
GetMaxScroll()),GetMinScroll())y.Position=UDim2.new(aU.X.Scale,aU.X.Offset,aX,aU
.Y.Offset)UpdateScrollPosition()end end function AttachScrollWheel()if aD then
return end aD={}table.insert(aD,h.WheelForward:connect(function()
OnScrollWheelMove(0.05)end))table.insert(aD,h.WheelBackward:connect(function()
OnScrollWheelMove(-5E-2)end))end function DetachScrollWheel()if aD then for aN,
aU in pairs(aD)do aU:disconnect()end end aD=nil end k.MouseEnter:connect(
function()if not(D.Value or F.Value)then AttachScrollWheel()end end)k.MouseLeave
:connect(function()DetachScrollWheel()end)function UpdateScrollBarVisibility()if
AreAllEntriesOnScreen()then x.BackgroundTransparency=1 else x.
BackgroundTransparency=0 UpdateScrollBarSize()end end function
UpdateScrollBarSize()local aN,aU=#ai*H.Size.Y.Scale,(v.Position.Y.Scale+1)x.Size
=UDim2.new(1,0,aU/aN,0)end function UpdateScrollPosition()local aN,aU=
GetMinScroll(),GetMaxScroll()local aX,aY=aU-aN,math.max(math.min(y.Position.Y.
Scale,aU),aN)y.Position=UDim2.new(y.Position.X.Scale,y.Position.X.Offset,aY,y.
Position.Y.Offset)local aZ=1-x.Size.Y.Scale x.Position=UDim2.new(0,0,aZ-(aZ*((y.
Position.Y.Scale-aN)/aX)),0)end function StartDrag(aN,aU,aX)local aY=true
WaitForChild(aN['Frame'],'ClickListener')local function dragExit()if aN['Player'
]and av and aY and aN['Player']~=g and av.userId>1 and g.userId>1 then
ActivatePlayerEntryPanel(aN)end end local aZ,a_=nil,y.Position local function
dragpoll(a0,a1)if not aZ then aZ=AbsoluteToPercent(a0,a1).Y end local a2=
AbsoluteToPercent(a0,a1).Y debugprint('drag dist:'..Vector2.new(aU-a0,aX-a1).
magnitude)if Vector2.new(aU-a0,aX-a1).magnitude>d then aY=false end local a3=
math.max(math.min(a_.Y.Scale+(a2-aZ),GetMaxScroll()),GetMinScroll())y.Position=
UDim2.new(a_.X.Scale,a_.X.Offset,a3,a_.Y.Offset)UpdateScrollPosition()end
WaitForClick(i,dragpoll,dragExit)end function StartMinimizeDrag()Delay(0,
function()local aN=tick()debugprint'Got Click2'local function dragExit()if tick(
)-aN<0.25 then ToggleMinimize()else aF=true if D.Value then ToggleMinimize()end
end end local aU,aX=nil,at local function dragpoll(aY,aZ)if not D.Value then if
not aU then aU=AbsoluteToPercent(aY,aZ).Y end local a_,a0=AbsoluteToPercent(aY,
aZ).Y,nil a0=math.min(math.max(aX+(a_-aU),-1),-1+(#ai*I.Size.Y.Scale))at=a0
UpdateMinimize()w.Size=UDim2.new(w.Size.X.Scale,0,(at+v.Size.Y.Scale),0)w.
Position=UDim2.new(w.Position.X.Scale,0,1-w.Size.Y.Scale,0)UpdateScrollBarSize()
UpdateScrollPosition()UpdateScrollBarVisibility()end end Spawn(function()
WaitForClick(i,dragpoll,dragExit)end)end)end E.Value=false D.Value=false E.
Changed:connect(UpdateMaximize)D.Changed:connect(UpdateMinimize)s.
MouseButton1Down:connect(function()if(time()-aj<ak)or aA then return end aj=
time()if F.Value then UnTabify()else StartMinimizeDrag()end end)n.
MouseButton1Click:connect(function()if(time()-aj<ak)or aA then return end aj=
time()if F.Value then UnTabify()elseif not G.Value then G.Value=true BaseUpdate(
)else ToggleMaximize()end end)n.MouseButton2Click:connect(function()if(time()-aj
<ak)or aA then return end aj=time()if F.Value then UnTabify()elseif E.Value then
ToggleMaximize()elseif G.Value then G.Value=false BaseUpdate()else Tabify()end
end)function AddMiddleBGFrame()local aN=I:Clone()aN.Position=UDim2.new(0.5,0,(#
ai*aN.Size.Y.Scale),0)if(#ai+1)%2~=1 then if E.Value then aN.Background.Image=
'http://www.roblox.com/asset/?id='..b['LargeDark']else aN.Background.Image=
'http://www.roblox.com/asset/?id='..b['midDark']end else if E.Value then aN.
Background.Image='http://www.roblox.com/asset/?id='..b['LargeLight']else aN.
Background.Image='http://www.roblox.com/asset/?id='..b['midLight']end end aN.
Parent=y table.insert(ai,aN)if#ai<aE and not aF then at=-1+(#ai*I.Size.Y.Scale)
end if not D.Value then UpdateMinimize()end end function RemoveMiddleBGFrame()ai
[#ai]:Destroy()table.remove(ai,#ai)if not D.Value then UpdateMinimize()end end
local aN={'Size8','Size9','Size10','Size11','Size12','Size14','Size24','Size36',
'Size48'}function ChangeHeaderName(aU)o.Text=aU UpdateHeaderNameSize()end
function UpdateHeaderNameSize()local aU=o:Clone()aU.Position=UDim2.new(2,0,2,0)
aU.Parent=i local aX=7 aU.FontSize=aN[aX]Delay(0.2,function()while aU.TextBounds
.x==0 do wait(3.333333333333333E-2)end while aU.TextBounds.x-aq.X.Offset>1 do aX
=aX-1 aU.FontSize=aN[aX]wait(0.2)end o.FontSize=aU.FontSize aU:Destroy()end)end
i.Changed:connect(UpdateHeaderNameSize)function LeaderstatsAdded(aU)local aX=aU[
'Player']for aY,aZ in pairs(aX.leaderstats:GetChildren())do StatAdded(aZ,aU)end
aX.leaderstats.ChildAdded:connect(function(a_)StatAdded(a_,aU)end)aX.leaderstats
.ChildRemoved:connect(function(a_)StatRemoved(a_,aU)end)end function
LeaderstatsRemoved(aU,aX)while aw do debugprint('waiting to insert '..aX[
'Player'].Name)wait(3.333333333333333E-2)end aw=true RemoveAllStats(aX)aw=false
end function ClosePopUpPanel()if au then local aU=au['Frame']Spawn(function()
TweenProperty(aU,'BackgroundTransparency',0.5,1,c)end)end A:TweenPosition(UDim2.
new(1,0,0,0),'Out','Linear',c,true)wait(0.1)aA=false au=nil end function
InitMovingPanel(aU,aX)z.Parent=i if A then A:Destroy()end A=B:Clone()A.Parent=z
local aY,aZ=2,GetFriendStatus(aX)debugprint(tostring(aZ))local a_,a0=aL and g.
PersonalServerRank>=aK['Admin']and g.PersonalServerRank>av.PersonalServerRank,
MakePopupButton(A,'Report Player',0)a0.MouseButton1Click:connect(function()
OpenAbuseDialog()end)local a1=MakePopupButton(A,'Friend',1,not a_ and aZ~=Enum.
FriendStatus.FriendRequestReceived)a1.MouseButton1Click:connect(
OnFriendButtonSelect)if aZ==Enum.FriendStatus.Friend then a1:FindFirstChild
'ButtonText'.Text='UnFriend Player'elseif aZ==Enum.FriendStatus.Unknown or aZ==
Enum.FriendStatus.NotFriend then a1:FindFirstChild'ButtonText'.Text=
'Send Request'elseif aZ==Enum.FriendStatus.FriendRequestSent then a1:
FindFirstChild'ButtonText'.Text='Revoke Request'elseif aZ==Enum.FriendStatus.
FriendRequestReceived then a1:FindFirstChild'ButtonText'.Text='Accept Friend'
local a2=MakePopupButton(A,'Decline Friend',2,not a_)a2.MouseButton1Click:
connect(OnFriendRefuseButtonSelect)aY=aY+1 end if a_ then local a2,a3,a4,a5=
MakePopupButton(A,'Ban',aY),MakePopupButton(A,'Visitor',aY+1),MakePopupButton(A,
'Member',aY+2),MakePopupButton(A,'Admin',aY+3,true)a2.MouseButton1Click:connect(
function()OnPrivilegeLevelSelect(aX,aK['Banned'],a2,a3,a4,a5)end)a3.
MouseButton1Click:connect(function()OnPrivilegeLevelSelect(aX,aK['Visitor'],a2,
a3,a4,a5)end)a4.MouseButton1Click:connect(function()OnPrivilegeLevelSelect(aX,aK
['Member'],a2,a3,a4,a5)end)a5.MouseButton1Click:connect(function()
OnPrivilegeLevelSelect(aX,aK['Admin'],a2,a3,a4,a5)end)HighlightMyRank(av,a2,a3,
a4,a5)end A:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',c,true)Delay(0,
function()local a2 a2=h.Button1Down:connect(function()a2:disconnect()
ClosePopUpPanel()end)end)local a2=aU['Frame']Spawn(function()while aA do z.
Position=UDim2.new(0,a2.AbsolutePosition.X-z.Size.X.Offset,0,a2.AbsolutePosition
.Y)wait()end end)end function OnPlayerEntrySelect(aU,aX,aY)if not aA then au=aU
av=aU['Player']StartDrag(aU,aX,aY)end end function ActivatePlayerEntryPanel(aU)
aU['Frame'].BackgroundColor3=Color3.new(0,1,1)Spawn(function()TweenProperty(aU[
'Frame'],'BackgroundTransparency',1,0.5,0.5)end)aA=true InitMovingPanel(aU,aU[
'Player'])end function PlayerListModeUpdate()RecreateScoreColumns(ae)table.sort(
ae,PlayerSortFunction)for aU,aX in ipairs(ae)do ah[aU]=aX['Frame']end for aY=#ae
+1,#ah,1 do ah[aY]=nil end UpdateMinimize()end function InsertPlayerFrame(aU)
while aw do debugprint('waiting to insert '..aU.Name)wait(3.333333333333333E-2)
end aw=true local aX=H:Clone()WaitForChild(WaitForChild(aX,'TitleFrame'),'Title'
).Text=aU.Name aX.Position=UDim2.new(1,0,(#ah*aX.Size.Y.Scale),0)local aY=
GetFriendStatus(aU)aX:FindFirstChild'BCLabel'.Image=getMembershipTypeIcon(aU.
MembershipType,aU.Name)aX:FindFirstChild'FriendLabel'.Image=getFriendStatusIcon(
aY)aX.Name=aU.Name WaitForChild(WaitForChild(aX,'TitleFrame'),'Title').Text=aU.
Name aX.FriendLabel.Position=aX.FriendLabel.Position+UDim2.new(0,17,0,0)aX.
TitleFrame.Title.Position=aX.TitleFrame.Title.Position+UDim2.new(0,17,0,0)if aX:
FindFirstChild'FriendLabel'.Image~=''then aX.TitleFrame.Title.Position=aX.
TitleFrame.Title.Position+UDim2.new(0,17,0,0)end if aU.Name==g.Name then aX.
TitleFrame.Title.Font='ArialBold'aX.PlayerScore.Font='ArialBold'
ChangeHeaderName(aU.Name)local aZ=aX.TitleFrame.Title:Clone()aZ.TextColor3=
Color3.new(0,0,0)aZ.TextTransparency=0 aZ.ZIndex=2 aZ.Position=aX.TitleFrame.
Title.Position+UDim2.new(0,1,0,1)aZ.Name='DropShadow'aZ.Parent=aX.TitleFrame end
aX.TitleFrame.Title.Font='ArialBold'aX.Parent=y aX:TweenPosition(UDim2.new(0.5,0
,(#ah*aX.Size.Y.Scale),0),'Out','Linear',c,true)UpdateMinimize()local aZ={}aZ[
'Frame']=aX aZ['Player']=aU aZ['ID']=ad ad=ad+1 table.insert(ae,aZ)if#af~=0 then
if aU.Neutral then aZ['MyTeam']=nil if not ag then AddNeutralTeam()else
AddPlayerToTeam(ag,aZ)end else local a_=false for a0,a1 in ipairs(af)do if a1[
'MyTeam'].TeamColor==aU.TeamColor then AddPlayerToTeam(a1,aZ)aZ['MyTeam']=a1 a_=
true end end if not a_ then aZ['MyTeam']=nil if not ag then AddNeutralTeam()else
AddPlayerToTeam(ag,aZ)end aZ['MyTeam']=ag end end end if aU:FindFirstChild
'leaderstats'then LeaderstatsAdded(aZ)end aU.ChildAdded:connect(function(a_)if
a_.Name=='leaderstats'then while aw do debugprint'in adding leaderstats lock'
wait(3.333333333333333E-2)end aw=true LeaderstatsAdded(aZ)aw=false end end)aU.
ChildRemoved:connect(function(a_)if aU==g and a_.Name=='leaderstats'then
LeaderstatsRemoved(a_,aZ)end end)aU.Changed:connect(function(a_)PlayerChanged(aZ
,a_)end)local a_=WaitForChild(aX,'ClickListener')a_.Active=true a_.
MouseButton1Down:connect(function(a0,a1)OnPlayerEntrySelect(aZ,a0,a1)end)
AddMiddleBGFrame()BaseUpdate()aw=false end function RemovePlayerFrame(aU)while
aw do debugprint'in removing player frame lock'wait(3.333333333333333E-2)end aw=
true local aX for aY,aZ in ipairs(ae)do if aU==aZ['Player']then if z.Parent==aZ[
'Frame']then z.Parent=nil end aZ['Frame']:Destroy()aX=aZ['MyTeam']table.remove(
ae,aY)end end if aX then for a_,a0 in ipairs(aX['MyPlayers'])do if a0['Player']
==aU then RemovePlayerFromTeam(aX,a_)end end end RemoveMiddleBGFrame()
UpdateMinimize()BaseUpdate()aw=false end f.ChildRemoved:connect(
RemovePlayerFrame)function UnrollTeams(aU,aX)local aY=0 if ag and not ag[
'IsHidden']then for aZ,a_ in ipairs(ag['MyPlayers'])do aY=aY+1 aX[aY]=a_['Frame'
]end aY=aY+1 aX[aY]=ag['Frame']end for aZ,a_ in ipairs(aU)do if not a_[
'IsHidden']then for a0,a1 in ipairs(a_.MyPlayers)do aY=aY+1 aX[aY]=a1['Frame']
end aY=aY+1 aX[aY]=a_['Frame']end end for a0=aY+1,#aX,1 do aX[a0]=nil end end
function TeamSortFunc(aU,aX)if aU['TeamScore']==aX['TeamScore']then return aU[
'ID']<aX['ID']end if not aU['TeamScore']then return false end if not aX[
'TeamScore']then return true end return aU['TeamScore']<aX['TeamScore']end
function SortTeams(aU)for aX,aY in ipairs(aU)do table.sort(aY['MyPlayers'],
PlayerSortFunction)AddTeamScores(aY)end table.sort(aU,TeamSortFunc)end function
TeamListModeUpdate()RecreateScoreColumns(ae)SortTeams(af)if ag then
AddTeamScores(ag)end UnrollTeams(af,ah)end function AddTeamScores(aU)for aX=1,#
ac,1 do local aY,aZ=ac[aX],0 for a_,a0 in ipairs(aU['MyPlayers'])do local a1=a0[
'Player']:FindFirstChild'leaderstats'and a0['Player'].leaderstats:
FindFirstChild(aY['Name'])if a1 and not a1:IsA'StringValue'then aZ=aZ+
GetScoreValue((a0['Player'].leaderstats)[aY['Name']])end end if aU['Frame']:
FindFirstChild(aY['Name'])then aU['Frame'][aY['Name']].Text=tostring(aZ)end end
UpdateMinimize()end function FindRemovePlayerFromTeam(aU)if aU['MyTeam']then for
aX,aY in ipairs(aU['MyTeam']['MyPlayers'])do if aY['Player']==aU['Player']then
RemovePlayerFromTeam(aU['MyTeam'],aX)return end end elseif ag then for aX,aY in
ipairs(ag['MyPlayers'])do if aY['Player']==aU['Player']then
RemovePlayerFromTeam(ag,aX)return end end end end function RemovePlayerFromTeam(
aU,aX)table.remove(aU['MyPlayers'],aX)if aU==ag and#aU['MyPlayers']==0 then
RemoveNeutralTeam()end end function AddPlayerToTeam(aU,aX)
FindRemovePlayerFromTeam(aX)table.insert(aU['MyPlayers'],aX)aX['MyTeam']=aU if
aU['IsHidden']then aU['Frame'].Parent=y AddMiddleBGFrame()end aU['IsHidden']=
false end function SetPlayerToTeam(aU)FindRemovePlayerFromTeam(aU)local aX=false
for aY,aZ in ipairs(af)do if aZ['MyTeam'].TeamColor==aU['Player'].TeamColor then
AddPlayerToTeam(aZ,aU)aX=true end end if not aX and#(game.Teams:GetTeams())>0
then debugprint(aU['Player'].Name..'could not find team')aU['MyTeam']=nil if not
ag then AddNeutralTeam()else AddPlayerToTeam(ag,aU)end end end function
PlayerChanged(aU,aX)while aB do debugprint'in playerchanged lock'wait(
3.333333333333333E-2)end aB=true if aX=='Neutral'then if aU['Player'].Neutral
and#(game.Teams:GetTeams())>0 then debugprint(aU['Player'].Name..
'setting to neutral')FindRemovePlayerFromTeam(aU)aU['MyTeam']=nil if not ag then
debugprint(aU['Player'].Name..'creating neutral team')AddNeutralTeam()else
debugprint(aU['Player'].Name..'adding to neutral team')AddPlayerToTeam(ag,aU)end
elseif#(game.Teams:GetTeams())>0 then debugprint(aU['Player'].Name..
'has been set non-neutral')SetPlayerToTeam(aU)end BaseUpdate()elseif aX==
'TeamColor'and not aU['Player'].Neutral and aU['Player']~=aU['MyTeam']then
debugprint(aU['Player'].Name..'setting to new team')SetPlayerToTeam(aU)
BaseUpdate()elseif aX=='Name'or aX=='MembershipType'then aU['Frame']:
FindFirstChild'BCLabel'.Image=getMembershipTypeIcon(aU['Player'].MembershipType,
aU['Player'].Name)aU['Frame'].Name=aU['Player'].Name aU['Frame'].TitleFrame.
Title.Text=aU['Player'].Name if aU['Frame'].BCLabel.Image~=''then aU['Frame'].
TitleFrame.Title.Position=UDim2.new(0.01,30,0.1,0)end if aU['Player']==g then aU
['Frame'].TitleFrame.DropShadow.Text=aU['Player'].Name ChangeHeaderName(aU[
'Player'].Name)end BaseUpdate()end aB=false end function OnFriendshipChanged(aU,
aX)Delay(0.5,function()debugprint('friend status changed for:'..aU.Name..' '..
tostring(aX)..' vs '..tostring(GetFriendStatus(aU)))for aY,aZ in ipairs(ae)do if
aZ['Player']==aU then local a_=getFriendStatusIcon(aX)if a_==''and aZ['Frame'].
FriendLabel.Image~=''then aZ['Frame'].TitleFrame.Title.Position=aZ['Frame'].
TitleFrame.Title.Position-UDim2.new(0,17,0,0)elseif a_~=''and aZ['Frame'].
FriendLabel.Image==''then aZ['Frame'].TitleFrame.Title.Position=aZ['Frame'].
TitleFrame.Title.Position+UDim2.new(0,17,0,0)debugprint('confirmed status:'..aU.
Name)end aZ['Frame'].FriendLabel.Image=a_ return end end end)end g.
FriendStatusChanged:connect(OnFriendshipChanged)function AddNeutralTeam()while
aC do debugprint'in neutral team 2 lock'wait()end aC=true local aU=Instance.new
'Team'aU.TeamColor=BrickColor.new'White'aU.Name='Neutral'local aX={}aX['MyTeam']
=aU aX['MyPlayers']={}aX['Frame']=H:Clone()WaitForChild(WaitForChild(aX['Frame']
,'TitleFrame'),'Title').Text=aU.Name aX['Frame'].TitleFrame.Position=UDim2.new(
aX['Frame'].TitleFrame.Position.X.Scale,aX['Frame'].TitleFrame.Position.X.Offset
,0.1,0)aX['Frame'].TitleFrame.Size=UDim2.new(aX['Frame'].TitleFrame.Size.X.Scale
,aX['Frame'].TitleFrame.Size.X.Offset,0.8,0)aX['Frame'].TitleFrame.Title.Font=
'ArialBold'aX['Frame'].Position=UDim2.new(1,0,(#ah*aX['Frame'].Size.Y.Scale),0)
WaitForChild(aX['Frame'],'ClickListener').MouseButton1Down:connect(function(aY,
aZ)StartDrag(aX,aY,aZ)end)aX['Frame'].ClickListener.BackgroundColor3=Color3.new(
1,1,1)aX['Frame'].ClickListener.BackgroundTransparency=0.7 aX['Frame'].
ClickListener.AutoButtonColor=false aX['AutoHide']=true aX['IsHidden']=true for
aY,aZ in pairs(ae)do if aZ['Player'].Neutral or not aZ['MyTeam']then
AddPlayerToTeam(aX,aZ)end end if#aX['MyPlayers']>0 then ag=aX UpdateMinimize()
BaseUpdate()end aC=false end function RemoveNeutralTeam()while aC do debugprint
'in neutral team lock'wait()end aC=true ag['Frame']:Destroy()ag=nil
RemoveMiddleBGFrame()aC=false end function TeamScoreChanged(aU,aX)WaitForChild(
aU['Frame'],'PlayerScore').Text=tostring(aX)aU['TeamScore']=aX end function
TeamChildAdded(aU,aX)if aX.Name=='AutoHide'then aU['AutoHide']=true elseif aX.
Name=='TeamScore'then WaitForChild(aU['Frame'],'PlayerScore').Text=tostring(aX.
Value)aU['TeamScore']=aX.Value aX.Changed:connect(function()TeamScoreChanged(aU,
aX.Value)end)end end function TeamChildRemoved(aU,aX)if aX.Name=='AutoHide'then
aU['AutoHide']=false elseif aX.Name=='TeamScore'then WaitForChild(aU['Frame'],
'PlayerScore').Text=''aU['TeamScore']=nil end end function TeamChanged(aU,aX)if
aX=='Name'then WaitForChild(WaitForChild(aU['Frame'],'TitleFrame'),'Title').Text
=aU['MyTeam'].Name elseif aX=='TeamColor'then aU['Frame'].ClickListener.
BackgroundColor3=aU['MyTeam'].TeamColor.Color for aY,aZ in pairs(af)do if aZ[
'MyTeam'].TeamColor==aU['MyTeam']then RemoveTeamFrame(aU['MyTeam'])end end aU[
'MyPlayers']={}for a_,a0 in pairs(ae)do SetPlayerToTeam(a0)end BaseUpdate()end
end function InsertTeamFrame(aU)while aw do debugprint
'in adding team frame lock'wait(3.333333333333333E-2)end aw=true local aX={}aX[
'MyTeam']=aU aX['MyPlayers']={}aX['Frame']=H:Clone()WaitForChild(WaitForChild(aX
['Frame'],'TitleFrame'),'Title').Text=aU.Name aX['Frame'].TitleFrame.Title.Font=
'ArialBold'aX['Frame'].TitleFrame.Title.FontSize='Size18'aX['Frame'].TitleFrame.
Position=UDim2.new(aX['Frame'].TitleFrame.Position.X.Scale,aX['Frame'].
TitleFrame.Position.X.Offset,0.1,0)aX['Frame'].TitleFrame.Size=UDim2.new(aX[
'Frame'].TitleFrame.Size.X.Scale,aX['Frame'].TitleFrame.Size.X.Offset,0.8,0)aX[
'Frame'].Position=UDim2.new(1,0,(#ah*aX['Frame'].Size.Y.Scale),0)WaitForChild(aX
['Frame'],'ClickListener').MouseButton1Down:connect(function(a_,a0)StartDrag(aX,
a_,a0)end)aX['Frame'].ClickListener.BackgroundColor3=aU.TeamColor.Color aX[
'Frame'].ClickListener.BackgroundTransparency=0.7 aX['Frame'].ClickListener.
AutoButtonColor=false ad=ad+1 aX['ID']=ad aX['AutoHide']=false if aU:
FindFirstChild'AutoHide'then aX['AutoHide']=true end if aU:FindFirstChild
'TeamScore'then TeamChildAdded(aX,aU.TeamScore)end aU.ChildAdded:connect(
function(a_)TeamChildAdded(aX,a_)end)aU.ChildRemoved:connect(function(a_)
TeamChildRemoved(aX,a_)end)aU.Changed:connect(function(a_)TeamChanged(aX,a_)end)
for a_,a0 in pairs(ae)do if not a0['Player'].Neutral and a0['Player'].TeamColor
==aU.TeamColor then AddPlayerToTeam(aX,a0)end end aX['IsHidden']=false if not aX
['AutoHide']or#aX['MyPlayers']>0 then aX['Frame'].Parent=y aX['Frame']:
TweenPosition(UDim2.new(0.5,0,(#ah*aX['Frame'].Size.Y.Scale),0),'Out','Linear',c
,true)AddMiddleBGFrame()else aX['IsHidden']=true aX['Frame'].Parent=nil end
table.insert(af,aX)UpdateMinimize()BaseUpdate()if#af==1 and not ag then
AddNeutralTeam()end aw=false end function RemoveTeamFrame(aU)while aw do
debugprint'in removing team frame lock'wait(3.333333333333333E-2)end aw=true
local aX for a_,a0 in ipairs(af)do if aU==a0['MyTeam']then aX=a0 a0['Frame']:
Destroy()table.remove(af,a_)end end if#af==0 then debugprint
'removeteamframe, remove neutral'if ag then RemoveNeutralTeam()end end for a1,a2
in ipairs(aX['MyPlayers'])do RemovePlayerFromTeam(aX,a1)PlayerChanged(a2,
'TeamColor')end RemoveMiddleBGFrame()BaseUpdate()aw=false end function TeamAdded
(aU)InsertTeamFrame(aU)end function TeamRemoved(aU)RemoveTeamFrame(aU)end
function BaseUpdate()while ay do debugprint'in baseupdate lock'wait(
3.333333333333333E-2)end ay=true UpdateStatNames()if#af==0 and not ag then
PlayerListModeUpdate()else TeamListModeUpdate()end for aU,aX in ipairs(ah)do if
aX.Parent~=nil then aX:TweenPosition(UDim2.new(0.5,0,((#ah-aU)*aX.Size.Y.Scale),
0),'Out','Linear',c,true)end end if not D.Value and#ah>_ then
UpdateScrollPosition()end UpdateMinimize()UpdateScrollBarSize()
UpdateScrollPosition()UpdateScrollBarVisibility()ay=false end game.GuiService:
AddKey'\t'local aU=time()game.GuiService.KeyPressed:connect(function(aX)if aX==
'\t'then debugprint'caught tab key'local a1,a2=pcall(function()return game.
GuiService.IsModalDialog end)if a1==false or(a1 and a2==false)then if time()-aU>
0.4 then aU=time()if F.Value then if not E.Value then i:TweenPosition(UDim2.new(
0,0,0,0),'Out','Linear',c*1.2,true)E.Value=true else i:TweenPosition(UDim2.new(
aq.X.Scale,aq.X.Offset-10,0,0),'Out','Linear',c*1.2,true)E.Value=false D.Value=
true end else ToggleMaximize()end end end end end)function PlayersChildAdded(aX)
if aX:IsA'Player'then Spawn(function()debugPlayerAdd(aX)end)else
BlowThisPopsicleStand()end end function coreGuiChanged(aX,a1)if aX==Enum.
CoreGuiType.All or aX==Enum.CoreGuiType.PlayerList then j.Visible=a1 end end
function TeamsChildAdded(aX)if aX:IsA'Team'then TeamAdded(aX)else
BlowThisPopsicleStand()end end function TeamsChildRemoved(aX)if aX:IsA'Team'then
TeamRemoved(aX)else BlowThisPopsicleStand()end end function debugPlayerAdd(aX)
InsertPlayerFrame(aX)end pcall(function()coreGuiChanged(Enum.CoreGuiType.
PlayerList,Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList))Game.
StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)end)while not game:
GetService'Teams'do wait(3.333333333333333E-2)debugprint'Waiting For Teams'end
for aX,a1 in pairs(game.Teams:GetTeams())do TeamAdded(a1)end for a2,a3 in pairs(
f:GetPlayers())do Spawn(function()debugPlayerAdd(a3)end)end game.Teams.
ChildAdded:connect(TeamsChildAdded)game.Teams.ChildRemoved:connect(
TeamsChildRemoved)f.ChildAdded:connect(PlayersChildAdded)InitReportAbuse()G.
Value=true BaseUpdate()wait(2)aL=not not game.Workspace:FindFirstChild
'PSVariable'if g.Name=='newplayerlistisbad'or g.Name=='imtotallyadmin'then V.
Parent=i Spawn(function()while true do local a4=''for a5,a6 in pairs(game.
Players:GetPlayers())do a4=a4..' '..a6.Name end W.Text=a4 wait(0.5)end end)end