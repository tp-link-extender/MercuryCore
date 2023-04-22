local a=script.Parent:FindFirstChild'ControlFrame'if not a then return end local
b b=function(c,d,e)if not(e~=nil)then e=d d=nil end local f=Instance.new(c)if d
then f.Name=d end local g for h,i in pairs(e)do if type(h)=='string'then if h==
'Parent'then g=i else f[h]=i end elseif type(h)=='number'and type(i)=='userdata'
then i.Parent=f end end f.Parent=g return f end local c,d,e,f=a:FindFirstChild
'BottomLeftControl',a:FindFirstChild'BottomRightControl',b('TextLabel','ToolTip'
,{Text='',Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size12,TextColor3=
Color3.new(1,1,1),BorderSizePixel=0,ZIndex=10,Size=UDim2.new(2,0,1,0),Position=
UDim2.new(1,0,0,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,
TextTransparency=1,TextWrap=true,b('BoolValue','inside',{Value=false})}),nil f=
function(g)local h=0.1 g.Parent.MouseEnter:connect(function()if g:FindFirstChild
'inside'then g.inside.Value=true wait(1.2)if g.inside.Value then while g.inside.
Value and g.BackgroundTransparency>0 do g.BackgroundTransparency=g.
BackgroundTransparency-h g.TextTransparency=g.TextTransparency-h wait()end end
end end)local i i=function(j)j.inside.Value=false j.BackgroundTransparency=1 j.
TextTransparency=1 end g.Parent.MouseLeave:connect(function()return i(g)end)
return g.Parent.MouseButton1Click:connect(function()return i(g)end)end local g g
=function(h)if not(h~=nil)then h=c:FindFirstChild'SettingsButton'end local i=e:
clone()i.RobloxLocked=true i.Text='Settings/Leave Game'i.Position=UDim2.new(0,0,
0,-18)i.Size=UDim2.new(0,120,0,20)i.Parent=h f(i)return i end wait(5)local h=c:
GetChildren()for i=1,#h do if h[i].Name=='Exit'then do local j=e:clone()j.
RobloxLocked=true j.Text='Leave Place'j.Position=UDim2.new(0,0,-1,0)j.Size=UDim2
.new(1,0,1,0)j.Parent=h[i]f(j)end elseif h[i].Name=='SettingsButton'then g(h[i])
end end local i=d:GetChildren()for j=1,#i do if(i[j].Name:find'Camera'~=nil)then
do local k=e:clone()k.RobloxLocked=true k.Text='Camera View'if i[j].Name:find
'Zoom'then k.Position=UDim2.new(-1,0,-1.5)else k.Position=UDim2.new(0,0,-1.5,0)
end k.Size=UDim2.new(2,0,1.25,0)k.Parent=i[j]f(k)end end end