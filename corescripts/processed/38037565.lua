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
Changed:connect(setMaxHealth)fireEffect=Instance.new'Fire'fireEffect.Heat=0.1
fireEffect.Size=3 fireEffect.Name='FireEffect'fireEffect.Enabled=false while
true do local n,o=wait(1),d.Health if o>0 then local p=0 if f then regen=f:
FindFirstChild'Regen'poison=f:FindFirstChild'Poison'ice=f:FindFirstChild'Ice'
fire=f:FindFirstChild'Fire'stun=f:FindFirstChild'Stun'if regen then p=p+regen.
Value.X if regen.Value.Y>=0 then regen.Value=Vector3.new(regen.Value.X+regen.
Value.Z,regen.Value.Y-n,regen.Value.Z)elseif regen.Value.Y==-1 then regen.Value=
Vector3.new(regen.Value.X+regen.Value.Z,-1,regen.Value.Z)else regen:remove()end
end if poison then p=p-poison.Value.X if poison.Value.Y>=0 then poison.Value=
Vector3.new(poison.Value.X+poison.Value.Z,poison.Value.Y-n,poison.Value.Z)elseif
poison.Value.Y==-1 then poison.Value=Vector3.new(poison.Value.X+poison.Value.Z,-
1,poison.Value.Z)else poison:remove()end end if ice then p=p-ice.Value.X if ice.
Value.Y>=0 then ice.Value=Vector3.new(ice.Value.X,ice.Value.Y-n,ice.Value.Z)else
ice:remove()end end if fire then fireEffect.Enabled=true fireEffect.Parent=c.
Torso p=p-fire.Value.X if fire.Value.Y>=0 then fire.Value=Vector3.new(fire.Value
.X,fire.Value.Y-n,fire.Value.Z)else fire:remove()fireEffect.Enabled=false
fireEffect.Parent=nil end end if stun then if stun.Value>0 then e.Anchored=true
i=script.Parent:GetChildren()j=game.Players:GetPlayerFromCharacter(script.Parent
).Backpack:GetChildren()for q=1,#i do if i[q].className=='Tool'then g:Clone().
Parent=i[q]print(j)table.insert(j,i[q])end end for q=1,#j do if j[q]:
FindFirstChild'RobloxBuildTool'==nil then h:Clone().Parent=j[q]j[q].Parent=game.
Lighting end end wait(0.2)for q=1,#j do j[q].Parent=game.Players:
GetPlayerFromCharacter(script.Parent).Backpack end stun.Value=stun.Value-n else
e.Anchored=false for q=1,#j do rbTool=j[q]:FindFirstChild'RobloxBuildTool'if
rbTool then rbTool:Remove()end j[q].Parent=game.Lighting end wait(0.2)for q=1,#j
do wasInCharacter=j[q]:FindFirstChild'InCharTag'if wasInChar then wasInChar:
Remove()j[q].Parent=script.Parent else j[q].Parent=game.Players:
GetPlayerFromCharacter(script.Parent).Backpack end end stun:Remove()end end if p
~=0 then newCo=coroutine.create(billboardHealthChange)coroutine.resume(newCo,p)
end end o=d.Health+p*n if o*1.01<d.MaxHealth then d.Health=o elseif p>0 then d.
Health=d.MaxHealth end end end