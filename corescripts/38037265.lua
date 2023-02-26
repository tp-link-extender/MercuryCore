<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
	<Item class="Script" referent="RBX0">
		<Properties>
			<bool name="Disabled">false</bool>
			<Content name="LinkedSource"><null></null></Content>
			<string name="Name">Health</string>
			<ProtectedString name="Source">function waitForChild(parent, childName)
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
local regening = false

-- regeneration
function regenHealth()
	if regening then return end
	regening = true
	while Humanoid.Health &lt; Humanoid.MaxHealth do
		local s = wait(1)
		local health = Humanoid.Health
		if health &gt; 0 and health &lt; Humanoid.MaxHealth then
			local newHealthDelta = 0.01 * s * Humanoid.MaxHealth
			health = health + newHealthDelta
			Humanoid.Health = math.min(health,Humanoid.MaxHealth)
		end
	end
	if Humanoid.Health &gt; Humanoid.MaxHealth then
		Humanoid.Health = Humanoid.MaxHealth
	end
	regening = false
end

Humanoid.HealthChanged:connect(regenHealth)
      </ProtectedString>
			<bool name="archivable">true</bool>
		</Properties>
	</Item>
	<Item class="Script" referent="RBX1">
		<Properties>
			<bool name="Disabled">false</bool>
			<Content name="LinkedSource"><null></null></Content>
			<string name="Name">HealthScript v3.1</string>
			<ProtectedString name="Source">local HealthGUI_prototype = script:FindFirstChild(&quot;HealthGUI&quot;)
local lastHealth = 100
local lastHealth2 = 100
local maxWidth = 0.96

local humanoid = script.Parent.Humanoid

if (humanoid == nil) then
	print(&quot;ERROR: no humanoid found in &apos;HealthScript v3.1&apos;&quot;)
end


function CreateGUI()
	local p = game.Players:GetPlayerFromCharacter(humanoid.Parent)
	HealthGUI_prototype.Parent = p.PlayerGui
end

function UpdateGUI(health)
	tray = HealthGUI_prototype.tray
	local width = (health / humanoid.MaxHealth) * maxWidth
	local height = 0.83
	local lastX = tray.bar.Position.X.Scale
	local x = 0.019 + (maxWidth - width)
	local y = 0.1
	
	tray.bar.Position = UDim2.new(x,0,y, 0) 
	tray.bar.Size = UDim2.new(width, 0, height, 0)
	-- If more than 1/4 health, bar = green.  Else, bar = red.
	if( (health / humanoid.MaxHealth) &gt; 0.25 ) then
		tray.barRed.Size = UDim2.new(0, 0, 0, 0)
	else
		tray.barRed.Position = tray.bar.Position
		tray.barRed.Size = tray.bar.Size
		tray.bar.Size = UDim2.new(0, 0, 0, 0)
	end
	
	if ( (lastHealth - health) &gt; (humanoid.MaxHealth / 10) ) then
		lastHealth = health

		if humanoid.Health ~= humanoid.MaxHealth then
			delay(0,function()
				AnimateHurtOverlay()
			end)
			delay(0,function()
				AnimateBars(x, y, lastX, height)
			end)
		end
	else
		lastHealth = health
	end
end


function HealthChanged(health)
	UpdateGUI(health)
	if ( (lastHealth2 - health) &gt; (humanoid.MaxHealth / 10) ) then
		lastHealth2 = health
	else
		lastHealth2 = health
	end
end

function AnimateBars(x, y, lastX, height)
	tray = HealthGUI_prototype.tray
	local width = math.abs(x - lastX)
	if( x &gt; lastX ) then
		x = lastX
	end
	tray.bar2.Position = UDim2.new(x,0, y, 0)
	tray.bar2.Size = UDim2.new(width, 0, height, 0)
	tray.bar2.BackgroundTransparency = 0
	local GBchannels = 1
	local j = 0.2

	local i_total = 30
	for i=1,i_total do
		-- Increment Values
		if (GBchannels &lt; 0.2) then
			j = -j
		end
		GBchannels = GBchannels + j
		if (i &gt; (i_total - 10)) then
			tray.bar2.BackgroundTransparency = tray.bar2.BackgroundTransparency + 0.1
		end
		tray.bar2.BackgroundColor3 = Color3.new(1, GBchannels, GBchannels)
		
		wait(0.02)
	end
end

function AnimateHurtOverlay()
	-- Start:
	-- overlay.Position = UDim2.new(0, 0, 0, -22)
	-- overlay.Size = UDim2.new(1, 0, 1.15, 30)
	
	-- Finish:
	-- overlay.Position = UDim2.new(-2, 0, -2, -22)
	-- overlay.Size = UDim2.new(4.5, 0, 4.65, 30)
	
	overlay = HealthGUI_prototype.hurtOverlay
	overlay.Position = UDim2.new(-2, 0, -2, -22)
	overlay.Size = UDim2.new(4.5, 0, 4.65, 30)
	-- Animate In, fast
	local i_total = 2
	local wiggle_total = 0
	local wiggle_i = 0.02
	for i=1,i_total do
		overlay.Position = UDim2.new( (-2 + (2 * (i/i_total)) + wiggle_total/2), 0, (-2 + (2 * (i/i_total)) + wiggle_total/2), -22 )
		overlay.Size = UDim2.new( (4.5 - (3.5 * (i/i_total)) + wiggle_total), 0, (4.65 - (3.5 * (i/i_total)) + wiggle_total), 30 )
		wait(0.01)
	end
	
	i_total = 30
	
	wait(0.03)
	
	-- Animate Out, slow
	for i=1,i_total do
		if( math.abs(wiggle_total) &gt; (wiggle_i * 3) ) then
			wiggle_i = -wiggle_i
		end
		wiggle_total = wiggle_total + wiggle_i
		overlay.Position = UDim2.new( (0 - (2 * (i/i_total)) + wiggle_total/2), 0, (0 - (2 * (i/i_total)) + wiggle_total/2), -22 )
		overlay.Size = UDim2.new( (1 + (3.5 * (i/i_total)) + wiggle_total), 0, (1.15 + (3.5 * (i/i_total)) + wiggle_total), 30 )
		wait(0.01)
	end
	
	-- Hide after we&apos;re done
	overlay.Position = UDim2.new(10, 0, 0, 0)
end

CreateGUI()
humanoid.HealthChanged:connect(HealthChanged)
humanoid.Died:connect(function() HealthChanged(0) end)</ProtectedString>
			<bool name="archivable">true</bool>
		</Properties>
		<Item class="GuiMain" referent="RBX2">
			<Properties>
				<string name="Name">HealthGUI</string>
				<bool name="archivable">true</bool>
			</Properties>
			<Item class="ImageLabel" referent="RBX3">
				<Properties>
					<bool name="Active">false</bool>
					<Color3 name="BackgroundColor3">4290164919</Color3>
					<float name="BackgroundTransparency">1</float>
					<Color3 name="BorderColor3">4279970357</Color3>
					<int name="BorderSizePixel">1</int>
					<bool name="Draggable">false</bool>
					<Content name="Image"><url>http://www.roblox.com/asset/?id=34854607</url></Content>
					<string name="Name">hurtOverlay</string>
					<UDim2 name="Position">
						<XS>2</XS>
						<XO>0</XO>
						<YS>0</YS>
						<YO>-22</YO>
					</UDim2>
					<UDim2 name="Size">
						<XS>1</XS>
						<XO>0</XO>
						<YS>1.1500001</YS>
						<YO>30</YO>
					</UDim2>
					<token name="SizeConstraint">0</token>
					<bool name="Visible">true</bool>
					<int name="ZIndex">1</int>
					<bool name="archivable">true</bool>
				</Properties>
			</Item>
			<Item class="Frame" referent="RBX4">
				<Properties>
					<bool name="Active">false</bool>
					<Color3 name="BackgroundColor3">4285215356</Color3>
					<float name="BackgroundTransparency">1</float>
					<Color3 name="BorderColor3">4279970357</Color3>
					<int name="BorderSizePixel">1</int>
					<bool name="Draggable">false</bool>
					<string name="Name">tray</string>
					<UDim2 name="Position">
						<XS>0.5</XS>
						<XO>-44</XO>
						<YS>1</YS>
						<YO>-26</YO>
					</UDim2>
					<UDim2 name="Size">
						<XS>0</XS>
						<XO>170</XO>
						<YS>0</YS>
						<YO>18</YO>
					</UDim2>
					<token name="SizeConstraint">2</token>
					<token name="Style">0</token>
					<bool name="Visible">true</bool>
					<int name="ZIndex">1</int>
					<bool name="archivable">true</bool>
				</Properties>
				<Item class="ImageLabel" referent="RBX5">
					<Properties>
						<bool name="Active">false</bool>
						<Color3 name="BackgroundColor3">4294967295</Color3>
						<float name="BackgroundTransparency">1</float>
						<Color3 name="BorderColor3">4279970357</Color3>
						<int name="BorderSizePixel">1</int>
						<bool name="Draggable">false</bool>
						<Content name="Image"><url>http://www.roblox.com/asset/?id=35238000</url></Content>
						<string name="Name">bkg</string>
						<UDim2 name="Position">
							<XS>0</XS>
							<XO>0</XO>
							<YS>0</YS>
							<YO>0</YO>
						</UDim2>
						<UDim2 name="Size">
							<XS>1</XS>
							<XO>0</XO>
							<YS>1</YS>
							<YO>0</YO>
						</UDim2>
						<token name="SizeConstraint">0</token>
						<bool name="Visible">true</bool>
						<int name="ZIndex">1</int>
						<bool name="archivable">true</bool>
					</Properties>
				</Item>
				<Item class="ImageLabel" referent="RBX6">
					<Properties>
						<bool name="Active">false</bool>
						<Color3 name="BackgroundColor3">4294967295</Color3>
						<float name="BackgroundTransparency">1</float>
						<Color3 name="BorderColor3">4279970357</Color3>
						<int name="BorderSizePixel">1</int>
						<bool name="Draggable">false</bool>
						<Content name="Image"><url>http://www.roblox.com/asset/?id=35238036</url></Content>
						<string name="Name">barRed</string>
						<UDim2 name="Position">
							<XS>0.0189999994</XS>
							<XO>0</XO>
							<YS>0.100000001</YS>
							<YO>0</YO>
						</UDim2>
						<UDim2 name="Size">
							<XS>0</XS>
							<XO>0</XO>
							<YS>0</YS>
							<YO>0</YO>
						</UDim2>
						<token name="SizeConstraint">0</token>
						<bool name="Visible">true</bool>
						<int name="ZIndex">1</int>
						<bool name="archivable">true</bool>
					</Properties>
				</Item>
				<Item class="Frame" referent="RBX7">
					<Properties>
						<bool name="Active">false</bool>
						<Color3 name="BackgroundColor3">4294967295</Color3>
						<float name="BackgroundTransparency">1.00000012</float>
						<Color3 name="BorderColor3">4279970357</Color3>
						<int name="BorderSizePixel">0</int>
						<bool name="Draggable">false</bool>
						<string name="Name">bar2</string>
						<UDim2 name="Position">
							<XS>0.0189999994</XS>
							<XO>0</XO>
							<YS>0.100000001</YS>
							<YO>0</YO>
						</UDim2>
						<UDim2 name="Size">
							<XS>0.192000002</XS>
							<XO>0</XO>
							<YS>0.829999983</YS>
							<YO>0</YO>
						</UDim2>
						<token name="SizeConstraint">0</token>
						<token name="Style">0</token>
						<bool name="Visible">true</bool>
						<int name="ZIndex">1</int>
						<bool name="archivable">true</bool>
					</Properties>
				</Item>
				<Item class="ImageLabel" referent="RBX8">
					<Properties>
						<bool name="Active">false</bool>
						<Color3 name="BackgroundColor3">4294967295</Color3>
						<float name="BackgroundTransparency">1</float>
						<Color3 name="BorderColor3">4279970357</Color3>
						<int name="BorderSizePixel">1</int>
						<bool name="Draggable">false</bool>
						<Content name="Image"><url>http://www.roblox.com/asset/?id=35238053</url></Content>
						<string name="Name">bar</string>
						<UDim2 name="Position">
							<XS>0.0189999994</XS>
							<XO>0</XO>
							<YS>0.100000001</YS>
							<YO>0</YO>
						</UDim2>
						<UDim2 name="Size">
							<XS>0.959999979</XS>
							<XO>0</XO>
							<YS>0.829999983</YS>
							<YO>0</YO>
						</UDim2>
						<token name="SizeConstraint">0</token>
						<bool name="Visible">true</bool>
						<int name="ZIndex">1</int>
						<bool name="archivable">true</bool>
					</Properties>
				</Item>
				<Item class="ImageLabel" referent="RBX9">
					<Properties>
						<bool name="Active">false</bool>
						<Color3 name="BackgroundColor3">4294967295</Color3>
						<float name="BackgroundTransparency">1</float>
						<Color3 name="BorderColor3">4279970357</Color3>
						<int name="BorderSizePixel">0</int>
						<bool name="Draggable">false</bool>
						<Content name="Image"><url>http://www.roblox.com/asset/?id=34816363</url></Content>
						<string name="Name">label</string>
						<UDim2 name="Position">
							<XS>0.680000007</XS>
							<XO>0</XO>
							<YS>0.300000012</YS>
							<YO>0</YO>
						</UDim2>
						<UDim2 name="Size">
							<XS>0.25</XS>
							<XO>0</XO>
							<YS>0.349999994</YS>
							<YO>0</YO>
						</UDim2>
						<token name="SizeConstraint">0</token>
						<bool name="Visible">true</bool>
						<int name="ZIndex">1</int>
						<bool name="archivable">true</bool>
					</Properties>
				</Item>
			</Item>
		</Item>
	</Item>
</roblox>