print'[Mercury]: Loaded corescript 45284430'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b,c={},nil c=function(d,e,f,g,h,i)local j,k k=
function()if game:IsAncestorOf(d)then if not j then j=e[f]:connect(g)if h then
return h()end end else if j then j:disconnect()if i then return i()end end end
end local l=d.AncestryChanged:connect(k)k()return l end local d d=function(e)
local f=e while f and not f:IsA'ScreenGui'do f=f.Parent end return f end local e
e=function(f,g,h,i)local j,k=1,{}for l,m in ipairs(g)do local n=a('TextButton',
'Button'..tostring(j),{Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
AutoButtonColor=true,Modal=true,Style=(function()if m['Style']then return m.
Style else return Enum.ButtonStyle.RobloxButton end end)(),Text=m.Text,
TextColor3=Color3.new(1,1,1),Parent=f})n.MouseButton1Click:connect(m.Function)k[
j]=n j=j+1 end local n=j-1 if n==1 then f.Button1.Position=UDim2.new(0.35,0,h.
Scale,h.Offset)f.Button1.Size=UDim2.new(0.4,0,i.Scale,i.Offset)elseif n==2 then
f.Button1.Position=UDim2.new(0.1,0,h.Scale,h.Offset)f.Button1.Size=UDim2.new(
0.26666666666666666,0,i.Scale,i.Offset)f.Button2.Position=UDim2.new(0.55,0,h.
Scale,h.Offset)f.Button2.Size=UDim2.new(0.35,0,i.Scale,i.Offset)elseif n>=3 then
local o,p=0.1/n,0.9/n j=1 while j<=n do k[j].Position=UDim2.new(o*j+(j-1)*p,0,h.
Scale,h.Offset)k[j].Size=UDim2.new(p,0,i.Scale,i.Offset)j=j+1 end end end local
f f=function(g,h,i,j,k)local l,m=k-1,math.min(1,math.max(0,(g-j.AbsolutePosition
.X)/j.AbsoluteSize.X))local n,o=math.modf(m*l)if o>0.5 then n=n+1 end m=n/l
local p=math.ceil(m*l)if i.Value~=(p+1)then i.Value=p+1 h.Position=UDim2.new(m,-
h.AbsoluteSize.X/2,h.Position.Y.Scale,h.Position.Y.Offset)end end local g g=
function(h)h.Visible=false if areaSoakMouseMoveCon then return
areaSoakMouseMoveCon:disconnect()end end b.CreateStyledMessageDialog=function(h,
i,j,k)local l,m=a('Frame','MessageDialog',{Size=UDim2.new(0.5,0,0,165),Position=
UDim2.new(0.25,0,0.5,-72.5),Active=true,Style=Enum.FrameStyle.RobloxRound,a(
'TextLabel','Title',{Text=h,TextStrokeTransparency=0,BackgroundTransparency=1,
TextColor3=Color3.new(0.8666666666666667,0.8666666666666667,0.8666666666666667),
Position=UDim2.new(0,80,0,0),Size=UDim2.new(1,-80,0,40),Font=Enum.Font.ArialBold
,FontSize=Enum.FontSize.Size36,TextXAlignment=Enum.TextXAlignment.Center,
TextYAlignment=Enum.TextYAlignment.Center}),a('TextLabel','Message',{Text=i,
TextStrokeTransparency=0,TextColor3=Color3.new(0.8666666666666667,
0.8666666666666667,0.8666666666666667),Position=UDim2.new(0.025,80,0,45),Size=
UDim2.new(0.95,-80,0,55),BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=
Enum.FontSize.Size18,TextWrap=true,TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top})}),a('ImageLabel','StyleImage',{
BackgroundTransparency=1,Position=UDim2.new(0,5,0,15)})if j=='error'or j==
'Error'then m.Size=UDim2.new(0,71,0,71)m.Image=
'http://www.roblox.com/asset?id=42565285'elseif j=='notify'or j=='Notify'then m.
Size=UDim2.new(0,71,0,71)m.Image='http://www.roblox.com/asset?id=42604978'elseif
j=='confirm'or j=='Confirm'then m.Size=UDim2.new(0,74,0,76)m.Image=
'http://www.roblox.com/asset?id=42557901'else return b.CreateMessageDialog(h,i,k
)end m.Parent=l e(l,k,UDim.new(0,105),UDim.new(0,40))return l end b.
CreateMessageDialog=function(h,i,j)local k=a('Frame','MessageDialog',{Size=UDim2
.new(0.5,0,0.5,0),Position=UDim2.new(0.25,0,0.25,0),Active=true,Style=Enum.
FrameStyle.RobloxRound,a('TextLabel','Title',{Text=h,BackgroundTransparency=1,
TextColor3=Color3.new(0.8666666666666667,0.8666666666666667,0.8666666666666667),
Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0.15,0),Font=Enum.Font.ArialBold,
FontSize=Enum.FontSize.Size36,TextXAlignment=Enum.TextXAlignment.Center,
TextYAlignment=Enum.TextYAlignment.Center}),a('TextLabel','Message',{Text=i,
TextColor3=Color3.new(0.8666666666666667,0.8666666666666667,0.8666666666666667),
Position=UDim2.new(0.025,0,0.175,0),Size=UDim2.new(0.95,0,0.55,0),
BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
TextWrap=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.
TextYAlignment.Top})})e(k,j,UDim.new(0.8,0),UDim.new(0.15,0))return k end b.
CreateDropDownMenu=function(h,i,j)local k,l=UDim.new(0,100),UDim.new(0,32)local
m=a('Frame','DropDownMenu',{BackgroundTransparency=1,Size=UDim2.new(k,l)})local
n,o,p,q=a('TextButton','DropDownMenuButton',{TextWrap=true,TextColor3=Color3.
new(1,1,1),Text='Choose One',Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.
Size18,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.
TextYAlignment.Center,BackgroundTransparency=1,AutoButtonColor=true,Style=Enum.
ButtonStyle.RobloxButton,Size=UDim2.new(1,0,1,0),Parent=m,ZIndex=2,a(
'ImageLabel','Icon',{Active=false,Image=
'http://www.roblox.com/asset/?id=45732894',BackgroundTransparency=1,Size=UDim2.
new(0,11,0,6),Position=UDim2.new(1,-11,0.5,-2),ZIndex=2})}),#h,#h,false if p>6
then q=true p=6 end local r,s,t,u,v,w,x,y=a('TextButton','List',{Text='',
BackgroundTransparency=1,Style=Enum.ButtonStyle.RobloxButton,Visible=false,
Active=true,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,(1+p)*0.8,0),Parent=m
,ZIndex=2}),a('TextButton','ChoiceButton',{BackgroundTransparency=1,
BorderSizePixel=0,Text='ReplaceMe',TextColor3=Color3.new(1,1,1),TextXAlignment=
Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,
BackgroundColor3=Color3.new(1,1,1),Font=Enum.Font.Arial,FontSize=Enum.FontSize.
Size18,Size=(function()if q then return UDim2.new(1,-13,0.8/((p+1)*0.8),0)else
return UDim2.new(1,0,0.8/((p+1)*0.8),0)end end)(),TextWrap=true,ZIndex=2}),a(
'TextButton','AreaSoak',{Text='',BackgroundTransparency=1,Active=true,Size=UDim2
.new(1,0,1,0),Visible=false,ZIndex=3}),false,nil,nil,0,nil y=function(z)r.ZIndex
=z+1 if v then v.ZIndex=z+3 end if w then w.ZIndex=z+3 end local A=r:
GetChildren()if A then for B,C in ipairs(A)do if C.Name=='ChoiceButton'then C.
ZIndex=z+2 elseif C.Name=='ClickCaptureButton'then C.ZIndex=z end end end end
local z,A=1,nil A=function()if v then v.Active=z>1 end if w then w.Active=z+p<=o
end local B=r:GetChildren()if not B then return end local C=1 for D,E in ipairs(
B)do if E.Name=='ChoiceButton'then if C<z or C>=z+p then E.Visible=false else E.
Position=UDim2.new(0,0,((C-z+1)*0.8)/((p+1)*0.8),0)E.Visible=true end E.
TextColor3=Color3.new(1,1,1)E.BackgroundTransparency=1 C=C+1 end end end local B
B=function()u=not u t.Visible=not t.Visible n.Visible=not u r.Visible=u if u
then y(4)else y(2)end if q then return A()end end r.MouseButton1Click:connect(B)
local C C=function(D)local E,F,G=false,r:GetChildren(),1 if F then for H,I in
ipairs(F)do if I.Name=='ChoiceButton'then if I.Text==D then I.Font=Enum.Font.
ArialBold E=true z=G else I.Font=Enum.Font.Arial end G=G+1 end end end if not D
then n.Text='Choose One'z=1 else if not E then error(
'Invalid Selection Update -- '..D)end if z+p>o+1 then z=o-p+1 end n.Text=D end
end local D D=function()if z+p<=o then z=z+1 A()return true end return false end
local E E=function()if z>1 then z=z-1 A()return true end return false end if q
then v=a('ImageButton','ScrollUpButton',{BackgroundTransparency=1,Image=
'rbxasset://textures/ui/scrollbuttonUp.png',Size=UDim2.new(0,17,0,17),Position=
UDim2.new(1,-11,(0.8)/((p+1)*0.8),0)})v.MouseButton1Click:connect(function()x=x+
1 end)v.MouseLeave:connect(function()x=x+1 end)v.MouseButton1Down:connect(
function()x=x+1 E()local F=x wait(0.5)while F==x do if E()==false then break end
wait(0.1)end end)v.Parent=r w=a('ImageButton','ScrollDownButton',{
BackgroundTransparency=1,Image='rbxasset://textures/ui/scrollbuttonDown.png',
Size=UDim2.new(0,17,0,17),Position=UDim2.new(1,-11,1,-11),Parent=r})w.
MouseButton1Click:connect(function()x=x+1 end)w.MouseLeave:connect(function()x=x
+1 end)w.MouseButton1Down:connect(function()x=x+1 D()local F=x wait(0.5)while F
==x do if D()==false then break end wait(0.1)end end)a('ImageLabel','ScrollBar',
{Image='rbxasset://textures/ui/scrollbar.png',BackgroundTransparency=1,Size=
UDim2.new(0,18,(p*0.8)/((p+1)*0.8),-32),Position=UDim2.new(1,-11,(0.8)/((p+1)*
0.8),19),Parent=r})end for F,G in ipairs(h)do local H=s:clone()if j then H.
RobloxLocked=true end H.Text=G H.Parent=r H.MouseButton1Click:connect(function()
H.TextColor3=Color3.new(1,1,1)H.BackgroundTransparency=1 C(G)i(G)return B()end)H
.MouseEnter:connect(function()H.TextColor3=Color3.new(0,0,0)H.
BackgroundTransparency=0 end)H.MouseLeave:connect(function()H.TextColor3=Color3.
new(1,1,1)H.BackgroundTransparency=1 end)end A()m.AncestryChanged:connect(
function(H,I)if I==nil then t.Parent=nil else t.Parent=d(m)end end)n.
MouseButton1Click:connect(B)t.MouseButton1Click:connect(B)return m,C end b.
CreatePropertyDropDownMenu=function(h,i,j)local k,l,m=j:GetEnumItems(),{},{}for
n,o in ipairs(k)do l[n]=o.Name m[o.Name]=o end local p,q p,q=b.
CreateDropDownMenu(l,function(r)h[i]=m[r]end)c(p,h,'Changed',function(r)if r==i
then return q(h[i].Name)end end,function()return q(h[i].Name)end)return p end b.
GetFontHeight=function(h,i)if h==nil or i==nil then error
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
return error'Unknown FontSize'end else return error('Unknown Font '..h)end end
local h h=function(i,j,k)local l,m=i.AbsoluteSize.Y,i.AbsoluteSize.Y for n,o in
ipairs(j)do if o:IsA'TextLabel'or o:IsA'TextButton'then local p=o:IsA'TextLabel'
if p then m=m-k['TextLabelPositionPadY']else m=m-k['TextButtonPositionPadY']end
o.Position=UDim2.new(o.Position.X.Scale,o.Position.X.Offset,0,l-m)o.Size=UDim2.
new(o.Size.X.Scale,o.Size.X.Offset,0,m)if o.TextFits and o.TextBounds.Y<m then o
.Visible=true if p then o.Size=UDim2.new(o.Size.X.Scale,o.Size.X.Offset,0,o.
TextBounds.Y+k['TextLabelSizePadY'])else o.Size=UDim2.new(o.Size.X.Scale,o.Size.
X.Offset,0,o.TextBounds.Y+k['TextButtonSizePadY'])end while not o.TextFits do o.
Size=UDim2.new(o.Size.X.Scale,o.Size.X.Offset,0,o.AbsoluteSize.Y+1)end m=m-o.
AbsoluteSize.Y if p then m=m-k['TextLabelPositionPadY']else m=m-k[
'TextButtonPositionPadY']end else o.Visible=false m=-1 end else o.Position=UDim2
.new(o.Position.X.Scale,o.Position.X.Offset,0,l-m)m=m-o.AbsoluteSize.Y o.Visible
=(m>=0)end end end b.LayoutGuiObjects=function(i,j,k)if not i:IsA'GuiObject'then
error'Frame must be a GuiObject'end for l,m in ipairs(j)do if not m:IsA
'GuiObject'then error'All elements that are layed out must be of type GuiObject'
end end if not k then k={}end if not k['TextLabelSizePadY']then k[
'TextLabelSizePadY']=0 end if not k['TextLabelPositionPadY']then k[
'TextLabelPositionPadY']=0 end if not k['TextButtonSizePadY']then k[
'TextButtonSizePadY']=12 end if not k['TextButtonPositionPadY']then k[
'TextButtonPositionPadY']=2 end local n=a('Frame','WrapperFrame',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Parent=i})for o,p in ipairs(j)
do p.Parent=n end local q q=function()wait()return h(n,j,k)end i.Changed:
connect(function(r)if r=='AbsoluteSize'then return q(nil)end end)i.
AncestryChanged:connect(q)return h(n,j,k)end b.CreateSlider=function(i,j,k)local
n=a('Frame','SliderGui',{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1})local
o,p=a('IntValue','SliderSteps',{Value=i,Parent=n}),a('TextButton','AreaSoak',{
Text='',BackgroundTransparency=1,Active=false,Size=UDim2.new(1,0,1,0),Visible=
false,ZIndex=4})n.AncestryChanged:connect(function(q,r)if r==nil then p.Parent=
nil else p.Parent=d(n)end end)local q,r=a('IntValue','SliderPosition',{Value=0,
Parent=n}),a('TextButton','Bar',{Text='',AutoButtonColor=false,BackgroundColor3=
Color3.new(0,0,0),Size=(function()if type(j)=='number'then return UDim2.new(0,j,
0,5)else return UDim2.new(0,200,0,5)end end)(),BorderColor3=Color3.new(
0.37254901960784315,0.37254901960784315,0.37254901960784315),ZIndex=2,Parent=n})
if k['X']and k['X']['Scale']and k['X']['Offset']and k['Y']and k['Y']['Scale']and
k['Y']['Offset']then r.Position=k end local s,t=a('ImageButton','Slider',{
BackgroundTransparency=1,Image='rbxasset://textures/ui/Slider.png',Position=
UDim2.new(0,0,0.5,-10),Size=UDim2.new(0,20,0,20),ZIndex=3,Parent=r}),nil p.
MouseLeave:connect(function()if p.Visible then return g(p)end end)p.
MouseButton1Up:connect(function()if p.Visible then return g(p)end end)s.
MouseButton1Down:connect(function()p.Visible=true if t then t:disconnect()end t=
p.MouseMoved:connect(function(u,v)return f(u,s,q,r,i)end)end)s.MouseButton1Up:
connect(function()return g(p)end)q.Changed:connect(function(u)q.Value=math.min(i
,math.max(1,q.Value))local v=(q.Value-1)/(i-1)s.Position=UDim2.new(v,-s.
AbsoluteSize.X/2,s.Position.Y.Scale,s.Position.Y.Offset)end)r.MouseButton1Down:
connect(function(u,v)return f(u,s,q,r,i)end)return n,q,o end b.
CreateTrueScrollingFrame=function()local i,j,k,n,o,p,q=nil,nil,nil,nil,false,{},
a('Frame','ScrollingFrame',{Active=true,Size=UDim2.new(1,0,1,0),ClipsDescendants
=true})local r=a('Frame','ControlFrame',{BackgroundTransparency=1,Size=UDim2.
new(0,18,1,0),Position=UDim2.new(1,-20,0,0),Parent=q})local s,t,u=a('BoolValue',
'ScrollBottom',{Value=false,Parent=r}),a('BoolValue','scrollUp',{Value=false,
Parent=r}),a('TextButton','ScrollUpButton',{Text='',AutoButtonColor=false,
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(1,1,1),
BackgroundTransparency=0.5,Size=UDim2.new(0,18,0,18),ZIndex=2,Parent=r})for v=1,
6 do a('Frame','tri'..tostring(v),{BorderColor3=Color3.new(1,1,1),ZIndex=3,
BackgroundTransparency=0.5,Size=UDim2.new(0,12-((v-1)*2),0,0),Position=UDim2.
new(0,3+(v-1),0.5,2-(v-1)),Parent=u})end u.MouseEnter:connect(function()u.
BackgroundTransparency=0.1 local v=u:GetChildren()for w=1,#v do v[w].
BackgroundTransparency=0.1 end end)u.MouseLeave:connect(function()u.
BackgroundTransparency=0.5 local v=u:GetChildren()for w=1,#v do v[w].
BackgroundTransparency=0.5 end end)local v=u:clone()v.Name='ScrollDownButton'v.
Position=UDim2.new(0,0,1,-18)local w=v:GetChildren()for x=1,#w do w[x].Position=
UDim2.new(0,3+(x-1),0.5,-2+(x-1))end v.MouseEnter:connect(function()v.
BackgroundTransparency=0.1 w=v:GetChildren()for x=1,#w do w[x].
BackgroundTransparency=0.1 end end)v.MouseLeave:connect(function()v.
BackgroundTransparency=0.5 w=v:GetChildren()for x=1,#w do w[x].
BackgroundTransparency=0.5 end end)v.Parent=r local x=a('Frame','ScrollTrack',{
BackgroundTransparency=1,Size=UDim2.new(0,18,1,-38),Position=UDim2.new(0,0,0,19)
,Parent=r})local y=a('TextButton','ScrollBar',{BackgroundColor3=Color3.new(0,0,0
),BorderColor3=Color3.new(1,1,1),BackgroundTransparency=0.5,AutoButtonColor=
false,Text='',Active=true,ZIndex=2,Size=UDim2.new(0,18,0.1,0),Position=UDim2.
new(0,0,0,0),Parent=x})local z=a('Frame','ScrollNub',{BorderColor3=Color3.new(1,
1,1),Size=UDim2.new(0,10,0,0),Position=UDim2.new(0.5,-5,0.5,0),ZIndex=2,
BackgroundTransparency=0.5,Parent=y})local A=z:clone()A.Position=UDim2.new(0.5,-
5,0.5,-2)A.Parent=y local B=z:clone()B.Position=UDim2.new(0.5,-5,0.5,2)B.Parent=
y y.MouseEnter:connect(function()y.BackgroundTransparency=0.1 z.
BackgroundTransparency=0.1 A.BackgroundTransparency=0.1 B.BackgroundTransparency
=0.1 end)y.MouseLeave:connect(function()y.BackgroundTransparency=0.5 z.
BackgroundTransparency=0.5 A.BackgroundTransparency=0.5 B.BackgroundTransparency
=0.5 end)local C,D=a('ImageButton','mouseDrag',{Active=false,Size=UDim2.new(1.5,
0,1.5,0),AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.new(-0.25
,0,-0.25,0),ZIndex=10}),nil D=function(E,F,G)local H=y.Position if F<x.
AbsolutePosition.y then y.Position=UDim2.new(y.Position.X.Scale,y.Position.X.
Offset,0,0)return(H~=y.Position)end local I=y.AbsoluteSize.Y/x.AbsoluteSize.Y if
F>(x.AbsolutePosition.y+x.AbsoluteSize.y)then y.Position=UDim2.new(y.Position.X.
Scale,y.Position.X.Offset,1-I,0)return(H~=y.Position)end local J=(F-x.
AbsolutePosition.y-G)/x.AbsoluteSize.y if J+I>1 then J=1-I s.Value=true t.Value=
false elseif J<=0 then J=0 t.Value=true s.Value=false else t.Value=false s.Value
=false end y.Position=UDim2.new(y.Position.X.Scale,y.Position.X.Offset,J,0)
return(H~=y.Position)end local E E=function(F)if not F or not F:IsA'GuiObject'
then return end if F==r then return end if F:IsDescendantOf(r)then return end if
not F.Visible then return end if(i and i>F.AbsolutePosition.Y)or not i then i=F.
AbsolutePosition.Y end if(j and j<(F.AbsolutePosition.Y+F.AbsoluteSize.Y))or not
j then j=F.AbsolutePosition.Y+F.AbsoluteSize.Y end local G=F:GetChildren()for H=
1,#G do E(G[H])end end local F F=function()local G=q:GetChildren()for H=1,#G do
E(G[H])end end local G G=function()o=true local H=0 if y.Position.Y.Scale>0 then
if y.Visible then H=y.Position.Y.Scale/((x.AbsoluteSize.Y-y.AbsoluteSize.Y)/x.
AbsoluteSize.Y)else H=0 end end if H>0.99 then H=1 end local I,J=(q.AbsoluteSize
.Y-(j-i))*H,q:GetChildren()for K=1,#J do if J[K]~=r then J[K].Position=UDim2.
new(J[K].Position.X.Scale,J[K].Position.X.Offset,0,math.ceil(J[K].
AbsolutePosition.Y)-math.ceil(i+I))end end i=nil j=nil F()o=false end local H H=
function()if not j or not i then return end local I=math.abs(j-i)if I==0 then y.
Visible=false v.Visible=false u.Visible=false if k then k:disconnect()k=nil end
if n then n:disconnect()n=nil end return end local J=q.AbsoluteSize.Y/I if J>=1
then y.Visible=false v.Visible=false u.Visible=false G()else y.Visible=true v.
Visible=true u.Visible=true y.Size=UDim2.new(y.Size.X.Scale,y.Size.X.Offset,J,0)
end local K=(q.AbsolutePosition.Y-i)/I y.Position=UDim2.new(y.Position.X.Scale,y
.Position.X.Offset,K,-y.AbsoluteSize.X/2)if y.AbsolutePosition.y<x.
AbsolutePosition.y then y.Position=UDim2.new(y.Position.X.Scale,y.Position.X.
Offset,0,0)end if(y.AbsolutePosition.y+y.AbsoluteSize.Y)>(x.AbsolutePosition.y+x
.AbsoluteSize.y)then local L=y.AbsoluteSize.Y/x.AbsoluteSize.Y y.Position=UDim2.
new(y.Position.X.Scale,y.Position.X.Offset,1-L,0)end end local I,J,K=7,false,nil
K=function()if J then return end J=true if D(0,y.AbsolutePosition.Y-I,0)then G()
end J=false end local L,M=false,nil M=function()if L then return end L=true if
D(0,y.AbsolutePosition.Y+I,0)then G()end L=false end t=function(N)if u.Active
then local O=tick()local P,Q=O,nil Q=C.MouseButton1Up:connect(function()O=tick()
C.Parent=nil return Q:disconnect()end)C.Parent=d(y)K()wait(0.2)b=tick()local R=
0.1 while O==P do K()if N and N>y.AbsolutePosition.y then break end if not u.
Active then break end if tick()-b>5 then R=0 elseif tick()-b>2 then R=0.06 end
wait(R)end end end local N N=function(O)if v.Active then local P=tick()local Q,R
=P,nil R=C.MouseButton1Up:connect(function()P=tick()C.Parent=nil return R:
disconnect()end)C.Parent=d(y)M()wait(0.2)b=tick()local S=0.1 while P==Q do M()if
O and O<(y.AbsolutePosition.y+y.AbsoluteSize.x)then break end if not v.Active
then break end if tick()-b>5 then S=0 elseif tick()-b>2 then S=0.06 end wait(S)
end end end y.MouseButton1Down:connect(function(O,P)if y.Active then local Q,R=
tick(),P-y.AbsolutePosition.y if k then k:disconnect()k=nil end if n then n:
disconnect()n=nil end local S=false k=C.MouseMoved:connect(function(T,U)if S
then return end S=true if D(T,U,R)then G()end S=false end)n=C.MouseButton1Up:
connect(function()Q=tick()C.Parent=nil k:disconnect()k=nil n:disconnect()drag=
nil end)C.Parent=d(y)end end)local O=0 u.MouseButton1Down:connect(function()
return t()end)v.MouseButton1Down:connect(function()return N()end)local P P=
function()scrollStamp=tick()end u.MouseButton1Up:connect(P)v.MouseButton1Up:
connect(P)y.MouseButton1Up:connect(P)local Q Q=function()local R,S=i,j i=nil j=
nil F()if(i~=R)or(j~=S)then return H()end end local R R=function(S,T)if o then
return end if not S.Visible then return end if T=='Size'or T=='Position'then
wait()return Q()end end q.DescendantAdded:connect(function(S)if not S:IsA
'GuiObject'then return end if S.Visible then wait()Q()end p[S]=S.Changed:
connect(function(T)return R(S,T)end)end)q.DescendantRemoving:connect(function(S)
if not S:IsA'GuiObject'then return end if p[S]then p[S]:disconnect()p[S]=nil end
wait()return Q()end)q.Changed:connect(function(S)if S=='AbsoluteSize'then if not
j or not i then return end Q()return H()end end)return q,r end b.
CreateScrollingFrame=function(i,j)local k,n,o,p,q=a('Frame','ScrollingFrame',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)}),a('ImageButton',
'ScrollUpButton',{BackgroundTransparency=1,Image=
'rbxasset://textures/ui/scrollbuttonUp.png',Size=UDim2.new(0,17,0,17)}),a(
'ImageButton','ScrollDownButton',{BackgroundTransparency=1,Image=
'rbxasset://textures/ui/scrollbuttonDown.png',Size=UDim2.new(0,17,0,17)}),a(
'ImageButton','ScrollBar',{Image='rbxasset://textures/ui/scrollbar.png',
BackgroundTransparency=1,Size=UDim2.new(0,18,0,150)}),0 local r,s,t=a(
'ImageButton','ScrollDrag',{Image='http://www.roblox.com/asset/?id=61367186',
Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Active=true,Parent=p}),a(
'ImageButton','mouseDrag',{Active=false,Size=UDim2.new(1.5,0,1.5,0),
AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.new(-0.25,0,-0.25,
0),ZIndex=10}),'simple'if j and tostring(j)then t=j end local u,v,w,x=1,0,0,nil
x=function()w=0 local y={}if i then for z,A in ipairs(i)do if A.Parent==k then
table.insert(y,A)end end else local z=k:GetChildren()if z then for A,B in
ipairs(z)do if B:IsA'GuiObject'then table.insert(y,B)end end end end if#y==0
then n.Active=false o.Active=false r.Active=false u=1 return end if u>#y then u=
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
end end end n.Active=(u>1)if I==0 then o.Active=false else o.Active=((A-I.Y)<0)
end r.Active=#y>w r.Visible=r.Active end local y y=function()local z={}w=0 if i
then for A,B in ipairs(i)do if B.Parent==k then table.insert(z,B)end end else
local A=k:GetChildren()if A then for B,C in ipairs(A)do if C:IsA'GuiObject'then
table.insert(z,C)end end end end if#z==0 then n.Active=false o.Active=false r.
Active=false u=1 return end if u>#z then u=#z end local A,B,C,D=k.AbsoluteSize.Y
,k.AbsoluteSize.Y,0,#z while C<A and D>=1 do if D>=u then C=C+z[D].AbsoluteSize.
Y else if C+z[D].AbsoluteSize.Y<=A then C=C+z[D].AbsoluteSize.Y if u<=1 then u=1
break else u=u-1 end else break end end D=D-1 end D=u for E,F in ipairs(z)do if
E<u then F.Visible=false else if B<0 then F.Visible=false else F.Position=UDim2.
new(F.Position.X.Scale,F.Position.X.Offset,0,A-B)B=B-F.AbsoluteSize.Y if B>=0
then F.Visible=true w=w+1 else F.Visible=false end end end end n.Active=(u>1)o.
Active=(B<0)r.Active=#z>w r.Visible=r.Active end local z z=function()local A,B=0
,k:GetChildren()if B then for C,D in ipairs(B)do if D:IsA'GuiObject'then A=A+1
end end end if not r.Parent then return end local C=r.Parent.AbsoluteSize.y*(1/(
A-w+1))if C<16 then C=16 end r.Size=UDim2.new(r.Size.X.Scale,r.Size.X.Offset,r.
Size.Y.Scale,C)local D=(u-1)/(A-w)if D>1 then D=1 elseif D<0 then D=0 end local
E=0 if D~=0 then E=(D*p.AbsoluteSize.y)-(D*r.AbsoluteSize.y)end r.Position=UDim2
.new(r.Position.X.Scale,r.Position.X.Offset,r.Position.Y.Scale,E)end local A,B=
false,nil B=function()if A then return end A=true wait()local C,D if t=='grid'
then C,D=pcall(function()return x()end)elseif t=='simple'then C,D=pcall(function
()return y()end)end if not C then print(D)end z()A=false end local C C=function(
)u=u-v if u<1 then u=1 end return B(nil)end local D D=function()u=u+v return B(
nil)end local E E=function(F)if n.Active then q=tick()local G,H=q,nil H=s.
MouseButton1Up:connect(function()q=tick()s.Parent=nil return H:disconnect()end)s
.Parent=d(p)C()wait(0.2)b=tick()local I=0.1 while q==G do C()if F and F>r.
AbsolutePosition.y then break end if not n.Active then break end if tick()-b>5
then I=0 elseif tick()-b>2 then I=0.06 end wait(I)end end end local F F=function
(G)if o.Active then q=tick()local H,I=q,nil I=s.MouseButton1Up:connect(function(
)q=tick()s.Parent=nil return I:disconnect()end)s.Parent=d(p)D()wait(0.2)b=tick()
local J=0.1 while q==H do D()if G and G<(r.AbsolutePosition.y+r.AbsoluteSize.x)
then break end if not o.Active then break end if tick()-b>5 then J=0 elseif
tick()-b>2 then J=0.06 end wait(J)end end end r.MouseButton1Down:connect(
function(G,H)if r.Active then q=tick()local I,J,K=H-r.AbsolutePosition.y,nil,nil
J=s.MouseMoved:connect(function(L,M)local N,O,P=p.AbsolutePosition.y,p.
AbsoluteSize.y,r.AbsoluteSize.y local Q=N+O-P M=M-I M=M<N and N or M>Q and Q or
M M=M-N local R,S=0,k:GetChildren()if S then for T,U in ipairs(S)do if U:IsA
'GuiObject'then R=R+1 end end end local T,U,V=M/(O-P),v,R-(w-1)local W=math.
floor((T*V)+0.5)+U if W<u then U=-U end if W<1 then W=1 end u=W return B(nil)end
)K=s.MouseButton1Up:connect(function()q=tick()s.Parent=nil J:disconnect()J=nil K
:disconnect()drag=nil end)s.Parent=d(p)end end)local G=0 n.MouseButton1Down:
connect(function()return E()end)n.MouseButton1Up:connect(function()q=tick()end)o
.MouseButton1Up:connect(function()q=tick()end)o.MouseButton1Down:connect(
function()return F()end)p.MouseButton1Up:connect(function()q=tick()end)p.
MouseButton1Down:connect(function(H,I)if I>(r.AbsoluteSize.y+r.AbsolutePosition.
y)then return F(I)elseif I<r.AbsolutePosition.y then return E(I)end end)k.
ChildAdded:connect(function()return B(nil)end)k.ChildRemoved:connect(function()
return B(nil)end)k.Changed:connect(function(H)if H=='AbsoluteSize'then return B(
nil)end end)k.AncestryChanged:connect(function()return B(nil)end)return k,n,o,B,
p end local i i=function(j,k,n)if j>k then return j end local o=j while j<=k do
local p=j+math.floor((k-j)/2)if n(p and(o==nil or o<p))then o=p j=p+1 else k=p-1
end end return o end local j j=function(k,n,o)if k>n then return k end local p=n
while k<=n do local q=k+math.floor((n-k)/2)if o(q and(p==nil or p>q))then p=q n=
q-1 else k=q+1 end end return p end local k k=function(n)while(n~=nil)do if n:
IsA'ScreenGui'or n:IsA'BillboardGui'then return n end n=n.Parent end return nil
end b.AutoTruncateTextObject=function(n)local o,p=n.Text,n:Clone()p.Name='Full'
..n.Name p.BorderSizePixel=0 p.BackgroundTransparency=0 p.Text=o p.
TextXAlignment=Enum.TextXAlignment.Center p.Position=UDim2.new(0,-3,0,0)p.Size=
UDim2.new(0,100,1,0)p.Visible=false p.Parent=n local q,r,s,t t=function()if k(n
==nil)then return end n.Text=o if n.TextFits then if r then r:disconnect()r=nil
end if s then s:disconnect()s=nil end else local u=string.len(o)n.Text=o..'~'
local v=i(0,u,function(v)if v==0 then n.Text='~'else n.Text=string.sub(o,1,v)..
'~'end return n.TextFits end)q=string.sub(o,1,v)..'~'n.Text=q if not p.TextFits
then p.Size=UDim2.new(0,10000,1,0)end local w=j(n.AbsoluteSize.X,p.AbsoluteSize.
X,function(w)p.Size=UDim2.new(0,w,1,0)return p.TextFits end)p.Size=UDim2.new(0,w
+6,1,0)if r==nil then r=n.MouseEnter:connect(function()p.ZIndex=n.ZIndex+1 p.
Visible=true end)end if s==nil then s=n.MouseLeave:connect(function()p.Visible=
false end)end end end n.AncestryChanged:connect(t)n.Changed:connect(function(u)
if u=='AbsoluteSize'then return t()end end)t()local u u=function(v)o=v p.Text=o
return t()end return n,u end local n n=function(o,p,q,r)if o then o.Visible=
false if q.Visible==false then q.Size=o.Size q.Position=o.Position end else if q
.Visible==false then q.Size=UDim2.new(0,50,0,50)q.Position=UDim2.new(0.5,-25,0.5
,-25)end end q.Visible=true r.Value=nil local s,t if p then p.Visible=true s=p.
Size t=p.Position p.Visible=false else s=UDim2.new(0,50,0,50)t=UDim2.new(0.5,-25
,0.5,-25)end return q:TweenSizeAndPosition(s,t,Enum.EasingDirection.InOut,Enum.
EasingStyle.Quad,0.3,true,function(u)if u==Enum.TweenStatus.Completed then q.
Visible=false if p then p.Visible=true r.Value=p end end end)end b.
CreateTutorial=function(o,p,q)local r=a('Frame','Tutorial-'..tostring(o),{
BackgroundTransparency=1,Size=UDim2.new(0.6,0,0.6,0),Position=UDim2.new(0.2,0,
0.2,0),a('BoolValue','Buttons',{Value=q})})local s,t,u,v=a('Frame',
'TransitionFrame',{Style=Enum.FrameStyle.RobloxRound,Size=UDim2.new(0.6,0,0.6,0)
,Position=UDim2.new(0.2,0,0.2,0),Visible=false,Parent=r}),a('ObjectValue',
'CurrentTutorialPage',{Value=nil,Parent=r}),a('Frame','Pages',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Parent=r}),nil v=function()
local w,x=nil,u:GetChildren()if x then for y,z in ipairs(x)do if z.Visible then
if w then z.Visible=false else w=z end end end end return w end local w w=
function(x)if x or UserSettings().GameSettings:GetTutorialState(p==false)then
print('Showing tutorial-',p)local y,z=v(),u:FindFirstChild'TutorialPage1'if z
then return n(y,z,s,t)else return error'Could not find TutorialPage1'end end end
local x x=function()local y=v()if y then n(y,nil,s,t)end return UserSettings().
GameSettings:SetTutorialState(p,true)end local y y=function(z)local A,B=u:
FindFirstChild('TutorialPage'..z),v()return n(B,A,s,t)end return r,w,x,y end
local o o=function(p,q,r,s)local t=a('Frame','TutorialPage',{Style=Enum.
FrameStyle.RobloxRound,Size=UDim2.new(0.6,0,0.6,0),Position=UDim2.new(0.2,0,0.2,
0),Visible=false,a('TextButton','NextButton',{Text='Next',TextColor3=Color3.new(
1,1,1),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,Style=Enum.ButtonStyle
.RobloxButtonDefault,Size=UDim2.new(0,80,0,32),Position=UDim2.new(0.5,5,1,-32),
Active=false,Visible=false}),a('TextButton','PrevButton',{Text='Previous',
TextColor3=Color3.new(1,1,1),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size18,
Style=Enum.ButtonStyle.RobloxButton,Size=UDim2.new(0,80,0,32),Position=UDim2.
new(0.5,-85,1,-32),Active=false,Visible=false}),a('TextLabel','Header',{Text=p,
BackgroundTransparency=1,FontSize=Enum.FontSize.Size24,Font=Enum.Font.ArialBold,
TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.TextXAlignment.Center,TextWrap=
true,Size=UDim2.new(1,-55,0,22),Position=UDim2.new(0,0,0,0)})})local u=a(
'ImageButton','SkipButton',{AutoButtonColor=false,BackgroundTransparency=1,Image
='rbxasset://textures/ui/closeButton.png',Size=UDim2.new(0,25,0,25),Position=
UDim2.new(1,-25,0,0),Parent=t})u.MouseButton1Click:connect(function()return r()
end)u.MouseEnter:connect(function()u.Image=
'rbxasset://textures/ui/closeButton_dn.png'end)u.MouseLeave:connect(function()u.
Image='rbxasset://textures/ui/closeButton.png'end)if s then local v=a(
'TextButton','DoneButton',{Style=Enum.ButtonStyle.RobloxButtonDefault,Text=
'Done',TextColor3=Color3.new(1,1,1),Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size18,Size=UDim2.new(0,100,0,50),Position=UDim2.new(0.5,-50,1,-50)})if
r then v.MouseButton1Click:connect(function()return r()end)end v.Parent=t end
local v=a('Frame','ContentFrame',{BackgroundTransparency=1,Position=UDim2.new(0,
0,0,25),Parent=t})if s then v.Size=UDim2.new(1,0,1,-75)else v.Size=UDim2.new(1,0
,1,-22)end local w,x x=function()if t.Visible and t.Parent then local y=math.
min(t.Parent.AbsoluteSize.X,t.Parent.AbsoluteSize.Y)return q(200,y)end end t.
Changed:connect(function(y)if y=='Parent'then if(w~=nil)then w:disconnect()w=nil
end if t.Parent and t.Parent:IsA'GuiObject'then w=t.Parent.Changed:connect(
function(z)if z=='AbsoluteSize'then wait()return x()end end)x()end end if y==
'Visible'then return x()end end)return t,v end b.CreateTextTutorialPage=function
(p,q,r)local s,t,u,v=nil,nil,a('TextLabel',{BackgroundTransparency=1,TextColor3=
Color3.new(1,1,1),Text=q,TextWrap=true,TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Center,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size14,Size=UDim2.new(1,0,1,0)}),nil v=function(w,x)local y=j(w,x,
function(y)s.Size=UDim2.new(0,y,0,y)return u.TextFits end)s.Size=UDim2.new(0,y,0
,y)s.Position=UDim2.new(0.5,-y/2,0.5,-y/2)end s,t=o(p,v,r)u.Parent=t return s
end b.CreateImageTutorialPage=function(p,q,r,s,t,u)local v,w,x,y=nil,nil,a(
'ImageLabel',{BackgroundTransparency=1,Image=q,Size=UDim2.new(0,r,0,s),Position=
UDim2.new(0.5,-r/2,0.5,-s/2)}),nil y=function(z,A)local B=j(z,A,function(B)
return B>=r and B>=s end)if B>=r and B>=s then x.Size=UDim2.new(0,r,0,s)x.
Position=UDim2.new(0.5,-r/2,0.5,-s/2)else if r>s then x.Size=UDim2.new(1,0,s/r,0
)x.Position=UDim2.new(0,0,0.5-(s/r)/2,0)else x.Size=UDim2.new(r/s,0,1,0)x.
Position=UDim2.new(0.5-(r/s)/2,0,0,0)end end B=B+50 v.Size=UDim2.new(0,B,0,B)v.
Position=UDim2.new(0.5,-B/2,0.5,-B/2)end v,w=o(p,y,t,u)x.Parent=w return v end b
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
Name='TutorialPage1'q.Parent=p.Pages end end b.CreateSetPanel=function(p,q,r,s,t
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
', should be of type function!')end if u==nil then u=false end local w,x,y,z,A,B
,C,D,E,F=1,{},{},nil,nil,'NegX','None',nil,nil,{}F.CurrentCategory=nil F.
Category={}local G,H,I={},nil,64 local J,K,L,M=I,nil,nil,game:GetService
'ContentProvider'.BaseUrl:lower()if v then L=M..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&assetversionid=]]K=M..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&assetversionid=]]else L=M..
'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&aid='K=M..
'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&aid='end local N N=function(
O,P)local Q=O:GetChildren()for R=1,#Q do if Q[R]:IsA'GuiObject'then Q[R].ZIndex=
P end N(Q[R],P)end end local O,P,Q=nil,{'Block','Vertical Ramp','Corner Wedge',
'Inverse Corner Wedge','Horizontal Ramp','Auto-Wedge'},{}for R=1,#P do Q[P[R]]=R
-1 end Q[P[#P]]=6 local R R=function()local S,T,U={'NegX','X','NegY','Y','NegZ',
'Z'},{'None','Small','Medium','Strong','Max'},a('Frame','WaterFrame',{Style=Enum
.FrameStyle.RobloxSquare,Size=UDim2.new(0,150,0,110),Visible=false})local V=a(
'TextLabel','WaterForceLabel',{BackgroundTransparency=1,Size=UDim2.new(1,0,0,12)
,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size12,TextColor3=Color3.new(1,
1,1),TextXAlignment=Enum.TextXAlignment.Left,Text='Water Force',Parent=U})local
W=V:Clone()W.Name='WaterForceDirectionLabel'W.Text='Water Force Direction'W.
Position=UDim2.new(0,0,0,50)W.Parent=U E=a('BindableEvent',
'WaterTypeChangedEvent',{Parent=U})local X X=function(Y)B=Y return E:Fire{C,B}
end local Y Y=function(Z)C=Z return E:Fire{C,B}end local Z,_=b.
CreateDropDownMenu(S,X)Z.Size=UDim2.new(1,0,0,25)Z.Position=UDim2.new(0,0,1,3)_
'NegX'Z.Parent=W local aa,ab=b.CreateDropDownMenu(T,Y)ab'None'aa.Size=UDim2.new(
1,0,0,25)aa.Position=UDim2.new(0,0,1,3)aa.Parent=V return U,E end local aa aa=
function()A=a('ScreenGui','SetGui',{a('Frame','SetPanel',{Active=true,
BackgroundTransparency=1,Position=(function()if t then return t else return
UDim2.new(0.2,29,0.1,24)end end)(),Size=(function()if s then return s else
return UDim2.new(0.6,-58,0.64,0)end end)(),Style=Enum.FrameStyle.RobloxRound,
ZIndex=6,Parent=A,a('TextButton','CancelButton',{Position=UDim2.new(1,-32,0,-2),
Size=UDim2.new(0,34,0,34),Style=Enum.ButtonStyle.RobloxButtonDefault,ZIndex=6,
Text='',Modal=true,a('ImageLabel','CancelImage',{BackgroundTransparency=1,Image=
'http://www.roblox.com/asset?id=54135717',Position=UDim2.new(0,-2,0,-2),Size=
UDim2.new(0,16,0,16),ZIndex=6})}),a('Frame','ItemPreview',{
BackgroundTransparency=1,Position=UDim2.new(0.8,5,0.085,0),Size=UDim2.new(0.21,0
,0.9,0),ZIndex=6,a('ImageLabel','LargePreview',{BackgroundTransparency=1,Image=
'',Size=UDim2.new(1,0,0,170),ZIndex=6}),a('Frame','TextPanel',{
BackgroundTransparency=1,Position=UDim2.new(0,0,0.45,0),Size=UDim2.new(1,0,0.55,
0),ZIndex=6,a('TextLabel','RolloverText',{BackgroundTransparency=1,Size=UDim2.
new(1,0,0,48),ZIndex=6,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size24,
Text='',TextColor3=Color3.new(1,1,1),TextWrap=true,TextXAlignment=Enum.
TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})})}),a('Frame',
'Sets',{BackgroundTransparency=1,Position=UDim2.new(0,0,0,5),Size=UDim2.new(0.23
,0,1,-5),ZIndex=6,a('TextLabel','SetsHeader',{BackgroundTransparency=1,Size=
UDim2.new(0,47,0,24),ZIndex=6,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.
Size24,Text='Sets',TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.
TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top}),a('Frame','Line',{
BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.7,BorderSizePixel=0,
Position=UDim2.new(1,-3,0.06,0),Size=UDim2.new(0,3,0.9,0),ZIndex=6})})})})local
ab,S=b.CreateTrueScrollingFrame()ab.Size=UDim2.new(1,-6,0.94,0)ab.Position=UDim2
.new(0,0,0.06,0)ab.BackgroundTransparency=1 ab.Name='SetsLists'ab.ZIndex=6 ab.
Parent=A.SetPanel.Sets N(S,7)return A end local ab ab=function(S)return a(
'TextButton',{Text=(function()if S then return S else return''end end)(),
AutoButtonColor=false,BackgroundTransparency=1,BackgroundColor3=Color3.new(1,1,1
),BorderSizePixel=0,Size=UDim2.new(1,-5,0,18),ZIndex=6,Visible=false,Font=Enum.
Font.Arial,FontSize=Enum.FontSize.Size18,TextColor3=Color3.new(1,1,1),
TextXAlignment=Enum.TextXAlignment.Left})end local S S=function(T,U,V,W,X)local
Y=ab(T)Y.Text=T Y.Name='SetButton'Y.Visible=true a('IntValue','SetId',{Value=U,
Parent=Y})a('StringValue','SetName',{Value=T,Parent=Y})return Y end local T T=
function(U)local X,Y={},0 for Z=1,#U do if not u and U[Z].Name=='Beta'then Y=Y+1
else X[Z-Y]=S(U[Z].Name,U[Z].CategoryId,U[Z].ImageAssetId,Z-Y,#U)end end return
X end local U U=function()wait()local X=A.SetPanel.ItemPreview X.LargePreview.
Size=UDim2.new(1,0,0,X.AbsoluteSize.X)X.LargePreview.Position=UDim2.new(0.5,-X.
LargePreview.AbsoluteSize.X/2,0,0)X.TextPanel.Position=UDim2.new(0,0,0,X.
LargePreview.AbsoluteSize.Y)X.TextPanel.Size=UDim2.new(1,0,0,X.AbsoluteSize.Y-X.
LargePreview.AbsoluteSize.Y)end local X X=function()local Y=a('Frame',
'InsertAssetButtonExample',{Position=UDim2.new(0,128,0,64),Size=UDim2.new(0,64,0
,64),BackgroundTransparency=1,ZIndex=6,Visible=false,a('IntValue','AssetId',{
Value=0}),a('StringValue','AssetName',{Value=''})})local Z=a('TextButton',
'Button',{Text='',Style=Enum.ButtonStyle.RobloxButton,Position=UDim2.new(0.025,0
,0.025,0),Size=UDim2.new(0.95,0,0.95,0),ZIndex=6,Parent=Y})local _=a(
'ImageLabel','ButtonImage',{Image='',Position=UDim2.new(0,-7,0,-7),Size=UDim2.
new(1,14,1,14),BackgroundTransparency=1,ZIndex=7,Parent=Z})local ac=_:clone()ac.
Name='ConfigIcon'ac.Visible=false ac.Position=UDim2.new(1,-23,1,-24)ac.Size=
UDim2.new(0,16,0,16)ac.Image=''ac.ZIndex=6 ac.Parent=Y return Y end local ac ac=
function(Y)if Y:FindFirstChild'AssetId'then delay(0,function()game:GetService
'ContentProvider':Preload(L..tostring(Y.AssetId.Value))A.SetPanel.ItemPreview.
LargePreview.Image='LargeThumbnailUrl'..tostring(Y.AssetId.Value)end)end if Y:
FindFirstChild'AssetName'then A.SetPanel.ItemPreview.TextPanel.RolloverText.Text
=Y.AssetName.Value end end local Y Y=function(Z)if O then return q(tostring(O.
AssetName.Value),tonumber(O.AssetId.Value),Z)end end local Z Z=function(_,ad)
local ae=a('TextButton',tostring(_)..'Button',{Font=Enum.Font.ArialBold,FontSize
=Enum.FontSize.Size14,BorderSizePixel=0,TextColor3=Color3.new(1,1,1),Text=_,
TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ZIndex=ad.
ZIndex+1,Size=UDim2.new(0,ad.Size.X.Offset-2,0,16),Position=UDim2.new(0,1,0,0)})
ae.MouseEnter:connect(function()ae.BackgroundTransparency=0 ae.TextColor3=Color3
.new(0,0,0)end)ae.MouseLeave:connect(function()ae.BackgroundTransparency=1 ae.
TextColor3=Color3.new(1,1,1)end)ae.MouseButton1Click:connect(function()ae.
BackgroundTransparency=1 ae.TextColor3=Color3.new(1,1,1)if ae.Parent and ae.
Parent:IsA'GuiObject'then ae.Parent.Visible=false end return Y(Q[ae.Text])end)
return ae end local ad ad=function(ae)local _=a('Frame','TerrainDropDown',{
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(1,0,0),Size=UDim2.
new(0,200,0,0),Visible=false,ZIndex=ae,Parent=A})for af=1,#P do local ag=Z(P[af]
,_)ag.Position=UDim2.new(0,1,0,(af-1)*ag.Size.Y.Offset)ag.Parent=_ _.Size=UDim2.
new(0,200,0,_.Size.Y.Offset+ag.Size.Y.Offset)end return _.MouseLeave:connect(
function()_.Visible=false end)end local ae ae=function(af)local ag=a(
'ImageButton','DropDownButton',{Image='http://www.roblox.com/asset/?id=67581509'
,BackgroundTransparency=1,Size=UDim2.new(0,16,0,16),Position=UDim2.new(1,-24,0,6
),ZIndex=af.ZIndex+2,Parent=af})if not A:FindFirstChild'TerrainDropDown'then ad(
8)end return ag.MouseButton1Click:connect(function()A.TerrainDropDown.Visible=
true A.TerrainDropDown.Position=UDim2.new(0,af.AbsolutePosition.X,0,af.
AbsolutePosition.Y)O=af end)end local af af=function()local ag=X()ag.Name=
'InsertAssetButton'ag.Visible=true if F.Category[F.CurrentCategory].SetName==
'High Scalability'then ae(ag)end local _ local ah=ag.MouseEnter:connect(function
()_=ag return delay(0.1,function()if _==ag then return ac(ag)end end)end)return
ag,ah end local ag ag=function(ah)local _,ai=0,0 for aj=1,#x do x[aj].Position=
UDim2.new(0,I*_,0,J*ai)_=_+1 if _>=ah then _=0 ai=ai+1 end end end local ah ah=
function(ai,aj,_,ak)if aj then ai.AssetName.Value=_ ai.AssetId.Value=ak local al
=K..ak if al~=ai.Button.ButtonImage.Image then delay(0,function()game:GetService
'ContentProvider':Preload(K..ak)ai.Button.ButtonImage.Image=K..ak end)end table.
insert(y,ai.Button.MouseButton1Click:connect(function()local am=(_=='Water')and(
F.Category[F.CurrentCategory].SetName=='High Scalability')D.Visible=am if am
then return q(_,tonumber(ak,nil))else return q(_,tonumber(ak))end end))ai.
Visible=true else ai.Visible=false end end local ai ai=function(aj,ak,al)local
am=ak*al if w>#z then return end local _=w for an=1,am+1 do if w>=#z+1 then
break end local ao x[w],ao=af()table.insert(y,ao)x[w].Parent=aj.SetPanel.
ItemsFrame w=w+1 end ag(al)for an=_,w do if x[an]then if z[an]then if z[an].Name
=='Water'then if F.Category[F.CurrentCategory].SetName=='High Scalability'then x
[an]:FindFirstChild('DropDownButton',true):Destroy()end end local ao if v then
ao=z[an].AssetVersionId else ao=z[an].AssetId end ah(x[an],true,z[an].Name,ao)
else break end else break end end end local aj aj=function()F.Category[F.
CurrentCategory].Index=0 local ak,al=7,math.floor(A.SetPanel.ItemsFrame.
AbsoluteSize.X/I)z=F.Category[F.CurrentCategory].Contents if z then for am=1,#x
do x[am]:remove()end for am=1,#y do if y[am]then y[am]:disconnect()end end y={}x
={}w=1 return ai(A,ak,al)end end local ak ak=function(al,am,an,ao)if al and(F.
Category[F.CurrentCategory]~=nil)then if al~=F.Category[F.CurrentCategory].
Button then F.Category[F.CurrentCategory].Button=al if G[an]==nil then G[an]=
game:GetService'InsertService':GetCollection(an)end F.Category[F.CurrentCategory
].Contents=G[an]F.Category[F.CurrentCategory].SetName=am F.Category[F.
CurrentCategory].SetId=an end return aj()end end local al al=function(am,an)if
am~=F.CurrentCategory then if F.CurrentCategory then for ao,_ in pairs(F.
CurrentCategory)do _.Visible=false end end F.CurrentCategory=am if F.Category[F.
CurrentCategory]==nil then F.Category[F.CurrentCategory]={}if#am>0 then return
ak(am[1],am[1].SetName.Value,am[1].SetId.Value,0)end else F.Category[F.
CurrentCategory].Button=nil return ak(F.Category[F.CurrentCategory].ButtonFrame,
F.Category[F.CurrentCategory].SetName,F.Category[F.CurrentCategory].SetId,F.
Category[F.CurrentCategory].Index)end end end local am am=function(an)return al(
an,0)end local an an=function()local ao=A.SetPanel.Sets.SetsLists:GetChildren()
for _=1,#ao do if ao[_]:IsA'TextButton'then ao[_].Selected=false ao[_].
BackgroundTransparency=1 ao[_].TextColor3=Color3.new(1,1,1)ao[_].
BackgroundColor3=Color3.new(1,1,1)end end end local ao ao=function()local _=0
for ap=1,#H do local aq=H[ap]aq.Visible=true aq.Position=UDim2.new(0,5,0,_*aq.
Size.Y.Offset)aq.Parent=A.SetPanel.Sets.SetsLists if ap==1 then aq.Selected=true
aq.BackgroundColor3=Color3.new(0,0.8,0)aq.TextColor3=Color3.new(0,0,0)aq.
BackgroundTransparency=0 end aq.MouseEnter:connect(function()if not aq.Selected
then aq.BackgroundTransparency=0 aq.TextColor3=Color3.new(0,0,0)end end)aq.
MouseLeave:connect(function()if not aq.Selected then aq.BackgroundTransparency=1
aq.TextColor3=Color3.new(1,1,1)end end)aq.MouseButton1Click:connect(function()
an()aq.Selected=not aq.Selected aq.BackgroundColor3=Color3.new(0,0.8,0)aq.
TextColor3=Color3.new(0,0,0)aq.BackgroundTransparency=0 return ak(aq,aq.Text,H[
ap].SetId.Value,0)end)_=_+1 end local ap=A.SetPanel.Sets.SetsLists:GetChildren()
if ap then for aq=1,#ap do if ap[aq]:IsA'TextButton'then ak(ap[aq],ap[aq].Text,H
[aq].SetId.Value,0)am(H)break end end end end A=aa()D,E=R()D.Position=UDim2.new(
0,55,0,0)D.Parent=A A.Changed:connect(function(ap)if ap=='AbsoluteSize'then U()
return aj()end end)local ap,aq=b.CreateTrueScrollingFrame()ap.Size=UDim2.new(
0.54,0,0.85,0)ap.Position=UDim2.new(0.24,0,0.085,0)ap.Name='ItemsFrame'ap.ZIndex
=6 ap.Parent=A.SetPanel ap.BackgroundTransparency=1 N(aq,7)aq.Parent=A.SetPanel
aq.Position=UDim2.new(0.76,5,0,0)local _=false aq.ScrollBottom.Changed:connect(
function(ar)if aq.ScrollBottom.Value==true then if _ then return end _=true ai(A
,rows,columns)_=false end end)local ar={}for as=1,#p do local at=game:GetService
'InsertService':GetUserSets(p[as])if at and#at>2 then for au=3,#at do if at[au].
Name=='High Scalability'then table.insert(ar,1,at[au])else table.insert(ar,at[au
])end end end end if ar then H=T(ar)end rows=math.floor(A.SetPanel.ItemsFrame.
AbsoluteSize.Y/J)columns=math.floor(A.SetPanel.ItemsFrame.AbsoluteSize.X/I)ao()A
.SetPanel.CancelButton.MouseButton1Click:connect(function()A.SetPanel.Visible=
false if r~=nil then return r()end return nil end)local as as=function(at)if at
then A.SetPanel.Visible=true else A.SetPanel.Visible=false end end local at at=
function()if A and A:FindFirstChild'SetPanel'then return A.SetPanel.Visible end
return false end return A,as,at,E end b.CreateTerrainMaterialSelector=function(
aa,ab)local ac=Instance.new'BindableEvent'ac.Name=
'TerrainMaterialSelectionChanged'local ad,ae=nil,a('Frame',
'TerrainMaterialSelector',{Size=(function()if aa then return aa else return
UDim2.new(0,245,0,230)end end)(),BorderSizePixel=0,BackgroundColor3=Color3.new(0
,0,0),Active=true})if ab then ae.Position=ab end ac.Parent=ae local af,ag,ah,ai=
{},{'Grass','Sand','Brick','Granite','Asphalt','Iron','Aluminum','Gold','Plank',
'Log','Gravel','Cinder Block','Stone Wall','Concrete','Plastic (red)',
'Plastic (blue)','Water'},1,nil ai=function(aj)if'Grass'==aj then return 1
elseif'Sand'==aj then return 2 elseif'Erase'==aj then return 0 elseif'Brick'==aj
then return 3 elseif'Granite'==aj then return 4 elseif'Asphalt'==aj then return
5 elseif'Iron'==aj then return 6 elseif'Aluminum'==aj then return 7 elseif'Gold'
==aj then return 8 elseif'Plank'==aj then return 9 elseif'Log'==aj then return
10 elseif'Gravel'==aj then return 11 elseif'Cinder Block'==aj then return 12
elseif'Stone Wall'==aj then return 13 elseif'Concrete'==aj then return 14 elseif
'Plastic (red)'==aj then return 15 elseif'Plastic (blue)'==aj then return 16
elseif'Water'==aj then return 17 end end local aj aj=function(ak)if Enum.
CellMaterial.Grass==ak or 1==ak then return'Grass'elseif Enum.CellMaterial.Sand
==ak or 2==ak then return'Sand'elseif Enum.CellMaterial.Empty==ak or 0==ak then
return'Erase'elseif Enum.CellMaterial.Brick==ak or 3==ak then return'Brick'
elseif Enum.CellMaterial.Granite==ak or 4==ak then return'Granite'elseif Enum.
CellMaterial.Asphalt==ak or 5==ak then return'Asphalt'elseif Enum.CellMaterial.
Iron==ak or 6==ak then return'Iron'elseif Enum.CellMaterial.Aluminum==ak or 7==
ak then return'Aluminum'elseif Enum.CellMaterial.Gold==ak or 8==ak then return
'Gold'elseif Enum.CellMaterial.WoodPlank==ak or 9==ak then return'Plank'elseif
Enum.CellMaterial.WoodLog==ak or 10==ak then return'Log'elseif Enum.CellMaterial
.Gravel==ak or 11==ak then return'Gravel'elseif Enum.CellMaterial.CinderBlock==
ak or 12==ak then return'Cinder Block'elseif Enum.CellMaterial.MossyStone==ak or
13==ak then return'Stone Wall'elseif Enum.CellMaterial.Cement==ak or 14==ak then
return'Concrete'elseif Enum.CellMaterial.RedPlastic==ak or 15==ak then return
'Plastic (red)'elseif Enum.CellMaterial.BluePlastic==ak or 16==ak then return
'Plastic (blue)'elseif Enum.CellMaterial.Water==ak or 17==ak then return'Water'
end end local ak ak=function(al)ah=ai(al)return ac:Fire(ah)end for al,am in
pairs(ag)do af[am]={}af[am].Regular='http://www.roblox.com/asset/?id='..(
function()if'Grass'==am then return'56563112'elseif'Sand'==am then return
'62356652'elseif'Brick'==am then return'65961537'elseif'Granite'==am then return
'67532153'elseif'Asphalt'==am then return'67532038'elseif'Iron'==am then return
'67532093'elseif'Aluminum'==am then return'67531995'elseif'Gold'==am then return
'67532118'elseif'Plastic (red)'==am then return'67531848'elseif'Plastic (blue)'
==am then return'67531924'elseif'Plank'==am then return'67532015'elseif'Log'==am
then return'67532051'elseif'Gravel'==am then return'67532206'elseif
'Cinder Block'==am then return'67532103'elseif'Stone Wall'==am then return
'67531804'elseif'Concrete'==am then return'67532059'elseif'Water'==am then
return'81407474'else return'66887593'end end)()end local an,ao,ap,aq=b.
CreateScrollingFrame(nil,'grid')an.Size=UDim2.new(0.85,0,1,0)an.Position=UDim2.
new(0,0,0,0)an.Parent=ae ao.Parent=ae ao.Visible=true ao.Position=UDim2.new(1,-
19,0,0)ap.Parent=ae ap.Visible=true ap.Position=UDim2.new(1,-19,1,-17)local ar
ar=function(as,at)ak(at)as.BackgroundTransparency=0 ad.BackgroundTransparency=1
ad=as end local as as=function(at)local au=a('TextButton',tostring(at),{Text='',
Size=UDim2.new(0,32,0,32),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,
BackgroundTransparency=1,AutoButtonColor=false,a('NumberValue','EnumType',{Value
=0})})local p=a('ImageButton',tostring(at),{AutoButtonColor=false,
BackgroundTransparency=1,Size=UDim2.new(0,30,0,30),Position=UDim2.new(0,1,0,1),
Parent=au,Image=af[at].Regular})p.MouseEnter:connect(function()au.
BackgroundTransparency=0 end)p.MouseLeave:connect(function()if ad~=au then au.
BackgroundTransparency=1 end end)p.MouseButton1Click:connect(function()if ad~=au
then return ar(au,tostring(at))end end)return au end for at=1,#ag do local au=
as(ag[at])if ag[at]=='Grass'then ad=au au.BackgroundTransparency=0 end au.Parent
=an end local at at=function(au)if not au then return end if ah==au then return
end local p,q=aj(au),an:GetChildren()for r=1,#q do if q[r].Name==
'Plastic (blue)'and p=='Plastic (blue)'then ar(q[r],p)return end if q[r].Name==
'Plastic (red)'and p=='Plastic (red)'then ar(q[r],p)return end if string.find(q[
r].Name,p)then ar(q[r],p)return end end end ae.Changed:connect(function(au)if au
=='AbsoluteSize'then return aq()end end)aq()return ae,ac,at end b.
CreateLoadingFrame=function(aa,ab,ac)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=35238053'local ad=a('Frame','LoadingFrame',{
Style=Enum.FrameStyle.RobloxRound,Size=(function()if ab then return ab else
return UDim2.new(0,300,0,160)end end)(),Position=(function()if ac then return ac
else return UDim2.new(0.5,-150,0.5,-80)end end)(),a('TextLabel','loadingName',{
BackgroundTransparency=1,Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,2),
Font=Enum.Font.Arial,Text=aa,TextColor3=Color3.new(1,1,1),TextStrokeTransparency
=1,FontSize=Enum.FontSize.Size18})})local ae=a('Frame','LoadingBar',{
BackgroundColor3=Color3.new(0,0,0),BorderColor3=Color3.new(0.30980392156862746,
0.30980392156862746,0.30980392156862746),Position=UDim2.new(0,0,0,41),Size=UDim2
.new(1,0,0,30),Parent=ad})local af,ag,ah=a('ImageLabel','LoadingGreenBar',{Image
='http://www.roblox.com/asset/?id=35238053',Position=UDim2.new(0,0,0,0),Size=
UDim2.new(0,0,1,0),Visible=false,Parent=ae}),a('TextLabel','LoadingPercent',{
BackgroundTransparency=1,Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,14),
Font=Enum.Font.Arial,Text='0%',FontSize=Enum.FontSize.Size14,TextColor3=Color3.
new(1,1,1),Parent=ae}),a('TextButton','CancelButton',{Position=UDim2.new(0.5,-60
,1,-40),Size=UDim2.new(0,120,0,40),Font=Enum.Font.Arial,FontSize=Enum.FontSize.
Size18,TextColor3=Color3.new(1,1,1),Text='Cancel',Style=Enum.ButtonStyle.
RobloxButton,Parent=ad})local ai=a('BindableEvent','CancelButtonClicked',{Parent
=ah})ah.MouseButton1Click:connect(function()return ai:Fire()end)local aj aj=
function(ak,al,am)if ak and type(ak~='number')then error(
'updateLoadingGuiPercent expects number as argument, got '..tostring(type(ak))..
' instead')end local an if ak<0 then an=UDim2.new(0,0,1,0)elseif ak>1 then an=
UDim2.new(1,0,1,0)else an=UDim2.new(ak,0,1,0)end if al then if not am then error
[[updateLoadingGuiPercent is set to tween new percentage, but got no tween time length! Please pass this in as third argument]]
end if an.X.Scale>0 then af.Visible=true return af:TweenSize(an,Enum.
EasingDirection.Out,Enum.EasingStyle.Quad,am,true)else return af:TweenSize(an,
Enum.EasingDirection.Out,Enum.EasingStyle.Quad,am,true,function()if an.X.Scale<0
then af.Visible=false end end)end else af.Size=an af.Visible=(an.X.Scale>0)end
end af.Changed:connect(function(ak)if ak=='Size'then ag.Text=tostring(math.ceil(
af.Size.X.Scale*100))..'%'end end)return ad,aj,ai end b.CreatePluginFrame=
function(aa,ab,ac,ad,ae)local af af=function(ag,ah,ai,aj,ak,al)local am=a(
'TextButton',ak,{AutoButtonColor=false,BackgroundTransparency=1,Position=ah,Size
=ag,Font=Enum.Font.ArialBold,FontSize=aj,Text=ai,TextColor3=Color3.new(1,1,1),
BorderSizePixel=0,BackgroundColor3=Color3.new(7.8431372549019605E-2,
7.8431372549019605E-2,7.8431372549019605E-2)})am.MouseEnter:connect(function()if
am.Selected then return end am.BackgroundTransparency=0 end)am.MouseLeave:
connect(function()if am.Selected then return end am.BackgroundTransparency=1 end
)am.Parent=al return am end local ag=a('Frame',tostring(aa)..'DragBar',{
BackgroundColor3=Color3.new(0.15294117647058825,0.15294117647058825,
0.15294117647058825),BorderColor3=Color3.new(0,0,0),Size=(function()if ab then
return UDim2.new(ab.X.Scale,ab.X.Offset,0,20)+UDim2.new(0,20,0,0)else return
UDim2.new(0,183,0,20)end end)(),Active=true,Draggable=true})if ac then ag.
Position=ac end ag.MouseEnter:connect(function()ag.BackgroundColor3=Color3.new(
0.19215686274509805,0.19215686274509805,0.19215686274509805)end)ag.MouseLeave:
connect(function()ag.BackgroundColor3=Color3.new(0.15294117647058825,
0.15294117647058825,0.15294117647058825)end)ag.Parent=ae a('TextLabel',
'BarNameLabel',{Text=' '..tostring(aa),TextColor3=Color3.new(1,1,1),
TextStrokeTransparency=0,Size=UDim2.new(1,0,1,0),Font=Enum.Font.ArialBold,
FontSize=Enum.FontSize.Size18,TextXAlignment=Enum.TextXAlignment.Left,
BackgroundTransparency=1,Parent=ag})local ah=af(UDim2.new(0,15,0,17),UDim2.new(1
,-16,0.5,-8),'X',Enum.FontSize.Size14,'CloseButton',ag)local ai=a(
'BindableEvent','CloseEvent',{Parent=ah})ah.MouseButton1Click:connect(function()
ai:Fire()ah.BackgroundTransparency=1 end)local aj,ak=af(UDim2.new(0,15,0,17),
UDim2.new(1,-51,0.5,-8),'?',Enum.FontSize.Size14,'HelpButton',ag),a('Frame',
'HelpFrame',{BackgroundColor3=Color3.new(0,0,0),Size=UDim2.new(0,300,0,552),
Position=UDim2.new(1,5,0,0),Active=true,BorderSizePixel=0,Visible=false,Parent=
ag})aj.MouseButton1Click:connect(function()ak.Visible=not ak.Visible if ak.
Visible then aj.Selected=true aj.BackgroundTransparency=0 local al=d(ak)if al
then if ak.AbsolutePosition.X+ak.AbsoluteSize.X>al.AbsoluteSize.X then ak.
Position=UDim2.new(0,-5-ak.AbsoluteSize.X,0,0)else ak.Position=UDim2.new(1,5,0,0
)end else ak.Position=UDim2.new(1,5,0,0)end else aj.Selected=false aj.
BackgroundTransparency=1 end end)local al=af(UDim2.new(0,16,0,17),UDim2.new(1,-
34,0.5,-8),'-',Enum.FontSize.Size14,'MinimizeButton',ag)al.TextYAlignment=Enum.
TextYAlignment.Top local am=a('Frame','MinimizeFrame',{BackgroundColor3=Color3.
new(0.28627450980392155,0.28627450980392155,0.28627450980392155),BorderColor3=
Color3.new(0,0,0),Position=UDim2.new(0,0,1,0),Size=(function()if ab then return
UDim2.new(ab.X.Scale,ab.X.Offset,0,50)+UDim2.new(0,20,0,0)else return UDim2.new(
0,183,0,50)end end)(),Visible=false,Parent=ag})local an,ao=a('TextButton',
'MinimizeButton',{Position=UDim2.new(0.5,-50,0.5,-20),Size=UDim2.new(0,100,0,40)
,Style=Enum.ButtonStyle.RobloxButton,Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size18,TextColor3=Color3.new(1,1,1),Text='Show',Parent=am}),a('Frame',
'SeparatingLine',{BackgroundColor3=Color3.new(0.45098039215686275,
0.45098039215686275,0.45098039215686275),BorderSizePixel=0,Position=UDim2.new(1,
-18,0.5,-7),Size=UDim2.new(0,1,0,14),Parent=ag})local ap=ao:clone()ap.Position=
UDim2.new(1,-35,0.5,-7)ap.Parent=ag local aq=a('Frame','WidgetContainer',{
BackgroundTransparency=1,Position=UDim2.new(0,0,1,0),BorderColor3=Color3.new(0,0
,0)})if not ad then aq.BackgroundTransparency=0 aq.BackgroundColor3=Color3.new(
0.2823529411764706,0.2823529411764706,0.2823529411764706)end aq.Parent=ag if ab
then if ad then aq.Size=ab else aq.Size=UDim2.new(0,ag.AbsoluteSize.X,ab.Y.Scale
,ab.Y.Offset)end else if ad then aq.Size=UDim2.new(0,163,0,400)else aq.Size=
UDim2.new(0,ag.AbsoluteSize.X,0,400)end end if ac then aq.Position=aq.Position+
UDim2.new(0,0,0,20)end local ar,as,at if ad then ar,as=b.
CreateTrueScrollingFrame()ar.Size=UDim2.new(1,0,1,0)ar.BackgroundColor3=Color3.
new(0.2823529411764706,0.2823529411764706,0.2823529411764706)ar.BorderColor3=
Color3.new(0,0,0)ar.Active=true ar.Parent=aq as.Parent=ag as.BackgroundColor3=
Color3.new(0.2823529411764706,0.2823529411764706,0.2823529411764706)as.
BorderSizePixel=0 as.BackgroundTransparency=0 as.Position=UDim2.new(1,-21,1,1)if
ab then as.Size=UDim2.new(0,21,ab.Y.Scale,ab.Y.Offset)else as.Size=UDim2.new(0,
21,0,400)end as:FindFirstChild'ScrollDownButton'.Position=UDim2.new(0,0,1,-20)a(
'Frame','FakeLine',{BorderSizePixel=0,BackgroundColor3=Color3.new(0,0,0),Size=
UDim2.new(0,1,1,1),Position=UDim2.new(1,0,0,0),Parent=as})at=a('TextButton',
'VerticalDragger',{ZIndex=2,AutoButtonColor=false,BackgroundColor3=Color3.new(
0.19607843137254902,0.19607843137254902,0.19607843137254902),BorderColor3=Color3
.new(0,0,0),Size=UDim2.new(1,20,0,20),Position=UDim2.new(0,0,1,0),Active=true,
Text='',Parent=aq})local au=a('Frame','ScrubFrame',{BackgroundColor3=Color3.new(
1,1,1),BorderSizePixel=0,Position=UDim2.new(0.5,-5,0.5,0),Size=UDim2.new(0,10,0,
1),ZIndex=5,Parent=at})local p=au:clone()p.Position=UDim2.new(0.5,-5,0.5,-2)p.
Parent=at local q=au:clone()q.Position=UDim2.new(0.5,-5,0.5,2)q.Parent=at local
r,s,t=a('TextButton','AreaSoak',{Size=UDim2.new(1,0,1,0),BackgroundTransparency=
1,BorderSizePixel=0,Text='',ZIndex=10,Visible=false,Active=true,Parent=d(ae)}),
false,nil at.MouseEnter:connect(function()at.BackgroundColor3=Color3.new(
0.23529411764705882,0.23529411764705882,0.23529411764705882)end)at.MouseLeave:
connect(function()at.BackgroundColor3=Color3.new(0.19607843137254902,
0.19607843137254902,0.19607843137254902)end)at.MouseButton1Down:connect(function
(u,v)s=true r.Visible=true t=v end)r.MouseButton1Up:connect(function()s=false r.
Visible=false end)r.MouseMoved:connect(function(u,v)if not s then return end
local w=v-t if not as.ScrollDownButton.Visible and w>0 then return end if(aq.
Size.Y.Offset+w)<150 then aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,aq.
Size.Y.Scale,150)as.Size=UDim2.new(0,21,0,150)return end t=v if aq.Size.Y.Offset
+w>=0 then aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,aq.Size.Y.Scale,aq
.Size.Y.Offset+w)as.Size=UDim2.new(0,21,0,as.Size.Y.Offset+w)end end)end local
au au=function()am.Visible=not am.Visible if ad then ar.Visible=not ar.Visible
at.Visible=not at.Visible as.Visible=not as.Visible else aq.Visible=not aq.
Visible end if am.Visible then al.Text='+'else al.Text='-'end end an.
MouseButton1Click:connect(function()return au()end)al.MouseButton1Click:connect(
function()return au()end)if ad then return ag,ar,ak,ai else return ag,aq,ak,ai
end end b.Help=function(aa)if aa=='CreatePropertyDropDownMenu'or aa==b.
CreatePropertyDropDownMenu then return
[[Function CreatePropertyDropDownMenu. Arguments: (instance, propertyName, enumType). Side effect: returns a container with a drop-down-box that is linked to the 'property' field of 'instance' which is of type 'enumType']]
elseif aa=='CreateDropDownMenu'or aa==b.CreateDropDownMenu then return
[[Function CreateDropDownMenu. Arguments: (items, onItemSelected). Side effect: Returns 2 results, a container to the gui object and a 'updateSelection' function for external updating. The container is a drop-down-box created around a list of items]]
elseif aa=='CreateMessageDialog'or aa==b.CreateMessageDialog then return
[[Function CreateMessageDialog. Arguments: (title, message, buttons). Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in. 'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button]]
elseif aa=='CreateStyledMessageDialog'or aa==b.CreateStyledMessageDialog then
return
[[Function CreateStyledMessageDialog. Arguments: (title, message, style, buttons). Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in. 'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button, 'style' is a string, either Error, Notify or Confirm]]
elseif aa=='GetFontHeight'or aa==b.GetFontHeight then return
[[Function GetFontHeight. Arguments: (font, fontSize). Side effect: returns the size in pixels of the given font + fontSize]]
elseif aa=='CreateScrollingFrame'or aa==b.CreateScrollingFrame then return
[[Function CreateScrollingFrame. Arguments: (orderList, style) Side effect: returns 4 objects, (scrollFrame, scrollUpButton, scrollDownButton, recalculateFunction). 'scrollFrame' can be filled with GuiObjects. It will lay them out and allow scrollUpButton/scrollDownButton to interact with them. Orderlist is optional (and specifies the order to layout the children. Without orderlist, it uses the children order. style is also optional, and allows for a 'grid' styling if style is passed 'grid' as a string. recalculateFunction can be called when a relayout is needed (when orderList changes)]]
elseif aa=='CreateTrueScrollingFrame'or aa==b.CreateTrueScrollingFrame then
return
[[Function CreateTrueScrollingFrame. Arguments: (nil) Side effect: returns 2 objects, (scrollFrame, controlFrame). 'scrollFrame' can be filled with GuiObjects, and they will be clipped if not inside the frame's bounds. controlFrame has children scrollup and scrolldown, as well as a slider. controlFrame can be parented to any guiobject and it will readjust itself to fit.]]
elseif aa=='AutoTruncateTextObject'or aa==b.AutoTruncateTextObject then return
[[Function AutoTruncateTextObject. Arguments: (textLabel) Side effect: returns 2 objects, (textLabel, changeText). The 'textLabel' input is modified to automatically truncate text (with ellipsis), if it gets too small to fit. 'changeText' is a function that can be used to change the text, it takes 1 string as an argument]]
elseif aa=='CreateSlider'or aa==b.CreateSlider then return
[[Function CreateSlider. Arguments: (steps, width, position) Side effect: returns 2 objects, (sliderGui, sliderPosition). The 'steps' argument specifies how many different positions the slider can hold along the bar. 'width' specifies in pixels how wide the bar should be (modifiable afterwards if desired). 'position' argument should be a UDim2 for slider positioning. 'sliderPosition' is an IntValue whose current .Value specifies the specific step the slider is currently on.]]
elseif aa=='CreateLoadingFrame'or aa==b.CreateLoadingFrame then return
[[Function CreateLoadingFrame. Arguments: (name, size, position) Side effect: Creates a gui that can be manipulated to show progress for a particular action. Name appears above the loading bar, and size and position are udim2 values (both size and position are optional arguments). Returns 3 arguments, the first being the gui created. The second being updateLoadingGuiPercent, which is a bindable function. This function takes one argument (two optionally), which should be a number between 0 and 1, representing the percentage the loading gui should be at. The second argument to this function is a boolean value that if set to true will tween the current percentage value to the new percentage value, therefore our third argument is how long this tween should take. Our third returned argument is a BindableEvent, that when fired means that someone clicked the cancel button on the dialog.]]
elseif aa=='CreateTerrainMaterialSelector'or aa==b.CreateTerrainMaterialSelector
then return
[[Function CreateTerrainMaterialSelector. Arguments: (size, position) Side effect: Size and position are UDim2 values that specifies the selector's size and position. Both size and position are optional arguments. This method returns 3 objects (terrainSelectorGui, terrainSelected, forceTerrainSelection). terrainSelectorGui is just the gui object that we generate with this function, parent it as you like. TerrainSelected is a BindableEvent that is fired whenever a new terrain type is selected in the gui. ForceTerrainSelection is a function that takes an argument of Enum.CellMaterial and will force the gui to show that material as currently selected.]]
end end return b