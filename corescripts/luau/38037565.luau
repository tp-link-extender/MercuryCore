print "[Mercury]: Loaded corescript 38037565"
local damageGuiWidth = 5.0
local damageGuiHeight = 5.0

function waitForChild(parent, childName)
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

-- declarations
local Figure = script.Parent
local Humanoid = waitForChild(Figure, "Humanoid")
local Torso = waitForChild(Figure, "Torso")

local config = Figure:FindFirstChild "PlayerStats"

local inCharTag = Instance.new "BoolValue"
inCharTag.Name = "InCharTag"

local hider = Instance.new "BoolValue"
hider.Name = "RobloxBuildTool"

local currentChildren, backpackTools

if config == nil then
	config = Instance.new "Configuration"
	config.Parent = Figure
	config.Name = "PlayerStats"
end

local myHealth = config:FindFirstChild "MaxHealth"
if myHealth == nil then
	myHealth = Instance.new "NumberValue"
	myHealth.Parent = config
	myHealth.Value = 100
	myHealth.Name = "MaxHealth"
end

Humanoid.MaxHealth = myHealth.Value
Humanoid.Health = myHealth.Value

function onMaxHealthChange()
	Humanoid.MaxHealth = myHealth.Value
	Humanoid.Health = myHealth.Value
end

myHealth.Changed:connect(onMaxHealthChange)

--Humanoid.MaxHealth = myHealth.Value
--Humanoid.Health = Humanoid.MaxHealth

local vPlayer = game.Players:GetPlayerFromCharacter(script.Parent)
local dotGui = vPlayer.PlayerGui:FindFirstChild "DamageOverTimeGui"
if dotGui == nil then
	dotGui = Instance.new "BillboardGui"
	dotGui.Name = "DamageOverTimeGui"
	dotGui.Parent = vPlayer.PlayerGui
	dotGui.Adornee = script.Parent:FindFirstChild "Head"
	dotGui.Active = true
	dotGui.size = UDim2.new(damageGuiWidth, 0, damageGuiHeight, 0.0)
	dotGui.StudsOffset = Vector3.new(0, 2.0, 0.0)
end

print "newHealth declarations finished"

function billboardHealthChange(dmg)
	local textLabel = Instance.new "TextLabel"
	if dmg > 0 then
		textLabel.Text = tostring(dmg)
		textLabel.TextColor3 = Color3.new(0, 1, 0)
	else
		textLabel.Text = tostring(dmg)
		textLabel.TextColor3 = Color3.new(1, 0, 1)
	end
	textLabel.size = UDim2.new(1, 0, 1, 0.0)
	textLabel.Active = true
	textLabel.FontSize = 6
	textLabel.BackgroundTransparency = 1
	textLabel.Parent = dotGui

	for t = 1, 10 do
		wait(0.1)
		textLabel.TextTransparency = t / 10
		textLabel.Position = UDim2.new(0, 0, 0, -t * 5)
		textLabel.FontSize = 6 - t * 0.6
	end

	textLabel:remove()
end

function setMaxHealth()
	--print(Humanoid.Health)
	if myHealth.Value >= 0 then
		Humanoid.MaxHealth = myHealth.Value
		print(Humanoid.MaxHealth)
		if Humanoid.Health > Humanoid.MaxHealth then
			Humanoid.Health = Humanoid.MaxHealth
		end
	end
end

myHealth.Changed:connect(setMaxHealth)

-- Visual Effects --

local fireEffect = Instance.new "Fire"
fireEffect.Heat = 0.1
fireEffect.Size = 3.0
fireEffect.Name = "FireEffect"
fireEffect.Enabled = false
--

-- regeneration
while true do
	local s = wait(1)
	local health = Humanoid.Health
	if health > 0 then -- and health < Humanoid.MaxHealth then
		local delta = 0
		if config then
			local regen = config:FindFirstChild "Regen"
			local poison = config:FindFirstChild "Poison"
			local ice = config:FindFirstChild "Ice"
			local fire = config:FindFirstChild "Fire"
			local stun = config:FindFirstChild "Stun"
			if regen then
				delta += regen.Value.X
				if regen.Value.Y >= 0 then
					regen.Value = Vector3.new(
						regen.Value.X + regen.Value.Z,
						regen.Value.Y - s,
						regen.Value.Z
					) -- maybe have 3rd parameter be an increaser/decreaser?
				elseif regen.Value.Y == -1 then
					regen.Value = Vector3.new(
						regen.Value.X + regen.Value.Z,
						-1,
						regen.Value.Z
					)
				else
					regen:remove()
				end -- infinity is -1
			end
			if poison then
				delta -= poison.Value.X
				if poison.Value.Y >= 0 then
					poison.Value = Vector3.new(
						poison.Value.X + poison.Value.Z,
						poison.Value.Y - s,
						poison.Value.Z
					)
				elseif poison.Value.Y == -1 then
					poison.Value = Vector3.new(
						poison.Value.X + poison.Value.Z,
						-1,
						poison.Value.Z
					)
				else
					poison:remove()
				end -- infinity is -1
			end

			if ice then
				--print("IN ICE")
				delta -= ice.Value.X
				if ice.Value.Y >= 0 then
					ice.Value =
						Vector3.new(ice.Value.X, ice.Value.Y - s, ice.Value.Z)
				else
					ice:remove()
				end
			end

			if fire then
				fireEffect.Enabled = true
				fireEffect.Parent = Figure.Torso
				delta -= fire.Value.X
				if fire.Value.Y >= 0 then
					fire.Value = Vector3.new(
						fire.Value.X,
						fire.Value.Y - s,
						fire.Value.Z
					)
				else
					fire:remove()
					fireEffect.Enabled = false
					fireEffect.Parent = nil
				end
			end

			if stun then
				if stun.Value > 0 then
					Torso.Anchored = true
					currentChildren = script.Parent:GetChildren()
					backpackTools = game.Players
						:GetPlayerFromCharacter(script.Parent).Backpack
						:GetChildren()
					for i = 1, #currentChildren do
						if currentChildren[i].className == "Tool" then
							inCharTag:Clone().Parent = currentChildren[i]
							print(backpackTools)
							table.insert(backpackTools, currentChildren[i])
						end
					end
					for i = 1, #backpackTools do
						if
							backpackTools[i]:FindFirstChild "RobloxBuildTool"
							== nil
						then
							hider:Clone().Parent = backpackTools[i]
							backpackTools[i].Parent = game.Lighting
						end
					end
					wait(0.2)
					for i = 1, #backpackTools do
						backpackTools[i].Parent =
							game.Players:GetPlayerFromCharacter(script.Parent).Backpack
					end
					stun.Value -= s
				else
					Torso.Anchored = false
					for i = 1, #backpackTools do
						local rbTool =
							backpackTools[i]:FindFirstChild "RobloxBuildTool"
						if rbTool then
							rbTool:Remove()
						end
						backpackTools[i].Parent = game.Lighting
					end
					wait(0.2)
					for i = 1, #backpackTools do
						local wasInChar =
							backpackTools[i]:FindFirstChild "InCharTag"
						if wasInChar then
							wasInChar:Remove()
							backpackTools[i].Parent = script.Parent
						else
							backpackTools[i].Parent =
								game.Players:GetPlayerFromCharacter(
									script.Parent
								).Backpack
						end
					end
					stun:Remove()
				end
			end

			if delta ~= 0 then
				coroutine.resume(coroutine.create(billboardHealthChange), delta)
			end
			--delta *= .01
		end
		--health += delta * s * Humanoid.MaxHealth

		health = Humanoid.Health + delta * s
		if health * 1.01 < Humanoid.MaxHealth then
			Humanoid.Health = health
		--myHealth.Value = math.floor(Humanoid.Health)
		elseif delta > 0 then
			Humanoid.Health = Humanoid.MaxHealth
			--myHealth.Value = Humanoid.Health
		end
	end
end
