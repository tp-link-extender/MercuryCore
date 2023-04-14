local New
New = function(className, name, props)
	if not (props ~= nil) then
		props = name
		name = nil
	end
	local obj = Instance.new(className)
	if name then
		obj.Name = name
	end
	local parent
	for k, v in pairs(props) do
		if type(k) == "string" then
			if k == "Parent" then
				parent = v
			else
				obj[k] = v
			end
		elseif type(k) == "number" and type(v) == "userdata" then
			v.Parent = obj
		end
	end
	obj.Parent = parent
	return obj
end
local damageGuiWidth = 5.0
local damageGuiHeight = 5.0
local waitForChild
waitForChild = function(parent, childName)
	local child = parent:findFirstChild(childName)
	if child then
		return child
	end
	while true do
		child = parent.ChildAdded:wait()
		if child.Name == childName then
			return child
		end
	end
end
local Figure = script.Parent
local Humanoid = waitForChild(Figure, "Humanoid")
local Torso = waitForChild(Figure, "Torso")
local config = Figure:FindFirstChild("PlayerStats")
local inCharTag = Instance.new("BoolValue")
inCharTag.Name = "InCharTag"
local hider = Instance.new("BoolValue")
hider.Name = "RobloxBuildTool"
if not (config ~= nil) then
	config = Instance.new("Configuration")
	config.Parent = Figure
	config.Name = "PlayerStats"
end
local myHealth = config:FindFirstChild("MaxHealth")
if not (myHealth ~= nil) then
	myHealth = Instance.new("NumberValue")
	myHealth.Parent = config
	myHealth.Value = 100
	myHealth.Name = "MaxHealth"
end
Humanoid.MaxHealth = myHealth.Value
Humanoid.Health = myHealth.Value
local onMaxHealthChange
onMaxHealthChange = function()
	Humanoid.MaxHealth = myHealth.Value
	Humanoid.Health = myHealth.Value
end
myHealth.Changed:connect(onMaxHealthChange)
local vPlayer = game.Players:GetPlayerFromCharacter(script.Parent)
local dotGui = vPlayer.PlayerGui:FindFirstChild("DamageOverTimeGui")
if not (dotGui ~= nil) then
	dotGui = New("BillboardGui", "DamageOverTimeGui", {
		Parent = vPlayer.PlayerGui,
		Adornee = script.Parent:FindFirstChild("Head"),
		Active = true,
		size = UDim2.new(damageGuiWidth, 0, damageGuiHeight, 0.0),
		StudsOffset = Vector3.new(0, 2.0, 0.0)
	})
end
print("newHealth declarations finished")
local billboardHealthChange
billboardHealthChange = function(dmg)
	local textLabel = New("TextLabel", {
		Text = tostring(dmg),
		TextColor3 = (function()
			if dmg > 0 then
				return Color3.new(0, 1, 0)
			else
				return Color3.new(1, 0, 1)
			end
		end)(),
		size = UDim2.new(1, 0, 1, 0.0),
		Active = true,
		FontSize = 6,
		BackgroundTransparency = 1,
		Parent = dotGui
	})
	for t = 1, 10 do
		wait(0.1)
		textLabel.TextTransparency = t / 10
		textLabel.Position = UDim2.new(0, 0, 0, -t * 5)
		textLabel.FontSize = 6 - t * 0.6
	end
	return textLabel:remove()
end
local setMaxHealth
setMaxHealth = function()
	if myHealth.Value >= 0 then
		Humanoid.MaxHealth = myHealth.Value
		print(Humanoid.MaxHealth)
		if Humanoid.Health > Humanoid.MaxHealth then
			Humanoid.Health = Humanoid.MaxHealth
		end
	end
end
myHealth.Changed:connect(setMaxHealth)
local fireEffect = New("Fire", "FireEffect", {
	Heat = 0.1,
	Size = 3.0,
	Enabled = false
})
while true do
	local s = wait(1)
	local health = Humanoid.Health
	if health > 0 then
		local delta = 0
		if config then
			local regen = config:FindFirstChild("Regen")
			local poison = config:FindFirstChild("Poison")
			local ice = config:FindFirstChild("Ice")
			local fire = config:FindFirstChild("Fire")
			local stun = config:FindFirstChild("Stun")
			if regen then
				delta = delta + regen.Value.X
				if regen.Value.Y >= 0 then
					regen.Value = Vector3.new(regen.Value.X + regen.Value.Z, regen.Value.Y - s, regen.Value.Z)
				elseif regen.Value.Y == -1 then
					regen.Value = Vector3.new(regen.Value.X + regen.Value.Z, -1, regen.Value.Z)
				else
					regen:remove()
				end
			end
			if poison then
				delta = delta - poison.Value.X
				if poison.Value.Y >= 0 then
					poison.Value = Vector3.new(poison.Value.X + poison.Value.Z, poison.Value.Y - s, poison.Value.Z)
				elseif poison.Value.Y == -1 then
					poison.Value = Vector3.new(poison.Value.X + poison.Value.Z, -1, poison.Value.Z)
				else
					poison:remove()
				end
			end
			if ice then
				delta = delta - ice.Value.X
				if ice.Value.Y >= 0 then
					ice.Value = Vector3.new(ice.Value.X, ice.Value.Y - s, ice.Value.Z)
				else
					ice:remove()
				end
			end
			if fire then
				fireEffect.Enabled = true
				fireEffect.Parent = Figure.Torso
				delta = delta - fire.Value.X
				if fire.Value.Y >= 0 then
					fire.Value = Vector3.new(fire.Value.X, fire.Value.Y - s, fire.Value.Z)
				else
					fire:remove()
					fireEffect.Enabled = false
					fireEffect.Parent = nil
				end
			end
			if stun then
				local backpackTools
				if stun.Value > 0 then
					Torso.Anchored = true
					local currentChildren = script.Parent:GetChildren()
					backpackTools = game.Players:GetPlayerFromCharacter(script.Parent).Backpack:GetChildren()
					for i = 1, #currentChildren do
						if currentChildren[i].className == "Tool" then
							inCharTag:Clone().Parent = currentChildren[i]
							print(backpackTools)
							table.insert(backpackTools, currentChildren[i])
						end
					end
					for i = 1, #backpackTools do
						if not (backpackTools[i]:FindFirstChild("RobloxBuildTool") ~= nil) then
							hider:Clone().Parent = backpackTools[i]
							backpackTools[i].Parent = game.Lighting
						end
					end
					wait(0.2)
					for i = 1, #backpackTools do
						backpackTools[i].Parent = game.Players:GetPlayerFromCharacter(script.Parent).Backpack
					end
					stun.Value = stun.Value - s
				else
					Torso.Anchored = false
					for i = 1, #backpackTools do
						local rbTool = backpackTools[i]:FindFirstChild("RobloxBuildTool")
						if rbTool then
							rbTool:Remove()
						end
						backpackTools[i].Parent = game.Lighting
					end
					wait(0.2)
					for i = 1, #backpackTools do
						local wasInChar = backpackTools[i]:FindFirstChild("InCharTag")
						if wasInChar then
							wasInChar:Remove()
							backpackTools[i].Parent = script.Parent
						else
							backpackTools[i].Parent = game.Players:GetPlayerFromCharacter(script.Parent).Backpack
						end
					end
					stun:Remove()
				end
			end
			if delta ~= 0 then
				coroutine.resume(coroutine.create(billboardHealthChange), delta)
			end
		end
		health = Humanoid.Health + delta * s
		if health * 1.01 < Humanoid.MaxHealth then
			Humanoid.Health = health
		elseif delta > 0 then
			Humanoid.Health = Humanoid.MaxHealth
		end
	end
end
