print'[Mercury]: Loaded corescript 48488235'local a,b,c,d,e={taskmanager=1,
Heliodex=1,multako='http://www.roblox.com/asset/?id=6923328292',mercury=1,
pizzaboxer='http://www.roblox.com/asset/?id=6917566633'},{bottomDark='94691904',
bottomLight='94691940',midDark='94691980',midLight='94692025',LargeDark=
'96098866',LargeLight='96098920',LargeHeader='96097470',NormalHeader='94692054',
LargeBottom='96397271',NormalBottom='94754966',DarkBluePopupMid='97114905',
LightBluePopupMid='97114905',DarkPopupMid='97112126',LightPopupMid='97109338',
DarkBluePopupTop='97114838',DarkBluePopupBottom='97114758',DarkPopupBottom=
'100869219',LightPopupBottom='97109175'},0.25,15,nil e=function(f,g,h)if not(h~=
nil)then h=g g=nil end local i=Instance.new(f)if g then i.Name=g end local j for
k,l in pairs(h)do if type(k)=='string'then if k=='Parent'then j=l else i[k]=l
end elseif type(k)=='number'and type(l)=='userdata'then l.Parent=i end end i.
Parent=j return i end local f f=function(g)return e('ImageLabel','Background',{
BackgroundTransparency=1,Image=g,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,
1,0)})end local g g=function(h,i,j)return Color3.new(h/255,i/255,j/255)end local
h h=function(i,j)if(a[string.lower(j)]~=nil)then if a[string.lower(j)]==1 then
return'http://www.roblox.com/asset/?id=6923330951'else return a[string.lower(j)]
end elseif i==Enum.MembershipType.None then return''elseif i==Enum.
MembershipType.BuildersClub then return'rbxasset://textures/ui/TinyBcIcon.png'
elseif i==Enum.MembershipType.TurboBuildersClub then return
'rbxasset://textures/ui/TinyTbcIcon.png'elseif i==Enum.MembershipType.
OutrageousBuildersClub then return'rbxasset://textures/ui/TinyObcIcon.png'else
return error('Unknown membershipType '..tostring(i))end end local i i=function(j
)if j==Enum.FriendStatus.Unknown or j==Enum.FriendStatus.NotFriend then return''
elseif j==Enum.FriendStatus.Friend then return
'http://www.roblox.com/asset/?id=99749771'elseif j==Enum.FriendStatus.
FriendRequestSent then return'http://www.roblox.com/asset/?id=99776888'elseif j
==Enum.FriendStatus.FriendRequestReceived then return
'http://www.roblox.com/asset/?id=99776838'else return error(
'Unknown FriendStatus: '..tostring(j))end end local j j=function(k,l,m,n)local o
=e('ImageButton','ReportButton',{BackgroundTransparency=1,Position=UDim2.new(0,0
,1*m,0),Size=UDim2.new(1,0,1,0),ZIndex=7,Parent=k,e('TextLabel','ButtonText',{
BackgroundTransparency=1,Position=UDim2.new(0.07,0,0.07,0),Size=UDim2.new(0.86,0
,0.86,0),Font='ArialBold',Text=l,FontSize='Size14',TextScaled=true,TextColor3=
Color3.new(1,1,1),TextStrokeTransparency=1,ZIndex=7})})o.Image=
'http://www.roblox.com/asset/?id='..(function()if m==0 then return'97108784'
elseif n then if m%2==1 then return b['LightPopupBottom']else return b[
'DarkPopupBottom']end else if m%2==1 then return'97112126'else return'97109338'
end end end)()return o end local k,l,m=nil,true,nil m=function(n)if l then k.
Text=n end end local n n=function(o,p)while not o:FindFirstChild(p)do wait()m(
' child '..tostring(o.Name)..' waiting for '..tostring(p))end return o[p]end
local o=game:GetService'Players'while not o.LocalPlayer do o.Changed:wait()end
local p=o.LocalPlayer local q,r=p:GetMouse(),e('Frame','PlayerListScreen',{Size=
UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=script.Parent})local s=e(
'Frame','LeaderBoardFrame',{Position=UDim2.new(1,-150,0.005,0),Size=UDim2.new(0,
150,0,800),BackgroundTransparency=1,Parent=r})local t,u=e('Frame','FocusFrame',{
Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,100),BackgroundTransparency=1,
Active=true,Parent=s}),e('Frame','Header',{BackgroundTransparency=1,Position=
UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0.07,0),Parent=s,f
'http://www.roblox.com/asset/?id=94692054'})local v,w,x,y=u.Size.Y.Scale,e(
'ImageButton','MaximizeButton',{Active=true,BackgroundTransparency=1,Position=
UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),Parent=u}),e('TextLabel','PlayerName'
,{BackgroundTransparency=1,Position=UDim2.new(0,0,0.01,0),Size=UDim2.new(0.98,0,
0.38,0),Parent=u,Font='ArialBold',Text=p.Name,FontSize='Size24',TextColor3=
Color3.new(1,1,1),TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0,
TextXAlignment='Right',TextYAlignment='Center'}),e('TextLabel','PlayerScore',{
BackgroundTransparency=1,Position=UDim2.new(0,0,0.4,0),Size=UDim2.new(0.98,0,0,
30),Parent=u,Font='ArialBold',Text='',FontSize='Size24',TextYAlignment='Top',
TextColor3=Color3.new(1,1,1),TextStrokeTransparency=1,TextXAlignment='Right'})
local z=e('Frame','BottomShiftFrame',{BackgroundTransparency=1,Position=UDim2.
new(0,0,v,0),Size=UDim2.new(1,0,1,0),Parent=s})local A=e('Frame','Bottom',{
BackgroundTransparency=1,Position=UDim2.new(0,0,0.07,0),Size=UDim2.new(1,0,0.03,
0),Parent=z,f'http://www.roblox.com/asset/?id=94754966'})local B,C,D=e(
'ImageButton','bigbutton',{Active=true,BackgroundTransparency=1,Position=UDim2.
new(0,0,0,0),Size=UDim2.new(1,0,1.5,0),ZIndex=3,Parent=A}),e('ImageButton',
'extendTab',{Active=true,BackgroundTransparency=1,Image=
'http://www.roblox.com/asset/?id=94692731',Position=UDim2.new(0.608,0,0.3,0),
Size=UDim2.new(0.3,0,0.7,0),Parent=A}),e('Frame','ListFrame',{
BackgroundTransparency=1,Position=UDim2.new(-1,0,0.07,0),Size=UDim2.new(2,0,1,0)
,Parent=s,ClipsDescendants=true})local E=e('Frame','BottomFrame',{
BackgroundTransparency=1,Position=UDim2.new(0,0,-0.8,0),Size=UDim2.new(1,0,1,0),
Parent=D,ClipsDescendants=true})local F=e('Frame','ScrollBarFrame',{
BackgroundTransparency=1,Position=UDim2.new(0.987,0,0.8,0),Size=UDim2.new(0.01,0
,0.2,0),Parent=E})local G,H,I,J=e('Frame','ScrollBar',{BackgroundTransparency=0,
BackgroundColor3=Color3.new(0.2,0.2,0.2),Position=UDim2.new(0,0,0,0),Size=UDim2.
new(1,0,0.5,0),ZIndex=5,Parent=F}),e('Frame','SubFrame',{BackgroundTransparency=
1,Position=UDim2.new(0,0,0.8,0),Size=UDim2.new(1,0,1,0),Parent=E}),e('Frame',
'PopUpFrame',{BackgroundTransparency=1,SizeConstraint='RelativeXX',Position=s.
Position+UDim2.new(0,-150,0,0),Size=UDim2.new(0,150,0,800),Parent=s,
ClipsDescendants=true,ZIndex=7}),nil local K,L,M,N,O,P,Q,R,S=e('Frame','Panel',{
BackgroundTransparency=1,Position=UDim2.new(1,0,0,0),Size=UDim2.new(1,0,0.032,0)
,Parent=I}),e('Frame','StatTitles',{BackgroundTransparency=1,Position=UDim2.new(
0,0,1,-10),Size=UDim2.new(1,0,0,0),Parent=u}),Instance.new'BoolValue',Instance.
new'BoolValue',Instance.new'BoolValue',Instance.new'BoolValue',e('Frame',{Name=
'MidTemplate',BackgroundTransparency=1,Position=UDim2.new(100,0,0.07,0),Size=
UDim2.new(0.5,0,0.025,0),e('ImageLabel',{Name='BCLabel',Active=true,
BackgroundTransparency=1,Position=UDim2.new(0.005,5,0.2,0),Size=UDim2.new(0,16,0
,16),SizeConstraint='RelativeYY',Image='',ZIndex=3}),e('ImageLabel',{Name=
'FriendLabel',Active=true,BackgroundTransparency=1,Position=UDim2.new(0.005,5,
0.15,0),Size=UDim2.new(0,16,0,16),SizeConstraint='RelativeYY',Image='',ZIndex=3}
),e('ImageButton','ClickListener',{Active=true,BackgroundTransparency=1,Position
=UDim2.new(0.005,1,0,0),Size=UDim2.new(0.96,0,1,0),ZIndex=3}),e('Frame',
'TitleFrame',{BackgroundTransparency=1,Position=UDim2.new(0.01,0,0,0),Size=UDim2
.new(0,140,1,0),ClipsDescendants=true,e('TextLabel','Title',{
BackgroundTransparency=1,Position=UDim2.new(0,5,0,0),Size=UDim2.new(100,0,1,0),
Font='Arial',FontSize='Size14',TextColor3=Color3.new(1,1,1),TextXAlignment=
'Left',TextYAlignment='Center',ZIndex=3})}),e('TextLabel','PlayerScore',{
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
Font='ArialBold',Text='',FontSize='Size14',TextColor3=Color3.new(1,1,1),
TextXAlignment='Right',TextYAlignment='Center',ZIndex=3}),ZIndex=3}),e('Frame',
'MidBGTemplate',{BackgroundTransparency=1,Position=UDim2.new(100,0,0.07,0),Size=
UDim2.new(0.5,0,0.025,0),f'http://www.roblox.com/asset/?id=94692025'}),e(
'TextButton','ReportAbuseShield',{Text='',AutoButtonColor=false,Active=true,
Visible=true,Size=UDim2.new(1,0,1,0),BackgroundColor3=g(51,51,51),BorderColor3=
g(27,42,53),BackgroundTransparency=1})local T,U=e('Frame','Settings',{Position=
UDim2.new(0.5,-250,0.5,-200),Size=UDim2.new(0,500,0,400),BackgroundTransparency=
1,Active=true,Parent=S}),nil U=e('Frame','ReportAbuseStyle',{Size=UDim2.new(1,0,
1,0),Active=true,BackgroundTransparency=1,Parent=T,f
'http://www.roblox.com/asset/?id=96488767',e('TextLabel','Title',{Text=
'Report Abuse',TextColor3=g(221,221,221),Position=UDim2.new(0.5,0,0,30),Font=
Enum.Font.ArialBold,FontSize=Enum.FontSize.Size36}),e('TextLabel','Description',
{Text=
[[This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.]]
,TextColor3=g(221,221,221),Position=UDim2.new(0.01,0,0,55),Size=UDim2.new(0.99,0
,0,40),BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.
Size18,TextWrap=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum
.TextYAlignment.Top}),e('TextLabel','AbuseLabel',{Text='What did they do?',Font=
Enum.Font.Arial,BackgroundTransparency=1,FontSize=Enum.FontSize.Size18,Position=
UDim2.new(0.025,0,0,140),Size=UDim2.new(0.4,0,0,36),TextColor3=g(255,255,255),
TextXAlignment=Enum.TextXAlignment.Left}),e('TextLabel','ShortDescriptionLabel',
{Text='Short Description: (optional)',Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size18,Position=UDim2.new(0.025,0,0,180),Size=UDim2.new(0.95,0,0,36),
TextColor3=g(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,
BackgroundTransparency=1}),e('TextLabel','ReportingPlayerLabel',{Text=
'Reporting Player',BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size18,Position=UDim2.new(0.025,0,0,100),Size=UDim2.new(0.95,0,0,36),
TextColor3=g(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,Parent=U})})
local V,W,X,Y,Z,_,aa,ab,ac,ad=e('TextLabel','PlayerLabel',{Text='',
BackgroundTransparency=1,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size18,
Position=UDim2.new(0.025,0,0,100),Size=UDim2.new(0.95,0,0,36),TextColor3=g(255,
255,255),TextXAlignment=Enum.TextXAlignment.Right,Parent=U}),e('ImageButton',
'SubmitReportBtn',{Active=false,BackgroundTransparency=1,Position=UDim2.new(0.5,
-200,1,-80),Size=UDim2.new(0,150,0,50),AutoButtonColor=false,Image=
'http://www.roblox.com/asset/?id=96502438',Parent=U}),e('ImageButton',
'CancelBtn',{BackgroundTransparency=1,Position=UDim2.new(0.5,50,1,-80),Size=
UDim2.new(0,150,0,50),AutoButtonColor=true,Image=
'http://www.roblox.com/asset/?id=96500683',Parent=U}),e('Frame',
'AbuseDescriptionWrapper',{Position=UDim2.new(0.025,0,0,220),Size=UDim2.new(0.95
,0,1,-310),BackgroundColor3=g(0,0,0),BorderSizePixel=0,Parent=U}),nil,e(
'TextBox',{Text='',ClearTextOnFocus=false,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size18,Position=UDim2.new(0,3,0,3),Size=UDim2.new(1,-6,1,-6),TextColor3
=g(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.
TextYAlignment.Top,TextWrap=true,BackgroundColor3=g(0,0,0),BorderSizePixel=0}),
e('Frame','AbuseFeedbackBox',{BackgroundTransparency=1,Position=UDim2.new(0.25,0
,0.3,0),Size=UDim2.new(0.5,0,0.37,0),f'http://www.roblox.com/asset/?id=96506233'
,e('TextLabel','Header',{Position=UDim2.new(0,10,0.05,0),Size=UDim2.new(1,-30,
0.15,0),TextScaled=true,BackgroundTransparency=1,TextXAlignment=Enum.
TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Top,Text=
'Thanks for your report!',TextColor3=Color3.new(1,1,1),FontSize=Enum.FontSize.
Size48,Font='ArialBold'}),e('TextLabel','content',{Position=UDim2.new(0,10,0.2,0
),Size=UDim2.new(1,-30,0.4,0),TextScaled=true,BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),Text=
[[Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.

If anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats]]
,TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,FontSize=Enum.FontSize.
Size24,Font='Arial'}),e('ImageButton','OkButton',{BackgroundTransparency=1,
Position=UDim2.new(0.5,-75,1,-80),Size=UDim2.new(0,150,0,50),AutoButtonColor=
true,Image='http://www.roblox.com/asset/?id=96507959'})}),e('Frame',
'AbuseFeedbackBox',{BackgroundTransparency=1,Position=UDim2.new(0.25,0,
0.300000012,0),Size=UDim2.new(0.5,0,0.370000005,0),f
'http://www.roblox.com/asset/?id=96506233',e('TextLabel','Header',{Position=
UDim2.new(0,10,0.05,0),Size=UDim2.new(1,-30,0.15,0),TextScaled=true,
BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.
TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Top,Text=
'Thanks for your report!',FontSize=Enum.FontSize.Size48,Font='ArialBold'}),e(
'TextLabel','content',{Position=UDim2.new(0,10,0.2,0),Size=UDim2.new(1,-30,0.15,
0),TextScaled=true,BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),Text=
[[Our moderators will review the chat logs and determine what happened.]],
TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,FontSize=Enum.FontSize.
Size24,Font='Arial'}),e('ImageButton','OkButton',{BackgroundTransparency=1,
Position=UDim2.new(0.5,-75,1,-80),Size=UDim2.new(0,150,0,50),AutoButtonColor=
true,Image='http://www.roblox.com/asset/?id=96507959'})}),e('ImageButton',{Size=
UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=8,Visible=false,Parent=r}),e(
'Frame','debugframe',{BackgroundTransparency=1,Position=UDim2.new(0.25,0,0.3,0),
Size=UDim2.new(0.5,0,0.37,0),f'http://www.roblox.com/asset/?id=96506233'})local
ae=e('TextLabel',{BackgroundTransparency=0.8,Position=UDim2.new(0,0,0.01,0),Size
=UDim2.new(1,0,0.5,0),Parent=ad,Font='ArialBold',Text='--',FontSize='Size14',
TextWrapped=true,TextColor3=Color3.new(1,1,1),TextStrokeColor3=Color3.new(0,0,0)
,TextStrokeTransparency=0,TextXAlignment='Right',TextYAlignment='Center'})k=e(
'TextLabel',{BackgroundTransparency=0.8,Position=UDim2.new(0,0,0.5,0),Size=UDim2
.new(1,0,0.5,0),Parent=ad,Font='ArialBold',Text='--',FontSize='Size14',
TextWrapped=true,TextColor3=Color3.new(1,1,1),TextStrokeColor3=Color3.new(0,0,0)
,TextStrokeTransparency=0,TextXAlignment='Right',TextYAlignment='Center'})local
af,ag=assert(LoadLibrary'RbxGui'),8 for ah,ai in pairs(b)do Game:GetService
'ContentProvider':Preload('http://www.roblox.com/asset/?id='..tostring(ai))end
local aj,ak,al,am,an,ao,ap,aq,ar,as={},0,{},{},nil,{},{},0,0.25,false pcall(
function()as=Game:GetService'UserInputService'.TouchEnabled end)local at,au,av,
aw=150,10,UDim2.new(0.5,0,1,0),UDim2.new(0.25,0,0.1,0)local ax,ay,az,aA,aB,aC,aD
,aE,aF,aG,aH,aI,aJ,aK,aL=UDim2.new(0,at,0,800),UDim2.new(1,-at,0.005,0),-4E-2,E.
Position.Y.Scale,nil,nil,false,false,false,false,false,false,false,{},8 if not
as then aL=12 end local aM,aN,aO,aP,aQ,aR,aS=false,nil,{'Bad Words or Threats',
'Bad Username','Talking about Dating','Account Trading or Sharing',
'Asking Personal Questions','Rude or Mean Behavior','False Reporting Me'},nil,
nil,{Owner=255,Admin=240,Member=128,Visitor=10,Banned=0},not not game.Workspace:
FindFirstChild'PSVariable'game.Workspace.ChildAdded:connect(function(aT)if aT.
Name=='PSVariable'and aT:IsA'BoolValue'then aS=true end end)local aT aT=function
()return#ap*Q.Size.Y.Scale<=1+aA end local aU aU=function()return aA*-1 end
local aV aV=function()if aT()then return aU()else return(aU()-(#ap*Q.Size.Y.
Scale))+(1+aA)end end local aW aW=function(aX,aY)return Vector2.new(aX,aY)/r.
AbsoluteSize end local aX aX=function(aY,aZ,a_,a0,a1)local a2=tick()while tick()
-a2<a1 do aY[aZ]=((a0-a_)*((tick()-a2)/a1))+a_ wait(3.333333333333333E-2)end aY[
aZ]=a0 end local aY aY=function(aZ,a_,a0)if aG then return end aG=true local a1,
a2 a1=ac.MouseButton1Up:connect(function(a3,a4)a0(a3,a4)ac.Visible=false a1:
disconnect()if a2~=nil then return a2:disconnect()end return nil end)a2=ac.
MouseMoved:connect(function(a3,a4)return a_(a3,a4)end)ac.Visible=true ac.Active=
true ac.Parent=aZ aZ.AncestryChanged:connect(function(a3,a4)if a3==aZ and not(a4
~=nil)then a0(nx,ny)ac.Visible=false a1:disconnect()a2:disconnect()return m
'forced out of wait for click'end end)aG=false end local aZ aZ=function(a_,a0)
while a_.PersonalServerRank<a0 do game:GetService'PersonalServerService':
Promote(a_)end while a_.PersonalServerRank>a0 do game:GetService
'PersonalServerService':Demote(a_)end end local a_,a0=
'http://www.roblox.com/asset/?id=',nil a0=function(a1,a2,a3,a4,a5)a2.Image=a_..b
['LightPopupMid']a3.Image=a_..b['DarkPopupMid']a4.Image=a_..b['LightPopupMid']a5
.Image=a_..b['DarkPopupBottom']local a6=a1.PersonalServerRank if a6<=aR['Banned'
]then a2.Image=a_..b['LightBluePopupMid']elseif a6<=aR['Visitor']then a3.Image=
a_..b['DarkBluePopupMid']elseif a6<=aR['Member']then a4.Image=a_..b[
'LightBluePopupMid']elseif a6<=aR['Admin']then a5.Image=a_..b[
'DarkBluePopupBottom']end end local a1 a1=function(a2,a3,a4,a5,a6,a7)m
'setting privilege level'aZ(a2,a3)return a0(a2,a4,a5,a6,a7)end local a2 a2=
function()aN=nil W.Active=false W.Image=
'http://www.roblox.com/asset/?id=96502438'Z:Destroy()aa.Parent=nil ab.Parent=nil
S.Parent=nil U.Visible=true end local a3 a3=function()if W.Active then if aN and
aC then U.Visible=false game.Players:ReportAbuse(aC,aN,Z.Text)if aN==
'Rude or Mean Behavior'or aN=='False Reporting Me'then aa.Parent=S else m
'opening abuse box'ab.Parent=S end else return a2()end end end local a4 a4=
function()if aB then local a5=aB['Frame']Spawn(function()return aX(a5,
'BackgroundTransparency',0.5,1,c)end)end J:TweenPosition(UDim2.new(1,0,0,0),
'Out','Linear',c,true)wait(0.1)aH=false aB=nil end local a5 a5=function()m
'adding report dialog'V.Text=aC.Name J:TweenPosition(UDim2.new(1,0,0,0),'Out',
'Linear',c,true)Z=_:Clone()Z.Parent=Y S.Parent=r return a4()end local a6 a6=
function()aP=function(a7)aN=a7 if aN and aC then W.Active=true W.Image=
'http://www.roblox.com/asset/?id=96501119'end end local a7 aQ,a7=af.
CreateDropDownMenu(aO,aP,true)aQ.Name='AbuseComboBox'aQ.Position=UDim2.new(0.425
,0,0,142)aQ.Size=UDim2.new(0.55,0,0,32)aQ.Parent=U X.MouseButton1Click:connect(
a2)W.MouseButton1Click:connect(a3)aa:FindFirstChild'OkButton'.MouseButton1Down:
connect(a2)return ab:FindFirstChild'OkButton'.MouseButton1Down:connect(a2)end
local a7 a7=function(a8)if a8==game.Players.LocalPlayer then return Enum.
FriendStatus.NotFriend else local a9,ba=pcall(function()return game.Players.
LocalPlayer:GetFriendStatus(a8)end)if a9 then return ba else return Enum.
FriendStatus.NotFriend end end end local a8 a8=function()local a9=a7(aC)if a9==
Enum.FriendStatus.Friend then p:RevokeFriendship(aC)elseif a9==Enum.FriendStatus
.Unknown or a9==Enum.FriendStatus.NotFriend or a9==Enum.FriendStatus.
FriendRequestSent or a9==Enum.FriendStatus.FriendRequestReceived then p:
RequestFriendship(aC)end return a4()end local a9 a9=function()p:
RevokeFriendship(aC)a4()return J:TweenPosition(UDim2.new(1,0,0,0),'Out','Linear'
,c,true)end local ba ba=function(bb,bc)if bb['Score']==bc['Score']then return bb
['Player'].Name:upper()<bc['Player'].Name:upper()end if not bb['Score']then
return false end if not bc['Score']then return true end return bb['Score']<bc[
'Score']end local bb,bc bc=function()O.Value=true N.Value=false M.Value=true bb(
)O.Value=true return r:TweenPosition(UDim2.new(ax.X.Scale,ax.X.Offset-10,0,0),
'Out','Linear',c*1.2,true)end local bd bd=function()if O.Value then O.Value=
false return r:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',c*1.2,true)end
end local be be=function()return bc()end local bf bf=function(bg,bh)if bg.
IsPrimary~=bh.IsPrimary then return bg.IsPrimary end if bg.Priority==bh.Priority
then return bg.AddId<bh.AddId end return bg.Priority<bh.Priority end local bg,bh
bh=function(bi,bj)return bg()end local bj bj=function(bk)local bl=Q:
FindFirstChild'PlayerScore':Clone()bl.Name=bk bl.Text=bk if N.Value then bl.
TextTransparency=0 else bl.TextTransparency=1 end bl.Parent=L return bl end
local bk,bl bl=function(bm,bn)while aE do m'in stat added function lock'wait(
3.333333333333333E-2)end aE=true if not(bm:IsA'StringValue'or bm:IsA'IntValue'or
bm:IsA'BoolValue'or bm:IsA'NumberValue'or bm:IsA'DoubleConstrainedValue'or bm:
IsA'IntConstrainedValue')then be()else local bo=false for bp,bq in pairs(aj)do
if bq['Name']==bm.Name then bo=true end end if not bo then local br={}br['Name']
=bm.Name br['Priority']=0 if bm:FindFirstChild'Priority'then br['Priority']=bm.
Priority end br['IsPrimary']=false if bm:FindFirstChild'IsPrimary'then br[
'IsPrimary']=true end br.AddId=ak ak=ak+1 table.insert(aj,br)table.sort(aj,bf)if
not L:FindFirstChild(br['Name'])then bj(br['Name'])end bk()end end aE=false bh(
bn)return bm.Changed:connect(function(bo)return bh(bn,bo)end)end local bm bm=
function(bn,bo)for bp,bq in pairs(al)do if bq['Player']~=bo and bq['Player']:
FindFirstChild(bq['Player'].leaderstats:FindFirstChild(bn))then return true end
end return false end local bn bn=function(bo,bp)while aE do m
'In Adding Stat Lock1'wait(3.333333333333333E-2)end aE=true if bp['Frame']:
FindFirstChild(bo.Name)then m'Destroyed frame!'bp['Frame'][bo.Name].Parent=nil
end if not bm(bo.Name,bp['Player'])then for bq,br in ipairs(aj)do if br['Name']
==bo.Name then table.remove(aj,bq)if L:FindFirstChild(bo.Name)then L[bo.Name]:
Destroy()end for bs,bt in pairs(am)do if bt['Frame']:FindFirstChild(bo.Name)then
bt['Frame'][bo.Name]:Destroy()end end end end end aE=false return bh(bp)end
local bo bo=function(bp)for bq,br in ipairs(aj)do bn(br,bp)end end local bp bp=
function(bq)if bq:IsA'DoubleConstrainedValue'or bq:IsA'IntConstrainedValue'then
return bq.ConstrainedValue elseif bq:IsA'BoolValue'then if bq.Value then return
1 else return 0 end else return bq.Value end end local bq bq=function(br,bs,bt)
if not bt:FindFirstChild'PlayerScore'then return end local bu,bv=bt:
FindFirstChild'PlayerScore':Clone(),nil wait()if br['Player']:FindFirstChild
'leaderstats'and br['Player'].leaderstats:FindFirstChild(bs['Name'])then bv=br[
'Player']:FindFirstChild'leaderstats':FindFirstChild(bs['Name'])else return end
if not br['Player'].Parent then return end bu.Name=bs['Name']bu.Text=tostring(
bp(bv))if bs['Name']==aj[1]['Name']then m'changing score'br['Score']=bp(bv)if br
['Player']==p then y.Text=tostring(bp(bv))end end bv.Changed:connect(function()
if not bv.Parent then return end if bs['Name']==aj[1]['Name']then br['Score']=
bp(bv)if br['Player']==p then y.Text=tostring(bp(bv))end end bu.Text=tostring(
bp(bv))return bg()end)return bu end local br,bs={'Size8','Size9','Size10',
'Size11','Size12','Size14','Size24','Size36','Size48'},nil bs=function()local bt
=x:Clone()bt.Position=UDim2.new(2,0,2,0)bt.Parent=r local bu=7 bt.FontSize=br[bu
]return Delay(0.2,function()while bt.TextBounds.x==0 do wait(
3.333333333333333E-2)end while bt.TextBounds.x-ax.X.Offset>1 do bu=bu-1 bt.
FontSize=br[bu]wait(0.2)end x.FontSize=bt.FontSize return bt:Destroy()end)end
local bt bt=function(bu)while aE do m'In Adding Stat Lock2'wait(
3.333333333333333E-2)end aE=true local bv=5 local bw,bx=bv,0 for by=#aj,1,-1 do
local bz=aj[by]bx=0 for bA,bB in ipairs(bu)do local bC=bB['Frame']if not bC:
FindFirstChild(bz['Name'])then local bD=bq(bB,bz,bC)if bD then m('adding '..
tostring(bD.Name)..' to '..tostring(bB['Player'].Name))bD.Parent=bC if bB[
'MyTeam']and bB['MyTeam']~=an and not bB['MyTeam']['Frame']:FindFirstChild(bz[
'Name'])then local bE=bD:Clone()bE.Parent=bB['MyTeam']['Frame']end end end bz[
'XOffset']=bv if bC:FindFirstChild(bz['Name'])then bx=math.max(bx,bC[bz['Name']]
.TextBounds.X)end end if P.Value then bx=math.max(bx,L[bz['Name']].TextBounds.X)
L[bz['Name']]:TweenPosition(UDim2.new(az,-bv,0,0),'Out','Linear',c,true)else L[
bz['Name']]:TweenPosition(UDim2.new((0.4+((0.6/#aj)*(by-1)))-1,0,0,0),'Out',
'Linear',c,true)end bz['ColumnSize']=bx bv=bv+(au+bx)bw=math.max(bv,bw)end ax=
UDim2.new(0,at+bw-au,0,800)ay=UDim2.new(1,-ax.X.Offset,ay.Y.Scale,0)bs()bk()aE=
false end local bu bu=function()if#aj~=0 then for bv,bw in pairs(L:GetChildren()
)do Spawn(function()return aX(bw,'TextTransparency',bw.TextTransparency,0,c)end)
end v=0.09 u:TweenSizeAndPosition(UDim2.new(u.Size.X.Scale,u.Size.X.Offset,v,0),
u.Position,'Out','Linear',c*1.2,true)D:TweenPosition(UDim2.new(D.Position.X.
Scale,0,v,0),'Out','Linear',c*1.2,true)return z:TweenPosition(UDim2.new(0,0,v,0)
,'Out','Linear',c*1.2,true)end end local bv bv=function()if#aj~=0 then v=0.07 if
not N.Value then for bw,bx in pairs(L:GetChildren())do Spawn(function()return
aX(bx,'TextTransparency',bx.TextTransparency,1,c)end)end end z:TweenPosition(
UDim2.new(0,0,v,0),'Out','Linear',c*1.2,true)u:TweenSizeAndPosition(UDim2.new(u.
Size.X.Scale,u.Size.X.Offset,v,0),u.Position,'Out','Linear',c*1.2,true)return D:
TweenPosition(UDim2.new(D.Position.X.Scale,0,v,0),'Out','Linear',c*1.2,true)end
end local bw bw=function()if not P.Value or M.Value then return bv()else return
bu()end end local bx bx=function()M.Value=not M.Value return bw()end local by by
=function()N.Value=not N.Value return bt(al)end local bz bz=function()local bA,
bB=aV(),aU()local bC,bD=bB-bA,math.max(math.min(H.Position.Y.Scale,bB),bA)H.
Position=UDim2.new(H.Position.X.Scale,H.Position.X.Offset,bD,H.Position.Y.Offset
)local bE=1-G.Size.Y.Scale G.Position=UDim2.new(0,0,bE-(bE*((H.Position.Y.Scale-
bA)/bC)),0)end bb=function()if M.Value then if N.Value then by()end if not O.
Value then s:TweenSizeAndPosition(UDim2.new(0.01,x.TextBounds.X,ax.Y.Scale,ax.Y.
Offset),UDim2.new(0.99,-x.TextBounds.X,ay.Y.Scale,0),'Out','Linear',c*1.2,true)
else s:TweenSizeAndPosition(ax,ay,'Out','Linear',c*1.2,true)end E:TweenPosition(
UDim2.new(0,0,-1,0),'Out','Linear',c*1.2,true)A:TweenPosition(UDim2.new(0,0,0,0)
,'Out','Linear',c*1.2,true)t.Size=UDim2.new(1,0,v,0)C.Image=
'http://www.roblox.com/asset/?id=94692731'else if not N.Value then s:
TweenSizeAndPosition(ax,ay,'Out','Linear',c*1.2,true)end aA=math.min(math.max(aA
,-1),-1+#ap*R.Size.Y.Scale)bz()E.Position=UDim2.new(0,0,aA,0)local bA=aA+E.Size.
Y.Scale A.Position=UDim2.new(0,0,bA,0)t.Size=UDim2.new(1,0,bA+v,0)C.Image=
'http://www.roblox.com/asset/?id=94825585'end end bk=function()if N.Value then
for bA=1,#aj,1 do local bB=aj[bA]L[bB['Name']]:TweenPosition(UDim2.new(0.4+((0.6
/#aj)*(bA-1))-1,0,0,0),'Out','Linear',c,true)end if M.Value then bx()else bb()
end s:TweenSizeAndPosition(av,aw,'Out','Linear',c*1.2,true)y:TweenPosition(UDim2
.new(0,0,x.Position.Y.Scale,0),'Out','Linear',c*1.2,true)x:TweenPosition(UDim2.
new(-0.1,-y.TextBounds.x,x.Position.Y.Scale,0),'Out','Linear',c*1.2,true)u.
Background.Image='http://www.roblox.com/asset/?id='..b['LargeHeader']A.
Background.Image='http://www.roblox.com/asset/?id='..b['LargeBottom']for bA,bB
in ipairs(ap)do bB.Background.Image='http://www.roblox.com/asset/?id='..(
function()if bA%2~=1 then return b['LargeDark']else return b['LargeLight']end
end)()end for bC,bD in ipairs(ao)do if bD:FindFirstChild'ClickListener'then bD.
ClickListener.Size=UDim2.new(0.974,0,bD.ClickListener.Size.Y.Scale,0)end for bE=
1,#aj,1 do local bF=aj[bE]if bD:FindFirstChild(bF['Name'])then bD[bF['Name']]:
TweenPosition(UDim2.new(0.4+((0.6/#aj)*(bE-1))-1,0,0,0),'Out','Linear',c,true)
end end end for bE,bF in ipairs(al)do n(bF['Frame'],'TitleFrame').Size=UDim2.
new(0.38,0,bF['Frame'].TitleFrame.Size.Y.Scale,0)end for bG,bH in ipairs(am)do
n(bH['Frame'],'TitleFrame').Size=UDim2.new(0.38,0,bH['Frame'].TitleFrame.Size.Y.
Scale,0)end else if not M.Value then s:TweenSizeAndPosition(ax,ay,'Out','Linear'
,c*1.2,true)end y:TweenPosition(UDim2.new(0,0,0.4,0),'Out','Linear',c*1.2,true)x
:TweenPosition(UDim2.new(0,0,x.Position.Y.Scale,0),'Out','Linear',c*1.2,true)u.
Background.Image='http://www.roblox.com/asset/?id='..b['NormalHeader']A.
Background.Image='http://www.roblox.com/asset/?id='..b['NormalBottom']for bA,bD
in ipairs(ap)do bD.Background.Image='http://www.roblox.com/asset/?id='..(
function()if bA%2~=1 then return b['midDark']else return b['midLight']end end)()
end for bG,bH in ipairs(ao)do if bH:FindFirstChild'ClickListener'then bH.
ClickListener.Size=UDim2.new(0.96,0,bH.ClickListener.Size.Y.Scale,0)for bI=1,#aj
,1 do local bJ=aj[bI]if bH:FindFirstChild(bJ['Name'])and bJ['XOffset']then bH[bJ
['Name']]:TweenPosition(UDim2.new(az,-bJ['XOffset'],0,0),'Out','Linear',c,true)
end end end end for bI,bJ in ipairs(am)do n(bJ['Frame'],'TitleFrame').Size=UDim2
.new(0,at*0.9,bJ['Frame'].TitleFrame.Size.Y.Scale,0)end for bK,bL in ipairs(al)
do n(bL['Frame'],'TitleFrame').Size=UDim2.new(0,at*0.9,bL['Frame'].TitleFrame.
Size.Y.Scale,0)end end end local bA bA=function(bH)if not(O.Value or M.Value or
aH)then local bK=H.Position local bL=math.max(math.min(bK.Y.Scale+bH,aU()),aV())
H.Position=UDim2.new(bK.X.Scale,bK.X.Offset,bL,bK.Y.Offset)return bz()end end
local bH bH=function()if aK then return end aK={}table.insert(aK,q.WheelForward:
connect(function()return bA(0.05)end))return table.insert(aK,q.WheelBackward:
connect(function()return bA(-5E-2)end))end local bK bK=function()if aK then for
bL,bM in pairs(aK)do bM:disconnect()end end aK=nil end t.MouseEnter:connect(
function()if not(M.Value or O.Value)then return bH()end end)t.MouseLeave:
connect(function()return bK()end)local bL bL=function()local bM,bN=#ap*Q.Size.Y.
Scale,E.Position.Y.Scale+1 G.Size=UDim2.new(1,0,bN/bM,0)end local bM bM=function
(bN,bO)I.Parent=r if J~=nil then J:Destroy()end J=K:Clone()J.Parent=I local bP,
bQ=2,a7(bO)m(tostring(bQ))local bR,bS=aS and p.PersonalServerRank>=aR['Admin']
and p.PersonalServerRank>aC.PersonalServerRank,j(J,'Report Player',0)bS.
MouseButton1Click:connect(function()return a5()end)local bT=j(J,'Friend',1,not
bR and bQ~=Enum.FriendStatus.FriendRequestReceived)bT.MouseButton1Click:connect(
a8)if bQ==Enum.FriendStatus.Friend then bT:FindFirstChild'ButtonText'.Text=
'UnFriend Player'elseif bQ==Enum.FriendStatus.Unknown or bQ==Enum.FriendStatus.
NotFriend then bT:FindFirstChild'ButtonText'.Text='Send Request'elseif bQ==Enum.
FriendStatus.FriendRequestSent then bT:FindFirstChild'ButtonText'.Text=
'Revoke Request'elseif bQ==Enum.FriendStatus.FriendRequestReceived then bT:
FindFirstChild'ButtonText'.Text='Accept Friend'local bU=j(J,'Decline Friend',2,
not bR)bU.MouseButton1Click:connect(a9)bP=bP+1 end if bR then local bU,bV,bW,bX=
j(J,'Ban',bP),j(J,'Visitor',bP+1),j(J,'Member',bP+2),j(J,'Admin',bP+3,true)bU.
MouseButton1Click:connect(function()return a1(bO,aR['Banned'],bU,bV,bW,bX)end)bV
.MouseButton1Click:connect(function()return a1(bO,aR['Visitor'],bU,bV,bW,bX)end)
bW.MouseButton1Click:connect(function()return a1(bO,aR['Member'],bU,bV,bW,bX)end
)bX.MouseButton1Click:connect(function()return a1(bO,aR['Admin'],bU,bV,bW,bX)end
)a0(aC,bU,bV,bW,bX)end J:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',c,true)
Delay(0,function()local bU=q.Button1Down:connect(function()tconnection:
disconnect()return a4()end)end)local bU=bN['Frame']return Spawn(function()while
aH do I.Position=UDim2.new(0,bU.AbsolutePosition.X-I.Size.X.Offset,0,bU.
AbsolutePosition.Y)wait()end end)end local bN bN=function()if aT()then G.
BackgroundTransparency=1 else G.BackgroundTransparency=0 return bL()end end
local bO bO=function(bP)bP['Frame'].BackgroundColor3=Color3.new(0,1,1)Spawn(
function()return aX(bP['Frame'],'BackgroundTransparency',1,0.5,0.5)end)aH=true
return bM(bP,bP['Player'])end local bP bP=function(bQ,bR,bS)local bT=true n(bQ[
'Frame'],'ClickListener')local bU bU=function()if bQ['Player']and aC and bT and
bQ['Player']~=p and aC.userId>1 and p.userId>1 then return bO(bQ)end end local
bV,bW,bX=nil,H.Position,nil bX=function(bY,bZ)if not bV then bV=aW(bY,bZ).Y end
local b_=aW(bY,bZ).Y m('drag dist: '..tostring(Vector2.new(bR-bY,bS-bZ).
magnitude))if Vector2.new(bR-bY,bS-bZ).magnitude>d then bT=false end local b0=
math.max(math.min(bW.Y.Scale+(b_-bV),aU()),aV())H.Position=UDim2.new(bW.X.Scale,
bW.X.Offset,b0,bW.Y.Offset)return bz()end return aY(r,bX,bU)end local bQ bQ=
function()return Delay(0,function()local bR=tick()m'Got Click2'local bS bS=
function()if tick()-bR<0.25 then return bx()else aM=true if M.Value then return
bx()end end end local bT,bU,bV=nil,aA,nil bV=function(bW,bX)if not M.Value then
if not bT then bT=aW(bW,bX).Y end local bY=aW(bW,bX).Y local bZ=math.min(math.
max(bU+(bY-bT),-1),-1+#ap*R.Size.Y.Scale)aA=bZ bb()F.Size=UDim2.new(F.Size.X.
Scale,0,(aA+E.Size.Y.Scale),0)F.Position=UDim2.new(F.Position.X.Scale,0,1-F.Size
.Y.Scale,0)bL()bz()return bN()end end return Spawn(function()return aY(r,bV,bS)
end)end)end N.Value=false M.Value=false N.Changed:connect(bk)M.Changed:connect(
bb)B.MouseButton1Down:connect(function()if(time()-aq<ar)or aH then return end aq
=time()if O.Value then return bd()else return bQ()end end)w.MouseButton1Click:
connect(function()if(time()-aq<ar)or aH then return end aq=time()if O.Value then
return bd()elseif not P.Value then P.Value=true return bg()else return by()end
end)w.MouseButton2Click:connect(function()if(time()-aq<ar)or aH then return end
aq=time()if O.Value then return bd()elseif N.Value then return by()elseif P.
Value then P.Value=false return bg()else return bc()end end)local bR bR=function
()local bS=R:Clone()bS.Position=UDim2.new(0.5,0,(#ap*bS.Size.Y.Scale),0)bS.
Background.Image='http://www.roblox.com/asset/?id='..(function()if(#ap+1)%2~=1
then if N.Value then return b['LargeDark']else return b['midDark']end else if N.
Value then return b['LargeLight']else return b['midLight']end end end)()bS.
Parent=H table.insert(ap,bS)if#ap<aL and not aM then aA=-1+#ap*R.Size.Y.Scale
end if not M.Value then return bb()end end local bS bS=function()ap[#ap]:
Destroy()table.remove(ap,#ap)if not M.Value then return bb()end end local bT bT=
function(bU)x.Text=bU return bs()end r.Changed:connect(bs)local bU bU=function(
bV)local bW=bV['Player']for bX,bY in pairs(bW.leaderstats:GetChildren())do bl(bY
,bV)end bW.leaderstats.ChildAdded:connect(function(bZ)return bl(bZ,bV)end)return
bW.leaderstats.ChildRemoved:connect(function(bZ)return bn(bZ,bV)end)end local bV
bV=function(bW,bX)while aD do m('waiting to insert '..tostring(bX['Player'].Name
))wait(3.333333333333333E-2)end aD=true bo(bX)aD=false end local bW bW=function(
bX,bY,bZ)if not aH then aB=bX aC=bX['Player']return bP(bX,bY,bZ)end end local bX
bX=function()bt(al)table.sort(al,ba)for bY,bZ in ipairs(al)do ao[bY]=bZ['Frame']
end for b_=#al+1,#ao,1 do ao[b_]=nil end return bb()end local bY bY=function()
while aJ do m'in neutral team lock'wait()end aJ=true an['Frame']:Destroy()an=nil
bS()aJ=false end local bZ bZ=function(b_,b0)table.remove(b_['MyPlayers'],b0)if
b_==an and#b_['MyPlayers']==0 then return bY()end end local b_ b_=function(b0)if
b0['MyTeam']then for b1,b2 in ipairs(b0['MyTeam']['MyPlayers'])do if b2['Player'
]==b0['Player']then bZ(b0['MyTeam'],b1)return end end elseif an then for b1,b2
in ipairs(an['MyPlayers'])do if b2['Player']==b0['Player']then bZ(an,b1)return
end end end end local b0 b0=function(b1,b2)b_(b2)table.insert(b1['MyPlayers'],b2
)b2['MyTeam']=b1 if b1['IsHidden']then b1['Frame'].Parent=H bR()end b1[
'IsHidden']=false end local b1 b1=function()while aJ do m
'in neutral team 2 lock'wait()end aJ=true local b2=Instance.new'Team'b2.
TeamColor=BrickColor.new'White'b2.Name='Neutral'local b3={}b3['MyTeam']=b2 b3[
'MyPlayers']={}b3['Frame']=Q:Clone()n(n(b3['Frame'],'TitleFrame'),'Title').Text=
b2.Name b3['Frame'].TitleFrame.Position=UDim2.new(b3['Frame'].TitleFrame.
Position.X.Scale,b3['Frame'].TitleFrame.Position.X.Offset,0.1,0)b3['Frame'].
TitleFrame.Size=UDim2.new(b3['Frame'].TitleFrame.Size.X.Scale,b3['Frame'].
TitleFrame.Size.X.Offset,0.8,0)b3['Frame'].TitleFrame.Title.Font='ArialBold'b3[
'Frame'].Position=UDim2.new(1,0,(#ao*b3['Frame'].Size.Y.Scale),0)n(b3['Frame'],
'ClickListener').MouseButton1Down:connect(function(b4,b5)return bP(b3,b4,b5)end)
b3['Frame'].ClickListener.BackgroundColor3=Color3.new(1,1,1)b3['Frame'].
ClickListener.BackgroundTransparency=0.7 b3['Frame'].ClickListener.
AutoButtonColor=false b3['AutoHide']=true b3['IsHidden']=true for b4,b5 in
pairs(al)do if b5['Player'].Neutral or not b5['MyTeam']then b0(b3,b5)end end if#
b3['MyPlayers']>0 then an=b3 bb()bg()end aJ=false end local b2 b2=function(b3)
b_(b3)local b4=false for b5,b6 in ipairs(am)do if b6['MyTeam'].TeamColor==b3[
'Player'].TeamColor then b0(b6,b3)b4=true end end if not b4 and#(game.Teams:
GetTeams())>0 then m(tostring(b3['Player'].Name)..' could not find team')b3[
'MyTeam']=nil if not an then return b1()else return b0(an,b3)end end end local
b3 b3=function(b4,b5)while aI do m'in playerchanged lock'wait(
3.333333333333333E-2)end aI=true if b5=='Neutral'then if b4['Player'].Neutral
and#game.Teams:GetTeams()>0 then m(tostring(b4['Player'].Name)..
' setting to neutral')b_(b4)b4['MyTeam']=nil if not an then m(tostring(b4[
'Player'].Name)..' creating neutral team')b1()else m(tostring(b4['Player'].Name)
..' adding to neutral team')b0(an,b4)end elseif#(game.Teams:GetTeams())>0 then
m(tostring(b4['Player'].Name)..' has been set non-neutral')b2(b4)end bg()elseif
b5=='TeamColor'and not b4['Player'].Neutral and b4['Player']~=b4['MyTeam']then
m(tostring(b4['Player'].Name)..' setting to new team')b2(b4)bg()elseif b5==
'Name'or b5=='MembershipType'then b4['Frame']:FindFirstChild'BCLabel'.Image=h(b4
['Player'].MembershipType,b4['Player'].Name)b4['Frame'].Name=b4['Player'].Name
b4['Frame'].TitleFrame.Title.Text=b4['Player'].Name if b4['Frame'].BCLabel.Image
~=''then b4['Frame'].TitleFrame.Title.Position=UDim2.new(0.01,30,0.1,0)end if b4
['Player']==p then b4['Frame'].TitleFrame.DropShadow.Text=b4['Player'].Name bT(
b4['Player'].Name)end bg()end aI=false end local b4 b4=function(b5)while aD do
m('waiting to insert '..tostring(b5.Name))wait(3.333333333333333E-2)end aD=true
local b6=Q:Clone()n(n(b6,'TitleFrame'),'Title').Text=b5.Name b6.Position=UDim2.
new(1,0,(#ao*b6.Size.Y.Scale),0)local b7=a7(b5)b6:FindFirstChild'BCLabel'.Image=
h(b5.MembershipType,b5.Name)b6:FindFirstChild'FriendLabel'.Image=i(b7)b6.Name=b5
.Name n(n(b6,'TitleFrame'),'Title').Text=b5.Name b6.FriendLabel.Position=b6.
FriendLabel.Position+UDim2.new(0,17,0,0)b6.TitleFrame.Title.Position=b6.
TitleFrame.Title.Position+UDim2.new(0,17,0,0)if b6:FindFirstChild'FriendLabel'.
Image~=''then b6.TitleFrame.Title.Position=b6.TitleFrame.Title.Position+UDim2.
new(0,17,0,0)end if b5.Name==p.Name then b6.TitleFrame.Title.Font='ArialBold'b6.
PlayerScore.Font='ArialBold'bT(b5.Name)do local b8=b6.TitleFrame.Title:Clone()b8
.TextColor3=Color3.new(0,0,0)b8.TextTransparency=0 b8.ZIndex=2 b8.Position=b6.
TitleFrame.Title.Position+UDim2.new(0,1,0,1)b8.Name='DropShadow'b8.Parent=b6.
TitleFrame end end b6.TitleFrame.Title.Font='ArialBold'b6.Parent=H b6:
TweenPosition(UDim2.new(0.5,0,(#ao*b6.Size.Y.Scale),0),'Out','Linear',c,true)bb(
)local b8={}b8['Frame']=b6 b8['Player']=b5 b8['ID']=ak ak=ak+1 table.insert(al,
b8)if#am~=0 then if b5.Neutral then b8['MyTeam']=nil if not an then b1()else b0(
an,b8)end else local b9=false for ca,cb in ipairs(am)do if cb['MyTeam'].
TeamColor==b5.TeamColor then b0(cb,b8)b8['MyTeam']=cb b9=true end end if not b9
then b8['MyTeam']=nil if not an then b1()else b0(an,b8)end b8['MyTeam']=an end
end end if b5:FindFirstChild'leaderstats'then bU(b8)end b5.ChildAdded:connect(
function(b9)if b9.Name=='leaderstats'then while aD do m
'in adding leaderstats lock'wait(3.333333333333333E-2)end aD=true bU(b8)aD=false
end end)b5.ChildRemoved:connect(function(b9)if b5==p and b9.Name=='leaderstats'
then return bV(b9,b8)end end)b5.Changed:connect(function(b9)return b3(b8,b9)end)
local b9=n(b6,'ClickListener')b9.Active=true b9.MouseButton1Down:connect(
function(ca,cb)return bW(b8,ca,cb)end)bR()bg()aD=false end local b5 b5=function(
b6)while aD do m'in removing player frame lock'wait(3.333333333333333E-2)end aD=
true local b7 for b8,b9 in ipairs(al)do if b6==b9['Player']then if I.Parent==b9[
'Frame']then I.Parent=nil end b9['Frame']:Destroy()b7=b9['MyTeam']table.remove(
al,b8)end end if b7 then for ca,cb in ipairs(b7['MyPlayers'])do if cb['Player']
==b6 then bZ(b7,ca)end end end bS()bb()bg()aD=false end o.ChildRemoved:connect(
b5)local b6 b6=function(b7,b8)local b9=0 if an and not an['IsHidden']then for ca
,cb in ipairs(an['MyPlayers'])do b9=b9+1 b8[b9]=cb['Frame']end b9=b9+1 b8[b9]=an
['Frame']end for ca,cb in ipairs(b7)do if not cb['IsHidden']then for cc,cd in
ipairs(cb.MyPlayers)do b9=b9+1 b8[b9]=cd['Frame']end b9=b9+1 b8[b9]=cb['Frame']
end end for cc=b9+1,#b8,1 do b8[cc]=nil end end local b7 b7=function(b8,b9)if b8
['TeamScore']==b9['TeamScore']then return b8['ID']<b9['ID']end if not b8[
'TeamScore']then return false end if not b9['TeamScore']then return true end
return b8['TeamScore']<b9['TeamScore']end local b8 b8=function(b9)for ca=1,#aj,1
do local cb,cc=aj[ca],0 for cd,ce in ipairs(b9['MyPlayers'])do local cf=ce[
'Player']:FindFirstChild(ce['Player'].leaderstats:FindFirstChild(cb['Name']))if
cf and not cf:IsA'StringValue'then cc=cc+bp((ce['Player'].leaderstats)[cb['Name'
]])end end if b9['Frame']:FindFirstChild(cb['Name'])then b9['Frame'][cb['Name']]
.Text=tostring(cc)end end return bb()end local b9 b9=function(ca)for cb,cc in
ipairs(ca)do table.sort(cc['MyPlayers'],ba)b8(cc)end return table.sort(ca,b7)end
local ca ca=function()bt(al)b9(am)if an then b8(an)end return b6(am,ao)end local
cb cb=function(cc,cd)return Delay(0.5,function()m('friend status changed for: '
..tostring(cc.Name)..' '..tostring(cd)..' vs '..tostring(a7(cc)))for ce,cf in
ipairs(al)do if cf['Player']==cc then local cg=i(cd)if cg==''and cf['Frame'].
FriendLabel.Image~=''then cf['Frame'].TitleFrame.Title.Position=cf['Frame'].
TitleFrame.Title.Position-UDim2.new(0,17,0,0)elseif cg~=''and cf['Frame'].
FriendLabel.Image==''then cf['Frame'].TitleFrame.Title.Position=cf['Frame'].
TitleFrame.Title.Position+UDim2.new(0,17,0,0)m('confirmed status: '..tostring(cc
.Name))end cf['Frame'].FriendLabel.Image=cg return end end end)end p.
FriendStatusChanged:connect(cb)local cc cc=function(cd,ce)n(cd['Frame'],
'PlayerScore').Text=tostring(ce)cd['TeamScore']=ce end local cd cd=function(ce,
cf)if cf.Name=='AutoHide'then ce['AutoHide']=true elseif cf.Name=='TeamScore'
then n(ce['Frame'],'PlayerScore').Text=tostring(cf.Value)ce['TeamScore']=cf.
Value return cf.Changed:connect(function()return cc(ce,cf.Value)end)end end
local ce ce=function(cf,cg)if cg.Name=='AutoHide'then cf['AutoHide']=false
elseif cg.Name=='TeamScore'then n(cf['Frame'],'PlayerScore').Text=''cf[
'TeamScore']=nil end end local cf cf=function(cg)while aD do m
'in removing team frame lock'wait(3.333333333333333E-2)end aD=true local ch for
ci,cj in ipairs(am)do if cg==cj['MyTeam']then ch=cj cj['Frame']:Destroy()table.
remove(am,ci)end end if#am==0 then m'removeteamframe, remove neutral'if an then
bY()end end for ck,cl in ipairs(ch['MyPlayers'])do bZ(ch,ck)b3(cl,'TeamColor')
end bS()bg()aD=false end local cg cg=function(ch,ck)if ck=='Name'then n(n(ch[
'Frame'],'TitleFrame'),'Title').Text=ch['MyTeam'].Name elseif ck=='TeamColor'
then ch['Frame'].ClickListener.BackgroundColor3=ch['MyTeam'].TeamColor.Color for
cl,cm in pairs(am)do if cm['MyTeam'].TeamColor==ch['MyTeam']then cf(ch['MyTeam']
)end end ch['MyPlayers']={}for cn,co in pairs(al)do b2(co)end return bg()end end
local ch ch=function(ck)while aD do m'in adding team frame lock'wait(
3.333333333333333E-2)end aD=true local cn={}cn['MyTeam']=ck cn['MyPlayers']={}cn
['Frame']=Q:Clone()n(n(cn['Frame'],'TitleFrame'),'Title').Text=ck.Name cn[
'Frame'].TitleFrame.Title.Font='ArialBold'cn['Frame'].TitleFrame.Title.FontSize=
'Size18'cn['Frame'].TitleFrame.Position=UDim2.new(cn['Frame'].TitleFrame.
Position.X.Scale,cn['Frame'].TitleFrame.Position.X.Offset,0.1,0)cn['Frame'].
TitleFrame.Size=UDim2.new(cn['Frame'].TitleFrame.Size.X.Scale,cn['Frame'].
TitleFrame.Size.X.Offset,0.8,0)cn['Frame'].Position=UDim2.new(1,0,(#ao*cn[
'Frame'].Size.Y.Scale),0)n(cn['Frame'],'ClickListener').MouseButton1Down:
connect(function(co,cp)return bP(cn,co,cp)end)cn['Frame'].ClickListener.
BackgroundColor3=ck.TeamColor.Color cn['Frame'].ClickListener.
BackgroundTransparency=0.7 cn['Frame'].ClickListener.AutoButtonColor=false ak=ak
+1 cn['ID']=ak cn['AutoHide']=false if ck:FindFirstChild'AutoHide'then cn[
'AutoHide']=true end if ck:FindFirstChild'TeamScore'then cd(cn,ck.TeamScore)end
ck.ChildAdded:connect(function(co)return cd(cn,co)end)ck.ChildRemoved:connect(
function(co)return ce(cn,co)end)ck.Changed:connect(function(co)return cg(cn,co)
end)for co,cp in pairs(al)do if not cp['Player'].Neutral and cp['Player'].
TeamColor==ck.TeamColor then b0(cn,cp)end end cn['IsHidden']=false if not cn[
'AutoHide']or#cn['MyPlayers']>0 then cn['Frame'].Parent=H cn['Frame']:
TweenPosition(UDim2.new(0.5,0,(#ao*cn['Frame'].Size.Y.Scale),0),'Out','Linear',c
,true)bR()else cn['IsHidden']=true cn['Frame'].Parent=nil end table.insert(am,cn
)bb()bg()if#am==1 and not an then b1()end aD=false end local ck ck=function(cn)
return ch(cn)end local cn cn=function(co)return cf(co)end bg=function()while aF
do m'in baseupdate lock'wait(3.333333333333333E-2)end aF=true bw()if#am==0 and
not an then bX()else ca()end for co,cp in ipairs(ao)do if not(cp.Parent~=nil)
then cp:TweenPosition(UDim2.new(0.5,0,((#ao-co)*cp.Size.Y.Scale),0),'Out',
'Linear',c,true)end end if not M.Value and#ao>ag then bz()end bb()bL()bz()bN()aF
=false end game.GuiService:AddKey'\t'local co=time()game.GuiService.KeyPressed:
connect(function(cp)if cp=='\t'then m'caught tab key'local cq,cr cq,cr=pcall(
function()return game.GuiService.IsModalDialog end)if cq==false or(cq and cr==
false)then if time()-co>0.4 then co=time()if O.Value then if not N.Value then r:
TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',c*1.2,true)N.Value=true else r:
TweenPosition(UDim2.new(ax.X.Scale,ax.X.Offset-10,0,0),'Out','Linear',c*1.2,true
)N.Value=false M.Value=true end else return by()end end end end end)local cp cp=
function(cq)return b4(cq)end local cq cq=function(cr)if cr:IsA'Player'then
return Spawn(function()return cp(cr)end)else return be()end end local cr cr=
function(cs,ct)if cs==Enum.CoreGuiType.All or cs==Enum.CoreGuiType.PlayerList
then s.Visible=ct end end local cs cs=function(ct)if ct:IsA'Team'then return ck(
ct)else return be()end end local ct ct=function(cu)if cu:IsA'Team'then return
cn(cu)else return be()end end pcall(function()cr(Enum.CoreGuiType.PlayerList,
Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList))return Game.
StarterGui.CoreGuiChangedSignal:connect(cr)end)while not game:GetService'Teams'
do wait(3.333333333333333E-2)m'Waiting For Teams'end for cu,cv in pairs(game.
Teams:GetTeams())do ck(cv)end for cw,cx in pairs(o:GetPlayers())do Spawn(
function()return cp(cx)end)end game.Teams.ChildAdded:connect(cs)game.Teams.
ChildRemoved:connect(ct)o.ChildAdded:connect(cq)a6()P.Value=true bg()wait(2)aS=
not not game.Workspace:FindFirstChild'PSVariable'if p.Name=='newplayerlistisbad'
or p.Name=='imtotallyadmin'then ad.Parent=r return Spawn(function()while true do
local cy cy=''for cz,cA in pairs(game.Players:GetPlayers())do cy=cy..' '..
tostring(cA.Name)end ae.Text=cy wait(0.5)end end)end