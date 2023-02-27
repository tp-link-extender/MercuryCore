local damageGuiWidth =  5.0
local damageGuiHeight = 5.0


function waitForChild(parent, childName)
        local child = parent:findFirstChild(childName)
        if child then return child end
        while true do
			child = parent.ChildAdded:wait()
			if child.Name==childName then return child end
        end
end

-- declarations
local Figure = script.Parent
local Head = waitForChild(Figure, &quot;Head&quot;)
local Humanoid = waitForChild(Figure, &quot;Humanoid&quot;)
local walkSpeed = Humanoid.WalkSpeed
local Torso = waitForChild(Figure, &quot;Torso&quot;)

local config = Figure:FindFirstChild(&quot;PlayerStats&quot;)

local inCharTag = Instance.new(&quot;BoolValue&quot;)
inCharTag.Name = &quot;InCharTag&quot;

local hider = Instance.new(&quot;BoolValue&quot;)
hider.Name = &quot;RobloxBuildTool&quot;

local currentChildren
local backpackTools

if config == nil then 
	config = Instance.new(&quot;Configuration&quot;)
	config.Parent = Figure
	config.Name = &quot;PlayerStats&quot;
end

local myHealth = config:FindFirstChild(&quot;MaxHealth&quot;)
if myHealth == nil then 
	myHealth = Instance.new(&quot;NumberValue&quot;)
	myHealth.Parent = config
	myHealth.Value = 100
	myHealth.Name = &quot;MaxHealth&quot;
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
local dotGui = vPlayer.PlayerGui:FindFirstChild(&quot;DamageOverTimeGui&quot;)
if dotGui == nil then
	dotGui = Instance.new(&quot;BillboardGui&quot;)	
	dotGui.Name = &quot;DamageOverTimeGui&quot;
	dotGui.Parent = vPlayer.PlayerGui
	dotGui.Adornee = script.Parent:FindFirstChild(&quot;Head&quot;)
	dotGui.Active = true
	dotGui.size = UDim2.new(damageGuiWidth, 0.0, damageGuiHeight, 0.0)	
	dotGui.StudsOffset = Vector3.new(0.0, 2.0, 0.0)
end

print(&quot;newHealth declarations finished&quot;)

function billboardHealthChange(dmg)			
		local textLabel = Instance.new(&quot;TextLabel&quot;)
		if dmg &gt; 0 then textLabel.Text = tostring(dmg) textLabel.TextColor3 = Color3.new(0, 1, 0)
		else textLabel.Text = tostring(dmg) textLabel.TextColor3 = Color3.new(1, 0, 1) end
		textLabel.size = UDim2.new(1.0, 0.0, 1.0, 0.0)
		textLabel.Active = true
		textLabel.FontSize = 6
		textLabel.BackgroundTransparency = 1
		textLabel.Parent = dotGui

		for t = 1, 10 do
			wait(.1)
			textLabel.TextTransparency = t/10
			textLabel.Position = UDim2.new(0, 0, 0, -t*5)
			textLabel.FontSize = 6-t*.6
		end

		textLabel:remove()
end

function setMaxHealth()
	--print(Humanoid.Health)
	if myHealth.Value &gt;=0 then
		Humanoid.MaxHealth = myHealth.Value 
		print(Humanoid.MaxHealth)
		if Humanoid.Health &gt; Humanoid.MaxHealth then 
			Humanoid.Health = Humanoid.MaxHealth			
		end		
	end
end

myHealth.Changed:connect(setMaxHealth)

-- Visual Effects --

fireEffect = Instance.new(&quot;Fire&quot;)
fireEffect.Heat = 0.1
fireEffect.Size = 3.0
fireEffect.Name = &quot;FireEffect&quot;
fireEffect.Enabled = false
--


  -- regeneration
  while true do
  local s = wait(1)
  local health = Humanoid.Health  
  if health &gt; 0 then -- and health &lt; Humanoid.MaxHealth then
  local delta = 0
  if config then
		regen = config:FindFirstChild(&quot;Regen&quot;)
		poison = config:FindFirstChild(&quot;Poison&quot;)
		ice = config:FindFirstChild(&quot;Ice&quot;)	
		fire = config:FindFirstChild(&quot;Fire&quot;)
		stun = config:FindFirstChild(&quot;Stun&quot;)
		if regen then 
			delta = delta + regen.Value.X
			if regen.Value.Y &gt;= 0 then regen.Value = Vector3.new(regen.Value.X+regen.Value.Z, regen.Value.Y - s, regen.Value.Z)   -- maybe have 3rd parameter be an increaser/decreaser?
			elseif regen.Value.Y == -1 then regen.Value = Vector3.new(regen.Value.X+regen.Value.Z, -1, regen.Value.Z)
			else regen:remove() end  -- infinity is -1
		end
		if poison then
			delta = delta - poison.Value.X
			if poison.Value.Y &gt;= 0 then poison.Value = Vector3.new(poison.Value.X+poison.Value.Z, poison.Value.Y - s, poison.Value.Z)
			elseif poison.Value.Y == -1 then poison.Value = Vector3.new(poison.Value.X+poison.Value.Z, -1, poison.Value.Z)
			else poison:remove() end  -- infinity is -1
		end

		if ice then 
			--print(&quot;IN ICE&quot;)
			delta = delta - ice.Value.X							
			if ice.Value.Y &gt;=0 then 				
				ice.Value = Vector3.new(ice.Value.X, ice.Value.Y - s, ice.Value.Z)				
			else				
				ice:remove()			
			end	
		end
		
		if fire then			
			fireEffect.Enabled = true
			fireEffect.Parent = Figure.Torso
			delta = delta - fire.Value.X
			if fire.Value.Y &gt;= 0 then 
				fire.Value = Vector3.new(fire.Value.X, fire.Value.Y - s, fire.Value.Z)
			else
				fire:remove()
				fireEffect.Enabled = false
				fireEffect.Parent = nil
			end
		end

		if stun then	
			if stun.Value &gt; 0 then	
				Torso.Anchored = true
				currentChildren = script.Parent:GetChildren()				
				backpackTools = game.Players:GetPlayerFromCharacter(script.Parent).Backpack:GetChildren()
				for i = 1, #currentChildren do 
					if currentChildren[i].className == &quot;Tool&quot; then 
						inCharTag:Clone().Parent =   currentChildren[i]
						print(backpackTools)
						table.insert(backpackTools, currentChildren[i])
					end
				end
				for i = 1, #backpackTools do 
					if backpackTools[i]:FindFirstChild(&quot;RobloxBuildTool&quot;) == nil then
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
					rbTool = backpackTools[i]:FindFirstChild(&quot;RobloxBuildTool&quot;)
					if rbTool then rbTool:Remove() end 
					backpackTools[i].Parent = game.Lighting
				end
				wait(0.2)
				for i = 1, #backpackTools do 
					wasInCharacter = backpackTools[i]:FindFirstChild(&quot;InCharTag&quot;)
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
			newCo = coroutine.create(billboardHealthChange)
			coroutine.resume(newCo, delta)
		end
		--delta = delta * .01
  end
  --health = health + delta * s * Humanoid.MaxHealth
	
	health = Humanoid.Health + delta * s
	if health * 1.01 &lt; Humanoid.MaxHealth then
		Humanoid.Health = health
		--myHealth.Value = math.floor(Humanoid.Health)
	elseif delta &gt; 0 then
		Humanoid.Health = Humanoid.MaxHealth
		--myHealth.Value = Humanoid.Health
	end
  end
 end