if game.CoreGui.Version<3 then return end local function waitForChild(a,b)while
not a:FindFirstChild(b)do a.ChildAdded:wait()end return a:FindFirstChild(b)end
local function waitForProperty(a,b)while not a[b]do a.Changed:wait()end end
local a,b,c,d=script.Parent,'gear',true,game:GetService'CoreGui':FindFirstChild
'RobloxGui'assert(d)local e=waitForChild(d,'ControlFrame')local f,g=
waitForChild(e,'BackpackButton'),waitForChild(d,'Backpack')waitForChild(d,
'CurrentLoadout')waitForChild(d.CurrentLoadout,'TempSlot')waitForChild(d.
CurrentLoadout.TempSlot,'SlotNumber')waitForChild(a,'Background')local h=a.
Background local function IsTouchDevice()local i=false pcall(function()i=Game:
GetService'UserInputService'.TouchEnabled end)return i end local function
moveHealthBar(i)waitForChild(i,'HealthGUI')waitForChild(i['HealthGUI'],'tray')
local j=i['HealthGUI']['tray']j.Position=UDim2.new(0.5,-85,1,-26)end
local function setHealthBarVisible(i,j)waitForChild(i,'HealthGUI')waitForChild(i
['HealthGUI'],'tray')local k=i['HealthGUI']['tray']k.Visible=j end waitForChild(
game,'Players')waitForProperty(game.Players,'LocalPlayer')local i=game.Players.
LocalPlayer waitForChild(i,'PlayerGui')Spawn(function()moveHealthBar(i.PlayerGui
)end)while i.Character==nil do wait(0.03)end local j=waitForChild(i.Character,
'Humanoid')j.Died:connect(function()f.Visible=false end)waitForChild(game,
'LocalBackpack')game.LocalBackpack:SetOldSchoolBackpack(false)waitForChild(a.
Parent,'Backpack')local k=a.Parent.Backpack local l=waitForChild(k,
'CoreScripts/BackpackScripts/BackpackManager')local m,n,o,p,q=waitForChild(l,
'BackpackOpenEvent'),waitForChild(l,'BackpackCloseEvent'),waitForChild(l,
'TabClickedEvent'),true,10 if d.AbsoluteSize.Y<=320 then q=4 end local r,s,t,u=
nil,nil,false,1.18 local v,w,x,y,z,A,B=UDim2.new(1*u,0,1*u,0),UDim2.new(1,0,1,0)
,true,0.5,false,{},{}for C=1,q do B[C]='empty'end local C=false local function
backpackIsOpen()if k then return k.Visible end return false end local function
kill(D,E,F)if E then E:disconnect()end if D==true and F then reorganizeLoadout(F
,false)end end function registerNumberKeys()for D=0,9 do game:GetService
'GuiService':AddKey(tostring(D))end end function unregisterNumberKeys()pcall(
function()for D=0,9 do game:GetService'GuiService':RemoveKey(tostring(D))end end
)end function characterInWorkspace()if game.Players['LocalPlayer']then if game.
Players.LocalPlayer['Character']then if game.Players.LocalPlayer.Character~=nil
then if game.Players.LocalPlayer.Character.Parent~=nil then return true end end
end end return false end function removeGear(D)local E=nil for F=1,#B do if B[F]
==D and D.Parent~=nil then E=F break end end if E then if B[E].GearReference.
Value then if B[E].GearReference.Value.Parent==game.Players.LocalPlayer.
Character then B[E].GearReference.Value.Parent=game.Players.LocalPlayer.Backpack
end if B[E].GearReference.Value:IsA'HopperBin'and B[E].GearReference.Value.
Active then B[E].GearReference.Value:Disable()B[E].GearReference.Value.Active=
false end end B[E]='empty'delay(0,function()D:remove()end)Spawn(function()while
backpackIsOpen()do wait(0.03)end waitForChild(i,'Backpack')local F=true for G=1,
#B do if B[G]~='empty'then F=false end end if F then if#i.Backpack:GetChildren()
<1 then f.Visible=false else f.Position=UDim2.new(0.5,-60,1,-44)end h.Visible=
false end end)end end function insertGear(D,E)local F=nil if not E then for G=1,
#B do if B[G]=='empty'then F=G break end end if F==1 and B[1]~='empty'then D:
remove()return end else F=E local G=1 for H=1,#B do if B[H]=='empty'then G=H
break end end for H=G,F+1,-1 do B[H]=B[H-1]if H==10 then B[H].SlotNumber.Text=
'0'B[H].SlotNumberDownShadow.Text='0'B[H].SlotNumberUpShadow.Text='0'else B[H].
SlotNumber.Text=H B[H].SlotNumberDownShadow.Text=H B[H].SlotNumberUpShadow.Text=
H end end end B[F]=D if F~=q then if type(tostring(F))=='string'then local G=
tostring(F)D.SlotNumber.Text=G D.SlotNumberDownShadow.Text=G D.
SlotNumberUpShadow.Text=G end else D.SlotNumber.Text='0'D.SlotNumberDownShadow.
Text='0'D.SlotNumberUpShadow.Text='0'end D.Visible=true local G=nil G=D.Kill.
Changed:connect(function(H)kill(H,G,D)end)end function reorganizeLoadout(D,E,F,G
)if E then insertGear(D,G)else removeGear(D)end if D~='empty'then D.ZIndex=1 end
end function checkToolAncestry(D,E)if D:FindFirstChild'RobloxBuildTool'then
return end if D:IsA'Tool'or D:IsA'HopperBin'then for F=1,#B do if B[F]~='empty'
and B[F].GearReference.Value==D then if E==nil then B[F].Kill.Value=true return
false elseif D.Parent==i.Character then B[F].Selected=true return true elseif D.
Parent==i.Backpack then if D:IsA'Tool'or D:IsA'HopperBin'then B[F].Selected=
false end return true end B[F].Kill.Value=true return false end end end end
function removeAllEquippedGear(D)local E=i.Character:GetChildren()for F=1,#E do
if(E[F]:IsA'Tool'or E[F]:IsA'HopperBin')and E[F]~=D then if E[F]:IsA'Tool'then E
[F].Parent=i.Backpack end if E[F]:IsA'HopperBin'then E[F]:Disable()end end end
end function hopperBinSwitcher(D,E)if not E then return end E:ToggleSelect()if B
[D]=='empty'then return end if not E.Active then B[D].Selected=false
normalizeButton(B[D])else B[D].Selected=true enlargeButton(B[D])end end function
toolSwitcher(D)if not B[D]then return end local E=B[D].GearReference.Value if E
==nil then return end removeAllEquippedGear(E)local F=D if D==0 then F=10 end
for G=1,#B do if B[G]and B[G]~='empty'and G~=F then normalizeButton(B[G])B[G].
Selected=false if B[G].GearReference and B[G].GearReference.Value and B[G].
GearReference.Value:IsA'HopperBin'and B[G].GearReference.Value.Active then B[G].
GearReference.Value:ToggleSelect()end end end if E:IsA'HopperBin'then
hopperBinSwitcher(D,E)else if E.Parent==i.Character then E.Parent=i.Backpack if
B[D]~='empty'then B[D].Selected=false normalizeButton(B[D])end else E.Parent=i.
Character B[D].Selected=true enlargeButton(B[D])end end end function
activateGear(D)local E=nil if D=='0'then E=10 else E=tonumber(D)end if E==nil
then return end if B[E]~='empty'then toolSwitcher(E)end end enlargeButton=
function(D)if D.Size.Y.Scale>1 then return end if not D.Parent then return end
if not D.Selected then return end for E=1,#B do if B[E]=='empty'then break end
if B[E]~=D then normalizeButton(B[E])end end if not x then return end if D:
FindFirstChild'Highlight'then D.Highlight.Visible=true end if D:IsA'ImageButton'
or D:IsA'TextButton'then D.ZIndex=5 local E,F=-(v.X.Scale-D.Size.X.Scale)/2,-(v.
Y.Scale-D.Size.Y.Scale)/2 D:TweenSizeAndPosition(v,UDim2.new(D.Position.X.Scale+
E,D.Position.X.Offset,D.Position.Y.Scale+F,D.Position.Y.Offset),Enum.
EasingDirection.Out,Enum.EasingStyle.Quad,y/5,x)end end normalizeAllButtons=
function()for D=1,#B do if B[D]=='empty'then break end if B[D]~=button then
normalizeButton(B[D],0.1)end end end normalizeButton=function(D,E)if not D then
return end if D.Size.Y.Scale<=1 then return end if D.Selected then return end if
not D.Parent then return end local F=E if F==nil or type(F)~='number'then F=y/5
end if D:FindFirstChild'Highlight'then D.Highlight.Visible=false end if D:IsA
'ImageButton'or D:IsA'TextButton'then D.ZIndex=1 local G,H=-(w.X.Scale-D.Size.X.
Scale)/2,-(w.Y.Scale-D.Size.Y.Scale)/2 D:TweenSizeAndPosition(w,UDim2.new(D.
Position.X.Scale+G,D.Position.X.Offset,D.Position.Y.Scale+H,D.Position.Y.Offset)
,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,F,x)end end local D=function()
while t do wait()end end function pointInRectangle(E,F,G)if E.x>F.x and E.x<(F.x
+G.x)then if E.y>F.y and E.y<(F.y+G.y)then return true end end return false end
function swapGear(E,F)local G=F:GetChildren()if#G==1 then if G[1]:FindFirstChild
'SlotNumber'then local H,I=tonumber(G[1].SlotNumber.Text),tonumber(E.SlotNumber.
Text)if H==0 then H=10 end if I==0 then I=10 end B[H]=E B[I]=G[1]G[1].SlotNumber
.Text=E.SlotNumber.Text G[1].SlotNumberDownShadow.Text=E.SlotNumber.Text G[1].
SlotNumberUpShadow.Text=E.SlotNumber.Text local J=string.sub(F.Name,5)E.
SlotNumber.Text=J E.SlotNumberDownShadow.Text=J E.SlotNumberUpShadow.Text=J E.
Position=UDim2.new(E.Position.X.Scale,0,E.Position.Y.Scale,0)G[1].Position=UDim2
.new(G[1].Position.X.Scale,0,G[1].Position.Y.Scale,0)G[1].Parent=E.Parent E.
Parent=F end else local H=tonumber(E.SlotNumber.Text)if H==0 then H=10 end B[H]=
'empty'local I=string.sub(F.Name,5)E.SlotNumber.Text=I E.SlotNumberDownShadow.
Text=I E.SlotNumberUpShadow.Text=I local J=tonumber(E.SlotNumber.Text)if J==0
then J=10 end B[J]=E E.Position=UDim2.new(E.Position.X.Scale,0,E.Position.Y.
Scale,0)E.Parent=F end end function resolveDrag(E,F,G)local H,I=Vector2.new(F,G)
,E.Parent local J=I.Parent:GetChildren()for K=1,#J do if J[K]:IsA'Frame'then if
pointInRectangle(H,J[K].AbsolutePosition,J[K].AbsoluteSize)then swapGear(E,J[K])
return true end end end if(F<I.AbsolutePosition.x or F>(I.AbsolutePosition.x+I.
AbsoluteSize.x))or(G<I.AbsolutePosition.y or G>(I.AbsolutePosition.y+I.
AbsoluteSize.y))then reorganizeLoadout(E,false)return false else if dragBeginPos
then E.Position=dragBeginPos end return-1 end end function unequipAllItems(E)for
F=1,#B do if B[F]=='empty'then break end if B[F].GearReference.Value and B[F].
GearReference.Value~=E then if B[F].GearReference.Value:IsA'HopperBin'then B[F].
GearReference.Value:Disable()elseif B[F].GearReference.Value:IsA'Tool'then B[F].
GearReference.Value.Parent=game.Players.LocalPlayer.Backpack end B[F].Selected=
false end end end function showToolTip(E,F)if E and E:FindFirstChild
'ToolTipLabel'and E.ToolTipLabel:IsA'TextLabel'and not IsTouchDevice()then E.
ToolTipLabel.Text=tostring(F)local G=E.ToolTipLabel.TextBounds.X+6 E.
ToolTipLabel.Size=UDim2.new(0,G,0,20)E.ToolTipLabel.Position=UDim2.new(0.5,-G/2,
0,-30)E.ToolTipLabel.Visible=true end end function hideToolTip(E,F)if E and E:
FindFirstChild'ToolTipLabel'and E.ToolTipLabel:IsA'TextLabel'then E.ToolTipLabel
.Visible=false end end local E=function(E,F,G,H)D()t=true if E:FindFirstChild
'RobloxBuildTool'then t=false return end if not E:IsA'Tool'then if not E:IsA
'HopperBin'then t=false return end end if not G then for I=1,#B do if B[I]~=
'empty'and B[I].GearReference.Value==E then t=false return end end end local I=a
.TempSlot:clone()I.Name=E.Name I.GearImage.Image=E.TextureId if I.GearImage.
Image==''then I.GearText.Text=E.Name end I.GearReference.Value=E I.MouseEnter:
connect(function()if I.GearReference and I.GearReference.Value['ToolTip']and I.
GearReference.Value.ToolTip~=''then showToolTip(I,I.GearReference.Value.ToolTip)
end end)I.MouseLeave:connect(function()if I.GearReference and I.GearReference.
Value['ToolTip']and I.GearReference.Value.ToolTip~=''then hideToolTip(I,I.
GearReference.Value.ToolTip)end end)I.RobloxLocked=true local J=-1 if not G then
for K=1,#B do if B[K]=='empty'then J=K break end end else J=G end if J==-1 then
t=false return end local K=J%10 local L=a:FindFirstChild('Slot'..tostring(K))I.
Parent=L if H then local M,N=H.AbsolutePosition,I.AbsolutePosition local O=M-N I
.Position=UDim2.new(I.Position.X.Scale,O.x,I.Position.Y.Scale,O.y)I.ZIndex=4 end
if G then reorganizeLoadout(I,true,F,G)else reorganizeLoadout(I,true)end if I.
Parent==nil then t=false return end if F then I.Selected=true unequipAllItems(E)
delay(y+0.01,function()if I:FindFirstChild'GearReference'and((I.GearReference.
Value:IsA'Tool'and I.GearReference.Value.Parent==i.Character)or(I.GearReference.
Value:IsA'HopperBin'and I.GearReference.Value.Active==true))then enlargeButton(I
)end end)end local M,N,O,P,Q,R,S=nil,nil N=I.MouseButton1Click:connect(function(
)if characterInWorkspace()then if not I.Draggable then activateGear(I.SlotNumber
.Text)end end end)P=I.MouseEnter:connect(function()if k.Visible then I.Draggable
=true end end)S=I.DragBegin:connect(function(T)M=T I.ZIndex=7 local U=I:
GetChildren()for V=1,#U do if U[V]:IsA'TextLabel'then if string.find(U[V].Name,
'Shadow')then U[V].ZIndex=8 else U[V].ZIndex=9 end elseif U[V]:IsA'Frame'or U[V]
:IsA'ImageLabel'then U[V].ZIndex=7 end end end)R=I.DragStopped:connect(function(
T,U)if I.Selected then I.ZIndex=4 else I.ZIndex=3 end local V=I:GetChildren()for
W=1,#V do if V[W]:IsA'TextLabel'then if string.find(V[W].Name,'Shadow')then V[W]
.ZIndex=3 else V[W].ZIndex=4 end elseif V[W]:IsA'Frame'or V[W]:IsA'ImageLabel'
then V[W].ZIndex=2 end end resolveDrag(I,T,U)end)Q=I.MouseLeave:connect(function
()I.Draggable=false end)O=I.AncestryChanged:connect(function()if I.Parent and I.
Parent.Parent==a then return end if N then N:disconnect()end if O then O:
disconnect()end if P then P:disconnect()end if Q then Q:disconnect()end if R
then R:disconnect()end if S then S:disconnect()end end)local T,U=nil,nil T=E.
AncestryChanged:connect(function(V,W)if not checkToolAncestry(V,W)then if T then
T:disconnect()end if U then U:disconnect()end removeFromInventory(E)elseif W==
game.Players.LocalPlayer.Backpack then normalizeButton(I)end end)U=E.Changed:
connect(function(V)if V=='Name'then if I and I.GearImage.Image==''then I.
GearText.Text=E.Name end elseif V=='Active'then if E and E:IsA'HopperBin'then if
not E.Active then I.Selected=false normalizeButton(I)end end elseif V==
'TextureId'then I.GearImage.Image=E.TextureId end end)t=false Spawn(function()
while backpackIsOpen()do wait(0.03)end for V=1,#B do if B[V]~='empty'then f.
Position=UDim2.new(0.5,-60,1,-108)if c then f.Visible=true h.Visible=true end
end end end)end function addToInventory(F)if not F:IsA'Tool'or not F:IsA
'HopperBin'then return end local G=nil for H=1,#A do if A[H]and A[H]==F then
return end if not A[H]then G=H end end if G then A[G]=F elseif#A<1 then A[1]=F
else A[#A+1]=F end end function removeFromInventory(F)for G=1,#A do if A[G]==F
then table.remove(A,G)A[G]=nil end end end local F,G=function()loadoutChildren=a
:GetChildren()for F=1,#loadoutChildren do if loadoutChildren[F]:IsA'Frame'then
loadoutChildren[F].BackgroundTransparency=0.5 local G=tonumber(string.sub(
loadoutChildren[F].Name,5))if G==0 then G=10 end if d.AbsoluteSize.Y<=320 then
loadoutChildren[F]:TweenPosition(UDim2.new(0,(G-1)*60,0,0),Enum.EasingDirection.
Out,Enum.EasingStyle.Quad,0.25,true)else loadoutChildren[F]:TweenPosition(UDim2.
new((G-1)/10,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)end
end end end,function()loadoutChildren=a:GetChildren()local F,G={},nil for H=1,#
loadoutChildren do if loadoutChildren[H]:IsA'Frame'then if#loadoutChildren[H]:
GetChildren()>0 then if loadoutChildren[H].Name=='Slot0'then G=loadoutChildren[H
]else table.insert(F,loadoutChildren[H])end end loadoutChildren[H].
BackgroundTransparency=1 end end if G then table.insert(F,G)end local H=(1-(#F*
0.1))/2 for I=1,#F do if d.AbsoluteSize.Y<=320 then H=(0.5-(#F*0.333)/2)F[I]:
TweenPosition(UDim2.new(H+(I-1)*0.33,0,0,0),Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,0.25,true)else F[I]:TweenPosition(UDim2.new(H+((I-1)*0.1),0,0,0
),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)end end end function
editLoadout()C=true if p then F()end end function readonlyLoadout()if not p then
G()end end function setupBackpackListener()if s then s:disconnect()s=nil end s=i
.Backpack.ChildAdded:connect(function(H)if not z then z=true if c then f.Visible
=true h.Visible=true end end E(H)addToInventory(H)end)end function
playerCharacterChildAdded(H)E(H,true)addToInventory(H)end function
activateLoadout()a.Visible=true end function deactivateLoadout()a.Visible=false
end function tabHandler(H)p=H if H then editLoadout()else readonlyLoadout()end
end function coreGuiChanged(H,I)if H==Enum.CoreGuiType.Backpack or H==Enum.
CoreGuiType.All then f.Visible=I h.Visible=I c=I if I then registerNumberKeys()
else unregisterNumberKeys()end end if H==Enum.CoreGuiType.Health or H==Enum.
CoreGuiType.All then setHealthBarVisible(game.Players.LocalPlayer.PlayerGui,I)
end end registerNumberKeys()pcall(function()coreGuiChanged(Enum.CoreGuiType.
Backpack,Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
coreGuiChanged(Enum.CoreGuiType.Health,Game.StarterGui:GetCoreGuiEnabled(Enum.
CoreGuiType.Health))Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)wait()waitForChild(i,'Backpack')waitForProperty(i,'Character')delay(1,
function()local H=i.Backpack:GetChildren()local I=math.min(10,#H)for J=1,I do if
c then f.Visible=true h.Visible=true end E(H[J],false)end setupBackpackListener(
)end)delay(2,function()if not C then if d.AbsoluteSize.Y<=320 then local H=a:
GetChildren()for I=1,#H do local J=tonumber(string.sub(H[I].Name,5,string.len(H[
I].Name)))if type(J)=='number'then H[I].Position=UDim2.new(0,(J-1)*60,0,0)end
end end end wait(0.25)end)i.ChildAdded:connect(function(H)if H:IsA'PlayerGui'
then moveHealthBar(H)end end)waitForProperty(i,'Character')for H,I in ipairs(i.
Character:GetChildren())do playerCharacterChildAdded(I)end r=i.Character.
ChildAdded:connect(function(J)playerCharacterChildAdded(J)end)waitForChild(i.
Character,'Humanoid')humanoidDiedCon=i.Character.Humanoid.Died:connect(function(
)if humanoidDiedCon then humanoidDiedCon:disconnect()humanoidDiedCon=nil end
deactivateLoadout()if s then s:disconnect()s=nil end C=false end)i.
CharacterRemoving:connect(function()for J=1,#B do if B[J]~='empty'then B[J].
Parent=nil B[J]='empty'end end end)i.CharacterAdded:connect(function()
waitForProperty(game.Players,'LocalPlayer')i=game.Players.LocalPlayer
waitForChild(i,'Backpack')delay(1,function()local J=i.Backpack:GetChildren()
local K=math.min(10,#J)for L=1,K do if c then f.Visible=true h.Visible=true end
E(J[L],false)end setupBackpackListener()end)activateLoadout()if r then r:
disconnect()r=nil end r=i.Character.ChildAdded:connect(function(J)E(J,true)end)
waitForChild(i.Character,'Humanoid')if g.Visible then m:Fire()end
humanoidDiedCon=i.Character.Humanoid.Died:connect(function()if c then f.Visible=
false h.Visible=false end z=false deactivateLoadout()if humanoidDiedCon then
humanoidDiedCon:disconnect()humanoidDiedCon=nil end if s then s:disconnect()s=
nil end end)waitForChild(i,'PlayerGui')moveHealthBar(i.PlayerGui)delay(2,
function()if not C then if d.AbsoluteSize.Y<=320 then local J=a:GetChildren()for
K=1,#J do local L=tonumber(string.sub(J[K].Name,5,string.len(J[K].Name)))if
type(L)=='number'then J[K].Position=UDim2.new(0,(L-1)*60,0,0)end end end end
wait(0.25)end)end)waitForChild(k,'SwapSlot')k.SwapSlot.Changed:connect(function(
)if k.SwapSlot.Value then local J=k.SwapSlot local K=J.Slot.Value if K==0 then K
=10 end if B[K]then reorganizeLoadout(B[K],false)end if J.GearButton.Value then
E(J.GearButton.Value.GearReference.Value,false,K)end k.SwapSlot.Value=false end
end)game:GetService'GuiService'.KeyPressed:connect(function(J)if
characterInWorkspace()then activateGear(J)end end)m.Event:connect(editLoadout)n.
Event:connect(G)o.Event:connect(function(J)tabHandler(J==b)end)