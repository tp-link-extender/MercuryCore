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
layoutGuiObjectsHelper(g,c,d)end a.CreateSlider=function(b,c,d)local e=Instance.
new'Frame'e.Size=UDim2.new(1,0,1,0)e.BackgroundTransparency=1 e.Name='SliderGui'
local g=Instance.new'IntValue'g.Name='SliderSteps'g.Value=b g.Parent=e local h=
Instance.new'TextButton'h.Name='AreaSoak'h.Text=''h.BackgroundTransparency=1 h.
Active=false h.Size=UDim2.new(1,0,1,0)h.Visible=false h.ZIndex=4 e.
AncestryChanged:connect(function(i,j)if j==nil then h.Parent=nil else h.Parent=
getScreenGuiAncestor(e)end end)local i=Instance.new'IntValue'i.Name=
'SliderPosition'i.Value=0 i.Parent=e local j,k=math.random(1,100),Instance.new
'TextButton'k.Text=''k.AutoButtonColor=false k.Name='Bar'k.BackgroundColor3=
Color3.new(0,0,0)if type(c)=='number'then k.Size=UDim2.new(0,c,0,5)else k.Size=
UDim2.new(0,200,0,5)end k.BorderColor3=Color3.new(0.37254901960784315,
0.37254901960784315,0.37254901960784315)k.ZIndex=2 k.Parent=e if d['X']and d['X'
]['Scale']and d['X']['Offset']and d['Y']and d['Y']['Scale']and d['Y']['Offset']
then k.Position=d end local l=Instance.new'ImageButton'l.Name='Slider'l.
BackgroundTransparency=1 l.Image='rbxasset://textures/ui/Slider.png'l.Position=
UDim2.new(0,0,0.5,-10)l.Size=UDim2.new(0,20,0,20)l.ZIndex=3 l.Parent=k local m=
nil h.MouseLeave:connect(function()if h.Visible then cancelSlide(h)end end)h.
MouseButton1Up:connect(function()if h.Visible then cancelSlide(h)end end)l.
MouseButton1Down:connect(function()h.Visible=true if m then m:disconnect()end m=
h.MouseMoved:connect(function(n,o)setSliderPos(n,l,i,k,b)end)end)l.
MouseButton1Up:connect(function()cancelSlide(h)end)i.Changed:connect(function(n)
i.Value=math.min(b,math.max(1,i.Value))local o=(i.Value-1)/(b-1)l.Position=UDim2
.new(o,-l.AbsoluteSize.X/2,l.Position.Y.Scale,l.Position.Y.Offset)end)k.
MouseButton1Down:connect(function(n,o)setSliderPos(n,l,i,k,b)end)return e,i,g
end a.CreateTrueScrollingFrame=function()local b,c,d,e,g,h,i=nil,nil,nil,nil,
false,{},Instance.new'Frame'i.Name='ScrollingFrame'i.Active=true i.Size=UDim2.
new(1,0,1,0)i.ClipsDescendants=true local j=Instance.new'Frame'j.Name=
'ControlFrame'j.BackgroundTransparency=1 j.Size=UDim2.new(0,18,1,0)j.Position=
UDim2.new(1,-20,0,0)j.Parent=i local k=Instance.new'BoolValue'k.Value=false k.
Name='ScrollBottom'k.Parent=j local l=Instance.new'BoolValue'l.Value=false l.
Name='scrollUp'l.Parent=j local m=Instance.new'TextButton'm.Name=
'ScrollUpButton'm.Text=''m.AutoButtonColor=false m.BackgroundColor3=Color3.new(0
,0,0)m.BorderColor3=Color3.new(1,1,1)m.BackgroundTransparency=0.5 m.Size=UDim2.
new(0,18,0,18)m.ZIndex=2 m.Parent=j for n=1,6 do local o=Instance.new'Frame'o.
BorderColor3=Color3.new(1,1,1)o.Name='tri'..tostring(n)o.ZIndex=3 o.
BackgroundTransparency=0.5 o.Size=UDim2.new(0,12-((n-1)*2),0,0)o.Position=UDim2.
new(0,3+(n-1),0.5,2-(n-1))o.Parent=m end m.MouseEnter:connect(function()m.
BackgroundTransparency=0.1 local n=m:GetChildren()for o=1,#n do n[o].
BackgroundTransparency=0.1 end end)m.MouseLeave:connect(function()m.
BackgroundTransparency=0.5 local n=m:GetChildren()for o=1,#n do n[o].
BackgroundTransparency=0.5 end end)local n=m:clone()n.Name='ScrollDownButton'n.
Position=UDim2.new(0,0,1,-18)local o=n:GetChildren()for p=1,#o do o[p].Position=
UDim2.new(0,3+(p-1),0.5,-2+(p-1))end n.MouseEnter:connect(function()n.
BackgroundTransparency=0.1 local p=n:GetChildren()for q=1,#p do p[q].
BackgroundTransparency=0.1 end end)n.MouseLeave:connect(function()n.
BackgroundTransparency=0.5 local p=n:GetChildren()for q=1,#p do p[q].
BackgroundTransparency=0.5 end end)n.Parent=j local p=Instance.new'Frame'p.Name=
'ScrollTrack'p.BackgroundTransparency=1 p.Size=UDim2.new(0,18,1,-38)p.Position=
UDim2.new(0,0,0,19)p.Parent=j local q=Instance.new'TextButton'q.BackgroundColor3
=Color3.new(0,0,0)q.BorderColor3=Color3.new(1,1,1)q.BackgroundTransparency=0.5 q
.AutoButtonColor=false q.Text=''q.Active=true q.Name='ScrollBar'q.ZIndex=2 q.
BackgroundTransparency=0.5 q.Size=UDim2.new(0,18,0.1,0)q.Position=UDim2.new(0,0,
0,0)q.Parent=p local r=Instance.new'Frame'r.Name='ScrollNub'r.BorderColor3=
Color3.new(1,1,1)r.Size=UDim2.new(0,10,0,0)r.Position=UDim2.new(0.5,-5,0.5,0)r.
ZIndex=2 r.BackgroundTransparency=0.5 r.Parent=q local s=r:clone()s.Position=
UDim2.new(0.5,-5,0.5,-2)s.Parent=q local t=r:clone()t.Position=UDim2.new(0.5,-5,
0.5,2)t.Parent=q q.MouseEnter:connect(function()q.BackgroundTransparency=0.1 r.
BackgroundTransparency=0.1 s.BackgroundTransparency=0.1 t.BackgroundTransparency
=0.1 end)q.MouseLeave:connect(function()q.BackgroundTransparency=0.5 r.
BackgroundTransparency=0.5 s.BackgroundTransparency=0.5 t.BackgroundTransparency
=0.5 end)local u=Instance.new'ImageButton'u.Active=false u.Size=UDim2.new(1.5,0,
1.5,0)u.AutoButtonColor=false u.BackgroundTransparency=1 u.Name='mouseDrag'u.
Position=UDim2.new(-0.25,0,-0.25,0)u.ZIndex=10 local function positionScrollBar(
v,w,x)local y=q.Position if w<p.AbsolutePosition.y then q.Position=UDim2.new(q.
Position.X.Scale,q.Position.X.Offset,0,0)return(y~=q.Position)end local z=q.
AbsoluteSize.Y/p.AbsoluteSize.Y if w>(p.AbsolutePosition.y+p.AbsoluteSize.y)then
q.Position=UDim2.new(q.Position.X.Scale,q.Position.X.Offset,1-z,0)return(y~=q.
Position)end local A=(w-p.AbsolutePosition.y-x)/p.AbsoluteSize.y if A+z>1 then A
=1-z k.Value=true l.Value=false elseif A<=0 then A=0 l.Value=true k.Value=false
else l.Value=false k.Value=false end q.Position=UDim2.new(q.Position.X.Scale,q.
Position.X.Offset,A,0)return(y~=q.Position)end local function
drillDownSetHighLow(v)if not v or not v:IsA'GuiObject'then return end if v==j
then return end if v:IsDescendantOf(j)then return end if not v.Visible then
return end if b and b>v.AbsolutePosition.Y then b=v.AbsolutePosition.Y elseif
not b then b=v.AbsolutePosition.Y end if c and c<(v.AbsolutePosition.Y+v.
AbsoluteSize.Y)then c=v.AbsolutePosition.Y+v.AbsoluteSize.Y elseif not c then c=
v.AbsolutePosition.Y+v.AbsoluteSize.Y end local w=v:GetChildren()for x=1,#w do
drillDownSetHighLow(w[x])end end local function resetHighLow()local v=i:
GetChildren()for w=1,#v do drillDownSetHighLow(v[w])end end local function
recalculate()g=true local v=0 if q.Position.Y.Scale>0 then if q.Visible then v=q
.Position.Y.Scale/((p.AbsoluteSize.Y-q.AbsoluteSize.Y)/p.AbsoluteSize.Y)else v=0
end end if v>0.99 then v=1 end local w,x=(i.AbsoluteSize.Y-(c-b))*v,i:
GetChildren()for y=1,#x do if x[y]~=j then x[y].Position=UDim2.new(x[y].Position
.X.Scale,x[y].Position.X.Offset,0,math.ceil(x[y].AbsolutePosition.Y)-math.ceil(b
)+w)end end b=nil c=nil resetHighLow()g=false end local function
setSliderSizeAndPosition()if not c or not b then return end local v=math.abs(c-b
)if v==0 then q.Visible=false n.Visible=false m.Visible=false if d then d:
disconnect()d=nil end if e then e:disconnect()e=nil end return end local w=i.
AbsoluteSize.Y/v if w>=1 then q.Visible=false n.Visible=false m.Visible=false
recalculate()else q.Visible=true n.Visible=true m.Visible=true q.Size=UDim2.new(
q.Size.X.Scale,q.Size.X.Offset,w,0)end local x=(i.AbsolutePosition.Y-b)/v q.
Position=UDim2.new(q.Position.X.Scale,q.Position.X.Offset,x,-q.AbsoluteSize.X/2)
if q.AbsolutePosition.y<p.AbsolutePosition.y then q.Position=UDim2.new(q.
Position.X.Scale,q.Position.X.Offset,0,0)end if(q.AbsolutePosition.y+q.
AbsoluteSize.Y)>(p.AbsolutePosition.y+p.AbsoluteSize.y)then local y=q.
AbsoluteSize.Y/p.AbsoluteSize.Y q.Position=UDim2.new(q.Position.X.Scale,q.
Position.X.Offset,1-y,0)end end local v,w=7,false local function doScrollUp()if
w then return end w=true if positionScrollBar(0,q.AbsolutePosition.Y-v,0)then
recalculate()end w=false end local x=false local function doScrollDown()if x
then return end x=true if positionScrollBar(0,q.AbsolutePosition.Y+v,0)then
recalculate()end x=false end local function scrollUp(y)if m.Active then
scrollStamp=tick()local z,A=scrollStamp,nil A=u.MouseButton1Up:connect(function(
)scrollStamp=tick()u.Parent=nil A:disconnect()end)u.Parent=getScreenGuiAncestor(
q)doScrollUp()wait(0.2)local B,C=tick(),0.1 while scrollStamp==z do doScrollUp()
if y and y>q.AbsolutePosition.y then break end if not m.Active then break end if
tick()-B>5 then C=0 elseif tick()-B>2 then C=0.06 end wait(C)end end end
local function scrollDown(y)if n.Active then scrollStamp=tick()local z,A=
scrollStamp,nil A=u.MouseButton1Up:connect(function()scrollStamp=tick()u.Parent=
nil A:disconnect()end)u.Parent=getScreenGuiAncestor(q)doScrollDown()wait(0.2)
local B,C=tick(),0.1 while scrollStamp==z do doScrollDown()if y and y<(q.
AbsolutePosition.y+q.AbsoluteSize.x)then break end if not n.Active then break
end if tick()-B>5 then C=0 elseif tick()-B>2 then C=0.06 end wait(C)end end end
q.MouseButton1Down:connect(function(y,z)if q.Active then scrollStamp=tick()local
A=z-q.AbsolutePosition.y if d then d:disconnect()d=nil end if e then e:
disconnect()e=nil end local B,C=z,false d=u.MouseMoved:connect(function(D,E)if C
then return end C=true if positionScrollBar(D,E,A)then recalculate()end C=false
end)e=u.MouseButton1Up:connect(function()scrollStamp=tick()u.Parent=nil d:
disconnect()d=nil e:disconnect()drag=nil end)u.Parent=getScreenGuiAncestor(q)end
end)local y=0 m.MouseButton1Down:connect(function()l()end)n.MouseButton1Down:
connect(function()scrollDown()end)local function scrollTick()scrollStamp=tick()
end m.MouseButton1Up:connect(scrollTick)n.MouseButton1Up:connect(scrollTick)q.
MouseButton1Up:connect(scrollTick)local function highLowRecheck()local z,A=b,c b
=nil c=nil resetHighLow()if(b~=z)or(c~=A)then setSliderSizeAndPosition()end end
local function descendantChanged(z,A)if g then return end if not z.Visible then
return end if A=='Size'or A=='Position'then wait()highLowRecheck()end end i.
DescendantAdded:connect(function(z)if not z:IsA'GuiObject'then return end if z.
Visible then wait()highLowRecheck()end h[z]=z.Changed:connect(function(A)
descendantChanged(z,A)end)end)i.DescendantRemoving:connect(function(z)if not z:
IsA'GuiObject'then return end if h[z]then h[z]:disconnect()h[z]=nil end wait()
highLowRecheck()end)i.Changed:connect(function(z)if z=='AbsoluteSize'then if not
c or not b then return end highLowRecheck()setSliderSizeAndPosition()end end)
return i,j end a.CreateScrollingFrame=function(b,c)local d=Instance.new'Frame'd.
Name='ScrollingFrame'd.BackgroundTransparency=1 d.Size=UDim2.new(1,0,1,0)local e
=Instance.new'ImageButton'e.Name='ScrollUpButton'e.BackgroundTransparency=1 e.
Image='rbxasset://textures/ui/scrollbuttonUp.png'e.Size=UDim2.new(0,17,0,17)
local g=Instance.new'ImageButton'g.Name='ScrollDownButton'g.
BackgroundTransparency=1 g.Image='rbxasset://textures/ui/scrollbuttonDown.png'g.
Size=UDim2.new(0,17,0,17)local h=Instance.new'ImageButton'h.Name='ScrollBar'h.
Image='rbxasset://textures/ui/scrollbar.png'h.BackgroundTransparency=1 h.Size=
UDim2.new(0,18,0,150)local i,j=0,Instance.new'ImageButton'j.Image=
'http://www.roblox.com/asset/?id=61367186'j.Size=UDim2.new(1,0,0,16)j.
BackgroundTransparency=1 j.Name='ScrollDrag'j.Active=true j.Parent=h local k=
Instance.new'ImageButton'k.Active=false k.Size=UDim2.new(1.5,0,1.5,0)k.
AutoButtonColor=false k.BackgroundTransparency=1 k.Name='mouseDrag'k.Position=
UDim2.new(-0.25,0,-0.25,0)k.ZIndex=10 local l='simple'if c and tostring(c)then l
=c end local m,n,o=1,0,0 local p,q,r,s=function()o=0 local p={}if b then for q,r
in ipairs(b)do if r.Parent==d then table.insert(p,r)end end else local q=d:
GetChildren()if q then for r,s in ipairs(q)do if s:IsA'GuiObject'then table.
insert(p,s)end end end end if#p==0 then e.Active=false g.Active=false j.Active=
false m=1 return end if m>#p then m=#p end if m<1 then m=1 end local q,r,s,t,u,v
,w,x,y=d.AbsoluteSize.Y,d.AbsoluteSize.Y,d.AbsoluteSize.X,0,0,true,0,#p,0 x=m
while x<=#p and w<q do t=t+p[x].AbsoluteSize.X if t>=s then w=w+y y=0 t=p[x].
AbsoluteSize.X end if p[x].AbsoluteSize.Y>y then y=p[x].AbsoluteSize.Y end x=x+1
end w=w+y y=0 x=m-1 t=0 while w+y<q and x>=1 do t=t+p[x].AbsoluteSize.X u=u+1 if
t>=s then n=u-1 u=0 t=p[x].AbsoluteSize.X if w+y<=q then w=w+y if m<=n then m=1
break else m=m-n end y=0 else break end end if p[x].AbsoluteSize.Y>y then y=p[x]
.AbsoluteSize.Y end x=x-1 end if(x==0)and(w+y<=q)then m=1 end t=0 u=0 v=true
local z,A,B=0,0 if p[1]then B=math.ceil(math.floor(math.fmod(q,p[1].AbsoluteSize
.X))/2)A=math.ceil(math.floor(math.fmod(s,p[1].AbsoluteSize.Y))/2)end for C,D in
ipairs(p)do if C<m then D.Visible=false else if r<0 then D.Visible=false else if
v then u=u+1 end if t+D.AbsoluteSize.X>=s then if v then n=u-1 v=false end t=0 r
=r-D.AbsoluteSize.Y end D.Position=UDim2.new(D.Position.X.Scale,t+A,0,q-r+B)t=t+
D.AbsoluteSize.X D.Visible=((r-D.AbsoluteSize.Y)>=0)if D.Visible then o=o+1 end
z=D.AbsoluteSize end end end e.Active=(m>1)if z==0 then g.Active=false else g.
Active=((r-z.Y)<0)end j.Active=#p>o j.Visible=j.Active end,function()local p={}o
=0 if b then for q,r in ipairs(b)do if r.Parent==d then table.insert(p,r)end end
else local q=d:GetChildren()if q then for r,s in ipairs(q)do if s:IsA'GuiObject'
then table.insert(p,s)end end end end if#p==0 then e.Active=false g.Active=false
j.Active=false m=1 return end if m>#p then m=#p end local q,r,s,t=d.AbsoluteSize
.Y,d.AbsoluteSize.Y,0,#p while s<q and t>=1 do if t>=m then s=s+p[t].
AbsoluteSize.Y else if s+p[t].AbsoluteSize.Y<=q then s=s+p[t].AbsoluteSize.Y if
m<=1 then m=1 break else m=m-1 end else break end end t=t-1 end t=m for u,v in
ipairs(p)do if u<m then v.Visible=false else if r<0 then v.Visible=false else v.
Position=UDim2.new(v.Position.X.Scale,v.Position.X.Offset,0,q-r)r=r-v.
AbsoluteSize.Y if r>=0 then v.Visible=true o=o+1 else v.Visible=false end end
end end e.Active=(m>1)g.Active=(r<0)j.Active=#p>o j.Visible=j.Active end,
function()local p,q=0,d:GetChildren()if q then for r,s in ipairs(q)do if s:IsA
'GuiObject'then p=p+1 end end end if not j.Parent then return end local r=j.
Parent.AbsoluteSize.y*(1/(p-o+1))if r<16 then r=16 end j.Size=UDim2.new(j.Size.X
.Scale,j.Size.X.Offset,j.Size.Y.Scale,r)local s=(m-1)/(p-o)if s>1 then s=1
elseif s<0 then s=0 end local t=0 if s~=0 then t=(s*h.AbsoluteSize.y)-(s*j.
AbsoluteSize.y)end j.Position=UDim2.new(j.Position.X.Scale,j.Position.X.Offset,j
.Position.Y.Scale,t)end,false local t=function()if s then return end s=true
wait()local t,u=nil if l=='grid'then t,u=pcall(function()p()end)elseif l==
'simple'then t,u=pcall(function()q()end)end if not t then print(u)end r()s=false
end local u,v=function()m=m-n if m<1 then m=1 end t(nil)end,function()m=m+n t(
nil)end local w,x,y=function(w)if e.Active then i=tick()local x,y=i,nil y=k.
MouseButton1Up:connect(function()i=tick()k.Parent=nil y:disconnect()end)k.Parent
=getScreenGuiAncestor(h)u()wait(0.2)local z,A=tick(),0.1 while i==x do u()if w
and w>j.AbsolutePosition.y then break end if not e.Active then break end if
tick()-z>5 then A=0 elseif tick()-z>2 then A=0.06 end wait(A)end end end,
function(w)if g.Active then i=tick()local x,y=i,nil y=k.MouseButton1Up:connect(
function()i=tick()k.Parent=nil y:disconnect()end)k.Parent=getScreenGuiAncestor(h
)v()wait(0.2)local z,A=tick(),0.1 while i==x do v()if w and w<(j.
AbsolutePosition.y+j.AbsoluteSize.x)then break end if not g.Active then break
end if tick()-z>5 then A=0 elseif tick()-z>2 then A=0.06 end wait(A)end end end,
0 j.MouseButton1Down:connect(function(z,A)if j.Active then i=tick()local B,C,D=A
-j.AbsolutePosition.y,nil,nil C=k.MouseMoved:connect(function(E,F)local G,H,I=h.
AbsolutePosition.y,h.AbsoluteSize.y,j.AbsoluteSize.y local J=G+H-I F=F-B F=F<G
and G or F>J and J or F F=F-G local K,L=0,d:GetChildren()if L then for M,N in
ipairs(L)do if N:IsA'GuiObject'then K=K+1 end end end local M,N,O=F/(H-I),n,K-(o
-1)local P=math.floor((M*O)+0.5)+N if P<m then N=-N end if P<1 then P=1 end m=P
t(nil)end)D=k.MouseButton1Up:connect(function()i=tick()k.Parent=nil C:
disconnect()C=nil D:disconnect()drag=nil end)k.Parent=getScreenGuiAncestor(h)end
end)local z=0 e.MouseButton1Down:connect(function()w()end)e.MouseButton1Up:
connect(function()i=tick()end)g.MouseButton1Up:connect(function()i=tick()end)g.
MouseButton1Down:connect(function()x()end)h.MouseButton1Up:connect(function()i=
tick()end)h.MouseButton1Down:connect(function(A,B)if B>(j.AbsoluteSize.y+j.
AbsolutePosition.y)then x(B)elseif B<j.AbsolutePosition.y then w(B)end end)d.
ChildAdded:connect(function()t(nil)end)d.ChildRemoved:connect(function()t(nil)
end)d.Changed:connect(function(A)if A=='AbsoluteSize'then t(nil)end end)d.
AncestryChanged:connect(function()t(nil)end)return d,e,g,t,h end local function
binaryGrow(b,c,d)if b>c then return b end local e=b while b<=c do local g=b+math
.floor((c-b)/2)if d(g)and(e==nil or e<g)then e=g b=g+1 else c=g-1 end end return
e end local function binaryShrink(b,c,d)if b>c then return b end local e=c while
b<=c do local g=b+math.floor((c-b)/2)if d(g)and(e==nil or e>g)then e=g c=g-1
else b=g+1 end end return e end local function getGuiOwner(b)while b~=nil do if
b:IsA'ScreenGui'or b:IsA'BillboardGui'then return b end b=b.Parent end return
nil end a.AutoTruncateTextObject=function(b)local c,d=b.Text,b:Clone()d.Name=
'Full'..b.Name d.BorderSizePixel=0 d.BackgroundTransparency=0 d.Text=c d.
TextXAlignment=Enum.TextXAlignment.Center d.Position=UDim2.new(0,-3,0,0)d.Size=
UDim2.new(0,100,1,0)d.Visible=false d.Parent=b local e,g,h=nil,nil,nil local i=
function()if getGuiOwner(b)==nil then return end b.Text=c if b.TextFits then if
g then g:disconnect()g=nil end if h then h:disconnect()h=nil end else local i=
string.len(c)b.Text=c..'~'local j=binaryGrow(0,i,function(j)if j==0 then b.Text=
'~'else b.Text=string.sub(c,1,j)..'~'end return b.TextFits end)e=string.sub(c,1,
j)..'~'b.Text=e if not d.TextFits then d.Size=UDim2.new(0,10000,1,0)end local k=
binaryShrink(b.AbsoluteSize.X,d.AbsoluteSize.X,function(k)d.Size=UDim2.new(0,k,1
,0)return d.TextFits end)d.Size=UDim2.new(0,k+6,1,0)if g==nil then g=b.
MouseEnter:connect(function()d.ZIndex=b.ZIndex+1 d.Visible=true end)end if h==
nil then h=b.MouseLeave:connect(function()d.Visible=false end)end end end b.
AncestryChanged:connect(i)b.Changed:connect(function(j)if j=='AbsoluteSize'then
i()end end)i()local function changeText(j)c=j d.Text=c i()end return b,
changeText end local function TransitionTutorialPages(b,c,d,e)if b then b.
Visible=false if d.Visible==false then d.Size=b.Size d.Position=b.Position end
else if d.Visible==false then d.Size=UDim2.new(0,50,0,50)d.Position=UDim2.new(
0.5,-25,0.5,-25)end end d.Visible=true e.Value=nil local g,h if c then c.Visible
=true g=c.Size h=c.Position c.Visible=false else g=UDim2.new(0,50,0,50)h=UDim2.
new(0.5,-25,0.5,-25)end d:TweenSizeAndPosition(g,h,Enum.EasingDirection.InOut,
Enum.EasingStyle.Quad,0.3,true,function(i)if i==Enum.TweenStatus.Completed then
d.Visible=false if c then c.Visible=true e.Value=c end end end)end a.
CreateTutorial=function(b,c,d)local e=Instance.new'Frame'e.Name='Tutorial-'..b e
.BackgroundTransparency=1 e.Size=UDim2.new(0.6,0,0.6,0)e.Position=UDim2.new(0.2,
0,0.2,0)local g=Instance.new'Frame'g.Name='TransitionFrame'g.Style=Enum.
FrameStyle.RobloxRound g.Size=UDim2.new(0.6,0,0.6,0)g.Position=UDim2.new(0.2,0,
0.2,0)g.Visible=false g.Parent=e local h=Instance.new'ObjectValue'h.Name=
'CurrentTutorialPage'h.Value=nil h.Parent=e local i=Instance.new'BoolValue'i.
Name='Buttons'i.Value=d i.Parent=e local j=Instance.new'Frame'j.Name='Pages'j.
BackgroundTransparency=1 j.Size=UDim2.new(1,0,1,0)j.Parent=e local function
getVisiblePageAndHideOthers()local k,l=nil,j:GetChildren()if l then for m,n in
ipairs(l)do if n.Visible then if k then n.Visible=false else k=n end end end end
return k end local k,l,m=function(k)if k or UserSettings().GameSettings:
GetTutorialState(c)==false then print('Showing tutorial-',c)local l,m=
getVisiblePageAndHideOthers(),j:FindFirstChild'TutorialPage1'if m then
TransitionTutorialPages(l,m,g,h)else error'Could not find TutorialPage1'end end
end,function()local k=getVisiblePageAndHideOthers()if k then
TransitionTutorialPages(k,nil,g,h)end UserSettings().GameSettings:
SetTutorialState(c,true)end,function(k)local l,m=j:FindFirstChild('TutorialPage'
..k),getVisiblePageAndHideOthers()TransitionTutorialPages(m,l,g,h)end return e,k
,l,m end local function CreateBasicTutorialPage(b,c,d,e)local g=Instance.new
'Frame'g.Name='TutorialPage'g.Style=Enum.FrameStyle.RobloxRound g.Size=UDim2.
new(0.6,0,0.6,0)g.Position=UDim2.new(0.2,0,0.2,0)g.Visible=false local h=
Instance.new'TextLabel'h.Name='Header'h.Text=b h.BackgroundTransparency=1 h.
FontSize=Enum.FontSize.Size24 h.Font=Enum.Font.ArialBold h.TextColor3=Color3.
new(1,1,1)h.TextXAlignment=Enum.TextXAlignment.Center h.TextWrap=true h.Size=
UDim2.new(1,-55,0,22)h.Position=UDim2.new(0,0,0,0)h.Parent=g local i=Instance.
new'ImageButton'i.Name='SkipButton'i.AutoButtonColor=false i.
BackgroundTransparency=1 i.Image='rbxasset://textures/ui/closeButton.png'i.
MouseButton1Click:connect(function()d()end)i.MouseEnter:connect(function()i.
Image='rbxasset://textures/ui/closeButton_dn.png'end)i.MouseLeave:connect(
function()i.Image='rbxasset://textures/ui/closeButton.png'end)i.Size=UDim2.new(0
,25,0,25)i.Position=UDim2.new(1,-25,0,0)i.Parent=g if e then local j=Instance.
new'TextButton'j.Name='DoneButton'j.Style=Enum.ButtonStyle.RobloxButtonDefault j
.Text='Done'j.TextColor3=Color3.new(1,1,1)j.Font=Enum.Font.ArialBold j.FontSize=
Enum.FontSize.Size18 j.Size=UDim2.new(0,100,0,50)j.Position=UDim2.new(0.5,-50,1,
-50)if d then j.MouseButton1Click:connect(function()d()end)end j.Parent=g end
local j=Instance.new'Frame'j.Name='ContentFrame'j.BackgroundTransparency=1 j.
Position=UDim2.new(0,0,0,25)j.Parent=g local k=Instance.new'TextButton'k.Name=
'NextButton'k.Text='Next'k.TextColor3=Color3.new(1,1,1)k.Font=Enum.Font.Arial k.
FontSize=Enum.FontSize.Size18 k.Style=Enum.ButtonStyle.RobloxButtonDefault k.
Size=UDim2.new(0,80,0,32)k.Position=UDim2.new(0.5,5,1,-32)k.Active=false k.
Visible=false k.Parent=g local l=Instance.new'TextButton'l.Name='PrevButton'l.
Text='Previous'l.TextColor3=Color3.new(1,1,1)l.Font=Enum.Font.Arial l.FontSize=
Enum.FontSize.Size18 l.Style=Enum.ButtonStyle.RobloxButton l.Size=UDim2.new(0,80
,0,32)l.Position=UDim2.new(0.5,-85,1,-32)l.Active=false l.Visible=false l.Parent
=g if e then j.Size=UDim2.new(1,0,1,-75)else j.Size=UDim2.new(1,0,1,-22)end
local m=nil local function basicHandleResize()if g.Visible and g.Parent then
local n=math.min(g.Parent.AbsoluteSize.X,g.Parent.AbsoluteSize.Y)c(200,n)end end
g.Changed:connect(function(n)if n=='Parent'then if m~=nil then m:disconnect()m=
nil end if g.Parent and g.Parent:IsA'GuiObject'then m=g.Parent.Changed:connect(
function(o)if o=='AbsoluteSize'then wait()basicHandleResize()end end)
basicHandleResize()end end if n=='Visible'then basicHandleResize()end end)return
g,j end a.CreateTextTutorialPage=function(b,c,d)local e,g,h=nil,nil,Instance.new
'TextLabel'h.BackgroundTransparency=1 h.TextColor3=Color3.new(1,1,1)h.Text=c h.
TextWrap=true h.TextXAlignment=Enum.TextXAlignment.Left h.TextYAlignment=Enum.
TextYAlignment.Center h.Font=Enum.Font.Arial h.FontSize=Enum.FontSize.Size14 h.
Size=UDim2.new(1,0,1,0)local function handleResize(i,j)size=binaryShrink(i,j,
function(k)e.Size=UDim2.new(0,k,0,k)return h.TextFits end)e.Size=UDim2.new(0,
size,0,size)e.Position=UDim2.new(0.5,-size/2,0.5,-size/2)end e,g=
CreateBasicTutorialPage(b,handleResize,d)h.Parent=g return e end a.
CreateImageTutorialPage=function(b,c,d,e,g,h)local i,j,k=nil,nil,Instance.new
'ImageLabel'k.BackgroundTransparency=1 k.Image=c k.Size=UDim2.new(0,d,0,e)k.
Position=UDim2.new(0.5,-d/2,0.5,-e/2)local function handleResize(l,m)size=
binaryShrink(l,m,function(n)return n>=d and n>=e end)if size>=d and size>=e then
k.Size=UDim2.new(0,d,0,e)k.Position=UDim2.new(0.5,-d/2,0.5,-e/2)else if d>e then
k.Size=UDim2.new(1,0,e/d,0)k.Position=UDim2.new(0,0,0.5-(e/d)/2,0)else k.Size=
UDim2.new(d/e,0,1,0)k.Position=UDim2.new(0.5-(d/e)/2,0,0,0)end end size=size+50
i.Size=UDim2.new(0,size,0,size)i.Position=UDim2.new(0.5,-size/2,0.5,-size/2)end
i,j=CreateBasicTutorialPage(b,handleResize,g,h)k.Parent=j return i end a.
AddTutorialPage=function(b,c)local d,e=b.TransitionFrame,b.CurrentTutorialPage
if not b.Buttons.Value then c.NextButton.Parent=nil c.PrevButton.Parent=nil end
local g=b.Pages:GetChildren()if g and#g>0 then c.Name='TutorialPage'..(#g+1)
local h=g[#g]if not h:IsA'GuiObject'then error
'All elements under Pages must be GuiObjects'end if b.Buttons.Value then if h.
NextButton.Active then error
[[NextButton already Active on previousPage, please only add pages with RbxGui.AddTutorialPage function]]
end h.NextButton.MouseButton1Click:connect(function()TransitionTutorialPages(h,c
,d,e)end)h.NextButton.Active=true h.NextButton.Visible=true if c.PrevButton.
Active then error
[[PrevButton already Active on tutorialPage, please only add pages with RbxGui.AddTutorialPage function]]
end c.PrevButton.MouseButton1Click:connect(function()TransitionTutorialPages(c,h
,d,e)end)c.PrevButton.Active=true c.PrevButton.Visible=true end c.Parent=b.Pages
else c.Name='TutorialPage1'c.Parent=b.Pages end end a.CreateSetPanel=function(b,
c,d,e,g,h,i)if not b then error
[[CreateSetPanel: userIdsForSets (first arg) is nil, should be a table of number ids]]
end if type(b)~='table'and type(b)~='userdata'then error(
'CreateSetPanel: userIdsForSets (first arg) is of type '..type(b)..
', should be of type table or userdata')end if not c then error
[[CreateSetPanel: objectSelected (second arg) is nil, should be a callback function!]]
end if type(c)~='function'then error(
'CreateSetPanel: objectSelected (second arg) is of type '..type(c)..
', should be of type function!')end if d and type(d)~='function'then error(
'CreateSetPanel: dialogClosed (third arg) is of type '..type(d)..
', should be of type function!')end if h==nil then h=false end local j,k,l,m,n,o
,p,q,r=1,{},{},nil,nil,'NegX','None',nil local s={}s.CurrentCategory=nil s.
Category={}local t,u,v={},nil,64 local w,x,y,z=v,nil,nil,game:GetService
'ContentProvider'.BaseUrl:lower()if i then y=z..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&assetversionid=]]x=z..
[[Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&assetversionid=]]else y=z..
'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&aid='x=z..
'Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&aid='end local function
drillDownSetZIndex(A,B)local C=A:GetChildren()for D=1,#C do if C[D]:IsA
'GuiObject'then C[D].ZIndex=B end drillDownSetZIndex(C[D],B)end end local A,B,C=
nil,{'Block','Vertical Ramp','Corner Wedge','Inverse Corner Wedge',
'Horizontal Ramp','Auto-Wedge'},{}for D=1,#B do C[B[D]]=D-1 end C[B[#B]]=6
local function createWaterGui()local D,E,F={'NegX','X','NegY','Y','NegZ','Z'},{
'None','Small','Medium','Strong','Max'},Instance.new'Frame'F.Name='WaterFrame'F.
Style=Enum.FrameStyle.RobloxSquare F.Size=UDim2.new(0,150,0,110)F.Visible=false
local G=Instance.new'TextLabel'G.Name='WaterForceLabel'G.BackgroundTransparency=
1 G.Size=UDim2.new(1,0,0,12)G.Font=Enum.Font.ArialBold G.FontSize=Enum.FontSize.
Size12 G.TextColor3=Color3.new(1,1,1)G.TextXAlignment=Enum.TextXAlignment.Left G
.Text='Water Force'G.Parent=F local H=G:Clone()H.Name='WaterForceDirectionLabel'
H.Text='Water Force Direction'H.Position=UDim2.new(0,0,0,50)H.Parent=F local I=
Instance.new'BindableEvent'I.Name='WaterTypeChangedEvent'I.Parent=F local J,K=
function(J)o=J I:Fire{p,o}end,function(J)p=J I:Fire{p,o}end local L,M=a.
CreateDropDownMenu(D,J)L.Size=UDim2.new(1,0,0,25)L.Position=UDim2.new(0,0,1,3)M
'NegX'L.Parent=H local N,O=a.CreateDropDownMenu(E,K)O'None'N.Size=UDim2.new(1,0,
0,25)N.Position=UDim2.new(0,0,1,3)N.Parent=G return F,I end local function
createSetGui()local D=Instance.new'ScreenGui'D.Name='SetGui'local E=Instance.new
'Frame'E.Name='SetPanel'E.Active=true E.BackgroundTransparency=1 if g then E.
Position=g else E.Position=UDim2.new(0.2,29,0.1,24)end if e then E.Size=e else E
.Size=UDim2.new(0.6,-58,0.64,0)end E.Style=Enum.FrameStyle.RobloxRound E.ZIndex=
6 E.Parent=D local F=Instance.new'Frame'F.Name='ItemPreview'F.
BackgroundTransparency=1 F.Position=UDim2.new(0.8,5,0.085,0)F.Size=UDim2.new(
0.21,0,0.9,0)F.ZIndex=6 F.Parent=E local G=Instance.new'Frame'G.Name='TextPanel'
G.BackgroundTransparency=1 G.Position=UDim2.new(0,0,0.45,0)G.Size=UDim2.new(1,0,
0.55,0)G.ZIndex=6 G.Parent=F local H=Instance.new'TextLabel'H.Name=
'RolloverText'H.BackgroundTransparency=1 H.Size=UDim2.new(1,0,0,48)H.ZIndex=6 H.
Font=Enum.Font.ArialBold H.FontSize=Enum.FontSize.Size24 H.Text=''H.TextColor3=
Color3.new(1,1,1)H.TextWrap=true H.TextXAlignment=Enum.TextXAlignment.Left H.
TextYAlignment=Enum.TextYAlignment.Top H.Parent=G local I=Instance.new
'ImageLabel'I.Name='LargePreview'I.BackgroundTransparency=1 I.Image=''I.Size=
UDim2.new(1,0,0,170)I.ZIndex=6 I.Parent=F local J=Instance.new'Frame'J.Name=
'Sets'J.BackgroundTransparency=1 J.Position=UDim2.new(0,0,0,5)J.Size=UDim2.new(
0.23,0,1,-5)J.ZIndex=6 J.Parent=E local K=Instance.new'Frame'K.Name='Line'K.
BackgroundColor3=Color3.new(1,1,1)K.BackgroundTransparency=0.7 K.BorderSizePixel
=0 K.Position=UDim2.new(1,-3,0.06,0)K.Size=UDim2.new(0,3,0.9,0)K.ZIndex=6 K.
Parent=J local L,M=a.CreateTrueScrollingFrame()L.Size=UDim2.new(1,-6,0.94,0)L.
Position=UDim2.new(0,0,0.06,0)L.BackgroundTransparency=1 L.Name='SetsLists'L.
ZIndex=6 L.Parent=J drillDownSetZIndex(M,7)local N=Instance.new'TextLabel'N.Name
='SetsHeader'N.BackgroundTransparency=1 N.Size=UDim2.new(0,47,0,24)N.ZIndex=6 N.
Font=Enum.Font.ArialBold N.FontSize=Enum.FontSize.Size24 N.Text='Sets'N.
TextColor3=Color3.new(1,1,1)N.TextXAlignment=Enum.TextXAlignment.Left N.
TextYAlignment=Enum.TextYAlignment.Top N.Parent=J local O=Instance.new
'TextButton'O.Name='CancelButton'O.Position=UDim2.new(1,-32,0,-2)O.Size=UDim2.
new(0,34,0,34)O.Style=Enum.ButtonStyle.RobloxButtonDefault O.ZIndex=6 O.Text=''O
.Modal=true O.Parent=E local P=Instance.new'ImageLabel'P.Name='CancelImage'P.
BackgroundTransparency=1 P.Image='http://www.roblox.com/asset?id=54135717'P.
Position=UDim2.new(0,-2,0,-2)P.Size=UDim2.new(0,16,0,16)P.ZIndex=6 P.Parent=O
return D end local function createSetButton(D)local E=Instance.new'TextButton'if
D then E.Text=D else E.Text=''end E.AutoButtonColor=false E.
BackgroundTransparency=1 E.BackgroundColor3=Color3.new(1,1,1)E.BorderSizePixel=0
E.Size=UDim2.new(1,-5,0,18)E.ZIndex=6 E.Visible=false E.Font=Enum.Font.Arial E.
FontSize=Enum.FontSize.Size18 E.TextColor3=Color3.new(1,1,1)E.TextXAlignment=
Enum.TextXAlignment.Left return E end local function buildSetButton(D,E,F,G,H)
local I=createSetButton(D)I.Text=D I.Name='SetButton'I.Visible=true local J=
Instance.new'IntValue'J.Name='SetId'J.Value=E J.Parent=I local K=Instance.new
'StringValue'K.Name='SetName'K.Value=D K.Parent=I return I end local function
processCategory(D)local E,H={},0 for I=1,#D do if not h and D[I].Name=='Beta'
then H=H+1 else E[I-H]=buildSetButton(D[I].Name,D[I].CategoryId,D[I].
ImageAssetId,I-H,#D)end end return E end local function handleResize()wait()
local D=n.SetPanel.ItemPreview D.LargePreview.Size=UDim2.new(1,0,0,D.
AbsoluteSize.X)D.LargePreview.Position=UDim2.new(0.5,-D.LargePreview.
AbsoluteSize.X/2,0,0)D.TextPanel.Position=UDim2.new(0,0,0,D.LargePreview.
AbsoluteSize.Y)D.TextPanel.Size=UDim2.new(1,0,0,D.AbsoluteSize.Y-D.LargePreview.
AbsoluteSize.Y)end local function makeInsertAssetButton()local D=Instance.new
'Frame'D.Name='InsertAssetButtonExample'D.Position=UDim2.new(0,128,0,64)D.Size=
UDim2.new(0,64,0,64)D.BackgroundTransparency=1 D.ZIndex=6 D.Visible=false local
E=Instance.new'IntValue'E.Name='AssetId'E.Value=0 E.Parent=D local H=Instance.
new'StringValue'H.Name='AssetName'H.Value=''H.Parent=D local I=Instance.new
'TextButton'I.Name='Button'I.Text=''I.Style=Enum.ButtonStyle.RobloxButton I.
Position=UDim2.new(0.025,0,0.025,0)I.Size=UDim2.new(0.95,0,0.95,0)I.ZIndex=6 I.
Parent=D local J=Instance.new'ImageLabel'J.Name='ButtonImage'J.Image=''J.
Position=UDim2.new(0,-7,0,-7)J.Size=UDim2.new(1,14,1,14)J.BackgroundTransparency
=1 J.ZIndex=7 J.Parent=I local K=J:clone()K.Name='ConfigIcon'K.Visible=false K.
Position=UDim2.new(1,-23,1,-24)K.Size=UDim2.new(0,16,0,16)K.Image=''K.ZIndex=6 K
.Parent=D return D end local function showLargePreview(D)if D:FindFirstChild
'AssetId'then delay(0,function()game:GetService'ContentProvider':Preload(y..
tostring(D.AssetId.Value))n.SetPanel.ItemPreview.LargePreview.Image=y..tostring(
D.AssetId.Value)end)end if D:FindFirstChild'AssetName'then n.SetPanel.
ItemPreview.TextPanel.RolloverText.Text=D.AssetName.Value end end local function
selectTerrainShape(D)if A then c(tostring(A.AssetName.Value),tonumber(A.AssetId.
Value),D)end end local function createTerrainTypeButton(D,E)local H=Instance.new
'TextButton'H.Name=D..'Button'H.Font=Enum.Font.ArialBold H.FontSize=Enum.
FontSize.Size14 H.BorderSizePixel=0 H.TextColor3=Color3.new(1,1,1)H.Text=D H.
TextXAlignment=Enum.TextXAlignment.Left H.BackgroundTransparency=1 H.ZIndex=E.
ZIndex+1 H.Size=UDim2.new(0,E.Size.X.Offset-2,0,16)H.Position=UDim2.new(0,1,0,0)
H.MouseEnter:connect(function()H.BackgroundTransparency=0 H.TextColor3=Color3.
new(0,0,0)end)H.MouseLeave:connect(function()H.BackgroundTransparency=1 H.
TextColor3=Color3.new(1,1,1)end)H.MouseButton1Click:connect(function()H.
BackgroundTransparency=1 H.TextColor3=Color3.new(1,1,1)if H.Parent and H.Parent:
IsA'GuiObject'then H.Parent.Visible=false end selectTerrainShape(C[H.Text])end)
return H end local function createTerrainDropDownMenu(D)local E=Instance.new
'Frame'E.Name='TerrainDropDown'E.BackgroundColor3=Color3.new(0,0,0)E.
BorderColor3=Color3.new(1,0,0)E.Size=UDim2.new(0,200,0,0)E.Visible=false E.
ZIndex=D E.Parent=n for H=1,#B do local I=createTerrainTypeButton(B[H],E)I.
Position=UDim2.new(0,1,0,(H-1)*I.Size.Y.Offset)I.Parent=E E.Size=UDim2.new(0,200
,0,E.Size.Y.Offset+I.Size.Y.Offset)end E.MouseLeave:connect(function()E.Visible=
false end)end local function createDropDownMenuButton(D)local E=Instance.new
'ImageButton'E.Name='DropDownButton'E.Image=
'http://www.roblox.com/asset/?id=67581509'E.BackgroundTransparency=1 E.Size=
UDim2.new(0,16,0,16)E.Position=UDim2.new(1,-24,0,6)E.ZIndex=D.ZIndex+2 E.Parent=
D if not n:FindFirstChild'TerrainDropDown'then createTerrainDropDownMenu(8)end E
.MouseButton1Click:connect(function()n.TerrainDropDown.Visible=true n.
TerrainDropDown.Position=UDim2.new(0,D.AbsolutePosition.X,0,D.AbsolutePosition.Y
)A=D end)end local function buildInsertButton()local D=makeInsertAssetButton()D.
Name='InsertAssetButton'D.Visible=true if s.Category[s.CurrentCategory].SetName
=='High Scalability'then createDropDownMenuButton(D)end local E=nil local H=D.
MouseEnter:connect(function()E=D delay(0.1,function()if E==D then
showLargePreview(D)end end)end)return D,H end local function realignButtonGrid(D
)local E,H=0,0 for I=1,#k do k[I].Position=UDim2.new(0,v*E,0,w*H)E=E+1 if E>=D
then E=0 H=H+1 end end end local function setInsertButtonImageBehavior(D,E,H,I)
if E then D.AssetName.Value=H D.AssetId.Value=I local J=x..I if J~=D.Button.
ButtonImage.Image then delay(0,function()game:GetService'ContentProvider':
Preload(x..I)D.Button.ButtonImage.Image=x..I end)end table.insert(l,D.Button.
MouseButton1Click:connect(function()local K=(H=='Water')and(s.Category[s.
CurrentCategory].SetName=='High Scalability')q.Visible=K if K then c(H,tonumber(
I),nil)else c(H,tonumber(I))end end))D.Visible=true else D.Visible=false end end
local function loadSectionOfItems(D,E,H)local I=E*H if j>#m then return end
local J,K=j,0 for L=1,I+1 do if j>=#m+1 then break end local M k[j],M=
buildInsertButton()table.insert(l,M)k[j].Parent=D.SetPanel.ItemsFrame j=j+1 end
realignButtonGrid(H)local L=J for M=J,j do if k[M]then if m[M]then if m[M].Name
=='Water'then if s.Category[s.CurrentCategory].SetName=='High Scalability'then k
[M]:FindFirstChild('DropDownButton',true):Destroy()end end local N if i then N=m
[M].AssetVersionId else N=m[M].AssetId end setInsertButtonImageBehavior(k[M],
true,m[M].Name,N)else break end else break end L=M end end local function
setSetIndex()s.Category[s.CurrentCategory].Index=0 rows=7 columns=math.floor(n.
SetPanel.ItemsFrame.AbsoluteSize.X/v)m=s.Category[s.CurrentCategory].Contents if
m then for D=1,#k do k[D]:remove()end for D=1,#l do if l[D]then l[D]:disconnect(
)end end l={}k={}j=1 loadSectionOfItems(n,rows,columns)end end local function
selectSet(D,E,H,I)if D and s.Category[s.CurrentCategory]~=nil then if D~=s.
Category[s.CurrentCategory].Button then s.Category[s.CurrentCategory].Button=D
if t[H]==nil then t[H]=game:GetService'InsertService':GetCollection(H)end s.
Category[s.CurrentCategory].Contents=t[H]s.Category[s.CurrentCategory].SetName=E
s.Category[s.CurrentCategory].SetId=H end setSetIndex()end end local function
selectCategoryPage(D,E)if D~=s.CurrentCategory then if s.CurrentCategory then
for H,I in pairs(s.CurrentCategory)do I.Visible=false end end s.CurrentCategory=
D if s.Category[s.CurrentCategory]==nil then s.Category[s.CurrentCategory]={}if#
D>0 then selectSet(D[1],D[1].SetName.Value,D[1].SetId.Value,0)end else s.
Category[s.CurrentCategory].Button=nil selectSet(s.Category[s.CurrentCategory].
ButtonFrame,s.Category[s.CurrentCategory].SetName,s.Category[s.CurrentCategory].
SetId,s.Category[s.CurrentCategory].Index)end end end local function
selectCategory(D)selectCategoryPage(D,0)end local function
resetAllSetButtonSelection()local D=n.SetPanel.Sets.SetsLists:GetChildren()for E
=1,#D do if D[E]:IsA'TextButton'then D[E].Selected=false D[E].
BackgroundTransparency=1 D[E].TextColor3=Color3.new(1,1,1)D[E].BackgroundColor3=
Color3.new(1,1,1)end end end local function populateSetsFrame()local D=0 for E=1
,#u do local H=u[E]H.Visible=true H.Position=UDim2.new(0,5,0,D*H.Size.Y.Offset)H
.Parent=n.SetPanel.Sets.SetsLists if E==1 then H.Selected=true H.
BackgroundColor3=Color3.new(0,0.8,0)H.TextColor3=Color3.new(0,0,0)H.
BackgroundTransparency=0 end H.MouseEnter:connect(function()if not H.Selected
then H.BackgroundTransparency=0 H.TextColor3=Color3.new(0,0,0)end end)H.
MouseLeave:connect(function()if not H.Selected then H.BackgroundTransparency=1 H
.TextColor3=Color3.new(1,1,1)end end)H.MouseButton1Click:connect(function()
resetAllSetButtonSelection()H.Selected=not H.Selected H.BackgroundColor3=Color3.
new(0,0.8,0)H.TextColor3=Color3.new(0,0,0)H.BackgroundTransparency=0 selectSet(H
,H.Text,u[E].SetId.Value,0)end)D=D+1 end local E=n.SetPanel.Sets.SetsLists:
GetChildren()if E then for H=1,#E do if E[H]:IsA'TextButton'then selectSet(E[H],
E[H].Text,u[H].SetId.Value,0)selectCategory(u)break end end end end n=
createSetGui()q,r=createWaterGui()q.Position=UDim2.new(0,55,0,0)q.Parent=n n.
Changed:connect(function(D)if D=='AbsoluteSize'then handleResize()setSetIndex()
end end)local D,E=a.CreateTrueScrollingFrame()D.Size=UDim2.new(0.54,0,0.85,0)D.
Position=UDim2.new(0.24,0,0.085,0)D.Name='ItemsFrame'D.ZIndex=6 D.Parent=n.
SetPanel D.BackgroundTransparency=1 drillDownSetZIndex(E,7)E.Parent=n.SetPanel E
.Position=UDim2.new(0.76,5,0,0)local H=false E.ScrollBottom.Changed:connect(
function(I)if E.ScrollBottom.Value==true then if H then return end H=true
loadSectionOfItems(n,rows,columns)H=false end end)local I={}for J=1,#b do local
K=game:GetService'InsertService':GetUserSets(b[J])if K and#K>2 then for L=3,#K
do if K[L].Name=='High Scalability'then table.insert(I,1,K[L])else table.insert(
I,K[L])end end end end if I then u=processCategory(I)end rows=math.floor(n.
SetPanel.ItemsFrame.AbsoluteSize.Y/w)columns=math.floor(n.SetPanel.ItemsFrame.
AbsoluteSize.X/v)populateSetsFrame()insertPanelCloseCon=n.SetPanel.CancelButton.
MouseButton1Click:connect(function()n.SetPanel.Visible=false if d then d()end
end)local J,K=function(J)if J then n.SetPanel.Visible=true else n.SetPanel.
Visible=false end end,function()if n then if n:FindFirstChild'SetPanel'then
return n.SetPanel.Visible end end return false end return n,J,K,r end a.
CreateTerrainMaterialSelector=function(b,c)local d=Instance.new'BindableEvent'd.
Name='TerrainMaterialSelectionChanged'local e,g=nil,Instance.new'Frame'g.Name=
'TerrainMaterialSelector'if b then g.Size=b else g.Size=UDim2.new(0,245,0,230)
end if c then g.Position=c end g.BorderSizePixel=0 g.BackgroundColor3=Color3.
new(0,0,0)g.Active=true d.Parent=g local h,i,j=true,{},{'Grass','Sand','Brick',
'Granite','Asphalt','Iron','Aluminum','Gold','Plank','Log','Gravel',
'Cinder Block','Stone Wall','Concrete','Plastic (red)','Plastic (blue)'}if h
then table.insert(j,'Water')end local k=1 function getEnumFromName(l)if l==
'Grass'then return 1 end if l=='Sand'then return 2 end if l=='Erase'then return
0 end if l=='Brick'then return 3 end if l=='Granite'then return 4 end if l==
'Asphalt'then return 5 end if l=='Iron'then return 6 end if l=='Aluminum'then
return 7 end if l=='Gold'then return 8 end if l=='Plank'then return 9 end if l==
'Log'then return 10 end if l=='Gravel'then return 11 end if l=='Cinder Block'
then return 12 end if l=='Stone Wall'then return 13 end if l=='Concrete'then
return 14 end if l=='Plastic (red)'then return 15 end if l=='Plastic (blue)'then
return 16 end if l=='Water'then return 17 end end function getNameFromEnum(l)if
l==Enum.CellMaterial.Grass or l==1 then return'Grass'elseif l==Enum.CellMaterial
.Sand or l==2 then return'Sand'elseif l==Enum.CellMaterial.Empty or l==0 then
return'Erase'elseif l==Enum.CellMaterial.Brick or l==3 then return'Brick'elseif
l==Enum.CellMaterial.Granite or l==4 then return'Granite'elseif l==Enum.
CellMaterial.Asphalt or l==5 then return'Asphalt'elseif l==Enum.CellMaterial.
Iron or l==6 then return'Iron'elseif l==Enum.CellMaterial.Aluminum or l==7 then
return'Aluminum'elseif l==Enum.CellMaterial.Gold or l==8 then return'Gold'elseif
l==Enum.CellMaterial.WoodPlank or l==9 then return'Plank'elseif l==Enum.
CellMaterial.WoodLog or l==10 then return'Log'elseif l==Enum.CellMaterial.Gravel
or l==11 then return'Gravel'elseif l==Enum.CellMaterial.CinderBlock or l==12
then return'Cinder Block'elseif l==Enum.CellMaterial.MossyStone or l==13 then
return'Stone Wall'elseif l==Enum.CellMaterial.Cement or l==14 then return
'Concrete'elseif l==Enum.CellMaterial.RedPlastic or l==15 then return
'Plastic (red)'elseif l==Enum.CellMaterial.BluePlastic or l==16 then return
'Plastic (blue)'end if h then if l==Enum.CellMaterial.Water or l==17 then return
'Water'end end end local function updateMaterialChoice(l)k=getEnumFromName(l)d:
Fire(k)end for l,m in pairs(j)do i[m]={}if m=='Grass'then i[m].Regular=
'http://www.roblox.com/asset/?id=56563112'elseif m=='Sand'then i[m].Regular=
'http://www.roblox.com/asset/?id=62356652'elseif m=='Brick'then i[m].Regular=
'http://www.roblox.com/asset/?id=65961537'elseif m=='Granite'then i[m].Regular=
'http://www.roblox.com/asset/?id=67532153'elseif m=='Asphalt'then i[m].Regular=
'http://www.roblox.com/asset/?id=67532038'elseif m=='Iron'then i[m].Regular=
'http://www.roblox.com/asset/?id=67532093'elseif m=='Aluminum'then i[m].Regular=
'http://www.roblox.com/asset/?id=67531995'elseif m=='Gold'then i[m].Regular=
'http://www.roblox.com/asset/?id=67532118'elseif m=='Plastic (red)'then i[m].
Regular='http://www.roblox.com/asset/?id=67531848'elseif m=='Plastic (blue)'then
i[m].Regular='http://www.roblox.com/asset/?id=67531924'elseif m=='Plank'then i[m
].Regular='http://www.roblox.com/asset/?id=67532015'elseif m=='Log'then i[m].
Regular='http://www.roblox.com/asset/?id=67532051'elseif m=='Gravel'then i[m].
Regular='http://www.roblox.com/asset/?id=67532206'elseif m=='Cinder Block'then i
[m].Regular='http://www.roblox.com/asset/?id=67532103'elseif m=='Stone Wall'then
i[m].Regular='http://www.roblox.com/asset/?id=67531804'elseif m=='Concrete'then
i[m].Regular='http://www.roblox.com/asset/?id=67532059'elseif m=='Water'then i[m
].Regular='http://www.roblox.com/asset/?id=81407474'else i[m].Regular=
'http://www.roblox.com/asset/?id=66887593'end end local n,o,p,q=a.
CreateScrollingFrame(nil,'grid')n.Size=UDim2.new(0.85,0,1,0)n.Position=UDim2.
new(0,0,0,0)n.Parent=g o.Parent=g o.Visible=true o.Position=UDim2.new(1,-19,0,0)
p.Parent=g p.Visible=true p.Position=UDim2.new(1,-19,1,-17)local function
goToNewMaterial(r,s)updateMaterialChoice(s)r.BackgroundTransparency=0 e.
BackgroundTransparency=1 e=r end local function createMaterialButton(r)local s=
Instance.new'TextButton's.Text=''s.Size=UDim2.new(0,32,0,32)s.BackgroundColor3=
Color3.new(1,1,1)s.BorderSizePixel=0 s.BackgroundTransparency=1 s.
AutoButtonColor=false s.Name=tostring(r)local t=Instance.new'ImageButton't.
AutoButtonColor=false t.BackgroundTransparency=1 t.Size=UDim2.new(0,30,0,30)t.
Position=UDim2.new(0,1,0,1)t.Name=tostring(r)t.Parent=s t.Image=i[r].Regular
local u=Instance.new'NumberValue'u.Name='EnumType'u.Parent=s u.Value=0 t.
MouseEnter:connect(function()s.BackgroundTransparency=0 end)t.MouseLeave:
connect(function()if e~=s then s.BackgroundTransparency=1 end end)t.
MouseButton1Click:connect(function()if e~=s then goToNewMaterial(s,tostring(r))
end end)return s end for r=1,#j do local s=createMaterialButton(j[r])if j[r]==
'Grass'then e=s s.BackgroundTransparency=0 end s.Parent=n end local r=function(r
)if not r then return end if k==r then return end local s,t=getNameFromEnum(r),n
:GetChildren()for u=1,#t do if t[u].Name=='Plastic (blue)'and s==
'Plastic (blue)'then goToNewMaterial(t[u],s)return end if t[u].Name==
'Plastic (red)'and s=='Plastic (red)'then goToNewMaterial(t[u],s)return end if
string.find(t[u].Name,s)then goToNewMaterial(t[u],s)return end end end g.Changed
:connect(function(s)if s=='AbsoluteSize'then q()end end)q()return g,d,r end a.
CreateLoadingFrame=function(b,c,d)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=35238053'local e=Instance.new'Frame'e.Name=
'LoadingFrame'e.Style=Enum.FrameStyle.RobloxRound if c then e.Size=c else e.Size
=UDim2.new(0,300,0,160)end if d then e.Position=d else e.Position=UDim2.new(0.5,
-150,0.5,-80)end local g=Instance.new'Frame'g.Name='LoadingBar'g.
BackgroundColor3=Color3.new(0,0,0)g.BorderColor3=Color3.new(0.30980392156862746,
0.30980392156862746,0.30980392156862746)g.Position=UDim2.new(0,0,0,41)g.Size=
UDim2.new(1,0,0,30)g.Parent=e local h=Instance.new'ImageLabel'h.Name=
'LoadingGreenBar'h.Image='http://www.roblox.com/asset/?id=35238053'h.Position=
UDim2.new(0,0,0,0)h.Size=UDim2.new(0,0,1,0)h.Visible=false h.Parent=g local i=
Instance.new'TextLabel'i.Name='LoadingPercent'i.BackgroundTransparency=1 i.
Position=UDim2.new(0,0,1,0)i.Size=UDim2.new(1,0,0,14)i.Font=Enum.Font.Arial i.
Text='0%'i.FontSize=Enum.FontSize.Size14 i.TextColor3=Color3.new(1,1,1)i.Parent=
g local j=Instance.new'TextButton'j.Name='CancelButton'j.Position=UDim2.new(0.5,
-60,1,-40)j.Size=UDim2.new(0,120,0,40)j.Font=Enum.Font.Arial j.FontSize=Enum.
FontSize.Size18 j.TextColor3=Color3.new(1,1,1)j.Text='Cancel'j.Style=Enum.
ButtonStyle.RobloxButton j.Parent=e local k=Instance.new'TextLabel'k.Name=
'loadingName'k.BackgroundTransparency=1 k.Size=UDim2.new(1,0,0,18)k.Position=
UDim2.new(0,0,0,2)k.Font=Enum.Font.Arial k.Text=b k.TextColor3=Color3.new(1,1,1)
k.TextStrokeTransparency=1 k.FontSize=Enum.FontSize.Size18 k.Parent=e local l=
Instance.new'BindableEvent'l.Name='CancelButtonClicked'l.Parent=j j.
MouseButton1Click:connect(function()l:Fire()end)local m=function(m,n,o)if m and
type(m)~='number'then error(
'updateLoadingGuiPercent expects number as argument, got',type(m),'instead')end
local p=nil if m<0 then p=UDim2.new(0,0,1,0)elseif m>1 then p=UDim2.new(1,0,1,0)
else p=UDim2.new(m,0,1,0)end if n then if not o then error
[[updateLoadingGuiPercent is set to tween new percentage, but got no tween time length! Please pass this in as third argument]]
end if p.X.Scale>0 then h.Visible=true h:TweenSize(p,Enum.EasingDirection.Out,
Enum.EasingStyle.Quad,o,true)else h:TweenSize(p,Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,o,true,function()if p.X.Scale<0 then h.Visible=false end end)
end else h.Size=p h.Visible=(p.X.Scale>0)end end h.Changed:connect(function(n)if
n=='Size'then i.Text=tostring(math.ceil(h.Size.X.Scale*100))..'%'end end)return
e,m,l end a.CreatePluginFrame=function(b,c,d,e,g)function createMenuButton(h,i,j
,k,l,m)local n=Instance.new'TextButton'n.AutoButtonColor=false n.Name=l n.
BackgroundTransparency=1 n.Position=i n.Size=h n.Font=Enum.Font.ArialBold n.
FontSize=k n.Text=j n.TextColor3=Color3.new(1,1,1)n.BorderSizePixel=0 n.
BackgroundColor3=Color3.new(7.8431372549019605E-2,7.8431372549019605E-2,
7.8431372549019605E-2)n.MouseEnter:connect(function()if n.Selected then return
end n.BackgroundTransparency=0 end)n.MouseLeave:connect(function()if n.Selected
then return end n.BackgroundTransparency=1 end)n.Parent=m return n end local h=
Instance.new'Frame'h.Name=tostring(b)..'DragBar'h.BackgroundColor3=Color3.new(
0.15294117647058825,0.15294117647058825,0.15294117647058825)h.BorderColor3=
Color3.new(0,0,0)if c then h.Size=UDim2.new(c.X.Scale,c.X.Offset,0,20)+UDim2.
new(0,20,0,0)else h.Size=UDim2.new(0,183,0,20)end if d then h.Position=d end h.
Active=true h.Draggable=true h.MouseEnter:connect(function()h.BackgroundColor3=
Color3.new(0.19215686274509805,0.19215686274509805,0.19215686274509805)end)h.
MouseLeave:connect(function()h.BackgroundColor3=Color3.new(0.15294117647058825,
0.15294117647058825,0.15294117647058825)end)h.Parent=g local i=Instance.new
'TextLabel'i.Name='BarNameLabel'i.Text=' '..tostring(b)i.TextColor3=Color3.new(1
,1,1)i.TextStrokeTransparency=0 i.Size=UDim2.new(1,0,1,0)i.Font=Enum.Font.
ArialBold i.FontSize=Enum.FontSize.Size18 i.TextXAlignment=Enum.TextXAlignment.
Left i.BackgroundTransparency=1 i.Parent=h local j,k=createMenuButton(UDim2.new(
0,15,0,17),UDim2.new(1,-16,0.5,-8),'X',Enum.FontSize.Size14,'CloseButton',h),
Instance.new'BindableEvent'k.Name='CloseEvent'k.Parent=j j.MouseButton1Click:
connect(function()k:Fire()j.BackgroundTransparency=1 end)local l,m=
createMenuButton(UDim2.new(0,15,0,17),UDim2.new(1,-51,0.5,-8),'?',Enum.FontSize.
Size14,'HelpButton',h),Instance.new'Frame'm.Name='HelpFrame'm.BackgroundColor3=
Color3.new(0,0,0)m.Size=UDim2.new(0,300,0,552)m.Position=UDim2.new(1,5,0,0)m.
Active=true m.BorderSizePixel=0 m.Visible=false m.Parent=h l.MouseButton1Click:
connect(function()m.Visible=not m.Visible if m.Visible then l.Selected=true l.
BackgroundTransparency=0 local n=getScreenGuiAncestor(m)if n then if m.
AbsolutePosition.X+m.AbsoluteSize.X>n.AbsoluteSize.X then m.Position=UDim2.new(0
,-5-m.AbsoluteSize.X,0,0)else m.Position=UDim2.new(1,5,0,0)end else m.Position=
UDim2.new(1,5,0,0)end else l.Selected=false l.BackgroundTransparency=1 end end)
local n=createMenuButton(UDim2.new(0,16,0,17),UDim2.new(1,-34,0.5,-8),'-',Enum.
FontSize.Size14,'MinimizeButton',h)n.TextYAlignment=Enum.TextYAlignment.Top
local o=Instance.new'Frame'o.Name='MinimizeFrame'o.BackgroundColor3=Color3.new(
0.28627450980392155,0.28627450980392155,0.28627450980392155)o.BorderColor3=
Color3.new(0,0,0)o.Position=UDim2.new(0,0,1,0)if c then o.Size=UDim2.new(c.X.
Scale,c.X.Offset,0,50)+UDim2.new(0,20,0,0)else o.Size=UDim2.new(0,183,0,50)end o
.Visible=false o.Parent=h local p=Instance.new'TextButton'p.Position=UDim2.new(
0.5,-50,0.5,-20)p.Name='MinimizeButton'p.Size=UDim2.new(0,100,0,40)p.Style=Enum.
ButtonStyle.RobloxButton p.Font=Enum.Font.ArialBold p.FontSize=Enum.FontSize.
Size18 p.TextColor3=Color3.new(1,1,1)p.Text='Show'p.Parent=o local q=Instance.
new'Frame'q.Name='SeparatingLine'q.BackgroundColor3=Color3.new(
0.45098039215686275,0.45098039215686275,0.45098039215686275)q.BorderSizePixel=0
q.Position=UDim2.new(1,-18,0.5,-7)q.Size=UDim2.new(0,1,0,14)q.Parent=h local r=q
:clone()r.Position=UDim2.new(1,-35,0.5,-7)r.Parent=h local s=Instance.new'Frame'
s.Name='WidgetContainer's.BackgroundTransparency=1 s.Position=UDim2.new(0,0,1,0)
s.BorderColor3=Color3.new(0,0,0)if not e then s.BackgroundTransparency=0 s.
BackgroundColor3=Color3.new(0.2823529411764706,0.2823529411764706,
0.2823529411764706)end s.Parent=h if c then if e then s.Size=c else s.Size=UDim2
.new(0,h.AbsoluteSize.X,c.Y.Scale,c.Y.Offset)end else if e then s.Size=UDim2.
new(0,163,0,400)else s.Size=UDim2.new(0,h.AbsoluteSize.X,0,400)end end if d then
s.Position=d+UDim2.new(0,0,0,20)end local t,u,v=nil if e then t,u=a.
CreateTrueScrollingFrame()t.Size=UDim2.new(1,0,1,0)t.BackgroundColor3=Color3.
new(0.2823529411764706,0.2823529411764706,0.2823529411764706)t.BorderColor3=
Color3.new(0,0,0)t.Active=true t.Parent=s u.Parent=h u.BackgroundColor3=Color3.
new(0.2823529411764706,0.2823529411764706,0.2823529411764706)u.BorderSizePixel=0
u.BackgroundTransparency=0 u.Position=UDim2.new(1,-21,1,1)if c then u.Size=UDim2
.new(0,21,c.Y.Scale,c.Y.Offset)else u.Size=UDim2.new(0,21,0,400)end u:
FindFirstChild'ScrollDownButton'.Position=UDim2.new(0,0,1,-20)local w=Instance.
new'Frame'w.Name='FakeLine'w.BorderSizePixel=0 w.BackgroundColor3=Color3.new(0,0
,0)w.Size=UDim2.new(0,1,1,1)w.Position=UDim2.new(1,0,0,0)w.Parent=u v=Instance.
new'TextButton'v.ZIndex=2 v.AutoButtonColor=false v.Name='VerticalDragger'v.
BackgroundColor3=Color3.new(0.19607843137254902,0.19607843137254902,
0.19607843137254902)v.BorderColor3=Color3.new(0,0,0)v.Size=UDim2.new(1,20,0,20)v
.Position=UDim2.new(0,0,1,0)v.Active=true v.Text=''v.Parent=s local x=Instance.
new'Frame'x.Name='ScrubFrame'x.BackgroundColor3=Color3.new(1,1,1)x.
BorderSizePixel=0 x.Position=UDim2.new(0.5,-5,0.5,0)x.Size=UDim2.new(0,10,0,1)x.
ZIndex=5 x.Parent=v local y=x:clone()y.Position=UDim2.new(0.5,-5,0.5,-2)y.Parent
=v local z=x:clone()z.Position=UDim2.new(0.5,-5,0.5,2)z.Parent=v local A=
Instance.new'TextButton'A.Name='AreaSoak'A.Size=UDim2.new(1,0,1,0)A.
BackgroundTransparency=1 A.BorderSizePixel=0 A.Text=''A.ZIndex=10 A.Visible=
false A.Active=true A.Parent=getScreenGuiAncestor(g)local B,C=false,nil v.
MouseEnter:connect(function()v.BackgroundColor3=Color3.new(0.23529411764705882,
0.23529411764705882,0.23529411764705882)end)v.MouseLeave:connect(function()v.
BackgroundColor3=Color3.new(0.19607843137254902,0.19607843137254902,
0.19607843137254902)end)v.MouseButton1Down:connect(function(D,E)B=true A.Visible
=true C=E end)A.MouseButton1Up:connect(function()B=false A.Visible=false end)A.
MouseMoved:connect(function(D,E)if not B then return end local H=E-C if not u.
ScrollDownButton.Visible and H>0 then return end if(s.Size.Y.Offset+H)<150 then
s.Size=UDim2.new(s.Size.X.Scale,s.Size.X.Offset,s.Size.Y.Scale,150)u.Size=UDim2.
new(0,21,0,150)return end C=E if s.Size.Y.Offset+H>=0 then s.Size=UDim2.new(s.
Size.X.Scale,s.Size.X.Offset,s.Size.Y.Scale,s.Size.Y.Offset+H)u.Size=UDim2.new(0
,21,0,u.Size.Y.Offset+H)end end)end local function switchMinimize()o.Visible=not
o.Visible if e then t.Visible=not t.Visible v.Visible=not v.Visible u.Visible=
not u.Visible else s.Visible=not s.Visible end if o.Visible then n.Text='+'else
n.Text='-'end end p.MouseButton1Click:connect(function()switchMinimize()end)n.
MouseButton1Click:connect(function()switchMinimize()end)if e then return h,t,m,k
else return h,s,m,k end end a.Help=function(b)if b=='CreatePropertyDropDownMenu'
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