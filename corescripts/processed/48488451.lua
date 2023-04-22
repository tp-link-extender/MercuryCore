local a a=function(b,c,d)if not(d~=nil)then d=c c=nil end local e=a(b)if c then
e.Name=c end local f for g,h in pairs(d)do if type(g)=='string'then if g==
'Parent'then f=h else e[g]=h end elseif type(g)=='number'and type(h)=='userdata'
then h.Parent=e end end e.Parent=f return e end local b=a('Frame','Popup',{
Position=UDim2.new(0.5,-165,0.5,-175),Size=UDim2.new(0,330,0,350),Style=Enum.
FrameStyle.RobloxRound,ZIndex=4,Visible=false,Parent=script.Parent,a('TextLabel'
,'PopupText',{Size=UDim2.new(1,0,0.8,0),Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size36,BackgroundTransparency=1,Text="Hello I'm a popup",TextColor3=
Color3.new(0.9725490196078431,0.9725490196078431,0.9725490196078431),TextWrap=
true,ZIndex=5}),a('TextButton','AcceptButton',{Position=UDim2.new(0,20,0,270),
Size=UDim2.new(0,100,0,50),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.
Size24,Style=Enum.ButtonStyle.RobloxButton,TextColor3=Color3.new(
0.9725490196078431,0.9725490196078431,0.9725490196078431),Text='Yes',ZIndex=5}),
a('ImageLabel','PopupImage',{BackgroundTransparency=1,Position=UDim2.new(0.5,-
140,0,0),Size=UDim2.new(0,280,0,280),ZIndex=3,a('ImageLabel','Backing',{
BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Image=
'http://www.roblox.com/asset/?id=47574181',ZIndex=2})})})local c=b.AcceptButton
do local d=b:clone()d.Name='Darken'd.Size=UDim2.new(1,16,1,16)d.Position=UDim2.
new(0,-8,0,-8)d.ZIndex=1 d.Parent=b end do local d=c:clone()d.Name=
'DeclineButton'd.Position=UDim2.new(1,-120,0,270)d.Text='No'd.Parent=b end do
local d=c:clone()d.Name='OKButton'd.Text='OK'd.Position=UDim2.new(0.5,-50,0,270)
d.Visible=false d.Parent=b end return script:remove()