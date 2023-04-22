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
UDim2.new(0,185,0,20),Font='SourceSansBold',FontSize=Enum.FontSize.Size18,
TextColor3=Color3.new(1,1,1),Text='Roblox Developer Console',TextYAlignment=Enum
.TextYAlignment.Top}local O,P,Q,R,S,T,U,V,W=nil,nil,nil,nil,nil,nil,nil,false,
false function clean()O=nil P=nil Q=nil R=nil S=nil T=nil U=nil V=false W=false
end function refreshConsolePosition(X,Y)if not O then return end local Z=Vector2
.new(X,Y)-O c.Position=UDim2.new(0,P.X+Z.X,0,P.Y+Z.Y)end M.TextButton.
MouseButton1Down:connect(function(X,Y)O=Vector2.new(X,Y)P=c.AbsolutePosition end
)M.TextButton.MouseButton1Up:connect(function(X,Y)clean()end)function
refreshConsoleSize(Y,Z)if not Q then return end local _=Vector2.new(Y,Z)-Q c.
Size=UDim2.new(0,math.max(R.X+_.X,i.X),0,math.max(R.Y+_.Y,i.Y))end c.Body.
ResizeButton.MouseButton1Down:connect(function(Y,Z)Q=Vector2.new(Y,Z)R=c.
AbsoluteSize end)c.Body.ResizeButton.MouseButton1Up:connect(function(Y,Z)clean()
end)M.CloseButton.MouseButton1Down:connect(function(Z,_)c.Visible=false end)c.
TitleBar.CloseButton.MouseButton1Up:connect(function()clean()end)local _,aa=true
,false function startAnimation()if aa then return end aa=true repeat if _ then u
=u-1 else u=u+1 end local ab=u/5 local ac=ab*ab*(3-(2*ab))K.ImageLabel.Rotation=
ac*5*9 x.Position=UDim2.new(0,(ac*5*50)-250,0,4)wait()if(u<=0 and _)or(u>=5 and
not _)then aa=false end until not aa end K.MouseButton1Down:connect(function(ab,
ac)_=not _ startAnimation()end)function changeOffset(ac)if j==f then m=m+ac
elseif j==g then n=n+ac end repositionList()end function
refreshTextHolderForReal()local ac,ad=J:GetChildren(),nil if j==f then ad=k
elseif j==g then ad=l end local ae=0 for af=1,#ac do ac[af].Visible=false end
for af=1,#ad do local ag,ah=nil,false if af>#ac then ag=a'TextLabel'{Name=
'Message',Parent=J,BackgroundTransparency=1,TextXAlignment='Left',Size=UDim2.
new(1,0,0,14),FontSize='Size10',ZIndex=1}ah=true else ag=ac[af]end if(r or ad[af
].Type~=Enum.MessageType.MessageOutput)and(q or ad[af].Type~=Enum.MessageType.
MessageInfo)and(p or ad[af].Type~=Enum.MessageType.MessageWarning)and(o or ad[af
].Type~=Enum.MessageType.MessageError)then ag.TextWrapped=s ag.Size=UDim2.new(
0.98,0,0,2000)ag.Parent=c ag.Text=ad[af].Time..' -- '..ad[af].Message ag.Size=
UDim2.new(0.98,0,0,ag.TextBounds.Y)ag.Position=UDim2.new(0,5,0,ae)ag.Parent=J ae
=ae+ag.TextBounds.Y if ah then if(j==f and m>0)or(j==g and n>0)then
changeOffset(ag.TextBounds.Y)end end ag.Visible=true if ad[af].Type==Enum.
MessageType.MessageError then ag.TextColor3=Color3.new(1,0,0)elseif ad[af].Type
==Enum.MessageType.MessageInfo then ag.TextColor3=Color3.new(0.4,0.5,1)elseif ad
[af].Type==Enum.MessageType.MessageWarning then ag.TextColor3=Color3.new(1,0.6,
0.4)else ag.TextColor3=Color3.new(1,1,1)end end end t=ae end local ac=false
function refreshTextHolder()if ac then return end Delay(0.1,function()ac=false
refreshTextHolderForReal()end)ac=true end local ad=0 function holdingUpButton()
if V then return end V=true wait(0.6)ad=ad+1 while V and ad<2 do wait()
changeOffset(12)end ad=ad-1 end function holdingDownButton()if W then return end
W=true wait(0.6)ad=ad+1 while W and ad<2 do wait()changeOffset(-12)end ad=ad-1
end c.Body.ScrollBar.Up.MouseButton1Click:connect(function()changeOffset(10)end)
c.Body.ScrollBar.Up.MouseButton1Down:connect(function()changeOffset(10)
holdingUpButton()end)c.Body.ScrollBar.Up.MouseButton1Up:connect(function()clean(
)end)c.Body.ScrollBar.Down.MouseButton1Down:connect(function()changeOffset(-10)
holdingDownButton()end)c.Body.ScrollBar.Down.MouseButton1Up:connect(function()
clean()end)function handleScroll(ae,af)if not S then return end local ag,ah,ai=(
Vector2.new(ae,af)-S).Y,1-(c.Body.TextBox.AbsoluteSize.Y/J.AbsoluteSize.Y),E.
AbsoluteSize.Y-E.Handle.AbsoluteSize.Y local aj=math.max(math.min(ag,ai),0-ai)
local ak,al=aj/ai,(ah*J.AbsoluteSize.Y)local am=al*ak if j==f then m=U-am elseif
j==g then n=U-am end end E.Handle.MouseButton1Down:connect(function(ae,af)S=
Vector2.new(ae,af)T=E.Handle.AbsolutePosition if j==f then U=m elseif j==g then
U=n end end)E.Handle.MouseButton1Up:connect(function(ae,af)clean()end)
local function existsInsideContainer(af,ag,ah)local ai,aj=af.AbsolutePosition,af
.AbsoluteSize if ag<ai.X or ag>ai.X+aj.X or ah<ai.y or ah>ai.y+aj.y then return
false end return true end function repositionList()if j==f then m=math.min(math.
max(m,0),t-c.Body.TextBox.AbsoluteSize.Y)J.Size=UDim2.new(1,0,0,t)elseif j==g
then n=math.min(math.max(n,0),t-c.Body.TextBox.AbsoluteSize.Y)J.Size=UDim2.new(1
,0,0,t)end local af=c.Body.TextBox.AbsoluteSize.Y/J.AbsoluteSize.Y if af>=1 then
c.Body.ScrollBar.Visible=false c.Body.TextBox.Size=UDim2.new(1,-4,1,-28)if j==f
or j==g then J.Position=UDim2.new(0,0,1,0-t)end else c.Body.ScrollBar.Visible=
true c.Body.TextBox.Size=UDim2.new(1,-25,1,-28)local ag,ah=1-af,nil if j==f then
ah=m/J.AbsoluteSize.Y elseif j==g then ah=n/J.AbsoluteSize.Y end local ai,aj=
math.max(0,ag-ah),math.max(E.AbsoluteSize.Y*af,21)local ak=aj/E.AbsoluteSize.Y
local al=(1-ak)/(1-af)local am=ai*al local an=math.min(E.AbsoluteSize.Y*am,E.
AbsoluteSize.Y-aj)E.Handle.Size=UDim2.new(1,0,0,aj)E.Handle.Position=UDim2.new(0
,0,0,an)if j==f then J.Position=UDim2.new(0,0,1,0-t+m)elseif j==g then J.
Position=UDim2.new(0,0,1,0-t+n)end end end local function numberWithZero(af)
return(af<10 and'0'or'')..af end local af='%s:%s:%s'function ConvertTimeStamp(ag
)local ah=ag-os.time()+math.floor(tick())local ai=ah%86400 local aj=math.floor(
ai/3600)ai=ai-(aj*3600)local ak=math.floor(ai/60)ai=ai-(ak*60)local al,am,an=
numberWithZero(aj),numberWithZero(ak),numberWithZero(ai)return af:format(al,am,
an)end x.ErrorToggleButton.MouseButton1Down:connect(function(ag,ah)o=not o x.
ErrorToggleButton.CheckFrame.Visible=o refreshTextHolder()repositionList()end)x.
WarningToggleButton.MouseButton1Down:connect(function(ah,ai)p=not p x.
WarningToggleButton.CheckFrame.Visible=p refreshTextHolder()repositionList()end)
x.InfoToggleButton.MouseButton1Down:connect(function(ai,aj)q=not q x.
InfoToggleButton.CheckFrame.Visible=q refreshTextHolder()repositionList()end)x.
OutputToggleButton.MouseButton1Down:connect(function(aj,ak)r=not r x.
OutputToggleButton.CheckFrame.Visible=r refreshTextHolder()repositionList()end)x
.WordWrapToggleButton.MouseButton1Down:connect(function(ak,al)s=not s x.
WordWrapToggleButton.CheckFrame.Visible=s refreshTextHolder()repositionList()end
)function AddLocalMessage(al,am,an)k[#k+1]={Message=al,Time=ConvertTimeStamp(an)
,Type=am}while#k>h do table.remove(k,1)end refreshTextHolder()repositionList()
end function AddServerMessage(al,am,an)l[#l+1]={Message=al,Time=
ConvertTimeStamp(an),Type=am}while#l>h do table.remove(l,1)end
refreshTextHolder()repositionList()end c.Body.LocalConsole.MouseButton1Click:
connect(function(al,am)if j==g then j=f local an,ao=c.Body.LocalConsole,c.Body.
ServerConsole an.Size=UDim2.new(0,90,0,20)ao.Size=UDim2.new(0,90,0,17)an.
BackgroundTransparency=0.6 ao.BackgroundTransparency=0.8 if game:FindFirstChild
'Players'and game.Players['LocalPlayer']then local ap=game.Players.LocalPlayer:
GetMouse()refreshConsolePosition(ap.X,ap.Y)refreshConsoleSize(ap.X,ap.Y)
handleScroll(ap.X,ap.Y)end refreshTextHolder()repositionList()end end)c.Body.
LocalConsole.MouseButton1Up:connect(function()clean()end)local am=false c.Body.
ServerConsole.MouseButton1Click:connect(function(an,ao)if not am then am=true
game:GetService'LogService':RequestServerOutput()end if j==f then j=g local ap,
aq=c.Body.LocalConsole,c.Body.ServerConsole aq.Size=UDim2.new(0,90,0,20)ap.Size=
UDim2.new(0,90,0,17)aq.BackgroundTransparency=0.6 ap.BackgroundTransparency=0.8
if game:FindFirstChild'Players'and game.Players['LocalPlayer']then local ar=game
.Players.LocalPlayer:GetMouse()refreshConsolePosition(ar.X,ar.Y)
refreshConsoleSize(ar.X,ar.Y)handleScroll(ar.X,ar.Y)end refreshTextHolder()
repositionList()end end)c.Body.ServerConsole.MouseButton1Up:connect(function()
clean()end)if game:FindFirstChild'Players'and game.Players['LocalPlayer']then
local ao=game.Players.LocalPlayer:GetMouse()ao.Move:connect(function()if not c.
Visible then return end local ap=game.Players.LocalPlayer:GetMouse()
refreshConsolePosition(ap.X,ap.Y)refreshConsoleSize(ap.X,ap.Y)handleScroll(ap.X,
ap.Y)refreshTextHolder()repositionList()end)ao.Button1Up:connect(function()
clean()end)ao.WheelForward:connect(function()if not c.Visible then return end if
existsInsideContainer(c,ao.X,ao.Y)then changeOffset(10)end end)ao.WheelBackward:
connect(function()if not c.Visible then return end if existsInsideContainer(c,ao
.X,ao.Y)then changeOffset(-10)end end)end E.Handle.MouseButton1Down:connect(
function()repositionList()end)local ao=game:GetService'LogService':
GetLogHistory()for ap=1,#ao do AddLocalMessage(ao[ap].message,ao[ap].messageType
,ao[ap].timestamp)end game:GetService'LogService'.MessageOut:connect(function(ap
,aq)AddLocalMessage(ap,aq,os.time())end)game:GetService'LogService'.
ServerMessageOut:connect(AddServerMessage)end local aa=false function d.OnInvoke
()if aa then return end aa=true initializeDeveloperConsole()c.Visible=not c.
Visible aa=false end