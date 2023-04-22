local New
New = function(className, name, props)
	if not (props ~= nil) then
		props = name
		name = nil
	end
	local obj = New(className)
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
local waitForChild
waitForChild = function(instance, name)
	assert(instance)
	assert(name)
	while not instance:FindFirstChild(name) do
		print("Waiting for ...", instance, name)
		instance.ChildAdded:wait()
	end
	return instance:FindFirstChild(name)
end
local waitForProperty
waitForProperty = function(instance, property)
	assert(instance)
	assert(property)
	while not instance[property] do
		instance.Changed:wait()
	end
end
local IsTouchDevice
IsTouchDevice = function()
	local touchEnabled = false
pcall(function()
		touchEnabled = Game:GetService("UserInputService").TouchEnabled
	end)
	return touchEnabled
end
waitForChild(game, "Players")
waitForProperty(game.Players, "LocalPlayer")
local player = game.Players.LocalPlayer
local RbxGui, _
RbxGui, _ = LoadLibrary("RbxGui")
if not RbxGui then
	print("could not find RbxGui!")
	return
end
local StaticTabName = "gear"
local backpack = script.Parent
local backpackItems = { }
local buttons = { }
local debounce = false
local browsingMenu = false
local mouseEnterCons = { }
local mouseClickCons = { }
local characterChildAddedCon
local characterChildRemovedCon
local backpackAddCon
local playerBackpack = waitForChild(player, "Backpack")
waitForChild(backpack, "Tabs")
waitForChild(backpack, "Gear")
local gearPreview = waitForChild(backpack.Gear, "GearPreview")
local scroller = waitForChild(backpack.Gear, "GearGridScrollingArea")
local currentLoadout = waitForChild(backpack.Parent, "CurrentLoadout")
local grid = waitForChild(backpack.Gear, "GearGrid")
local gearButton = waitForChild(grid, "GearButton")
local swapSlot = waitForChild(script.Parent, "SwapSlot")
local backpackManager = waitForChild(script.Parent, "CoreScripts/BackpackScripts/BackpackManager")
local backpackOpenEvent = waitForChild(backpackManager, "BackpackOpenEvent")
local backpackCloseEvent = waitForChild(backpackManager, "BackpackCloseEvent")
local tabClickedEvent = waitForChild(backpackManager, "TabClickedEvent")
local resizeEvent = waitForChild(backpackManager, "ResizeEvent")
local searchRequestedEvent = waitForChild(backpackManager, "SearchRequestedEvent")
local tellBackpackReadyFunc = waitForChild(backpackManager, "BackpackReady")
local scrollFrame, scrollUp, scrollDown, recalculateScroll
scrollFrame, scrollUp, scrollDown, recalculateScroll = RbxGui.CreateScrollingFrame(nil, "grid", Vector2.new(6, 6))
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Parent = backpack.Gear.GearGrid
local scrollBar = New("Frame", "ScrollBar", {
	BackgroundTransparency = 0.9,
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	Size = UDim2.new(0, 17, 1, -36),
	Position = UDim2.new(0, 0, 0, 18),
	Parent = scroller
})
scrollDown.Position = UDim2.new(0, 0, 1, -17)
scrollUp.Parent = scroller
scrollDown.Parent = scroller
local scrollFrameLoadout, scrollUpLoadout, scrollDownLoadout, recalculateScrollLoadout
scrollFrameLoadout, scrollUpLoadout, scrollDownLoadout, recalculateScrollLoadout = RbxGui.CreateScrollingFrame()
scrollFrameLoadout.Position = UDim2.new(0, 0, 0, 0)
scrollFrameLoadout.Size = UDim2.new(1, 0, 1, 0)
scrollFrameLoadout.Parent = backpack.Gear.GearLoadouts.LoadoutsList
local LoadoutButton = New("TextButton", "LoadoutButton", {
	RobloxLocked = true,
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size14,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 32),
	Style = Enum.ButtonStyle.RobloxButton,
	Text = "Loadout #1",
	TextColor3 = Color3.new(1, 1, 1),
	Parent = scrollFrameLoadout
})
do
	local _with_0 = LoadoutButton:clone()
	_with_0.Text = "Loadout #2"
	_with_0.Parent = scrollFrameLoadout
end
do
	local _with_0 = LoadoutButton:clone()
	_with_0.Text = "Loadout #3"
	_with_0.Parent = scrollFrameLoadout
end
do
	local _with_0 = LoadoutButton:clone()
	_with_0.Text = "Loadout #4"
	_with_0.Parent = scrollFrameLoadout
end
New("Frame", "ScrollBarLoadout", {
	BackgroundTransparency = 0.9,
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	Size = UDim2.new(0, 17, 1, -36),
	Position = UDim2.new(0, 0, 0, 18),
	Parent = backpack.Gear.GearLoadouts.GearLoadoutsScrollingArea
})
scrollDownLoadout.Position = UDim2.new(0, 0, 1, -17)
scrollUpLoadout.Parent = backpack.Gear.GearLoadouts.GearLoadoutsScrollingArea
scrollDownLoadout.Parent = backpack.Gear.GearLoadouts.GearLoadoutsScrollingArea
local removeFromMap
removeFromMap = function(map, object)
	for i = 1, #map do
		if map[i] == object then
			table.remove(map, i)
			break
		end
	end
end
local robloxLock
robloxLock = function(instance)
	instance.RobloxLocked = true
	local children = instance:GetChildren()
	if children then
		for _, child in ipairs(children) do
			robloxLock(child)
		end
	end
end
local clearPreview
clearPreview = function()
	gearPreview.GearImage.Image = ""
	gearPreview.GearStats.GearName.Text = ""
end
local clearHighlight
clearHighlight = function(button)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.new(0, 0, 0)
end
local inLoadout
inLoadout = function(gear)
	local children = currentLoadout:GetChildren()
	for i = 1, #children do
		if children[i]:IsA("Frame") then
			local button = children[i]:GetChildren()
			if #button > 0 and button[1].GearReference.Value and button[1].GearReference.Value == gear then
				return true
			end
		end
	end
	return false
end
local updateGridActive
updateGridActive = function()
	for _, v in pairs(backpackItems) do
		if buttons[v] then
			local gear
			local gearRef = buttons[v]:FindFirstChild("GearReference")
			if gearRef then
				gear = gearRef.Value
			end
			if (not gear) or inLoadout(gear) then
				buttons[v].Active = false
			else
				buttons[v].Active = true
			end
		end
	end
end
local swapGearSlot
swapGearSlot = function(slot, gearButton)
	if not swapSlot.Value then
		swapSlot.Slot.Value = slot
		swapSlot.GearButton.Value = gearButton
		swapSlot.Value = true
		return updateGridActive()
	end
end
local unequipGear
unequipGear = function(physGear)
	physGear.Parent = playerBackpack
	return updateGridActive()
end
local UnequipGearMenuClick
UnequipGearMenuClick = function(element, menu)
	if type(element.Action) ~= "number" then
		return
	end
	local num = element.Action
	if num == 1 then
		unequipGear(menu.Parent.GearReference.Value)
		local inventoryButton = menu.Parent
		local gearToUnequip = inventoryButton.GearReference.Value
		local loadoutChildren = currentLoadout:GetChildren()
		local slot = -1
		for i = 1, #loadoutChildren do
			if loadoutChildren[i]:IsA("Frame") then
				local button = loadoutChildren[i]:GetChildren()
				if button[1] and button[1].GearReference.Value == gearToUnequip then
					slot = button[1].SlotNumber.Text
					break
				end
			end
		end
		return swapGearSlot(slot, nil)
	end
end
local highlight
highlight = function(button)
	button.TextColor3 = Color3.new(0, 0, 0)
	button.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
end
local getGearContextMenu
getGearContextMenu = function()
	local gearContextMenu = New("Frame", "UnequipContextMenu", {
		Active = true,
		Size = UDim2.new(0, 115, 0, 70),
		Position = UDim2.new(0, -16, 0, -16),
		BackgroundTransparency = 1,
		Visible = false
	})
	local gearContextMenuButton = New("TextButton", "UnequipContextMenuButton", {
		Text = "",
		Style = Enum.ButtonStyle.RobloxButtonDefault,
		ZIndex = 8,
		Size = UDim2.new(1, 0, 1, -20),
		Visible = true,
		Parent = gearContextMenu
	})
	local elementHeight = 12
	local contextMenuElements = { }
	local contextMenuElementsName = {
		"Remove Hotkey"
	}
	for i = 1, #contextMenuElementsName do
		local element = { }
		element.Type = "Button"
		element.Text = contextMenuElementsName[i]
		element.Action = i
		element.DoIt = UnequipGearMenuClick
		table.insert(contextMenuElements, element)
	end
	for i, contextElement in ipairs(contextMenuElements) do
		local element = contextElement
		if element.Type == "Button" then
			local button = New("TextButton", "UnequipContextButton" .. tostring(i), {
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = " " .. tostring(contextElement.Text),
				Font = Enum.Font.Arial,
				FontSize = Enum.FontSize.Size14,
				Size = UDim2.new(1, 8, 0, elementHeight),
				Position = UDim2.new(0, 0, 0, elementHeight * i),
				TextColor3 = Color3.new(1, 1, 1),
				ZIndex = 9,
				Parent = gearContextMenuButton
			})
			if not IsTouchDevice() then
				button.MouseButton1Click:connect(function()
					if button.Active and not gearContextMenu.Parent.Active then
pcall(function()
							return element.DoIt(element, gearContextMenu)
						end)
						browsingMenu = false
						gearContextMenu.Visible = false
						clearHighlight(button)
						return clearPreview()
					end
				end)
				button.MouseEnter:connect(function()
					if button.Active and gearContextMenu.Parent.Active then
						return highlight(button)
					end
				end)
				button.MouseLeave:connect(function()
					if button.Active and gearContextMenu.Parent.Active then
						return clearHighlight(button)
					end
				end)
			end
			contextElement.Button = button
			contextElement.Element = button
		elseif element.Type == "Label" then
			local frame = New("Frame", "ContextLabel" .. tostring(i), {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 8, 0, elementHeight),
				New("TextLabel", "Text1", {
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = Enum.Font.ArialBold,
					FontSize = Enum.FontSize.Size14,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0.5, 0, 1, 0),
					TextColor3 = Color3.new(1, 1, 1),
					ZIndex = 9
				})
			})
			element.Label1 = frame.Text1
			if element.GetText2 then
				element.Label2 = New("TextLabel", "Text2", {
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Right,
					Font = Enum.Font.Arial,
					FontSize = Enum.FontSize.Size14,
					Position = UDim2.new(0.5, 0, 0, 0),
					Size = UDim2.new(0.5, 0, 1, 0),
					TextColor3 = Color3.new(1, 1, 1),
					ZIndex = 9,
					Parent = frame
				})
			end
			frame.Parent = gearContextMenuButton
			element.Label = frame
			element.Element = frame
		end
	end
	gearContextMenu.ZIndex = 4
	gearContextMenu.MouseLeave:connect(function()
		browsingMenu = false
		gearContextMenu.Visible = false
		return clearPreview()
	end)
	robloxLock(gearContextMenu)
	return gearContextMenu
end
local findEmptySlot
findEmptySlot = function()
	local smallestNum
	local loadout = currentLoadout:GetChildren()
	for i = 1, #loadout do
		if loadout[i]:IsA("Frame") and #loadout[i]:GetChildren() <= 0 then
			local frameNum = tonumber(string.sub(loadout[i].Name, 5))
			if frameNum == 0 then
				frameNum = 10
			end
			if not smallestNum or (smallestNum > frameNum) then
				smallestNum = frameNum
			end
		end
	end
	if smallestNum == 10 then
		smallestNum = 0
	end
	return smallestNum
end
local checkForSwap
checkForSwap = function(button, x, y)
	local loadoutChildren = currentLoadout:GetChildren()
	for i = 1, #loadoutChildren do
		if loadoutChildren[i]:IsA("Frame") and string.find(loadoutChildren[i].Name, "Slot") then
			if x >= loadoutChildren[i].AbsolutePosition.x and x <= (loadoutChildren[i].AbsolutePosition.x + loadoutChildren[i].AbsoluteSize.x) then
				if y >= loadoutChildren[i].AbsolutePosition.y and y <= (loadoutChildren[i].AbsolutePosition.y + loadoutChildren[i].AbsoluteSize.y) then
					local slot = tonumber(string.sub(loadoutChildren[i].Name, 5))
					swapGearSlot(slot, button)
					return true
				end
			end
		end
	end
	return false
end
local previewGear
previewGear = function(button)
	if not browsingMenu then
		gearPreview.Visible = false
		gearPreview.GearImage.Image = button.Image
		gearPreview.GearStats.GearName.Text = button.GearReference.Value.Name
	end
end
local buttonClick
buttonClick = function(button)
	if button:FindFirstChild("UnequipContextMenu" and not button.Active) then
		button.UnequipContextMenu.Visible = true
		browsingMenu = true
	end
end
local resizeGrid
resizeGrid = function()
	for _, v in pairs(backpackItems) do
		if not v:FindFirstChild("RobloxBuildTool") then
			if not buttons[v] then
				local buttonClone = gearButton:clone()
				buttonClone.Parent = grid.ScrollingFrame
				buttonClone.Visible = true
				buttonClone.Image = v.TextureId
				if buttonClone.Image == "" then
					buttonClone.GearText.Text = v.Name
				end
				buttonClone.GearReference.Value = v
				buttonClone.Draggable = true
				buttons[v] = buttonClone
				if not IsTouchDevice() then
					local unequipMenu = getGearContextMenu()
					unequipMenu.Visible = false
					unequipMenu.Parent = buttonClone
				end
				local beginPos
				buttonClone.DragBegin:connect(function(value)
					waitForChild(buttonClone, "Background")
					buttonClone["Background"].ZIndex = 10
					buttonClone.ZIndex = 10
					beginPos = value
				end)
				buttonClone.DragStopped:connect(function(x, y)
					waitForChild(buttonClone, "Background")
					buttonClone["Background"].ZIndex = 1
					buttonClone.ZIndex = 2
					if beginPos ~= buttonClone.Position then
						if not checkForSwap(buttonClone, x, y) then
							buttonClone:TweenPosition(beginPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
							buttonClone.Draggable = false
							return delay(0.5, function()
								buttonClone.Draggable = true
							end)
						else
							buttonClone.Position = beginPos
						end
					end
				end)
				local clickTime = tick()
				mouseEnterCons[buttonClone] = buttonClone.MouseEnter:connect(function()
					return previewGear(buttonClone)
				end)
				mouseClickCons[buttonClone] = buttonClone.MouseButton1Click:connect(function()
					local newClickTime = tick()
					if buttonClone.Active and (newClickTime - clickTime) < 0.5 then
						local slot = findEmptySlot()
						if slot then
							buttonClone.ZIndex = 1
							swapGearSlot(slot, buttonClone)
						end
					else
						buttonClick(buttonClone)
					end
					clickTime = newClickTime
				end)
			end
		end
	end
	return recalculateScroll()
end
local resize
resize = function()
	local size = 0.75 * (function()
		if gearPreview.AbsoluteSize.Y > gearPreview.AbsoluteSize.X then
			return gearPreview.AbsoluteSize.X
		else
			return gearPreview.AbsoluteSize.Y
		end
	end)()
	waitForChild(gearPreview, "GearImage")
	gearPreview.GearImage.Size = UDim2.new(0, size, 0, size)
	gearPreview.GearImage.Position = UDim2.new(0, gearPreview.AbsoluteSize.X / 2 - size / 2, 0.75, -size)
	return resizeGrid()
end
local addToGrid
addToGrid = function(child)
	if not child:IsA("Tool") and not child:IsA("HopperBin") then
		return
	end
	if child:FindFirstChild("RobloxBuildTool") then
		return
	end
	for _, v in pairs(backpackItems) do
		if v == child then
			return
		end
	end
	table.insert(backpackItems, child)
	local changeCon = child.Changed:connect(function(prop)
		if prop == "Name" and buttons[child] and buttons[child].Image == "" then
			buttons[child].GearText.Text = child.Name
		end
	end)
	local ancestryCon = child.AncestryChanged:connect(function(_, _)
		local thisObject
		for _, v in pairs(backpackItems) do
			if v == child then
				thisObject = v
				break
			end
		end
		waitForProperty(player, "Character")
		waitForChild(player, "Backpack")
		if child.Parent ~= player.Backpack and child.Parent ~= player.Character then
			do
				local _obj_0 = ancestryCon
				if _obj_0 ~= nil then
					_obj_0:disconnect()
				end
			end
			if changeCon ~= nil then
				changeCon:disconnect()
			end
			for _, v in pairs(backpackItems) do
				if v == thisObject then
					do
						local _obj_0 = mouseEnterCons[buttons[v]]
						if _obj_0 ~= nil then
							_obj_0:disconnect()
						end
					end
					do
						local _obj_0 = mouseClickCons[buttons[v]]
						if _obj_0 ~= nil then
							_obj_0:disconnect()
						end
					end
					buttons[v].Parent = nil
					buttons[v] = nil
					break
				end
			end
			removeFromMap(backpackItems, thisObject)
			resizeGrid()
		else
			resizeGrid()
		end
		return updateGridActive()
	end)
	return resizeGrid()
end
local showPartialGrid
showPartialGrid = function(subset)
	for _, v in pairs(buttons) do
		v.Parent = nil
	end
	if subset then
		for _, v in pairs(subset) do
			v.Parent = grid.ScrollingFrame
		end
	end
	return recalculateScroll()
end
local showEntireGrid
showEntireGrid = function()
	for _, v in pairs(buttons) do
		v.Parent = grid.ScrollingFrame
	end
	return recalculateScroll()
end
local centerGear
centerGear = function(loadoutChildren)
	local gearButtons = { }
	local lastSlotAdd
	for i = 1, #loadoutChildren do
		if loadoutChildren[i]:IsA("Frame") and #loadoutChildren[i]:GetChildren() > 0 then
			if loadoutChildren[i].Name == "Slot0" then
				lastSlotAdd = loadoutChildren[i]
			else
				table.insert(gearButtons, loadoutChildren[i])
			end
		end
	end
	if lastSlotAdd then
		table.insert(gearButtons, lastSlotAdd)
	end
	local startPos = (1 - (#gearButtons * 0.1)) / 2
	for i = 1, #gearButtons do
		gearButtons[i]:TweenPosition(UDim2.new(startPos + ((i - 1) * 0.1), 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
	end
end
local backpackOpenHandler
backpackOpenHandler = function(currentTab)
	if currentTab and currentTab ~= StaticTabName then
		backpack.Gear.Visible = false
		return
	end
	backpack.Gear.Visible = true
	updateGridActive()
	resizeGrid()
	resize()
	return tellBackpackReadyFunc:Invoke()
end
local backpackCloseHandler
backpackCloseHandler = function(currentTab)
	if currentTab and currentTab ~= StaticTabName then
		backpack.Gear.Visible = false
		return
	end
	backpack.Gear.Visible = false
	resizeGrid()
	resize()
	return tellBackpackReadyFunc:Invoke()
end
local tabClickHandler
tabClickHandler = function(tabName)
	if tabName == StaticTabName then
		return backpackOpenHandler(tabName)
	else
		return backpackCloseHandler(tabName)
	end
end
local loadoutCheck
loadoutCheck = function(child, selectState)
	if not child:IsA("ImageButton") then
		return
	end
	for _, v in pairs(backpackItems) do
		if buttons[v] then
			if child:FindFirstChild("GearReference" and buttons[v]:FindFirstChild("GearReference")) then
				if buttons[v].GearReference.Value == child.GearReference.Value then
					buttons[v].Active = selectState
					break
				end
			end
		end
	end
end
local setupCharacterConnections
setupCharacterConnections = function()
	if backpackAddCon ~= nil then
		backpackAddCon:disconnect()
	end
	backpackAddCon = game.Players.LocalPlayer.Backpack.ChildAdded:connect(function(child)
		return addToGrid(child)
	end)
	local backpackChildren = game.Players.LocalPlayer.Backpack:GetChildren()
	for i = 1, #backpackChildren do
		addToGrid(backpackChildren[i])
	end
	if characterChildAddedCon ~= nil then
		characterChildAddedCon:disconnect()
	end
	characterChildAddedCon = game.Players.LocalPlayer.Character.ChildAdded:connect(function(child)
		addToGrid(child)
		return updateGridActive()
	end)
	if characterChildRemovedCon ~= nil then
		characterChildRemovedCon:disconnect()
	end
	characterChildRemovedCon = game.Players.LocalPlayer.Character.ChildRemoved:connect(function(_)
		return updateGridActive()
	end)
	wait()
	return centerGear(currentLoadout:GetChildren())
end
local removeCharacterConnections
removeCharacterConnections = function()
	if characterChildAddedCon ~= nil then
		characterChildAddedCon:disconnect()
	end
	if characterChildRemovedCon ~= nil then
		characterChildRemovedCon:disconnect()
	end
	if backpackAddCon ~= nil then
		return backpackAddCon:disconnect()
	end
	return nil
end
local trim
trim = function(s)
	return s:gsub("^%s*(.-)%s*$", "%1")
end
local filterGear
filterGear = function(terms)
	local filteredGear = { }
	for _, v in pairs(backpackItems) do
		if buttons[v] then
			local gearString = string.lower(buttons[v].GearReference.Value.Name)
			gearString = trim(gearString)
			for i = 1, #terms do
				if string.match(gearString, terms[i]) then
					table.insert(filteredGear, buttons[v])
					break
				end
			end
		end
	end
	return filteredGear
end
local splitByWhitespace
splitByWhitespace = function(text)
	if type(text) ~= "string" then
		return
	end
	local terms = { }
	for token in string.gmatch(text, "[^%s]+") do
		if string.len(token) > 0 then
			table.insert(terms, token)
		end
	end
	return terms
end
local showSearchGear
showSearchGear = function(searchTerms)
	if not backpack.Gear.Visible then
		return
	end
	local searchTermTable = splitByWhitespace(searchTerms)
	local currSearchTerms
	if searchTermTable and (#searchTermTable > 0) then
		currSearchTerms = searchTermTable
	else
		currSearchTerms = nil
	end
	if not (searchTermTable ~= nil) then
		showEntireGrid()
		return
	end
	local filteredButtons = filterGear(currSearchTerms)
	return showPartialGrid(filteredButtons)
end
local nukeBackpack
nukeBackpack = function()
	while #buttons > 0 do
		table.remove(buttons)
	end
	buttons = { }
	while #backpackItems > 0 do
		table.remove(backpackItems)
	end
	backpackItems = { }
	local scrollingFrameChildren = grid.ScrollingFrame:GetChildren()
	for i = 1, #scrollingFrameChildren do
		scrollingFrameChildren[i]:remove()
	end
end
local coreGuiChanged
coreGuiChanged = function(coreGuiType, enabled)
	if coreGuiType == Enum.CoreGuiType.Backpack or coreGuiType == Enum.CoreGuiType.All then
		if not enabled then
			backpack.Gear.Visible = false
		end
	end
end
local backpackChildren = player.Backpack:GetChildren()
for i = 1, #backpackChildren do
	addToGrid(backpackChildren[i])
end
resizeEvent.Event:connect(function(_)
	if debounce then
		return
	end
	debounce = true
	wait()
	resize()
	resizeGrid()
	debounce = false
end)
currentLoadout.ChildAdded:connect(function(child)
	return loadoutCheck(child, false)
end)
currentLoadout.ChildRemoved:connect(function(child)
	return loadoutCheck(child, true)
end)
currentLoadout.DescendantAdded:connect(function(descendant)
	if not backpack.Visible and (descendant:IsA("ImageButton") or descendant:IsA("TextButton")) then
		return centerGear(currentLoadout:GetChildren())
	end
end)
currentLoadout.DescendantRemoving:connect(function(descendant)
	if not backpack.Visible and (descendant:IsA("ImageButton") or descendant:IsA("TextButton")) then
		wait()
		return centerGear(currentLoadout:GetChildren())
	end
end)
grid.MouseEnter:connect(function()
	return clearPreview()
end)
grid.MouseLeave:connect(function()
	return clearPreview()
end)
player.CharacterRemoving:connect(function()
	removeCharacterConnections()
	return nukeBackpack()
end)
player.CharacterAdded:connect(function()
	return setupCharacterConnections()
end)
player.ChildAdded:connect(function(child)
	if child:IsA("Backpack") then
		playerBackpack = child
		if backpackAddCon ~= nil then
			backpackAddCon:disconnect()
		end
		backpackAddCon = game.Players.LocalPlayer.Backpack.ChildAdded:connect(function(child)
			return addToGrid(child)
		end)
	end
end)
swapSlot.Changed:connect(function()
	if not swapSlot.Value then
		return updateGridActive()
	end
end)
local loadoutChildren = currentLoadout:GetChildren()
for i = 1, #loadoutChildren do
	if loadoutChildren[i]:IsA("Frame") and string.find(loadoutChildren[i].Name, "Slot") then
		loadoutChildren[i].ChildRemoved:connect(function()
			return updateGridActive()
		end)
		loadoutChildren[i].ChildAdded:connect(function()
			return updateGridActive()
		end)
	end
end
pcall(function()
	coreGuiChanged(Enum.CoreGuiType.Backpack, Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
	return Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)
resize()
resizeGrid()
loadoutChildren = currentLoadout:GetChildren()
for i = 1, #loadoutChildren do
	loadoutCheck(loadoutChildren[i], false)
end
if not backpack.Visible then
	centerGear(currentLoadout:GetChildren())
end
if not (characterChildAddedCon ~= nil) and game.Players.LocalPlayer["Character"] then
	setupCharacterConnections()
end
if not backpackAddCon then
	backpackAddCon = game.Players.LocalPlayer.Backpack.ChildAdded:connect(function(child)
		return addToGrid(child)
	end)
end
backpackOpenEvent.Event:connect(backpackOpenHandler)
backpackCloseEvent.Event:connect(backpackCloseHandler)
tabClickedEvent.Event:connect(tabClickHandler)
searchRequestedEvent.Event:connect(showSearchGear)
return recalculateScrollLoadout()
