print'[Mercury]: Loaded corescript 38037565'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b,c,d=5,5,nil d=function(e,f)local g=e:
findFirstChild(f)if g then return g end while true do g=e.ChildAdded:wait()if g.
Name==f then return g end end end local e=script.Parent local f,g,h,i=d(e,
'Humanoid'),d(e,'Torso'),e:FindFirstChild'PlayerStats',Instance.new'BoolValue'i.
Name='InCharTag'local j=Instance.new'BoolValue'j.Name='RobloxBuildTool'if not(h
~=nil)then h=a('Configuration','PlayerStats',{Parent=e})end local k=h:
FindFirstChild'MaxHealth'if not(k~=nil)then k=a('NumberValue','MaxHealth',{Value
=100,Parent=h})end f.MaxHealth=k.Value f.Health=k.Value local l l=function()f.
MaxHealth=k.Value f.Health=k.Value end k.Changed:connect(l)local m=game.Players:
GetPlayerFromCharacter(script.Parent)local n=m.PlayerGui:FindFirstChild
'DamageOverTimeGui'if not(n~=nil)then n=a('BillboardGui','DamageOverTimeGui',{
Parent=m.PlayerGui,Adornee=script.Parent:FindFirstChild'Head',Active=true,size=
UDim2.new(b,0,c,0),StudsOffset=Vector3.new(0,2,0)})end print
'newHealth declarations finished'local o o=function(p)local q=a('TextLabel',{
Text=tostring(p),TextColor3=(function()if p>0 then return Color3.new(0,1,0)else
return Color3.new(1,0,1)end end)(),size=UDim2.new(1,0,1,0),Active=true,FontSize=
6,BackgroundTransparency=1,Parent=n})for r=1,10 do wait(0.1)q.TextTransparency=r
/10 q.Position=UDim2.new(0,0,0,-r*5)q.FontSize=6-r*0.6 end return q:remove()end
local p p=function()if k.Value>=0 then f.MaxHealth=k.Value print(f.MaxHealth)if
f.Health>f.MaxHealth then f.Health=f.MaxHealth end end end k.Changed:connect(p)
local q=a('Fire','FireEffect',{Heat=0.1,Size=3,Enabled=false})while true do
local r,s=wait(1),f.Health if s>0 then local t=0 if h then local u,v,w,x,y=h:
FindFirstChild'Regen',h:FindFirstChild'Poison',h:FindFirstChild'Ice',h:
FindFirstChild'Fire',h:FindFirstChild'Stun'if u then t=t+u.Value.X if u.Value.Y
>=0 then u.Value=Vector3.new(u.Value.X+u.Value.Z,u.Value.Y-r,u.Value.Z)elseif u.
Value.Y==-1 then u.Value=Vector3.new(u.Value.X+u.Value.Z,-1,u.Value.Z)else u:
remove()end end if v then t=t-v.Value.X if v.Value.Y>=0 then v.Value=Vector3.
new(v.Value.X+v.Value.Z,v.Value.Y-r,v.Value.Z)elseif v.Value.Y==-1 then v.Value=
Vector3.new(v.Value.X+v.Value.Z,-1,v.Value.Z)else v:remove()end end if w then t=
t-w.Value.X if w.Value.Y>=0 then w.Value=Vector3.new(w.Value.X,w.Value.Y-r,w.
Value.Z)else w:remove()end end if x then q.Enabled=true q.Parent=e.Torso t=t-x.
Value.X if x.Value.Y>=0 then x.Value=Vector3.new(x.Value.X,x.Value.Y-r,x.Value.Z
)else x:remove()q.Enabled=false q.Parent=nil end end if y then local z if y.
Value>0 then g.Anchored=true local A=script.Parent:GetChildren()z=game.Players:
GetPlayerFromCharacter(script.Parent).Backpack:GetChildren()for B=1,#A do if A[B
].className=='Tool'then i:Clone().Parent=A[B]print(z)table.insert(z,A[B])end end
for B=1,#z do if not(z[B]:FindFirstChild'RobloxBuildTool'~=nil)then j:Clone().
Parent=z[B]z[B].Parent=game.Lighting end end wait(0.2)for B=1,#z do z[B].Parent=
game.Players:GetPlayerFromCharacter(script.Parent).Backpack end y.Value=y.Value-
r else g.Anchored=false for A=1,#z do local B=z[A]:FindFirstChild
'RobloxBuildTool'if B then B:Remove()end z[A].Parent=game.Lighting end wait(0.2)
for A=1,#z do local B=z[A]:FindFirstChild'InCharTag'if B then B:Remove()z[A].
Parent=script.Parent else z[A].Parent=game.Players:GetPlayerFromCharacter(script
.Parent).Backpack end end y:Remove()end end if t~=0 then coroutine.resume(
coroutine.create(o),t)end end s=f.Health+t*r if s*1.01<f.MaxHealth then f.Health
=s elseif t>0 then f.Health=f.MaxHealth end end end