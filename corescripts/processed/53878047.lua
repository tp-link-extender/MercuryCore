print'[Mercury]: Loaded corescript 53878047'if game.CoreGui.Version<3 then
return end local a a=function(b,c,d)if not(d~=nil)then d=c c=nil end local e=
Instance.new(b)if c then e.Name=c end local f for g,h in pairs(d)do if type(g)==
'string'then if g=='Parent'then f=h else e[g]=h end elseif type(g)=='number'and
type(h)=='userdata'then h.Parent=e end end e.Parent=f return e end local b,c=
script.Parent,nil c=function(d,e)while not d:FindFirstChild(e)do d.ChildAdded:
wait()end end local d d=function(e,f)while not e[f]do e.Changed:wait()end end
local e e=function()local f=false pcall(function()f=Game:GetService
'UserInputService'.TouchEnabled end)return f end local f f=function()if b.
AbsoluteSize.Y<=320 then return true else return false end end c(game,'Players')
d(game.Players,'LocalPlayer')local g=a('Frame','CurrentLoadout',{Position=UDim2.
new(0.5,-300,1,-85),Size=UDim2.new(0,600,0,54),BackgroundTransparency=1,
RobloxLocked=true,Parent=b,a('BoolValue','Debounce',{RobloxLocked=true}),a(
'ImageLabel','Background',{Size=UDim2.new(1.2,0,1.2,0),Image=
'http://www.roblox.com/asset/?id=96536002',BackgroundTransparency=1,Position=
UDim2.new(-0.1,0,-0.1,0),ZIndex=0,Visible=false,a('ImageLabel',{Size=UDim2.new(1
,0,0.025,1),Position=UDim2.new(0,0,0,0),Image=
'http://www.roblox.com/asset/?id=97662207',BackgroundTransparency=1})})})c(b,
'ControlFrame')a('ImageButton','BackpackButton',{RobloxLocked=true,Visible=false
,BackgroundTransparency=1,Image='http://www.roblox.com/asset/?id=97617958',
Position=UDim2.new(0.5,-60,1,-108),Size=UDim2.new(0,120,0,18),Parent=b.
ControlFrame})local h=9 if f()then h=3 g.Size=UDim2.new(0,180,0,54)g.Position=
UDim2.new(0.5,-90,1,-85)end for i=0,h do local j=a('Frame','Slot'..tostring(i),{
RobloxLocked=true,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,
BorderColor3=Color3.new(1,1,1),ZIndex=4,Position=UDim2.new((function()if i==0
then return 0.9,0,0,0 else return(i-1)*0.1,(i-1)*6,0,0 end end)()),Size=UDim2.
new(0,54,1,0),Parent=g})if b.AbsoluteSize.Y<=320 then j.Position=UDim2.new(0,(i-
1)*60,0,-50)print('Well got here',j,j.Position.X.Scale,j.Position.X.Offset)if i
==0 then j:Destroy()end end end local i=a('ImageButton','TempSlot',{Active=true,
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Style='Custom',Visible=false,
RobloxLocked=true,ZIndex=3,Parent=g,a('ImageLabel','Background',{
BackgroundTransparency=1,Image='http://www.roblox.com/asset/?id=97613075',Size=
UDim2.new(1,0,1,0)}),a('ObjectValue','GearReference',{RobloxLocked=true}),a(
'TextLabel','ToolTipLabel',{RobloxLocked=true,Text='',BackgroundTransparency=0.5
,BorderSizePixel=0,Visible=false,TextColor3=Color3.new(1,1,1),BackgroundColor3=
Color3.new(0,0,0),TextStrokeTransparency=0,Font=Enum.Font.ArialBold,FontSize=
Enum.FontSize.Size14,Size=UDim2.new(1,60,0,20),Position=UDim2.new(0,-30,0,-30)})
,a('BoolValue','Kill',{RobloxLocked=true}),a('TextLabel','GearText',{
RobloxLocked=true,BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.
FontSize.Size14,Position=UDim2.new(0,-8,0,-8),Size=UDim2.new(1,16,1,16),Text='',
TextColor3=Color3.new(1,1,1),TextWrap=true,ZIndex=5}),a('ImageLabel','GearImage'
,{BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
ZIndex=5,RobloxLocked=true})})local j=a('TextLabel','SlotNumber',{
BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.ArialBold,FontSize=
Enum.FontSize.Size18,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,10,0,15),
TextColor3=Color3.new(1,1,1),TextTransparency=0,TextXAlignment=Enum.
TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Bottom,RobloxLocked=true,
Parent=i,ZIndex=5})if e()then j.Visible=false end local k do local l=j:Clone()l.
Name='SlotNumberDownShadow'l.TextColor3=Color3.new(0,0,0)l.Position=UDim2.new(0,
1,0,-1)l.Parent=i l.ZIndex=2 k=l end do local l=k:Clone()l.Name=
'SlotNumberUpShadow'l.Position=UDim2.new(0,-1,0,-1)l.Parent=i end local l=a(
'Frame','Backpack',{RobloxLocked=true,Visible=false,Position=UDim2.new(0.5,0,0.5
,0),BackgroundColor3=Color3.new(0.12549019607843137,0.12549019607843137,
0.12549019607843137),BackgroundTransparency=0,BorderSizePixel=0,Parent=b,Active=
true,a('BoolValue','SwapSlot',{RobloxLocked=true,a('IntValue','Slot',{
RobloxLocked=true}),a('ObjectValue','GearButton',{RobloxLocked=true})}),a(
'Frame','SearchFrame',{RobloxLocked=true,BackgroundTransparency=1,Position=UDim2
.new(1,-220,0,2),Size=UDim2.new(0,220,0,24),a('ImageButton','SearchButton',{
RobloxLocked=true,Size=UDim2.new(0,25,0,25),BackgroundTransparency=1,Image=
'rbxasset://textures/ui/SearchIcon.png'}),a('TextButton','ResetButton',{
RobloxLocked=true,Visible=false,Position=UDim2.new(1,-26,0,3),Size=UDim2.new(0,
20,0,20),Style=Enum.ButtonStyle.RobloxButtonDefault,Text='X',TextColor3=Color3.
new(1,1,1),Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size18,ZIndex=3}),a(
'TextButton','SearchBoxFrame',{RobloxLocked=true,Position=UDim2.new(0,25,0,0),
Size=UDim2.new(1,-28,0,26),Text='',Style=Enum.ButtonStyle.RobloxButton,a(
'TextBox','SearchBox',{RobloxLocked=true,BackgroundTransparency=1,Font=Enum.Font
.ArialBold,FontSize=Enum.FontSize.Size12,Position=UDim2.new(0,-5,0,-5),Size=
UDim2.new(1,10,1,10),TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.
TextXAlignment.Left,ZIndex=2,TextWrap=true,Text='Search...'})})})})local m=a(
'Frame','Tabs',{Visible=false,Active=false,RobloxLocked=true,BackgroundColor3=
Color3.new(0,0,0),BackgroundTransparency=0.08,BorderSizePixel=0,Position=UDim2.
new(0,0,-0.1,-4),Size=UDim2.new(1,0,0.1,4),Parent=l,a('Frame','TabLine',{
RobloxLocked=true,BackgroundColor3=Color3.new(0.20784313725490197,
0.20784313725490197,0.20784313725490197),BorderSizePixel=0,Position=UDim2.new(0,
5,1,-4),Size=UDim2.new(1,-10,0,4),ZIndex=2}),a('TextButton','InventoryButton',{
RobloxLocked=true,Size=UDim2.new(0,60,0,30),Position=UDim2.new(0,7,1,-31),
BackgroundColor3=Color3.new(1,1,1),BorderColor3=Color3.new(1,1,1),Font=Enum.Font
.ArialBold,FontSize=Enum.FontSize.Size18,Text='Gear',AutoButtonColor=false,
TextColor3=Color3.new(0,0,0),Selected=true,Active=true,ZIndex=3}),a('TextButton'
,'CloseButton',{RobloxLocked=true,Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size24,Position=UDim2.new(1,-33,0,4),Size=UDim2.new(0,30,0,30),Style=
Enum.ButtonStyle.RobloxButton,Text='',TextColor3=Color3.new(1,1,1),Modal=true,a(
'ImageLabel','XImage',{RobloxLocked=true,Image=(function()game:GetService
'ContentProvider':Preload'http://www.roblox.com/asset/?id=75547445'return
'http://www.roblox.com/asset/?id=75547445'end)(),BackgroundTransparency=1,
Position=UDim2.new(-0.25,-1,-0.25,-1),Size=UDim2.new(1.5,2,1.5,2),ZIndex=2})})})
if game.CoreGui.Version>=8 then a('TextButton','WardrobeButton',{RobloxLocked=
true,Size=UDim2.new(0,90,0,30),Position=UDim2.new(0,77,1,-31),BackgroundColor3=
Color3.new(0,0,0),BorderColor3=Color3.new(1,1,1),Font=Enum.Font.ArialBold,
FontSize=Enum.FontSize.Size18,Text='Wardrobe',AutoButtonColor=false,TextColor3=
Color3.new(1,1,1),Selected=false,Active=true,Parent=m})end local n=a('Frame',
'Gear',{RobloxLocked=true,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
ClipsDescendants=true,Parent=l,a('Frame','AssetsList',{RobloxLocked=true,
BackgroundTransparency=1,Size=UDim2.new(0.2,0,1,0),Style=Enum.FrameStyle.
RobloxSquare,Visible=false}),a('Frame','GearGrid',{RobloxLocked=true,Size=UDim2.
new(0.95,0,1,0),BackgroundTransparency=1,a('ImageButton','GearButton',{
RobloxLocked=true,Visible=false,Size=UDim2.new(0,54,0,54),Style='Custom',
BackgroundTransparency=1,a('ImageLabel','Background',{BackgroundTransparency=1,
Image='http://www.roblox.com/asset/?id=97613075',Size=UDim2.new(1,0,1,0)}),a(
'ObjectValue','GearReference',{RobloxLocked=true}),a('Frame','GreyOutButton',{
RobloxLocked=true,BackgroundTransparency=0.5,Size=UDim2.new(1,0,1,0),Active=true
,Visible=false,ZIndex=3}),a('TextLabel','GearText',{RobloxLocked=true,
BackgroundTransparency=1,Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size14,
Position=UDim2.new(0,-8,0,-8),Size=UDim2.new(1,16,1,16),Text='',ZIndex=2,
TextColor3=Color3.new(1,1,1),TextWrap=true})})})})local o,p=a('Frame',
'GearGridScrollingArea',{RobloxLocked=true,Position=UDim2.new(1,-19,0,35),Size=
UDim2.new(0,17,1,-45),BackgroundTransparency=1,Parent=n}),a('Frame',
'GearLoadouts',{RobloxLocked=true,BackgroundTransparency=1,Position=UDim2.new(
0.7,23,0.5,1),Size=UDim2.new(0.3,-23,0.5,-1),Parent=n,Visible=false,a('Frame',
'LoadoutsList',{RobloxLocked=true,Position=UDim2.new(0,0,0.15,2),Size=UDim2.new(
1,-17,0.85,-2),Style=Enum.FrameStyle.RobloxSquare}),a('Frame',
'GearLoadoutsHeader',{RobloxLocked=true,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.2,BorderColor3=Color3.new(1,0,0),Size=UDim2.new(1,2,
0.15,-1),a('TextLabel','LoadoutsHeaderText',{RobloxLocked=true,
BackgroundTransparency=1,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size18,
Size=UDim2.new(1,0,1,0),Text='Loadouts',TextColor3=Color3.new(1,1,1)})})})do
local q=o:Clone()q.Name='GearLoadoutsScrollingArea'q.RobloxLocked=true q.
Position=UDim2.new(1,-15,0.15,2)q.Size=UDim2.new(0,17,0.85,-2)q.Parent=p end
local q,r,s=a('Frame','GearPreview',{RobloxLocked=true,Position=UDim2.new(0.7,23
,0,0),Size=UDim2.new(0.3,-28,0.5,-1),BackgroundTransparency=1,ZIndex=7,Parent=n,
a('Frame','GearStats',{RobloxLocked=true,BackgroundTransparency=1,Position=UDim2
.new(0,0,0.75,0),Size=UDim2.new(1,0,0.25,0),ZIndex=8,a('TextLabel','GearName',{
RobloxLocked=true,BackgroundTransparency=1,Font=Enum.Font.ArialBold,FontSize=
Enum.FontSize.Size18,Position=UDim2.new(0,-3,0,0),Size=UDim2.new(1,6,1,5),Text=
'',TextColor3=Color3.new(1,1,1),TextWrap=true,ZIndex=9})}),a('ImageLabel',
'GearImage',{RobloxLocked=true,Image='',BackgroundTransparency=1,Position=UDim2.
new(0.125,0,0,0),Size=UDim2.new(0.75,0,0.75,0),ZIndex=8,a('Frame','GearIcons',{
BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,BorderSizePixel=0,
RobloxLocked=true,Position=UDim2.new(0.4,2,0.85,-2),Size=UDim2.new(0.6,0,0.15,0)
,Visible=false,ZIndex=9,a('ImageLabel','GenreImage',{RobloxLocked=true,
BackgroundColor3=Color3.new(0.4,0.6,1),BackgroundTransparency=0.5,
BorderSizePixel=0,Size=UDim2.new(0.25,0,1,0)})})})}),nil,nil do local t=q.
GearImage r,s=t.GearIcons,t.GearIcons.GenreImage end do local t=s:Clone()t.Name=
'AttributeOneImage't.RobloxLocked=true t.BackgroundColor3=Color3.new(1,0.2,0)t.
Position=UDim2.new(0.25,0,0,0)t.Parent=r end do local t=s:Clone()t.Name=
'AttributeTwoImage't.RobloxLocked=true t.BackgroundColor3=Color3.new(0.6,1,0.6)t
.Position=UDim2.new(0.5,0,0,0)t.Parent=r end do local t=s:Clone()t.Name=
'AttributeThreeImage't.RobloxLocked=true t.BackgroundColor3=Color3.new(0,0.5,0.5
)t.Position=UDim2.new(0.75,0,0,0)t.Parent=r end if game.CoreGui.Version<8 then
script:remove()return end local t t=function(u,v)return a('Frame',tostring(u),{
RobloxLocked=true,Size=UDim2.new(1,0,1,-70),Position=UDim2.new(0,0,0,20),
BackgroundTransparency=1,Parent=v,Visible=false})end local u u=function(v,w,x,y,
z)return a('ImageLabel',tostring(v),{RobloxLocked=true,Image=w,Size=x,
BackgroundTransparency=1,Position=y,Parent=z})end local v v=function(w,x,y,z,A)
local B=a('ImageButton',tostring(w),{RobloxLocked=true,Size=x,Position=y})if A
then B.Style=A else B.BackgroundColor3=Color3.new(0,0,0)B.BorderColor3=Color3.
new(1,1,1)end B.Parent=z return B end local w w=function(x,y,z,A)return a(
'TextLabel',x,{RobloxLocked=true,BackgroundTransparency=1,Size=UDim2.new(0,32,0,
14),Font=Enum.Font.Arial,TextColor3=Color3.new(1,1,1),FontSize=Enum.FontSize.
Size14,Text=y,Position=z,Parent=A})end local x=a('Frame','Wardrobe',{
RobloxLocked=true,BackgroundTransparency=1,Visible=false,Size=UDim2.new(1,0,1,0)
,Parent=l,a('Frame','AssetList',{RobloxLocked=true,Position=UDim2.new(0,4,0,5),
Size=UDim2.new(0,85,1,-5),BackgroundTransparency=1,Visible=true}),a('TextButton'
,'PreviewButton',{RobloxLocked=true,Text='Rotate',BackgroundColor3=Color3.new(0,
0,0),BackgroundTransparency=0.5,BorderColor3=Color3.new(1,1,1),Position=UDim2.
new(1.2,-62,1,-50),Size=UDim2.new(0,125,0,50),Font=Enum.Font.ArialBold,FontSize=
Enum.FontSize.Size24,TextColor3=Color3.new(1,1,1),TextWrapped=true,
TextStrokeTransparency=0})})local y=a('Frame','PreviewAssetFrame',{RobloxLocked=
true,BackgroundTransparency=1,Position=UDim2.new(1,-240,0,30),Size=UDim2.new(0,
250,0,250),Parent=x})local z=a('TextButton','PreviewAssetBacking',{RobloxLocked=
true,Active=false,Text='',AutoButtonColor=false,Size=UDim2.new(1,0,1,0),Style=
Enum.ButtonStyle.RobloxButton,Visible=false,ZIndex=9,Parent=y,a('ImageLabel',
'PreviewAssetImage',{RobloxLocked=true,BackgroundTransparency=0.8,Position=UDim2
.new(0.5,-100,0,0),Size=UDim2.new(0,200,0,200),BorderSizePixel=0,ZIndex=10})})
local A=a('TextLabel','AssetNameLabel',{RobloxLocked=true,BackgroundTransparency
=1,Position=UDim2.new(0,0,1,-20),Size=UDim2.new(0.5,0,0,24),ZIndex=10,Font=Enum.
Font.Arial,Text='',TextColor3=Color3.new(1,1,1),TextScaled=true,Parent=z})do
local B=A:Clone()B.Name='AssetTypeLabel'B.RobloxLocked=true B.TextScaled=false B
.FontSize=Enum.FontSize.Size18 B.Position=UDim2.new(0.5,3,1,-20)B.Parent=z end
local B=a('Frame','CharacterPane',{RobloxLocked=true,Position=UDim2.new(1,-220,0
,32),Size=UDim2.new(0,220,1,-40),BackgroundTransparency=1,Visible=true,Parent=x,
a('TextLabel','CategoryLabel',{RobloxLocked=true,BackgroundTransparency=1,Font=
Enum.Font.ArialBold,FontSize=Enum.FontSize.Size18,Position=UDim2.new(0,0,0,-7),
Size=UDim2.new(1,0,0,20),TextXAlignment=Enum.TextXAlignment.Center,Text='All',
TextColor3=Color3.new(1,1,1)}),a('TextButton','SaveButton',{RobloxLocked=true,
Size=UDim2.new(0.6,0,0,50),Position=UDim2.new(0.2,0,1,-50),Style=Enum.
ButtonStyle.RobloxButton,Selected=false,Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size18,Text='Save',TextColor3=Color3.new(1,1,1)})})local C=t(
'FacesFrame',B)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=75460621'u('FaceZone',
'http://www.roblox.com/asset/?id=75460621',UDim2.new(0,157,0,137),UDim2.new(0.5,
-78,0.5,-68),C)v('Face',UDim2.new(0,64,0,64),UDim2.new(0.5,-32,0.5,-135),C)local
D=t('HeadsFrame',B)u('FaceZone','http://www.roblox.com/asset/?id=75460621',UDim2
.new(0,157,0,137),UDim2.new(0.5,-78,0.5,-68),D)v('Head',UDim2.new(0,64,0,64),
UDim2.new(0.5,-32,0.5,-135),D)local E=t('HatsFrame',B)game:GetService
'ContentProvider':Preload'http://www.roblox.com/asset/?id=75457888'local F=u(
'HatsZone','http://www.roblox.com/asset/?id=75457888',UDim2.new(0,186,0,184),
UDim2.new(0.5,-93,0.5,-100),E)v('Hat1Button',UDim2.new(0,64,0,64),UDim2.new(0,-1
,0,-1),F,Enum.ButtonStyle.RobloxButton)v('Hat2Button',UDim2.new(0,64,0,64),UDim2
.new(0,63,0,-1),F,Enum.ButtonStyle.RobloxButton)v('Hat3Button',UDim2.new(0,64,0,
64),UDim2.new(0,127,0,-1),F,Enum.ButtonStyle.RobloxButton)local G=t('PantsFrame'
,B)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=75457920'u('PantsZone',
'http://www.roblox.com/asset/?id=75457920',UDim2.new(0,121,0,99),UDim2.new(0.5,-
60,0.5,-100),G)local H=a('Frame','PantFrame',{RobloxLocked=true,Size=UDim2.new(0
,25,0,56),Position=UDim2.new(0.5,-26,0.5,0),BackgroundColor3=Color3.new(0,0,0),
BorderColor3=Color3.new(1,1,1),Parent=G})do local I=H:Clone()I.Position=UDim2.
new(0.5,3,0.5,0)I.RobloxLocked=true I.Parent=G end a('ImageButton',
'CurrentPants',{RobloxLocked=true,BackgroundTransparency=1,ZIndex=2,Position=
UDim2.new(0.5,-31,0.5,-4),Size=UDim2.new(0,54,0,59),Parent=G})local I=t(
'PackagesFrame',B)local J=v('TorsoMeshButton',UDim2.new(0,64,0,64),UDim2.new(0.5
,-32,0.5,-110),I,Enum.ButtonStyle.RobloxButton)w('TorsoLabel','Torso',UDim2.new(
0.5,-16,0,-25),J)local K=v('LeftLegMeshButton',UDim2.new(0,64,0,64),UDim2.new(
0.5,0,0.5,-25),I,Enum.ButtonStyle.RobloxButton)w('LeftLegLabel','Left Leg',UDim2
.new(0.5,-16,0,-25),K)local L=v('RightLegMeshButton',UDim2.new(0,64,0,64),UDim2.
new(0.5,-64,0.5,-25),I,Enum.ButtonStyle.RobloxButton)w('RightLegLabel',
'Right Leg',UDim2.new(0.5,-16,0,-25),L)local M=v('RightArmMeshButton',UDim2.new(
0,64,0,64),UDim2.new(0.5,-96,0.5,-110),I,Enum.ButtonStyle.RobloxButton)w(
'RightArmLabel','Right Arm',UDim2.new(0.5,-16,0,-25),M)local N=v(
'LeftArmMeshButton',UDim2.new(0,64,0,64),UDim2.new(0.5,32,0.5,-110),I,Enum.
ButtonStyle.RobloxButton)w('LeftArmLabel','Left Arm',UDim2.new(0.5,-16,0,-25),N)
local O=t('T-ShirtsFrame',B)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=75460642'u('TShirtZone',
'http://www.roblox.com/asset/?id=75460642',UDim2.new(0,121,0,154),UDim2.new(0.5,
-60,0.5,-100),O)v('TShirtButton',UDim2.new(0,64,0,64),UDim2.new(0.5,-32,0.5,-64)
,O)local P=t('ShirtsFrame',B)u('ShirtZone',
'http://www.roblox.com/asset/?id=75460642',UDim2.new(0,121,0,154),UDim2.new(0.5,
-60,0.5,-100),P)v('ShirtButton',UDim2.new(0,64,0,64),UDim2.new(0.5,-32,0.5,-64),
P)local Q=t('ColorFrame',B)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=76049888'local R=u('ColorZone',
'http://www.roblox.com/asset/?id=76049888',UDim2.new(0,120,0,150),UDim2.new(0.5,
-60,0.5,-100),Q)v('Head',UDim2.new(0.26,0,0.19,0),UDim2.new(0.37,0,0.02,0),R).
AutoButtonColor=false v('LeftArm',UDim2.new(0.19,0,0.36,0),UDim2.new(0.78,0,0.26
,0),R).AutoButtonColor=false v('RightArm',UDim2.new(0.19,0,0.36,0),UDim2.new(
0.025,0,0.26,0),R).AutoButtonColor=false v('Torso',UDim2.new(0.43,0,0.36,0),
UDim2.new(0.28,0,0.26,0),R).AutoButtonColor=false v('RightLeg',UDim2.new(0.19,0,
0.31,0),UDim2.new(0.275,0,0.67,0),R).AutoButtonColor=false v('LeftLeg',UDim2.
new(0.19,0,0.31,0),UDim2.new(0.525,0,0.67,0),R).AutoButtonColor=false return
script:Destroy()