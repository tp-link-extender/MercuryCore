print'[Mercury]: Loaded corescript 53878057'if game.CoreGui.Version<3 then
return end local a a=function(b,c)while not b:FindFirstChild(c)do b.ChildAdded:
wait()end return b:FindFirstChild(c)end local b b=function(c,d)while not c[d]do
c.Changed:wait()end end local c,d,e,f=script.Parent,'gear',true,game:GetService
'CoreGui':FindFirstChild'RobloxGui'assert(f)local g=a(f,'ControlFrame')local h,i
=a(g,'BackpackButton'),a(f,'Backpack')a(f,'CurrentLoadout')a(f.CurrentLoadout,
'TempSlot')a(f.CurrentLoadout.TempSlot,'SlotNumber')a(c,'Background')local j,k=c
.Background,nil k=function()local l=false pcall(function()l=Game:GetService
'UserInputService'.TouchEnabled end)return l end local l l=function(m)a(m,
'HealthGUI')a(m['HealthGUI'],'tray')local n=m['HealthGUI']['tray']n.Position=
UDim2.new(0.5,-85,1,-26)end local m m=function(n,o)a(n,'HealthGUI')a(n[
'HealthGUI'],'tray')local p=n['HealthGUI']['tray']p.Visible=o end a(game,
'Players')b(game.Players,'LocalPlayer')local n=game.Players.LocalPlayer a(n,
'PlayerGui')Spawn(function()return l(n.PlayerGui)end)while not(n.Character~=nil)
do wait(0.03)end local o=a(n.Character,'Humanoid')o.Died:connect(function()h.
Visible=false end)a(game,'LocalBackpack')game.LocalBackpack:
SetOldSchoolBackpack(false)a(c.Parent,'Backpack')local p=c.Parent.Backpack local
q=a(p,'CoreScripts/BackpackScripts/BackpackManager')local r,s,t,u,v=a(q,
'BackpackOpenEvent'),a(q,'BackpackCloseEvent'),a(q,'TabClickedEvent'),true,10 if
f.AbsoluteSize.Y<=320 then v=4 end local w,x,y,z=nil,nil,false,1.18 local A,B,C,
D,E,F,G=UDim2.new(1*z,0,1*z,0),UDim2.new(1,0,1,0),true,0.5,false,{},{}for H=1,v
do G[H]='empty'end local H,I=false,nil I=function()if p then return p.Visible
end return false end local J,K K=function(L,M,N)if M~=nil then M:disconnect()end
if L==true and N then return J(N,false)end end local L L=function()for M=0,9 do
game:GetService'GuiService':AddKey(tostring(M))end end local M M=function()
return pcall(function()for N=0,9 do game:GetService'GuiService':RemoveKey(
tostring(N))end end)end local N N=function()if game.Players['LocalPlayer']and
game.Players.LocalPlayer['Character']and(game.Players.LocalPlayer.Character~=nil
)and(game.Players.LocalPlayer.Character.Parent~=nil)then return true end return
false end local O O=function(P)local Q for R=1,#G do if G[R]==P and(P.Parent~=
nil)then Q=R break end end if Q then do local R=G[Q]if R.GearReference.Value
then if R.GearReference.Value.Parent==game.Players.LocalPlayer.Character then R.
GearReference.Value.Parent=game.Players.LocalPlayer.Backpack end if R.
GearReference.Value:IsA'HopperBin'and R.GearReference.Value.Active then R.
GearReference.Value:Disable()R.GearReference.Value.Active=false end end end G[Q]
='empty'delay(0,function()return P:remove()end)return Spawn(function()while I()
do wait(0.03)end a(n,'Backpack')local R=true for S=1,#G do if G[S]~='empty'then
R=false end end if R then if#n.Backpack:GetChildren()<1 then h.Visible=false
else h.Position=UDim2.new(0.5,-60,1,-44)end j.Visible=false end end)end end
local P P=function(Q,R)local S if not R then for T=1,#G do if G[T]=='empty'then
S=T break end end if S==1 and G[1]~='empty'then Q:remove()return end else S=R
local T=1 for U=1,#G do if G[U]=='empty'then T=U break end end for U=T,S+1,-1 do
G[U]=G[U-1]do local V if U==10 then V='0'else V=U end G[U].SlotNumber.Text=V G[U
].SlotNumberDownShadow.Text=V G[U].SlotNumberUpShadow.Text=V end end end G[S]=Q
if S~=v then if type(tostring(S))=='string'then local T=tostring(S)Q.SlotNumber.
Text=T Q.SlotNumberDownShadow.Text=T Q.SlotNumberUpShadow.Text=T end else Q.
SlotNumber.Text='0'Q.SlotNumberDownShadow.Text='0'Q.SlotNumberUpShadow.Text='0'
end Q.Visible=true local T=Q.Kill.Changed:connect(function(T)return K(T,con,Q)
end)end J=function(Q,R,S,T)if R then P(Q,T)else O(Q)end if Q~='empty'then Q.
ZIndex=1 end end local Q Q=function(R,S)if R:FindFirstChild'RobloxBuildTool'then
return end if R:IsA'Tool'or R:IsA'HopperBin'then for T=1,#G do if G[T]~='empty'
and G[T].GearReference.Value==R then if not(S~=nil)then G[T].Kill.Value=true
return false elseif R.Parent==n.Character then G[T].Selected=true return true
elseif R.Parent==n.Backpack then if R:IsA'Tool'or R:IsA'HopperBin'then G[T].
Selected=false end return true end G[T].Kill.Value=true return false end end end
end local R R=function(S)local T=n.Character:GetChildren()for U=1,#T do if(T[U]:
IsA'Tool'or T[U]:IsA'HopperBin')and T[U]~=S then if T[U]:IsA'Tool'then T[U].
Parent=n.Backpack end if T[U]:IsA'HopperBin'then T[U]:Disable()end end end end
local S S=function(T,U)if not T then return end if T.Size.Y.Scale<=1 then return
end if T.Selected then return end if not T.Parent then return end local V=U if
not(V~=nil)or type(V)~='number'then V=D/5 end if T:FindFirstChild'Highlight'then
T.Highlight.Visible=false end if T:IsA'ImageButton'or T:IsA'TextButton'then T.
ZIndex=1 local W,X=-(B.X.Scale-T.Size.X.Scale)/2,-(B.Y.Scale-T.Size.Y.Scale)/2
return T:TweenSizeAndPosition(B,UDim2.new(T.Position.X.Scale+W,T.Position.X.
Offset,T.Position.Y.Scale+X,T.Position.Y.Offset),Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,V,C)end end local T T=function(U)if U.Size.Y.Scale>1 then
return end if not U.Parent then return end if not U.Selected then return end for
V=1,#G do if G[V]=='empty'then break end if G[V]~=U then S(G[V])end end if not C
then return end if U:FindFirstChild'Highlight'then U.Highlight.Visible=true end
if U:IsA'ImageButton'or U:IsA'TextButton'then U.ZIndex=5 local V,W=-(A.X.Scale-U
.Size.X.Scale)/2,-(A.Y.Scale-U.Size.Y.Scale)/2 return U:TweenSizeAndPosition(A,
UDim2.new(U.Position.X.Scale+V,U.Position.X.Offset,U.Position.Y.Scale+W,U.
Position.Y.Offset),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,D/5,C)end end
local U U=function(V,W)if not W then return end W:ToggleSelect()if G[V]=='empty'
then return end if not W.Active then G[V].Selected=false return S(G[V])else G[V]
.Selected=true return T(G[V])end end local V V=function(W)if not G[W]then return
end local X=G[W].GearReference.Value if not(X~=nil)then return end R(X)local Y=W
if W==0 then Y=10 end for Z=1,#G do if G[Z]and G[Z]~='empty'and Z~=Y then S(G[Z]
)do local _=G[Z]_.Selected=false if _.GearReference and _.GearReference.Value
and _.GearReference.Value:IsA'HopperBin'and _.GearReference.Value.Active then _.
GearReference.Value:ToggleSelect()end end end end if X:IsA'HopperBin'then return
U(W,X)else if X.Parent==n.Character then X.Parent=n.Backpack if G[W]~='empty'
then G[W].Selected=false return S(G[W])end else X.Parent=n.Character G[W].
Selected=true return T(G[W])end end end local W W=function(X)local Y if X=='0'
then Y=10 else Y=tonumber(X)end if not(Y~=nil)then return end if G[Y]~='empty'
then return V(Y)end end local X X=function()for Y=1,#G do if G[Y]=='empty'then
break end if G[Y]~=button then S(G[Y],0.1)end end end local Y Y=function()while
y do wait()end end local Z Z=function(_,aa,ab)if(_.x>aa.x and _.x<(aa.x+ab.x))or
(_.y>aa.y and _.y<(aa.y+ab.y))then return true end return false end local aa aa=
function(ab,_)local ac=_:GetChildren()if#ac==1 then if ac[1]:FindFirstChild
'SlotNumber'then local ad,ae=tonumber(ac[1].SlotNumber.Text),tonumber(ab.
SlotNumber.Text)if ad==0 then ad=10 end if ae==0 then ae=10 end G[ad]=ab G[ae]=
ac[1]ac[1].SlotNumber.Text=ab.SlotNumber.Text ac[1].SlotNumberDownShadow.Text=ab
.SlotNumber.Text ac[1].SlotNumberUpShadow.Text=ab.SlotNumber.Text local af=
string.sub(_.Name,5)ab.SlotNumber.Text=af ab.SlotNumberDownShadow.Text=af ab.
SlotNumberUpShadow.Text=af ab.Position=UDim2.new(ab.Position.X.Scale,0,ab.
Position.Y.Scale,0)ac[1].Position=UDim2.new(ac[1].Position.X.Scale,0,ac[1].
Position.Y.Scale,0)ac[1].Parent=ab.Parent ab.Parent=_ end else local ad=
tonumber(ab.SlotNumber.Text)if ad==0 then ad=10 end G[ad]='empty'local ae=string
.sub(_.Name,5)ab.SlotNumber.Text=ae ab.SlotNumberDownShadow.Text=ae ab.
SlotNumberUpShadow.Text=ae local af=tonumber(ab.SlotNumber.Text)if af==0 then af
=10 end G[af]=ab ab.Position=UDim2.new(ab.Position.X.Scale,0,ab.Position.Y.Scale
,0)ab.Parent=_ end end local ab ab=function(ac,ad,ae)local af,_=Vector2.new(ad,
ae),ac.Parent local ag=_.Parent:GetChildren()for ah=1,#ag do if ag[ah]:IsA
'Frame'and Z(af,ag[ah].AbsolutePosition,ag[ah].AbsoluteSize)then aa(ac,ag[ah])
return true end end if(ad<_.AbsolutePosition.x or ad>(_.AbsolutePosition.x+_.
AbsoluteSize.x))or(ae<_.AbsolutePosition.y or ae>(_.AbsolutePosition.y+_.
AbsoluteSize.y))then J(ac,false)return false else if dragBeginPos then ac.
Position=dragBeginPos end return-1 end end local ac ac=function(ad)for ae=1,#G
do if G[ae]=='empty'then break end do local af=G[ae]if af.GearReference.Value
and af.GearReference.Value~=ad then if af.GearReference.Value:IsA'HopperBin'then
af.GearReference.Value:Disable()elseif af.GearReference.Value:IsA'Tool'then af.
GearReference.Value.Parent=game.Players.LocalPlayer.Backpack end af.Selected=
false end end end end local ad ad=function(ae,af)if ae and ae:FindFirstChild
'ToolTipLabel'and ae.ToolTipLabel:IsA'TextLabel'and not k()then ae.ToolTipLabel.
Text=tostring(af)local ag=ae.ToolTipLabel.TextBounds.X+6 ae.ToolTipLabel.Size=
UDim2.new(0,ag,0,20)ae.ToolTipLabel.Position=UDim2.new(0.5,-ag/2,0,-30)ae.
ToolTipLabel.Visible=true end end local ae ae=function(af,ag)if af and af:
FindFirstChild'ToolTipLabel'and af.ToolTipLabel:IsA'TextLabel'then af.
ToolTipLabel.Visible=false end end local af af=function(ag)for ah=1,#F do if F[
ah]==ag then table.remove(F,ah)F[ah]=nil end end end local ag ag=function(ah,_,
ai,aj)Y()y=true if ah:FindFirstChild'RobloxBuildTool'then y=false return end if
not ah:IsA'Tool'and not ah:IsA'HopperBin'then y=false return end if not ai then
for ak=1,#G do if G[ak]~='empty'and G[ak].GearReference.Value==ah then y=false
return end end end local ak=c.TempSlot:clone()ak.Name=ah.Name ak.GearImage.Image
=ah.TextureId if ak.GearImage.Image==''then ak.GearText.Text=ah.Name end ak.
GearReference.Value=ah ak.MouseEnter:connect(function()if ak.GearReference and
ak.GearReference.Value['ToolTip']and ak.GearReference.Value.ToolTip~=''then
return ad(ak,ak.GearReference.Value.ToolTip)end end)ak.MouseLeave:connect(
function()if ak.GearReference and ak.GearReference.Value['ToolTip']and ak.
GearReference.Value.ToolTip~=''then return ae(ak,ak.GearReference.Value.ToolTip)
end end)ak.RobloxLocked=true local al=-1 if not ai then for am=1,#G do if G[am]
=='empty'then al=am break end end else al=ai end if al==-1 then y=false return
end local am=al%10 local an=c:FindFirstChild('Slot'..tostring(am))ak.Parent=an
if aj then local ao,ap=aj.AbsolutePosition,ak.AbsolutePosition local aq=ao-ap ak
.Position=UDim2.new(ak.Position.X.Scale,aq.x,ak.Position.Y.Scale,aq.y)ak.ZIndex=
4 end J(ak,(function()if ai then return true,_,ai else return true end end)())if
not(ak.Parent~=nil)then y=false return end if _ then ak.Selected=true ac(ah)
delay(D+0.01,function()if ak:FindFirstChild'GearReference'and((ak.GearReference.
Value:IsA'Tool'and ak.GearReference.Value.Parent==n.Character)or(ak.
GearReference.Value:IsA'HopperBin'and ak.GearReference.Value.Active==true))then
return T(ak)end end)end local ao,ap,aq,ar,as,at,au ap=ak.MouseButton1Click:
connect(function()if N()then if not ak.Draggable then return W(ak.SlotNumber.
Text)end end end)ar=ak.MouseEnter:connect(function()if p.Visible then ak.
Draggable=true end end)au=ak.DragBegin:connect(function(av)ao=av ak.ZIndex=7
local aw=ak:GetChildren()for ax=1,#aw do if aw[ax]:IsA'TextLabel'then if string.
find(aw[ax].Name,'Shadow')then aw[ax].ZIndex=8 else aw[ax].ZIndex=9 end elseif
aw[ax]:IsA'Frame'or aw[ax]:IsA'ImageLabel'then aw[ax].ZIndex=7 end end end)at=ak
.DragStopped:connect(function(av,aw)if ak.Selected then ak.ZIndex=4 else ak.
ZIndex=3 end local ax=ak:GetChildren()for ay=1,#ax do if ax[ay]:IsA'TextLabel'
then if string.find(ax[ay].Name,'Shadow')then ax[ay].ZIndex=3 else ax[ay].ZIndex
=4 end elseif ax[ay]:IsA'Frame'or ax[ay]:IsA'ImageLabel'then ax[ay].ZIndex=2 end
end return ab(ak,av,aw)end)as=ak.MouseLeave:connect(function()ak.Draggable=false
end)aq=ak.AncestryChanged:connect(function()if ak.Parent and ak.Parent.Parent==c
then return end if ap~=nil then ap:disconnect()end if aq~=nil then aq:
disconnect()end if ar~=nil then ar:disconnect()end if as~=nil then as:
disconnect()end if at~=nil then at:disconnect()end if au~=nil then return au:
disconnect()end return nil end)local av,aw av=ah.AncestryChanged:connect(
function(ax,ay)if not Q(ax,ay)then if av~=nil then av:disconnect()end if aw~=nil
then aw:disconnect()end return af(ah)elseif ay==game.Players.LocalPlayer.
Backpack then return S(ak)end end)aw=ah.Changed:connect(function(ax)if ax==
'Name'then if ak and ak.GearImage.Image==''then ak.GearText.Text=ah.Name end
elseif ax=='Active'then if ah and ah:IsA'HopperBin'then if not ah.Active then ak
.Selected=false return S(ak)end end elseif ax=='TextureId'then ak.GearImage.
Image=ah.TextureId end end)y=false return Spawn(function()while I()do wait(0.03)
end for ax=1,#G do if G[ax]~='empty'then h.Position=UDim2.new(0.5,-60,1,-108)if
e then h.Visible=true j.Visible=true end end end end)end local ah ah=function(ai
)if not ai:IsA'Tool'or not ai:IsA'HopperBin'then return end local aj for ak=1,#F
do if F[ak]and F[ak]==ai then return end if not F[ak]then aj=ak end end if aj
then F[aj]=ai elseif#F<1 then F[1]=ai else F[#F+1]=ai end end local ai ai=
function()local aj=c:GetChildren()for ak=1,#aj do if aj[ak]:IsA'Frame'then aj[ak
].BackgroundTransparency=0.5 local al=tonumber(string.sub(aj[ak].Name,5))if al==
0 then al=10 end if f.AbsoluteSize.Y<=320 then aj[ak]:TweenPosition(UDim2.new(0,
(al-1)*60,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)else aj[
ak]:TweenPosition(UDim2.new((al-1)/10,0,0,0),Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,0.25,true)end end end end local aj aj=function()local ak,al,am=
c:GetChildren(),{},nil for an=1,#ak do if ak[an]:IsA'Frame'then if#ak[an]:
GetChildren()>0 then if ak[an].Name=='Slot0'then am=ak[an]else table.insert(al,
ak[an])end end ak[an].BackgroundTransparency=1 end end if am then table.insert(
al,am)end local an=(1-(#al*0.1))/2 for ao=1,#al do if f.AbsoluteSize.Y<=320 then
an=0.5-(#al*0.333)/2 al[ao]:TweenPosition(UDim2.new(an+(ao-1)*0.33,0,0,0),Enum.
EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)else al[ao]:TweenPosition(
UDim2.new(an+((ao-1)*0.1),0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,
0.25,true)end end end local ak ak=function()H=true if u then return ai()end end
local al al=function()if not u then return aj()end end local am am=function()if
x~=nil then x:disconnect()end x=nil x=n.Backpack.ChildAdded:connect(function(an)
if not E then E=true if e then h.Visible=true j.Visible=true end end ag(an)
return ah(an)end)end local an an=function(ao)ag(ao,true)return ah(ao)end local
ao ao=function()c.Visible=true end local ap ap=function()c.Visible=false end
local aq aq=function(ar)u=ar if ar then return ak()else return al()end end local
ar ar=function(as,at)if as==Enum.CoreGuiType.Backpack or as==Enum.CoreGuiType.
All then h.Visible=at j.Visible=at e=at if at then L()else M()end end if as==
Enum.CoreGuiType.Health or as==Enum.CoreGuiType.All then return m(game.Players.
LocalPlayer.PlayerGui,at)end end L()pcall(function()ar(Enum.CoreGuiType.Backpack
,Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))ar(Enum.
CoreGuiType.Health,Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health))
return Game.StarterGui.CoreGuiChangedSignal:connect(ar)end)wait()a(n,'Backpack')
b(n,'Character')delay(1,function()local as=n.Backpack:GetChildren()local at=math
.min(10,#as)for au=1,at do if e then h.Visible=true j.Visible=true end ag(as[au]
,false)end return am()end)delay(2,function()if not H then if f.AbsoluteSize.Y<=
320 then local as=c:GetChildren()for at=1,#as do local au=tonumber(string.sub(as
[at].Name,5,string.len(as[at].Name)))if type(au)=='number'then as[at].Position=
UDim2.new(0,(au-1)*60,0,0)end end end end return wait(0.25)end)n.ChildAdded:
connect(function(as)if as:IsA'PlayerGui'then return l(as)end end)b(n,'Character'
)for as,at in ipairs(n.Character:GetChildren())do an(at)end w=n.Character.
ChildAdded:connect(function(au)return an(au)end)a(n.Character,'Humanoid')local
au=n.Character.Humanoid.Died:connect(function()do local au=humanoidDiedCon if au
~=nil then au:disconnect()end end humanoidDiedCon=nil ap()if x~=nil then x:
disconnect()end x=nil H=false end)n.CharacterRemoving:connect(function()for av=1
,#G do if G[av]~='empty'then G[av].Parent=nil G[av]='empty'end end end)n.
CharacterAdded:connect(function()b(game.Players,'LocalPlayer')n=game.Players.
LocalPlayer a(n,'Backpack')delay(1,function()local av=n.Backpack:GetChildren()
local aw=math.min(10,#av)for ax=1,aw do if e then h.Visible=true j.Visible=true
end ag(av[ax],false)end return am()end)ao()if w~=nil then w:disconnect()end w=n.
Character.ChildAdded:connect(function(av)return ag(av,true)end)a(n.Character,
'Humanoid')if i.Visible then r:Fire()end au=n.Character.Humanoid.Died:connect(
function()if e then h.Visible=false j.Visible=false end E=false ap()if au~=nil
then au:disconnect()end au=nil if x~=nil then x:disconnect()end x=nil end)a(n,
'PlayerGui')l(n.PlayerGui)return delay(2,function()if(not H)and(f.AbsoluteSize.Y
<=320)then local av=c:GetChildren()for aw=1,#av do local ax=tonumber(string.sub(
av[aw].Name,5,string.len(av[aw].Name)))if type(ax)=='number'then av[aw].Position
=UDim2.new(0,(ax-1)*60,0,0)end end end return wait(0.25)end)end)a(p,'SwapSlot')p
.SwapSlot.Changed:connect(function()if p.SwapSlot.Value then local av=p.SwapSlot
local aw=av.Slot.Value if aw==0 then aw=10 end if G[aw]then J(G[aw],false)end if
av.GearButton.Value then ag(av.GearButton.Value.GearReference.Value,false,aw)end
p.SwapSlot.Value=false end end)game:GetService'GuiService'.KeyPressed:connect(
function(av)if N()then return W(av)end end)r.Event:connect(ak)s.Event:connect(aj
)return t.Event:connect(function(av)return aq(av==d)end)