local a={}local function ScopedConnect(b,c,d,e,f,g)local h=nil local i=function(
)if game:IsAncestorOf(b)then if not h then h=c[d]:connect(e)if f then f()end end
else if h then h:disconnect()if g then g()end end end end local j=b.
AncestryChanged:connect(i)i()return j end local function getScreenGuiAncestor(b)
local c=b while c and not c:IsA'ScreenGui'do c=c.Parent end return c end
local function CreateButtons(b,c,d,e)local f,g=1,{}for h,i in ipairs(c)do local
j=Instance.new'TextButton'j.Name='Button'..f j.Font=Enum.Font.Arial j.FontSize=
Enum.FontSize.Size18 j.AutoButtonColor=true j.Modal=true if i['Style']then j.
Style=i.Style else j.Style=Enum.ButtonStyle.RobloxButton end j.Text=i.Text j.
TextColor3=Color3.new(1,1,1)j.MouseButton1Click:connect(i.Function)j.Parent=b g[
f]=j f=f+1 end local j=f-1 if j==1 then b.Button1.Position=UDim2.new(0.35,0,d.
Scale,d.Offset)b.Button1.Size=UDim2.new(0.4,0,e.Scale,e.Offset)elseif j==2 then
b.Button1.Position=UDim2.new(0.1,0,d.Scale,d.Offset)b.Button1.Size=UDim2.new(
0.26666666666666666,0,e.Scale,e.Offset)b.Button2.Position=UDim2.new(0.55,0,d.
Scale,d.Offset)b.Button2.Size=UDim2.new(0.35,0,e.Scale,e.Offset)elseif j>=3 then
local k,l=0.1/j,0.9/j f=1 while f<=j do g[f].Position=UDim2.new(k*f+(f-1)*l,0,d.
Scale,d.Offset)g[f].Size=UDim2.new(l,0,e.Scale,e.Offset)f=f+1 end end end
local function setSliderPos(b,c,d,e,f)local g,h=f-1,math.min(1,math.max(0,(b-e.
AbsolutePosition.X)/e.AbsoluteSize.X))local i,j=math.modf(h*g)if j>0.5 then i=i+
1 end h=i/g local k=math.ceil(h*g)if d.Value~=(k+1)then d.Value=k+1 c.Position=
UDim2.new(h,-c.AbsoluteSize.X/2,c.Position.Y.Scale,c.Position.Y.Offset)end end
local function cancelSlide(b)b.Visible=false if areaSoakMouseMoveCon then
areaSoakMouseMoveCon:disconnect()end end a.CreateStyledMessageDialog=function(b,
c,d,e)local f=Instance.new'Frame'f.Size=UDim2.new(0.5,0,0,165)f.Position=UDim2.
new(0.25,0,0.5,-72.5)f.Name='MessageDialog'f.Active=true f.Style=Enum.FrameStyle
.RobloxRound local g=Instance.new'ImageLabel'g.Name='StyleImage'g.
BackgroundTransparency=1 g.Position=UDim2.new(0,5,0,15)if d=='error'or d==
'Error'then g.Size=UDim2.new(0,71,0,71)g.Image=
'http://www.roblox.com/asset?id=42565285'elseif d=='notify'or d=='Notify'then g.
Size=UDim2.new(0,71,0,71)g.Image='http://www.roblox.com/asset?id=42604978'elseif
d=='confirm'or d=='Confirm'then g.Size=UDim2.new(0,74,0,76)g.Image=
'http://www.roblox.com/asset?id=42557901'else return a.CreateMessageDialog(b,c,e
)end g.Parent=f local h=Instance.new'TextLabel'h.Name='Title'h.Text=b h.
TextStrokeTransparency=0 h.BackgroundTransparency=1 h.TextColor3=Color3.new(
0.8666666666666667,0.8666666666666667,0.8666666666666667)h.Position=UDim2.new(0,
80,0,0)h.Size=UDim2.new(1,-80,0,40)h.Font=Enum.Font.ArialBold h.FontSize=Enum.
FontSize.Size36 h.TextXAlignment=Enum.TextXAlignment.Center h.TextYAlignment=
Enum.TextYAlignment.Center h.Parent=f local i=Instance.new'TextLabel'i.Name=
'Message'i.Text=c i.TextStrokeTransparency=0 i.TextColor3=Color3.new(
0.8666666666666667,0.8666666666666667,0.8666666666666667)i.Position=UDim2.new(
0.025,80,0,45)i.Size=UDim2.new(0.95,-80,0,55)i.BackgroundTransparency=1 i.Font=
Enum.Font.Arial i.FontSize=Enum.FontSize.Size18 i.TextWrap=true i.TextXAlignment
=Enum.TextXAlignment.Left i.TextYAlignment=Enum.TextYAlignment.Top i.Parent=f
CreateButtons(f,e,UDim.new(0,105),UDim.new(0,40))return f end a.
CreateMessageDialog=function(b,c,d)local e=Instance.new'Frame'e.Size=UDim2.new(
0.5,0,0.5,0)e.Position=UDim2.new(0.25,0,0.25,0)e.Name='MessageDialog'e.Active=
true e.Style=Enum.FrameStyle.RobloxRound local f=Instance.new'TextLabel'f.Name=
'Title'f.Text=b f.BackgroundTransparency=1 f.TextColor3=Color3.new(
0.8666666666666667,0.8666666666666667,0.8666666666666667)f.Position=UDim2.new(0,
0,0,0)f.Size=UDim2.new(1,0,0.15,0)f.Font=Enum.Font.ArialBold f.FontSize=Enum.
FontSize.Size36 f.TextXAlignment=Enum.TextXAlignment.Center f.TextYAlignment=
Enum.TextYAlignment.Center f.Parent=e local g=Instance.new'TextLabel'g.Name=
'Message'g.Text=c g.TextColor3=Color3.new(0.8666666666666667,0.8666666666666667,
0.8666666666666667)g.Position=UDim2.new(0.025,0,0.175,0)g.Size=UDim2.new(0.95,0,
0.55,0)g.BackgroundTransparency=1 g.Font=Enum.Font.Arial g.FontSize=Enum.
FontSize.Size18 g.TextWrap=true g.TextXAlignment=Enum.TextXAlignment.Left g.
TextYAlignment=Enum.TextYAlignment.Top g.Parent=e CreateButtons(e,d,UDim.new(0.8
,0),UDim.new(0.15,0))return e end a.CreateDropDownMenu=function(b,c,d)local e,f,
g=UDim.new(0,100),UDim.new(0,32),Instance.new'Frame'g.Name='DropDownMenu'g.
BackgroundTransparency=1 g.Size=UDim2.new(e,f)local h=Instance.new'TextButton'h.
Name='DropDownMenuButton'h.TextWrap=true h.TextColor3=Color3.new(1,1,1)h.Text=
'Choose One'h.Font=Enum.Font.ArialBold h.FontSize=Enum.FontSize.Size18 h.
TextXAlignment=Enum.TextXAlignment.Left h.TextYAlignment=Enum.TextYAlignment.
Center h.BackgroundTransparency=1 h.AutoButtonColor=true h.Style=Enum.
ButtonStyle.RobloxButton h.Size=UDim2.new(1,0,1,0)h.Parent=g h.ZIndex=2 local i=
Instance.new'ImageLabel'i.Name='Icon'i.Active=false i.Image=
'http://www.roblox.com/asset/?id=45732894'i.BackgroundTransparency=1 i.Size=
UDim2.new(0,11,0,6)i.Position=UDim2.new(1,-11,0.5,-2)i.Parent=h i.ZIndex=2 local
j,k,l=#b,#b,false if k>6 then l=true k=6 end local m=Instance.new'TextButton'm.
Name='List'm.Text=''m.BackgroundTransparency=1 m.Style=Enum.ButtonStyle.
RobloxButton m.Visible=false m.Active=true m.Position=UDim2.new(0,0,0,0)m.Size=
UDim2.new(1,0,(1+k)*0.8,0)m.Parent=g m.ZIndex=2 local n=Instance.new'TextButton'
n.Name='ChoiceButton'n.BackgroundTransparency=1 n.BorderSizePixel=0 n.Text=
'ReplaceMe'n.TextColor3=Color3.new(1,1,1)n.TextXAlignment=Enum.TextXAlignment.
Left n.TextYAlignment=Enum.TextYAlignment.Center n.BackgroundColor3=Color3.new(1
,1,1)n.Font=Enum.Font.Arial n.FontSize=Enum.FontSize.Size18 if l then n.Size=
UDim2.new(1,-13,0.8/((k+1)*0.8),0)else n.Size=UDim2.new(1,0,0.8/((k+1)*0.8),0)
end n.TextWrap=true n.ZIndex=2 local o=Instance.new'TextButton'o.Name='AreaSoak'
o.Text=''o.BackgroundTransparency=1 o.Active=true o.Size=UDim2.new(1,0,1,0)o.
Visible=false o.ZIndex=3 local p,q,r,s=false,nil,nil,0 local t,u=function(t)m.
ZIndex=t+1 if q then q.ZIndex=t+3 end if r then r.ZIndex=t+3 end local u=m:
GetChildren()if u then for v,w in ipairs(u)do if w.Name=='ChoiceButton'then w.
ZIndex=t+2 elseif w.Name=='ClickCaptureButton'then w.ZIndex=t end end end end,1
local v=function()if q then q.Active=u>1 end if r then r.Active=u+k<=j end local
v=m:GetChildren()if not v then return end local w=1 for x,y in ipairs(v)do if y.
Name=='ChoiceButton'then if w<u or w>=u+k then y.Visible=false else y.Position=
UDim2.new(0,0,((w-u+1)*0.8)/((k+1)*0.8),0)y.Visible=true end y.TextColor3=Color3
.new(1,1,1)y.BackgroundTransparency=1 w=w+1 end end end local w=function()p=not
p o.Visible=not o.Visible h.Visible=not p m.Visible=p if p then t(4)else t(2)end
if l then v()end end m.MouseButton1Click:connect(w)local x=function(x)local y,z,
A=false,m:GetChildren(),1 if z then for B,C in ipairs(z)do if C.Name==
'ChoiceButton'then if C.Text==x then C.Font=Enum.Font.ArialBold y=true u=A else
C.Font=Enum.Font.Arial end A=A+1 end end end if not x then h.Text='Choose One'u=
1 else if not y then error('Invalid Selection Update -- '..x)end if u+k>j+1 then
u=j-k+1 end h.Text=x end end local function scrollDown()if u+k<=j then u=u+1 v()
return true end return false end local function scrollUp()if u>1 then u=u-1 v()
return true end return false end if l then q=Instance.new'ImageButton'q.Name=
'ScrollUpButton'q.BackgroundTransparency=1 q.Image=
'rbxasset://textures/ui/scrollbuttonUp.png'q.Size=UDim2.new(0,17,0,17)q.Position
=UDim2.new(1,-11,(0.8)/((k+1)*0.8),0)q.MouseButton1Click:connect(function()s=s+1
end)q.MouseLeave:connect(function()s=s+1 end)q.MouseButton1Down:connect(function
()s=s+1 scrollUp()local y=s wait(0.5)while y==s do if scrollUp()==false then
break end wait(0.1)end end)q.Parent=m r=Instance.new'ImageButton'r.Name=
'ScrollDownButton'r.BackgroundTransparency=1 r.Image=
'rbxasset://textures/ui/scrollbuttonDown.png'r.Size=UDim2.new(0,17,0,17)r.
Position=UDim2.new(1,-11,1,-11)r.Parent=m r.MouseButton1Click:connect(function()
s=s+1 end)r.MouseLeave:connect(function()s=s+1 end)r.MouseButton1Down:connect(
function()s=s+1 scrollDown()local y=s wait(0.5)while y==s do if scrollDown()==
false then break end wait(0.1)end end)local y=Instance.new'ImageLabel'y.Name=
'ScrollBar'y.Image='rbxasset://textures/ui/scrollbar.png'y.
BackgroundTransparency=1 y.Size=UDim2.new(0,18,(k*0.8)/((k+1)*0.8),-32)y.
Position=UDim2.new(1,-11,(0.8)/((k+1)*0.8),19)y.Parent=m end for y,z in ipairs(b
)do local A=n:clone()if d then A.RobloxLocked=true end A.Text=z A.Parent=m A.
MouseButton1Click:connect(function()A.TextColor3=Color3.new(1,1,1)A.
BackgroundTransparency=1 x(z)c(z)w()end)A.MouseEnter:connect(function()A.
TextColor3=Color3.new(0,0,0)A.BackgroundTransparency=0 end)A.MouseLeave:connect(
function()A.TextColor3=Color3.new(1,1,1)A.BackgroundTransparency=1 end)end v()g.
AncestryChanged:connect(function(A,B)if B==nil then o.Parent=nil else o.Parent=
getScreenGuiAncestor(g)end end)h.MouseButton1Click:connect(w)o.MouseButton1Click
:connect(w)return g,x end a.CreatePropertyDropDownMenu=function(b,c,d)local e,f,
g=d:GetEnumItems(),{},{}for h,i in ipairs(e)do f[h]=i.Name g[i.Name]=i end local
j,k j,k=a.CreateDropDownMenu(f,function(l)b[c]=g[l]end)ScopedConnect(j,b,
'Changed',function(l)if l==c then k(b[c].Name)end end,function()k(b[c].Name)end)
return j end a.GetFontHeight=function(b,c)if b==nil or c==nil then error
'Font and FontSize must be non-nil'end if b==Enum.Font.Legacy then if c==Enum.
FontSize.Size8 then return 12 elseif c==Enum.FontSize.Size9 then return 14
elseif c==Enum.FontSize.Size10 then return 15 elseif c==Enum.FontSize.Size11
then return 17 elseif c==Enum.FontSize.Size12 then return 18 elseif c==Enum.
FontSize.Size14 then return 21 elseif c==Enum.FontSize.Size18 then return 27
elseif c==Enum.FontSize.Size24 then return 36 elseif c==Enum.FontSize.Size36
then return 54 elseif c==Enum.FontSize.Size48 then return 72 else error
'Unknown FontSize'end elseif b==Enum.Font.Arial or b==Enum.Font.ArialBold then
if c==Enum.FontSize.Size8 then return 8 elseif c==Enum.FontSize.Size9 then
return 9 elseif c==Enum.FontSize.Size10 then return 10 elseif c==Enum.FontSize.
Size11 then return 11 elseif c==Enum.FontSize.Size12 then return 12 elseif c==
Enum.FontSize.Size14 then return 14 elseif c==Enum.FontSize.Size18 then return
18 elseif c==Enum.FontSize.Size24 then return 24 elseif c==Enum.FontSize.Size36
then return 36 elseif c==Enum.FontSize.Size48 then return 48 else error
'Unknown FontSize'end else error('Unknown Font '..b)end end local function
layoutGuiObjectsHelper(b,c,d)local e,f=b.AbsoluteSize.Y,b.AbsoluteSize.Y for g,h
in ipairs(c)do if h:IsA'TextLabel'or h:IsA'TextButton'then local i=h:IsA
'TextLabel'if i then f=f-d['TextLabelPositionPadY']else f=f-d[
'TextButtonPositionPadY']end h.Position=UDim2.new(h.Position.X.Scale,h.Position.
X.Offset,0,e-f)h.Size=UDim2.new(h.Size.X.Scale,h.Size.X.Offset,0,f)if h.TextFits
and h.TextBounds.Y<f then h.Visible=true if i then h.Size=UDim2.new(h.Size.X.
Scale,h.Size.X.Offset,0,h.TextBounds.Y+d['TextLabelSizePadY'])else h.Size=UDim2.
new(h.Size.X.Scale,h.Size.X.Offset,0,h.TextBounds.Y+d['TextButtonSizePadY'])end
while not h.TextFits do h.Size=UDim2.new(h.Size.X.Scale,h.Size.X.Offset,0,h.
AbsoluteSize.Y+1)end f=f-h.AbsoluteSize.Y if i then f=f-d[
'TextLabelPositionPadY']else f=f-d['TextButtonPositionPadY']end else h.Visible=
false f=-1 end else h.Position=UDim2.new(h.Position.X.Scale,h.Position.X.Offset,
0,e-f)f=f-h.AbsoluteSize.Y h.Visible=(f>=0)end end end a.LayoutGuiObjects=
function(b,c,d)if not b:IsA'GuiObject'then error'Frame must be a GuiObject'end
for e,f in ipairs(c)do if not f:IsA'GuiObject'then error
'All elements that are layed out must be of type GuiObject'end end if not d then
d={}end if not d['TextLabelSizePadY']then d['TextLabelSizePadY']=0 end if not d[
'TextLabelPositionPadY']then d['TextLabelPositionPadY']=0 end if not d[
'TextButtonSizePadY']then d['TextButtonSizePadY']=12 end if not d[
'TextButtonPositionPadY']then d['TextButtonPositionPadY']=2 end local g=Instance
.new'Frame'g.Name='WrapperFrame'g.BackgroundTransparency=1 g.Size=UDim2.new(1,0,
1,0)g.Parent=b for h,i in ipairs(c)do i.Parent=g end local j=function()wait()
layoutGuiObjectsHelper(g,c,d)end b.Changed:connect(function(k)if k==
'AbsoluteSize'then j(nil)end end)b.AncestryChanged:connect(j)
layoutGuiObjectsHelper(g,c,d)end a.CreateSlider=function(b,c,d)local g=Instance.
new'Frame'g.Size=UDim2.new(1,0,1,0)g.BackgroundTransparency=1 g.Name='SliderGui'
local h=Instance.new'IntValue'h.Name='SliderSteps'h.Value=b h.Parent=g local i=
Instance.new'TextButton'i.Name='AreaSoak'i.Text=''i.BackgroundTransparency=1 i.
Active=false i.Size=UDim2.new(1,0,1,0)i.Visible=false i.ZIndex=4 g.
AncestryChanged:connect(function(j,k)if k==nil then i.Parent=nil else i.Parent=
getScreenGuiAncestor(g)end end)local j=Instance.new'IntValue'j.Name=
'SliderPosition'j.Value=0 j.Parent=g local k=Instance.new'TextButton'k.Text=''k.
AutoButtonColor=false k.Name='Bar'k.BackgroundColor3=Color3.new(0,0,0)if type(c)
=='number'then k.Size=UDim2.new(0,c,0,5)else k.Size=UDim2.new(0,200,0,5)end k.
BorderColor3=Color3.new(0.37254901960784315,0.37254901960784315,
0.37254901960784315)k.ZIndex=2 k.Parent=g if d['X']and d['X']['Scale']and d['X']
['Offset']and d['Y']and d['Y']['Scale']and d['Y']['Offset']then k.Position=d end
local l=Instance.new'ImageButton'l.Name='Slider'l.BackgroundTransparency=1 l.
Image='rbxasset://textures/ui/Slider.png'l.Position=UDim2.new(0,0,0.5,-10)l.Size
=UDim2.new(0,20,0,20)l.ZIndex=3 l.Parent=k local m=nil i.MouseLeave:connect(
function()if i.Visible then cancelSlide(i)end end)i.MouseButton1Up:connect(
function()if i.Visible then cancelSlide(i)end end)l.MouseButton1Down:connect(
function()i.Visible=true if m then m:disconnect()end m=i.MouseMoved:connect(
function(n,o)setSliderPos(n,l,j,k,b)end)end)l.MouseButton1Up:connect(function()
cancelSlide(i)end)j.Changed:connect(function(n)j.Value=math.min(b,math.max(1,j.
Value))local o=(j.Value-1)/(b-1)l.Position=UDim2.new(o,-l.AbsoluteSize.X/2,l.
Position.Y.Scale,l.Position.Y.Offset)end)k.MouseButton1Down:connect(function(n,o
)setSliderPos(n,l,j,k,b)end)return g,j,h end a.CreateTrueScrollingFrame=function
()local b,c,d,g,h,i,j=nil,nil,nil,nil,false,{},Instance.new'Frame'j.Name=
'ScrollingFrame'j.Active=true j.Size=UDim2.new(1,0,1,0)j.ClipsDescendants=true
local k=Instance.new'Frame'k.Name='ControlFrame'k.BackgroundTransparency=1 k.
Size=UDim2.new(0,18,1,0)k.Position=UDim2.new(1,-20,0,0)k.Parent=j local l=
Instance.new'BoolValue'l.Value=false l.Name='ScrollBottom'l.Parent=k local m=
Instance.new'BoolValue'm.Value=false m.Name='scrollUp'm.Parent=k local n=
Instance.new'TextButton'n.Name='ScrollUpButton'n.Text=''n.AutoButtonColor=false
n.BackgroundColor3=Color3.new(0,0,0)n.BorderColor3=Color3.new(1,1,1)n.
BackgroundTransparency=0.5 n.Size=UDim2.new(0,18,0,18)n.ZIndex=2 n.Parent=k for
o=1,6 do local p=Instance.new'Frame'p.BorderColor3=Color3.new(1,1,1)p.Name='tri'
..tostring(o)p.ZIndex=3 p.BackgroundTransparency=0.5 p.Size=UDim2.new(0,12-((o-1
)*2),0,0)p.Position=UDim2.new(0,3+(o-1),0.5,2-(o-1))p.Parent=n end n.MouseEnter:
connect(function()n.BackgroundTransparency=0.1 local o=n:GetChildren()for p=1,#o
do o[p].BackgroundTransparency=0.1 end end)n.MouseLeave:connect(function()n.
BackgroundTransparency=0.5 local o=n:GetChildren()for p=1,#o do o[p].
BackgroundTransparency=0.5 end end)local o=n:clone()o.Name='ScrollDownButton'o.
Position=UDim2.new(0,0,1,-18)local p=o:GetChildren()for q=1,#p do p[q].Position=
UDim2.new(0,3+(q-1),0.5,-2+(q-1))end o.MouseEnter:connect(function()o.
BackgroundTransparency=0.1 local q=o:GetChildren()for r=1,#q do q[r].
BackgroundTransparency=0.1 end end)o.MouseLeave:connect(function()o.
BackgroundTransparency=0.5 local q=o:GetChildren()for r=1,#q do q[r].
BackgroundTransparency=0.5 end end)o.Parent=k local q=Instance.new'Frame'q.Name=
'ScrollTrack'q.BackgroundTransparency=1 q.Size=UDim2.new(0,18,1,-38)q.Position=
UDim2.new(0,0,0,19)q.Parent=k local r=Instance.new'TextButton'r.BackgroundColor3
=Color3.new(0,0,0)r.BorderColor3=Color3.new(1,1,1)r.BackgroundTransparency=0.5 r
.AutoButtonColor=false r.Text=''r.Active=true r.Name='ScrollBar'r.ZIndex=2 r.
BackgroundTransparency=0.5 r.Size=UDim2.new(0,18,0.1,0)r.Position=UDim2.new(0,0,
0,0)r.Parent=q local s=Instance.new'Frame's.Name='ScrollNub's.BorderColor3=
Color3.new(1,1,1)s.Size=UDim2.new(0,10,0,0)s.Position=UDim2.new(0.5,-5,0.5,0)s.
ZIndex=2 s.BackgroundTransparency=0.5 s.Parent=r local t=s:clone()t.Position=
UDim2.new(0.5,-5,0.5,-2)t.Parent=r local u=s:clone()u.Position=UDim2.new(0.5,-5,
0.5,2)u.Parent=r r.MouseEnter:connect(function()r.BackgroundTransparency=0.1 s.
BackgroundTransparency=0.1 t.BackgroundTransparency=0.1 u.BackgroundTransparency
=0.1 end)r.MouseLeave:connect(function()r.BackgroundTransparency=0.5 s.
BackgroundTransparency=0.5 t.BackgroundTransparency=0.5 u.BackgroundTransparency
=0.5 end)local v=Instance.new'ImageButton'v.Active=false v.Size=UDim2.new(1.5,0,
1.5,0)v.AutoButtonColor=false v.BackgroundTransparency=1 v.Name='mouseDrag'v.
Position=UDim2.new(-0.25,0,-0.25,0)v.ZIndex=10 local function positionScrollBar(
w,x,y)local z=r.Position if x<q.AbsolutePosition.y then r.Position=UDim2.new(r.
Position.X.Scale,r.Position.X.Offset,0,0)return(z~=r.Position)end local A=r.
AbsoluteSize.Y/q.AbsoluteSize.Y if x>(q.AbsolutePosition.y+q.AbsoluteSize.y)then
r.Position=UDim2.new(r.Position.X.Scale,r.Position.X.Offset,1-A,0)return(z~=r.
Position)end local B=(x-q.AbsolutePosition.y-y)/q.AbsoluteSize.y if B+A>1 then B
=1-A l.Value=true m.Value=false elseif B<=0 then B=0 m.Value=true l.Value=false
else m.Value=false l.Value=false end r.Position=UDim2.new(r.Position.X.Scale,r.
Position.X.Offset,B,0)return(z~=r.Position)end local function
drillDownSetHighLow(w)if not w or not w:IsA'GuiObject'then return end if w==k
then return end if w:IsDescendantOf(k)then return end if not w.Visible then
return end if(b and b>w.AbsolutePosition.Y)or not b then b=w.AbsolutePosition.Y
end if(c and c<(w.AbsolutePosition.Y+w.AbsoluteSize.Y))or not c then c=w.
AbsolutePosition.Y+w.AbsoluteSize.Y end local x=w:GetChildren()for y=1,#x do
drillDownSetHighLow(x[y])end end local function resetHighLow()local w=j:
GetChildren()for x=1,#w do drillDownSetHighLow(w[x])end end local function
recalculate()h=true local w=0 if r.Position.Y.Scale>0 then if r.Visible then w=r
.Position.Y.Scale/((q.AbsoluteSize.Y-r.AbsoluteSize.Y)/q.AbsoluteSize.Y)else w=0
end end if w>0.99 then w=1 end local x,y=(j.AbsoluteSize.Y-(c-b))*w,j:
GetChildren()for z=1,#y do if y[z]~=k then y[z].Position=UDim2.new(y[z].Position
.X.Scale,y[z].Position.X.Offset,0,math.ceil(y[z].AbsolutePosition.Y)-math.ceil(b
)+x)end end b=nil c=nil resetHighLow()h=false end local function
setSliderSizeAndPosition()if not c or not b then return end local w=math.abs(c-b
)if w==0 then r.Visible=false o.Visible=false n.Visible=false if d then d:
disconnect()d=nil end if g then g:disconnect()g=nil end return end local x=j.
AbsoluteSize.Y/w if x>=1 then r.Visible=false o.Visible=false n.Visible=false
recalculate()else r.Visible=true o.Visible=true n.Visible=true r.Size=UDim2.new(
r.Size.X.Scale,r.Size.X.Offset,x,0)end local y=(j.AbsolutePosition.Y-b)/w r.
Position=UDim2.new(r.Position.X.Scale,r.Position.X.Offset,y,-r.AbsoluteSize.X/2)
if r.AbsolutePosition.y<q.AbsolutePosition.y then r.Position=UDim2.new(r.
Position.X.Scale,r.Position.X.Offset,0,0)end if(r.AbsolutePosition.y+r.
AbsoluteSize.Y)>(q.AbsolutePosition.y+q.AbsoluteSize.y)then local z=r.
AbsoluteSize.Y/q.AbsoluteSize.Y r.Position=UDim2.new(r.Position.X.Scale,r.
Position.X.Offset,1-z,0)end end local w,x=7,false local function doScrollUp()if
x then return end x=true if positionScrollBar(0,r.AbsolutePosition.Y-w,0)then
recalculate()end x=false end local y=false local function doScrollDown()if y
then return end y=true if positionScrollBar(0,r.AbsolutePosition.Y+w,0)then
recalculate()end y=false end local function scrollUp(z)if n.Active then local A=
tick()local B,C=A,nil C=v.MouseButton1Up:connect(function()A=tick()v.Parent=nil
C:disconnect()end)v.Parent=getScreenGuiAncestor(r)doScrollUp()wait(0.2)local D,E
=tick(),0.1 while A==B do doScrollUp()if z and z>r.AbsolutePosition.y then break
end if not n.Active then break end if tick()-D>5 then E=0 elseif tick()-D>2 then
E=0.06 end wait(E)end end end local function scrollDown(z)if o.Active then local
A=tick()local B,C=A,nil C=v.MouseButton1Up:connect(function()A=tick()v.Parent=
nil C:disconnect()end)v.Parent=getScreenGuiAncestor(r)doScrollDown()wait(0.2)
local D,E=tick(),0.1 while A==B do doScrollDown()if z and z<(r.AbsolutePosition.
y+r.AbsoluteSize.x)then break end if not o.Active then break end if tick()-D>5
then E=0 elseif tick()-D>2 then E=0.06 end wait(E)end end end r.MouseButton1Down
:connect(function(z,A)if r.Active then local B,C=tick(),A-r.AbsolutePosition.y
if d then d:disconnect()d=nil end if g then g:disconnect()g=nil end local D=
false d=v.MouseMoved:connect(function(E,F)if D then return end D=true if
positionScrollBar(E,F,C)then recalculate()end D=false end)g=v.MouseButton1Up:
connect(function()B=tick()v.Parent=nil d:disconnect()d=nil g:disconnect()drag=
nil end)v.Parent=getScreenGuiAncestor(r)end end)local z=0 n.MouseButton1Down:
connect(function()m()end)o.MouseButton1Down:connect(function()scrollDown()end)
local function scrollTick()scrollStamp=tick()end n.MouseButton1Up:connect(
scrollTick)o.MouseButton1Up:connect(scrollTick)r.MouseButton1Up:connect(
scrollTick)local function highLowRecheck()local A,B=b,c b=nil c=nil
resetHighLow()if(b~=A)or(c~=B)then setSliderSizeAndPosition()end end
local function descendantChanged(A,B)if h then return end if not A.Visible then
return end if B=='Size'or B=='Position'then wait()highLowRecheck()end end j.
DescendantAdded:connect(function(A)if not A:IsA'GuiObject'then return end if A.
Visible then wait()highLowRecheck()end i[A]=A.Changed:connect(function(B)
descendantChanged(A,B)end)end)j.DescendantRemoving:connect(function(A)if not A:
IsA'GuiObject'then return end if i[A]then i[A]:disconnect()i[A]=nil end wait()
highLowRecheck()end)j.Changed:connect(function(A)if A=='AbsoluteSize'then if not
c or not b then return end highLowRecheck()setSliderSizeAndPosition()end end)
return j,k end a.CreateScrollingFrame=function(b,c)local d=Instance.new'Frame'd.
Name='ScrollingFrame'd.BackgroundTransparency=1 d.Size=UDim2.new(1,0,1,0)local g
=Instance.new'ImageButton'g.Name='ScrollUpButton'g.BackgroundTransparency=1 g.
Image='rbxasset://textures/ui/scrollbuttonUp.png'g.Size=UDim2.new(0,17,0,17)
local h=Instance.new'ImageButton'h.Name='ScrollDownButton'h.
BackgroundTransparency=1 h.Image='rbxasset://textures/ui/scrollbuttonDown.png'h.
Size=UDim2.new(0,17,0,17)local i=Instance.new'ImageButton'i.Name='ScrollBar'i.
Image='rbxasset://textures/ui/scrollbar.png'i.BackgroundTransparency=1 i.Size=
UDim2.new(0,18,0,150)local j,k=0,Instance.new'ImageButton'k.Image=
'http://www.roblox.com/asset/?id=61367186'k.Size=UDim2.new(1,0,0,16)k.
BackgroundTransparency=1 k.Name='ScrollDrag'k.Active=true k.Parent=i local l=
Instance.new'ImageButton'l.Active=false l.Size=UDim2.new(1.5,0,1.5,0)l.
AutoButtonColor=false l.BackgroundTransparency=1 l.Name='mouseDrag'l.Position=
UDim2.new(-0.25,0,-0.25,0)l.ZIndex=10 local m='simple'if c and tostring(c)then m
=c end local n,o,p=1,0,0 local q,r,s,t=function()p=0 local q={}if b then for r,s
in ipairs(b)do if s.Parent==d then table.insert(q,s)end end else local r=d:
GetChildren()if r then for s,t in ipairs(r)do if t:IsA'GuiObject'then table.
insert(q,t)end end end end if#q==0 then g.Active=false h.Active=false k.Active=
false n=1 return end if n>#q then n=#q end if n<1 then n=1 end local r,s,t,u,v,w
,x,y,z=d.AbsoluteSize.Y,d.AbsoluteSize.Y,d.AbsoluteSize.X,0,0,true,0,#q,0 y=n
while y<=#q and x<r do u=u+q[y].AbsoluteSize.X if u>=t then x=x+z z=0 u=q[y].
AbsoluteSize.X end if q[y].AbsoluteSize.Y>z then z=q[y].AbsoluteSize.Y end y=y+1
end x=x+z z=0 y=n-1 u=0 while x+z<r and y>=1 do u=u+q[y].AbsoluteSize.X v=v+1 if
u>=t then o=v-1 v=0 u=q[y].AbsoluteSize.X if x+z<=r then x=x+z if n<=o then n=1
break else n=n-o end z=0 else break end end if q[y].AbsoluteSize.Y>z then z=q[y]
.AbsoluteSize.Y end y=y-1 end if(y==0)and(x+z<=r)then n=1 end u=0 v=0 w=true
local A,B,C=0,0 if q[1]then C=math.ceil(math.floor(math.fmod(r,q[1].AbsoluteSize
.X))/2)B=math.ceil(math.floor(math.fmod(t,q[1].AbsoluteSize.Y))/2)end for D,E in
ipairs(q)do if D<n then E.Visible=false else if s<0 then E.Visible=false else if
w then v=v+1 end if u+E.AbsoluteSize.X>=t then if w then o=v-1 w=false end u=0 s
=s-E.AbsoluteSize.Y end E.Position=UDim2.new(E.Position.X.Scale,u+B,0,r-s+C)u=u+
E.AbsoluteSize.X E.Visible=((s-E.AbsoluteSize.Y)>=0)if E.Visible then p=p+1 end
A=E.AbsoluteSize end end end g.Active=(n>1)if A==0 then h.Active=false else h.
Active=((s-A.Y)<0)end k.Active=#q>p k.Visible=k.Active end,function()local q={}p
=0 if b then for r,s in ipairs(b)do if s.Parent==d then table.insert(q,s)end end
else local r=d:GetChildren()if r then for s,t in ipairs(r)do if t:IsA'GuiObject'
then table.insert(q,t)end end end end if#q==0 then g.Active=false h.Active=false
k.Active=false n=1 return end if n>#q then n=#q end local r,s,t,u=d.AbsoluteSize
.Y,d.AbsoluteSize.Y,0,#q while t<r and u>=1 do if u>=n then t=t+q[u].
AbsoluteSize.Y else if t+q[u].AbsoluteSize.Y<=r then t=t+q[u].AbsoluteSize.Y if
n<=1 then n=1 break else n=n-1 end else break end end u=u-1 end u=n for v,w in
ipairs(q)do if v<n then w.Visible=false else if s<0 then w.Visible=false else w.
Position=UDim2.new(w.Position.X.Scale,w.Position.X.Offset,0,r-s)s=s-w.
AbsoluteSize.Y if s>=0 then w.Visible=true p=p+1 else w.Visible=false end end
end end g.Active=(n>1)h.Active=(s<0)k.Active=#q>p k.Visible=k.Active end,
function()local q,r=0,d:GetChildren()if r then for s,t in ipairs(r)do if t:IsA
'GuiObject'then q=q+1 end end end if not k.Parent then return end local s=k.
Parent.AbsoluteSize.y*(1/(q-p+1))if s<16 then s=16 end k.Size=UDim2.new(k.Size.X
.Scale,k.Size.X.Offset,k.Size.Y.Scale,s)local t=(n-1)/(q-p)if t>1 then t=1
elseif t<0 then t=0 end local u=0 if t~=0 then u=(t*i.AbsoluteSize.y)-(t*k.
AbsoluteSize.y)end k.Position=UDim2.new(k.Position.X.Scale,k.Position.X.Offset,k
.Position.Y.Scale,u)end,false local u=function()if t then return end t=true
wait()local u,v=nil if m=='grid'then u,v=pcall(function()q()end)elseif m==
'simple'then u,v=pcall(function()r()end)end if not u then print(v)end s()t=false
end local v,w=function()n=n-o if n<1 then n=1 end u(nil)end,function()n=n+o u(
nil)end local x,y=function(x)if g.Active then j=tick()local y,z=j,nil z=l.
MouseButton1Up:connect(function()j=tick()l.Parent=nil z:disconnect()end)l.Parent
=getScreenGuiAncestor(i)v()wait(0.2)local A,B=tick(),0.1 while j==y do v()if x
and x>k.AbsolutePosition.y then break end if not g.Active then break end if
tick()-A>5 then B=0 elseif tick()-A>2 then B=0.06 end wait(B)end end end,
function(x)if h.Active then j=tick()local y,z=j,nil z=l.MouseButton1Up:connect(
function()j=tick()l.Parent=nil z:disconnect()end)l.Parent=getScreenGuiAncestor(i
)w()wait(0.2)local A,B=tick(),0.1 while j==y do w()if x and x<(k.
AbsolutePosition.y+k.AbsoluteSize.x)then break end if not h.Active then break
end if tick()-A>5 then B=0 elseif tick()-A>2 then B=0.06 end wait(B)end end end
k.MouseButton1Down:connect(function(z,A)if k.Active then j=tick()local B,C,D=A-k
.AbsolutePosition.y,nil,nil C=l.MouseMoved:connect(function(E,F)local G,H,I=i.
AbsolutePosition.y,i.AbsoluteSize.y,k.AbsoluteSize.y local J=G+H-I F=F-B F=F<G
and G or F>J and J or F F=F-G local K,L=0,d:GetChildren()if L then for M,N in
ipairs(L)do if N:IsA'GuiObject'then K=K+1 end end end local M,N,O=F/(H-I),o,K-(p
-1)local P=math.floor((M*O)+0.5)+N if P<n then N=-N end if P<1 then P=1 end n=P
u(nil)end)D=l.MouseButton1Up:connect(function()j=tick()l.Parent=nil C:
disconnect()C=nil D:disconnect()drag=nil end)l.Parent=getScreenGuiAncestor(i)end
end)local z=0 g.MouseButton1Down:connect(function()x()end)g.MouseButton1Up:
connect(function()j=tick()end)h.MouseButton1Up:connect(function()j=tick()end)h.
MouseButton1Down:connect(function()y()end)i.MouseButton1Up:connect(function()j=
tick()end)i.MouseButton1Down:connect(function(A,B)if B>(k.AbsoluteSize.y+k.
AbsolutePosition.y)then y(B)elseif B<k.AbsolutePosition.y then x(B)end end)d.
ChildAdded:connect(function()u(nil)end)d.ChildRemoved:connect(function()u(nil)
end)d.Changed:connect(function(A)if A=='AbsoluteSize'then u(nil)end end)d.
AncestryChanged:connect(function()u(nil)end)return d,g,h,u,i end local function
binaryGrow(b,c,d)if b>c then return b end local g=b while b<=c do local h=b+math
.floor((c-b)/2)if d(h)and(g==nil or g<h)then g=h b=h+1 else c=h-1 end end return
g end local function binaryShrink(b,c,d)if b>c then return b end local g=c while
b<=c do local h=b+math.floor((c-b)/2)if d(h)and(g==nil or g>h)then g=h c=h-1
else b=h+1 end end return g end local function getGuiOwner(b)while b~=nil do if
b:IsA'ScreenGui'or b:IsA'BillboardGui'then return b end b=b.Parent end return
nil end a.AutoTruncateTextObject=function(b)local c,d=b.Text,b:Clone()d.Name=
'Full'..b.Name d.BorderSizePixel=0 d.BackgroundTransparency=0 d.Text=c d.
TextXAlignment=Enum.TextXAlignment.Center d.Position=UDim2.new(0,-3,0,0)d.Size=
UDim2.new(0,100,1,0)d.Visible=false d.Parent=b local g,h,i=nil,nil,nil local j=
function()if getGuiOwner(b)==nil then return end b.Text=c if b.TextFits then if
h then h:disconnect()h=nil end if i then i:disconnect()i=nil end else local j=
string.len(c)b.Text=c..'~'local k=binaryGrow(0,j,function(k)if k==0 then b.Text=
'~'else b.Text=string.sub(c,1,k)..'~'end return b.TextFits end)g=string.sub(c,1,
k)..'~'b.Text=g if not d.TextFits then d.Size=UDim2.new(0,10000,1,0)end local l=
binaryShrink(b.AbsoluteSize.X,d.AbsoluteSize.X,function(l)d.Size=UDim2.new(0,l,1
,0)return d.TextFits end)d.Size=UDim2.new(0,l+6,1,0)if h==nil then h=b.
MouseEnter:connect(function()d.ZIndex=b.ZIndex+1 d.Visible=true end)end if i==
nil then i=b.MouseLeave:connect(function()d.Visible=false end)end end end b.
AncestryChanged:connect(j)b.Changed:connect(function(k)if k=='AbsoluteSize'then
j()end end)j()local function changeText(k)c=k d.Text=c j()end return b,
changeText end local function TransitionTutorialPages(b,c,d,g)if b then b.
Visible=false if d.Visible==false then d.Size=b.Size d.Position=b.Position end
else if d.Visible==false then d.Size=UDim2.new(0,50,0,50)d.Position=UDim2.new(
0.5,-25,0.5,-25)end end d.Visible=true g.Value=nil local h,i if c then c.Visible
=true h=c.Size i=c.Position c.Visible=false else h=UDim2.new(0,50,0,50)i=UDim2.
new(0.5,-25,0.5,-25)end d:TweenSizeAndPosition(h,i,Enum.EasingDirection.InOut,
Enum.EasingStyle.Quad,0.3,true,function(j)if j==Enum.TweenStatus.Completed then
d.Visible=false if c then c.Visible=true g.Value=c end end end)end a.
CreateTutorial=function(b,c,d)local g=Instance.new'Frame'g.Name='Tutorial-'..b g
.BackgroundTransparency=1 g.Size=UDim2.new(0.6,0,0.6,0)g.Position=UDim2.new(0.2,
0,0.2,0)local h=Instance.new'Frame'h.Name='TransitionFrame'h.Style=Enum.
FrameStyle.RobloxRound h.Size=UDim2.new(0.6,0,0.6,0)h.Position=UDim2.new(0.2,0,
0.2,0)h.Visible=false h.Parent=g local i=Instance.new'ObjectValue'i.Name=
'CurrentTutorialPage'i.Value=nil i.Parent=g local j=Instance.new'BoolValue'j.
Name='Buttons'j.Value=d j.Parent=g local k=Instance.new'Frame'k.Name='Pages'k.
BackgroundTransparency=1 k.Size=UDim2.new(1,0,1,0)k.Parent=g local function
getVisiblePageAndHideOthers()local l,m=nil,k:GetChildren()if m then for n,o in
ipairs(m)do if o.Visible then if l then o.Visible=false else l=o end end end end
return l end local l,m,n=function(l)if l or UserSettings().GameSettings:
GetTutorialState(c)==false then print('Showing tutorial-',c)local m,n=
getVisiblePageAndHideOthers(),k:FindFirstChild'TutorialPage1'if n then
TransitionTutorialPages(m,n,h,i)else error'Could not find TutorialPage1'end end
end,function()local l=getVisiblePageAndHideOthers()if l then
TransitionTutorialPages(l,nil,h,i)end UserSettings().GameSettings:
SetTutorialState(c,true)end,function(l)local m,n=k:FindFirstChild('TutorialPage'
..l),getVisiblePageAndHideOthers()TransitionTutorialPages(n,m,h,i)end return g,l
,m,n end local function CreateBasicTutorialPage(b,c,d,g)local h=Instance.new
'Frame'h.Name='TutorialPage'h.Style=Enum.FrameStyle.RobloxRound h.Size=UDim2.
new(0.6,0,0.6,0)h.Position=UDim2.new(0.2,0,0.2,0)h.Visible=false local i=
Instance.new'TextLabel'i.Name='Header'i.Text=b i.BackgroundTransparency=1 i.
FontSize=Enum.FontSize.Size24 i.Font=Enum.Font.ArialBold i.TextColor3=Color3.
new(1,1,1)i.TextXAlignment=Enum.TextXAlignment.Center i.TextWrap=true i.Size=
UDim2.new(1,-55,0,22)i.Position=UDim2.new(0,0,0,0)i.Parent=h local j=Instance.
new'ImageButton'j.Name='SkipButton'j.AutoButtonColor=false j.
BackgroundTransparency=1 j.Image='rbxasset://textures/ui/closeButton.png'j.
MouseButton1Click:connect(function()d()end)j.MouseEnter:connect(function()j.
Image='rbxasset://textures/ui/closeButton_dn.png'end)j.MouseLeave:connect(
function()j.Image='rbxasset://textures/ui/closeButton.png'end)j.Size=UDim2.new(0
,25,0,25)j.Position=UDim2.new(1,-25,0,0)j.Parent=h if g then local k=Instance.
new'TextButton'k.Name='DoneButton'k.Style=Enum.ButtonStyle.RobloxButtonDefault k
.Text='Done'k.TextColor3=Color3.new(1,1,1)k.Font=Enum.Font.ArialBold k.FontSize=
Enum.FontSize.Size18 k.Size=UDim2.new(0,100,0,50)k.Position=UDim2.new(0.5,-50,1,
-50)if d then k.MouseButton1Click:connect(function()d()end)end k.Parent=h end
local k=Instance.new'Frame'k.Name='ContentFrame'k.BackgroundTransparency=1 k.
Position=UDim2.new(0,0,0,25)k.Parent=h local l=Instance.new'TextButton'l.Name=
'NextButton'l.Text='Next'l.TextColor3=Color3.new(1,1,1)l.Font=Enum.Font.Arial l.
FontSize=Enum.FontSize.Size18 l.Style=Enum.ButtonStyle.RobloxButtonDefault l.
Size=UDim2.new(0,80,0,32)l.Position=UDim2.new(0.5,5,1,-32)l.Active=false l.
Visible=false l.Parent=h local m=Instance.new'TextButton'm.Name='PrevButton'm.
Text='Previous'm.TextColor3=Color3.new(1,1,1)m.Font=Enum.Font.Arial m.FontSize=
Enum.FontSize.Size18 m.Style=Enum.ButtonStyle.RobloxButton m.Size=UDim2.new(0,80
,0,32)m.Position=UDim2.new(0.5,-85,1,-32)m.Active=false m.Visible=false m.Parent
=h if g then k.Size=UDim2.new(1,0,1,-75)else k.Size=UDim2.new(1,0,1,-22)end
local n=nil local function basicHandleResize()if h.Visible and h.Parent then
local o=math.min(h.Parent.AbsoluteSize.X,h.Parent.AbsoluteSize.Y)c(200,o)end end
h.Changed:connect(function(o)if o=='Parent'then if n~=nil then n:disconnect()n=
nil end if h.Parent and h.Parent:IsA'GuiObject'then n=h.Parent.Changed:connect(
function(p)if p=='AbsoluteSize'then wait()basicHandleResize()end end)
basicHandleResize()end end if o=='Visible'then basicHandleResize()end end)return
h,k end a.CreateTextTutorialPage=function(b,c,d)local g,h,i=nil,nil,Instance.new
'TextLabel'i.BackgroundTransparency=1 i.TextColor3=Color3.new(1,1,1)i.Text=c i.
TextWrap=true i.TextXAlignment=Enum.TextXAlignment.Left i.TextYAlignment=Enum.
TextYAlignment.Center i.Font=Enum.Font.Arial i.FontSize=Enum.FontSize.Size14 i.
Size=UDim2.new(1,0,1,0)local function handleResize(j,k)local l=binaryShrink(j,k,
function(l)g.Size=UDim2.new(0,l,0,l)return i.TextFits end)g.Size=UDim2.new(0,l,0
,l)g.Position=UDim2.new(0.5,-l/2,0.5,-l/2)end g,h=CreateBasicTutorialPage(b,
handleResize,d)i.Parent=h return g end a.CreateImageTutorialPage=function(b,c,d,
g,h,i)local j,k,l=nil,nil,Instance.new'ImageLabel'l.BackgroundTransparency=1 l.
Image=c l.Size=UDim2.new(0,d,0,g)l.Position=UDim2.new(0.5,-d/2,0.5,-g/2)
local function handleResize(m,n)local o=binaryShrink(m,n,function(o)return o>=d
and o>=g end)if o>=d and o>=g then l.Size=UDim2.new(0,d,0,g)l.Position=UDim2.
new(0.5,-d/2,0.5,-g/2)else if d>g then l.Size=UDim2.new(1,0,g/d,0)l.Position=
UDim2.new(0,0,0.5-(g/d)/2,0)else l.Size=UDim2.new(d/g,0,1,0)l.Position=UDim2.
new(0.5-(d/g)/2,0,0,0)end end o=o+50 j.Size=UDim2.new(0,o,0,o)j.Position=UDim2.
new(0.5,-o/2,0.5,-o/2)end j,k=CreateBasicTutorialPage(b,handleResize,h,i)l.
Parent=k return j end a.AddTutorialPage=function(b,c)local d,g=b.TransitionFrame
,b.CurrentTutorialPage if not b.Buttons.Value then c.NextButton.Parent=nil c.
PrevButton.Parent=nil end local h=b.Pages:GetChildren()if h and#h>0 then c.Name=
'TutorialPage'..(#h+1)local i=h[#h]if not i:IsA'GuiObject'then error
'All elements under Pages must be GuiObjects'end if b.Buttons.Value then if i.
NextButton.Active then error
[[NextButton already Active on previousPage, please only add pages with RbxGui.AddTutorialPage function]]
end i.NextButton.MouseButton1Click:connect(function()TransitionTutorialPages(i,c
,d,g)end)i.NextButton.Active=true i.NextButton.Visible=true if c.PrevButton.
Active then error
[[PrevButton already Active on tutorialPage, please only add pages with RbxGui.AddTutorialPage function]]
end c.PrevButton.MouseButton1Click:connect(function()TransitionTutorialPages(c,i
,d,g)end)c.PrevButton.Active=true c.PrevButton.Visible=true end c.Parent=b.Pages
else c.Name='TutorialPage1'c.Parent=b.Pages end end a.CreateSetPanel=function(b,
c,d,g,h,i,j)if not b then error
[[CreateSetPanel: userIdsForSets (first arg) is nil, should be a table of number ids]]
end if type(b)~='table'and type(b)~='userdata'then error(
'CreateSetPanel: userIdsForSets (first arg) is of type '..type(b)..
', should be of type table or userdata')end if not c then error
[[CreateSetPanel: objectSelected (second arg) is nil, should be a callback function!]]
end if type(c)~='function'then error(
'CreateSetPanel: objectSelected (second arg) is of type '..type(c)..
', should be of type function!')end if d and type(d)~='function'then error(
'CreateSetPanel: dialogClosed (third arg) is of type '..type(d)..
', should be of type function!')end if i==nil then i=false end local k,l,m,n,o,p
,q,r,s=1,{},{},nil,nil,'NegX','None',nil local t={}t.CurrentCategory=nil t.
Category={}local u,v,w={},nil,64 local x,y,z,A=w,nil,nil,game:GetService
'ContentProvider'.BaseUrl:lower()if j then z=A..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&assetversionid=]]y=A..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&assetversionid=]]else z=A..
'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&aid='y=A..
'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&aid='end local function
drillDownSetZIndex(B,C)local D=B:GetChildren()for E=1,#D do if D[E]:IsA
'GuiObject'then D[E].ZIndex=C end drillDownSetZIndex(D[E],C)end end local B,C,D=
nil,{'Block','Vertical Ramp','Corner Wedge','Inverse Corner Wedge',
'Horizontal Ramp','Auto-Wedge'},{}for E=1,#C do D[C[E]]=E-1 end D[C[#C]]=6
local function createWaterGui()local E,F,G={'NegX','X','NegY','Y','NegZ','Z'},{
'None','Small','Medium','Strong','Max'},Instance.new'Frame'G.Name='WaterFrame'G.
Style=Enum.FrameStyle.RobloxSquare G.Size=UDim2.new(0,150,0,110)G.Visible=false
local H=Instance.new'TextLabel'H.Name='WaterForceLabel'H.BackgroundTransparency=
1 H.Size=UDim2.new(1,0,0,12)H.Font=Enum.Font.ArialBold H.FontSize=Enum.FontSize.
Size12 H.TextColor3=Color3.new(1,1,1)H.TextXAlignment=Enum.TextXAlignment.Left H
.Text='Water Force'H.Parent=G local I=H:Clone()I.Name='WaterForceDirectionLabel'
I.Text='Water Force Direction'I.Position=UDim2.new(0,0,0,50)I.Parent=G local J=
Instance.new'BindableEvent'J.Name='WaterTypeChangedEvent'J.Parent=G local K,L=
function(K)p=K J:Fire{q,p}end,function(K)q=K J:Fire{q,p}end local M,N=a.
CreateDropDownMenu(E,K)M.Size=UDim2.new(1,0,0,25)M.Position=UDim2.new(0,0,1,3)N
'NegX'M.Parent=I local O,P=a.CreateDropDownMenu(F,L)P'None'O.Size=UDim2.new(1,0,
0,25)O.Position=UDim2.new(0,0,1,3)O.Parent=H return G,J end local function
createSetGui()local E=Instance.new'ScreenGui'E.Name='SetGui'local F=Instance.new
'Frame'F.Name='SetPanel'F.Active=true F.BackgroundTransparency=1 if h then F.
Position=h else F.Position=UDim2.new(0.2,29,0.1,24)end if g then F.Size=g else F
.Size=UDim2.new(0.6,-58,0.64,0)end F.Style=Enum.FrameStyle.RobloxRound F.ZIndex=
6 F.Parent=E local G=Instance.new'Frame'G.Name='ItemPreview'G.
BackgroundTransparency=1 G.Position=UDim2.new(0.8,5,0.085,0)G.Size=UDim2.new(
0.21,0,0.9,0)G.ZIndex=6 G.Parent=F local H=Instance.new'Frame'H.Name='TextPanel'
H.BackgroundTransparency=1 H.Position=UDim2.new(0,0,0.45,0)H.Size=UDim2.new(1,0,
0.55,0)H.ZIndex=6 H.Parent=G local I=Instance.new'TextLabel'I.Name=
'RolloverText'I.BackgroundTransparency=1 I.Size=UDim2.new(1,0,0,48)I.ZIndex=6 I.
Font=Enum.Font.ArialBold I.FontSize=Enum.FontSize.Size24 I.Text=''I.TextColor3=
Color3.new(1,1,1)I.TextWrap=true I.TextXAlignment=Enum.TextXAlignment.Left I.
TextYAlignment=Enum.TextYAlignment.Top I.Parent=H local J=Instance.new
'ImageLabel'J.Name='LargePreview'J.BackgroundTransparency=1 J.Image=''J.Size=
UDim2.new(1,0,0,170)J.ZIndex=6 J.Parent=G local K=Instance.new'Frame'K.Name=
'Sets'K.BackgroundTransparency=1 K.Position=UDim2.new(0,0,0,5)K.Size=UDim2.new(
0.23,0,1,-5)K.ZIndex=6 K.Parent=F local L=Instance.new'Frame'L.Name='Line'L.
BackgroundColor3=Color3.new(1,1,1)L.BackgroundTransparency=0.7 L.BorderSizePixel
=0 L.Position=UDim2.new(1,-3,0.06,0)L.Size=UDim2.new(0,3,0.9,0)L.ZIndex=6 L.
Parent=K local M,N=a.CreateTrueScrollingFrame()M.Size=UDim2.new(1,-6,0.94,0)M.
Position=UDim2.new(0,0,0.06,0)M.BackgroundTransparency=1 M.Name='SetsLists'M.
ZIndex=6 M.Parent=K drillDownSetZIndex(N,7)local O=Instance.new'TextLabel'O.Name
='SetsHeader'O.BackgroundTransparency=1 O.Size=UDim2.new(0,47,0,24)O.ZIndex=6 O.
Font=Enum.Font.ArialBold O.FontSize=Enum.FontSize.Size24 O.Text='Sets'O.
TextColor3=Color3.new(1,1,1)O.TextXAlignment=Enum.TextXAlignment.Left O.
TextYAlignment=Enum.TextYAlignment.Top O.Parent=K local P=Instance.new
'TextButton'P.Name='CancelButton'P.Position=UDim2.new(1,-32,0,-2)P.Size=UDim2.
new(0,34,0,34)P.Style=Enum.ButtonStyle.RobloxButtonDefault P.ZIndex=6 P.Text=''P
.Modal=true P.Parent=F local Q=Instance.new'ImageLabel'Q.Name='CancelImage'Q.
BackgroundTransparency=1 Q.Image='http://www.roblox.com/asset?id=54135717'Q.
Position=UDim2.new(0,-2,0,-2)Q.Size=UDim2.new(0,16,0,16)Q.ZIndex=6 Q.Parent=P
return E end local function createSetButton(E)local F=Instance.new'TextButton'if
E then F.Text=E else F.Text=''end F.AutoButtonColor=false F.
BackgroundTransparency=1 F.BackgroundColor3=Color3.new(1,1,1)F.BorderSizePixel=0
F.Size=UDim2.new(1,-5,0,18)F.ZIndex=6 F.Visible=false F.Font=Enum.Font.Arial F.
FontSize=Enum.FontSize.Size18 F.TextColor3=Color3.new(1,1,1)F.TextXAlignment=
Enum.TextXAlignment.Left return F end local function buildSetButton(E,F,G,H,I)
local J=createSetButton(E)J.Text=E J.Name='SetButton'J.Visible=true local K=
Instance.new'IntValue'K.Name='SetId'K.Value=F K.Parent=J local L=Instance.new
'StringValue'L.Name='SetName'L.Value=E L.Parent=J return J end local function
processCategory(E)local F,I={},0 for J=1,#E do if not i and E[J].Name=='Beta'
then I=I+1 else F[J-I]=buildSetButton(E[J].Name,E[J].CategoryId,E[J].
ImageAssetId,J-I,#E)end end return F end local function handleResize()wait()
local E=o.SetPanel.ItemPreview E.LargePreview.Size=UDim2.new(1,0,0,E.
AbsoluteSize.X)E.LargePreview.Position=UDim2.new(0.5,-E.LargePreview.
AbsoluteSize.X/2,0,0)E.TextPanel.Position=UDim2.new(0,0,0,E.LargePreview.
AbsoluteSize.Y)E.TextPanel.Size=UDim2.new(1,0,0,E.AbsoluteSize.Y-E.LargePreview.
AbsoluteSize.Y)end local function makeInsertAssetButton()local E=Instance.new
'Frame'E.Name='InsertAssetButtonExample'E.Position=UDim2.new(0,128,0,64)E.Size=
UDim2.new(0,64,0,64)E.BackgroundTransparency=1 E.ZIndex=6 E.Visible=false local
F=Instance.new'IntValue'F.Name='AssetId'F.Value=0 F.Parent=E local I=Instance.
new'StringValue'I.Name='AssetName'I.Value=''I.Parent=E local J=Instance.new
'TextButton'J.Name='Button'J.Text=''J.Style=Enum.ButtonStyle.RobloxButton J.
Position=UDim2.new(0.025,0,0.025,0)J.Size=UDim2.new(0.95,0,0.95,0)J.ZIndex=6 J.
Parent=E local K=Instance.new'ImageLabel'K.Name='ButtonImage'K.Image=''K.
Position=UDim2.new(0,-7,0,-7)K.Size=UDim2.new(1,14,1,14)K.BackgroundTransparency
=1 K.ZIndex=7 K.Parent=J local L=K:clone()L.Name='ConfigIcon'L.Visible=false L.
Position=UDim2.new(1,-23,1,-24)L.Size=UDim2.new(0,16,0,16)L.Image=''L.ZIndex=6 L
.Parent=E return E end local function showLargePreview(E)if E:FindFirstChild
'AssetId'then delay(0,function()game:GetService'ContentProvider':Preload(z..
tostring(E.AssetId.Value))o.SetPanel.ItemPreview.LargePreview.Image=z..tostring(
E.AssetId.Value)end)end if E:FindFirstChild'AssetName'then o.SetPanel.
ItemPreview.TextPanel.RolloverText.Text=E.AssetName.Value end end local function
selectTerrainShape(E)if B then c(tostring(B.AssetName.Value),tonumber(B.AssetId.
Value),E)end end local function createTerrainTypeButton(E,F)local I=Instance.new
'TextButton'I.Name=E..'Button'I.Font=Enum.Font.ArialBold I.FontSize=Enum.
FontSize.Size14 I.BorderSizePixel=0 I.TextColor3=Color3.new(1,1,1)I.Text=E I.
TextXAlignment=Enum.TextXAlignment.Left I.BackgroundTransparency=1 I.ZIndex=F.
ZIndex+1 I.Size=UDim2.new(0,F.Size.X.Offset-2,0,16)I.Position=UDim2.new(0,1,0,0)
I.MouseEnter:connect(function()I.BackgroundTransparency=0 I.TextColor3=Color3.
new(0,0,0)end)I.MouseLeave:connect(function()I.BackgroundTransparency=1 I.
TextColor3=Color3.new(1,1,1)end)I.MouseButton1Click:connect(function()I.
BackgroundTransparency=1 I.TextColor3=Color3.new(1,1,1)if I.Parent and I.Parent:
IsA'GuiObject'then I.Parent.Visible=false end selectTerrainShape(D[I.Text])end)
return I end local function createTerrainDropDownMenu(E)local F=Instance.new
'Frame'F.Name='TerrainDropDown'F.BackgroundColor3=Color3.new(0,0,0)F.
BorderColor3=Color3.new(1,0,0)F.Size=UDim2.new(0,200,0,0)F.Visible=false F.
ZIndex=E F.Parent=o for I=1,#C do local J=createTerrainTypeButton(C[I],F)J.
Position=UDim2.new(0,1,0,(I-1)*J.Size.Y.Offset)J.Parent=F F.Size=UDim2.new(0,200
,0,F.Size.Y.Offset+J.Size.Y.Offset)end F.MouseLeave:connect(function()F.Visible=
false end)end local function createDropDownMenuButton(E)local F=Instance.new
'ImageButton'F.Name='DropDownButton'F.Image=
'http://www.roblox.com/asset/?id=67581509'F.BackgroundTransparency=1 F.Size=
UDim2.new(0,16,0,16)F.Position=UDim2.new(1,-24,0,6)F.ZIndex=E.ZIndex+2 F.Parent=
E if not o:FindFirstChild'TerrainDropDown'then createTerrainDropDownMenu(8)end F
.MouseButton1Click:connect(function()o.TerrainDropDown.Visible=true o.
TerrainDropDown.Position=UDim2.new(0,E.AbsolutePosition.X,0,E.AbsolutePosition.Y
)B=E end)end local function buildInsertButton()local E=makeInsertAssetButton()E.
Name='InsertAssetButton'E.Visible=true if t.Category[t.CurrentCategory].SetName
=='High Scalability'then createDropDownMenuButton(E)end local F=nil local I=E.
MouseEnter:connect(function()F=E delay(0.1,function()if F==E then
showLargePreview(E)end end)end)return E,I end local function realignButtonGrid(E
)local F,I=0,0 for J=1,#l do l[J].Position=UDim2.new(0,w*F,0,x*I)F=F+1 if F>=E
then F=0 I=I+1 end end end local function setInsertButtonImageBehavior(E,F,I,J)
if F then E.AssetName.Value=I E.AssetId.Value=J local K=y..J if K~=E.Button.
ButtonImage.Image then delay(0,function()game:GetService'ContentProvider':
Preload(y..J)E.Button.ButtonImage.Image=y..J end)end table.insert(m,E.Button.
MouseButton1Click:connect(function()local L=(I=='Water')and(t.Category[t.
CurrentCategory].SetName=='High Scalability')r.Visible=L if L then c(I,tonumber(
J),nil)else c(I,tonumber(J))end end))E.Visible=true else E.Visible=false end end
local function loadSectionOfItems(E,F,I)local J=F*I if k>#n then return end
local K=k for L=1,J+1 do if k>=#n+1 then break end local M l[k],M=
buildInsertButton()table.insert(m,M)l[k].Parent=E.SetPanel.ItemsFrame k=k+1 end
realignButtonGrid(I)for L=K,k do if l[L]then if n[L]then if n[L].Name=='Water'
then if t.Category[t.CurrentCategory].SetName=='High Scalability'then l[L]:
FindFirstChild('DropDownButton',true):Destroy()end end local M if j then M=n[L].
AssetVersionId else M=n[L].AssetId end setInsertButtonImageBehavior(l[L],true,n[
L].Name,M)else break end else break end end end local function setSetIndex()t.
Category[t.CurrentCategory].Index=0 local E,F=7,math.floor(o.SetPanel.ItemsFrame
.AbsoluteSize.X/w)n=t.Category[t.CurrentCategory].Contents if n then for I=1,#l
do l[I]:remove()end for I=1,#m do if m[I]then m[I]:disconnect()end end m={}l={}k
=1 loadSectionOfItems(o,E,F)end end local function selectSet(E,F,I,J)if E and t.
Category[t.CurrentCategory]~=nil then if E~=t.Category[t.CurrentCategory].Button
then t.Category[t.CurrentCategory].Button=E if u[I]==nil then u[I]=game:
GetService'InsertService':GetCollection(I)end t.Category[t.CurrentCategory].
Contents=u[I]t.Category[t.CurrentCategory].SetName=F t.Category[t.
CurrentCategory].SetId=I end setSetIndex()end end local function
selectCategoryPage(E,F)if E~=t.CurrentCategory then if t.CurrentCategory then
for I,J in pairs(t.CurrentCategory)do J.Visible=false end end t.CurrentCategory=
E if t.Category[t.CurrentCategory]==nil then t.Category[t.CurrentCategory]={}if#
E>0 then selectSet(E[1],E[1].SetName.Value,E[1].SetId.Value,0)end else t.
Category[t.CurrentCategory].Button=nil selectSet(t.Category[t.CurrentCategory].
ButtonFrame,t.Category[t.CurrentCategory].SetName,t.Category[t.CurrentCategory].
SetId,t.Category[t.CurrentCategory].Index)end end end local function
selectCategory(E)selectCategoryPage(E,0)end local function
resetAllSetButtonSelection()local E=o.SetPanel.Sets.SetsLists:GetChildren()for F
=1,#E do if E[F]:IsA'TextButton'then E[F].Selected=false E[F].
BackgroundTransparency=1 E[F].TextColor3=Color3.new(1,1,1)E[F].BackgroundColor3=
Color3.new(1,1,1)end end end local function populateSetsFrame()local E=0 for F=1
,#v do local I=v[F]I.Visible=true I.Position=UDim2.new(0,5,0,E*I.Size.Y.Offset)I
.Parent=o.SetPanel.Sets.SetsLists if F==1 then I.Selected=true I.
BackgroundColor3=Color3.new(0,0.8,0)I.TextColor3=Color3.new(0,0,0)I.
BackgroundTransparency=0 end I.MouseEnter:connect(function()if not I.Selected
then I.BackgroundTransparency=0 I.TextColor3=Color3.new(0,0,0)end end)I.
MouseLeave:connect(function()if not I.Selected then I.BackgroundTransparency=1 I
.TextColor3=Color3.new(1,1,1)end end)I.MouseButton1Click:connect(function()
resetAllSetButtonSelection()I.Selected=not I.Selected I.BackgroundColor3=Color3.
new(0,0.8,0)I.TextColor3=Color3.new(0,0,0)I.BackgroundTransparency=0 selectSet(I
,I.Text,v[F].SetId.Value,0)end)E=E+1 end local F=o.SetPanel.Sets.SetsLists:
GetChildren()if F then for I=1,#F do if F[I]:IsA'TextButton'then selectSet(F[I],
F[I].Text,v[I].SetId.Value,0)selectCategory(v)break end end end end o=
createSetGui()r,s=createWaterGui()r.Position=UDim2.new(0,55,0,0)r.Parent=o o.
Changed:connect(function(E)if E=='AbsoluteSize'then handleResize()setSetIndex()
end end)local E,F=a.CreateTrueScrollingFrame()E.Size=UDim2.new(0.54,0,0.85,0)E.
Position=UDim2.new(0.24,0,0.085,0)E.Name='ItemsFrame'E.ZIndex=6 E.Parent=o.
SetPanel E.BackgroundTransparency=1 drillDownSetZIndex(F,7)F.Parent=o.SetPanel F
.Position=UDim2.new(0.76,5,0,0)local I=false F.ScrollBottom.Changed:connect(
function(J)if F.ScrollBottom.Value==true then if I then return end I=true
loadSectionOfItems(o,rows,columns)I=false end end)local J={}for K=1,#b do local
L=game:GetService'InsertService':GetUserSets(b[K])if L and#L>2 then for M=3,#L
do if L[M].Name=='High Scalability'then table.insert(J,1,L[M])else table.insert(
J,L[M])end end end end if J then v=processCategory(J)end rows=math.floor(o.
SetPanel.ItemsFrame.AbsoluteSize.Y/x)columns=math.floor(o.SetPanel.ItemsFrame.
AbsoluteSize.X/w)populateSetsFrame()o.SetPanel.CancelButton.MouseButton1Click:
connect(function()o.SetPanel.Visible=false if d then d()end end)local K,L=
function(K)if K then o.SetPanel.Visible=true else o.SetPanel.Visible=false end
end,function()if o then if o:FindFirstChild'SetPanel'then return o.SetPanel.
Visible end end return false end return o,K,L,s end a.
CreateTerrainMaterialSelector=function(b,c)local d=Instance.new'BindableEvent'd.
Name='TerrainMaterialSelectionChanged'local g,h=nil,Instance.new'Frame'h.Name=
'TerrainMaterialSelector'if b then h.Size=b else h.Size=UDim2.new(0,245,0,230)
end if c then h.Position=c end h.BorderSizePixel=0 h.BackgroundColor3=Color3.
new(0,0,0)h.Active=true d.Parent=h local i,j,k=true,{},{'Grass','Sand','Brick',
'Granite','Asphalt','Iron','Aluminum','Gold','Plank','Log','Gravel',
'Cinder Block','Stone Wall','Concrete','Plastic (red)','Plastic (blue)'}if i
then table.insert(k,'Water')end local l=1 function getEnumFromName(m)if m==
'Grass'then return 1 end if m=='Sand'then return 2 end if m=='Erase'then return
0 end if m=='Brick'then return 3 end if m=='Granite'then return 4 end if m==
'Asphalt'then return 5 end if m=='Iron'then return 6 end if m=='Aluminum'then
return 7 end if m=='Gold'then return 8 end if m=='Plank'then return 9 end if m==
'Log'then return 10 end if m=='Gravel'then return 11 end if m=='Cinder Block'
then return 12 end if m=='Stone Wall'then return 13 end if m=='Concrete'then
return 14 end if m=='Plastic (red)'then return 15 end if m=='Plastic (blue)'then
return 16 end if m=='Water'then return 17 end end function getNameFromEnum(m)if
m==Enum.CellMaterial.Grass or m==1 then return'Grass'elseif m==Enum.CellMaterial
.Sand or m==2 then return'Sand'elseif m==Enum.CellMaterial.Empty or m==0 then
return'Erase'elseif m==Enum.CellMaterial.Brick or m==3 then return'Brick'elseif
m==Enum.CellMaterial.Granite or m==4 then return'Granite'elseif m==Enum.
CellMaterial.Asphalt or m==5 then return'Asphalt'elseif m==Enum.CellMaterial.
Iron or m==6 then return'Iron'elseif m==Enum.CellMaterial.Aluminum or m==7 then
return'Aluminum'elseif m==Enum.CellMaterial.Gold or m==8 then return'Gold'elseif
m==Enum.CellMaterial.WoodPlank or m==9 then return'Plank'elseif m==Enum.
CellMaterial.WoodLog or m==10 then return'Log'elseif m==Enum.CellMaterial.Gravel
or m==11 then return'Gravel'elseif m==Enum.CellMaterial.CinderBlock or m==12
then return'Cinder Block'elseif m==Enum.CellMaterial.MossyStone or m==13 then
return'Stone Wall'elseif m==Enum.CellMaterial.Cement or m==14 then return
'Concrete'elseif m==Enum.CellMaterial.RedPlastic or m==15 then return
'Plastic (red)'elseif m==Enum.CellMaterial.BluePlastic or m==16 then return
'Plastic (blue)'end if i then if m==Enum.CellMaterial.Water or m==17 then return
'Water'end end end local function updateMaterialChoice(m)l=getEnumFromName(m)d:
Fire(l)end for m,n in pairs(k)do j[n]={}if n=='Grass'then j[n].Regular=
'http://www.roblox.com/asset/?id=56563112'elseif n=='Sand'then j[n].Regular=
'http://www.roblox.com/asset/?id=62356652'elseif n=='Brick'then j[n].Regular=
'http://www.roblox.com/asset/?id=65961537'elseif n=='Granite'then j[n].Regular=
'http://www.roblox.com/asset/?id=67532153'elseif n=='Asphalt'then j[n].Regular=
'http://www.roblox.com/asset/?id=67532038'elseif n=='Iron'then j[n].Regular=
'http://www.roblox.com/asset/?id=67532093'elseif n=='Aluminum'then j[n].Regular=
'http://www.roblox.com/asset/?id=67531995'elseif n=='Gold'then j[n].Regular=
'http://www.roblox.com/asset/?id=67532118'elseif n=='Plastic (red)'then j[n].
Regular='http://www.roblox.com/asset/?id=67531848'elseif n=='Plastic (blue)'then
j[n].Regular='http://www.roblox.com/asset/?id=67531924'elseif n=='Plank'then j[n
].Regular='http://www.roblox.com/asset/?id=67532015'elseif n=='Log'then j[n].
Regular='http://www.roblox.com/asset/?id=67532051'elseif n=='Gravel'then j[n].
Regular='http://www.roblox.com/asset/?id=67532206'elseif n=='Cinder Block'then j
[n].Regular='http://www.roblox.com/asset/?id=67532103'elseif n=='Stone Wall'then
j[n].Regular='http://www.roblox.com/asset/?id=67531804'elseif n=='Concrete'then
j[n].Regular='http://www.roblox.com/asset/?id=67532059'elseif n=='Water'then j[n
].Regular='http://www.roblox.com/asset/?id=81407474'else j[n].Regular=
'http://www.roblox.com/asset/?id=66887593'end end local o,p,q,r=a.
CreateScrollingFrame(nil,'grid')o.Size=UDim2.new(0.85,0,1,0)o.Position=UDim2.
new(0,0,0,0)o.Parent=h p.Parent=h p.Visible=true p.Position=UDim2.new(1,-19,0,0)
q.Parent=h q.Visible=true q.Position=UDim2.new(1,-19,1,-17)local function
goToNewMaterial(s,t)updateMaterialChoice(t)s.BackgroundTransparency=0 g.
BackgroundTransparency=1 g=s end local function createMaterialButton(s)local t=
Instance.new'TextButton't.Text=''t.Size=UDim2.new(0,32,0,32)t.BackgroundColor3=
Color3.new(1,1,1)t.BorderSizePixel=0 t.BackgroundTransparency=1 t.
AutoButtonColor=false t.Name=tostring(s)local u=Instance.new'ImageButton'u.
AutoButtonColor=false u.BackgroundTransparency=1 u.Size=UDim2.new(0,30,0,30)u.
Position=UDim2.new(0,1,0,1)u.Name=tostring(s)u.Parent=t u.Image=j[s].Regular
local v=Instance.new'NumberValue'v.Name='EnumType'v.Parent=t v.Value=0 u.
MouseEnter:connect(function()t.BackgroundTransparency=0 end)u.MouseLeave:
connect(function()if g~=t then t.BackgroundTransparency=1 end end)u.
MouseButton1Click:connect(function()if g~=t then goToNewMaterial(t,tostring(s))
end end)return t end for s=1,#k do local t=createMaterialButton(k[s])if k[s]==
'Grass'then g=t t.BackgroundTransparency=0 end t.Parent=o end local s=function(s
)if not s then return end if l==s then return end local t,u=getNameFromEnum(s),o
:GetChildren()for v=1,#u do if u[v].Name=='Plastic (blue)'and t==
'Plastic (blue)'then goToNewMaterial(u[v],t)return end if u[v].Name==
'Plastic (red)'and t=='Plastic (red)'then goToNewMaterial(u[v],t)return end if
string.find(u[v].Name,t)then goToNewMaterial(u[v],t)return end end end h.Changed
:connect(function(t)if t=='AbsoluteSize'then r()end end)r()return h,d,s end a.
CreateLoadingFrame=function(b,c,d)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=35238053'local g=Instance.new'Frame'g.Name=
'LoadingFrame'g.Style=Enum.FrameStyle.RobloxRound if c then g.Size=c else g.Size
=UDim2.new(0,300,0,160)end if d then g.Position=d else g.Position=UDim2.new(0.5,
-150,0.5,-80)end local h=Instance.new'Frame'h.Name='LoadingBar'h.
BackgroundColor3=Color3.new(0,0,0)h.BorderColor3=Color3.new(0.30980392156862746,
0.30980392156862746,0.30980392156862746)h.Position=UDim2.new(0,0,0,41)h.Size=
UDim2.new(1,0,0,30)h.Parent=g local i=Instance.new'ImageLabel'i.Name=
'LoadingGreenBar'i.Image='http://www.roblox.com/asset/?id=35238053'i.Position=
UDim2.new(0,0,0,0)i.Size=UDim2.new(0,0,1,0)i.Visible=false i.Parent=h local j=
Instance.new'TextLabel'j.Name='LoadingPercent'j.BackgroundTransparency=1 j.
Position=UDim2.new(0,0,1,0)j.Size=UDim2.new(1,0,0,14)j.Font=Enum.Font.Arial j.
Text='0%'j.FontSize=Enum.FontSize.Size14 j.TextColor3=Color3.new(1,1,1)j.Parent=
h local k=Instance.new'TextButton'k.Name='CancelButton'k.Position=UDim2.new(0.5,
-60,1,-40)k.Size=UDim2.new(0,120,0,40)k.Font=Enum.Font.Arial k.FontSize=Enum.
FontSize.Size18 k.TextColor3=Color3.new(1,1,1)k.Text='Cancel'k.Style=Enum.
ButtonStyle.RobloxButton k.Parent=g local l=Instance.new'TextLabel'l.Name=
'loadingName'l.BackgroundTransparency=1 l.Size=UDim2.new(1,0,0,18)l.Position=
UDim2.new(0,0,0,2)l.Font=Enum.Font.Arial l.Text=b l.TextColor3=Color3.new(1,1,1)
l.TextStrokeTransparency=1 l.FontSize=Enum.FontSize.Size18 l.Parent=g local m=
Instance.new'BindableEvent'm.Name='CancelButtonClicked'm.Parent=k k.
MouseButton1Click:connect(function()m:Fire()end)local n=function(n,o,p)if n and
type(n)~='number'then error(
'updateLoadingGuiPercent expects number as argument, got',type(n),'instead')end
local q=nil if n<0 then q=UDim2.new(0,0,1,0)elseif n>1 then q=UDim2.new(1,0,1,0)
else q=UDim2.new(n,0,1,0)end if o then if not p then error
[[updateLoadingGuiPercent is set to tween new percentage, but got no tween time length! Please pass this in as third argument]]
end if q.X.Scale>0 then i.Visible=true i:TweenSize(q,Enum.EasingDirection.Out,
Enum.EasingStyle.Quad,p,true)else i:TweenSize(q,Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,p,true,function()if q.X.Scale<0 then i.Visible=false end end)
end else i.Size=q i.Visible=(q.X.Scale>0)end end i.Changed:connect(function(o)if
o=='Size'then j.Text=tostring(math.ceil(i.Size.X.Scale*100))..'%'end end)return
g,n,m end a.CreatePluginFrame=function(b,c,d,g,h)function createMenuButton(i,j,k
,l,m,n)local o=Instance.new'TextButton'o.AutoButtonColor=false o.Name=m o.
BackgroundTransparency=1 o.Position=j o.Size=i o.Font=Enum.Font.ArialBold o.
FontSize=l o.Text=k o.TextColor3=Color3.new(1,1,1)o.BorderSizePixel=0 o.
BackgroundColor3=Color3.new(7.8431372549019605E-2,7.8431372549019605E-2,
7.8431372549019605E-2)o.MouseEnter:connect(function()if o.Selected then return
end o.BackgroundTransparency=0 end)o.MouseLeave:connect(function()if o.Selected
then return end o.BackgroundTransparency=1 end)o.Parent=n return o end local i=
Instance.new'Frame'i.Name=tostring(b)..'DragBar'i.BackgroundColor3=Color3.new(
0.15294117647058825,0.15294117647058825,0.15294117647058825)i.BorderColor3=
Color3.new(0,0,0)if c then i.Size=UDim2.new(c.X.Scale,c.X.Offset,0,20)+UDim2.
new(0,20,0,0)else i.Size=UDim2.new(0,183,0,20)end if d then i.Position=d end i.
Active=true i.Draggable=true i.MouseEnter:connect(function()i.BackgroundColor3=
Color3.new(0.19215686274509805,0.19215686274509805,0.19215686274509805)end)i.
MouseLeave:connect(function()i.BackgroundColor3=Color3.new(0.15294117647058825,
0.15294117647058825,0.15294117647058825)end)i.Parent=h local j=Instance.new
'TextLabel'j.Name='BarNameLabel'j.Text=' '..tostring(b)j.TextColor3=Color3.new(1
,1,1)j.TextStrokeTransparency=0 j.Size=UDim2.new(1,0,1,0)j.Font=Enum.Font.
ArialBold j.FontSize=Enum.FontSize.Size18 j.TextXAlignment=Enum.TextXAlignment.
Left j.BackgroundTransparency=1 j.Parent=i local k,l=createMenuButton(UDim2.new(
0,15,0,17),UDim2.new(1,-16,0.5,-8),'X',Enum.FontSize.Size14,'CloseButton',i),
Instance.new'BindableEvent'l.Name='CloseEvent'l.Parent=k k.MouseButton1Click:
connect(function()l:Fire()k.BackgroundTransparency=1 end)local m,n=
createMenuButton(UDim2.new(0,15,0,17),UDim2.new(1,-51,0.5,-8),'?',Enum.FontSize.
Size14,'HelpButton',i),Instance.new'Frame'n.Name='HelpFrame'n.BackgroundColor3=
Color3.new(0,0,0)n.Size=UDim2.new(0,300,0,552)n.Position=UDim2.new(1,5,0,0)n.
Active=true n.BorderSizePixel=0 n.Visible=false n.Parent=i m.MouseButton1Click:
connect(function()n.Visible=not n.Visible if n.Visible then m.Selected=true m.
BackgroundTransparency=0 local o=getScreenGuiAncestor(n)if o then if n.
AbsolutePosition.X+n.AbsoluteSize.X>o.AbsoluteSize.X then n.Position=UDim2.new(0
,-5-n.AbsoluteSize.X,0,0)else n.Position=UDim2.new(1,5,0,0)end else n.Position=
UDim2.new(1,5,0,0)end else m.Selected=false m.BackgroundTransparency=1 end end)
local o=createMenuButton(UDim2.new(0,16,0,17),UDim2.new(1,-34,0.5,-8),'-',Enum.
FontSize.Size14,'MinimizeButton',i)o.TextYAlignment=Enum.TextYAlignment.Top
local p=Instance.new'Frame'p.Name='MinimizeFrame'p.BackgroundColor3=Color3.new(
0.28627450980392155,0.28627450980392155,0.28627450980392155)p.BorderColor3=
Color3.new(0,0,0)p.Position=UDim2.new(0,0,1,0)if c then p.Size=UDim2.new(c.X.
Scale,c.X.Offset,0,50)+UDim2.new(0,20,0,0)else p.Size=UDim2.new(0,183,0,50)end p
.Visible=false p.Parent=i local q=Instance.new'TextButton'q.Position=UDim2.new(
0.5,-50,0.5,-20)q.Name='MinimizeButton'q.Size=UDim2.new(0,100,0,40)q.Style=Enum.
ButtonStyle.RobloxButton q.Font=Enum.Font.ArialBold q.FontSize=Enum.FontSize.
Size18 q.TextColor3=Color3.new(1,1,1)q.Text='Show'q.Parent=p local r=Instance.
new'Frame'r.Name='SeparatingLine'r.BackgroundColor3=Color3.new(
0.45098039215686275,0.45098039215686275,0.45098039215686275)r.BorderSizePixel=0
r.Position=UDim2.new(1,-18,0.5,-7)r.Size=UDim2.new(0,1,0,14)r.Parent=i local s=r
:clone()s.Position=UDim2.new(1,-35,0.5,-7)s.Parent=i local t=Instance.new'Frame'
t.Name='WidgetContainer't.BackgroundTransparency=1 t.Position=UDim2.new(0,0,1,0)
t.BorderColor3=Color3.new(0,0,0)if not g then t.BackgroundTransparency=0 t.
BackgroundColor3=Color3.new(0.2823529411764706,0.2823529411764706,
0.2823529411764706)end t.Parent=i if c then if g then t.Size=c else t.Size=UDim2
.new(0,i.AbsoluteSize.X,c.Y.Scale,c.Y.Offset)end else if g then t.Size=UDim2.
new(0,163,0,400)else t.Size=UDim2.new(0,i.AbsoluteSize.X,0,400)end end if d then
t.Position=d+UDim2.new(0,0,0,20)end local u,v,w=nil if g then u,v=a.
CreateTrueScrollingFrame()u.Size=UDim2.new(1,0,1,0)u.BackgroundColor3=Color3.
new(0.2823529411764706,0.2823529411764706,0.2823529411764706)u.BorderColor3=
Color3.new(0,0,0)u.Active=true u.Parent=t v.Parent=i v.BackgroundColor3=Color3.
new(0.2823529411764706,0.2823529411764706,0.2823529411764706)v.BorderSizePixel=0
v.BackgroundTransparency=0 v.Position=UDim2.new(1,-21,1,1)if c then v.Size=UDim2
.new(0,21,c.Y.Scale,c.Y.Offset)else v.Size=UDim2.new(0,21,0,400)end v:
FindFirstChild'ScrollDownButton'.Position=UDim2.new(0,0,1,-20)local x=Instance.
new'Frame'x.Name='FakeLine'x.BorderSizePixel=0 x.BackgroundColor3=Color3.new(0,0
,0)x.Size=UDim2.new(0,1,1,1)x.Position=UDim2.new(1,0,0,0)x.Parent=v w=Instance.
new'TextButton'w.ZIndex=2 w.AutoButtonColor=false w.Name='VerticalDragger'w.
BackgroundColor3=Color3.new(0.19607843137254902,0.19607843137254902,
0.19607843137254902)w.BorderColor3=Color3.new(0,0,0)w.Size=UDim2.new(1,20,0,20)w
.Position=UDim2.new(0,0,1,0)w.Active=true w.Text=''w.Parent=t local y=Instance.
new'Frame'y.Name='ScrubFrame'y.BackgroundColor3=Color3.new(1,1,1)y.
BorderSizePixel=0 y.Position=UDim2.new(0.5,-5,0.5,0)y.Size=UDim2.new(0,10,0,1)y.
ZIndex=5 y.Parent=w local z=y:clone()z.Position=UDim2.new(0.5,-5,0.5,-2)z.Parent
=w local A=y:clone()A.Position=UDim2.new(0.5,-5,0.5,2)A.Parent=w local B=
Instance.new'TextButton'B.Name='AreaSoak'B.Size=UDim2.new(1,0,1,0)B.
BackgroundTransparency=1 B.BorderSizePixel=0 B.Text=''B.ZIndex=10 B.Visible=
false B.Active=true B.Parent=getScreenGuiAncestor(h)local C,D=false,nil w.
MouseEnter:connect(function()w.BackgroundColor3=Color3.new(0.23529411764705882,
0.23529411764705882,0.23529411764705882)end)w.MouseLeave:connect(function()w.
BackgroundColor3=Color3.new(0.19607843137254902,0.19607843137254902,
0.19607843137254902)end)w.MouseButton1Down:connect(function(E,F)C=true B.Visible
=true D=F end)B.MouseButton1Up:connect(function()C=false B.Visible=false end)B.
MouseMoved:connect(function(E,F)if not C then return end local I=F-D if not v.
ScrollDownButton.Visible and I>0 then return end if(t.Size.Y.Offset+I)<150 then
t.Size=UDim2.new(t.Size.X.Scale,t.Size.X.Offset,t.Size.Y.Scale,150)v.Size=UDim2.
new(0,21,0,150)return end D=F if t.Size.Y.Offset+I>=0 then t.Size=UDim2.new(t.
Size.X.Scale,t.Size.X.Offset,t.Size.Y.Scale,t.Size.Y.Offset+I)v.Size=UDim2.new(0
,21,0,v.Size.Y.Offset+I)end end)end local function switchMinimize()p.Visible=not
p.Visible if g then u.Visible=not u.Visible w.Visible=not w.Visible v.Visible=
not v.Visible else t.Visible=not t.Visible end if p.Visible then o.Text='+'else
o.Text='-'end end q.MouseButton1Click:connect(function()switchMinimize()end)o.
MouseButton1Click:connect(function()switchMinimize()end)if g then return i,u,n,l
else return i,t,n,l end end a.Help=function(b)if b=='CreatePropertyDropDownMenu'
or b==a.CreatePropertyDropDownMenu then return
[[Function CreatePropertyDropDownMenu.  Arguments: (instance, propertyName, enumType).  Side effect: returns a container with a drop-down-box that is linked to the 'property' field of 'instance' which is of type 'enumType']]
end if b=='CreateDropDownMenu'or b==a.CreateDropDownMenu then return
[[Function CreateDropDownMenu.  Arguments: (items, onItemSelected).  Side effect: Returns 2 results, a container to the gui object and a 'updateSelection' function for external updating.  The container is a drop-down-box created around a list of items]]
end if b=='CreateMessageDialog'or b==a.CreateMessageDialog then return
[[Function CreateMessageDialog.  Arguments: (title, message, buttons). Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in.  'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button]]
end if b=='CreateStyledMessageDialog'or b==a.CreateStyledMessageDialog then
return
[[Function CreateStyledMessageDialog.  Arguments: (title, message, style, buttons). Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in.  'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button, 'style' is a string, either Error, Notify or Confirm]]
end if b=='GetFontHeight'or b==a.GetFontHeight then return
[[Function GetFontHeight.  Arguments: (font, fontSize). Side effect: returns the size in pixels of the given font + fontSize]]
end if b=='CreateScrollingFrame'or b==a.CreateScrollingFrame then return
[[Function CreateScrollingFrame.  Arguments: (orderList, style) Side effect: returns 4 objects, (scrollFrame, scrollUpButton, scrollDownButton, recalculateFunction).  'scrollFrame' can be filled with GuiObjects.  It will lay them out and allow scrollUpButton/scrollDownButton to interact with them.  Orderlist is optional (and specifies the order to layout the children.  Without orderlist, it uses the children order. style is also optional, and allows for a 'grid' styling if style is passed 'grid' as a string.  recalculateFunction can be called when a relayout is needed (when orderList changes)]]
end if b=='CreateTrueScrollingFrame'or b==a.CreateTrueScrollingFrame then return
[[Function CreateTrueScrollingFrame.  Arguments: (nil) Side effect: returns 2 objects, (scrollFrame, controlFrame).  'scrollFrame' can be filled with GuiObjects, and they will be clipped if not inside the frame's bounds. controlFrame has children scrollup and scrolldown, as well as a slider.  controlFrame can be parented to any guiobject and it will readjust itself to fit.]]
end if b=='AutoTruncateTextObject'or b==a.AutoTruncateTextObject then return
[[Function AutoTruncateTextObject.  Arguments: (textLabel) Side effect: returns 2 objects, (textLabel, changeText).  The 'textLabel' input is modified to automatically truncate text (with ellipsis), if it gets too small to fit.  'changeText' is a function that can be used to change the text, it takes 1 string as an argument]]
end if b=='CreateSlider'or b==a.CreateSlider then return
[[Function CreateSlider.  Arguments: (steps, width, position) Side effect: returns 2 objects, (sliderGui, sliderPosition).  The 'steps' argument specifies how many different positions the slider can hold along the bar.  'width' specifies in pixels how wide the bar should be (modifiable afterwards if desired). 'position' argument should be a UDim2 for slider positioning. 'sliderPosition' is an IntValue whose current .Value specifies the specific step the slider is currently on.]]
end if b=='CreateLoadingFrame'or b==a.CreateLoadingFrame then return
[[Function CreateLoadingFrame.  Arguments: (name, size, position) Side effect: Creates a gui that can be manipulated to show progress for a particular action.  Name appears above the loading bar, and size and position are udim2 values (both size and position are optional arguments).  Returns 3 arguments, the first being the gui created. The second being updateLoadingGuiPercent, which is a bindable function.  This function takes one argument (two optionally), which should be a number between 0 and 1, representing the percentage the loading gui should be at.  The second argument to this function is a boolean value that if set to true will tween the current percentage value to the new percentage value, therefore our third argument is how long this tween should take. Our third returned argument is a BindableEvent, that when fired means that someone clicked the cancel button on the dialog.]]
end if b=='CreateTerrainMaterialSelector'or b==a.CreateTerrainMaterialSelector
then return
[[Function CreateTerrainMaterialSelector.  Arguments: (size, position) Side effect: Size and position are UDim2 values that specifies the selector's size and position.  Both size and position are optional arguments. This method returns 3 objects (terrainSelectorGui, terrainSelected, forceTerrainSelection).  terrainSelectorGui is just the gui object that we generate with this function, parent it as you like. TerrainSelected is a BindableEvent that is fired whenever a new terrain type is selected in the gui.  ForceTerrainSelection is a function that takes an argument of Enum.CellMaterial and will force the gui to show that material as currently selected.]]
end end return a