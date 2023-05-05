print'[Mercury]: Loaded corescript 157877000'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b=script.Parent:FindFirstChild'ControlFrame'or
script.Parent local c,d,e,f=a('Frame','DevConsoleContainer',{Parent=b,
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.9,Position=UDim2.
new(0,100,0,10),Size=UDim2.new(0.5,20,0.5,20),Visible=false}),a(
'BindableFunction','ToggleDevConsole',{Parent=b}),false,nil f=function()if e
then return end e=true local g,h,i,j=1,2,1000,Vector2.new(245,180)local k,l,m,n,
o,p,q,r,s,t,u,v,w=g,{},{},0,0,true,true,true,true,false,0,0,a('Frame','Body',{
Parent=c,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=
UDim2.new(0,0,0,21),Size=UDim2.new(1,0,1,-25),a('ImageButton','ResizeButton',{
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=UDim2.
new(1,-20,1,-20),Size=UDim2.new(0,20,0,20),a('ImageLabel','ImageLabel',{
BackgroundTransparency=1,Position=UDim2.new(0,6,0,6),Size=UDim2.new(0.8,0,0.8,0)
,Rotation=135,Image='http://www.roblox.com/Asset?id=151205813'})}),a(
'TextButton','LocalConsole',{BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.6,Position=UDim2.new(0,7,0,5),Size=UDim2.new(0,90,0,20)
,Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='Local Console',
TextColor3=Color3.new(1,1,1),TextYAlignment=Enum.TextYAlignment.Center}),a(
'TextButton','ServerConsole',{BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.8,Position=UDim2.new(0,102,0,5),Size=UDim2.new(0,90,0,
17),Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='Server Console',
TextColor3=Color3.new(1,1,1),TextYAlignment=Enum.TextYAlignment.Center})})local
x=a('Frame','OptionsHolder',{Parent=w,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=1,Position=UDim2.new(0,220,0,0),Size=UDim2.new(1,-255,0,
24),ClipsDescendants=true})local y,z=a('Frame','OptionsBar',{Parent=x,
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=UDim2.new(0
,-250,0,4),Size=UDim2.new(0,234,0,18),a('TextButton','ErrorToggleButton',{
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(1,0,0),Position=UDim2
.new(0,115,0,0),Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=Enum.
FontSize.Size14,Text='',TextColor3=Color3.new(1,0,0),a('Frame','CheckFrame',{
BackgroundColor3=Color3.new(1,0,0),BorderColor3=Color3.new(1,0,0),Position=UDim2
.new(0,4,0,4),Size=UDim2.new(0,10,0,10)})}),a('TextButton','InfoToggleButton',{
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(0.4,0.5,1),Position=
UDim2.new(0,65,0,0),Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=
Enum.FontSize.Size14,Text='',TextColor3=Color3.new(0.4,0.5,1),a('Frame',
'CheckFrame',{BackgroundColor3=Color3.new(0.4,0.5,1),BorderColor3=Color3.new(0.4
,0.5,1),Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0,10)})}),a('TextButton'
,'OutputToggleButton',{BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.
new(1,1,1),Position=UDim2.new(0,40,0,0),Size=UDim2.new(0,18,0,18),Font=
'SourceSansBold',FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.new(1,1
,1),a('Frame','CheckFrame',{BackgroundColor3=Color3.new(1,1,1),BorderColor3=
Color3.new(1,1,1),Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0,10)})}),a(
'TextButton','WarningToggleButton',{BackgroundColor3=Color3.new(0,0,0),
BorderColor3=Color3.new(1,0.6,0.4),Position=UDim2.new(0,90,0,0),Size=UDim2.new(0
,18,0,18),Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='',TextColor3
=Color3.new(1,0.6,0.4),a('Frame','CheckFrame',{BackgroundColor3=Color3.new(1,0.6
,0.4),BorderColor3=Color3.new(1,0.6,0.4),Position=UDim2.new(0,4,0,4),Size=UDim2.
new(0,10,0,10)})}),a('TextButton','WordWrapToggleButton',{BackgroundColor3=
Color3.new(0,0,0),BorderColor3=Color3.new(0.8,0.8,0.8),Position=UDim2.new(0,215,
0,0),Size=UDim2.new(0,18,0,18),Font='SourceSansBold',FontSize=Enum.FontSize.
Size14,Text='',TextColor3=Color3.new(0.8,0.8,0.8),a('Frame','CheckFrame',{
BackgroundColor3=Color3.new(0.8,0.8,0.8),BorderColor3=Color3.new(0.8,0.8,0.8),
Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,10,0,10),Visible=false})}),a(
'TextLabel','Filter',{BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=
UDim2.new(0,40,0,18),Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text=
'Filter',TextColor3=Color3.new(1,1,1)}),a('TextLabel','WordWrap',{
BackgroundTransparency=1,Position=UDim2.new(0,150,0,0),Size=UDim2.new(0,50,0,18)
,Font='SourceSansBold',FontSize=Enum.FontSize.Size14,Text='Word Wrap',TextColor3
=Color3.new(1,1,1)})}),a('Frame','ScrollBar',{Parent=w,BackgroundColor3=Color3.
new(0,0,0),BackgroundTransparency=0.9,Position=UDim2.new(1,-20,0,26),Size=UDim2.
new(0,20,1,-50),Visible=false,a('ImageButton','Down',{BackgroundColor3=Color3.
new(0,0,0),BackgroundTransparency=0.5,Position=UDim2.new(0,0,1,-20),Size=UDim2.
new(0,20,0,20),a('ImageLabel','ImageLabel',{BackgroundTransparency=1,Position=
UDim2.new(0,3,0,3),Size=UDim2.new(0,14,0,14),Rotation=180,Image=
'http://www.roblox.com/Asset?id=151205813'})}),a('ImageButton','Up',{
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=UDim2.
new(0,0,0,0),Size=UDim2.new(0,20,0,20),a('ImageLabel','ImageLabel',{
BackgroundTransparency=1,Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,14,0,14),
Image='http://www.roblox.com/Asset?id=151205813'})})})local A,B=a('Frame',
'ScrollArea',{Parent=z,BackgroundTransparency=1,Position=UDim2.new(0,0,0,23),
Size=UDim2.new(1,0,1,-46),a('ImageButton','Handle',{BackgroundColor3=Color3.new(
0,0,0),BackgroundTransparency=0.5,Position=UDim2.new(0,0,0.2,0),Size=UDim2.new(0
,20,0,40),a('ImageLabel','ImageLabel',{BackgroundTransparency=1,Position=UDim2.
new(0,0,0.5,-8),Rotation=180,Size=UDim2.new(1,0,0,16),Image=
'http://www.roblox.com/Asset?id=151205881'})})}),a('Frame','TextBox',{Parent=w,
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.6,Position=UDim2.
new(0,2,0,26),Size=UDim2.new(1,-4,1,-28),ClipsDescendants=true})local C,D,E,F,G,
H,I,J,K,L,M,N=a('Frame','TextHolder',{Parent=B,BackgroundTransparency=1,Position
=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0)}),a('ImageButton','OptionsButton',{
Parent=w,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=
UDim2.new(0,200,0,2),Size=UDim2.new(0,20,0,20),a('ImageLabel','ImageLabel',{
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
Rotation=0,Image='http://www.roblox.com/Asset?id=152093917'})}),a('Frame',
'TitleBar',{Parent=c,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=
0.5,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,20),a('ImageButton',
'CloseButton',{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,
Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),a('ImageLabel',{
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Position=UDim2.new(0
,3,0,3),Size=UDim2.new(0,14,0,14),Image=
'http://www.roblox.com/Asset?id=151205852'})}),a('TextButton','TextButton',{
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,Position=UDim2.
new(0,0,0,0),Size=UDim2.new(1,-23,1,0),Text=''}),a('TextLabel','TitleText',{
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,185,0,20),
Font='SourceSansBold',FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1)
,Text='Roblox Developer Console',TextYAlignment=Enum.TextYAlignment.Top})}),nil,
nil,nil,nil,nil,nil,false,false,nil N=function()F=nil G=nil H=nil I=nil J=nil K=
nil L=false M=false end local O O=function(P,Q)if not F then return end local R=
Vector2.new(P,Q-F)c.Position=UDim2.new(0,G.X+R.X,0,G.Y+R.Y)end E.TextButton.
MouseButton1Down:connect(function(P,Q)F=Vector2.new(P,Q)G=c.AbsolutePosition end
)E.TextButton.MouseButton1Up:connect(N)local P P=function(Q,R)if not H then
return end local S=Vector2.new(Q,R-H)c.Size=UDim2.new(0,math.max(I.X+S.X,j.X),0,
math.max(I.Y+S.Y,j.Y))end c.Body.ResizeButton.MouseButton1Down:connect(function(
Q,R)H=Vector2.new(Q,R)I=c.AbsoluteSize end)c.Body.ResizeButton.MouseButton1Up:
connect(N)E.CloseButton.MouseButton1Down:connect(function()c.Visible=false end)c
.TitleBar.CloseButton.MouseButton1Up:connect(N)local Q,R,S=true,false,nil S=
function()if R then return end R=true repeat v=v+(function()if Q then return-1
else return 1 end end)()local T=v/5 local U=T*T*(3-(2*T))D.ImageLabel.Rotation=U
*5*9 y.Position=UDim2.new(0,(U*5*50)-250,0,4)wait()if(v<=0 and Q)or(v>=5 and not
Q)then R=false end until not R end D.MouseButton1Down:connect(function()Q=not Q
return S()end)local T T=function()if k==g then n=math.min(math.max(n,0),u-c.Body
.TextBox.AbsoluteSize.Y)C.Size=UDim2.new(1,0,0,u)elseif k==h then o=math.min(
math.max(o,0),u-c.Body.TextBox.AbsoluteSize.Y)C.Size=UDim2.new(1,0,0,u)end local
U=c.Body.TextBox.AbsoluteSize.Y/C.AbsoluteSize.Y if U>=1 then c.Body.ScrollBar.
Visible=false c.Body.TextBox.Size=UDim2.new(1,-4,1,-28)if k==g or k==h then C.
Position=UDim2.new(0,0,1,0-u)end else c.Body.ScrollBar.Visible=true c.Body.
TextBox.Size=UDim2.new(1,-25,1,-28)local V,W=1-U,nil if k==g then W=n/C.
AbsoluteSize.Y elseif k==h then W=o/C.AbsoluteSize.Y end local X,Y=math.max(0,V-
W),math.max(A.AbsoluteSize.Y*U,21)local Z=Y/A.AbsoluteSize.Y local _=(1-Z)/(1-U)
local aa=X*_ local ab=math.min(A.AbsoluteSize.Y*aa,A.AbsoluteSize.Y-Y)A.Handle.
Size=UDim2.new(1,0,0,Y)A.Handle.Position=UDim2.new(0,0,0,ab)C.Position=UDim2.
new(0,0,1,0-u+(function()if k==g then return n elseif k==h then return o end end
)())end end local aa aa=function(ab)if k==g then n=n+ab elseif k==h then o=o+ab
end return T()end local ab ab=function()local U,V=C:GetChildren(),nil if k==g
then V=l elseif k==h then V=m end local W=0 for X=1,#U do U[X].Visible=false end
for X=1,#V do local Y,Z=nil,false if X>#U then Y=a('TextLabel','Message',{Parent
=C,BackgroundTransparency=1,TextXAlignment='Left',Size=UDim2.new(1,0,0,14),
FontSize='Size10',ZIndex=1})Z=true else Y=U[X]end if(s or V[X].Type~=Enum.
MessageType.MessageOutput)and(r or V[X].Type~=Enum.MessageType.MessageInfo)and(q
or V[X].Type~=Enum.MessageType.MessageWarning)and(p or V[X].Type~=Enum.
MessageType.MessageError)then do Y.TextWrapped=t Y.Size=UDim2.new(0.98,0,0,2000)
Y.Parent=c Y.Text=tostring(V[X].Time)..' -- '..tostring(V[X].Message)Y.Size=
UDim2.new(0.98,0,0,Y.TextBounds.Y)Y.Position=UDim2.new(0,5,0,W)Y.Parent=C W=W+Y.
TextBounds.Y end if Z then if(k==g and n>0)or(k==h and o>0)then aa(Y.TextBounds.
Y)end end Y.Visible=true Y.TextColor3=Color3.new((function()if V[X].Type==Enum.
MessageType.MessageError then return 1,0,0 elseif V[X].Type==Enum.MessageType.
MessageInfo then return 0.4,0.5,1 elseif V[X].Type==Enum.MessageType.
MessageWarning then return 1,0.6,0.4 else return 1,1,1 end end)())end end u=W
end local U,V=false,nil V=function()if U then return end Delay(0.1,function()U=
false return ab()end)U=true end local W,X=0,nil X=function()if L then return end
L=true wait(0.6)W=W+1 while L and W<2 do wait()aa(12)end W=W-1 end local Y Y=
function()if M then return end M=true wait(0.6)W=W+1 while M and W<2 do wait()
aa(-12)end W=W-1 end c.Body.ScrollBar.Up.MouseButton1Click:connect(function()
return aa(10)end)c.Body.ScrollBar.Up.MouseButton1Down:connect(function()aa(10)
return X()end)c.Body.ScrollBar.Up.MouseButton1Up:connect(N)c.Body.ScrollBar.Down
.MouseButton1Down:connect(function()aa(-10)return Y()end)c.Body.ScrollBar.Down.
MouseButton1Up:connect(N)local Z Z=function(_,ac)if not J then return end local
ad,ae,af=(Vector2.new(_,ac-J)).Y,1-(c.Body.TextBox.AbsoluteSize.Y/C.AbsoluteSize
.Y),A.AbsoluteSize.Y-A.Handle.AbsoluteSize.Y local ag=math.max(math.min(ad,af),0
-af)local ah,ai=ag/af,(ae*C.AbsoluteSize.Y)local aj=ai*ah if k==g then n=K-aj
elseif k==h then o=K-aj end end A.Handle.MouseButton1Down:connect(function(ac,ad
)J=Vector2.new(ac,ad)if k==g then K=n elseif k==h then K=o end end)A.Handle.
MouseButton1Up:connect(N)local ac ac=function(ad,ae,af)local ag,ah=ad.
AbsolutePosition,ad.AbsoluteSize if ae<ag.X or ae>ag.X+ah.X or af<ag.y or af>ag.
y+ah.y then return false end return true end local ad ad=function(ae)if ae<10
then return'0'..tostring(ae)else return ae end end local ae,af='%s:%s:%s',nil af
=function(ag)local ah=ag-os.time()+math.floor(tick())local ai=ah%86400 local aj=
math.floor(ai/3600)ai=ai-(aj*3600)local _=math.floor(ai/60)ai=ai-(_*60)local ak,
al,am=ad(aj),ad(_),ad(ai)return ae:format(ak,al,am)end y.ErrorToggleButton.
MouseButton1Down:connect(function()p=not p y.ErrorToggleButton.CheckFrame.
Visible=p V()return T()end)y.WarningToggleButton.MouseButton1Down:connect(
function()q=not q y.WarningToggleButton.CheckFrame.Visible=q V()return T()end)y.
InfoToggleButton.MouseButton1Down:connect(function()r=not r y.InfoToggleButton.
CheckFrame.Visible=r V()return T()end)y.OutputToggleButton.MouseButton1Down:
connect(function()s=not s y.OutputToggleButton.CheckFrame.Visible=s V()return T(
)end)y.WordWrapToggleButton.MouseButton1Down:connect(function()t=not t y.
WordWrapToggleButton.CheckFrame.Visible=t V()return T()end)local ag ag=function(
ah,ai,aj)l[#l+1]={Message=ah,Time=af(aj),Type=ai}while#l>i do table.remove(l,1)
end V()return T()end local ah ah=function(ai,aj,ak)m[#m+1]={Message=ai,Time=af(
ak),Type=aj}while#m>i do table.remove(m,1)end V()return T()end c.Body.
LocalConsole.MouseButton1Click:connect(function()if k==h then k=g local ai,aj=c.
Body.LocalConsole,c.Body.ServerConsole ai.Size=UDim2.new(0,90,0,20)aj.Size=UDim2
.new(0,90,0,17)ai.BackgroundTransparency=0.6 aj.BackgroundTransparency=0.8 if
game:FindFirstChild'Players'and game.Players['LocalPlayer']then local ak=game.
Players.LocalPlayer:GetMouse()O(ak.X,ak.Y)P(ak.X,ak.Y)Z(ak.X,ak.Y)end V()return
T()end end)c.Body.LocalConsole.MouseButton1Up:connect(N)local ai=false c.Body.
ServerConsole.MouseButton1Click:connect(function()if not ai then ai=true game:
GetService'LogService':RequestServerOutput()end if k==g then k=h local aj,ak=c.
Body.LocalConsole,c.Body.ServerConsole ak.Size=UDim2.new(0,90,0,20)aj.Size=UDim2
.new(0,90,0,17)ak.BackgroundTransparency=0.6 aj.BackgroundTransparency=0.8 if
game:FindFirstChild'Players'and game.Players['LocalPlayer']then local al=game.
Players.LocalPlayer:GetMouse()O(al.X,al.Y)P(al.X,al.Y)Z(al.X,al.Y)end V()return
T()end end)c.Body.ServerConsole.MouseButton1Up:connect(N)if game:FindFirstChild
'Players'and game.Players['LocalPlayer']then local aj=game.Players.LocalPlayer:
GetMouse()aj.Move:connect(function()if not c.Visible then return end local ak=
game.Players.LocalPlayer:GetMouse()O(ak.X,ak.Y)P(ak.X,ak.Y)Z(ak.X,ak.Y)V()return
T()end)aj.Button1Up:connect(N)aj.WheelForward:connect(function()if not c.Visible
then return end if ac(c,aj.X,aj.Y)then return aa(10)end end)aj.WheelBackward:
connect(function()if not c.Visible then return end if ac(c,aj.X,aj.Y)then return
aa(-10)end end)end A.Handle.MouseButton1Down:connect(function()return T()end)
local aj=game:GetService'LogService':GetLogHistory()for ak=1,#aj do ag(aj[ak].
message,aj[ak].messageType,aj[ak].timestamp)end local ak=game:GetService
'LogService'ak.MessageOut:connect(function(al,am)return ag(al,am,os.time())end)
ak.ServerMessageOut:connect(ah)return ak end local aa=false d.OnInvoke=function(
)if aa then return end aa=true f()c.Visible=not c.Visible aa=false end