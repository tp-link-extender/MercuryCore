if game.CoreGui.Version<3 then return end local a=script.Parent local function
waitForChild(b,c)while not b:FindFirstChild(c)do b.ChildAdded:wait()end end
local function waitForProperty(b,c)while not b[c]do b.Changed:wait()end end
local function IsTouchDevice()local b=false pcall(function()b=Game:GetService
'UserInputService'.TouchEnabled end)return b end local function IsPhone()if a.
AbsoluteSize.Y<=320 then return true end return false end waitForChild(game,
'Players')waitForProperty(game.Players,'LocalPlayer')local b=Instance.new'Frame'
b.Name='CurrentLoadout'b.Position=UDim2.new(0.5,-300,1,-85)b.Size=UDim2.new(0,
600,0,54)b.BackgroundTransparency=1 b.RobloxLocked=true b.Parent=a local c=
Instance.new'ImageLabel'c.Name='Background'c.Size=UDim2.new(1.2,0,1.2,0)c.Image=
'http://www.roblox.com/asset/?id=96536002'c.BackgroundTransparency=1 c.Position=
UDim2.new(-0.1,0,-0.1,0)c.ZIndex=0 c.Parent=b c.Visible=false local d=Instance.
new'ImageLabel'd.Size=UDim2.new(1,0,0.025,1)d.Position=UDim2.new(0,0,0,0)d.Image
='http://www.roblox.com/asset/?id=97662207'd.BackgroundTransparency=1 d.Parent=c
local e=Instance.new'BoolValue'e.Name='Debounce'e.RobloxLocked=true e.Parent=b
local f=Instance.new'ImageButton'f.RobloxLocked=true f.Visible=false f.Name=
'BackpackButton'f.BackgroundTransparency=1 f.Image=
'http://www.roblox.com/asset/?id=97617958'f.Position=UDim2.new(0.5,-60,1,-108)f.
Size=UDim2.new(0,120,0,18)waitForChild(a,'ControlFrame')f.Parent=a.ControlFrame
local g=9 if IsPhone()then g=3 b.Size=UDim2.new(0,180,0,54)b.Position=UDim2.new(
0.5,-90,1,-85)end for h=0,g do local i=Instance.new'Frame'i.RobloxLocked=true i.
BackgroundColor3=Color3.new(0,0,0)i.BackgroundTransparency=1 i.BorderColor3=
Color3.new(1,1,1)i.Name='Slot'..tostring(h)i.ZIndex=4 if h==0 then i.Position=
UDim2.new(0.9,0,0,0)else i.Position=UDim2.new((h-1)*0.1,(h-1)*6,0,0)end i.Size=
UDim2.new(0,54,1,0)i.Parent=b if a.AbsoluteSize.Y<=320 then i.Position=UDim2.
new(0,(h-1)*60,0,-50)print('Well got here',i,i.Position.X.Scale,i.Position.X.
Offset)end if a.AbsoluteSize.Y<=320 and h==0 then i:Destroy()end end local h=
Instance.new'ImageButton'h.Name='TempSlot'h.Active=true h.Size=UDim2.new(1,0,1,0
)h.BackgroundTransparency=1 h.Style='Custom'h.Visible=false h.RobloxLocked=true
h.Parent=b h.ZIndex=3 local i=Instance.new'ImageLabel'i.Name='Background'i.
BackgroundTransparency=1 i.Image='http://www.roblox.com/asset/?id=97613075'i.
Size=UDim2.new(1,0,1,0)i.Parent=h local j=Instance.new'ImageLabel'j.Name=
'Highlight'j.BackgroundTransparency=1 j.Image=
'http://www.roblox.com/asset/?id=97643886'j.Size=UDim2.new(1,0,1,0)j.Visible=
false local k=Instance.new'ObjectValue'k.Name='GearReference'k.RobloxLocked=true
k.Parent=h local l=Instance.new'TextLabel'l.Name='ToolTipLabel'l.RobloxLocked=
true l.Text=''l.BackgroundTransparency=0.5 l.BorderSizePixel=0 l.Visible=false l
.TextColor3=Color3.new(1,1,1)l.BackgroundColor3=Color3.new(0,0,0)l.
TextStrokeTransparency=0 l.Font=Enum.Font.ArialBold l.FontSize=Enum.FontSize.
Size14 l.Size=UDim2.new(1,60,0,20)l.Position=UDim2.new(0,-30,0,-30)l.Parent=h
local m=Instance.new'BoolValue'm.Name='Kill'm.RobloxLocked=true m.Parent=h local
n=Instance.new'ImageLabel'n.Name='GearImage'n.BackgroundTransparency=1 n.
Position=UDim2.new(0,0,0,0)n.Size=UDim2.new(1,0,1,0)n.ZIndex=5 n.RobloxLocked=
true n.Parent=h local o=Instance.new'TextLabel'o.Name='SlotNumber'o.
BackgroundTransparency=1 o.BorderSizePixel=0 o.Font=Enum.Font.ArialBold o.
FontSize=Enum.FontSize.Size18 o.Position=UDim2.new(0,0,0,0)o.Size=UDim2.new(0,10
,0,15)o.TextColor3=Color3.new(1,1,1)o.TextTransparency=0 o.TextXAlignment=Enum.
TextXAlignment.Left o.TextYAlignment=Enum.TextYAlignment.Bottom o.RobloxLocked=
true o.Parent=h o.ZIndex=5 if IsTouchDevice()then o.Visible=false end local p=o:
Clone()p.Name='SlotNumberDownShadow'p.TextColor3=Color3.new(0,0,0)p.Position=
UDim2.new(0,1,0,-1)p.Parent=h p.ZIndex=2 local q=p:Clone()q.Name=
'SlotNumberUpShadow'q.Position=UDim2.new(0,-1,0,-1)q.Parent=h local r=Instance.
new'TextLabel'r.RobloxLocked=true r.Name='GearText'r.BackgroundTransparency=1 r.
Font=Enum.Font.Arial r.FontSize=Enum.FontSize.Size14 r.Position=UDim2.new(0,-8,0
,-8)r.Size=UDim2.new(1,16,1,16)r.Text=''r.TextColor3=Color3.new(1,1,1)r.TextWrap
=true r.Parent=h r.ZIndex=5 local s=Instance.new'Frame's.RobloxLocked=true s.
Visible=false s.Name='Backpack's.Position=UDim2.new(0.5,0,0.5,0)s.
BackgroundColor3=Color3.new(0.12549019607843137,0.12549019607843137,
0.12549019607843137)s.BackgroundTransparency=0 s.BorderSizePixel=0 s.Parent=a s.
Active=true local t=Instance.new'BoolValue't.RobloxLocked=true t.Name='SwapSlot'
t.Parent=s local u=Instance.new'IntValue'u.RobloxLocked=true u.Name='Slot'u.
Parent=t local v=Instance.new'ObjectValue'v.RobloxLocked=true v.Name=
'GearButton'v.Parent=t local w=Instance.new'Frame'w.Name='Tabs'w.Visible=false w
.Active=false w.RobloxLocked=true w.BackgroundColor3=Color3.new(0,0,0)w.
BackgroundTransparency=0.08 w.BorderSizePixel=0 w.Position=UDim2.new(0,0,-0.1,-4
)w.Size=UDim2.new(1,0,0.1,4)w.Parent=s local x=Instance.new'Frame'x.RobloxLocked
=true x.Name='TabLine'x.BackgroundColor3=Color3.new(0.20784313725490197,
0.20784313725490197,0.20784313725490197)x.BorderSizePixel=0 x.Position=UDim2.
new(0,5,1,-4)x.Size=UDim2.new(1,-10,0,4)x.ZIndex=2 x.Parent=w local y=Instance.
new'TextButton'y.RobloxLocked=true y.Name='InventoryButton'y.Size=UDim2.new(0,60
,0,30)y.Position=UDim2.new(0,7,1,-31)y.BackgroundColor3=Color3.new(1,1,1)y.
BorderColor3=Color3.new(1,1,1)y.Font=Enum.Font.ArialBold y.FontSize=Enum.
FontSize.Size18 y.Text='Gear'y.AutoButtonColor=false y.TextColor3=Color3.new(0,0
,0)y.Selected=true y.Active=true y.ZIndex=3 y.Parent=w if game.CoreGui.Version>=
8 then local z=Instance.new'TextButton'z.RobloxLocked=true z.Name=
'WardrobeButton'z.Size=UDim2.new(0,90,0,30)z.Position=UDim2.new(0,77,1,-31)z.
BackgroundColor3=Color3.new(0,0,0)z.BorderColor3=Color3.new(1,1,1)z.Font=Enum.
Font.ArialBold z.FontSize=Enum.FontSize.Size18 z.Text='Wardrobe'z.
AutoButtonColor=false z.TextColor3=Color3.new(1,1,1)z.Selected=false z.Active=
true z.Parent=w end local z=Instance.new'TextButton'z.RobloxLocked=true z.Name=
'CloseButton'z.Font=Enum.Font.ArialBold z.FontSize=Enum.FontSize.Size24 z.
Position=UDim2.new(1,-33,0,4)z.Size=UDim2.new(0,30,0,30)z.Style=Enum.ButtonStyle
.RobloxButton z.Text=''z.TextColor3=Color3.new(1,1,1)z.Parent=w z.Modal=true
local A=Instance.new'ImageLabel'A.RobloxLocked=true A.Name='XImage'game:
GetService'ContentProvider':Preload'http://www.roblox.com/asset/?id=75547445'A.
Image='http://www.roblox.com/asset/?id=75547445'A.BackgroundTransparency=1 A.
Position=UDim2.new(-0.25,-1,-0.25,-1)A.Size=UDim2.new(1.5,2,1.5,2)A.ZIndex=2 A.
Parent=z local B=Instance.new'Frame'B.RobloxLocked=true B.Name='SearchFrame'B.
BackgroundTransparency=1 B.Position=UDim2.new(1,-220,0,2)B.Size=UDim2.new(0,220,
0,24)B.Parent=s local C=Instance.new'ImageButton'C.RobloxLocked=true C.Name=
'SearchButton'C.Size=UDim2.new(0,25,0,25)C.BackgroundTransparency=1 C.Image=
'rbxasset://textures/ui/SearchIcon.png'C.Parent=B local D=Instance.new
'TextButton'D.RobloxLocked=true D.Position=UDim2.new(0,25,0,0)D.Size=UDim2.new(1
,-28,0,26)D.Name='SearchBoxFrame'D.Text=''D.Style=Enum.ButtonStyle.RobloxButton
D.Parent=B local E=Instance.new'TextBox'E.RobloxLocked=true E.Name='SearchBox'E.
BackgroundTransparency=1 E.Font=Enum.Font.ArialBold E.FontSize=Enum.FontSize.
Size12 E.Position=UDim2.new(0,-5,0,-5)E.Size=UDim2.new(1,10,1,10)E.TextColor3=
Color3.new(1,1,1)E.TextXAlignment=Enum.TextXAlignment.Left E.ZIndex=2 E.TextWrap
=true E.Text='Search...'E.Parent=D local F=Instance.new'TextButton'F.
RobloxLocked=true F.Visible=false F.Name='ResetButton'F.Position=UDim2.new(1,-26
,0,3)F.Size=UDim2.new(0,20,0,20)F.Style=Enum.ButtonStyle.RobloxButtonDefault F.
Text='X'F.TextColor3=Color3.new(1,1,1)F.Font=Enum.Font.ArialBold F.FontSize=Enum
.FontSize.Size18 F.ZIndex=3 F.Parent=B local G=Instance.new'Frame'G.Name='Gear'G
.RobloxLocked=true G.BackgroundTransparency=1 G.Size=UDim2.new(1,0,1,0)G.
ClipsDescendants=true G.Parent=s local H=Instance.new'Frame'H.RobloxLocked=true
H.Name='AssetsList'H.BackgroundTransparency=1 H.Size=UDim2.new(0.2,0,1,0)H.Style
=Enum.FrameStyle.RobloxSquare H.Visible=false H.Parent=G local I=Instance.new
'Frame'I.RobloxLocked=true I.Name='GearGrid'I.Size=UDim2.new(0.95,0,1,0)I.
BackgroundTransparency=1 I.Parent=G local J=Instance.new'ImageButton'J.
RobloxLocked=true J.Visible=false J.Name='GearButton'J.Size=UDim2.new(0,54,0,54)
J.Style='Custom'J.BackgroundTransparency=1 J.Parent=I local K=Instance.new
'ImageLabel'K.Name='Background'K.BackgroundTransparency=1 K.Image=
'http://www.roblox.com/asset/?id=97613075'K.Size=UDim2.new(1,0,1,0)K.Parent=J
local L=Instance.new'ObjectValue'L.RobloxLocked=true L.Name='GearReference'L.
Parent=J local M=Instance.new'Frame'M.RobloxLocked=true M.Name='GreyOutButton'M.
BackgroundTransparency=0.5 M.Size=UDim2.new(1,0,1,0)M.Active=true M.Visible=
false M.ZIndex=3 M.Parent=J local N=Instance.new'TextLabel'N.RobloxLocked=true N
.Name='GearText'N.BackgroundTransparency=1 N.Font=Enum.Font.Arial N.FontSize=
Enum.FontSize.Size14 N.Position=UDim2.new(0,-8,0,-8)N.Size=UDim2.new(1,16,1,16)N
.Text=''N.ZIndex=2 N.TextColor3=Color3.new(1,1,1)N.TextWrap=true N.Parent=J
local O=Instance.new'Frame'O.RobloxLocked=true O.Name='GearGridScrollingArea'O.
Position=UDim2.new(1,-19,0,35)O.Size=UDim2.new(0,17,1,-45)O.
BackgroundTransparency=1 O.Parent=G local P=Instance.new'Frame'P.RobloxLocked=
true P.Name='GearLoadouts'P.BackgroundTransparency=1 P.Position=UDim2.new(0.7,23
,0.5,1)P.Size=UDim2.new(0.3,-23,0.5,-1)P.Parent=G P.Visible=false local Q=
Instance.new'Frame'Q.RobloxLocked=true Q.Name='GearLoadoutsHeader'Q.
BackgroundColor3=Color3.new(0,0,0)Q.BackgroundTransparency=0.2 Q.BorderColor3=
Color3.new(1,0,0)Q.Size=UDim2.new(1,2,0.15,-1)Q.Parent=P local R=Instance.new
'TextLabel'R.RobloxLocked=true R.Name='LoadoutsHeaderText'R.
BackgroundTransparency=1 R.Font=Enum.Font.ArialBold R.FontSize=Enum.FontSize.
Size18 R.Size=UDim2.new(1,0,1,0)R.Text='Loadouts'R.TextColor3=Color3.new(1,1,1)R
.Parent=Q local S=O:clone()S.RobloxLocked=true S.Name=
'GearLoadoutsScrollingArea'S.Position=UDim2.new(1,-15,0.15,2)S.Size=UDim2.new(0,
17,0.85,-2)S.Parent=P local T=Instance.new'Frame'T.RobloxLocked=true T.Name=
'LoadoutsList'T.Position=UDim2.new(0,0,0.15,2)T.Size=UDim2.new(1,-17,0.85,-2)T.
Style=Enum.FrameStyle.RobloxSquare T.Parent=P local U=Instance.new'Frame'U.
RobloxLocked=true U.Name='GearPreview'U.Position=UDim2.new(0.7,23,0,0)U.Size=
UDim2.new(0.3,-28,0.5,-1)U.BackgroundTransparency=1 U.ZIndex=7 U.Parent=G local
V=Instance.new'Frame'V.RobloxLocked=true V.Name='GearStats'V.
BackgroundTransparency=1 V.Position=UDim2.new(0,0,0.75,0)V.Size=UDim2.new(1,0,
0.25,0)V.ZIndex=8 V.Parent=U local W=Instance.new'TextLabel'W.RobloxLocked=true
W.Name='GearName'W.BackgroundTransparency=1 W.Font=Enum.Font.ArialBold W.
FontSize=Enum.FontSize.Size18 W.Position=UDim2.new(0,-3,0,0)W.Size=UDim2.new(1,6
,1,5)W.Text=''W.TextColor3=Color3.new(1,1,1)W.TextWrap=true W.ZIndex=9 W.Parent=
V local X=Instance.new'ImageLabel'X.RobloxLocked=true X.Name='GearImage'X.Image=
''X.BackgroundTransparency=1 X.Position=UDim2.new(0.125,0,0,0)X.Size=UDim2.new(
0.75,0,0.75,0)X.ZIndex=8 X.Parent=U local Y=Instance.new'Frame'Y.
BackgroundColor3=Color3.new(0,0,0)Y.BackgroundTransparency=0.5 Y.BorderSizePixel
=0 Y.RobloxLocked=true Y.Name='GearIcons'Y.Position=UDim2.new(0.4,2,0.85,-2)Y.
Size=UDim2.new(0.6,0,0.15,0)Y.Visible=false Y.ZIndex=9 Y.Parent=X local Z=
Instance.new'ImageLabel'Z.RobloxLocked=true Z.Name='GenreImage'Z.
BackgroundColor3=Color3.new(0.4,0.6,1)Z.BackgroundTransparency=0.5 Z.
BorderSizePixel=0 Z.Size=UDim2.new(0.25,0,1,0)Z.Parent=Y local _=Z:clone()_.
RobloxLocked=true _.Name='AttributeOneImage'_.BackgroundColor3=Color3.new(1,0.2,
0)_.Position=UDim2.new(0.25,0,0,0)_.Parent=Y local aa=Z:clone()aa.RobloxLocked=
true aa.Name='AttributeTwoImage'aa.BackgroundColor3=Color3.new(0.6,1,0.6)aa.
Position=UDim2.new(0.5,0,0,0)aa.Parent=Y local ab=Z:clone()ab.RobloxLocked=true
ab.Name='AttributeThreeImage'ab.BackgroundColor3=Color3.new(0,0.5,0.5)ab.
Position=UDim2.new(0.75,0,0,0)ab.Parent=Y if game.CoreGui.Version<8 then script:
remove()return end local function makeCharFrame(ac,ad)local ae=Instance.new
'Frame'ae.RobloxLocked=true ae.Size=UDim2.new(1,0,1,-70)ae.Position=UDim2.new(0,
0,0,20)ae.Name=ac ae.BackgroundTransparency=1 ae.Parent=ad ae.Visible=false
return ae end local function makeZone(ac,ad,ae,af,ag)local ah=Instance.new
'ImageLabel'ah.RobloxLocked=true ah.Name=ac ah.Image=ad ah.Size=ae ah.
BackgroundTransparency=1 ah.Position=af ah.Parent=ag return ah end
local function makeStyledButton(ac,ad,ae,af,ag)local ah=Instance.new
'ImageButton'ah.RobloxLocked=true ah.Name=ac ah.Size=ad ah.Position=ae if ag
then ah.Style=ag else ah.BackgroundColor3=Color3.new(0,0,0)ah.BorderColor3=
Color3.new(1,1,1)end ah.Parent=af return ah end local function makeTextLabel(ac,
ad,ae,af)local ag=Instance.new'TextLabel'ag.RobloxLocked=true ag.
BackgroundTransparency=1 ag.Size=UDim2.new(0,32,0,14)ag.Name=ac ag.Font=Enum.
Font.Arial ag.TextColor3=Color3.new(1,1,1)ag.FontSize=Enum.FontSize.Size14 ag.
Text=ad ag.Position=ae ag.Parent=af end local ac=Instance.new'Frame'ac.Name=
'Wardrobe'ac.RobloxLocked=true ac.BackgroundTransparency=1 ac.Visible=false ac.
Size=UDim2.new(1,0,1,0)ac.Parent=s local ad=Instance.new'Frame'ad.RobloxLocked=
true ad.Name='AssetList'ad.Position=UDim2.new(0,4,0,5)ad.Size=UDim2.new(0,85,1,-
5)ad.BackgroundTransparency=1 ad.Visible=true ad.Parent=ac local ae=Instance.new
'Frame'ae.RobloxLocked=true ae.Name='PreviewAssetFrame'ae.BackgroundTransparency
=1 ae.Position=UDim2.new(1,-240,0,30)ae.Size=UDim2.new(0,250,0,250)ae.Parent=ac
local af=Instance.new'TextButton'af.RobloxLocked=true af.Name=
'PreviewAssetBacking'af.Active=false af.Text=''af.AutoButtonColor=false af.Size=
UDim2.new(1,0,1,0)af.Style=Enum.ButtonStyle.RobloxButton af.Visible=false af.
ZIndex=9 af.Parent=ae local ag=Instance.new'ImageLabel'ag.RobloxLocked=true ag.
Name='PreviewAssetImage'ag.BackgroundTransparency=0.8 ag.Position=UDim2.new(0.5,
-100,0,0)ag.Size=UDim2.new(0,200,0,200)ag.BorderSizePixel=0 ag.ZIndex=10 ag.
Parent=af local ah=Instance.new'TextLabel'ah.Name='AssetNameLabel'ah.
RobloxLocked=true ah.BackgroundTransparency=1 ah.Position=UDim2.new(0,0,1,-20)ah
.Size=UDim2.new(0.5,0,0,24)ah.ZIndex=10 ah.Font=Enum.Font.Arial ah.Text=''ah.
TextColor3=Color3.new(1,1,1)ah.TextScaled=true ah.Parent=af local ai=ah:clone()
ai.RobloxLocked=true ai.Name='AssetTypeLabel'ai.TextScaled=false ai.FontSize=
Enum.FontSize.Size18 ai.Position=UDim2.new(0.5,3,1,-20)ai.Parent=af local aj=
Instance.new'TextButton'aj.RobloxLocked=true aj.Name='PreviewButton'aj.Text=
'Rotate'aj.BackgroundColor3=Color3.new(0,0,0)aj.BackgroundTransparency=0.5 aj.
BorderColor3=Color3.new(1,1,1)aj.Position=UDim2.new(1.2,-62,1,-50)aj.Size=UDim2.
new(0,125,0,50)aj.Font=Enum.Font.ArialBold aj.FontSize=Enum.FontSize.Size24 aj.
TextColor3=Color3.new(1,1,1)aj.TextWrapped=true aj.TextStrokeTransparency=0 aj.
Parent=ac local ak=Instance.new'Frame'ak.RobloxLocked=true ak.Name=
'CharacterPane'ak.Position=UDim2.new(1,-220,0,32)ak.Size=UDim2.new(0,220,1,-40)
ak.BackgroundTransparency=1 ak.Visible=true ak.Parent=ac local al=makeCharFrame(
'FacesFrame',ak)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=75460621'makeZone('FaceZone',
'http://www.roblox.com/asset/?id=75460621',UDim2.new(0,157,0,137),UDim2.new(0.5,
-78,0.5,-68),al)makeStyledButton('Face',UDim2.new(0,64,0,64),UDim2.new(0.5,-32,
0.5,-135),al)local am=makeCharFrame('HeadsFrame',ak)makeZone('FaceZone',
'http://www.roblox.com/asset/?id=75460621',UDim2.new(0,157,0,137),UDim2.new(0.5,
-78,0.5,-68),am)makeStyledButton('Head',UDim2.new(0,64,0,64),UDim2.new(0.5,-32,
0.5,-135),am)local an=makeCharFrame('HatsFrame',ak)game:GetService
'ContentProvider':Preload'http://www.roblox.com/asset/?id=75457888'local ao=
makeZone('HatsZone','http://www.roblox.com/asset/?id=75457888',UDim2.new(0,186,0
,184),UDim2.new(0.5,-93,0.5,-100),an)makeStyledButton('Hat1Button',UDim2.new(0,
64,0,64),UDim2.new(0,-1,0,-1),ao,Enum.ButtonStyle.RobloxButton)makeStyledButton(
'Hat2Button',UDim2.new(0,64,0,64),UDim2.new(0,63,0,-1),ao,Enum.ButtonStyle.
RobloxButton)makeStyledButton('Hat3Button',UDim2.new(0,64,0,64),UDim2.new(0,127,
0,-1),ao,Enum.ButtonStyle.RobloxButton)local ap=makeCharFrame('PantsFrame',ak)
game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=75457920'makeZone('PantsZone',
'http://www.roblox.com/asset/?id=75457920',UDim2.new(0,121,0,99),UDim2.new(0.5,-
60,0.5,-100),ap)local aq=Instance.new'Frame'aq.RobloxLocked=true aq.Size=UDim2.
new(0,25,0,56)aq.Position=UDim2.new(0.5,-26,0.5,0)aq.BackgroundColor3=Color3.
new(0,0,0)aq.BorderColor3=Color3.new(1,1,1)aq.Name='PantFrame'aq.Parent=ap local
ar=aq:clone()ar.Position=UDim2.new(0.5,3,0.5,0)ar.RobloxLocked=true ar.Parent=ap
local as=Instance.new'ImageButton'as.RobloxLocked=true as.BackgroundTransparency
=1 as.ZIndex=2 as.Name='CurrentPants'as.Position=UDim2.new(0.5,-31,0.5,-4)as.
Size=UDim2.new(0,54,0,59)as.Parent=ap local at=makeCharFrame('PackagesFrame',ak)
local au=makeStyledButton('TorsoMeshButton',UDim2.new(0,64,0,64),UDim2.new(0.5,-
32,0.5,-110),at,Enum.ButtonStyle.RobloxButton)makeTextLabel('TorsoLabel','Torso'
,UDim2.new(0.5,-16,0,-25),au)local av=makeStyledButton('LeftLegMeshButton',UDim2
.new(0,64,0,64),UDim2.new(0.5,0,0.5,-25),at,Enum.ButtonStyle.RobloxButton)
makeTextLabel('LeftLegLabel','Left Leg',UDim2.new(0.5,-16,0,-25),av)local aw=
makeStyledButton('RightLegMeshButton',UDim2.new(0,64,0,64),UDim2.new(0.5,-64,0.5
,-25),at,Enum.ButtonStyle.RobloxButton)makeTextLabel('RightLegLabel','Right Leg'
,UDim2.new(0.5,-16,0,-25),aw)local ax=makeStyledButton('RightArmMeshButton',
UDim2.new(0,64,0,64),UDim2.new(0.5,-96,0.5,-110),at,Enum.ButtonStyle.
RobloxButton)makeTextLabel('RightArmLabel','Right Arm',UDim2.new(0.5,-16,0,-25),
ax)local ay=makeStyledButton('LeftArmMeshButton',UDim2.new(0,64,0,64),UDim2.new(
0.5,32,0.5,-110),at,Enum.ButtonStyle.RobloxButton)makeTextLabel('LeftArmLabel',
'Left Arm',UDim2.new(0.5,-16,0,-25),ay)local az=makeCharFrame('T-ShirtsFrame',ak
)game:GetService'ContentProvider':Preload
'http://www.roblox.com/asset/?id=75460642'makeZone('TShirtZone',
'http://www.roblox.com/asset/?id=75460642',UDim2.new(0,121,0,154),UDim2.new(0.5,
-60,0.5,-100),az)makeStyledButton('TShirtButton',UDim2.new(0,64,0,64),UDim2.new(
0.5,-32,0.5,-64),az)local aA=makeCharFrame('ShirtsFrame',ak)makeZone('ShirtZone'
,'http://www.roblox.com/asset/?id=75460642',UDim2.new(0,121,0,154),UDim2.new(0.5
,-60,0.5,-100),aA)makeStyledButton('ShirtButton',UDim2.new(0,64,0,64),UDim2.new(
0.5,-32,0.5,-64),aA)local aB=makeCharFrame('ColorFrame',ak)game:GetService
'ContentProvider':Preload'http://www.roblox.com/asset/?id=76049888'local aC=
makeZone('ColorZone','http://www.roblox.com/asset/?id=76049888',UDim2.new(0,120,
0,150),UDim2.new(0.5,-60,0.5,-100),aB)makeStyledButton('Head',UDim2.new(0.26,0,
0.19,0),UDim2.new(0.37,0,0.02,0),aC).AutoButtonColor=false makeStyledButton(
'LeftArm',UDim2.new(0.19,0,0.36,0),UDim2.new(0.78,0,0.26,0),aC).AutoButtonColor=
false makeStyledButton('RightArm',UDim2.new(0.19,0,0.36,0),UDim2.new(0.025,0,
0.26,0),aC).AutoButtonColor=false makeStyledButton('Torso',UDim2.new(0.43,0,0.36
,0),UDim2.new(0.28,0,0.26,0),aC).AutoButtonColor=false makeStyledButton(
'RightLeg',UDim2.new(0.19,0,0.31,0),UDim2.new(0.275,0,0.67,0),aC).
AutoButtonColor=false makeStyledButton('LeftLeg',UDim2.new(0.19,0,0.31,0),UDim2.
new(0.525,0,0.67,0),aC).AutoButtonColor=false local aD=Instance.new'TextLabel'aD
.RobloxLocked=true aD.Name='CategoryLabel'aD.BackgroundTransparency=1 aD.Font=
Enum.Font.ArialBold aD.FontSize=Enum.FontSize.Size18 aD.Position=UDim2.new(0,0,0
,-7)aD.Size=UDim2.new(1,0,0,20)aD.TextXAlignment=Enum.TextXAlignment.Center aD.
Text='All'aD.TextColor3=Color3.new(1,1,1)aD.Parent=ak local aE=Instance.new
'TextButton'aE.RobloxLocked=true aE.Name='SaveButton'aE.Size=UDim2.new(0.6,0,0,
50)aE.Position=UDim2.new(0.2,0,1,-50)aE.Style=Enum.ButtonStyle.RobloxButton aE.
Selected=false aE.Font=Enum.Font.ArialBold aE.FontSize=Enum.FontSize.Size18 aE.
Text='Save'aE.TextColor3=Color3.new(1,1,1)aE.Parent=ak script:Destroy()