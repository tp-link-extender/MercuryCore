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
'CoreScripts/BackpackScripts/BackpackManager')local m,n,o,p,q,r=waitForChild(l,
'BackpackOpenEvent'),waitForChild(l,'BackpackCloseEvent'),waitForChild(l,
'TabClickedEvent'),waitForChild(l,'ResizeEvent'),true,10 if d.AbsoluteSize.Y<=
320 then r=4 end local s,t,u,v=nil,nil,false,1.18 local w,x,y,z,A,B,C=UDim2.new(
1*v,0,1*v,0),UDim2.new(1,0,1,0),true,0.5,false,{},{}for D=1,r do C[D]='empty'end
local D=false local function backpackIsOpen()if k then return k.Visible end
return false end local function kill(E,F,G)if F then F:disconnect()end if E==
true and G then reorganizeLoadout(G,false)end end function registerNumberKeys()
for E=0,9 do game:GetService'GuiService':AddKey(tostring(E))end end function
unregisterNumberKeys()pcall(function()for E=0,9 do game:GetService'GuiService':
RemoveKey(tostring(E))end end)end function characterInWorkspace()if game.Players
['LocalPlayer']then if game.Players.LocalPlayer['Character']then if game.Players
.LocalPlayer.Character~=nil then if game.Players.LocalPlayer.Character.Parent~=
nil then return true end end end end return false end function removeGear(E)
local F=nil for G=1,#C do if C[G]==E and E.Parent~=nil then F=G break end end if
F then if C[F].GearReference.Value then if C[F].GearReference.Value.Parent==game
.Players.LocalPlayer.Character then C[F].GearReference.Value.Parent=game.Players
.LocalPlayer.Backpack end if C[F].GearReference.Value:IsA'HopperBin'and C[F].
GearReference.Value.Active then C[F].GearReference.Value:Disable()C[F].
GearReference.Value.Active=false end end C[F]='empty'local G,H=E.Size.X.Scale/2,
E.Size.Y.Scale/2 delay(0,function()E:remove()end)Spawn(function()while
backpackIsOpen()do wait(0.03)end waitForChild(i,'Backpack')local I=true for J=1,
#C do if C[J]~='empty'then I=false end end if I then if#i.Backpack:GetChildren()
<1 then f.Visible=false else f.Position=UDim2.new(0.5,-60,1,-44)end h.Visible=
false end end)end end function insertGear(E,F)local G=nil if not F then for H=1,
#C do if C[H]=='empty'then G=H break end end if G==1 and C[1]~='empty'then E:
remove()return end else G=F local H=1 for I=1,#C do if C[I]=='empty'then H=I
break end end for I=H,G+1,-1 do C[I]=C[I-1]if I==10 then C[I].SlotNumber.Text=
'0'C[I].SlotNumberDownShadow.Text='0'C[I].SlotNumberUpShadow.Text='0'else C[I].
SlotNumber.Text=I C[I].SlotNumberDownShadow.Text=I C[I].SlotNumberUpShadow.Text=
I end end end C[G]=E if G~=r then if type(tostring(G))=='string'then local H=
tostring(G)E.SlotNumber.Text=H E.SlotNumberDownShadow.Text=H E.
SlotNumberUpShadow.Text=H end else E.SlotNumber.Text='0'E.SlotNumberDownShadow.
Text='0'E.SlotNumberUpShadow.Text='0'end E.Visible=true local H=nil H=E.Kill.
Changed:connect(function(I)kill(I,H,E)end)end function reorganizeLoadout(E,F,G,H
)if F then insertGear(E,H)else removeGear(E)end if E~='empty'then E.ZIndex=1 end
end function checkToolAncestry(E,F)if E:FindFirstChild'RobloxBuildTool'then
return end if E:IsA'Tool'or E:IsA'HopperBin'then for G=1,#C do if C[G]~='empty'
and C[G].GearReference.Value==E then if F==nil then C[G].Kill.Value=true return
false elseif E.Parent==i.Character then C[G].Selected=true return true elseif E.
Parent==i.Backpack then if E:IsA'Tool'or E:IsA'HopperBin'then C[G].Selected=
false end return true else C[G].Kill.Value=true return false end return true end
end end end function removeAllEquippedGear(E)local F=i.Character:GetChildren()
for G=1,#F do if(F[G]:IsA'Tool'or F[G]:IsA'HopperBin')and F[G]~=E then if F[G]:
IsA'Tool'then F[G].Parent=i.Backpack end if F[G]:IsA'HopperBin'then F[G]:
Disable()end end end end function hopperBinSwitcher(E,F)if not F then return end
F:ToggleSelect()if C[E]=='empty'then return end if not F.Active then C[E].
Selected=false normalizeButton(C[E])else C[E].Selected=true enlargeButton(C[E])
end end function toolSwitcher(E)if not C[E]then return end local F=C[E].
GearReference.Value if F==nil then return end removeAllEquippedGear(F)local G=E
if E==0 then G=10 end for H=1,#C do if C[H]and C[H]~='empty'and H~=G then
normalizeButton(C[H])C[H].Selected=false if C[H].GearReference and C[H].
GearReference.Value and C[H].GearReference.Value:IsA'HopperBin'and C[H].
GearReference.Value.Active then C[H].GearReference.Value:ToggleSelect()end end
end if F:IsA'HopperBin'then hopperBinSwitcher(E,F)else if F.Parent==i.Character
then F.Parent=i.Backpack if C[E]~='empty'then C[E].Selected=false
normalizeButton(C[E])end else F.Parent=i.Character C[E].Selected=true
enlargeButton(C[E])end end end function activateGear(E)local F=nil if E=='0'then
F=10 else F=tonumber(E)end if F==nil then return end if C[F]~='empty'then
toolSwitcher(F)end end enlargeButton=function(E)if E.Size.Y.Scale>1 then return
end if not E.Parent then return end if not E.Selected then return end for F=1,#C
do if C[F]=='empty'then break end if C[F]~=E then normalizeButton(C[F])end end
if not y then return end if E:FindFirstChild'Highlight'then E.Highlight.Visible=
true end if E:IsA'ImageButton'or E:IsA'TextButton'then E.ZIndex=5 local F,G=-(w.
X.Scale-E.Size.X.Scale)/2,-(w.Y.Scale-E.Size.Y.Scale)/2 E:TweenSizeAndPosition(w
,UDim2.new(E.Position.X.Scale+F,E.Position.X.Offset,E.Position.Y.Scale+G,E.
Position.Y.Offset),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,z/5,y)end end
normalizeAllButtons=function()for E=1,#C do if C[E]=='empty'then break end if C[
E]~=button then normalizeButton(C[E],0.1)end end end normalizeButton=function(E,
F)if not E then return end if E.Size.Y.Scale<=1 then return end if E.Selected
then return end if not E.Parent then return end local G=F if G==nil or type(G)~=
'number'then G=z/5 end if E:FindFirstChild'Highlight'then E.Highlight.Visible=
false end if E:IsA'ImageButton'or E:IsA'TextButton'then E.ZIndex=1 local H,I,J=1
/v,-(x.X.Scale-E.Size.X.Scale)/2,-(x.Y.Scale-E.Size.Y.Scale)/2 E:
TweenSizeAndPosition(x,UDim2.new(E.Position.X.Scale+I,E.Position.X.Offset,E.
Position.Y.Scale+J,E.Position.Y.Offset),Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,G,y)end end local E=function()while u do wait()end end function
pointInRectangle(F,G,H)if F.x>G.x and F.x<(G.x+H.x)then if F.y>G.y and F.y<(G.y+
H.y)then return true end end return false end function swapGear(F,G)local H=G:
GetChildren()if#H==1 then if H[1]:FindFirstChild'SlotNumber'then local I,J=
tonumber(H[1].SlotNumber.Text),tonumber(F.SlotNumber.Text)if I==0 then I=10 end
if J==0 then J=10 end C[I]=F C[J]=H[1]H[1].SlotNumber.Text=F.SlotNumber.Text H[1
].SlotNumberDownShadow.Text=F.SlotNumber.Text H[1].SlotNumberUpShadow.Text=F.
SlotNumber.Text local K=string.sub(G.Name,5)F.SlotNumber.Text=K F.
SlotNumberDownShadow.Text=K F.SlotNumberUpShadow.Text=K F.Position=UDim2.new(F.
Position.X.Scale,0,F.Position.Y.Scale,0)H[1].Position=UDim2.new(H[1].Position.X.
Scale,0,H[1].Position.Y.Scale,0)H[1].Parent=F.Parent F.Parent=G end else local I
=tonumber(F.SlotNumber.Text)if I==0 then I=10 end C[I]='empty'local J=string.
sub(G.Name,5)F.SlotNumber.Text=J F.SlotNumberDownShadow.Text=J F.
SlotNumberUpShadow.Text=J local K=tonumber(F.SlotNumber.Text)if K==0 then K=10
end C[K]=F F.Position=UDim2.new(F.Position.X.Scale,0,F.Position.Y.Scale,0)F.
Parent=G end end function resolveDrag(F,G,H)local I,J=Vector2.new(G,H),F.Parent
local K=J.Parent:GetChildren()for L=1,#K do if K[L]:IsA'Frame'then if
pointInRectangle(I,K[L].AbsolutePosition,K[L].AbsoluteSize)then swapGear(F,K[L])
return true end end end if G<J.AbsolutePosition.x or G>(J.AbsolutePosition.x+J.
AbsoluteSize.x)then reorganizeLoadout(F,false)return false elseif H<J.
AbsolutePosition.y or H>(J.AbsolutePosition.y+J.AbsoluteSize.y)then
reorganizeLoadout(F,false)return false else if dragBeginPos then F.Position=
dragBeginPos end return-1 end end function unequipAllItems(F)for G=1,#C do if C[
G]=='empty'then break end if C[G].GearReference.Value and C[G].GearReference.
Value~=F then if C[G].GearReference.Value:IsA'HopperBin'then C[G].GearReference.
Value:Disable()elseif C[G].GearReference.Value:IsA'Tool'then C[G].GearReference.
Value.Parent=game.Players.LocalPlayer.Backpack end C[G].Selected=false end end
end function showToolTip(F,G)if F and F:FindFirstChild'ToolTipLabel'and F.
ToolTipLabel:IsA'TextLabel'and not IsTouchDevice()then F.ToolTipLabel.Text=
tostring(G)local H=F.ToolTipLabel.TextBounds.X+6 F.ToolTipLabel.Size=UDim2.new(0
,H,0,20)F.ToolTipLabel.Position=UDim2.new(0.5,-H/2,0,-30)F.ToolTipLabel.Visible=
true end end function hideToolTip(F,G)if F and F:FindFirstChild'ToolTipLabel'and
F.ToolTipLabel:IsA'TextLabel'then F.ToolTipLabel.Visible=false end end local F=
function(F,G,H,I)E()u=true if F:FindFirstChild'RobloxBuildTool'then u=false
return end if not F:IsA'Tool'then if not F:IsA'HopperBin'then u=false return end
end if not H then for J=1,#C do if C[J]~='empty'and C[J].GearReference.Value==F
then u=false return end end end local J=a.TempSlot:clone()J.Name=F.Name J.
GearImage.Image=F.TextureId if J.GearImage.Image==''then J.GearText.Text=F.Name
end J.GearReference.Value=F J.MouseEnter:connect(function()if J.GearReference
and J.GearReference.Value['ToolTip']and J.GearReference.Value.ToolTip~=''then
showToolTip(J,J.GearReference.Value.ToolTip)end end)J.MouseLeave:connect(
function()if J.GearReference and J.GearReference.Value['ToolTip']and J.
GearReference.Value.ToolTip~=''then hideToolTip(J,J.GearReference.Value.ToolTip)
end end)J.RobloxLocked=true local K=-1 if not H then for L=1,#C do if C[L]==
'empty'then K=L break end end else K=H end if K==-1 then u=false return end
local L=K%10 local M=a:FindFirstChild('Slot'..tostring(L))J.Parent=M if I then
local N,O=I.AbsolutePosition,J.AbsolutePosition local P=N-O J.Position=UDim2.
new(J.Position.X.Scale,P.x,J.Position.Y.Scale,P.y)J.ZIndex=4 end if H then
reorganizeLoadout(J,true,G,H)else reorganizeLoadout(J,true)end if J.Parent==nil
then u=false return end if G then J.Selected=true unequipAllItems(F)delay(z+0.01
,function()if J:FindFirstChild'GearReference'and((J.GearReference.Value:IsA
'Tool'and J.GearReference.Value.Parent==i.Character)or(J.GearReference.Value:IsA
'HopperBin'and J.GearReference.Value.Active==true))then enlargeButton(J)end end)
end local N,O,P,Q,R,S,T=nil,nil O=J.MouseButton1Click:connect(function()if
characterInWorkspace()then if not J.Draggable then activateGear(J.SlotNumber.
Text)end end end)Q=J.MouseEnter:connect(function()if k.Visible then J.Draggable=
true end end)T=J.DragBegin:connect(function(U)N=U J.ZIndex=7 local V=J:
GetChildren()for W=1,#V do if V[W]:IsA'TextLabel'then if string.find(V[W].Name,
'Shadow')then V[W].ZIndex=8 else V[W].ZIndex=9 end elseif V[W]:IsA'Frame'or V[W]
:IsA'ImageLabel'then V[W].ZIndex=7 end end end)S=J.DragStopped:connect(function(
U,V)if J.Selected then J.ZIndex=4 else J.ZIndex=3 end local W=J:GetChildren()for
X=1,#W do if W[X]:IsA'TextLabel'then if string.find(W[X].Name,'Shadow')then W[X]
.ZIndex=3 else W[X].ZIndex=4 end elseif W[X]:IsA'Frame'or W[X]:IsA'ImageLabel'
then W[X].ZIndex=2 end end resolveDrag(J,U,V)end)R=J.MouseLeave:connect(function
()J.Draggable=false end)P=J.AncestryChanged:connect(function()if J.Parent and J.
Parent.Parent==a then return end if O then O:disconnect()end if P then P:
disconnect()end if Q then Q:disconnect()end if R then R:disconnect()end if S
then S:disconnect()end if T then T:disconnect()end end)local U,V=nil,nil U=F.
AncestryChanged:connect(function(W,X)if not checkToolAncestry(W,X)then if U then
U:disconnect()end if V then V:disconnect()end removeFromInventory(F)elseif X==
game.Players.LocalPlayer.Backpack then normalizeButton(J)end end)V=F.Changed:
connect(function(W)if W=='Name'then if J and J.GearImage.Image==''then J.
GearText.Text=F.Name end elseif W=='Active'then if F and F:IsA'HopperBin'then if
not F.Active then J.Selected=false normalizeButton(J)end end elseif W==
'TextureId'then J.GearImage.Image=F.TextureId end end)u=false Spawn(function()
while backpackIsOpen()do wait(0.03)end for W=1,#C do if C[W]~='empty'then f.
Position=UDim2.new(0.5,-60,1,-108)if c then f.Visible=true h.Visible=true end
end end end)end function addToInventory(G)if not G:IsA'Tool'or not G:IsA
'HopperBin'then return end local H=nil for I=1,#B do if B[I]and B[I]==G then
return end if not B[I]then H=I end end if H then B[H]=G elseif#B<1 then B[1]=G
else B[#B+1]=G end end function removeFromInventory(G)for H=1,#B do if B[H]==G
then table.remove(B,H)B[H]=nil end end end local G,H=function()loadoutChildren=a
:GetChildren()for G=1,#loadoutChildren do if loadoutChildren[G]:IsA'Frame'then
loadoutChildren[G].BackgroundTransparency=0.5 local H=tonumber(string.sub(
loadoutChildren[G].Name,5))if H==0 then H=10 end if d.AbsoluteSize.Y<=320 then
loadoutChildren[G]:TweenPosition(UDim2.new(0,(H-1)*60,0,0),Enum.EasingDirection.
Out,Enum.EasingStyle.Quad,0.25,true)else loadoutChildren[G]:TweenPosition(UDim2.
new((H-1)/10,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)end
end end end,function()loadoutChildren=a:GetChildren()local G,H={},nil for I=1,#
loadoutChildren do if loadoutChildren[I]:IsA'Frame'then if#loadoutChildren[I]:
GetChildren()>0 then if loadoutChildren[I].Name=='Slot0'then H=loadoutChildren[I
]else table.insert(G,loadoutChildren[I])end end loadoutChildren[I].
BackgroundTransparency=1 end end if H then table.insert(G,H)end local I=(1-(#G*
0.1))/2 for J=1,#G do if d.AbsoluteSize.Y<=320 then I=(0.5-(#G*0.333)/2)G[J]:
TweenPosition(UDim2.new(I+(J-1)*0.33,0,0,0),Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,0.25,true)else G[J]:TweenPosition(UDim2.new(I+((J-1)*0.1),0,0,0
),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)end end end function
editLoadout()D=true if q then G()end end function readonlyLoadout()if not q then
H()end end function setupBackpackListener()if t then t:disconnect()t=nil end t=i
.Backpack.ChildAdded:connect(function(I)if not A then A=true if c then f.Visible
=true h.Visible=true end end F(I)addToInventory(I)end)end function
playerCharacterChildAdded(I)F(I,true)addToInventory(I)end function
activateLoadout()a.Visible=true end function deactivateLoadout()a.Visible=false
end function tabHandler(I)q=I if I then editLoadout()else readonlyLoadout()end
end function coreGuiChanged(I,J)if I==Enum.CoreGuiType.Backpack or I==Enum.
CoreGuiType.All then f.Visible=J h.Visible=J c=J if J then registerNumberKeys()
else unregisterNumberKeys()end end if I==Enum.CoreGuiType.Health or I==Enum.
CoreGuiType.All then setHealthBarVisible(game.Players.LocalPlayer.PlayerGui,J)
end end registerNumberKeys()pcall(function()coreGuiChanged(Enum.CoreGuiType.
Backpack,Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
coreGuiChanged(Enum.CoreGuiType.Health,Game.StarterGui:GetCoreGuiEnabled(Enum.
CoreGuiType.Health))Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)wait()waitForChild(i,'Backpack')waitForProperty(i,'Character')delay(1,
function()local I=i.Backpack:GetChildren()local J=math.min(10,#I)for K=1,J do if
c then f.Visible=true h.Visible=true end F(I[K],false)end setupBackpackListener(
)end)delay(2,function()if not D then if d.AbsoluteSize.Y<=320 then local I=a:
GetChildren()for J=1,#I do local K=tonumber(string.sub(I[J].Name,5,string.len(I[
J].Name)))if type(K)=='number'then I[J].Position=UDim2.new(0,(K-1)*60,0,0)end
end end end wait(0.25)end)i.ChildAdded:connect(function(I)if I:IsA'PlayerGui'
then moveHealthBar(I)end end)waitForProperty(i,'Character')for I,J in ipairs(i.
Character:GetChildren())do playerCharacterChildAdded(J)end s=i.Character.
ChildAdded:connect(function(K)playerCharacterChildAdded(K)end)waitForChild(i.
Character,'Humanoid')humanoidDiedCon=i.Character.Humanoid.Died:connect(function(
)if humanoidDiedCon then humanoidDiedCon:disconnect()humanoidDiedCon=nil end
deactivateLoadout()if t then t:disconnect()t=nil end D=false end)i.
CharacterRemoving:connect(function()for K=1,#C do if C[K]~='empty'then C[K].
Parent=nil C[K]='empty'end end end)i.CharacterAdded:connect(function()
waitForProperty(game.Players,'LocalPlayer')i=game.Players.LocalPlayer
waitForChild(i,'Backpack')delay(1,function()local K=i.Backpack:GetChildren()
local L=math.min(10,#K)for M=1,L do if c then f.Visible=true h.Visible=true end
F(K[M],false)end setupBackpackListener()end)activateLoadout()if s then s:
disconnect()s=nil end s=i.Character.ChildAdded:connect(function(K)F(K,true)end)
waitForChild(i.Character,'Humanoid')if g.Visible then m:Fire()end
humanoidDiedCon=i.Character.Humanoid.Died:connect(function()if c then f.Visible=
false h.Visible=false end A=false deactivateLoadout()if humanoidDiedCon then
humanoidDiedCon:disconnect()humanoidDiedCon=nil end if t then t:disconnect()t=
nil end end)waitForChild(i,'PlayerGui')moveHealthBar(i.PlayerGui)delay(2,
function()if not D then if d.AbsoluteSize.Y<=320 then local K=a:GetChildren()for
L=1,#K do local M=tonumber(string.sub(K[L].Name,5,string.len(K[L].Name)))if
type(M)=='number'then K[L].Position=UDim2.new(0,(M-1)*60,0,0)end end end end
wait(0.25)end)end)waitForChild(k,'SwapSlot')k.SwapSlot.Changed:connect(function(
)if k.SwapSlot.Value then local K=k.SwapSlot local L=K.Slot.Value if L==0 then L
=10 end if C[L]then reorganizeLoadout(C[L],false)end if K.GearButton.Value then
F(K.GearButton.Value.GearReference.Value,false,L)end k.SwapSlot.Value=false end
end)game:GetService'GuiService'.KeyPressed:connect(function(K)if
characterInWorkspace()then activateGear(K)end end)m.Event:connect(editLoadout)n.
Event:connect(H)o.Event:connect(function(K)tabHandler(K==b)end)