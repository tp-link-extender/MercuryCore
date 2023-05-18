print'[Mercury]: Loaded corescript 89449008'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b b=function(c,d)assert(c)assert(d)while not c:
FindFirstChild(d)do print('Waiting for ...',c,d)c.ChildAdded:wait()end return c:
FindFirstChild(d)end local c c=function(d,e)assert(d)assert(e)while not d[e]do d
.Changed:wait()end end local d d=function()local e=false pcall(function()e=Game:
GetService'UserInputService'.TouchEnabled end)return e end b(game,'Players')c(
game.Players,'LocalPlayer')local e,f,g=game.Players.LocalPlayer,LoadLibrary
'RbxGui'if not f then print'could not find RbxGui!'return end local h,i,j,k,l,m,
n,o,p,q,r,s='gear',script.Parent,{},{},false,false,{},{},nil,nil,nil,b(e,
'Backpack')b(i,'Tabs')b(i,'Gear')local t,u,v,w=b(i.Gear,'GearPreview'),b(i.Gear,
'GearGridScrollingArea'),b(i.Parent,'CurrentLoadout'),b(i.Gear,'GearGrid')local
x,y,z=b(w,'GearButton'),b(script.Parent,'SwapSlot'),b(script.Parent,
'CoreScripts/BackpackScripts/BackpackManager')local A,B,C,D,E,F,G,H,I,J=b(z,
'BackpackOpenEvent'),b(z,'BackpackCloseEvent'),b(z,'TabClickedEvent'),b(z,
'ResizeEvent'),b(z,'SearchRequestedEvent'),b(z,'BackpackReady'),f.
CreateScrollingFrame(nil,'grid',Vector2.new(6,6))G.Position=UDim2.new(0,0,0,30)G
.Size=UDim2.new(1,0,1,-30)G.Parent=i.Gear.GearGrid local K=a('Frame','ScrollBar'
,{BackgroundTransparency=0.9,BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=
0,Size=UDim2.new(0,17,1,-36),Position=UDim2.new(0,0,0,18),Parent=u})I.Position=
UDim2.new(0,0,1,-17)H.Parent=u I.Parent=u local L,M,N,O=f.CreateScrollingFrame()
L.Position=UDim2.new(0,0,0,0)L.Size=UDim2.new(1,0,1,0)L.Parent=i.Gear.
GearLoadouts.LoadoutsList local P=a('TextButton','LoadoutButton',{RobloxLocked=
true,Font=Enum.Font.ArialBold,FontSize=Enum.FontSize.Size14,Position=UDim2.new(0
,0,0,0),Size=UDim2.new(1,0,0,32),Style=Enum.ButtonStyle.RobloxButton,Text=
'Loadout #1',TextColor3=Color3.new(1,1,1),Parent=L})do local Q=P:clone()Q.Text=
'Loadout #2'Q.Parent=L end do local Q=P:clone()Q.Text='Loadout #3'Q.Parent=L end
do local Q=P:clone()Q.Text='Loadout #4'Q.Parent=L end a('Frame',
'ScrollBarLoadout',{BackgroundTransparency=0.9,BackgroundColor3=Color3.new(1,1,1
),BorderSizePixel=0,Size=UDim2.new(0,17,1,-36),Position=UDim2.new(0,0,0,18),
Parent=i.Gear.GearLoadouts.GearLoadoutsScrollingArea})N.Position=UDim2.new(0,0,1
,-17)M.Parent=i.Gear.GearLoadouts.GearLoadoutsScrollingArea N.Parent=i.Gear.
GearLoadouts.GearLoadoutsScrollingArea local Q Q=function(R,S)for T=1,#R do if R
[T]==S then table.remove(R,T)break end end end local R R=function(S)S.
RobloxLocked=true local T=S:GetChildren()if T then for U,V in ipairs(T)do R(V)
end end end local S S=function()t.GearImage.Image=''t.GearStats.GearName.Text=''
end local T T=function(U)U.TextColor3=Color3.new(1,1,1)U.BackgroundColor3=Color3
.new(0,0,0)end local U U=function(V)local W=v:GetChildren()for X=1,#W do if W[X]
:IsA'Frame'then local Y=W[X]:GetChildren()if#Y>0 and Y[1].GearReference.Value
and Y[1].GearReference.Value==V then return true end end end return false end
local V V=function()for W,X in pairs(j)do if k[X]then local Y,Z=nil,k[X]:
FindFirstChild'GearReference'if Z then Y=Z.Value end if(not Y)or U(Y)then k[X].
Active=false else k[X].Active=true end end end end local W W=function(X,Y)if not
y.Value then y.Slot.Value=X y.GearButton.Value=Y y.Value=true return V()end end
local X X=function(Y)Y.Parent=s return V()end local Y Y=function(Z,_)if type(Z.
Action)~='number'then return end local aa=Z.Action if aa==1 then X(_.Parent.
GearReference.Value)local ab=_.Parent local ac,ad,ae=ab.GearReference.Value,v:
GetChildren(),-1 for af=1,#ad do if ad[af]:IsA'Frame'then local ag=ad[af]:
GetChildren()if ag[1]and ag[1].GearReference.Value==ac then ae=ag[1].SlotNumber.
Text break end end end return W(ae,nil)end end local aa aa=function(ab)ab.
TextColor3=Color3.new(0,0,0)ab.BackgroundColor3=Color3.new(0.8,0.8,0.8)end local
ab ab=function()local ac=a('Frame','UnequipContextMenu',{Active=true,Size=UDim2.
new(0,115,0,70),Position=UDim2.new(0,-16,0,-16),BackgroundTransparency=1,Visible
=false})local ad,ae,af,ag=a('TextButton','UnequipContextMenuButton',{Text='',
Style=Enum.ButtonStyle.RobloxButtonDefault,ZIndex=8,Size=UDim2.new(1,0,1,-20),
Visible=true,Parent=ac}),12,{},{'Remove Hotkey'}for Z=1,#ag do local _={}_.Type=
'Button'_.Text=ag[Z]_.Action=Z _.DoIt=Y table.insert(af,_)end for Z,_ in ipairs(
af)do local ah=_ if ah.Type=='Button'then local ai=a('TextButton',
'UnequipContextButton'..tostring(Z),{BackgroundColor3=Color3.new(0,0,0),
BorderSizePixel=0,TextXAlignment=Enum.TextXAlignment.Left,Text=' '..tostring(_.
Text),Font=Enum.Font.Arial,FontSize=Enum.FontSize.Size14,Size=UDim2.new(1,8,0,ae
),Position=UDim2.new(0,0,0,ae*Z),TextColor3=Color3.new(1,1,1),ZIndex=9,Parent=ad
})if not d()then ai.MouseButton1Click:connect(function()if ai.Active and not ac.
Parent.Active then pcall(function()return ah.DoIt(ah,ac)end)m=false ac.Visible=
false T(ai)return S()end end)ai.MouseEnter:connect(function()if ai.Active and ac
.Parent.Active then return aa(ai)end end)ai.MouseLeave:connect(function()if ai.
Active and ac.Parent.Active then return T(ai)end end)end _.Button=ai _.Element=
ai elseif ah.Type=='Label'then local ai=a('Frame','ContextLabel'..tostring(Z),{
BackgroundTransparency=1,Size=UDim2.new(1,8,0,ae),a('TextLabel','Text1',{
BackgroundTransparency=1,BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,
TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.ArialBold,FontSize=Enum.
FontSize.Size14,Position=UDim2.new(0,0,0,0),Size=UDim2.new(0.5,0,1,0),TextColor3
=Color3.new(1,1,1),ZIndex=9})})ah.Label1=ai.Text1 if ah.GetText2 then ah.Label2=
a('TextLabel','Text2',{BackgroundTransparency=1,BackgroundColor3=Color3.new(1,1,
1),BorderSizePixel=0,TextXAlignment=Enum.TextXAlignment.Right,Font=Enum.Font.
Arial,FontSize=Enum.FontSize.Size14,Position=UDim2.new(0.5,0,0,0),Size=UDim2.
new(0.5,0,1,0),TextColor3=Color3.new(1,1,1),ZIndex=9,Parent=ai})end ai.Parent=ad
ah.Label=ai ah.Element=ai end end ac.ZIndex=4 ac.MouseLeave:connect(function()m=
false ac.Visible=false return S()end)R(ac)return ac end local ac ac=function()
local ad,ae=nil,v:GetChildren()for af=1,#ae do if ae[af]:IsA'Frame'and#ae[af]:
GetChildren()<=0 then local ag=tonumber(string.sub(ae[af].Name,5))if ag==0 then
ag=10 end if not ad or(ad>ag)then ad=ag end end end if ad==10 then ad=0 end
return ad end local ad ad=function(ae,af,ag)local ah=v:GetChildren()for ai=1,#ah
do if ah[ai]:IsA'Frame'and string.find(ah[ai].Name,'Slot')then if af>=ah[ai].
AbsolutePosition.x and af<=(ah[ai].AbsolutePosition.x+ah[ai].AbsoluteSize.x)then
if ag>=ah[ai].AbsolutePosition.y and ag<=(ah[ai].AbsolutePosition.y+ah[ai].
AbsoluteSize.y)then local Z=tonumber(string.sub(ah[ai].Name,5))W(Z,ae)return
true end end end end return false end local ae ae=function(af)if not m then t.
Visible=false t.GearImage.Image=af.Image t.GearStats.GearName.Text=af.
GearReference.Value.Name end end local af af=function(ag)if ag:FindFirstChild(
not ag.Active)then ag.UnequipContextMenu.Visible=true m=true end end local ag ag
=function()for ah,ai in pairs(j)do if not ai:FindFirstChild'RobloxBuildTool'then
if not k[ai]then local Z=x:clone()Z.Parent=w.ScrollingFrame Z.Visible=true Z.
Image=ai.TextureId if Z.Image==''then Z.GearText.Text=ai.Name end Z.
GearReference.Value=ai Z.Draggable=true k[ai]=Z if not d()then local _=ab()_.
Visible=false _.Parent=Z end local _ Z.DragBegin:connect(function(aj)b(Z,
'Background')Z['Background'].ZIndex=10 Z.ZIndex=10 _=aj end)Z.DragStopped:
connect(function(aj,ak)b(Z,'Background')Z['Background'].ZIndex=1 Z.ZIndex=2 if _
~=Z.Position then if not ad(Z,aj,ak)then Z:TweenPosition(_,Enum.EasingDirection.
Out,Enum.EasingStyle.Quad,0.5,true)Z.Draggable=false return delay(0.5,function()
Z.Draggable=true end)else Z.Position=_ end end end)local aj=tick()n[Z]=Z.
MouseEnter:connect(function()return ae(Z)end)o[Z]=Z.MouseButton1Click:connect(
function()local ak=tick()if Z.Active and(ak-aj)<0.5 then local al=ac()if al then
Z.ZIndex=1 W(al,Z)end else af(Z)end aj=ak end)end end end return J()end local ah
ah=function()local ai=0.75*(function()if t.AbsoluteSize.Y>t.AbsoluteSize.X then
return t.AbsoluteSize.X else return t.AbsoluteSize.Y end end)()b(t,'GearImage')t
.GearImage.Size=UDim2.new(0,ai,0,ai)t.GearImage.Position=UDim2.new(0,t.
AbsoluteSize.X/2-ai/2,0.75,-ai)return ag()end local ai ai=function(aj)if not aj:
IsA'Tool'and not aj:IsA'HopperBin'then return end if aj:FindFirstChild
'RobloxBuildTool'then return end for ak,al in pairs(j)do if al==aj then return
end end table.insert(j,aj)local Z=aj.Changed:connect(function(Z)if Z=='Name'and
k[aj]and k[aj].Image==''then k[aj].GearText.Text=aj.Name end end)local am=aj.
AncestryChanged:connect(function(_,am)local an for ao,ap in pairs(j)do if ap==aj
then an=ap break end end c(e,'Character')b(e,'Backpack')if aj.Parent~=e.Backpack
and aj.Parent~=e.Character then do local aq=ancestryCon if aq~=nil then aq:
disconnect()end end if Z~=nil then Z:disconnect()end for aq,ar in pairs(j)do if
ar==an then do local as=n[k[ar]]if as~=nil then as:disconnect()end end do local
as=o[k[ar]]if as~=nil then as:disconnect()end end k[ar].Parent=nil k[ar]=nil
break end end Q(j,an)ag()else ag()end return V()end)return ag()end local aj aj=
function(ak)for al,am in pairs(k)do am.Parent=nil end if ak then for an,ao in
pairs(ak)do ao.Parent=w.ScrollingFrame end end return J()end local ak ak=
function()for al,am in pairs(k)do am.Parent=w.ScrollingFrame end return J()end
local al al=function(am)local an,ao={},nil for ap=1,#am do if am[ap]:IsA'Frame'
and#am[ap]:GetChildren()>0 then if am[ap].Name=='Slot0'then ao=am[ap]else table.
insert(an,am[ap])end end end if ao then table.insert(an,ao)end local ap=(1-(#an*
0.1))/2 for aq=1,#an do an[aq]:TweenPosition(UDim2.new(ap+((aq-1)*0.1),0,0,0),
Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)end end local am am=
function(an)if an and an~=h then i.Gear.Visible=false return end i.Gear.Visible=
true V()ag()ah()return F:Invoke()end local an an=function(ao)if ao and ao~=h
then i.Gear.Visible=false return end i.Gear.Visible=false ag()ah()return F:
Invoke()end local ao ao=function(ap)if ap==h then return am(ap)else return an(ap
)end end local ap ap=function(aq,ar)if not aq:IsA'ImageButton'then return end
for as,Z in pairs(j)do if k[Z]then if aq:FindFirstChild(k[Z]:FindFirstChild
'GearReference')then if k[Z].GearReference.Value==aq.GearReference.Value then k[
Z].Active=ar break end end end end end local aq aq=function()if r~=nil then r:
disconnect()end r=game.Players.LocalPlayer.Backpack.ChildAdded:connect(function(
ar)return ai(ar)end)local ar=game.Players.LocalPlayer.Backpack:GetChildren()for
as=1,#ar do ai(ar[as])end if p~=nil then p:disconnect()end p=game.Players.
LocalPlayer.Character.ChildAdded:connect(function(as)ai(as)return V()end)if q~=
nil then q:disconnect()end q=game.Players.LocalPlayer.Character.ChildRemoved:
connect(function(as)return V()end)wait()return al(v:GetChildren())end local ar
ar=function()if p~=nil then p:disconnect()end if q~=nil then q:disconnect()end
if r~=nil then return r:disconnect()end return nil end local as as=function(Z)
return Z:gsub('^%s*(.-)%s*$','%1')end local Z Z=function(at)local au={}for av,aw
in pairs(j)do if k[aw]then local ax=as(string.lower(k[aw].GearReference.Value.
Name))for ay=1,#at do if string.match(ax,at[ay])then table.insert(au,k[aw])break
end end end end return au end local at at=function(au)if type(au)~='string'then
return end local av={}for aw in string.gmatch(au,'[^%s]+')do if string.len(aw)>0
then table.insert(av,aw)end end return av end local au au=function(av)if not i.
Gear.Visible then return end local aw,ax=at(av),nil if aw and(#aw>0)then ax=aw
else ax=nil end if not(aw~=nil)then ak()return end local ay=Z(ax)return aj(ay)
end local av av=function()while#k>0 do table.remove(k)end k={}while#j>0 do table
.remove(j)end j={}local aw=w.ScrollingFrame:GetChildren()for ax=1,#aw do aw[ax]:
remove()end end local aw aw=function(ax,ay)if ax==Enum.CoreGuiType.Backpack or
ax==Enum.CoreGuiType.All then if not ay then i.Gear.Visible=false end end end
local ax=e.Backpack:GetChildren()for ay=1,#ax do ai(ax[ay])end D.Event:connect(
function(ay)if l then return end l=true wait()ah()ag()l=false end)v.ChildAdded:
connect(function(ay)return ap(ay,false)end)v.ChildRemoved:connect(function(ay)
return ap(ay,true)end)v.DescendantAdded:connect(function(ay)if not i.Visible and
(ay:IsA'ImageButton'or ay:IsA'TextButton')then return al(v:GetChildren())end end
)v.DescendantRemoving:connect(function(ay)if not i.Visible and(ay:IsA
'ImageButton'or ay:IsA'TextButton')then wait()return al(v:GetChildren())end end)
w.MouseEnter:connect(function()return S()end)w.MouseLeave:connect(function()
return S()end)e.CharacterRemoving:connect(function()ar()return av()end)e.
CharacterAdded:connect(function()return aq()end)e.ChildAdded:connect(function(ay
)if ay:IsA'Backpack'then s=ay if r~=nil then r:disconnect()end r=game.Players.
LocalPlayer.Backpack.ChildAdded:connect(function(az)return ai(az)end)end end)y.
Changed:connect(function()if not y.Value then return V()end end)local ay=v:
GetChildren()for az=1,#ay do if ay[az]:IsA'Frame'and string.find(ay[az].Name,
'Slot')then ay[az].ChildRemoved:connect(function()return V()end)ay[az].
ChildAdded:connect(function()return V()end)end end pcall(function()aw(Enum.
CoreGuiType.Backpack,Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack
))return Game.StarterGui.CoreGuiChangedSignal:connect(aw)end)ah()ag()ay=v:
GetChildren()for az=1,#ay do ap(ay[az],false)end if not i.Visible then al(v:
GetChildren())end if not(p~=nil)and game.Players.LocalPlayer['Character']then
aq()end if not r then r=game.Players.LocalPlayer.Backpack.ChildAdded:connect(
function(az)return ai(az)end)end A.Event:connect(am)B.Event:connect(an)C.Event:
connect(ao)E.Event:connect(au)return O()