local a=script.Parent:FindFirstChild'ControlFrame'if not a then return end local
b,c,d=a:FindFirstChild'BottomLeftControl',a:FindFirstChild'BottomRightControl',
Instance.new'TextLabel'd.Name='ToolTip'd.Text=''d.Font=Enum.Font.ArialBold d.
FontSize=Enum.FontSize.Size12 d.TextColor3=Color3.new(1,1,1)d.BorderSizePixel=0
d.ZIndex=10 d.Size=UDim2.new(2,0,1,0)d.Position=UDim2.new(1,0,0,0)d.
BackgroundColor3=Color3.new(0,0,0)d.BackgroundTransparency=1 d.TextTransparency=
1 d.TextWrap=true local e=Instance.new'BoolValue'e.Name='inside'e.Value=false e.
Parent=d function setUpListeners(f)local g=0.1 f.Parent.MouseEnter:connect(
function()if f:FindFirstChild'inside'then f.inside.Value=true wait(1.2)if f.
inside.Value then while f.inside.Value and f.BackgroundTransparency>0 do f.
BackgroundTransparency=f.BackgroundTransparency-g f.TextTransparency=f.
TextTransparency-g wait()end end end end)function killTip(h)h.inside.Value=false
h.BackgroundTransparency=1 h.TextTransparency=1 end f.Parent.MouseLeave:connect(
function()killTip(f)end)f.Parent.MouseButton1Click:connect(function()killTip(f)
end)end function createSettingsButtonTip(f)if f==nil then f=b:FindFirstChild
'SettingsButton'end local g=d:clone()g.RobloxLocked=true g.Text=
'Settings/Leave Game'g.Position=UDim2.new(0,0,0,-18)g.Size=UDim2.new(0,120,0,20)
g.Parent=f setUpListeners(g)end wait(5)local f=b:GetChildren()for g=1,#f do if f
[g].Name=='Exit'then local h=d:clone()h.RobloxLocked=true h.Text='Leave Place'h.
Position=UDim2.new(0,0,-1,0)h.Size=UDim2.new(1,0,1,0)h.Parent=f[g]
setUpListeners(h)elseif f[g].Name=='SettingsButton'then createSettingsButtonTip(
f[g])end end local g=c:GetChildren()for h=1,#g do if g[h].Name:find'Camera'~=nil
then local i=d:clone()i.RobloxLocked=true i.Text='Camera View'if g[h].Name:find
'Zoom'then i.Position=UDim2.new(-1,0,-1.5)else i.Position=UDim2.new(0,0,-1.5,0)
end i.Size=UDim2.new(2,0,1.25,0)i.Parent=g[h]setUpListeners(i)end end