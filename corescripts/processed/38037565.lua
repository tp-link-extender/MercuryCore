local a,b=5,5 function waitForChild(c,d)local e=c:findFirstChild(d)if e then
return e end while true do e=c.ChildAdded:wait()if e.Name==d then return e end
end end local c=script.Parent local d,e,f,g=waitForChild(c,'Humanoid'),
waitForChild(c,'Torso'),c:FindFirstChild'PlayerStats',Instance.new'BoolValue'g.
Name='InCharTag'local h=Instance.new'BoolValue'h.Name='RobloxBuildTool'local i,j
if f==nil then f=Instance.new'Configuration'f.Parent=c f.Name='PlayerStats'end
local k=f:FindFirstChild'MaxHealth'if k==nil then k=Instance.new'NumberValue'k.
Parent=f k.Value=100 k.Name='MaxHealth'end d.MaxHealth=k.Value d.Health=k.Value
function onMaxHealthChange()d.MaxHealth=k.Value d.Health=k.Value end k.Changed:
connect(onMaxHealthChange)local l=game.Players:GetPlayerFromCharacter(script.
Parent)local m=l.PlayerGui:FindFirstChild'DamageOverTimeGui'if m==nil then m=
Instance.new'BillboardGui'm.Name='DamageOverTimeGui'm.Parent=l.PlayerGui m.
Adornee=script.Parent:FindFirstChild'Head'm.Active=true m.size=UDim2.new(a,0,b,0
)m.StudsOffset=Vector3.new(0,2,0)end print'newHealth declarations finished'
function billboardHealthChange(n)local o=Instance.new'TextLabel'if n>0 then o.
Text=tostring(n)o.TextColor3=Color3.new(0,1,0)else o.Text=tostring(n)o.
TextColor3=Color3.new(1,0,1)end o.size=UDim2.new(1,0,1,0)o.Active=true o.
FontSize=6 o.BackgroundTransparency=1 o.Parent=m for p=1,10 do wait(0.1)o.
TextTransparency=p/10 o.Position=UDim2.new(0,0,0,-p*5)o.FontSize=6-p*0.6 end o:
remove()end function setMaxHealth()if k.Value>=0 then d.MaxHealth=k.Value print(
d.MaxHealth)if d.Health>d.MaxHealth then d.Health=d.MaxHealth end end end k.
Changed:connect(setMaxHealth)local n=Instance.new'Fire'n.Heat=0.1 n.Size=3 n.
Name='FireEffect'n.Enabled=false while true do local o,p=wait(1),d.Health if p>0
then local q=0 if f then local r,s,t,u,v=f:FindFirstChild'Regen',f:
FindFirstChild'Poison',f:FindFirstChild'Ice',f:FindFirstChild'Fire',f:
FindFirstChild'Stun'if r then q=q+r.Value.X if r.Value.Y>=0 then r.Value=Vector3
.new(r.Value.X+r.Value.Z,r.Value.Y-o,r.Value.Z)elseif r.Value.Y==-1 then r.Value
=Vector3.new(r.Value.X+r.Value.Z,-1,r.Value.Z)else r:remove()end end if s then q
=q-s.Value.X if s.Value.Y>=0 then s.Value=Vector3.new(s.Value.X+s.Value.Z,s.
Value.Y-o,s.Value.Z)elseif s.Value.Y==-1 then s.Value=Vector3.new(s.Value.X+s.
Value.Z,-1,s.Value.Z)else s:remove()end end if t then q=q-t.Value.X if t.Value.Y
>=0 then t.Value=Vector3.new(t.Value.X,t.Value.Y-o,t.Value.Z)else t:remove()end
end if u then n.Enabled=true n.Parent=c.Torso q=q-u.Value.X if u.Value.Y>=0 then
u.Value=Vector3.new(u.Value.X,u.Value.Y-o,u.Value.Z)else u:remove()n.Enabled=
false n.Parent=nil end end if v then if v.Value>0 then e.Anchored=true i=script.
Parent:GetChildren()j=game.Players:GetPlayerFromCharacter(script.Parent).
Backpack:GetChildren()for w=1,#i do if i[w].className=='Tool'then g:Clone().
Parent=i[w]print(j)table.insert(j,i[w])end end for w=1,#j do if j[w]:
FindFirstChild'RobloxBuildTool'==nil then h:Clone().Parent=j[w]j[w].Parent=game.
Lighting end end wait(0.2)for w=1,#j do j[w].Parent=game.Players:
GetPlayerFromCharacter(script.Parent).Backpack end v.Value=v.Value-o else e.
Anchored=false for w=1,#j do local x=j[w]:FindFirstChild'RobloxBuildTool'if x
then x:Remove()end j[w].Parent=game.Lighting end wait(0.2)for w=1,#j do local x=
j[w]:FindFirstChild'InCharTag'if x then x:Remove()j[w].Parent=script.Parent else
j[w].Parent=game.Players:GetPlayerFromCharacter(script.Parent).Backpack end end
v:Remove()end end if q~=0 then coroutine.resume(coroutine.create(
billboardHealthChange),q)end end p=d.Health+q*o if p*1.01<d.MaxHealth then d.
Health=p elseif q>0 then d.Health=d.MaxHealth end end end