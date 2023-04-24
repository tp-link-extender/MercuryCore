print'[Mercury]: Loaded corescript 157877000'local a,b=assert(LoadLibrary
'RbxUtility').Create,script.Parent:FindFirstChild'ControlFrame'or script.Parent
local c,d,e,f=a'Frame'{Name='DevConsoleContainer',Parent=b,BackgroundColor3=
Color3.new(0,0,0),BackgroundTransparency=0.9,Position=UDim2.new(0,100,0,10),Size
=UDim2.new(0.5,20,0.5,20),Visible=false},a'BindableFunction'{Name=
'ToggleDevConsole',Parent=b},false,nil f=function()if e then return end e=true
local g,h,i,j=1,2,1000,Vector2.new(245,180)local k,l,m,n,o,p,q,r,s,t,u,v,w=g,{},
{},0,0,true,true,true,true,false,0,0,a'Frame'{Name='Body',Parent=c,
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=UDim2.
new(0,0,0,21),Size=UDim2.new(1,0,1,-25)}local x=a'Frame'{Name='OptionsHolder',
Parent=w,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=
UDim2.new(0,220,0,0),Size=UDim2.new(1,-255,0,24),ClipsDescendants=true}local y=a
'Frame'{Name='OptionsBar',Parent=x,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,Position=UDim2.new(0,-250,0,4),Size=UDim2.new(0,234,0,
18)}local z=a'TextButton'{Name='ErrorToggleButton',Parent=y,BackgroundColor3=
Color3.new(0,0,0),BorderColor3=Color3.new(1,0,0),Position=UDim2.new(0,115,0,0),
Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=Enum.FontSize.Size14,
Text='',TextColor3=Color3.new(1,0,0)}a'Frame'{Name='CheckFrame',Parent=z,
BackgroundColor3=Color3.new(1,0,0),BorderColor3=Color3.new(1,0,0),Position=UDim2
.new(0,4,0,4),Size=UDim2.new(0,10,0,10)}local A=a'TextButton'{Name=
'InfoToggleButton',Parent=y,BackgroundColor3=Color3.new(0,0,0),BorderColor3=
Color3.new(0.4,0.5,1),Position=UDim2.new(0,65,0,0),Size=UDim2.new(0,18,0,18),
Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.
new(0.4,0.5,1)}a'Frame'{Name='CheckFrame',Parent=A,BackgroundColor3=Color3.new(
0.4,0.5,1),BorderColor3=Color3.new(0.4,0.5,1),Position=UDim2.new(0,4,0,4),Size=
UDim2.new(0,10,0,10)}local B=a'TextButton'{Name='OutputToggleButton',Parent=y,
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(1,1,1),Position=UDim2
.new(0,40,0,0),Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=Enum.
FontSize.Size14,Text='',TextColor3=Color3.new(1,1,1)}a'Frame'{Name='CheckFrame',
Parent=B,BackgroundColor3=Color3.new(1,1,1),BorderColor3=Color3.new(1,1,1),
Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0,10)}local C=a'TextButton'{Name
='WarningToggleButton',Parent=y,BackgroundColor3=Color3.new(0,0,0),BorderColor3=
Color3.new(1,0.6,0.4),Position=UDim2.new(0,90,0,0),Size=UDim2.new(0,18,0,18),
Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.
new(1,0.6,0.4)}a'Frame'{Name='CheckFrame',Parent=C,BackgroundColor3=Color3.new(1
,0.6,0.4),BorderColor3=Color3.new(1,0.6,0.4),Position=UDim2.new(0,4,0,4),Size=
UDim2.new(0,10,0,10)}local D=a'TextButton'{Name='WordWrapToggleButton',Parent=y,
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(0.8,0.8,0.8),Position
=UDim2.new(0,215,0,0),Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=
Enum.FontSize.Size14,Text='',TextColor3=Color3.new(0.8,0.8,0.8)}a'Frame'{Name=
'CheckFrame',Parent=D,BackgroundColor3=Color3.new(0.8,0.8,0.8),BorderColor3=
Color3.new(0.8,0.8,0.8),Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0,10),
Visible=false}a'TextLabel'{Name='Filter',Parent=y,BackgroundTransparency=1,
Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,40,0,18),Font='SourceSansBold',
FontSize=Enum.FontSize.Size14,Text='Filter',TextColor3=Color3.new(1,1,1)}a
'TextLabel'{Name='WordWrap',Parent=y,BackgroundTransparency=1,Position=UDim2.
new(0,150,0,0),Size=UDim2.new(0,50,0,18),Font='SourceSansBold',FontSize=Enum.
FontSize.Size14,Text='Word Wrap',TextColor3=Color3.new(1,1,1)}local E=a'Frame'{
Name='ScrollBar',Parent=w,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.9,Position=UDim2.new(1,-20,0,26),Size=UDim2.new(0,20,1,
-50),Visible=false}local F=a'Frame'{Name='ScrollArea',Parent=E,
BackgroundTransparency=1,Position=UDim2.new(0,0,0,23),Size=UDim2.new(1,0,1,-46)}
local G=a'ImageButton'{Name='Handle',Parent=F,BackgroundColor3=Color3.new(0,0,0)
,BackgroundTransparency=0.5,Position=UDim2.new(0,0,0.2,0),Size=UDim2.new(0,20,0,
40)}a'ImageLabel'{Name='ImageLabel',Parent=G,BackgroundTransparency=1,Position=
UDim2.new(0,0,0.5,-8),Rotation=180,Size=UDim2.new(1,0,0,16),Image=
'http://www.roblox.com/Asset?id=151205881'}local H=a'ImageButton'{Name='Down',
Parent=E,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=
UDim2.new(0,0,1,-20),Size=UDim2.new(0,20,0,20)}a'ImageLabel'{Name='ImageLabel',
Parent=H,BackgroundTransparency=1,Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,
14,0,14),Rotation=180,Image='http://www.roblox.com/Asset?id=151205813'}local I=a
'ImageButton'{Name='Up',Parent=E,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.5,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,20,0,20)
}a'ImageLabel'{Name='ImageLabel',Parent=I,BackgroundTransparency=1,Position=
UDim2.new(0,3,0,3),Size=UDim2.new(0,14,0,14),Image=
'http://www.roblox.com/Asset?id=151205813'}local J=a'Frame'{Name='TextBox',
Parent=w,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.6,Position=
UDim2.new(0,2,0,26),Size=UDim2.new(1,-4,1,-28),ClipsDescendants=true}local K,L=a
'Frame'{Name='TextHolder',Parent=J,BackgroundTransparency=1,Position=UDim2.new(0
,0,0,0),Size=UDim2.new(1,0,1,0)},a'ImageButton'{Name='OptionsButton',Parent=w,
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=UDim2.new(0
,200,0,2),Size=UDim2.new(0,20,0,20)}a'ImageLabel'{Name='ImageLabel',Parent=L,
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
Rotation=0,Image='http://www.roblox.com/Asset?id=152093917'}local M=a
'ImageButton'{Name='ResizeButton',Parent=w,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.5,Position=UDim2.new(1,-20,1,-20),Size=UDim2.new(0,20,0
,20)}a'ImageLabel'{Name='ImageLabel',Parent=M,BackgroundTransparency=1,Position=
UDim2.new(0,6,0,6),Size=UDim2.new(0.8,0,0.8,0),Rotation=135,Image=
'http://www.roblox.com/Asset?id=151205813'}a'TextButton'{Name='LocalConsole',
Parent=w,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.6,Position=
UDim2.new(0,7,0,5),Size=UDim2.new(0,90,0,20),Font='SourceSansBold',FontSize=Enum
.FontSize.Size14,Text='Local Console',TextColor3=Color3.new(1,1,1),
TextYAlignment=Enum.TextYAlignment.Center}a'TextButton'{Name='ServerConsole',
Parent=w,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.8,Position=
UDim2.new(0,102,0,5),Size=UDim2.new(0,90,0,17),Font='SourceSansBold',FontSize=
Enum.FontSize.Size14,Text='Server Console',TextColor3=Color3.new(1,1,1),
TextYAlignment=Enum.TextYAlignment.Center}local N=a'Frame'{Name='TitleBar',
Parent=c,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=
UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,20)}local O=a'ImageButton'{Name=
'CloseButton',Parent=N,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency
=0.5,Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20)}a'ImageLabel'{
Parent=O,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=
UDim2.new(0,3,0,3),Size=UDim2.new(0,14,0,14),Image=
'http://www.roblox.com/Asset?id=151205852'}a'TextButton'{Name='TextButton',
Parent=N,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=
UDim2.new(0,0,0,0),Size=UDim2.new(1,-23,1,0),Text=''}a'TextLabel'{Name=
'TitleText',Parent=N,BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=
UDim2.new(0,185,0,20),Font='SourceSansBold',FontSize=Enum.FontSize.Size18,
TextColor3=Color3.new(1,1,1),Text='Roblox Developer Console',TextYAlignment=Enum
.TextYAlignment.Top}local P,Q,R,S,T,U,V,W,X=nil,nil,nil,nil,nil,nil,false,false,
nil X=function()P=nil Q=nil R=nil S=nil T=nil U=nil V=false W=false end local Y
Y=function(Z,_)if not P then return end local aa=Vector2.new(Z,_-P)c.Position=
UDim2.new(0,Q.X+aa.X,0,Q.Y+aa.Y)end N.TextButton.MouseButton1Down:connect(
function(aa,Z)P=Vector2.new(aa,Z)Q=c.AbsolutePosition end)N.TextButton.
MouseButton1Up:connect(X)local aa aa=function(Z,_)if not R then return end local
ab=Vector2.new(Z,_-R)c.Size=UDim2.new(0,math.max(S.X+ab.X,j.X),0,math.max(S.Y+ab
.Y,j.Y))end c.Body.ResizeButton.MouseButton1Down:connect(function(ab,Z)R=Vector2
.new(ab,Z)S=c.AbsoluteSize end)c.Body.ResizeButton.MouseButton1Up:connect(X)N.
CloseButton.MouseButton1Down:connect(function()c.Visible=false end)c.TitleBar.
CloseButton.MouseButton1Up:connect(X)local ab,Z,_=true,false,nil _=function()if
Z then return end Z=true repeat v=v+(function()if ab then return-1 else return 1
end end)()local ac=v/5 local ad=ac*ac*(3-(2*ac))L.ImageLabel.Rotation=ad*5*9 y.
Position=UDim2.new(0,(ad*5*50)-250,0,4)wait()if(v<=0 and ab)or(v>=5 and not ab)
then Z=false end until not Z end L.MouseButton1Down:connect(function()ab=not ab
return _()end)local ac ac=function()if k==g then n=math.min(math.max(n,0),u-c.
Body.TextBox.AbsoluteSize.Y)K.Size=UDim2.new(1,0,0,u)elseif k==h then o=math.
min(math.max(o,0),u-c.Body.TextBox.AbsoluteSize.Y)K.Size=UDim2.new(1,0,0,u)end
local ad=c.Body.TextBox.AbsoluteSize.Y/K.AbsoluteSize.Y if ad>=1 then c.Body.
ScrollBar.Visible=false c.Body.TextBox.Size=UDim2.new(1,-4,1,-28)if k==g or k==h
then K.Position=UDim2.new(0,0,1,0-u)end else c.Body.ScrollBar.Visible=true c.
Body.TextBox.Size=UDim2.new(1,-25,1,-28)local ae,af=1-ad,nil if k==g then af=n/K
.AbsoluteSize.Y elseif k==h then af=o/K.AbsoluteSize.Y end local ag,ah=math.max(
0,ae-af),math.max(F.AbsoluteSize.Y*ad,21)local ai=ah/F.AbsoluteSize.Y local aj=(
1-ai)/(1-ad)local ak=ag*aj local al=math.min(F.AbsoluteSize.Y*ak,F.AbsoluteSize.
Y-ah)F.Handle.Size=UDim2.new(1,0,0,ah)F.Handle.Position=UDim2.new(0,0,0,al)K.
Position=UDim2.new(0,0,1,0-u+(function()if k==g then return n elseif k==h then
return o end end)())end end local ad ad=function(ae)if k==g then n=n+ae elseif k
==h then o=o+ae end return ac()end local ae ae=function()local af,ag=K:
GetChildren(),nil if k==g then ag=l elseif k==h then ag=m end local ah=0 for ai=
1,#af do af[ai].Visible=false end for ai=1,#ag do local aj,ak=nil,false if ai>#
af then aj=a'TextLabel'{Name='Message',Parent=K,BackgroundTransparency=1,
TextXAlignment='Left',Size=UDim2.new(1,0,0,14),FontSize='Size10',ZIndex=1}ak=
true else aj=af[ai]end if(s or ag[ai].Type~=Enum.MessageType.MessageOutput)and(r
or ag[ai].Type~=Enum.MessageType.MessageInfo)and(q or ag[ai].Type~=Enum.
MessageType.MessageWarning)and(p or ag[ai].Type~=Enum.MessageType.MessageError)
then do aj.TextWrapped=t aj.Size=UDim2.new(0.98,0,0,2000)aj.Parent=c aj.Text=
tostring(ag[ai].Time)..' -- '..tostring(ag[ai].Message)aj.Size=UDim2.new(0.98,0,
0,aj.TextBounds.Y)aj.Position=UDim2.new(0,5,0,ah)aj.Parent=K ah=ah+aj.TextBounds
.Y end if ak then if(k==g and n>0)or(k==h and o>0)then ad(aj.TextBounds.Y)end
end aj.Visible=true aj.TextColor3=Color3.new((function()if ag[ai].Type==Enum.
MessageType.MessageError then return 1,0,0 elseif ag[ai].Type==Enum.MessageType.
MessageInfo then return 0.4,0.5,1 elseif ag[ai].Type==Enum.MessageType.
MessageWarning then return 1,0.6,0.4 else return 1,1,1 end end)())end end u=ah
end local af,ag=false,nil ag=function()if af then return end Delay(0.1,function(
)af=false return ae()end)af=true end local ah,ai=0,nil ai=function()if V then
return end V=true wait(0.6)ah=ah+1 while V and ah<2 do wait()ad(12)end ah=ah-1
end local aj aj=function()if W then return end W=true wait(0.6)ah=ah+1 while W
and ah<2 do wait()ad(-12)end ah=ah-1 end c.Body.ScrollBar.Up.MouseButton1Click:
connect(function()return ad(10)end)c.Body.ScrollBar.Up.MouseButton1Down:connect(
function()ad(10)return ai()end)c.Body.ScrollBar.Up.MouseButton1Up:connect(X)c.
Body.ScrollBar.Down.MouseButton1Down:connect(function()ad(-10)return aj()end)c.
Body.ScrollBar.Down.MouseButton1Up:connect(X)local ak ak=function(al,am)if not T
then return end local an,ao,ap=(Vector2.new(al,am-T)).Y,1-(c.Body.TextBox.
AbsoluteSize.Y/K.AbsoluteSize.Y),F.AbsoluteSize.Y-F.Handle.AbsoluteSize.Y local
aq=math.max(math.min(an,ap),0-ap)local ar,as=aq/ap,(ao*K.AbsoluteSize.Y)local at
=as*ar if k==g then n=U-at elseif k==h then o=U-at end end F.Handle.
MouseButton1Down:connect(function(al,am)T=Vector2.new(al,am)if k==g then U=n
elseif k==h then U=o end end)F.Handle.MouseButton1Up:connect(X)local al al=
function(am,an,ao)local ap,aq=am.AbsolutePosition,am.AbsoluteSize if an<ap.X or
an>ap.X+aq.X or ao<ap.y or ao>ap.y+aq.y then return false end return true end
local am am=function(an)if an<10 then return'0'..tostring(an)else return an end
end local an,ao='%s:%s:%s',nil ao=function(ap)local aq=ap-os.time()+math.floor(
tick())local ar=aq%86400 local as=math.floor(ar/3600)ar=ar-(as*3600)local at=
math.floor(ar/60)ar=ar-(at*60)local au,av,aw=am(as),am(at),am(ar)return an:
format(au,av,aw)end y.ErrorToggleButton.MouseButton1Down:connect(function()p=not
p y.ErrorToggleButton.CheckFrame.Visible=p ag()return ac()end)y.
WarningToggleButton.MouseButton1Down:connect(function()q=not q y.
WarningToggleButton.CheckFrame.Visible=q ag()return ac()end)y.InfoToggleButton.
MouseButton1Down:connect(function()r=not r y.InfoToggleButton.CheckFrame.Visible
=r ag()return ac()end)y.OutputToggleButton.MouseButton1Down:connect(function()s=
not s y.OutputToggleButton.CheckFrame.Visible=s ag()return ac()end)y.
WordWrapToggleButton.MouseButton1Down:connect(function()t=not t y.
WordWrapToggleButton.CheckFrame.Visible=t ag()return ac()end)local ap ap=
function(aq,ar,as)l[#l+1]={Message=aq,Time=ao(as),Type=ar}while#l>i do table.
remove(l,1)end ag()return ac()end local aq aq=function(ar,as,at)m[#m+1]={Message
=ar,Time=ao(at),Type=as}while#m>i do table.remove(m,1)end ag()return ac()end c.
Body.LocalConsole.MouseButton1Click:connect(function()if k==h then k=g local ar,
as=c.Body.LocalConsole,c.Body.ServerConsole ar.Size=UDim2.new(0,90,0,20)as.Size=
UDim2.new(0,90,0,17)ar.BackgroundTransparency=0.6 as.BackgroundTransparency=0.8
if game:FindFirstChild'Players'and game.Players['LocalPlayer']then local at=game
.Players.LocalPlayer:GetMouse()Y(at.X,at.Y)aa(at.X,at.Y)ak(at.X,at.Y)end ag()
return ac()end end)c.Body.LocalConsole.MouseButton1Up:connect(X)local ar=false c
.Body.ServerConsole.MouseButton1Click:connect(function()if not ar then ar=true
game:GetService'LogService':RequestServerOutput()end if k==g then k=h local as,
at=c.Body.LocalConsole,c.Body.ServerConsole at.Size=UDim2.new(0,90,0,20)as.Size=
UDim2.new(0,90,0,17)at.BackgroundTransparency=0.6 as.BackgroundTransparency=0.8
if game:FindFirstChild'Players'and game.Players['LocalPlayer']then local au=game
.Players.LocalPlayer:GetMouse()Y(au.X,au.Y)aa(au.X,au.Y)ak(au.X,au.Y)end ag()
return ac()end end)c.Body.ServerConsole.MouseButton1Up:connect(X)if game:
FindFirstChild'Players'and game.Players['LocalPlayer']then local as=game.Players
.LocalPlayer:GetMouse()as.Move:connect(function()if not c.Visible then return
end local at=game.Players.LocalPlayer:GetMouse()Y(at.X,at.Y)aa(at.X,at.Y)ak(at.X
,at.Y)ag()return ac()end)as.Button1Up:connect(X)as.WheelForward:connect(function
()if not c.Visible then return end if al(c,as.X,as.Y)then return ad(10)end end)
as.WheelBackward:connect(function()if not c.Visible then return end if al(c,as.X
,as.Y)then return ad(-10)end end)end F.Handle.MouseButton1Down:connect(function(
)return ac()end)local as=game:GetService'LogService':GetLogHistory()for at=1,#as
do ap(as[at].message,as[at].messageType,as[at].timestamp)end local at=game:
GetService'LogService'at.MessageOut:connect(function(au,av)return ap(au,av,os.
time())end)at.ServerMessageOut:connect(aq)return at end local aa=false d.
OnInvoke=function()if aa then return end aa=true f()c.Visible=not c.Visible aa=
false end