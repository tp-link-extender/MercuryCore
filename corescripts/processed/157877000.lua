local a,b=assert(LoadLibrary'RbxUtility').Create,nil if script.Parent:
FindFirstChild'ControlFrame'then b=script.Parent:FindFirstChild'ControlFrame'
else b=script.Parent end local c,d,e=a'Frame'{Name='DevConsoleContainer',Parent=
b,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.9,Position=UDim2.
new(0,100,0,10),Size=UDim2.new(0.5,20,0.5,20),Visible=false},a'BindableFunction'
{Name='ToggleDevConsole',Parent=b},false function initializeDeveloperConsole()if
e then return end e=true local f,g,h,i=1,2,1000,Vector2.new(245,180)local j,k,l,
m,n,o,p,q,r,s,t,u,v=f,{},{},0,0,true,true,true,true,false,0,0,a'Frame'{Name=
'Body',Parent=c,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,
Position=UDim2.new(0,0,0,21),Size=UDim2.new(1,0,1,-25)}local w=a'Frame'{Name=
'OptionsHolder',Parent=v,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,Position=UDim2.new(0,220,0,0),Size=UDim2.new(1,-255,0,
24),ClipsDescendants=true}local x=a'Frame'{Name='OptionsBar',Parent=w,
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=UDim2.new(0
,-250,0,4),Size=UDim2.new(0,234,0,18)}local y=a'TextButton'{Name=
'ErrorToggleButton',Parent=x,BackgroundColor3=Color3.new(0,0,0),BorderColor3=
Color3.new(1,0,0),Position=UDim2.new(0,115,0,0),Size=UDim2.new(0,18,0,18),Font=
'SourceSansBold',FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.new(1,0
,0)}a'Frame'{Name='CheckFrame',Parent=y,BackgroundColor3=Color3.new(1,0,0),
BorderColor3=Color3.new(1,0,0),Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0
,10)}local z=a'TextButton'{Name='InfoToggleButton',Parent=x,BackgroundColor3=
Color3.new(0,0,0),BorderColor3=Color3.new(0.4,0.5,1),Position=UDim2.new(0,65,0,0
),Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=Enum.FontSize.Size14,
Text='',TextColor3=Color3.new(0.4,0.5,1)}a'Frame'{Name='CheckFrame',Parent=z,
BackgroundColor3=Color3.new(0.4,0.5,1),BorderColor3=Color3.new(0.4,0.5,1),
Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0,10)}local A=a'TextButton'{Name
='OutputToggleButton',Parent=x,BackgroundColor3=Color3.new(0,0,0),BorderColor3=
Color3.new(1,1,1),Position=UDim2.new(0,40,0,0),Size=UDim2.new(0,18,0,18),Font=
'SourceSansBold',FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.new(1,1
,1)}a'Frame'{Name='CheckFrame',Parent=A,BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(1,1,1),Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0
,10)}local B=a'TextButton'{Name='WarningToggleButton',Parent=x,BackgroundColor3=
Color3.new(0,0,0),BorderColor3=Color3.new(1,0.6,0.4),Position=UDim2.new(0,90,0,0
),Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=Enum.FontSize.Size14,
Text='',TextColor3=Color3.new(1,0.6,0.4)}a'Frame'{Name='CheckFrame',Parent=B,
BackgroundColor3=Color3.new(1,0.6,0.4),BorderColor3=Color3.new(1,0.6,0.4),
Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0,10)}local C=a'TextButton'{Name
='WordWrapToggleButton',Parent=x,BackgroundColor3=Color3.new(0,0,0),BorderColor3
=Color3.new(0.8,0.8,0.8),Position=UDim2.new(0,215,0,0),Size=UDim2.new(0,18,0,18)
,Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.
new(0.8,0.8,0.8)}a'Frame'{Name='CheckFrame',Parent=C,BackgroundColor3=Color3.
new(0.8,0.8,0.8),BorderColor3=Color3.new(0.8,0.8,0.8),Position=UDim2.new(0,4,0,4
),Size=UDim2.new(0,10,0,10),Visible=false}a'TextLabel'{Name='Filter',Parent=x,
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,40,0,18),
Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='Filter',TextColor3=
Color3.new(1,1,1)}a'TextLabel'{Name='WordWrap',Parent=x,BackgroundTransparency=1
,Position=UDim2.new(0,150,0,0),Size=UDim2.new(0,50,0,18),Font='SourceSansBold',
FontSize=Enum.FontSize.Size14,Text='Word Wrap',TextColor3=Color3.new(1,1,1)}
local D=a'Frame'{Name='ScrollBar',Parent=v,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.9,Position=UDim2.new(1,-20,0,26),Size=UDim2.new(0,20,1,
-50),Visible=false}local E=a'Frame'{Name='ScrollArea',Parent=D,
BackgroundTransparency=1,Position=UDim2.new(0,0,0,23),Size=UDim2.new(1,0,1,-46)}
local F=a'ImageButton'{Name='Handle',Parent=E,BackgroundColor3=Color3.new(0,0,0)
,BackgroundTransparency=0.5,Position=UDim2.new(0,0,0.2,0),Size=UDim2.new(0,20,0,
40)}a'ImageLabel'{Name='ImageLabel',Parent=F,BackgroundTransparency=1,Position=
UDim2.new(0,0,0.5,-8),Rotation=180,Size=UDim2.new(1,0,0,16),Image=
'http://www.roblox.com/Asset?id=151205881'}local G=a'ImageButton'{Name='Down',
Parent=D,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=
UDim2.new(0,0,1,-20),Size=UDim2.new(0,20,0,20)}a'ImageLabel'{Name='ImageLabel',
Parent=G,BackgroundTransparency=1,Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,
14,0,14),Rotation=180,Image='http://www.roblox.com/Asset?id=151205813'}local H=a
'ImageButton'{Name='Up',Parent=D,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.5,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,20,0,20)
}a'ImageLabel'{Name='ImageLabel',Parent=H,BackgroundTransparency=1,Position=
UDim2.new(0,3,0,3),Size=UDim2.new(0,14,0,14),Image=
'http://www.roblox.com/Asset?id=151205813'}local I=a'Frame'{Name='TextBox',
Parent=v,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.6,Position=
UDim2.new(0,2,0,26),Size=UDim2.new(1,-4,1,-28),ClipsDescendants=true}local J,K=a
'Frame'{Name='TextHolder',Parent=I,BackgroundTransparency=1,Position=UDim2.new(0
,0,0,0),Size=UDim2.new(1,0,1,0)},a'ImageButton'{Name='OptionsButton',Parent=v,
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=UDim2.new(0
,200,0,2),Size=UDim2.new(0,20,0,20)}a'ImageLabel'{Name='ImageLabel',Parent=K,
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
Rotation=0,Image='http://www.roblox.com/Asset?id=152093917'}local L=a
'ImageButton'{Name='ResizeButton',Parent=v,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.5,Position=UDim2.new(1,-20,1,-20),Size=UDim2.new(0,20,0
,20)}a'ImageLabel'{Name='ImageLabel',Parent=L,BackgroundTransparency=1,Position=
UDim2.new(0,6,0,6),Size=UDim2.new(0.8,0,0.8,0),Rotation=135,Image=
'http://www.roblox.com/Asset?id=151205813'}a'TextButton'{Name='LocalConsole',
Parent=v,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.6,Position=
UDim2.new(0,7,0,5),Size=UDim2.new(0,90,0,20),Font='SourceSansBold',FontSize=Enum
.FontSize.Size14,Text='Local Console',TextColor3=Color3.new(1,1,1),
TextYAlignment=Enum.TextYAlignment.Center}a'TextButton'{Name='ServerConsole',
Parent=v,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.8,Position=
UDim2.new(0,102,0,5),Size=UDim2.new(0,90,0,17),Font='SourceSansBold',FontSize=
Enum.FontSize.Size14,Text='Server Console',TextColor3=Color3.new(1,1,1),
TextYAlignment=Enum.TextYAlignment.Center}local M=a'Frame'{Name='TitleBar',
Parent=c,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=
UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,20)}local N=a'ImageButton'{Name=
'CloseButton',Parent=M,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency
=0.5,Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20)}a'ImageLabel'{
Parent=N,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=
UDim2.new(0,3,0,3),Size=UDim2.new(0,14,0,14),Image=
'http://www.roblox.com/Asset?id=151205852'}a'TextButton'{Name='TextButton',
Parent=M,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=
UDim2.new(0,0,0,0),Size=UDim2.new(1,-23,1,0),Text=''}a'TextLabel'{Name=
'TitleText',Parent=M,BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=
UDim2.new(0,185,0,20),Font='SourceSansBold',FontSize=Enum.FontSize.Size18,Text=
'Server Console',TextColor3=Color3.new(1,1,1),Text='Roblox Developer Console',
TextYAlignment=Enum.TextYAlignment.Top}local O,P,Q,R,S,T,U,V=nil,nil,nil,nil,nil
,nil,false,false function clean()O=nil P=nil Q=nil R=nil S=nil pScrollHandle=nil
T=nil U=false V=false end function refreshConsolePosition(W,X)if not O then
return end local Y=Vector2.new(W,X)-O c.Position=UDim2.new(0,P.X+Y.X,0,P.Y+Y.Y)
end M.TextButton.MouseButton1Down:connect(function(W,X)O=Vector2.new(W,X)P=c.
AbsolutePosition end)M.TextButton.MouseButton1Up:connect(function(W,X)clean()end
)function refreshConsoleSize(X,Y)if not Q then return end local Z=Vector2.new(X,
Y)-Q c.Size=UDim2.new(0,math.max(R.X+Z.X,i.X),0,math.max(R.Y+Z.Y,i.Y))end c.Body
.ResizeButton.MouseButton1Down:connect(function(X,Y)Q=Vector2.new(X,Y)R=c.
AbsoluteSize end)c.Body.ResizeButton.MouseButton1Up:connect(function(X,Y)clean()
end)M.CloseButton.MouseButton1Down:connect(function(Y,Z)c.Visible=false end)c.
TitleBar.CloseButton.MouseButton1Up:connect(function()clean()end)local Z,_=true,
false function startAnimation()if _ then return end _=true repeat if Z then u=u-
1 else u=u+1 end local aa=u/5 local ab=aa*aa*(3-(2*aa))K.ImageLabel.Rotation=ab*
5*9 x.Position=UDim2.new(0,(ab*5*50)-250,0,4)wait()if(u<=0 and Z)or(u>=5 and not
Z)then _=false end until not _ end K.MouseButton1Down:connect(function(aa,ab)Z=
not Z startAnimation()end)function changeOffset(ab)if j==f then m=m+ab elseif j
==g then n=n+ab end repositionList()end function refreshTextHolderForReal()local
ab,ac=J:GetChildren(),nil if j==f then ac=k elseif j==g then ac=l end local ad=0
for ae=1,#ab do ab[ae].Visible=false end for ae=1,#ac do local af,ag=nil,false
if ae>#ab then af=a'TextLabel'{Name='Message',Parent=J,BackgroundTransparency=1,
TextXAlignment='Left',Size=UDim2.new(1,0,0,14),FontSize='Size10',ZIndex=1}ag=
true else af=ab[ae]end if(r or ac[ae].Type~=Enum.MessageType.MessageOutput)and(q
or ac[ae].Type~=Enum.MessageType.MessageInfo)and(p or ac[ae].Type~=Enum.
MessageType.MessageWarning)and(o or ac[ae].Type~=Enum.MessageType.MessageError)
then af.TextWrapped=s af.Size=UDim2.new(0.98,0,0,2000)af.Parent=c af.Text=ac[ae]
.Time..' -- '..ac[ae].Message af.Size=UDim2.new(0.98,0,0,af.TextBounds.Y)af.
Position=UDim2.new(0,5,0,ad)af.Parent=J ad=ad+af.TextBounds.Y if ag then if(j==f
and m>0)or(j==g and n>0)then changeOffset(af.TextBounds.Y)end end af.Visible=
true if ac[ae].Type==Enum.MessageType.MessageError then af.TextColor3=Color3.
new(1,0,0)elseif ac[ae].Type==Enum.MessageType.MessageInfo then af.TextColor3=
Color3.new(0.4,0.5,1)elseif ac[ae].Type==Enum.MessageType.MessageWarning then af
.TextColor3=Color3.new(1,0.6,0.4)else af.TextColor3=Color3.new(1,1,1)end end end
t=ad end local ab=false function refreshTextHolder()if ab then return end Delay(
0.1,function()ab=false refreshTextHolderForReal()end)ab=true end local ac=0
function holdingUpButton()if U then return end U=true wait(0.6)ac=ac+1 while U
and ac<2 do wait()changeOffset(12)end ac=ac-1 end function holdingDownButton()if
V then return end V=true wait(0.6)ac=ac+1 while V and ac<2 do wait()
changeOffset(-12)end ac=ac-1 end c.Body.ScrollBar.Up.MouseButton1Click:connect(
function()changeOffset(10)end)c.Body.ScrollBar.Up.MouseButton1Down:connect(
function()changeOffset(10)holdingUpButton()end)c.Body.ScrollBar.Up.
MouseButton1Up:connect(function()clean()end)c.Body.ScrollBar.Down.
MouseButton1Down:connect(function()changeOffset(-10)holdingDownButton()end)c.
Body.ScrollBar.Down.MouseButton1Up:connect(function()clean()end)function
handleScroll(ad,ae)if not S then return end local af,ag,ah=(Vector2.new(ad,ae)-S
).Y,1-(c.Body.TextBox.AbsoluteSize.Y/J.AbsoluteSize.Y),E.AbsoluteSize.Y-E.Handle
.AbsoluteSize.Y local ai=math.max(math.min(af,ah),0-ah)local aj,ak=ai/ah,(ag*J.
AbsoluteSize.Y)local al=ak*aj if j==f then m=T-al elseif j==g then n=T-al end
end E.Handle.MouseButton1Down:connect(function(ad,ae)S=Vector2.new(ad,ae)
pScrollHandle=E.Handle.AbsolutePosition if j==f then T=m elseif j==g then T=n
end end)E.Handle.MouseButton1Up:connect(function(ad,ae)clean()end)local function
existsInsideContainer(ae,af,ag)local ah,ai=ae.AbsolutePosition,ae.AbsoluteSize
if af<ah.X or af>ah.X+ai.X or ag<ah.y or ag>ah.y+ai.y then return false end
return true end function repositionList()if j==f then m=math.min(math.max(m,0),t
-c.Body.TextBox.AbsoluteSize.Y)J.Size=UDim2.new(1,0,0,t)elseif j==g then n=math.
min(math.max(n,0),t-c.Body.TextBox.AbsoluteSize.Y)J.Size=UDim2.new(1,0,0,t)end
local ae=c.Body.TextBox.AbsoluteSize.Y/J.AbsoluteSize.Y if ae>=1 then c.Body.
ScrollBar.Visible=false c.Body.TextBox.Size=UDim2.new(1,-4,1,-28)if j==f or j==g
then J.Position=UDim2.new(0,0,1,0-t)end else c.Body.ScrollBar.Visible=true c.
Body.TextBox.Size=UDim2.new(1,-25,1,-28)local af,ag=1-ae,nil if j==f then ag=m/J
.AbsoluteSize.Y elseif j==g then ag=n/J.AbsoluteSize.Y end local ah,ai=math.max(
0,af-ag),math.max(E.AbsoluteSize.Y*ae,21)local aj=ai/E.AbsoluteSize.Y local ak=(
1-aj)/(1-ae)local al=ah*ak local am=math.min(E.AbsoluteSize.Y*al,E.AbsoluteSize.
Y-ai)E.Handle.Size=UDim2.new(1,0,0,ai)E.Handle.Position=UDim2.new(0,0,0,am)if j
==f then J.Position=UDim2.new(0,0,1,0-t+m)elseif j==g then J.Position=UDim2.new(
0,0,1,0-t+n)end end end local function numberWithZero(ae)return(ae<10 and'0'or''
)..ae end local ae='%s:%s:%s'function ConvertTimeStamp(af)local ag=af-os.time()+
math.floor(tick())local ah=ag%86400 local ai=math.floor(ah/3600)ah=ah-(ai*3600)
local aj=math.floor(ah/60)ah=ah-(aj*60)local ak,al,am=numberWithZero(ai),
numberWithZero(aj),numberWithZero(ah)return ae:format(ak,al,am)end x.
ErrorToggleButton.MouseButton1Down:connect(function(af,ag)o=not o x.
ErrorToggleButton.CheckFrame.Visible=o refreshTextHolder()repositionList()end)x.
WarningToggleButton.MouseButton1Down:connect(function(ag,ah)p=not p x.
WarningToggleButton.CheckFrame.Visible=p refreshTextHolder()repositionList()end)
x.InfoToggleButton.MouseButton1Down:connect(function(ah,ai)q=not q x.
InfoToggleButton.CheckFrame.Visible=q refreshTextHolder()repositionList()end)x.
OutputToggleButton.MouseButton1Down:connect(function(ai,aj)r=not r x.
OutputToggleButton.CheckFrame.Visible=r refreshTextHolder()repositionList()end)x
.WordWrapToggleButton.MouseButton1Down:connect(function(aj,ak)s=not s x.
WordWrapToggleButton.CheckFrame.Visible=s refreshTextHolder()repositionList()end
)function AddLocalMessage(ak,al,am)k[#k+1]={Message=ak,Time=ConvertTimeStamp(am)
,Type=al}while#k>h do table.remove(k,1)end refreshTextHolder()repositionList()
end function AddServerMessage(ak,al,am)l[#l+1]={Message=ak,Time=
ConvertTimeStamp(am),Type=al}while#l>h do table.remove(l,1)end
refreshTextHolder()repositionList()end c.Body.LocalConsole.MouseButton1Click:
connect(function(ak,al)if j==g then j=f local am,an=c.Body.LocalConsole,c.Body.
ServerConsole am.Size=UDim2.new(0,90,0,20)an.Size=UDim2.new(0,90,0,17)am.
BackgroundTransparency=0.6 an.BackgroundTransparency=0.8 if game:FindFirstChild
'Players'and game.Players['LocalPlayer']then local ao=game.Players.LocalPlayer:
GetMouse()refreshConsolePosition(ao.X,ao.Y)refreshConsoleSize(ao.X,ao.Y)
handleScroll(ao.X,ao.Y)end refreshTextHolder()repositionList()end end)c.Body.
LocalConsole.MouseButton1Up:connect(function()clean()end)local al=false c.Body.
ServerConsole.MouseButton1Click:connect(function(am,an)if not al then al=true
game:GetService'LogService':RequestServerOutput()end if j==f then j=g local ao,
ap=c.Body.LocalConsole,c.Body.ServerConsole ap.Size=UDim2.new(0,90,0,20)ao.Size=
UDim2.new(0,90,0,17)ap.BackgroundTransparency=0.6 ao.BackgroundTransparency=0.8
if game:FindFirstChild'Players'and game.Players['LocalPlayer']then local aq=game
.Players.LocalPlayer:GetMouse()refreshConsolePosition(aq.X,aq.Y)
refreshConsoleSize(aq.X,aq.Y)handleScroll(aq.X,aq.Y)end refreshTextHolder()
repositionList()end end)c.Body.ServerConsole.MouseButton1Up:connect(function()
clean()end)if game:FindFirstChild'Players'and game.Players['LocalPlayer']then
local an=game.Players.LocalPlayer:GetMouse()an.Move:connect(function()if not c.
Visible then return end local ao=game.Players.LocalPlayer:GetMouse()
refreshConsolePosition(ao.X,ao.Y)refreshConsoleSize(ao.X,ao.Y)handleScroll(ao.X,
ao.Y)refreshTextHolder()repositionList()end)an.Button1Up:connect(function()
clean()end)an.WheelForward:connect(function()if not c.Visible then return end if
existsInsideContainer(c,an.X,an.Y)then changeOffset(10)end end)an.WheelBackward:
connect(function()if not c.Visible then return end if existsInsideContainer(c,an
.X,an.Y)then changeOffset(-10)end end)end E.Handle.MouseButton1Down:connect(
function()repositionList()end)local an=game:GetService'LogService':
GetLogHistory()for ao=1,#an do AddLocalMessage(an[ao].message,an[ao].messageType
,an[ao].timestamp)end game:GetService'LogService'.MessageOut:connect(function(ao
,ap)AddLocalMessage(ao,ap,os.time())end)game:GetService'LogService'.
ServerMessageOut:connect(AddServerMessage)end local ab=false function d.OnInvoke
()if ab then return end ab=true initializeDeveloperConsole()c.Visible=not c.
Visible ab=false end