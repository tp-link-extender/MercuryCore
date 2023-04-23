print("[Mercury]: Loaded corescript 53878057")
if game.CoreGui.Version < 3 then
	return
end
local waitForChild
waitForChild = function(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
	return instance:FindFirstChild(name)
end
local waitForProperty
waitForProperty = function(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end
local currentLoadout = script.Parent
local StaticTabName = "gear"
local backpackEnabled = true
local robloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
assert(robloxGui)
local controlFrame = waitForChild(robloxGui, "ControlFrame")
local backpackButton = waitForChild(controlFrame, "BackpackButton")
local backpack = waitForChild(robloxGui, "Backpack")
waitForChild(robloxGui, "CurrentLoadout")
waitForChild(robloxGui.CurrentLoadout, "TempSlot")
waitForChild(robloxGui.CurrentLoadout.TempSlot, "SlotNumber")
waitForChild(currentLoadout, "Background")
local clBackground = currentLoadout.Background
local IsTouchDevice
IsTouchDevice = function()
	local touchEnabled = false
pcall(function()
		touchEnabled = Game:GetService("UserInputService").TouchEnabled
	end)
	return touchEnabled
end
local moveHealthBar
moveHealthBar = function(pGui)
	waitForChild(pGui, "HealthGUI")
	waitForChild(pGui["HealthGUI"], "tray")
	local tray = pGui["HealthGUI"]["tray"]
	tray.Position = UDim2.new(0.5, -85, 1, -26)
end
local setHealthBarVisible
setHealthBarVisible = function(pGui, visible)
	waitForChild(pGui, "HealthGUI")
	waitForChild(pGui["HealthGUI"], "tray")
	local tray = pGui["HealthGUI"]["tray"]
	tray.Visible = visible
end
waitForChild(game, "Players")
waitForProperty(game.Players, "LocalPlayer")
local player = game.Players.LocalPlayer
waitForChild(player, "PlayerGui")
Spawn(function()
	return moveHealthBar(player.PlayerGui)
end)
while not (player.Character ~= nil) do
	wait(0.03)
end
local humanoid = waitForChild(player.Character, "Humanoid")
humanoid.Died:connect(function()
	backpackButton.Visible = false
end)
waitForChild(game, "LocalBackpack")
game.LocalBackpack:SetOldSchoolBackpack(false)
waitForChild(currentLoadout.Parent, "Backpack")
local guiBackpack = currentLoadout.Parent.Backpack
local backpackManager = waitForChild(guiBackpack, "CoreScripts/BackpackScripts/BackpackManager")
local backpackOpenEvent = waitForChild(backpackManager, "BackpackOpenEvent")
local backpackCloseEvent = waitForChild(backpackManager, "BackpackCloseEvent")
local tabClickedEvent = waitForChild(backpackManager, "TabClickedEvent")
local inGearTab = true
local maxNumLoadoutItems = 10
if robloxGui.AbsoluteSize.Y <= 320 then
	maxNumLoadoutItems = 4
end
local characterChildAddedCon, backpackChildCon
local debounce = false
local enlargeFactor = 1.18
local buttonSizeEnlarge = UDim2.new(1 * enlargeFactor, 0, 1 * enlargeFactor, 0)
local buttonSizeNormal = UDim2.new(1, 0, 1, 0)
local enlargeOverride = true
local guiTweenSpeed = 0.5
local firstInstanceOfLoadout = false
local inventory = { }
local gearSlots = { }
for i = 1, maxNumLoadoutItems do
	gearSlots[i] = "empty"
end
local backpackWasOpened = false
local backpackIsOpen
backpackIsOpen = function()
	if guiBackpack then
		return guiBackpack.Visible
	end
	return false
end
local reorganizeLoadout
local kill
kill = function(prop, con, gear)
	if con ~= nil then
		con:disconnect()
	end
	if prop == true and gear then
		return reorganizeLoadout(gear, false)
	end
end
local registerNumberKeys
registerNumberKeys = function()
	for i = 0, 9 do
		game:GetService("GuiService"):AddKey(tostring(i))
	end
end
local unregisterNumberKeys
unregisterNumberKeys = function()
	return pcall(function()
		for i = 0, 9 do
			game:GetService("GuiService"):RemoveKey(tostring(i))
		end
	end)
end
local characterInWorkspace
characterInWorkspace = function()
	if game.Players["LocalPlayer"] and game.Players.LocalPlayer["Character"] and (game.Players.LocalPlayer.Character ~= nil) and (game.Players.LocalPlayer.Character.Parent ~= nil) then
		return true
	end
	return false
end
local removeGear
removeGear = function(gear)
	local emptySlot
	for i = 1, #gearSlots do
		if gearSlots[i] == gear and (gear.Parent ~= nil) then
			emptySlot = i
			break
		end
	end
	if emptySlot then
		do
			local _with_0 = gearSlots[emptySlot]
			if _with_0.GearReference.Value then
				if _with_0.GearReference.Value.Parent == game.Players.LocalPlayer.Character then
					_with_0.GearReference.Value.Parent = game.Players.LocalPlayer.Backpack
				end
				if _with_0.GearReference.Value:IsA("HopperBin") and _with_0.GearReference.Value.Active then
					_with_0.GearReference.Value:Disable()
					_with_0.GearReference.Value.Active = false
				end
			end
		end
		gearSlots[emptySlot] = "empty"
		delay(0, function()
			return gear:remove()
		end)
		return Spawn(function()
			while backpackIsOpen() do
				wait(0.03)
			end
			waitForChild(player, "Backpack")
			local allEmpty = true
			for i = 1, #gearSlots do
				if gearSlots[i] ~= "empty" then
					allEmpty = false
				end
			end
			if allEmpty then
				if #player.Backpack:GetChildren() < 1 then
					backpackButton.Visible = false
				else
					backpackButton.Position = UDim2.new(0.5, -60, 1, -44)
				end
				clBackground.Visible = false
			end
		end)
	end
end
local insertGear
insertGear = function(gear, addToSlot)
	local pos
	if not addToSlot then
		for i = 1, #gearSlots do
			if gearSlots[i] == "empty" then
				pos = i
				break
			end
		end
		if pos == 1 and gearSlots[1] ~= "empty" then
			gear:remove()
			return
		end
	else
		pos = addToSlot
		local start = 1
		for i = 1, #gearSlots do
			if gearSlots[i] == "empty" then
				start = i
				break
			end
		end
		for i = start, pos + 1, -1 do
			gearSlots[i] = gearSlots[i - 1]
			do
				local _tmp_0
				if i == 10 then
					_tmp_0 = "0"
				else
					_tmp_0 = i
				end
				gearSlots[i].SlotNumber.Text = _tmp_0
				gearSlots[i].SlotNumberDownShadow.Text = _tmp_0
				gearSlots[i].SlotNumberUpShadow.Text = _tmp_0
			end
		end
	end
	gearSlots[pos] = gear
	if pos ~= maxNumLoadoutItems then
		if type(tostring(pos)) == "string" then
			local posString = tostring(pos)
			gear.SlotNumber.Text = posString
			gear.SlotNumberDownShadow.Text = posString
			gear.SlotNumberUpShadow.Text = posString
		end
	else
		gear.SlotNumber.Text = "0"
		gear.SlotNumberDownShadow.Text = "0"
		gear.SlotNumberUpShadow.Text = "0"
	end
	gear.Visible = true
	local con = gear.Kill.Changed:connect(function(prop)
		return kill(prop, con, gear)
	end)
end
reorganizeLoadout = function(gear, inserting, _, addToSlot)
	if inserting then
		insertGear(gear, addToSlot)
	else
		removeGear(gear)
	end
	if gear ~= "empty" then
		gear.ZIndex = 1
	end
end
local checkToolAncestry
checkToolAncestry = function(child, parent)
	if child:FindFirstChild("RobloxBuildTool") then
		return
	end
	if child:IsA("Tool") or child:IsA("HopperBin") then
		for i = 1, #gearSlots do
			if gearSlots[i] ~= "empty" and gearSlots[i].GearReference.Value == child then
				if not (parent ~= nil) then
					gearSlots[i].Kill.Value = true
					return false
				elseif child.Parent == player.Character then
					gearSlots[i].Selected = true
					return true
				elseif child.Parent == player.Backpack then
					if child:IsA("Tool") or child:IsA("HopperBin") then
						gearSlots[i].Selected = false
					end
					return true
				end
				gearSlots[i].Kill.Value = true
				return false
			end
		end
	end
end
local removeAllEquippedGear
removeAllEquippedGear = function(physGear)
	local stuff = player.Character:GetChildren()
	for i = 1, #stuff do
		if (stuff[i]:IsA("Tool") or stuff[i]:IsA("HopperBin")) and stuff[i] ~= physGear then
			if stuff[i]:IsA("Tool") then
				stuff[i].Parent = player.Backpack
			end
			if stuff[i]:IsA("HopperBin") then
				stuff[i]:Disable()
			end
		end
	end
end
local normalizeButton
normalizeButton = function(button, speed)
	if not button then
		return
	end
	if button.Size.Y.Scale <= 1 then
		return
	end
	if button.Selected then
		return
	end
	if not button.Parent then
		return
	end
	local moveSpeed = speed
	if not (moveSpeed ~= nil) or type(moveSpeed) ~= "number" then
		moveSpeed = guiTweenSpeed / 5
	end
	if button:FindFirstChild("Highlight") then
		button.Highlight.Visible = false
	end
	if button:IsA("ImageButton") or button:IsA("TextButton") then
		button.ZIndex = 1
		local centerizeX = -(buttonSizeNormal.X.Scale - button.Size.X.Scale) / 2
		local centerizeY = -(buttonSizeNormal.Y.Scale - button.Size.Y.Scale) / 2
		return button:TweenSizeAndPosition(buttonSizeNormal, UDim2.new(button.Position.X.Scale + centerizeX, button.Position.X.Offset, button.Position.Y.Scale + centerizeY, button.Position.Y.Offset), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, moveSpeed, enlargeOverride)
	end
end
local enlargeButton
enlargeButton = function(button)
	if button.Size.Y.Scale > 1 then
		return
	end
	if not button.Parent then
		return
	end
	if not button.Selected then
		return
	end
	for i = 1, #gearSlots do
		if gearSlots[i] == "empty" then
			break
		end
		if gearSlots[i] ~= button then
			normalizeButton(gearSlots[i])
		end
	end
	if not enlargeOverride then
		return
	end
	if button:FindFirstChild("Highlight") then
		button.Highlight.Visible = true
	end
	if button:IsA("ImageButton") or button:IsA("TextButton") then
		button.ZIndex = 5
		local centerizeX = -(buttonSizeEnlarge.X.Scale - button.Size.X.Scale) / 2
		local centerizeY = -(buttonSizeEnlarge.Y.Scale - button.Size.Y.Scale) / 2
		return button:TweenSizeAndPosition(buttonSizeEnlarge, UDim2.new(button.Position.X.Scale + centerizeX, button.Position.X.Offset, button.Position.Y.Scale + centerizeY, button.Position.Y.Offset), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, guiTweenSpeed / 5, enlargeOverride)
	end
end
local hopperBinSwitcher
hopperBinSwitcher = function(numKey, physGear)
	if not physGear then
		return
	end
	physGear:ToggleSelect()
	if gearSlots[numKey] == "empty" then
		return
	end
	if not physGear.Active then
		gearSlots[numKey].Selected = false
		return normalizeButton(gearSlots[numKey])
	else
		gearSlots[numKey].Selected = true
		return enlargeButton(gearSlots[numKey])
	end
end
local toolSwitcher
toolSwitcher = function(numKey)
	if not gearSlots[numKey] then
		return
	end
	local physGear = gearSlots[numKey].GearReference.Value
	if not (physGear ~= nil) then
		return
	end
	removeAllEquippedGear(physGear)
	local key = numKey
	if numKey == 0 then
		key = 10
	end
	for i = 1, #gearSlots do
		if gearSlots[i] and gearSlots[i] ~= "empty" and i ~= key then
			normalizeButton(gearSlots[i])
			do
				local _with_0 = gearSlots[i]
				_with_0.Selected = false
				if _with_0.GearReference and _with_0.GearReference.Value and _with_0.GearReference.Value:IsA("HopperBin") and _with_0.GearReference.Value.Active then
					_with_0.GearReference.Value:ToggleSelect()
				end
			end
		end
	end
	if physGear:IsA("HopperBin") then
		return hopperBinSwitcher(numKey, physGear)
	else
		if physGear.Parent == player.Character then
			physGear.Parent = player.Backpack
			if gearSlots[numKey] ~= "empty" then
				gearSlots[numKey].Selected = false
				return normalizeButton(gearSlots[numKey])
			end
		else
			physGear.Parent = player.Character
			gearSlots[numKey].Selected = true
			return enlargeButton(gearSlots[numKey])
		end
	end
end
local activateGear
activateGear = function(num)
	local numKey
	if num == "0" then
		numKey = 10
	else
		numKey = tonumber(num)
	end
	if not (numKey ~= nil) then
		return
	end
	if gearSlots[numKey] ~= "empty" then
		return toolSwitcher(numKey)
	end
end
local normalizeAllButtons
normalizeAllButtons = function()
	for i = 1, #gearSlots do
		if gearSlots[i] == "empty" then
			break
		end
		if gearSlots[i] ~= button then
			normalizeButton(gearSlots[i], 0.1)
		end
	end
end
local waitForDebounce
waitForDebounce = function()
	while debounce do
		wait()
	end
end
local pointInRectangle
pointInRectangle = function(point, rectTopLeft, rectSize)
	if (point.x > rectTopLeft.x and point.x < (rectTopLeft.x + rectSize.x)) or (point.y > rectTopLeft.y and point.y < (rectTopLeft.y + rectSize.y)) then
		return true
	end
	return false
end
local swapGear
swapGear = function(gearClone, toFrame)
	local toFrameChildren = toFrame:GetChildren()
	if #toFrameChildren == 1 then
		if toFrameChildren[1]:FindFirstChild("SlotNumber") then
			local toSlot = tonumber(toFrameChildren[1].SlotNumber.Text)
			local gearCloneSlot = tonumber(gearClone.SlotNumber.Text)
			if toSlot == 0 then
				toSlot = 10
			end
			if gearCloneSlot == 0 then
				gearCloneSlot = 10
			end
			gearSlots[toSlot] = gearClone
			gearSlots[gearCloneSlot] = toFrameChildren[1]
			toFrameChildren[1].SlotNumber.Text = gearClone.SlotNumber.Text
			toFrameChildren[1].SlotNumberDownShadow.Text = gearClone.SlotNumber.Text
			toFrameChildren[1].SlotNumberUpShadow.Text = gearClone.SlotNumber.Text
			local subString = string.sub(toFrame.Name, 5)
			gearClone.SlotNumber.Text = subString
			gearClone.SlotNumberDownShadow.Text = subString
			gearClone.SlotNumberUpShadow.Text = subString
			gearClone.Position = UDim2.new(gearClone.Position.X.Scale, 0, gearClone.Position.Y.Scale, 0)
			toFrameChildren[1].Position = UDim2.new(toFrameChildren[1].Position.X.Scale, 0, toFrameChildren[1].Position.Y.Scale, 0)
			toFrameChildren[1].Parent = gearClone.Parent
			gearClone.Parent = toFrame
		end
	else
		local slotNum = tonumber(gearClone.SlotNumber.Text)
		if slotNum == 0 then
			slotNum = 10
		end
		gearSlots[slotNum] = "empty"
		local subString = string.sub(toFrame.Name, 5)
		gearClone.SlotNumber.Text = subString
		gearClone.SlotNumberDownShadow.Text = subString
		gearClone.SlotNumberUpShadow.Text = subString
		local toSlotNum = tonumber(gearClone.SlotNumber.Text)
		if toSlotNum == 0 then
			toSlotNum = 10
		end
		gearSlots[toSlotNum] = gearClone
		gearClone.Position = UDim2.new(gearClone.Position.X.Scale, 0, gearClone.Position.Y.Scale, 0)
		gearClone.Parent = toFrame
	end
end
local resolveDrag
resolveDrag = function(gearClone, x, y)
	local mousePoint = Vector2.new(x, y)
	local frame = gearClone.Parent
	local frames = frame.Parent:GetChildren()
	for i = 1, #frames do
		if frames[i]:IsA("Frame") and pointInRectangle(mousePoint, frames[i].AbsolutePosition, frames[i].AbsoluteSize) then
			swapGear(gearClone, frames[i])
			return true
		end
	end
	if (x < frame.AbsolutePosition.x or x > (frame.AbsolutePosition.x + frame.AbsoluteSize.x)) or (y < frame.AbsolutePosition.y or y > (frame.AbsolutePosition.y + frame.AbsoluteSize.y)) then
		reorganizeLoadout(gearClone, false)
		return false
	else
		if dragBeginPos then
			gearClone.Position = dragBeginPos
		end
		return -1
	end
end
local unequipAllItems
unequipAllItems = function(dontEquipThis)
	for i = 1, #gearSlots do
		if gearSlots[i] == "empty" then
			break
		end
		do
			local _with_0 = gearSlots[i]
			if _with_0.GearReference.Value and _with_0.GearReference.Value ~= dontEquipThis then
				if _with_0.GearReference.Value:IsA("HopperBin") then
					_with_0.GearReference.Value:Disable()
				elseif _with_0.GearReference.Value:IsA("Tool") then
					_with_0.GearReference.Value.Parent = game.Players.LocalPlayer.Backpack
				end
				_with_0.Selected = false
			end
		end
	end
end
local showToolTip
showToolTip = function(button, tip)
	if button and button:FindFirstChild("ToolTipLabel") and button.ToolTipLabel:IsA("TextLabel") and not IsTouchDevice() then
		button.ToolTipLabel.Text = tostring(tip)
		local xSize = button.ToolTipLabel.TextBounds.X + 6
		button.ToolTipLabel.Size = UDim2.new(0, xSize, 0, 20)
		button.ToolTipLabel.Position = UDim2.new(0.5, -xSize / 2, 0, -30)
		button.ToolTipLabel.Visible = true
	end
end
local hideToolTip
hideToolTip = function(button, _)
	if button and button:FindFirstChild("ToolTipLabel") and button.ToolTipLabel:IsA("TextLabel") then
		button.ToolTipLabel.Visible = false
	end
end
local removeFromInventory
removeFromInventory = function(child)
	for i = 1, #inventory do
		if inventory[i] == child then
			table.remove(inventory, i)
			inventory[i] = nil
		end
	end
end
local addingPlayerChild
addingPlayerChild = function(child, equipped, addToSlot, inventoryGearButton)
	waitForDebounce()
	debounce = true
	if child:FindFirstChild("RobloxBuildTool") then
		debounce = false
		return
	end
	if not child:IsA("Tool") and not child:IsA("HopperBin") then
		debounce = false
		return
	end
	if not addToSlot then
		for i = 1, #gearSlots do
			if gearSlots[i] ~= "empty" and gearSlots[i].GearReference.Value == child then
				debounce = false
				return
			end
		end
	end
	local gearClone = currentLoadout.TempSlot:clone()
	gearClone.Name = child.Name
	gearClone.GearImage.Image = child.TextureId
	if gearClone.GearImage.Image == "" then
		gearClone.GearText.Text = child.Name
	end
	gearClone.GearReference.Value = child
	gearClone.MouseEnter:connect(function()
		if gearClone.GearReference and gearClone.GearReference.Value["ToolTip"] and gearClone.GearReference.Value.ToolTip ~= "" then
			return showToolTip(gearClone, gearClone.GearReference.Value.ToolTip)
		end
	end)
	gearClone.MouseLeave:connect(function()
		if gearClone.GearReference and gearClone.GearReference.Value["ToolTip"] and gearClone.GearReference.Value.ToolTip ~= "" then
			return hideToolTip(gearClone, gearClone.GearReference.Value.ToolTip)
		end
	end)
	gearClone.RobloxLocked = true
	local slotToMod = -1
	if not addToSlot then
		for i = 1, #gearSlots do
			if gearSlots[i] == "empty" then
				slotToMod = i
				break
			end
		end
	else
		slotToMod = addToSlot
	end
	if slotToMod == -1 then
		debounce = false
		return
	end
	local slotNum = slotToMod % 10
	local parent = currentLoadout:FindFirstChild("Slot" .. tostring(slotNum))
	gearClone.Parent = parent
	if inventoryGearButton then
		local absolutePositionFinal = inventoryGearButton.AbsolutePosition
		local currentAbsolutePosition = gearClone.AbsolutePosition
		local diff = absolutePositionFinal - currentAbsolutePosition
		gearClone.Position = UDim2.new(gearClone.Position.X.Scale, diff.x, gearClone.Position.Y.Scale, diff.y)
		gearClone.ZIndex = 4
	end
	reorganizeLoadout(gearClone, (function()
		if addToSlot then
			return true, equipped, addToSlot
		else
			return true
		end
	end)())
	if not (gearClone.Parent ~= nil) then
		debounce = false
		return
	end
	if equipped then
		gearClone.Selected = true
		unequipAllItems(child)
		delay(guiTweenSpeed + 0.01, function()
			if gearClone:FindFirstChild("GearReference") and ((gearClone.GearReference.Value:IsA("Tool") and gearClone.GearReference.Value.Parent == player.Character) or (gearClone.GearReference.Value:IsA("HopperBin") and gearClone.GearReference.Value.Active == true)) then
				return enlargeButton(gearClone)
			end
		end)
	end
	local dragBeginPos
	local clickCon, buttonDeleteCon, mouseEnterCon, mouseLeaveCon, dragStop, dragBegin
	clickCon = gearClone.MouseButton1Click:connect(function()
		if characterInWorkspace() then
			if not gearClone.Draggable then
				return activateGear(gearClone.SlotNumber.Text)
			end
		end
	end)
	mouseEnterCon = gearClone.MouseEnter:connect(function()
		if guiBackpack.Visible then
			gearClone.Draggable = true
		end
	end)
	dragBegin = gearClone.DragBegin:connect(function(pos)
		dragBeginPos = pos
		gearClone.ZIndex = 7
		local children = gearClone:GetChildren()
		for i = 1, #children do
			if children[i]:IsA("TextLabel") then
				if string.find(children[i].Name, "Shadow") then
					children[i].ZIndex = 8
				else
					children[i].ZIndex = 9
				end
			elseif children[i]:IsA("Frame") or children[i]:IsA("ImageLabel") then
				children[i].ZIndex = 7
			end
		end
	end)
	dragStop = gearClone.DragStopped:connect(function(x, y)
		if gearClone.Selected then
			gearClone.ZIndex = 4
		else
			gearClone.ZIndex = 3
		end
		local children = gearClone:GetChildren()
		for i = 1, #children do
			if children[i]:IsA("TextLabel") then
				if string.find(children[i].Name, "Shadow") then
					children[i].ZIndex = 3
				else
					children[i].ZIndex = 4
				end
			elseif children[i]:IsA("Frame") or children[i]:IsA("ImageLabel") then
				children[i].ZIndex = 2
			end
		end
		return resolveDrag(gearClone, x, y)
	end)
	mouseLeaveCon = gearClone.MouseLeave:connect(function()
		gearClone.Draggable = false
	end)
	buttonDeleteCon = gearClone.AncestryChanged:connect(function()
		if gearClone.Parent and gearClone.Parent.Parent == currentLoadout then
			return
		end
		if clickCon ~= nil then
			clickCon:disconnect()
		end
		if buttonDeleteCon ~= nil then
			buttonDeleteCon:disconnect()
		end
		if mouseEnterCon ~= nil then
			mouseEnterCon:disconnect()
		end
		if mouseLeaveCon ~= nil then
			mouseLeaveCon:disconnect()
		end
		if dragStop ~= nil then
			dragStop:disconnect()
		end
		if dragBegin ~= nil then
			return dragBegin:disconnect()
		end
		return nil
	end)
	local childCon
	local childChangeCon
	childCon = child.AncestryChanged:connect(function(newChild, parent)
		if not checkToolAncestry(newChild, parent) then
			if childCon ~= nil then
				childCon:disconnect()
			end
			if childChangeCon ~= nil then
				childChangeCon:disconnect()
			end
			return removeFromInventory(child)
		elseif parent == game.Players.LocalPlayer.Backpack then
			return normalizeButton(gearClone)
		end
	end)
	childChangeCon = child.Changed:connect(function(prop)
		if prop == "Name" then
			if gearClone and gearClone.GearImage.Image == "" then
				gearClone.GearText.Text = child.Name
			end
		elseif prop == "Active" then
			if child and child:IsA("HopperBin") then
				if not child.Active then
					gearClone.Selected = false
					return normalizeButton(gearClone)
				end
			end
		elseif prop == "TextureId" then
			gearClone.GearImage.Image = child.TextureId
		end
	end)
	debounce = false
	return Spawn(function()
		while backpackIsOpen() do
			wait(0.03)
		end
		for i = 1, #gearSlots do
			if gearSlots[i] ~= "empty" then
				backpackButton.Position = UDim2.new(0.5, -60, 1, -108)
				if backpackEnabled then
					backpackButton.Visible = true
					clBackground.Visible = true
				end
			end
		end
	end)
end
local addToInventory
addToInventory = function(child)
	if not child:IsA("Tool") or not child:IsA("HopperBin") then
		return
	end
	local slot
	for i = 1, #inventory do
		if inventory[i] and inventory[i] == child then
			return
		end
		if not inventory[i] then
			slot = i
		end
	end
	if slot then
		inventory[slot] = child
	elseif #inventory < 1 then
		inventory[1] = child
	else
		inventory[#inventory + 1] = child
	end
end
local spreadOutGear
spreadOutGear = function()
	local loadoutChildren = currentLoadout:GetChildren()
	for i = 1, #loadoutChildren do
		if loadoutChildren[i]:IsA("Frame") then
			loadoutChildren[i].BackgroundTransparency = 0.5
			local slot = tonumber(string.sub(loadoutChildren[i].Name, 5))
			if slot == 0 then
				slot = 10
			end
			if robloxGui.AbsoluteSize.Y <= 320 then
				loadoutChildren[i]:TweenPosition(UDim2.new(0, (slot - 1) * 60, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
			else
				loadoutChildren[i]:TweenPosition(UDim2.new((slot - 1) / 10, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
			end
		end
	end
end
local centerGear
centerGear = function()
	local loadoutChildren = currentLoadout:GetChildren()
	local gearButtons = { }
	local lastSlotAdd
	for i = 1, #loadoutChildren do
		if loadoutChildren[i]:IsA("Frame") then
			if #loadoutChildren[i]:GetChildren() > 0 then
				if loadoutChildren[i].Name == "Slot0" then
					lastSlotAdd = loadoutChildren[i]
				else
					table.insert(gearButtons, loadoutChildren[i])
				end
			end
			loadoutChildren[i].BackgroundTransparency = 1
		end
	end
	if lastSlotAdd then
		table.insert(gearButtons, lastSlotAdd)
	end
	local startPos = (1 - (#gearButtons * 0.1)) / 2
	for i = 1, #gearButtons do
		if robloxGui.AbsoluteSize.Y <= 320 then
			startPos = 0.5 - (#gearButtons * 0.333) / 2
			gearButtons[i]:TweenPosition(UDim2.new(startPos + (i - 1) * 0.33, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
		else
			gearButtons[i]:TweenPosition(UDim2.new(startPos + ((i - 1) * 0.1), 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
		end
	end
end
local editLoadout
editLoadout = function()
	backpackWasOpened = true
	if inGearTab then
		return spreadOutGear()
	end
end
local readonlyLoadout
readonlyLoadout = function()
	if not inGearTab then
		return centerGear()
	end
end
local setupBackpackListener
setupBackpackListener = function()
	if backpackChildCon ~= nil then
		backpackChildCon:disconnect()
	end
	backpackChildCon = nil
	backpackChildCon = player.Backpack.ChildAdded:connect(function(child)
		if not firstInstanceOfLoadout then
			firstInstanceOfLoadout = true
			if backpackEnabled then
				backpackButton.Visible = true
				clBackground.Visible = true
			end
		end
		addingPlayerChild(child)
		return addToInventory(child)
	end)
end
local playerCharacterChildAdded
playerCharacterChildAdded = function(child)
	addingPlayerChild(child, true)
	return addToInventory(child)
end
local activateLoadout
activateLoadout = function()
	currentLoadout.Visible = true
end
local deactivateLoadout
deactivateLoadout = function()
	currentLoadout.Visible = false
end
local tabHandler
tabHandler = function(inFocus)
	inGearTab = inFocus
	if inFocus then
		return editLoadout()
	else
		return readonlyLoadout()
	end
end
local coreGuiChanged
coreGuiChanged = function(coreGuiType, enabled)
	if coreGuiType == Enum.CoreGuiType.Backpack or coreGuiType == Enum.CoreGuiType.All then
		backpackButton.Visible = enabled
		clBackground.Visible = enabled
		backpackEnabled = enabled
		if enabled then
			registerNumberKeys()
		else
			unregisterNumberKeys()
		end
	end
	if coreGuiType == Enum.CoreGuiType.Health or coreGuiType == Enum.CoreGuiType.All then
		return setHealthBarVisible(game.Players.LocalPlayer.PlayerGui, enabled)
	end
end
registerNumberKeys()
pcall(function()
	coreGuiChanged(Enum.CoreGuiType.Backpack, Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
	coreGuiChanged(Enum.CoreGuiType.Health, Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health))
	return Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)
wait()
waitForChild(player, "Backpack")
waitForProperty(player, "Character")
delay(1, function()
	local backpackChildren = player.Backpack:GetChildren()
	local size = math.min(10, #backpackChildren)
	for i = 1, size do
		if backpackEnabled then
			backpackButton.Visible = true
			clBackground.Visible = true
		end
		addingPlayerChild(backpackChildren[i], false)
	end
	return setupBackpackListener()
end)
delay(2, function()
	if not backpackWasOpened then
		if robloxGui.AbsoluteSize.Y <= 320 then
			local cChildren = currentLoadout:GetChildren()
			for i = 1, #cChildren do
				local slotNum = tonumber(string.sub(cChildren[i].Name, 5, string.len(cChildren[i].Name)))
				if type(slotNum) == "number" then
					cChildren[i].Position = UDim2.new(0, (slotNum - 1) * 60, 0, 0)
				end
			end
		end
	end
	return wait(0.25)
end)
player.ChildAdded:connect(function(child)
	if child:IsA("PlayerGui") then
		return moveHealthBar(child)
	end
end)
waitForProperty(player, "Character")
for _, v in ipairs(player.Character:GetChildren()) do
	playerCharacterChildAdded(v)
end
characterChildAddedCon = player.Character.ChildAdded:connect(function(child)
	return playerCharacterChildAdded(child)
end)
waitForChild(player.Character, "Humanoid")
local humanoidDiedCon = player.Character.Humanoid.Died:connect(function()
	do
		local _obj_0 = humanoidDiedCon
		if _obj_0 ~= nil then
			_obj_0:disconnect()
		end
	end
	humanoidDiedCon = nil
	deactivateLoadout()
	if backpackChildCon ~= nil then
		backpackChildCon:disconnect()
	end
	backpackChildCon = nil
	backpackWasOpened = false
end)
player.CharacterRemoving:connect(function()
	for i = 1, #gearSlots do
		if gearSlots[i] ~= "empty" then
			gearSlots[i].Parent = nil
			gearSlots[i] = "empty"
		end
	end
end)
player.CharacterAdded:connect(function()
	waitForProperty(game.Players, "LocalPlayer")
	player = game.Players.LocalPlayer
	waitForChild(player, "Backpack")
	delay(1, function()
		local backpackChildren = player.Backpack:GetChildren()
		local size = math.min(10, #backpackChildren)
		for i = 1, size do
			if backpackEnabled then
				backpackButton.Visible = true
				clBackground.Visible = true
			end
			addingPlayerChild(backpackChildren[i], false)
		end
		return setupBackpackListener()
	end)
	activateLoadout()
	if characterChildAddedCon ~= nil then
		characterChildAddedCon:disconnect()
	end
	characterChildAddedCon = player.Character.ChildAdded:connect(function(child)
		return addingPlayerChild(child, true)
	end)
	waitForChild(player.Character, "Humanoid")
	if backpack.Visible then
		backpackOpenEvent:Fire()
	end
	humanoidDiedCon = player.Character.Humanoid.Died:connect(function()
		if backpackEnabled then
			backpackButton.Visible = false
			clBackground.Visible = false
		end
		firstInstanceOfLoadout = false
		deactivateLoadout()
		if humanoidDiedCon ~= nil then
			humanoidDiedCon:disconnect()
		end
		humanoidDiedCon = nil
		if backpackChildCon ~= nil then
			backpackChildCon:disconnect()
		end
		backpackChildCon = nil
	end)
	waitForChild(player, "PlayerGui")
	moveHealthBar(player.PlayerGui)
	return delay(2, function()
		if (not backpackWasOpened) and (robloxGui.AbsoluteSize.Y <= 320) then
			local cChildren = currentLoadout:GetChildren()
			for i = 1, #cChildren do
				local slotNum = tonumber(string.sub(cChildren[i].Name, 5, string.len(cChildren[i].Name)))
				if type(slotNum) == "number" then
					cChildren[i].Position = UDim2.new(0, (slotNum - 1) * 60, 0, 0)
				end
			end
		end
		return wait(0.25)
	end)
end)
waitForChild(guiBackpack, "SwapSlot")
guiBackpack.SwapSlot.Changed:connect(function()
	if guiBackpack.SwapSlot.Value then
		local swapSlot = guiBackpack.SwapSlot
		local pos = swapSlot.Slot.Value
		if pos == 0 then
			pos = 10
		end
		if gearSlots[pos] then
			reorganizeLoadout(gearSlots[pos], false)
		end
		if swapSlot.GearButton.Value then
			addingPlayerChild(swapSlot.GearButton.Value.GearReference.Value, false, pos)
		end
		guiBackpack.SwapSlot.Value = false
	end
end)
game:GetService("GuiService").KeyPressed:connect(function(key)
	if characterInWorkspace() then
		return activateGear(key)
	end
end)
backpackOpenEvent.Event:connect(editLoadout)
backpackCloseEvent.Event:connect(centerGear)
return tabClickedEvent.Event:connect(function(tabName)
	return tabHandler(tabName == StaticTabName)
end)
