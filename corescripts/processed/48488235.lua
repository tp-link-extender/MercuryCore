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
'http://www.roblox.com/asset/?id='..ab)end local ac,ad,ae,af,ag,ah,ai,aj,ak,al,
am={},0,{},{},nil,{},{},0.03,0,0.25,false pcall(function()am=Game:GetService
'UserInputService'.TouchEnabled end)local an,ao,ap,aq=150,10,UDim2.new(0.5,0,1,0
),UDim2.new(0.25,0,0.1,0)local ar,as,at,au,av,aw,ax,ay,az,aA,aB,aC,aD,aE,aF=
UDim2.new(0,an,0,800),UDim2.new(1,-an,0.005,0),-4E-2,v.Position.Y.Scale,nil,nil,
false,false,false,false,false,false,false,{},8 if not am then aF=12 end local aG
,aH,aI,aJ,aK,aL,aM=false,nil,{'Bad Words or Threats','Bad Username',
'Talking about Dating','Account Trading or Sharing','Asking Personal Questions',
'Rude or Mean Behavior','False Reporting Me'},nil,nil,{Owner=255,Admin=240,
Member=128,Visitor=10,Banned=0},not not game.Workspace:FindFirstChild
'PSVariable'game.Workspace.ChildAdded:connect(function(aN)if aN.Name==
'PSVariable'and aN:IsA'BoolValue'then aM=true end end)function GetTotalEntries()
return math.min(#ai,_)end function GetEntryListLength()local aN=#ae+#af if ag
then aN=aN+1 end return aN end function AreAllEntriesOnScreen()return#ai*H.Size.
Y.Scale<=1+au end function GetLengthOfVisbleScroll()return 1+au end function
GetMaxScroll()return au*-1 end function GetMinScroll()if AreAllEntriesOnScreen()
then return GetMaxScroll()else return(GetMaxScroll()-(#ai*H.Size.Y.Scale))+(1+au
)end end function AbsoluteToPercent(aN,aO)return Vector2.new(aN,aO)/i.
AbsoluteSize end function TweenProperty(aN,aO,aP,aQ,aR)local aS=tick()while
tick()-aS<aR do aN[aO]=((aQ-aP)*((tick()-aS)/aR))+aP wait(3.333333333333333E-2)
end aN[aO]=aQ end function WaitForClick(aN,aO,aP)if aA then return end aA=true
local aQ,aR aQ=U.MouseButton1Up:connect(function(aS,aT)aP(aS,aT)U.Visible=false
aQ:disconnect()if aR then aR:disconnect()end end)aR=U.MouseMoved:connect(
function(aS,aT)aO(aS,aT)end)U.Visible=true U.Active=true U.Parent=aN aN.
AncestryChanged:connect(function(aS,aT)if aS==aN and aT==nil then aP(nx,ny)U.
Visible=false aQ:disconnect()aR:disconnect()debugprint
'forced out of wait for click'end end)aA=false end function GetPrivilegeType(aN)
if aN<=aL['Banned']then return aL['Banned']elseif aN<=aL['Visitor']then return
aL['Visitor']elseif aN<=aL['Member']then return aL['Member']elseif aN<=aL[
'Admin']then return aL['Admin']else return aL['Owner']end end function
SetPrivilegeRank(aN,aO)while aN.PersonalServerRank<aO do game:GetService
'PersonalServerService':Promote(aN)end while aN.PersonalServerRank>aO do game:
GetService'PersonalServerService':Demote(aN)end end function
OnPrivilegeLevelSelect(aN,aO,aP,aQ,aR,aS)debugprint'setting privilege level'
SetPrivilegeRank(aN,aO)HighlightMyRank(aN,aP,aQ,aR,aS)end function
HighlightMyRank(aN,aO,aP,aQ,aR)aO.Image='http://www.roblox.com/asset/?id='..b[
'LightPopupMid']aP.Image='http://www.roblox.com/asset/?id='..b['DarkPopupMid']aQ
.Image='http://www.roblox.com/asset/?id='..b['LightPopupMid']aR.Image=
'http://www.roblox.com/asset/?id='..b['DarkPopupBottom']local aS=aN.
PersonalServerRank if aS<=aL['Banned']then aO.Image=
'http://www.roblox.com/asset/?id='..b['LightBluePopupMid']elseif aS<=aL[
'Visitor']then aP.Image='http://www.roblox.com/asset/?id='..b['DarkBluePopupMid'
]elseif aS<=aL['Member']then aQ.Image='http://www.roblox.com/asset/?id='..b[
'LightBluePopupMid']elseif aS<=aL['Admin']then aR.Image=
'http://www.roblox.com/asset/?id='..b['DarkBluePopupBottom']end end function
OnSubmitAbuse()if N.Active then if aH and aw then L.Visible=false game.Players:
ReportAbuse(aw,aH,Q.Text)if aH=='Rude or Mean Behavior'or aH==
'False Reporting Me'then S.Parent=J else debugprint'opening abuse box'T.Parent=J
end else CloseAbuseDialog()end end end function OpenAbuseDialog()debugprint
'adding report dialog'M.Text=aw.Name A:TweenPosition(UDim2.new(1,0,0,0),'Out',
'Linear',c,true)Q=R:Clone()Q.Parent=P J.Parent=i ClosePopUpPanel()end function
CloseAbuseDialog()aH=nil N.Active=false N.Image=
'http://www.roblox.com/asset/?id=96502438'Q:Destroy()S.Parent=nil T.Parent=nil J
.Parent=nil L.Visible=true end function InitReportAbuse()aJ=function(aN)aH=aN if
aH and aw then N.Active=true N.Image='http://www.roblox.com/asset/?id=96501119'
end end aK,UpdateAbuseSelection=Z.CreateDropDownMenu(aI,aJ,true)aK.Name=
'AbuseComboBox'aK.Position=UDim2.new(0.425,0,0,142)aK.Size=UDim2.new(0.55,0,0,32
)aK.Parent=L O.MouseButton1Click:connect(CloseAbuseDialog)N.MouseButton1Click:
connect(OnSubmitAbuse)S:FindFirstChild'OkButton'.MouseButton1Down:connect(
CloseAbuseDialog)T:FindFirstChild'OkButton'.MouseButton1Down:connect(
CloseAbuseDialog)end local function GetFriendStatus(aN)if aN==game.Players.
LocalPlayer then return Enum.FriendStatus.NotFriend else local aO,aP=pcall(
function()return game.Players.LocalPlayer:GetFriendStatus(aN)end)if aO then
return aP else return Enum.FriendStatus.NotFriend end end end function
OnFriendButtonSelect()local aN=GetFriendStatus(aw)if aN==Enum.FriendStatus.
Friend then g:RevokeFriendship(aw)elseif aN==Enum.FriendStatus.Unknown or aN==
Enum.FriendStatus.NotFriend or aN==Enum.FriendStatus.FriendRequestSent or aN==
Enum.FriendStatus.FriendRequestReceived then g:RequestFriendship(aw)end
ClosePopUpPanel()end function OnFriendRefuseButtonSelect()g:RevokeFriendship(aw)
ClosePopUpPanel()A:TweenPosition(UDim2.new(1,0,0,0),'Out','Linear',c,true)end
function PlayerSortFunction(aN,aO)if aN['Score']==aO['Score']then return aN[
'Player'].Name:upper()<aO['Player'].Name:upper()end if not aN['Score']then
return false end if not aO['Score']then return true end return aN['Score']<aO[
'Score']end function BlowThisPopsicleStand()Tabify()end function StatSort(aN,aO)
if aN.IsPrimary~=aO.IsPrimary then return aN.IsPrimary end if aN.Priority==aO.
Priority then return aN.AddId<aO.AddId end return aN.Priority<aO.Priority end
function StatChanged(aN,aO)BaseUpdate()end function StatAdded(aN,aO)while ay do
debugprint'in stat added function lock'wait(3.333333333333333E-2)end ay=true if
not(aN:IsA'StringValue'or aN:IsA'IntValue'or aN:IsA'BoolValue'or aN:IsA
'NumberValue'or aN:IsA'DoubleConstrainedValue'or aN:IsA'IntConstrainedValue')
then BlowThisPopsicleStand()else local aP=false for aQ,aR in pairs(ac)do if aR[
'Name']==aN.Name then aP=true end end if not aP then local aS={}aS['Name']=aN.
Name aS['Priority']=0 if aN:FindFirstChild'Priority'then aS['Priority']=aN.
Priority end aS['IsPrimary']=false if aN:FindFirstChild'IsPrimary'then aS[
'IsPrimary']=true end aS.AddId=ad ad=ad+1 table.insert(ac,aS)table.sort(ac,
StatSort)if not C:FindFirstChild(aS['Name'])then CreateStatTitle(aS['Name'])end
UpdateMaximize()end end ay=false StatChanged(aO)aN.Changed:connect(function(aP)
StatChanged(aO,aP)end)end function DoesStatExist(aN,aO)for aP,aQ in pairs(ae)do
if aQ['Player']~=aO and aQ['Player']:FindFirstChild'leaderstats'and aQ['Player']
.leaderstats:FindFirstChild(aN)then return true end end return false end
function StatRemoved(aN,aO)while ay do debugprint'In Adding Stat Lock1'wait(
3.333333333333333E-2)end ay=true if aO['Frame']:FindFirstChild(aN.Name)then
debugprint'Destroyed frame!'aO['Frame'][aN.Name].Parent=nil end if not
DoesStatExist(aN.Name,aO['Player'])then for aP,aQ in ipairs(ac)do if aQ['Name']
==aN.Name then table.remove(ac,aP)if C:FindFirstChild(aN.Name)then C[aN.Name]:
Destroy()end for aR,aS in pairs(af)do if aS['Frame']:FindFirstChild(aN.Name)then
aS['Frame'][aN.Name]:Destroy()end end end end end ay=false StatChanged(aO)end
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
TextTransparency=1 end aO.Parent=C end function RecreateScoreColumns(aN)while ay
do debugprint'In Adding Stat Lock2'wait(3.333333333333333E-2)end ay=true local
aO=5 local aP,aQ=aO,0 for aR=#ac,1,-1 do local aS=ac[aR]aQ=0 for aT,aU in
ipairs(aN)do local aV,aW=aU['Frame'],aU['Player']if not aV:FindFirstChild(aS[
'Name'])then local aX=MakeScoreEntry(aU,aS,aV)if aX then debugprint('adding '..
aX.Name..' to '..aU['Player'].Name)aX.Parent=aV if aU['MyTeam']and aU['MyTeam']
~=ag and not aU['MyTeam']['Frame']:FindFirstChild(aS['Name'])then local aY=aX:
Clone()aY.Parent=aU['MyTeam']['Frame']end end end aS['XOffset']=aO if aV:
FindFirstChild(aS['Name'])then aQ=math.max(aQ,aV[aS['Name']].TextBounds.X)end
end if G.Value then aQ=math.max(aQ,C[aS['Name']].TextBounds.X)C[aS['Name']]:
TweenPosition(UDim2.new(at,-aO,0,0),'Out','Linear',c,true)else C[aS['Name']]:
TweenPosition(UDim2.new((0.4+((0.6/#ac)*(aR-1)))-1,0,0,0),'Out','Linear',c,true)
end aS['ColumnSize']=aQ aO=aO+ao+aQ aP=math.max(aO,aP)end ar=UDim2.new(0,an+aP-
ao,0,800)as=UDim2.new(1,-ar.X.Offset,as.Y.Scale,0)UpdateHeaderNameSize()
UpdateMaximize()ay=false end function ToggleMinimize()D.Value=not D.Value
UpdateStatNames()end function ToggleMaximize()E.Value=not E.Value
RecreateScoreColumns(ae)end function Tabify()F.Value=true E.Value=false D.Value=
true UpdateMinimize()F.Value=true i:TweenPosition(UDim2.new(ar.X.Scale,ar.X.
Offset-10,0,0),'Out','Linear',c*1.2,true)end function UnTabify()if F.Value then
F.Value=false i:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',c*1.2,true)end
end function UpdateMinimize()if D.Value then if E.Value then ToggleMaximize()end
if not F.Value then j:TweenSizeAndPosition(UDim2.new(0.01,o.TextBounds.X,ar.Y.
Scale,ar.Y.Offset),UDim2.new(0.99,-o.TextBounds.X,as.Y.Scale,0),'Out','Linear',c
*1.2,true)else j:TweenSizeAndPosition(ar,as,'Out','Linear',c*1.2,true)end v:
TweenPosition(UDim2.new(0,0,-1,0),'Out','Linear',c*1.2,true)r:TweenPosition(
UDim2.new(0,0,0,0),'Out','Linear',c*1.2,true)k.Size=UDim2.new(1,0,m,0)t.Image=
'http://www.roblox.com/asset/?id=94692731'else if not E.Value then j:
TweenSizeAndPosition(ar,as,'Out','Linear',c*1.2,true)end au=math.min(math.max(au
,-1),-1+(#ai*I.Size.Y.Scale))UpdateScrollPosition()v.Position=UDim2.new(0,0,au,0
)local aN=(au+v.Size.Y.Scale)r.Position=UDim2.new(0,0,aN,0)k.Size=UDim2.new(1,0,
aN+m,0)t.Image='http://www.roblox.com/asset/?id=94825585'end end function
UpdateMaximize()if E.Value then for aN=1,#ac,1 do local aO=ac[aN]C[aO['Name']]:
TweenPosition(UDim2.new(0.4+((0.6/#ac)*(aN-1))-1,0,0,0),'Out','Linear',c,true)
end if D.Value then ToggleMinimize()else UpdateMinimize()end j:
TweenSizeAndPosition(ap,aq,'Out','Linear',c*1.2,true)p:TweenPosition(UDim2.new(0
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
then j:TweenSizeAndPosition(ar,as,'Out','Linear',c*1.2,true)end p:TweenPosition(
UDim2.new(0,0,0.4,0),'Out','Linear',c*1.2,true)o:TweenPosition(UDim2.new(0,0,o.
Position.Y.Scale,0),'Out','Linear',c*1.2,true)l.Background.Image=
'http://www.roblox.com/asset/?id='..b['NormalHeader']r.Background.Image=
'http://www.roblox.com/asset/?id='..b['NormalBottom']for aN,aQ in ipairs(ai)do
if aN%2~=1 then aQ.Background.Image='http://www.roblox.com/asset/?id='..b[
'midDark']else aQ.Background.Image='http://www.roblox.com/asset/?id='..b[
'midLight']end end for aT,aU in ipairs(ah)do if aU:FindFirstChild'ClickListener'
then aU.ClickListener.Size=UDim2.new(0.96,0,aU.ClickListener.Size.Y.Scale,0)for
aV=1,#ac,1 do local aW=ac[aV]if aU:FindFirstChild(aW['Name'])and aW['XOffset']
then aU[aW['Name']]:TweenPosition(UDim2.new(at,-aW['XOffset'],0,0),'Out',
'Linear',c,true)end end end end for aV,aW in ipairs(af)do WaitForChild(aW[
'Frame'],'TitleFrame').Size=UDim2.new(0,an*0.9,aW['Frame'].TitleFrame.Size.Y.
Scale,0)end for aX,aY in ipairs(ae)do WaitForChild(aY['Frame'],'TitleFrame').
Size=UDim2.new(0,an*0.9,aY['Frame'].TitleFrame.Size.Y.Scale,0)end end end
function UpdateStatNames()if not G.Value or D.Value then CloseNames()else
ExpandNames()end end function ExpandNames()if#ac~=0 then for aT,aX in pairs(C:
GetChildren())do Spawn(function()TweenProperty(aX,'TextTransparency',aX.
TextTransparency,0,c)end)end m=0.09 l:TweenSizeAndPosition(UDim2.new(l.Size.X.
Scale,l.Size.X.Offset,m,0),l.Position,'Out','Linear',c*1.2,true)u:TweenPosition(
UDim2.new(u.Position.X.Scale,0,m,0),'Out','Linear',c*1.2,true)q:TweenPosition(
UDim2.new(0,0,m,0),'Out','Linear',c*1.2,true)end end function CloseNames()if#ac
~=0 then m=0.07 if not E.Value then for aT,aX in pairs(C:GetChildren())do Spawn(
function()TweenProperty(aX,'TextTransparency',aX.TextTransparency,1,c)end)end
end q:TweenPosition(UDim2.new(0,0,m,0),'Out','Linear',c*1.2,true)l:
TweenSizeAndPosition(UDim2.new(l.Size.X.Scale,l.Size.X.Offset,m,0),l.Position,
'Out','Linear',c*1.2,true)u:TweenPosition(UDim2.new(u.Position.X.Scale,0,m,0),
'Out','Linear',c*1.2,true)end end function OnScrollWheelMove(aT)if not(F.Value
or D.Value or aB)then local aX=y.Position local aY=math.max(math.min(aX.Y.Scale+
aT,GetMaxScroll()),GetMinScroll())y.Position=UDim2.new(aX.X.Scale,aX.X.Offset,aY
,aX.Y.Offset)UpdateScrollPosition()end end function AttachScrollWheel()if aE
then return end aE={}table.insert(aE,h.WheelForward:connect(function()
OnScrollWheelMove(0.05)end))table.insert(aE,h.WheelBackward:connect(function()
OnScrollWheelMove(-5E-2)end))end function DetachScrollWheel()if aE then for aT,
aX in pairs(aE)do aX:disconnect()end end aE=nil end k.MouseEnter:connect(
function()if not(D.Value or F.Value)then AttachScrollWheel()end end)k.MouseLeave
:connect(function()DetachScrollWheel()end)function UpdateScrollBarVisibility()if
AreAllEntriesOnScreen()then x.BackgroundTransparency=1 else x.
BackgroundTransparency=0 UpdateScrollBarSize()end end function
UpdateScrollBarSize()local aT,aX=#ai*H.Size.Y.Scale,(v.Position.Y.Scale+1)x.Size
=UDim2.new(1,0,aX/aT,0)end function UpdateScrollPosition()local aT,aX=
GetMinScroll(),GetMaxScroll()local aY,aZ=aX-aT,math.max(math.min(y.Position.Y.
Scale,aX),aT)y.Position=UDim2.new(y.Position.X.Scale,y.Position.X.Offset,aZ,y.
Position.Y.Offset)local a_=1-x.Size.Y.Scale x.Position=UDim2.new(0,0,a_-(a_*((y.
Position.Y.Scale-aT)/aY)),0)end function StartDrag(aT,aX,aY)local aZ,a_,a0,a1=
tick(),false,true,WaitForChild(aT['Frame'],'ClickListener')local function
dragExit()a_=true if aT['Player']and aw and a0 and aT['Player']~=g and aw.userId
>1 and g.userId>1 then ActivatePlayerEntryPanel(aT)end end local a2,a3=nil,y.
Position local function dragpoll(a4,a5)if not a2 then a2=AbsoluteToPercent(a4,a5
).Y end local a6=AbsoluteToPercent(a4,a5).Y debugprint('drag dist:'..Vector2.
new(aX-a4,aY-a5).magnitude)if Vector2.new(aX-a4,aY-a5).magnitude>d then a0=false
end local a7=math.max(math.min(a3.Y.Scale+(a6-a2),GetMaxScroll()),GetMinScroll()
)y.Position=UDim2.new(a3.X.Scale,a3.X.Offset,a7,a3.Y.Offset)
UpdateScrollPosition()end WaitForClick(i,dragpoll,dragExit)end function
StartMinimizeDrag()Delay(0,function()local aT=tick()debugprint'Got Click2'local
aX=false local function dragExit()if tick()-aT<0.25 then ToggleMinimize()else aG
=true if D.Value then ToggleMinimize()end end aX=true end local aY,aZ=nil,au
local function dragpoll(a_,a0)if not D.Value then if not aY then aY=
AbsoluteToPercent(a_,a0).Y end local a1,a2=AbsoluteToPercent(a_,a0).Y,nil a2=
math.min(math.max(aZ+(a1-aY),-1),-1+(#ai*I.Size.Y.Scale))au=a2 UpdateMinimize()w
.Size=UDim2.new(w.Size.X.Scale,0,(au+v.Size.Y.Scale),0)w.Position=UDim2.new(w.
Position.X.Scale,0,1-w.Size.Y.Scale,0)UpdateScrollBarSize()UpdateScrollPosition(
)UpdateScrollBarVisibility()end end Spawn(function()WaitForClick(i,dragpoll,
dragExit)end)end)end E.Value=false D.Value=false E.Changed:connect(
UpdateMaximize)D.Changed:connect(UpdateMinimize)s.MouseButton1Down:connect(
function()if(time()-ak<al)or aB then return end ak=time()if F.Value then
UnTabify()else StartMinimizeDrag()end end)n.MouseButton1Click:connect(function()
if(time()-ak<al)or aB then return end ak=time()if F.Value then UnTabify()elseif
not G.Value then G.Value=true BaseUpdate()else ToggleMaximize()end end)n.
MouseButton2Click:connect(function()if(time()-ak<al)or aB then return end ak=
time()if F.Value then UnTabify()elseif E.Value then ToggleMaximize()elseif G.
Value then G.Value=false BaseUpdate()else Tabify()end end)function
AddMiddleBGFrame()local aT=I:Clone()aT.Position=UDim2.new(0.5,0,(#ai*aT.Size.Y.
Scale),0)if(#ai+1)%2~=1 then if E.Value then aT.Background.Image=
'http://www.roblox.com/asset/?id='..b['LargeDark']else aT.Background.Image=
'http://www.roblox.com/asset/?id='..b['midDark']end else if E.Value then aT.
Background.Image='http://www.roblox.com/asset/?id='..b['LargeLight']else aT.
Background.Image='http://www.roblox.com/asset/?id='..b['midLight']end end aT.
Parent=y table.insert(ai,aT)if#ai<aF and not aG then au=-1+(#ai*I.Size.Y.Scale)
end if not D.Value then UpdateMinimize()end end function RemoveMiddleBGFrame()ai
[#ai]:Destroy()table.remove(ai,#ai)if not D.Value then UpdateMinimize()end end
local aT={'Size8','Size9','Size10','Size11','Size12','Size14','Size24','Size36',
'Size48'}function ChangeHeaderName(aX)o.Text=aX UpdateHeaderNameSize()end
function UpdateHeaderNameSize()local aX=o:Clone()aX.Position=UDim2.new(2,0,2,0)
aX.Parent=i local aY=7 aX.FontSize=aT[aY]Delay(0.2,function()while aX.TextBounds
.x==0 do wait(3.333333333333333E-2)end while aX.TextBounds.x-ar.X.Offset>1 do aY
=aY-1 aX.FontSize=aT[aY]wait(0.2)end o.FontSize=aX.FontSize aX:Destroy()end)end
i.Changed:connect(UpdateHeaderNameSize)function LeaderstatsAdded(aX)local aY=aX[
'Player']for aZ,a_ in pairs(aY.leaderstats:GetChildren())do StatAdded(a_,aX)end
aY.leaderstats.ChildAdded:connect(function(a0)StatAdded(a0,aX)end)aY.leaderstats
.ChildRemoved:connect(function(a0)StatRemoved(a0,aX)end)end function
LeaderstatsRemoved(aX,aY)while ax do debugprint('waiting to insert '..aY[
'Player'].Name)wait(3.333333333333333E-2)end ax=true RemoveAllStats(aY)ax=false
end function ClosePopUpPanel()if av then local aX=av['Frame']Spawn(function()
TweenProperty(aX,'BackgroundTransparency',0.5,1,c)end)end A:TweenPosition(UDim2.
new(1,0,0,0),'Out','Linear',c,true)wait(0.1)aB=false av=nil end function
InitMovingPanel(aX,aY)z.Parent=i if A then A:Destroy()end A=B:Clone()A.Parent=z
local aZ,a_=2,GetFriendStatus(aY)debugprint(tostring(a_))local a0,a1=aM and g.
PersonalServerRank>=aL['Admin']and g.PersonalServerRank>aw.PersonalServerRank,
MakePopupButton(A,'Report Player',0)a1.MouseButton1Click:connect(function()
OpenAbuseDialog()end)local a2=MakePopupButton(A,'Friend',1,not a0 and a_~=Enum.
FriendStatus.FriendRequestReceived)a2.MouseButton1Click:connect(
OnFriendButtonSelect)if a_==Enum.FriendStatus.Friend then a2:FindFirstChild
'ButtonText'.Text='UnFriend Player'elseif a_==Enum.FriendStatus.Unknown or a_==
Enum.FriendStatus.NotFriend then a2:FindFirstChild'ButtonText'.Text=
'Send Request'elseif a_==Enum.FriendStatus.FriendRequestSent then a2:
FindFirstChild'ButtonText'.Text='Revoke Request'elseif a_==Enum.FriendStatus.
FriendRequestReceived then a2:FindFirstChild'ButtonText'.Text='Accept Friend'
local a3=MakePopupButton(A,'Decline Friend',2,not a0)a3.MouseButton1Click:
connect(OnFriendRefuseButtonSelect)aZ=aZ+1 end if a0 then local a3,a4,a5,a6=
MakePopupButton(A,'Ban',aZ),MakePopupButton(A,'Visitor',aZ+1),MakePopupButton(A,
'Member',aZ+2),MakePopupButton(A,'Admin',aZ+3,true)a3.MouseButton1Click:connect(
function()OnPrivilegeLevelSelect(aY,aL['Banned'],a3,a4,a5,a6)end)a4.
MouseButton1Click:connect(function()OnPrivilegeLevelSelect(aY,aL['Visitor'],a3,
a4,a5,a6)end)a5.MouseButton1Click:connect(function()OnPrivilegeLevelSelect(aY,aL
['Member'],a3,a4,a5,a6)end)a6.MouseButton1Click:connect(function()
OnPrivilegeLevelSelect(aY,aL['Admin'],a3,a4,a5,a6)end)HighlightMyRank(aw,a3,a4,
a5,a6)end A:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',c,true)Delay(0,
function()local a3 a3=h.Button1Down:connect(function()a3:disconnect()
ClosePopUpPanel()end)end)local a3=aX['Frame']Spawn(function()while aB do z.
Position=UDim2.new(0,a3.AbsolutePosition.X-z.Size.X.Offset,0,a3.AbsolutePosition
.Y)wait()end end)end function OnPlayerEntrySelect(aX,aY,aZ)if not aB then av=aX
aw=aX['Player']StartDrag(aX,aY,aZ)end end function ActivatePlayerEntryPanel(aX)
aX['Frame'].BackgroundColor3=Color3.new(0,1,1)Spawn(function()TweenProperty(aX[
'Frame'],'BackgroundTransparency',1,0.5,0.5)end)aB=true InitMovingPanel(aX,aX[
'Player'])end function PlayerListModeUpdate()RecreateScoreColumns(ae)table.sort(
ae,PlayerSortFunction)for aX,aY in ipairs(ae)do ah[aX]=aY['Frame']end for aZ=#ae
+1,#ah,1 do ah[aZ]=nil end UpdateMinimize()end function InsertPlayerFrame(aX)
while ax do debugprint('waiting to insert '..aX.Name)wait(3.333333333333333E-2)
end ax=true local aY=H:Clone()WaitForChild(WaitForChild(aY,'TitleFrame'),'Title'
).Text=aX.Name aY.Position=UDim2.new(1,0,(#ah*aY.Size.Y.Scale),0)local aZ=
GetFriendStatus(aX)aY:FindFirstChild'BCLabel'.Image=getMembershipTypeIcon(aX.
MembershipType,aX.Name)aY:FindFirstChild'FriendLabel'.Image=getFriendStatusIcon(
aZ)aY.Name=aX.Name WaitForChild(WaitForChild(aY,'TitleFrame'),'Title').Text=aX.
Name aY.FriendLabel.Position=aY.FriendLabel.Position+UDim2.new(0,17,0,0)aY.
TitleFrame.Title.Position=aY.TitleFrame.Title.Position+UDim2.new(0,17,0,0)if aY:
FindFirstChild'FriendLabel'.Image~=''then aY.TitleFrame.Title.Position=aY.
TitleFrame.Title.Position+UDim2.new(0,17,0,0)end if aX.Name==g.Name then aY.
TitleFrame.Title.Font='ArialBold'aY.PlayerScore.Font='ArialBold'
ChangeHeaderName(aX.Name)local a_=aY.TitleFrame.Title:Clone()a_.TextColor3=
Color3.new(0,0,0)a_.TextTransparency=0 a_.ZIndex=2 a_.Position=aY.TitleFrame.
Title.Position+UDim2.new(0,1,0,1)a_.Name='DropShadow'a_.Parent=aY.TitleFrame
else end aY.TitleFrame.Title.Font='ArialBold'aY.Parent=y aY:TweenPosition(UDim2.
new(0.5,0,(#ah*aY.Size.Y.Scale),0),'Out','Linear',c,true)UpdateMinimize()local
a_={}a_['Frame']=aY a_['Player']=aX a_['ID']=ad ad=ad+1 table.insert(ae,a_)if#af
~=0 then if aX.Neutral then a_['MyTeam']=nil if not ag then AddNeutralTeam()else
AddPlayerToTeam(ag,a_)end else local a0=false for a1,a2 in ipairs(af)do if a2[
'MyTeam'].TeamColor==aX.TeamColor then AddPlayerToTeam(a2,a_)a_['MyTeam']=a2 a0=
true end end if not a0 then a_['MyTeam']=nil if not ag then AddNeutralTeam()else
AddPlayerToTeam(ag,a_)end a_['MyTeam']=ag end end end if aX:FindFirstChild
'leaderstats'then LeaderstatsAdded(a_)end aX.ChildAdded:connect(function(a0)if
a0.Name=='leaderstats'then while ax do debugprint'in adding leaderstats lock'
wait(3.333333333333333E-2)end ax=true LeaderstatsAdded(a_)ax=false end end)aX.
ChildRemoved:connect(function(a0)if aX==g and a0.Name=='leaderstats'then
LeaderstatsRemoved(a0,a_)end end)aX.Changed:connect(function(a0)PlayerChanged(a_
,a0)end)local a0=WaitForChild(aY,'ClickListener')a0.Active=true a0.
MouseButton1Down:connect(function(a1,a2)OnPlayerEntrySelect(a_,a1,a2)end)
AddMiddleBGFrame()BaseUpdate()ax=false end function RemovePlayerFrame(aX)while
ax do debugprint'in removing player frame lock'wait(3.333333333333333E-2)end ax=
true local aY for aZ,a_ in ipairs(ae)do if aX==a_['Player']then if z.Parent==a_[
'Frame']then z.Parent=nil end a_['Frame']:Destroy()aY=a_['MyTeam']table.remove(
ae,aZ)end end if aY then for a0,a1 in ipairs(aY['MyPlayers'])do if a1['Player']
==aX then RemovePlayerFromTeam(aY,a0)end end end RemoveMiddleBGFrame()
UpdateMinimize()BaseUpdate()ax=false end f.ChildRemoved:connect(
RemovePlayerFrame)function UnrollTeams(aX,aY)local aZ=0 if ag and not ag[
'IsHidden']then for a_,a0 in ipairs(ag['MyPlayers'])do aZ=aZ+1 aY[aZ]=a0['Frame'
]end aZ=aZ+1 aY[aZ]=ag['Frame']end for a_,a0 in ipairs(aX)do if not a0[
'IsHidden']then for a1,a2 in ipairs(a0.MyPlayers)do aZ=aZ+1 aY[aZ]=a2['Frame']
end aZ=aZ+1 aY[aZ]=a0['Frame']end end for a1=aZ+1,#aY,1 do aY[a1]=nil end end
function TeamSortFunc(aX,aY)if aX['TeamScore']==aY['TeamScore']then return aX[
'ID']<aY['ID']end if not aX['TeamScore']then return false end if not aY[
'TeamScore']then return true end return aX['TeamScore']<aY['TeamScore']end
function SortTeams(aX)for aY,aZ in ipairs(aX)do table.sort(aZ['MyPlayers'],
PlayerSortFunction)AddTeamScores(aZ)end table.sort(aX,TeamSortFunc)end function
TeamListModeUpdate()RecreateScoreColumns(ae)SortTeams(af)if ag then
AddTeamScores(ag)end UnrollTeams(af,ah)end function AddTeamScores(aX)for aY=1,#
ac,1 do local aZ,a_=ac[aY],0 for a0,a1 in ipairs(aX['MyPlayers'])do local a2=a1[
'Player']:FindFirstChild'leaderstats'and a1['Player'].leaderstats:
FindFirstChild(aZ['Name'])if a2 and not a2:IsA'StringValue'then a_=a_+
GetScoreValue((a1['Player'].leaderstats)[aZ['Name']])end end if aX['Frame']:
FindFirstChild(aZ['Name'])then aX['Frame'][aZ['Name']].Text=tostring(a_)end end
UpdateMinimize()end function FindRemovePlayerFromTeam(aX)if aX['MyTeam']then for
aY,aZ in ipairs(aX['MyTeam']['MyPlayers'])do if aZ['Player']==aX['Player']then
RemovePlayerFromTeam(aX['MyTeam'],aY)return end end elseif ag then for aY,aZ in
ipairs(ag['MyPlayers'])do if aZ['Player']==aX['Player']then
RemovePlayerFromTeam(ag,aY)return end end end end function RemovePlayerFromTeam(
aX,aY)table.remove(aX['MyPlayers'],aY)if aX==ag and#aX['MyPlayers']==0 then
RemoveNeutralTeam()end end function AddPlayerToTeam(aX,aY)
FindRemovePlayerFromTeam(aY)table.insert(aX['MyPlayers'],aY)aY['MyTeam']=aX if
aX['IsHidden']then aX['Frame'].Parent=y AddMiddleBGFrame()end aX['IsHidden']=
false end function SetPlayerToTeam(aX)FindRemovePlayerFromTeam(aX)local aY=false
for aZ,a_ in ipairs(af)do if a_['MyTeam'].TeamColor==aX['Player'].TeamColor then
AddPlayerToTeam(a_,aX)aY=true end end if not aY and#(game.Teams:GetTeams())>0
then debugprint(aX['Player'].Name..'could not find team')aX['MyTeam']=nil if not
ag then AddNeutralTeam()else AddPlayerToTeam(ag,aX)end end end function
PlayerChanged(aX,aY)while aC do debugprint'in playerchanged lock'wait(
3.333333333333333E-2)end aC=true if aY=='Neutral'then if aX['Player'].Neutral
and#(game.Teams:GetTeams())>0 then debugprint(aX['Player'].Name..
'setting to neutral')FindRemovePlayerFromTeam(aX)aX['MyTeam']=nil if not ag then
debugprint(aX['Player'].Name..'creating neutral team')AddNeutralTeam()else
debugprint(aX['Player'].Name..'adding to neutral team')AddPlayerToTeam(ag,aX)end
elseif#(game.Teams:GetTeams())>0 then debugprint(aX['Player'].Name..
'has been set non-neutral')SetPlayerToTeam(aX)end BaseUpdate()elseif aY==
'TeamColor'and not aX['Player'].Neutral and aX['Player']~=aX['MyTeam']then
debugprint(aX['Player'].Name..'setting to new team')SetPlayerToTeam(aX)
BaseUpdate()elseif aY=='Name'or aY=='MembershipType'then aX['Frame']:
FindFirstChild'BCLabel'.Image=getMembershipTypeIcon(aX['Player'].MembershipType,
aX['Player'].Name)aX['Frame'].Name=aX['Player'].Name aX['Frame'].TitleFrame.
Title.Text=aX['Player'].Name if aX['Frame'].BCLabel.Image~=''then aX['Frame'].
TitleFrame.Title.Position=UDim2.new(0.01,30,0.1,0)end if aX['Player']==g then aX
['Frame'].TitleFrame.DropShadow.Text=aX['Player'].Name ChangeHeaderName(aX[
'Player'].Name)end BaseUpdate()end aC=false end function OnFriendshipChanged(aX,
aY)Delay(0.5,function()debugprint('friend status changed for:'..aX.Name..' '..
tostring(aY)..' vs '..tostring(GetFriendStatus(aX)))for aZ,a_ in ipairs(ae)do if
a_['Player']==aX then local a0=getFriendStatusIcon(aY)if a0==''and a_['Frame'].
FriendLabel.Image~=''then a_['Frame'].TitleFrame.Title.Position=a_['Frame'].
TitleFrame.Title.Position-UDim2.new(0,17,0,0)elseif a0~=''and a_['Frame'].
FriendLabel.Image==''then a_['Frame'].TitleFrame.Title.Position=a_['Frame'].
TitleFrame.Title.Position+UDim2.new(0,17,0,0)debugprint('confirmed status:'..aX.
Name)end a_['Frame'].FriendLabel.Image=a0 return end end end)end g.
FriendStatusChanged:connect(OnFriendshipChanged)function AddNeutralTeam()while
aD do debugprint'in neutral team 2 lock'wait()end aD=true local aX=Instance.new
'Team'aX.TeamColor=BrickColor.new'White'aX.Name='Neutral'local aY={}aY['MyTeam']
=aX aY['MyPlayers']={}aY['Frame']=H:Clone()WaitForChild(WaitForChild(aY['Frame']
,'TitleFrame'),'Title').Text=aX.Name aY['Frame'].TitleFrame.Position=UDim2.new(
aY['Frame'].TitleFrame.Position.X.Scale,aY['Frame'].TitleFrame.Position.X.Offset
,0.1,0)aY['Frame'].TitleFrame.Size=UDim2.new(aY['Frame'].TitleFrame.Size.X.Scale
,aY['Frame'].TitleFrame.Size.X.Offset,0.8,0)aY['Frame'].TitleFrame.Title.Font=
'ArialBold'aY['Frame'].Position=UDim2.new(1,0,(#ah*aY['Frame'].Size.Y.Scale),0)
WaitForChild(aY['Frame'],'ClickListener').MouseButton1Down:connect(function(aZ,
a_)StartDrag(aY,aZ,a_)end)aY['Frame'].ClickListener.BackgroundColor3=Color3.new(
1,1,1)aY['Frame'].ClickListener.BackgroundTransparency=0.7 aY['Frame'].
ClickListener.AutoButtonColor=false aY['AutoHide']=true aY['IsHidden']=true for
aZ,a_ in pairs(ae)do if a_['Player'].Neutral or not a_['MyTeam']then
AddPlayerToTeam(aY,a_)end end if#aY['MyPlayers']>0 then ag=aY UpdateMinimize()
BaseUpdate()end aD=false end function RemoveNeutralTeam()while aD do debugprint
'in neutral team lock'wait()end aD=true ag['Frame']:Destroy()ag=nil
RemoveMiddleBGFrame()aD=false end function TeamScoreChanged(aX,aY)WaitForChild(
aX['Frame'],'PlayerScore').Text=tostring(aY)aX['TeamScore']=aY end function
TeamChildAdded(aX,aY)if aY.Name=='AutoHide'then aX['AutoHide']=true elseif aY.
Name=='TeamScore'then WaitForChild(aX['Frame'],'PlayerScore').Text=tostring(aY.
Value)aX['TeamScore']=aY.Value aY.Changed:connect(function()TeamScoreChanged(aX,
aY.Value)end)end end function TeamChildRemoved(aX,aY)if aY.Name=='AutoHide'then
aX['AutoHide']=false elseif aY.Name=='TeamScore'then WaitForChild(aX['Frame'],
'PlayerScore').Text=''aX['TeamScore']=nil end end function TeamChanged(aX,aY)if
aY=='Name'then WaitForChild(WaitForChild(aX['Frame'],'TitleFrame'),'Title').Text
=aX['MyTeam'].Name elseif aY=='TeamColor'then aX['Frame'].ClickListener.
BackgroundColor3=aX['MyTeam'].TeamColor.Color for aZ,a_ in pairs(af)do if a_[
'MyTeam'].TeamColor==aX['MyTeam']then RemoveTeamFrame(aX['MyTeam'])end end aX[
'MyPlayers']={}for a0,a1 in pairs(ae)do SetPlayerToTeam(a1)end BaseUpdate()end
end function InsertTeamFrame(aX)while ax do debugprint
'in adding team frame lock'wait(3.333333333333333E-2)end ax=true local aY={}aY[
'MyTeam']=aX aY['MyPlayers']={}aY['Frame']=H:Clone()WaitForChild(WaitForChild(aY
['Frame'],'TitleFrame'),'Title').Text=aX.Name aY['Frame'].TitleFrame.Title.Font=
'ArialBold'aY['Frame'].TitleFrame.Title.FontSize='Size18'aY['Frame'].TitleFrame.
Position=UDim2.new(aY['Frame'].TitleFrame.Position.X.Scale,aY['Frame'].
TitleFrame.Position.X.Offset,0.1,0)aY['Frame'].TitleFrame.Size=UDim2.new(aY[
'Frame'].TitleFrame.Size.X.Scale,aY['Frame'].TitleFrame.Size.X.Offset,0.8,0)aY[
'Frame'].Position=UDim2.new(1,0,(#ah*aY['Frame'].Size.Y.Scale),0)WaitForChild(aY
['Frame'],'ClickListener').MouseButton1Down:connect(function(a0,a1)StartDrag(aY,
a0,a1)end)aY['Frame'].ClickListener.BackgroundColor3=aX.TeamColor.Color aY[
'Frame'].ClickListener.BackgroundTransparency=0.7 aY['Frame'].ClickListener.
AutoButtonColor=false ad=ad+1 aY['ID']=ad aY['AutoHide']=false if aX:
FindFirstChild'AutoHide'then aY['AutoHide']=true end if aX:FindFirstChild
'TeamScore'then TeamChildAdded(aY,aX.TeamScore)end aX.ChildAdded:connect(
function(a0)TeamChildAdded(aY,a0)end)aX.ChildRemoved:connect(function(a0)
TeamChildRemoved(aY,a0)end)aX.Changed:connect(function(a0)TeamChanged(aY,a0)end)
for a0,a1 in pairs(ae)do if not a1['Player'].Neutral and a1['Player'].TeamColor
==aX.TeamColor then AddPlayerToTeam(aY,a1)end end aY['IsHidden']=false if not aY
['AutoHide']or#aY['MyPlayers']>0 then aY['Frame'].Parent=y aY['Frame']:
TweenPosition(UDim2.new(0.5,0,(#ah*aY['Frame'].Size.Y.Scale),0),'Out','Linear',c
,true)AddMiddleBGFrame()else aY['IsHidden']=true aY['Frame'].Parent=nil end
table.insert(af,aY)UpdateMinimize()BaseUpdate()if#af==1 and not ag then
AddNeutralTeam()end ax=false end function RemoveTeamFrame(aX)while ax do
debugprint'in removing team frame lock'wait(3.333333333333333E-2)end ax=true if
D.Value then end local aY for a0,a1 in ipairs(af)do if aX==a1['MyTeam']then aY=
a1 a1['Frame']:Destroy()table.remove(af,a0)end end if#af==0 then debugprint
'removeteamframe, remove neutral'if ag then RemoveNeutralTeam()end end for a2,a3
in ipairs(aY['MyPlayers'])do RemovePlayerFromTeam(aY,a2)PlayerChanged(a3,
'TeamColor')end RemoveMiddleBGFrame()BaseUpdate()ax=false end function TeamAdded
(aX)InsertTeamFrame(aX)end function TeamRemoved(aX)RemoveTeamFrame(aX)end
function BaseUpdate()while az do debugprint'in baseupdate lock'wait(
3.333333333333333E-2)end az=true UpdateStatNames()if#af==0 and not ag then
PlayerListModeUpdate()else TeamListModeUpdate()end for aX,aY in ipairs(ah)do if
aY.Parent~=nil then aY:TweenPosition(UDim2.new(0.5,0,((#ah-aX)*aY.Size.Y.Scale),
0),'Out','Linear',c,true)end end if not D.Value and#ah>_ then
UpdateScrollPosition()end UpdateMinimize()UpdateScrollBarSize()
UpdateScrollPosition()UpdateScrollBarVisibility()az=false end game.GuiService:
AddKey'\t'local aX=time()game.GuiService.KeyPressed:connect(function(aY)if aY==
'\t'then debugprint'caught tab key'local a2,a3=pcall(function()return game.
GuiService.IsModalDialog end)if a2==false or(a2 and a3==false)then if time()-aX>
0.4 then aX=time()if F.Value then if not E.Value then i:TweenPosition(UDim2.new(
0,0,0,0),'Out','Linear',c*1.2,true)E.Value=true else i:TweenPosition(UDim2.new(
ar.X.Scale,ar.X.Offset-10,0,0),'Out','Linear',c*1.2,true)E.Value=false D.Value=
true end else ToggleMaximize()end end end end end)function PlayersChildAdded(aY)
if aY:IsA'Player'then Spawn(function()debugPlayerAdd(aY)end)else
BlowThisPopsicleStand()end end function coreGuiChanged(aY,a2)if aY==Enum.
CoreGuiType.All or aY==Enum.CoreGuiType.PlayerList then j.Visible=a2 end end
function TeamsChildAdded(aY)if aY:IsA'Team'then TeamAdded(aY)else
BlowThisPopsicleStand()end end function TeamsChildRemoved(aY)if aY:IsA'Team'then
TeamRemoved(aY)else BlowThisPopsicleStand()end end function debugPlayerAdd(aY)
InsertPlayerFrame(aY)end pcall(function()coreGuiChanged(Enum.CoreGuiType.
PlayerList,Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList))Game.
StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)end)while not game:
GetService'Teams'do wait(3.333333333333333E-2)debugprint'Waiting For Teams'end
for aY,a2 in pairs(game.Teams:GetTeams())do TeamAdded(a2)end for a3,a4 in pairs(
f:GetPlayers())do Spawn(function()debugPlayerAdd(a4)end)end game.Teams.
ChildAdded:connect(TeamsChildAdded)game.Teams.ChildRemoved:connect(
TeamsChildRemoved)f.ChildAdded:connect(PlayersChildAdded)InitReportAbuse()G.
Value=true BaseUpdate()wait(2)aM=not not game.Workspace:FindFirstChild
'PSVariable'if g.Name=='newplayerlistisbad'or g.Name=='imtotallyadmin'then V.
Parent=i Spawn(function()while true do local a5=''for a6,a7 in pairs(game.
Players:GetPlayers())do a5=a5..' '..a7.Name end W.Text=a5 wait(0.5)end end)end