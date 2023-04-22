local a,b={},nil b=function(c,d,e)if not(e~=nil)then e=d d=nil end local f=
Instance.new(c)if d then f.Name=d end local g for h,i in pairs(e)do if type(h)==
'string'then if h=='Parent'then g=i else f[h]=i end elseif type(h)=='number'and
type(i)=='userdata'then i.Parent=f end end f.Parent=g return f end local c c=
function(d,e,f,g,h,i)local j,k k=function()if game:IsAncestorOf(d)then if not j
then j=e[f]:connect(g)if h~=nil then h()end end if j then j:disconnect()if i~=
nil then return i()end return nil end end end local l=d.AncestryChanged:connect(
k)k()return l end local d d=function(e)local f=e while f and not f:IsA
'ScreenGui'do f=f.Parent end return f end local e e=function(f,g,h,i)local j,k=1
,{}for l,m in ipairs(g)do local n=b('TextButton','Button'..tostring(j),{Font=
Enum.Font.Arial,FontSize=Enum.FontSize.Size18,AutoButtonColor=true,Modal=true,
Style=(function()if m['Style']then return m.Style else return Enum.ButtonStyle.
RobloxButton end end)(),Text=m.Text,TextColor3=Color3.new(1,1,1),Parent=f})n.
MouseButton1Click:connect(m.Function)k[j]=n j=j+1 end local n=j-1 if n==1 then f
.Button1.Position=UDim2.new(0.35,0,h.Scale,h.Offset)f.Button1.Size=UDim2.new(0.4
,0,i.Scale,i.Offset)elseif n==2 then f.Button1.Position=UDim2.new(0.1,0,h.Scale,
h.Offset)f.Button1.Size=UDim2.new(0.26666666666666666,0,i.Scale,i.Offset)f.
Button2.Position=UDim2.new(0.55,0,h.Scale,h.Offset)f.Button2.Size=UDim2.new(0.35
,0,i.Scale,i.Offset)elseif n>=3 then local o,p=0.1/n,0.9/n j=1 while j<=n do k[j
].Position=UDim2.new(o*j+p*(j-1),0,h.Scale,h.Offset)k[j].Size=UDim2.new(p,0,i.
Scale,i.Offset)j=j+1 end end end local f f=function(g,h,i,j,k)local l,m=k-1,math
.min(1,math.max(0,(g-j.AbsolutePosition.X)/j.AbsoluteSize.X))local n,o=math.
modf(m*l)if o>0.5 then n=n+1 end m=n/l local p=math.ceil(m*l)if i.Value~=p+1
then i.Value=p+1 h.Position=UDim2.new(m,-h.AbsoluteSize.X/2,h.Position.Y.Scale,h
.Position.Y.Offset)end end local g g=function(h)h.Visible=false local i=
areaSoakMouseMoveCon if i~=nil then return i:disconnect()end return nil end a.
CreateStyledMessageDialog=function(h,i,j,k)local l=b('Frame','MessageDialog',{
Size=UDim2.new(0.5,0,0,165),Position=UDim2.new(0.25,0,0.5,-72.5),Active=true,
Style=Enum.FrameStyle.RobloxRound,b('ImageLabel','StyleImage',{
BackgroundTransparency=1,Position=UDim2.new(0,5,0,15)}),b('TextLabel','Title',{
Text=h,TextStrokeTransparency=0,BackgroundTransparency=1,TextColor3=Color3.new(
0.8666666666666667,0.8666666666666667,0.8666666666666667),Position=UDim2.new(0,
80,0,0),Size=UDim2.new(1,-80,0,40),Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size36,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.
TextYAlignment.Center}),b('TextLabel','Message',{Text=i,TextStrokeTransparency=0
,TextColor3=Color3.new(0.8666666666666667,0.8666666666666667,0.8666666666666667)
,Position=UDim2.new(0.025,80,0,45),Size=UDim2.new(0.95,-80,0,55),
BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
TextWrap=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.
TextYAlignment.Top})})local m=l.StyleImage if j=='error'or j=='Error'then m.Size
=UDim2.new(0,71,0,71)m.Image='http://www.roblox.com/asset?id=42565285'elseif j==
'notify'or j=='Notify'then m.Size=UDim2.new(0,71,0,71)m.Image=
'http://www.roblox.com/asset?id=42604978'elseif j=='confirm'or j=='Confirm'then
m.Size=UDim2.new(0,74,0,76)m.Image='http://www.roblox.com/asset?id=42557901'else
return a.CreateMessageDialog(h,i,k)end e(l,k,UDim.new(0,105),UDim.new(0,40))
return l end a.CreateMessageDialog=function(h,i,j)local k=b('Frame',
'MessageDialog',{Size=UDim2.new(0.5,0,0.5,0),Position=UDim2.new(0.25,0,0.25,0),
Active=true,Style=Enum.FrameStyle.RobloxRound,Parent=script.Parent,b('TextLabel'
,'Title',{Text=h,BackgroundTransparency=1,TextColor3=Color3.new(
0.8666666666666667,0.8666666666666667,0.8666666666666667),Position=UDim2.new(0,0
,0,0),Size=UDim2.new(1,0,0.15,0),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize
.Size36,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.
TextYAlignment.Center}),b('TextLabel','Message',{Text=i,TextColor3=Color3.new(
0.8666666666666667,0.8666666666666667,0.8666666666666667),Position=UDim2.new(
0.025,0,0.175,0),Size=UDim2.new(0.95,0,0.55,0),BackgroundTransparency=1,Font=
Enum.Font.Arial,FontSize=Enum.FontSize.Size18,TextWrap=true,TextXAlignment=Enum.
TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})})e(k,j,UDim.new(0.8
,0),UDim.new(0.15,0))return k end a.CreateDropDownMenu=function(h,i,j)local k,l,
m=UDim.new(0,100),UDim.new(0,32),#h local n,o=m,false if n>6 then o=true n=6 end
local p=b('Frame','DropDownMenu',{BackgroundTransparency=1,Size=UDim2.new(k,l),
b('TextButton','List',{Text='',BackgroundTransparency=1,Style=Enum.ButtonStyle.
RobloxButton,Visible=false,Active=true,Position=UDim2.new(0,0,0,0),Size=UDim2.
new(1,0,(1+n)*0.8,0),ZIndex=2}),b('TextButton','DropDownMenuButton',{TextWrap=
true,TextColor3=Color3.new(1,1,1),Text='Choose One',Font=Enum.Font.ArialBold,
FontSize=Enum.FontSize.Size18,TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,BackgroundTransparency=1,
AutoButtonColor=true,Style=Enum.ButtonStyle.RobloxButton,Size=UDim2.new(1,0,1,0)
,ZIndex=2,b('ImageLabel','Icon',{Active=false,Image=
'http://www.roblox.com/asset/?id=45732894',BackgroundTransparency=1,Size=UDim2.
new(0,11,0,6),Position=UDim2.new(1,-11,0.5,-2),ZIndex=2})})})local q,r,s,t,u,v,w
,x,y=p.DropDownMenuButton,p.List,b('TextButton','ChoiceButton',{
BackgroundTransparency=1,BorderSizePixel=0,Text='ReplaceMe',TextColor3=Color3.
new(1,1,1),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.
TextYAlignment.Center,BackgroundColor3=Color3.new(1,1,1),Font=Enum.Font.Arial,
FontSize=Enum.FontSize.Size18,Size=UDim2.new((function()if o then return 1,-13,
0.8/((n+1)*0.8),0 else return 1,0,0.8/((n+1)*0.8),0 end end)()),TextWrap=true,
ZIndex=2}),b('TextButton','AreaSoak',{Text='',BackgroundTransparency=1,Active=
true,Size=UDim2.new(1,0,1,0),Visible=false,ZIndex=3}),false,nil,nil,0,nil y=
function(z)r.ZIndex=z+1 if v then v.ZIndex=z+3 end if w then w.ZIndex=z+3 end
local A=r:GetChildren()if A then for B,C in ipairs(A)do if C.Name==
'ChoiceButton'then C.ZIndex=z+2 elseif C.Name=='ClickCaptureButton'then C.ZIndex
=z end end end end local z,A=1,nil A=function()if v then v.Active=z>1 end if w
then w.Active=z+n<=m end local B=r:GetChildren()if not B then return end local C
=1 for D,E in ipairs(B)do if E.Name=='ChoiceButton'then if C<z or C>=z+n then E.
Visible=false else E.Position=UDim2.new(0,0,((C-z+1)*0.8)/((n+1)*0.8),0)E.
Visible=true end E.TextColor3=Color3.new(1,1,1)E.BackgroundTransparency=1 C=C+1
end end end local B B=function()u=not u t.Visible=not t.Visible q.Visible=not u
r.Visible=u if u then y(4)else y(2)end if o then return A()end end r.
MouseButton1Click:connect(B)local C C=function(D)local E,F,G=false,r:
GetChildren(),1 if F then for H,I in ipairs(F)do if I.Name=='ChoiceButton'then
if I.Text==D then I.Font=Enum.Font.ArialBold E=true z=G else I.Font=Enum.Font.
Arial end G=G+1 end end end if not D then q.Text='Choose One'z=1 else if not E
then error('Invalid Selection Update -- '..D)end if z+n>m+1 then z=m-n+1 end q.
Text=D end end local D D=function()if z+n<=m then z=z+1 A()return true end
return false end local E E=function()if z>1 then z=z-1 A()return true end return
false end if o then v=b('ImageButton','ScrollUpButton',{BackgroundTransparency=1
,Image='rbxasset://textures/ui/scrollbuttonUp.png',Size=UDim2.new(0,17,0,17),
Position=UDim2.new(1,-11,(0.8)/((n+1)*0.8),0),Parent=r})local F F=function()x=x+
1 end v.MouseButton1Click:connect(F)v.MouseLeave:connect(F)v.MouseButton1Down:
connect(function()x=x+1 E()local G=x wait(0.5)while G==x do if E()==false then
break end wait(0.1)end end)w=b('ImageButton','ScrollDownButton',{
BackgroundTransparency=1,Image='rbxasset://textures/ui/scrollbuttonDown.png',
Size=UDim2.new(0,17,0,17),Position=UDim2.new(1,-11,1,-11),Parent=r})w.
MouseButton1Click:connect(F)w.MouseLeave:connect(F)w.MouseButton1Down:connect(
function()x=x+1 D()local G=x wait(0.5)while G==x do if D()==false then break end
wait(0.1)end end)b('ImageLabel','ScrollBar',{Image=
'rbxasset://textures/ui/scrollbar.png',BackgroundTransparency=1,Size=UDim2.new(0
,18,(n*0.8)/((n+1)*0.8),-32),Position=UDim2.new(1,-11,(0.8)/((n+1)*0.8),19),
Parent=r})end for F,G in ipairs(h)do local H=s:clone()if j then H.RobloxLocked=
true end H.Text=G H.Parent=r H.MouseButton1Click:connect(function()H.TextColor3=
Color3.new(1,1,1)H.BackgroundTransparency=1 C(G)i(G)return B()end)H.MouseEnter:
connect(function()H.TextColor3=Color3.new(0,0,0)H.BackgroundTransparency=0 end)H
.MouseLeave:connect(function()H.TextColor3=Color3.new(1,1,1)H.
BackgroundTransparency=1 end)end A()p.AncestryChanged:connect(function(H,I)if
not(I~=nil)then t.Parent=nil else t.Parent=d(p)end end)q.MouseButton1Click:
connect(B)t.MouseButton1Click:connect(B)return p,C end a.
CreatePropertyDropDownMenu=function(h,i,j)local k,l,m=j:GetEnumItems(),{},{}for
n,o in ipairs(k)do l[n]=o.Name m[o.Name]=o end local p,q=a.CreateDropDownMenu(l,
function(p)h[i]=m[p]end)local r r=function(s)if s==i then return q(h[i].Name)end
end local s s=function()return q(h[i].Name)end c(p,h,'Changed',r,s)return p end
a.GetFontHeight=function(h,i)if not((h~=nil)and(i~=nil))then error
'Font and FontSize must be non-nil'end if h==Enum.Font.Legacy then if Enum.
FontSize.Size8==i then return 12 elseif Enum.FontSize.Size9==i then return 14
elseif Enum.FontSize.Size10==i then return 15 elseif Enum.FontSize.Size11==i
then return 17 elseif Enum.FontSize.Size12==i then return 18 elseif Enum.
FontSize.Size14==i then return 21 elseif Enum.FontSize.Size18==i then return 27
elseif Enum.FontSize.Size24==i then return 36 elseif Enum.FontSize.Size36==i
then return 54 elseif Enum.FontSize.Size48==i then return 72 else return error
'Unknown FontSize'end elseif h==Enum.Font.Arial or h==Enum.Font.ArialBold then
if Enum.FontSize.Size8==i then return 8 elseif Enum.FontSize.Size9==i then
return 9 elseif Enum.FontSize.Size10==i then return 10 elseif Enum.FontSize.
Size11==i then return 11 elseif Enum.FontSize.Size12==i then return 12 elseif
Enum.FontSize.Size14==i then return 14 elseif Enum.FontSize.Size18==i then
return 18 elseif Enum.FontSize.Size24==i then return 24 elseif Enum.FontSize.
Size36==i then return 36 elseif Enum.FontSize.Size48==i then return 48 else
return error'Unknown FontSize'end else return error('Unknown Font '..tostring(h)
)end end local h h=function(i,j,k)local l=i.AbsoluteSize.Y local m=l for n,o in
ipairs(j)do if o:IsA'TextLabel'or o:IsA'TextButton'then local p=o:IsA'TextLabel'
local q='Text'..tostring((function()if p then return'Label'else return'Button'
end end)())..'PositionPadY'm=m-k[q]o.Position=UDim2.new(o.Position.X.Scale,o.
Position.X.Offset,0,l-m)o.Size=UDim2.new(o.Size.X.Scale,o.Size.X.Offset,0,m)if o
.TextFits and o.TextBounds.Y<m then o.Visible=true o.Size=UDim2.new(o.Size.X.
Scale,o.Size.X.Offset,0,o.TextBounds.Y+k[q])while not o.TextFits do o.Size=UDim2
.new(o.Size.X.Scale,o.Size.X.Offset,0,o.AbsoluteSize.Y+1)end m=m-o.AbsoluteSize.
Y m=m-k[q]else o.Visible=false m=-1 end else o.Position=UDim2.new(o.Position.X.
Scale,o.Position.X.Offset,0,l-m)m=m-o.AbsoluteSize.Y o.Visible=m>=0 end end end
a.LayoutGuiObjects=function(i,j,k)if not i:IsA'GuiObject'then error
'Frame must be a GuiObject'end for l,m in ipairs(j)do if not m:IsA'GuiObject'
then error'All elements that are layed out must be of type GuiObject'end end if
not k then k={}end if not k['TextLabelSizePadY']then k['TextLabelSizePadY']=0
end if not k['TextLabelPositionPadY']then k['TextLabelPositionPadY']=0 end if
not k['TextButtonSizePadY']then k['TextButtonSizePadY']=12 end if not k[
'TextButtonPositionPadY']then k['TextButtonPositionPadY']=2 end local n=b(
'Frame','WrapperFrame',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Parent=
i})for o,p in ipairs(j)do p.Parent=n end local q q=function()wait()return h(n,j,
k)end i.Changed:connect(function(r)if r=='AbsoluteSize'then return q(nil)end end
)i.AncestryChanged:connect(q)return h(n,j,k)end a.CreateSlider=function(i,j,k)
local n,o=b('Frame','SliderGui',{Size=UDim2.new(1,0,1,0),BackgroundTransparency=
1,b('IntValue','SliderSteps',{Value=i}),b('IntValue','SliderPosition',{Value=0})
,b('TextButton','Bar',{Text='',AutoButtonColor=false,BackgroundColor3=Color3.
new(0,0,0),Size=UDim2.new(0,(function()if type(j)=='number'then return j else
return 200 end end)(),0,5),BorderColor3=Color3.new(0.37254901960784315,
0.37254901960784315,0.37254901960784315),ZIndex=2,b('ImageButton','Slider',{
BackgroundTransparency=1,Image='rbxasset://textures/ui/Slider.png',Position=
UDim2.new(0,0,0.5,-10),Size=UDim2.new(0,20,0,20),ZIndex=3})})}),b('TextButton',
'AreaSoak',{Text='',BackgroundTransparency=1,Active=false,Size=UDim2.new(1,0,1,0
),Visible=false,ZIndex=4})local p,q,r,s=n.Bar.Slider,n.Bar,n.SliderPosition,n.
SliderSteps n.AncestryChanged:connect(function(t,u)if not(u~=nil)then o.Parent=
nil else o.Parent=d(n)end end)if k['X']and k['X']['Scale']and k['X']['Offset']
and k['Y']and k['Y']['Scale']and k['Y']['Offset']then q.Position=k end local t o
.MouseLeave:connect(function()if o.Visible then return g(o)end end)o.
MouseButton1Up:connect(function()if o.Visible then return g(o)end end)p.
MouseButton1Down:connect(function()o.Visible=true if t~=nil then t:disconnect()
end t=o.MouseMoved:connect(function(u,v)return f(u,p,r,q,i)end)end)p.
MouseButton1Up:connect(function()return g(o)end)r.Changed:connect(function(u)r.
Value=math.min(i,math.max(1,r.Value))local v=(r.Value-1)/(i-1)p.Position=UDim2.
new(v,-p.AbsoluteSize.X/2,p.Position.Y.Scale,p.Position.Y.Offset)end)q.
MouseButton1Down:connect(function(u,v)return f(u,p,r,q,i)end)return n,r,s end a.
CreateTrueScrollingFrame=function()local i,j,k,n,o,p,q=nil,nil,nil,nil,false,{},
b('Frame','ScrollingFrame',{Active=true,Size=UDim2.new(1,0,1,0),ClipsDesants=
true,b('Frame','ControlFrame',{BackgroundTransparency=1,Size=UDim2.new(0,18,1,0)
,Position=UDim2.new(1,-20,0,0),b('BoolValue','ScrollBottom',{Value=false}),b(
'BoolValue','scrollUp',{Value=false}),b('TextButton','ScrollUpButton',{Text='',
AutoButtonColor=false,BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.
new(1,1,1),BackgroundTransparency=0.5,Size=UDim2.new(0,18,0,18),ZIndex=2}),b(
'Frame','ScrollTrack',{BackgroundTransparency=1,Size=UDim2.new(0,18,1,-38),
Position=UDim2.new(0,0,0,19),b('TextButton','ScrollBar',{BackgroundColor3=Color3
.new(0,0,0),BorderColor3=Color3.new(1,1,1),BackgroundTransparency=0.5,
AutoButtonColor=false,Text='',Active=true,ZIndex=2,Size=UDim2.new(0,18,0.1,0),
Position=UDim2.new(0,0,0,0),b('Frame','ScrollNub',{BorderColor3=Color3.new(1,1,1
),Size=UDim2.new(0,10,0,0),Position=UDim2.new(0.5,-5,0.5,0),ZIndex=2,
BackgroundTransparency=0.5})})})})})local r,s,t,u,v,w,x=q.ControlFrame,q.
ControlFrame.ScrollBottom,q.ControlFrame.ScrollUp,q.ControlFrame.ScrollUpButton,
q.ControlFrame.ScrollTrack,q.ControlFrame.ScrollTrack.ScrollBar,q.ControlFrame.
ScrollTrack.ScrollBar.ScrollNub for y=1,6 do b('Frame','tri'..tostring(y),{
BorderColor3=Color3.new(1,1,1),ZIndex=3,BackgroundTransparency=0.5,Size=UDim2.
new(0,12-((y-1)*2),0,0),Position=UDim2.new(0,3+(y-1),0.5,2-(y-1)),Parent=u})end
u.MouseEnter:connect(function()u.BackgroundTransparency=0.1 local y=u:
GetChildren()for z=1,#y do y[z].BackgroundTransparency=0.1 end end)u.MouseLeave:
connect(function()u.BackgroundTransparency=0.5 local y=u:GetChildren()for z=1,#y
do y[z].BackgroundTransparency=0.5 end end)local y=u:clone()do y.Name=
'ScrollDownButton'y.Position=UDim2.new(0,0,1,-18)local z=y:GetChildren()for A=1,
#z do z[A].Position=UDim2.new(0,3+(A-1),0.5,-2+(A-1))end y.MouseEnter:connect(
function()y.BackgroundTransparency=0.1 z=y:GetChildren()for A=1,#z do z[A].
BackgroundTransparency=0.1 end end)y.MouseLeave:connect(function()y.
BackgroundTransparency=0.5 z=y:GetChildren()for A=1,#z do z[A].
BackgroundTransparency=0.5 end end)y.Parent=r end local z=x:clone()z.Position=
UDim2.new(0.5,-5,0.5,-2)z.Parent=w local A=x:clone()A.Position=UDim2.new(0.5,-5,
0.5,2)A.Parent=w w.MouseEnter:connect(function()w.BackgroundTransparency=0.1 x.
BackgroundTransparency=0.1 z.BackgroundTransparency=0.1 A.BackgroundTransparency
=0.1 end)w.MouseLeave:connect(function()w.BackgroundTransparency=0.5 x.
BackgroundTransparency=0.5 z.BackgroundTransparency=0.5 A.BackgroundTransparency
=0.5 end)local B,C=b('ImageButton',{Active=false,Size=UDim2.new(1.5,0,1.5,0),
AutoButtonColor=false,BackgroundTransparency=1,Name='mouseDrag',Position=UDim2.
new(-0.25,0,-0.25,0),ZIndex=10}),nil C=function(D,E,F)local G=w.Position if E<v.
AbsolutePosition.y then w.Position=UDim2.new(w.Position.X.Scale,w.Position.X.
Offset,0,0)return(G~=w.Position)end local H=w.AbsoluteSize.Y/v.AbsoluteSize.Y if
E>(v.AbsolutePosition.y+v.AbsoluteSize.y)then w.Position=UDim2.new(w.Position.X.
Scale,w.Position.X.Offset,1-H,0)return(G~=w.Position)end local I=(E-v.
AbsolutePosition.y-F)/v.AbsoluteSize.y if I+H>1 then I=1-H s.Value=true t.Value=
false elseif I<=0 then I=0 t.Value=true s.Value=false else t.Value=false s.Value
=false end w.Position=UDim2.new(w.Position.X.Scale,w.Position.X.Offset,I,0)
return(G~=w.Position)end local D D=function(E)if not E or not E:IsA'GuiObject'
then return end if E==r then return end if E:IsDesantOf(r)then return end if not
E.Visible then return end if(i and i>E.AbsolutePosition.Y)or not i then i=E.
AbsolutePosition.Y end if(j and j<(E.AbsolutePosition.Y+E.AbsoluteSize.Y))or not
j then j=E.AbsolutePosition.Y+E.AbsoluteSize.Y end local F=E:GetChildren()for G=
1,#F do D(F[G])end end local E E=function()local F=q:GetChildren()for G=1,#F do
D(F[G])end end local F F=function()o=true local G=0 if w.Position.Y.Scale>0 then
if w.Visible then G=w.Position.Y.Scale/((v.AbsoluteSize.Y-w.AbsoluteSize.Y)/v.
AbsoluteSize.Y)else G=0 end end if G>0.99 then G=1 end local H,I=(q.AbsoluteSize
.Y-(j-i))*G,q:GetChildren()for J=1,#I do if I[J]~=r then I[J].Position=UDim2.
new(I[J].Position.X.Scale,I[J].Position.X.Offset,0,math.ceil(I[J].
AbsolutePosition.Y)-math.ceil(i)+H)end end i=nil j=nil E()o=false end local G G=
function()if not j or not i then return end local H=math.abs(j-i)if H==0 then w.
Visible=false y.Visible=false u.Visible=false if k~=nil then k:disconnect()end k
=nil if n~=nil then n:disconnect()end n=nil end local I=q.AbsoluteSize.Y/H if I
>=1 then w.Visible=false y.Visible=false u.Visible=false F()else w.Visible=true
y.Visible=true u.Visible=true w.Size=UDim2.new(w.Size.X.Scale,w.Size.X.Offset,I,
0)end local J=(q.AbsolutePosition.Y-i)/H w.Position=UDim2.new(w.Position.X.Scale
,w.Position.X.Offset,J,-w.AbsoluteSize.X/2)if w.AbsolutePosition.y<v.
AbsolutePosition.y then w.Position=UDim2.new(w.Position.X.Scale,w.Position.X.
Offset,0,0)end if w.AbsolutePosition.y+w.AbsoluteSize.Y>v.AbsolutePosition.y+v.
AbsoluteSize.y then local K=w.AbsoluteSize.Y/v.AbsoluteSize.Y w.Position=UDim2.
new(w.Position.X.Scale,w.Position.X.Offset,1-K,0)end end local H,I,J=7,false,nil
J=function()if I then return end I=true if C(0,w.AbsolutePosition.Y-H,0)then F()
end I=false end local K,L=false,nil L=function()if K then return end K=true if
C(0,w.AbsolutePosition.Y+H,0)then F()end K=false end t=function(M)if u.Active
then local N=tick()local O,P=N,nil P=B.MouseButton1Up:connect(function()N=tick()
B.Parent=nil return P:disconnect()end)B.Parent=d(w)J()wait(0.2)a=tick()local Q=
0.1 while N==O do J()if M and M>w.AbsolutePosition.y then break end if not u.
Active then break end if tick()-a>5 then Q=0 elseif tick()-a>2 then Q=0.06 end
wait(Q)end end end local M M=function(N)if y.Active then local O=tick()local P,Q
=O,nil Q=B.MouseButton1Up:connect(function()O=tick()B.Parent=nil return Q:
disconnect()end)B.Parent=d(w)L()wait(0.2)a=tick()local R=0.1 while O==P do L()if
N and N<(w.AbsolutePosition.y+w.AbsoluteSize.x)then break end if not y.Active
then break end if tick()-a>5 then R=0 elseif tick()-a>2 then R=0.06 end wait(R)
end end end w.MouseButton1Down:connect(function(N,O)if w.Active then scrollStamp
=tick()local P=O-w.AbsolutePosition.y if k~=nil then k:disconnect()end k=nil if
n~=nil then n:disconnect()end n=nil local Q=false k=B.MouseMoved:connect(
function(R,S)if Q then return end Q=true if C(R,S,P)then F()end Q=false end)n=B.
MouseButton1Up:connect(function()scrollStamp=tick()B.Parent=nil k:disconnect()k=
nil n:disconnect()local R=nil end)B.Parent=d(w)end end)local N=0 u.
MouseButton1Down:connect(function()return t()end)y.MouseButton1Down:connect(
function()return M()end)local O O=function()scrollStamp=tick()end u.
MouseButton1Up:connect(O)y.MouseButton1Up:connect(O)w.MouseButton1Up:connect(O)
local P P=function()local Q,R=i,j i=nil j=nil E()if(i~=Q)or(j~=R)then return G()
end end local Q Q=function(R,S)if o then return end if not R.Visible then return
end if S=='Size'or S=='Position'then wait()return P()end end q.DesantAdded:
connect(function(R)if not R:IsA'GuiObject'then return end if R.Visible then
wait()P()end p[R]=R.Changed:connect(function(S)return Q(R,S)end)end)q.
DesantRemoving:connect(function(R)if not R:IsA'GuiObject'then return end if p[R]
then p[R]:disconnect()p[R]=nil end wait()return P()end)q.Changed:connect(
function(R)if R=='AbsoluteSize'then if not j or not i then return end P()return
G()end end)return q,r end a.CreateScrollingFrame=function(i,j)local k,n,o,p=b(
'Frame','ScrollingFrame',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)}),b(
'ImageButton','ScrollUpButton',{BackgroundTransparency=1,Image=
'rbxasset://textures/ui/scrollbuttonUp.png',Size=UDim2.new(0,17,0,17)}),b(
'ImageButton','ScrollDownButton',{BackgroundTransparency=1,Image=
'rbxasset://textures/ui/scrollbuttonDown.png',Size=UDim2.new(0,17,0,17)}),b(
'ImageButton','ScrollBar',{Image='rbxasset://textures/ui/scrollbar.png',
BackgroundTransparency=1,Size=UDim2.new(0,18,0,150),b('ImageButton','ScrollDrag'
,{Image='http://www.roblox.com/asset/?id=61367186',Size=UDim2.new(1,0,0,16),
BackgroundTransparency=1,Active=true})})local q,r,s,t=p.scrollDrag,b(
'ImageButton','mouseDrag',{Active=false,Size=UDim2.new(1.5,0,1.5,0),
AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.new(-0.25,0,-0.25,
0),ZIndex=10}),0,'simple'if j and tostring(j)then t=j end local u,v,w,x=1,0,0,
nil x=function()w=0 local y={}if i then for z,A in ipairs(i)do if A.Parent==k
then table.insert(y,A)end end else local z=k:GetChildren()if z then for A,B in
ipairs(z)do if B:IsA'GuiObject'then table.insert(y,B)end end end end if#y==0
then n.Active=false o.Active=false q.Active=false u=1 return end if u>#y then u=
#y end if u<1 then u=1 end local z,A,B,C,D,E,F,G,H=k.AbsoluteSize.Y,k.
AbsoluteSize.Y,k.AbsoluteSize.X,0,0,true,0,#y,0 G=u while G<=#y and F<z do C=C+y
[G].AbsoluteSize.X if C>=B then F=F+H H=0 C=y[G].AbsoluteSize.X end if y[G].
AbsoluteSize.Y>H then H=y[G].AbsoluteSize.Y end G=G+1 end F=F+H H=0 G=u-1 C=0
while F+H<z and G>=1 do C=C+y[G].AbsoluteSize.X D=D+1 if C>=B then v=D-1 D=0 C=y
[G].AbsoluteSize.X if F+H<=z then F=F+H if u<=v then u=1 break else u=u-v end H=
0 else break end end if y[G].AbsoluteSize.Y>H then H=y[G].AbsoluteSize.Y end G=G
-1 end if(G==0)and(F+H<=z)then u=1 end C=0 D=0 E=true local I,J,K=0,0,0 if y[1]
then K=math.ceil(math.floor(math.fmod(z,y[1].AbsoluteSize.X))/2)J=math.ceil(math
.floor(math.fmod(B,y[1].AbsoluteSize.Y))/2)end for L,M in ipairs(y)do if L<u
then M.Visible=false else if A<0 then M.Visible=false else if E then D=D+1 end
if C+M.AbsoluteSize.X>=B then if E then v=D-1 E=false end C=0 A=A-M.AbsoluteSize
.Y end M.Position=UDim2.new(M.Position.X.Scale,C+J,0,z-A+K)C=C+M.AbsoluteSize.X
M.Visible=((A-M.AbsoluteSize.Y)>=0)if M.Visible then w=w+1 end I=M.AbsoluteSize
end end end n.Active=(u>1)if I==0 then o.Active=false else o.Active=(A-I.Y)<0
end q.Active=#y>w q.Visible=q.Active end local y y=function()local z={}w=0 if i
then for A,B in ipairs(i)do if B.Parent==k then table.insert(z,B)end end else
local A=k:GetChildren()if A then for B,C in ipairs(A)do if C:IsA'GuiObject'then
table.insert(z,C)end end end end if#z==0 then n.Active=false o.Active=false q.
Active=false u=1 return end if u>#z then u=#z end local A,B,C,D=k.AbsoluteSize.Y
,k.AbsoluteSize.Y,0,#z while C<A and D>=1 do if D>=u then C=C+z[D].AbsoluteSize.
Y else if C+z[D].AbsoluteSize.Y<=A then C=C+z[D].AbsoluteSize.Y if u<=1 then u=1
break else u=u-1 end else break end end D=D-1 end D=u for E,F in ipairs(z)do if
E<u then F.Visible=false else if B<0 then F.Visible=false else F.Position=UDim2.
new(F.Position.X.Scale,F.Position.X.Offset,0,A-B)B=B-F.AbsoluteSize.Y if B>=0
then F.Visible=true w=w+1 else F.Visible=false end end end end n.Active=(u>1)o.
Active=(B<0)q.Active=#z>w q.Visible=q.Active end local z z=function()local A,B=0
,k:GetChildren()if B then for C,D in ipairs(B)do if D:IsA'GuiObject'then A=A+1
end end end if not q.Parent then return end local C=q.Parent.AbsoluteSize.y*(1/(
A-w+1))if C<16 then C=16 end q.Size=UDim2.new(q.Size.X.Scale,q.Size.X.Offset,q.
Size.Y.Scale,C)local D=(u-1)/(A-w)if D>1 then D=1 elseif D<0 then D=0 end local
E=0 if D~=0 then E=(D*p.AbsoluteSize.y)-(D*q.AbsoluteSize.y)end q.Position=UDim2
.new(q.Position.X.Scale,q.Position.X.Offset,q.Position.Y.Scale,E)end local A,B=
false,nil B=function()if A then return end A=true wait()local C,D if t=='grid'
then C,D=pcall(function()return x()end)elseif t=='simple'then C,D=pcall(function
()return y()end)end if not C then print(D)end z()A=false end local C C=function(
)u=u-v if u<1 then u=1 end return B(nil)end local D D=function()u=u+v return B(
nil)end local E E=function(F)if n.Active then s=tick()local G,H=s,r.
MouseButton1Up:connect(function()s=tick()r.Parent=nil return upCon:disconnect()
end)r.Parent=d(p)C()wait(0.2)a=tick()local I=0.1 while s==G do C()if F and F>q.
AbsolutePosition.y then break end if not n.Active then break end if tick()-a>5
then I=0 elseif tick()-a>2 then I=0.06 end wait(I)end end end local F F=function
(G)if o.Active then s=tick()local H,I=s,r.MouseButton1Up:connect(function()s=
tick()r.Parent=nil return downCon:disconnect()end)r.Parent=d(p)D()wait(0.2)a=
tick()local J=0.1 while s==H do D()if G and G<(q.AbsolutePosition.y+q.
AbsoluteSize.x)then break end if not o.Active then break end if tick()-a>5 then
J=0 elseif tick()-a>2 then J=0.06 end wait(J)end end end q.MouseButton1Down:
connect(function(G,H)if q.Active then s=tick()local I,J,K=H-q.AbsolutePosition.y
,nil,nil J=r.MouseMoved:connect(function(L,M)local N,O,P=p.AbsolutePosition.y,p.
AbsoluteSize.y,q.AbsoluteSize.y local Q=N+O-P M=M-I M=M<N and N or M>Q and Q or
M M=M-N local R,S=0,k:GetChildren()if S then for T,U in ipairs(S)do if U:IsA
'GuiObject'then R=R+1 end end end local T,U,V=M/(O-P),v,R-(w-1)local W=math.
floor((T*V)+0.5)+U if W<u then U=-U end if W<1 then W=1 end u=W return B(nil)end
)K=r.MouseButton1Up:connect(function()s=tick()r.Parent=nil J:disconnect()J=nil K
:disconnect()local L=nil end)r.Parent=d(p)end end)local G=0 n.MouseButton1Down:
connect(function()return E()end)o.MouseButton1Down:connect(function()return F()
end)n.MouseButton1Up:connect(function()s=tick()end)o.MouseButton1Up:connect(
function()s=tick()end)p.MouseButton1Up:connect(function()s=tick()end)p.
MouseButton1Down:connect(function(H,I)if I>(q.AbsoluteSize.y+q.AbsolutePosition.
y)then return F(I)elseif I<q.AbsolutePosition.y then return E(I)end end)k.
ChildAdded:connect(function()return B(nil)end)k.ChildRemoved:connect(function()
return B(nil)end)k.AncestryChanged:connect(function()return B(nil)end)k.Changed:
connect(function(H)if H=='AbsoluteSize'then return B(nil)end end)return k,n,o,B,
p end local i i=function(j,k,n)if j>k then return j end local o=j while j<=k do
local p=j+math.floor((k-j)/2)if n(p)and(not(o~=nil)or o<p)then o=p j=p+1 else k=
p-1 end end return o end local j j=function(k,n,o)if k>n then return k end local
p=n while k<=n do local q=k+math.floor((n-k)/2)if o(q)and(not(p~=nil)or p>q)then
p=q n=q-1 else k=q+1 end end return p end local k k=function(n)while(n~=nil)do
if n:IsA'ScreenGui'or n:IsA'BillboardGui'then return n end n=n.Parent end end a.
AutoTruncateTextObject=function(n)local o,p=n.Text,n:Clone()p.Name='Full'..
tostring(n.Name)p.BorderSizePixel=0 p.BackgroundTransparency=0 p.Text=o p.
TextXAlignment=Enum.TextXAlignment.Center p.Position=UDim2.new(0,-3,0,0)p.Size=
UDim2.new(0,100,1,0)p.Visible=false p.Parent=n local q,r,s,t t=function()if not(
k(n)~=nil)then return end n.Text=o if n.TextFits then if r~=nil then r:
disconnect()end r=nil if s~=nil then s:disconnect()end s=nil else local u=string
.len(o)n.Text=tostring(o)..'~'local v=i(0,u,function(v)if v==0 then n.Text='~'
else n.Text=tostring(string.sub(o,1,v))..'~'end return n.TextFits end)q=
tostring(string.sub(o,1,v))..'~'n.Text=q if not p.TextFits then p.Size=UDim2.
new(0,10000,1,0)end local w=j(n.AbsoluteSize.X,p.AbsoluteSize.X,function(w)p.
Size=UDim2.new(0,w,1,0)return p.TextFits end)p.Size=UDim2.new(0,w+6,1,0)if not(r
~=nil)then r=n.MouseEnter:connect(function()p.ZIndex=n.ZIndex+1 p.Visible=true
end)end if not(s~=nil)then s=n.MouseLeave:connect(function()p.Visible=false end)
end end end n.AncestryChanged:connect(t)n.Changed:connect(function(u)if u==
'AbsoluteSize'then return t()end end)t()local u u=function(v)o=v p.Text=o return
t()end return n,u end local n n=function(o,p,q,r)if o then o.Visible=false if q.
Visible==false then q.Size=o.Size q.Position=o.Position end elseif q.Visible==
false then q.Size=UDim2.new(0,50,0,50)q.Position=UDim2.new(0.5,-25,0.5,-25)end q
.Visible=true r.Value=nil local s,t if p then p.Visible=true s=p.Size t=p.
Position p.Visible=false else s=UDim2.new(0,50,0,50)t=UDim2.new(0.5,-25,0.5,-25)
end return q:TweenSizeAndPosition(s,t,Enum.EasingDirection.InOut,Enum.
EasingStyle.Quad,0.3,true,function(u)if u==Enum.TweenStatus.Completed then q.
Visible=false if p then p.Visible=true r.Value=p end end end)end a.
CreateTutorial=function(o,p,q)local r=b('Frame','Tutorial-'..tostring(o),{
BackgroundTransparency=1,Size=UDim2.new(0.6,0,0.6,0),Position=UDim2.new(0.2,0,
0.2,0),b('Frame','TransitionFrame',{Style=Enum.FrameStyle.RobloxRound,Size=UDim2
.new(0.6,0,0.6,0),Position=UDim2.new(0.2,0,0.2,0),Visible=false}),b(
'ObjectValue','CurrentTutorialPage',{Value=nil}),b('BoolValue','Buttons',{Value=
q}),b('Frame','Pages',{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)})})local
s,t,u,v=r.TransitionFrame,r.CurrentTutorialPage,r.Pages,nil v=function()local w,
x=nil,u:GetChildren()if x then for y,z in ipairs(x)do if z.Visible then if w
then z.Visible=false else w=z end end end end return w end local w w=function(x)
if x or UserSettings().GameSettings:GetTutorialState(p)==false then print(
'Showing tutorial-',p)local y,z=v(),u:FindFirstChild'TutorialPage1'if z then
return n(y,z,s,t)else return error'Could not find TutorialPage1'end end end
local x x=function()local y=v()if y then n(y,nil,s,t)end return UserSettings().
GameSettings:SetTutorialState(p,true)end local y y=function(z)local A,B=u:
FindFirstChild('TutorialPage'..tostring(z)),v()return n(B,A,s,t)end return r,w,x
,y end local o o=function(p,q,r,s)local t=b('Frame','TutorialPage',{Style=Enum.
FrameStyle.RobloxRound,Size=UDim2.new(0.6,0,0.6,0),Position=UDim2.new(0.2,0,0.2,
0),Visible=false,b('TextLabel','Header',{Text=p,BackgroundTransparency=1,
FontSize=Enum.FontSize.Size24,Font=Enum.Font.ArialBold,TextColor3=Color3.new(1,1
,1),TextXAlignment=Enum.TextXAlignment.Center,TextWrap=true,Size=UDim2.new(1,-55
,0,22),Position=UDim2.new(0,0,0,0)}),b('ImageButton','SkipButton',{
AutoButtonColor=false,BackgroundTransparency=1,Image=
'rbxasset://textures/ui/closeButton.png',Size=UDim2.new(0,25,0,25),Position=
UDim2.new(1,-25,0,0)}),b('TextButton','NextButton',{Text='Next',TextColor3=
Color3.new(1,1,1),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,Style=Enum.
ButtonStyle.RobloxButtonDefault,Size=UDim2.new(0,80,0,32),Position=UDim2.new(0.5
,5,1,-32),Active=false,Visible=false}),b('TextButton','PrevButton',{Text=
'Previous',TextColor3=Color3.new(1,1,1),Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size18,Style=Enum.ButtonStyle.RobloxButton,Size=UDim2.new(0,80,0,32),
Position=UDim2.new(0.5,-85,1,-32),Active=false,Visible=false}),b('Frame',
'ContentFrame',{BackgroundTransparency=1,Position=UDim2.new(0,0,0,25)})})local u
=t.ContentFrame do local v=t.SkipButton v.MouseButton1Click:connect(function()
return r()end)v.MouseEnter:connect(function()v.Image=
'rbxasset://textures/ui/closeButton_dn.png'end)v.MouseLeave:connect(function()v.
Image='rbxasset://textures/ui/closeButton.png'end)end if s then local v=b(
'TextButton','DoneButton',{Style=Enum.ButtonStyle.RobloxButtonDefault,Text=
'Done',TextColor3=Color3.new(1,1,1),Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size18,Size=UDim2.new(0,100,0,50),Position=UDim2.new(0.5,-50,1,-50),
Parent=t})if r then v.MouseButton1Click:connect(function()return r()end)end end
if s then u.Size=UDim2.new(1,0,1,-75)else u.Size=UDim2.new(1,0,1,-22)end local v
,w w=function()if t.Visible and t.Parent then local x=math.min(t.Parent.
AbsoluteSize.X,t.Parent.AbsoluteSize.Y)return q(200,x)end end t.Changed:connect(
function(x)if x=='Parent'then if v~=nil then v:disconnect()end v=nil if t.Parent
and t.Parent:IsA'GuiObject'then v=t.Parent.Changed:connect(function(y)if y==
'AbsoluteSize'then wait()return w()end end)w()end end if x=='Visible'then return
w()end end)return t,u end a.CreateTextTutorialPage=function(p,q,r)local s,t,u=
nil,b('TextLabel',{BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),Text=q,
TextWrap=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.
TextYAlignment.Center,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size14,Size=
UDim2.new(1,0,1,0)}),nil u=function(v,w)local x=j(v,w,function(x)s.Size=UDim2.
new(0,x,0,x)return t.TextFits end)s.Size=UDim2.new(0,x,0,x)s.Position=UDim2.new(
0.5,-x/2,0.5,-x/2)end local v s,v=o(p,u,r)t.Parent=v return s end a.
CreateImageTutorialPage=function(p,q,r,s,t,u)local v,w,x,y=nil,nil,b(
'ImageLabel',{BackgroundTransparency=1,Image=q,Size=UDim2.new(0,r,0,s),Position=
UDim2.new(0.5,-r/2,0.5,-s/2)}),nil y=function(z,A)local B=j(z,A,function(B)
return B>=r and B>=s end)if B>=r and B>=s then x.Size=UDim2.new(0,r,0,s)x.
Position=UDim2.new(0.5,-r/2,0.5,-s/2)else if r>s then x.Size,x.Position=UDim2.
new(1,0,s/r,0),UDim2.new(0,0,0.5-(s/r)/2,0)else x.Size,x.Position=UDim2.new(r/s,
0,1,0),UDim2.new(0.5-(r/s)/2,0,0,0)end end B=B+50 v.Size=UDim2.new(0,B,0,B)v.
Position=UDim2.new(0.5,-B/2,0.5,-B/2)end v,w=o(p,y,t,u)x.Parent=w return v end a
.AddTutorialPage=function(p,q)local r,s=p.TransitionFrame,p.CurrentTutorialPage
if not p.Buttons.Value then q.NextButton.Parent=nil q.PrevButton.Parent=nil end
local t=p.Pages:GetChildren()if t and#t>0 then q.Name='TutorialPage'..tostring(#
t+1)local u=t[#t]if not u:IsA'GuiObject'then error
'All elements under Pages must be GuiObjects'end if p.Buttons.Value then if u.
NextButton.Active then error
[[NextButton already Active on previousPage, please only add pages with RbxGui.AddTutorialPage function]]
end u.NextButton.MouseButton1Click:connect(function()return n(u,q,r,s)end)u.
NextButton.Active=true u.NextButton.Visible=true if q.PrevButton.Active then
error
[[PrevButton already Active on tutorialPage, please only add pages with RbxGui.AddTutorialPage function]]
end q.PrevButton.MouseButton1Click:connect(function()return n(q,u,r,s)end)q.
PrevButton.Active=true q.PrevButton.Visible=true end q.Parent=p.Pages else q.
Name='TutorialPage1'q.Parent=p.Pages end end a.CreateSetPanel=function(p,q,r,s,t
,u,v)if not p then error
[[CreateSetPanel: userIdsForSets (first arg) is nil, should be a table of number ids]]
end if type(p)~='table'and type(p)~='userdata'then error(
'CreateSetPanel: userIdsForSets (first arg) is of type '..tostring(type(p))..
', should be of type table or userdata')end if not q then error
[[CreateSetPanel: objectSelected (second arg) is nil, should be a callback function!]]
end if type(q)~='function'then error(
'CreateSetPanel: objectSelected (second arg) is of type '..tostring(type(q))..
', should be of type function!')end if r and type(r)~='function'then error(
'CreateSetPanel: dialogClosed (third arg) is of type '..tostring(type(r))..
', should be of type function!')end if not(u~=nil)then u=false end local w,x,y,z
,A,B,C,D,E,F=1,{},{},nil,nil,'NegX','None',nil,nil,{}F.CurrentCategory=nil F.
Category={}local G,H,I={},nil,64 local J,K,L,M=I,nil,nil,game:GetService
'ContentProvider'.BaseUrl:lower()if v then L,K=tostring(M)..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&assetversionid=]],
tostring(M)..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&assetversionid=]]else L,K=
tostring(M)..'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&aid=',
tostring(M)..'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&aid='end local
N N=function(O,P)local Q=O:GetChildren()for R=1,#Q do if Q[R]:IsA'GuiObject'then
Q[R].ZIndex=P end N(Q[R],P)end end local O,P,Q=nil,{'Block','Vertical Ramp',
'Corner Wedge','Inverse Corner Wedge','Horizontal Ramp','Auto-Wedge'},{}for R=1,
#P do Q[P[R]]=R-1 end Q[P[#P]]=6 local R R=function()local S,T,U={'NegX','X',
'NegY','Y','NegZ','Z'},{'None','Small','Medium','Strong','Max'},b('Frame',
'WaterFrame',{Style=Enum.FrameStyle.RobloxSquare,Size=UDim2.new(0,150,0,110),
Visible=false})local V=b('TextLabel','WaterForceLabel',{BackgroundTransparency=1
,Size=UDim2.new(1,0,0,12),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size12
,TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.TextXAlignment.Left,Text=
'Water Force',Parent=U})local W=V:Clone()W.Name='WaterForceDirectionLabel'W.Text
='Water Force Direction'W.Position=UDim2.new(0,0,0,50)W.Parent=U E=b(
'BindableEvent','WaterTypeChangedEvent',{Parent=U})local X X=function(Y)B=Y
return E:Fire{C,B}end local Y Y=function(Z)C=Z return E:Fire{C,B}end local Z,_=a
.CreateDropDownMenu(S,X)Z.Size=UDim2.new(1,0,0,25)Z.Position=UDim2.new(0,0,1,3)_
'NegX'Z.Parent=W local aa,ab=a.CreateDropDownMenu(T,Y)ab'None'aa.Size=UDim2.new(
1,0,0,25)aa.Position=UDim2.new(0,0,1,3)aa.Parent=V return U,E end local aa aa=
function()A=Instance.new'ScreenGui'A.Name='SetGui'local ab,S,T=b('Frame',
'SetPanel',{Active=true,BackgroundTransparency=1,Position=t or UDim2.new(0.2,29,
0.1,24),Size=s or UDim2.new(0.6,-58,0.64,0),Style=Enum.FrameStyle.RobloxRound,
ZIndex=6,Parent=A,b('TextButton','CancelButton',{Position=UDim2.new(1,-32,0,-2),
Size=UDim2.new(0,34,0,34),Style=Enum.ButtonStyle.RobloxButtonDefault,ZIndex=6,
Text='',Modal=true,b('ImageLabel','CancelImage',{BackgroundTransparency=1,Image=
'http://www.roblox.com/asset?id=54135717',Position=UDim2.new(0,-2,0,-2),Size=
UDim2.new(0,16,0,16),ZIndex=6})}),b('Frame','ItemPreview',{
BackgroundTransparency=1,Position=UDim2.new(0.8,5,0.085,0),Size=UDim2.new(0.21,0
,0.9,0),ZIndex=6,b('ImageLabel','LargePreview',{BackgroundTransparency=1,Image=
'',Size=UDim2.new(1,0,0,170),ZIndex=6}),b('Frame','TextPanel',{
BackgroundTransparency=1,Position=UDim2.new(0,0,0.45,0),Size=UDim2.new(1,0,0.55,
0),ZIndex=6,b('TextLabel','RolloverText',{BackgroundTransparency=1,Size=UDim2.
new(1,0,0,48),ZIndex=6,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size24,
Text='',TextColor3=Color3.new(1,1,1),TextWrap=true,TextXAlignment=Enum.
TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})})}),b('Frame',
'Sets',{BackgroundTransparency=1,Position=UDim2.new(0,0,0,5),Size=UDim2.new(0.23
,0,1,-5),ZIndex=6,b('Frame','Line',{BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.7,BorderSizePixel=0,Position=UDim2.new(1,-3,0.06,0),
Size=UDim2.new(0,3,0.9,0),ZIndex=6}),b('TextLabel','SetsHeader',{
BackgroundTransparency=1,Size=UDim2.new(0,47,0,24),ZIndex=6,Font=Enum.Font.
ArialBold,FontSize=Enum.FontSize.Size24,Text='Sets',TextColor3=Color3.new(1,1,1)
,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top}
)})}),a.CreateTrueScrollingFrame()S.Size=UDim2.new(1,-6,0.94,0)S.Position=UDim2.
new(0,0,0.06,0)S.BackgroundTransparency=1 S.Name='SetsLists'S.ZIndex=6 S.Parent=
ab.Sets N(T,7)return A end local ab ab=function(S)local T=b('TextButton',{Text=S
or'',AutoButtonColor=false,BackgroundTransparency=1,BackgroundColor3=Color3.new(
1,1,1),BorderSizePixel=0,Size=UDim2.new(1,-5,0,18),ZIndex=6,Visible=false,Font=
Enum.Font.Arial,FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),
TextXAlignment=Enum.TextXAlignment.Left})return T end local S S=function(T,U,V,W
,X)local Y=ab(T)Y.Text=T Y.Name='SetButton'Y.Visible=true b('IntValue','SetId',{
Value=U,Parent=Y})b('StringValue','SetName',{Value=T,Parent=Y})return Y end
local T T=function(U)local X,Y={},0 for Z=1,#U do if not u and U[Z].Name=='Beta'
then Y=Y+1 else X[Z-Y]=S(U[Z].Name,U[Z].CategoryId,U[Z].ImageAssetId,Z-Y,#U)end
end return X end local U U=function()wait()local X=A.SetPanel.ItemPreview X.
LargePreview.Size=UDim2.new(1,0,0,X.AbsoluteSize.X)X.LargePreview.Position=UDim2
.new(0.5,-X.LargePreview.AbsoluteSize.X/2,0,0)X.TextPanel.Position=UDim2.new(0,0
,0,X.LargePreview.AbsoluteSize.Y)X.TextPanel.Size=UDim2.new(1,0,0,X.AbsoluteSize
.Y-X.LargePreview.AbsoluteSize.Y)return X end local X X=function()local Y=b(
'Frame','InsertAssetButtonExample',{Position=UDim2.new(0,128,0,64),Size=UDim2.
new(0,64,0,64),BackgroundTransparency=1,ZIndex=6,Visible=false,b('IntValue',
'AssetId',{Value=0}),b('StringValue','AssetName',{Value=''}),b('TextButton',
'Button',{Text='',Style=Enum.ButtonStyle.RobloxButton,Position=UDim2.new(0.025,0
,0.025,0),Size=UDim2.new(0.95,0,0.95,0),ZIndex=6,b('ImageLabel','ButtonImage',{
Image='',Position=UDim2.new(0,-7,0,-7),Size=UDim2.new(1,14,1,14),
BackgroundTransparency=1,ZIndex=7})})})do local Z=Y.button.ButtonImage:clone()Z.
Name='ConfigIcon'Z.Visible=false Z.Position=UDim2.new(1,-23,1,-24)Z.Size=UDim2.
new(0,16,0,16)Z.Image=''Z.ZIndex=6 Z.Parent=Y end return Y end local Y Y=
function(Z)if Z:FindFirstChild'AssetId'then delay(0,function()game:GetService
'ContentProvider':Preload(L..tostring(Z.AssetId.Value))A.SetPanel.ItemPreview.
LargePreview.Image=L..tostring(Z.AssetId.Value)end)end if Z:FindFirstChild
'AssetName'then A.SetPanel.ItemPreview.TextPanel.RolloverText.Text=Z.AssetName.
Value end end local Z Z=function(_)if O then return q(tostring(O.AssetName.Value
),tonumber(O.AssetId.Value),_)end end local _ _=function(ac,ad)local ae=b(
'TextButton',tostring(ac)..'Button',{Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size14,BorderSizePixel=0,TextColor3=Color3.new(1,1,1),Text=ac,
TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ZIndex=ad.
ZIndex+1,Size=UDim2.new(0,ad.Size.X.Offset-2,0,16),Position=UDim2.new(0,1,0,0)})
ae.MouseEnter:connect(function()ae.BackgroundTransparency=0 ae.TextColor3=Color3
.new(0,0,0)end)ae.MouseLeave:connect(function()ae.BackgroundTransparency=1 ae.
TextColor3=Color3.new(1,1,1)end)ae.MouseButton1Click:connect(function()ae.
BackgroundTransparency=1 ae.TextColor3=Color3.new(1,1,1)if ae.Parent and ae.
Parent:IsA'GuiObject'then ae.Parent.Visible=false end return Z(Q[ae.Text])end)
return ae end local ac ac=function(ad)local ae=b('Frame','TerrainDropDown',{
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(1,0,0),Size=UDim2.
new(0,200,0,0),Visible=false,ZIndex=ad,Parent=A})for af=1,#P do local ag=_(P[af]
,ae)ag.Position=UDim2.new(0,1,0,(af-1)*ag.Size.Y.Offset)ag.Parent=ae ae.Size=
UDim2.new(0,200,0,ae.Size.Y.Offset+ag.Size.Y.Offset)end return ae.MouseLeave:
connect(function()ae.Visible=false end)end local ad ad=function(ae)local af=b(
'ImageButton',{Name='DropDownButton',Image=
'http://www.roblox.com/asset/?id=67581509',BackgroundTransparency=1,Size=UDim2.
new(0,16,0,16),Position=UDim2.new(1,-24,0,6),ZIndex=ae.ZIndex+2,Parent=ae})if
not A:FindFirstChild'TerrainDropDown'then ac(8)end return af.MouseButton1Click:
connect(function()A.TerrainDropDown.Visible=true A.TerrainDropDown.Position=
UDim2.new(0,ae.AbsolutePosition.X,0,ae.AbsolutePosition.Y)O=ae end)end local ae
ae=function()local af=X()af.Name='InsertAssetButton'af.Visible=true if F.
Category[F.CurrentCategory].SetName=='High Scalability'then ad(af)end local ag=
nil local ah=af.MouseEnter:connect(function()ag=af return delay(0.1,function()if
ag==af then return Y(af)end end)end)return af,ah end local af af=function(ag)
local ah,ai=0,0 for aj=1,#x do x[aj].Position=UDim2.new(0,I*ah,0,J*ai)ah=ah+1 if
ah>=ag then ah=0 ai=ai+1 end end end local ag ag=function(ah,ai,aj,ak)if ai then
ah.AssetName.Value=aj ah.AssetId.Value=ak local al=K..ak if al~=ah.Button.
ButtonImage.Image then delay(0,function()game:GetService'ContentProvider':
Preload(K..ak)ah.Button.ButtonImage.Image=K..ak end)end table.insert(y,ah.Button
.MouseButton1Click:connect(function()local am=aj=='Water'and(F.Category[F.
CurrentCategory].SetName=='High Scalability')D.Visible=am return q(aj,(function(
)if am then return tonumber(ak),nil else return tonumber(ak)end end)())end))ah.
Visible=true else ah.Visible=false end end local ah ah=function(ai,aj,ak)local
al=aj*ak if w>#z then return end local am=w for an=1,al+1 do if w>=#z+1 then
break end local ao x[w],ao=ae()table.insert(y,ao)x[w].Parent=ai.SetPanel.
ItemsFrame w=w+1 end af(ak)for an=am,w do if x[an]then if z[an]then if z[an].
Name=='Water'and F.Category[F.CurrentCategory].SetName=='High Scalability'then x
[an]:FindFirstChild('DropDownButton',true):Destroy()end local ao if v then ao=z[
an].AssetVersionId else ao=z[an].AssetId end ag(x[an],true,z[an].Name,ao)else
break end else break end end end local ai ai=function()F.Category[F.
CurrentCategory].Index=0 local aj,ak=7,math.floor(A.SetPanel.ItemsFrame.
AbsoluteSize.X/I)z=F.Category[F.CurrentCategory].Contents if z then for al=1,#x
do x[al]:remove()end for al=1,#y do if y[al]then y[al]:disconnect()end end y={}x
={}w=1 return ah(A,aj,ak)end end local aj aj=function(ak,al,am,an)if ak and(F.
Category[F.CurrentCategory]~=nil)then do local ao=F.Category[F.CurrentCategory]
if ak~=ao.Button then ao.Button=ak if not(G[am]~=nil)then G[am]=game:GetService
'InsertService':GetCollection(am)end ao.Contents=G[am]ao.SetName=al ao.SetId=am
end end return ai()end end local ak ak=function(al,am)if al~=F.CurrentCategory
then if F.CurrentCategory then for an,ao in pairs(F.CurrentCategory)do ao.
Visible=false end end F.CurrentCategory=al if not(F.Category[F.CurrentCategory]
~=nil)then F.Category[F.CurrentCategory]={}if#al>0 then return aj(al[1],al[1].
SetName.Value,al[1].SetId.Value,0)end else local an=F.Category[F.CurrentCategory
]an.Button=nil aj(an.ButtonFrame,an.SetName,an.SetId,an.Index)return an end end
end local al al=function(am)return ak(am,0)end local am am=function()local an=A.
SetPanel.Sets.SetsLists:GetChildren()for ao=1,#an do do local ap=an[ao]if ap:IsA
'TextButton'then ap.Selected=false ap.BackgroundTransparency=1 ap.TextColor3=
Color3.new(1,1,1)ap.BackgroundColor3=Color3.new(1,1,1)end end end end local an
an=function()local ao=0 for ap=1,#H do do local aq=H[ap]aq.Visible=true aq.
Position=UDim2.new(0,5,0,ao*aq.Size.Y.Offset)aq.Parent=A.SetPanel.Sets.SetsLists
if ap==1 then aq.Selected=true aq.BackgroundColor3=Color3.new(0,0.8,0)aq.
TextColor3=Color3.new(0,0,0)aq.BackgroundTransparency=0 end aq.MouseEnter:
connect(function()if not aq.Selected then aq.BackgroundTransparency=0 aq.
TextColor3=Color3.new(0,0,0)end end)aq.MouseLeave:connect(function()if not aq.
Selected then aq.BackgroundTransparency=1 aq.TextColor3=Color3.new(1,1,1)end end
)aq.MouseButton1Click:connect(function()am()aq.Selected=not aq.Selected aq.
BackgroundColor3=Color3.new(0,0.8,0)aq.TextColor3=Color3.new(0,0,0)aq.
BackgroundTransparency=0 return aj(aq,aq.Text,H[ap].SetId.Value,0)end)ao=ao+1
end end local ap=A.SetPanel.Sets.SetsLists:GetChildren()if ap then for aq=1,#ap
do if ap[aq]:IsA'TextButton'then aj(ap[aq],ap[aq].Text,H[aq].SetId.Value,0)al(H)
break end end end end A=aa()D,E=R()D.Position=UDim2.new(0,55,0,0)D.Parent=A A.
Changed:connect(function(ao)if ao=='AbsoluteSize'then U()return ai()end end)
local ao,ap=a.CreateTrueScrollingFrame()ao.Name='ItemsFrame'ao.Size=UDim2.new(
0.54,0,0.85,0)ao.Position=UDim2.new(0.24,0,0.085,0)ao.ZIndex=6 ao.Parent=A.
SetPanel ao.BackgroundTransparency=1 N(ap,7)ap.Parent=A.SetPanel ap.Position=
UDim2.new(0.76,5,0,0)local aq,ar,as=false,math.floor(A.SetPanel.ItemsFrame.
AbsoluteSize.Y/J),math.floor(A.SetPanel.ItemsFrame.AbsoluteSize.X/I)ap.
ScrollBottom.Changed:connect(function(at)if ap.ScrollBottom.Value==true then if
aq then return end aq=true ah(A,ar,as)aq=false end end)local at={}for au=1,#p do
local av=game:GetService'InsertService':GetUserSets(p[au])if av and#av>2 then
for aw=3,#av do table.insert(at,(function()if av[aw].Name=='High Scalability'
then return 1,av[aw]else return av[aw]end end)())end end end if at then H=T(at)
end an()A.SetPanel.CancelButton.MouseButton1Click:connect(function()A.SetPanel.
Visible=false if r~=nil then return r()end return nil end)local au au=function(
av)A.SetPanel.Visible=not not av end local av av=function()if(function()if A~=
nil then return A:FindFirstChild'SetPanel'end return nil end)()then return A.
SetPanel.Visible end return false end return A,au,av,E end a.
CreateTerrainMaterialSelector=function(aa,ab)local ac=Instance.new
'BindableEvent'ac.Name='TerrainMaterialSelectionChanged'local ad,ae=nil,b(
'Frame','TerrainMaterialSelector',{Size=aa or UDim2.new(0,245,0,230),
BorderSizePixel=0,BackgroundColor3=Color3.new(0,0,0),Active=true})if ab then ae.
Position=ab end ac.Parent=ae local af,ag,ah,ai={},{'Grass','Sand','Brick',
'Granite','Asphalt','Iron','Aluminum','Gold','Plank','Log','Gravel',
'Cinder Block','Stone Wall','Concrete','Plastic (red)','Plastic (blue)','Water'}
,1,nil ai=function(aj)for ak,al in ipairs(ag)do if al==aj then return ak end end
end local aj aj=function(ak)if Enum.CellMaterial.Grass==ak or 1==ak then return
'Grass'elseif Enum.CellMaterial.Sand==ak or 2==ak then return'Sand'elseif Enum.
CellMaterial.Empty==ak or 0==ak then return'Erase'elseif Enum.CellMaterial.Brick
==ak or 3==ak then return'Brick'elseif Enum.CellMaterial.Granite==ak or 4==ak
then return'Granite'elseif Enum.CellMaterial.Asphalt==ak or 5==ak then return
'Asphalt'elseif Enum.CellMaterial.Iron==ak or 6==ak then return'Iron'elseif Enum
.CellMaterial.Aluminum==ak or 7==ak then return'Aluminum'elseif Enum.
CellMaterial.Gold==ak or 8==ak then return'Gold'elseif Enum.CellMaterial.
WoodPlank==ak or 9==ak then return'Plank'elseif Enum.CellMaterial.WoodLog==ak or
10==ak then return'Log'elseif Enum.CellMaterial.Gravel==ak or 11==ak then return
'Gravel'elseif Enum.CellMaterial.CinderBlock==ak or 12==ak then return
'Cinder Block'elseif Enum.CellMaterial.MossyStone==ak or 13==ak then return
'Stone Wall'elseif Enum.CellMaterial.Cement==ak or 14==ak then return'Concrete'
elseif Enum.CellMaterial.RedPlastic==ak or 15==ak then return'Plastic (red)'
elseif Enum.CellMaterial.BluePlastic==ak or 16==ak then return'Plastic (blue)'
elseif Enum.CellMaterial.Water==ak or 17==ak then return'Water'end end local ak
ak=function(al)ah=ai(al)return ac:Fire(ah)end for al,am in pairs(ag)do af[am]={}
af[am].Regular='http://www.roblox.com/asset/?id='..tostring((function()if'Grass'
==am then return 56563112 elseif'Sand'==am then return 62356652 elseif'Brick'==
am then return 65961537 elseif'Granite'==am then return 67532153 elseif'Asphalt'
==am then return 67532038 elseif'Iron'==am then return 67532093 elseif'Aluminum'
==am then return 67531995 elseif'Gold'==am then return 67532118 elseif
'Plastic (red)'==am then return 67531848 elseif'Plastic (blue)'==am then return
67531924 elseif'Plank'==am then return 67532015 elseif'Log'==am then return
67532051 elseif'Gravel'==am then return 67532206 elseif'Cinder Block'==am then
return 67532103 elseif'Stone Wall'==am then return 67531804 elseif'Concrete'==am
then return 67532059 elseif'Water'==am then return 81407474 else return 66887593
end end)())end local an,ao,ap,aq=a.CreateScrollingFrame(nil,'grid')an.Size=UDim2
.new(0.85,0,1,0)an.Position=UDim2.new(0,0,0,0)an.Parent=ae ao.Parent=ae ao.
Visible=true ao.Position=UDim2.new(1,-19,0,0)ap.Parent=ae ap.Visible=true ap.
Position=UDim2.new(1,-19,1,-17)local ar ar=function(as,at)ak(at)as.
BackgroundTransparency=0 ad.BackgroundTransparency=1 ad=as end local as as=
function(at)local au=b('TextButton',tostring(at),{Text='',Size=UDim2.new(0,32,0,
32),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,BackgroundTransparency=
1,AutoButtonColor=false,b('ImageButton',tostring(at),{AutoButtonColor=false,
BackgroundTransparency=1,Size=UDim2.new(0,30,0,30),Position=UDim2.new(0,1,0,1),
Image=af[at].Regular}),b('NumberValue','EnumType',{Value=0})})do local av=au.
ImageButton av.MouseEnter:connect(function()au.BackgroundTransparency=0 end)av.
MouseLeave:connect(function()if ad~=au then au.BackgroundTransparency=1 end end)
av.MouseButton1Click:connect(function()if ad~=au then return ar(au,tostring(at))
end end)end return au end for at=1,#ag do local au=as(ag[at])if ag[at]=='Grass'
then ad=au au.BackgroundTransparency=0 end au.Parent=an end local at at=function
(au)if not au then return end if ah==au then return end local av,aw=aj(au),an:
GetChildren()for p=1,#aw do if(aw[p].Name=='Plastic (blue)'and av==
'Plastic (blue)')or(aw[p].Name=='Plastic (red)'and av=='Plastic (red)')or(string
.find(aw[p].Name,av))then ar(aw[p],av)return end end end ae.Changed:connect(
function(au)if au=='AbsoluteSize'then return aq()end end)aq()return ae,ac,at end
a.CreateLoadingFrame=function(aa,ab,ac)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=35238053'local ad=b('Frame','LoadingFrame',{
Style=Enum.FrameStyle.RobloxRound,Size=ab or UDim2.new(0,300,0,160),Position=ac
or UDim2.new(0.5,-150,0.5,-80),b('TextLabel','loadingName',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,2),
Font=Enum.Font.Arial,Text=aa,TextColor3=Color3.new(1,1,1),TextStrokeTransparency
=1,FontSize=Enum.FontSize.Size18}),b('TextButton','CancelButton',{Position=UDim2
.new(0.5,-60,1,-40),Size=UDim2.new(0,120,0,40),Font=Enum.Font.Arial,FontSize=
Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),Text='Cancel',Style=Enum.
ButtonStyle.RobloxButton}),b('Frame','LoadingBar',{BackgroundColor3=Color3.new(0
,0,0),BorderColor3=Color3.new(0.30980392156862746,0.30980392156862746,
0.30980392156862746),Position=UDim2.new(0,0,0,41),Size=UDim2.new(1,0,0,30),b(
'ImageLabel','LoadingGreenBar',{Image='http://www.roblox.com/asset/?id=35238053'
,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,1,0),Visible=false}),b(
'TextLabel','LoadingPercent',{BackgroundTransparency=1,Position=UDim2.new(0,0,1,
0),Size=UDim2.new(1,0,0,14),Font=Enum.Font.Arial,Text='0%',FontSize=Enum.
FontSize.Size14,TextColor3=Color3.new(1,1,1)})})})local ae,af,ag=ad.CancelButton
,ad.LoadingBar.LoadingGreenBar,ad.LoadingBar.LoadingPercent local ah=b(
'BindableEvent','CancelButtonClicked',{Parent=ae})ae.MouseButton1Click:connect(
function()return ah:Fire()end)local ai ai=function(aj,ak,al)if aj and type(aj)~=
'number'then error('updateLoadingGuiPercent expects number as argument, got',
type(aj),'instead')end local am=UDim2.new((function()if aj<0 then return 0,0,1,0
elseif aj>1 then return 1,0,1,0 else return aj,0,1,0 end end)())if ak then if
not al then error
[[updateLoadingGuiPercent is set to tween new percentage, but got no tween time length! Please pass this in as third argument]]
end return af:TweenSize(am,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,al,(
function()if am.X.Scale>0 then af.Visible=true return true else return true,
function()if am.X.Scale<0 then af.Visible=false end end end end)())else af.Size=
am af.Visible=am.X.Scale>0 end end af.Changed:connect(function(aj)if aj=='Size'
then ag.Text=tostring(math.ceil(af.Size.X.Scale*100))..'%'end end)return ad,ai,
ah end a.CreatePluginFrame=function(aa,ab,ac,ad,ae)local af af=function(ag,ah,ai
,aj,ak,al)local am=b('TextButton',ak,{AutoButtonColor=false,
BackgroundTransparency=1,Position=ah,Size=ag,Font=Enum.Font.ArialBold,FontSize=
aj,Text=ai,TextColor3=Color3.new(1,1,1),BorderSizePixel=0,BackgroundColor3=
Color3.new(7.8431372549019605E-2,7.8431372549019605E-2,7.8431372549019605E-2)})
am.MouseEnter:connect(function()if am.Selected then return end am.
BackgroundTransparency=0 end)am.MouseLeave:connect(function()if am.Selected then
return end am.BackgroundTransparency=1 end)am.Parent=al return am end local ag=
b('Frame',tostring(aa)..'DragBar',{BackgroundColor3=Color3.new(
0.15294117647058825,0.15294117647058825,0.15294117647058825),BorderColor3=Color3
.new(0,0,0),Size=(function()if ab then return UDim2.new(ab.X.Scale,ab.X.Offset,0
,20)+UDim2.new(0,20,0,0)else return UDim2.new(0,183,0,20)end end)(),Active=true,
Draggable=true,b('TextLabel','BarNameLabel',{Text=' '..tostring(aa),TextColor3=
Color3.new(1,1,1),TextStrokeTransparency=0,Size=UDim2.new(1,0,1,0),Font=Enum.
Font.ArialBold,FontSize=Enum.FontSize.Size18,TextXAlignment=Enum.TextXAlignment.
Left,BackgroundTransparency=1}),b('Frame','HelpFrame',{BackgroundColor3=Color3.
new(0,0,0),Size=UDim2.new(0,300,0,552),Position=UDim2.new(1,5,0,0),Active=true,
BorderSizePixel=0,Visible=false}),b('Frame','SeparatingLine',{BackgroundColor3=
Color3.new(0.45098039215686275,0.45098039215686275,0.45098039215686275),
BorderSizePixel=0,Position=UDim2.new(1,-18,0.5,-7),Size=UDim2.new(0,1,0,14)}),b(
'Frame','MinimizeFrame',{BackgroundColor3=Color3.new(0.28627450980392155,
0.28627450980392155,0.28627450980392155),BorderColor3=Color3.new(0,0,0),Position
=UDim2.new(0,0,1,0),Size=(function()if ab then return UDim2.new(ab.X.Scale,ab.X.
Offset,0,50)+UDim2.new(0,20,0,0)else return UDim2.new(0,183,0,50)end end)(),
Visible=false,b('TextButton','MinimizeButton',{Position=UDim2.new(0.5,-50,0.5,-
20),Size=UDim2.new(0,100,0,40),Style=Enum.ButtonStyle.RobloxButton,Font=Enum.
Font.ArialBold,FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),Text=
'Show'})})})if ac then ag.Position=ac end ag.MouseEnter:connect(function()ag.
BackgroundColor3=Color3.new(0.19215686274509805,0.19215686274509805,
0.19215686274509805)end)ag.MouseLeave:connect(function()ag.BackgroundColor3=
Color3.new(0.15294117647058825,0.15294117647058825,0.15294117647058825)end)ag.
Parent=ae local ah=af(UDim2.new(0,15,0,17),UDim2.new(1,-16,0.5,-8),'X',Enum.
FontSize.Size14,'CloseButton',ag)local ai=b('BindableEvent','CloseEvent',{Parent
=ah})ah.MouseButton1Click:connect(function()ai:Fire()ah.BackgroundTransparency=1
end)local aj,ak,al,am,an=af(UDim2.new(0,15,0,17),UDim2.new(1,-51,0.5,-8),'?',
Enum.FontSize.Size14,'HelpButton',ag),ag.HelpFrame,ag.SeparatingLine,ag.
MinimizeFrame,ag.MinimizeFrame.MinimizeBigButton aj.MouseButton1Click:connect(
function()ak.Visible=not ak.Visible if ak.Visible then aj.Selected=true aj.
BackgroundTransparency=0 local ao=d(ak)if ao then if ak.AbsolutePosition.X+ak.
AbsoluteSize.X>ao.AbsoluteSize.X then ak.Position=UDim2.new(0,-5-ak.AbsoluteSize
.X,0,0)else ak.Position=UDim2.new(1,5,0,0)end else ak.Position=UDim2.new(1,5,0,0
)end else aj.Selected=false aj.BackgroundTransparency=1 end end)local ao=af(
UDim2.new(0,16,0,17),UDim2.new(1,-34,0.5,-8),'-',Enum.FontSize.Size14,
'MinimizeButton',ag)ao.TextYAlignment=Enum.TextYAlignment.Top do local ap=al:
clone()ap.Position=UDim2.new(1,-35,0.5,-7)ap.Parent=ag end local ap=b('Frame',
'WidgetContainer',{BackgroundTransparency=1,Position=UDim2.new(0,0,1,0),
BorderColor3=Color3.new(0,0,0),b('TextButton','VerticalDragger',{ZIndex=2,
AutoButtonColor=false,BackgroundColor3=Color3.new(0.19607843137254902,
0.19607843137254902,0.19607843137254902),BorderColor3=Color3.new(0,0,0),Size=
UDim2.new(1,20,0,20),Position=UDim2.new(0,0,1,0),Active=true,Text='',b('Frame',
'ScrubFrame',{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Position=
UDim2.new(0.5,-5,0.5,0),Size=UDim2.new(0,10,0,1),ZIndex=5})})})local aq,ar=ap.
VerticalDragger,ap.VerticalDragger.ScrubFrame if not ad then ap.
BackgroundTransparency=0 ap.BackgroundColor3=Color3.new(0.2823529411764706,
0.2823529411764706,0.2823529411764706)end ap.Parent=ag if ab then if ad then ap.
Size=ab else ap.Size=UDim2.new(0,ag.AbsoluteSize.X,ab.Y.Scale,ab.Y.Offset)end
else ap.Size=UDim2.new((function()if ad then return 0,163,0,400 else return 0,ag
.AbsoluteSize.X,0,400 end end)())end if ac then ap.Position=ac+UDim2.new(0,0,0,
20)end local as,at if ad then as,at=a.CreateTrueScrollingFrame()as.Size=UDim2.
new(1,0,1,0)as.BackgroundColor3=Color3.new(0.2823529411764706,0.2823529411764706
,0.2823529411764706)as.BorderColor3=Color3.new(0,0,0)as.Active=true as.Parent=ap
at.BackgroundColor3=Color3.new(0.2823529411764706,0.2823529411764706,
0.2823529411764706)at.BorderSizePixel=0 at.BackgroundTransparency=0 at.Position=
UDim2.new(1,-21,1,1)at.Size=UDim2.new(0,21,(function()if ab then return ab.Y.
Scale,ab.Y.Offset else return 0,400 end end)())at:FindFirstChild
'ScrollDownButton'.Position=UDim2.new(0,0,1,-20)at.Parent=ag b('Frame',
'FakeLine',{BorderSizePixel=0,BackgroundColor3=Color3.new(0,0,0),Size=UDim2.new(
0,1,1,1),Position=UDim2.new(1,0,0,0),Parent=at})for au=1,2 do do local av=ar:
clone()av.Position=UDim2.new(0.5,-5,0.5,2)av.Parent=aq end end local au,av,aw=b(
'TextButton','AreaSoak',{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
BorderSizePixel=0,Text='',ZIndex=10,Visible=false,Active=true,Parent=d(ae)}),
false,nil aq.MouseEnter:connect(function()aq.BackgroundColor3=Color3.new(
0.23529411764705882,0.23529411764705882,0.23529411764705882)end)aq.MouseLeave:
connect(function()aq.BackgroundColor3=Color3.new(0.19607843137254902,
0.19607843137254902,0.19607843137254902)end)aq.MouseButton1Down:connect(function
(p,q)av=true au.Visible=true aw=q end)au.MouseButton1Up:connect(function()av=
false au.Visible=false end)au.MouseMoved:connect(function(p,q)if not av then
return end local r=q-aw if not at.ScrollDownButton.Visible and r>0 then return
end if(ap.Size.Y.Offset+r)<150 then ap.Size=UDim2.new(ap.Size.X.Scale,ap.Size.X.
Offset,ap.Size.Y.Scale,150)at.Size=UDim2.new(0,21,0,150)return end aw=q if ap.
Size.Y.Offset+r>=0 then ap.Size=UDim2.new(ap.Size.X.Scale,ap.Size.X.Offset,ap.
Size.Y.Scale,ap.Size.Y.Offset+r)at.Size=UDim2.new(0,21,0,at.Size.Y.Offset+r)end
end)end local au au=function()am.Visible=not am.Visible if ad then as.Visible=
not as.Visible aq.Visible=not aq.Visible at.Visible=not at.Visible else ap.
Visible=not ap.Visible end if am.Visible then ao.Text='+'else ao.Text='-'end end
an.MouseButton1Click:connect(au)ao.MouseButton1Click:connect(au)return ag,(
function()if ad then return as,ak,ai else return ap,ak,ai end end)()end a.Help=
function(aa)if'CreatePropertyDropDownMenu'==aa or a.CreatePropertyDropDownMenu==
aa then return
[[Function CreatePropertyDropDownMenu.  Arguments: (instance, propertyName, enumType).  Side effect: returns a container with a drop-down-box that is linked to the "property" field of "instance" which is of type "enumType"]]
elseif'CreateDropDownMenu'==aa or a.CreateDropDownMenu==aa then return
[[Function CreateDropDownMenu.  Arguments: (items, onItemSelected).  Side effect: Returns 2 results, a container to the gui object and a "updateSelection" function for external updating.  The container is a drop-down-box created around a list of items]]
elseif'CreateMessageDialog'==aa or a.CreateMessageDialog==aa then return
[[Function CreateMessageDialog.  Arguments: (title, message, buttons). Side effect: Returns a gui object of a message box with "title" and "message" as passed in.  "buttons" input is an array of Tables contains a "Text" and "Function" field for the text/callback of each button]]
elseif'CreateStyledMessageDialog'==aa or a.CreateStyledMessageDialog==aa then
return
[[Function CreateStyledMessageDialog.  Arguments: (title, message, style, buttons). Side effect: Returns a gui object of a message box with "title" and "message" as passed in.  "buttons" input is an array of Tables contains a "Text" and "Function" field for the text/callback of each button, "style" is a string, either Error, Notify or Confirm]]
elseif'GetFontHeight'==aa or a.GetFontHeight==aa then return
[[Function GetFontHeight.  Arguments: (font, fontSize). Side effect: returns the size in pixels of the given font + fontSize]]
elseif'CreateScrollingFrame'==aa or a.CreateScrollingFrame==aa then return
'Function CreateScrollingFrame.  Arguments: (orderList, style) Side effect: returns 4 objects, (scrollFrame, scrollUpButton, scrollDownButton, recalculateFunction).  "scrollFrame" can be filled with GuiObjects.  It will lay them out and allow scrollUpButton/scrollDownButton to interact with them.  Orderlist is optional (and specifies the order to layout the children.  Without orderlist, it uses the children order. style is also optional, and allows for a "grid" styling if style is passed "grid" as a string.  recalculateFunction can be called\n\t\t\twhen a relayout is needed (\n\t\t\t\twhen orderList changes)'
elseif'CreateTrueScrollingFrame'==aa or a.CreateTrueScrollingFrame==aa then
return
[[Function CreateTrueScrollingFrame.  Arguments: (nil) Side effect: returns 2 objects, (scrollFrame, controlFrame).  "scrollFrame" can be filled with GuiObjects, and they will be clipped if not inside the frame"s bounds. controlFrame has children scrollup and scrolldown, as well as a slider.  controlFrame can be parented to any guiobject and it will readjust itself to fit.]]
elseif'AutoTruncateTextObject'==aa or a.AutoTruncateTextObject==aa then return
[[Function AutoTruncateTextObject.  Arguments: (textLabel) Side effect: returns 2 objects, (textLabel, changeText).  The "textLabel" input is modified to automatically truncate text (with ellipsis), if it gets too small to fit.  "changeText" is a function that can be used to change the text, it takes 1 string as an argument]]
elseif'CreateSlider'==aa or a.CreateSlider==aa then return
[[Function CreateSlider.  Arguments: (steps, width, position) Side effect: returns 2 objects, (sliderGui, sliderPosition).  The "steps" argument specifies how many different positions the slider can hold along the bar.  "width" specifies in pixels how wide the bar should be (modifiable afterwards if desired). "position" argument should be a UDim2 for slider positioning. "sliderPosition" is an IntValue whose current .Value specifies the specific step the slider is currently on.]]
elseif'CreateLoadingFrame'==aa or a.CreateLoadingFrame==aa then return
'Function CreateLoadingFrame.  Arguments: (name, size, position) Side effect: Creates a gui that can be manipulated to show progress for a particular action.  Name appears above the loading bar, and size and position are udim2 values (both size and position are optional arguments).  Returns 3 arguments, the first being the gui created. The second being updateLoadingGuiPercent, which is a bindable function.  This function takes one argument (two optionally), which should be a number between 0 and 1, representing the percentage the loading gui should be at.  The second argument to this function is a boolean value that if set to true will tween the current percentage value to the new percentage value, therefore our third argument is how long this tween should take. Our third returned argument is a BindableEvent, that\n\t\t\twhen fired means that someone clicked the cancel button on the dialog.'
elseif'CreateTerrainMaterialSelector'==aa or a.CreateTerrainMaterialSelector==aa
then return
[[Function CreateTerrainMaterialSelector.  Arguments: (size, position) Side effect: Size and position are UDim2 values that specifies the selector"s size and position.  Both size and position are optional arguments. This method returns 3 objects (terrainSelectorGui, terrainSelected, forceTerrainSelection).  terrainSelectorGui is just the gui object that we generate with this function, parent it as you like. TerrainSelected is a BindableEvent that is fired whenever a new terrain type is selected in the gui.  ForceTerrainSelection is a function that takes an argument of Enum.CellMaterial and will force the gui to show that material as currently selected.]]
end end