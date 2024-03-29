-- CoreGui.RobloxGui.Backpack.CoreScripts/BackpackScripts/Back (1?)
print "[Mercury]: Loaded corescript 89449008"

local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate

-- A couple of necessary functions
local function waitForChild(instance: Instance, name: string)
	while not instance:FindFirstChild(name) do
		print("Waiting for ...", instance, name)
		instance.ChildAdded:wait()
	end
	return instance:FindFirstChild(name)
end
local function waitForProperty(instance: Instance, property: string)
	while not instance[property] do
		instance.Changed:wait()
	end
end

local function IsTouchDevice()
	local touchEnabled = false
	pcall(function()
		touchEnabled = Game:GetService("UserInputService").TouchEnabled
	end)
	return touchEnabled
end

waitForChild(game, "Players")
waitForProperty(game.Players, "LocalPlayer")
local player = game.Players.LocalPlayer

local RbxGui, _ = LoadLibrary "RbxGui"
if not RbxGui then
	print "could not find RbxGui!"
	return
end

--- Begin Locals
local StaticTabName = "gear"

local backpack = script.Parent

local backpackItems: { Tool | HopperBin } = {}
local buttons = {}

local debounce = false
local browsingMenu = false

local mouseEnterCons = {}
local mouseClickCons = {}

local characterChildAddedCon, characterChildRemovedCon, backpackAddCon

local playerBackpack = waitForChild(player, "Backpack")

waitForChild(backpack, "Tabs")

waitForChild(backpack, "Gear")
local gearPreview = waitForChild(backpack.Gear, "GearPreview")

local scroller = waitForChild(backpack.Gear, "GearGridScrollingArea")

local currentLoadout = waitForChild(backpack.Parent, "CurrentLoadout")

local grid = waitForChild(backpack.Gear, "GearGrid")
local gearButton = waitForChild(grid, "GearButton")

local swapSlot = waitForChild(script.Parent, "SwapSlot")

local backpackManager =
	waitForChild(script.Parent, "CoreScripts/BackpackScripts/BackpackManager")
local backpackOpenEvent = waitForChild(backpackManager, "BackpackOpenEvent")
local backpackCloseEvent = waitForChild(backpackManager, "BackpackCloseEvent")
local tabClickedEvent = waitForChild(backpackManager, "TabClickedEvent")
local resizeEvent = waitForChild(backpackManager, "ResizeEvent")
local searchRequestedEvent =
	waitForChild(backpackManager, "SearchRequestedEvent")
local tellBackpackReadyFunc = waitForChild(backpackManager, "BackpackReady")

-- creating scroll bar early as to make sure items get placed correctly
local scrollFrame, scrollUp, scrollDown, recalculateScroll =
	RbxGui.CreateScrollingFrame(nil, "grid", Vector2.new(6, 6))

scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Parent = backpack.Gear.GearGrid

local scrollBar = Instance.new "Frame"
scrollBar.Name = "ScrollBar"
scrollBar.BackgroundTransparency = 0.9
scrollBar.BackgroundColor3 = Color3.new(1, 1, 1)
scrollBar.BorderSizePixel = 0
scrollBar.Size = UDim2.new(0, 17, 1, -36)
scrollBar.Position = UDim2.new(0, 0, 0, 18)
scrollBar.Parent = scroller

scrollDown.Position = UDim2.new(0, 0, 1, -17)

scrollUp.Parent = scroller
scrollDown.Parent = scroller

local scrollFrameLoadout, scrollUpLoadout, scrollDownLoadout, recalculateScrollLoadout =
	RbxGui.CreateScrollingFrame()

scrollFrameLoadout.Position = UDim2.new(0, 0, 0, 0)
scrollFrameLoadout.Size = UDim2.new(1, 0, 1, 0)
scrollFrameLoadout.Parent = backpack.Gear.GearLoadouts.LoadoutsList

for i = 1, 4 do
	New "TextButton" {
		RobloxLocked = true,
		Name = "LoadoutButton",
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size14,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 32),
		Style = Enum.ButtonStyle.RobloxButton,
		Text = "Loadout #" .. i,
		TextColor3 = Color3.new(1, 1, 1),
		Parent = scrollFrameLoadout,
	}
end

New "Frame" {
	Name = "ScrollBarLoadout",
	BackgroundTransparency = 0.9,
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	Size = UDim2.new(0, 17, 1, -36),
	Position = UDim2.new(0, 0, 0, 18),
	Parent = backpack.Gear.GearLoadouts.GearLoadoutsScrollingArea,
}

scrollDownLoadout.Position = UDim2.new(0, 0, 1, -17)

scrollUpLoadout.Parent = backpack.Gear.GearLoadouts.GearLoadoutsScrollingArea
scrollDownLoadout.Parent = backpack.Gear.GearLoadouts.GearLoadoutsScrollingArea

-- Begin Functions
local function removeFromMap(map, object)
	for i = 1, #map do
		if map[i] == object then
			table.remove(map, i)
			break
		end
	end
end

local function robloxLock(instance)
	instance.RobloxLocked = true
	local children = instance:GetChildren()
	if children then
		for _, child in ipairs(children) do
			robloxLock(child)
		end
	end
end

local function buttonClick(button)
	if button:FindFirstChild "UnequipContextMenu" and not button.Active then
		button.UnequipContextMenu.Visible = true
		browsingMenu = true
	end
end

local function previewGear(button)
	if not browsingMenu then
		gearPreview.Visible = false
		gearPreview.GearImage.Image = button.Image
		gearPreview.GearStats.GearName.Text = button.GearReference.Value.Name
	end
end

local function findEmptySlot()
	local smallestNum
	local loadout = currentLoadout:GetChildren()
	for i = 1, #loadout do
		if loadout[i]:IsA "Frame" and #loadout[i]:GetChildren() <= 0 then
			local frameNum = tonumber(string.sub(loadout[i].Name, 5))
			if frameNum == 0 then
				frameNum = 10
			end
			if not smallestNum or (smallestNum > frameNum) then
				smallestNum = frameNum
			end
		end
	end
	return smallestNum == 10 and 0 or smallestNum
end

local function inLoadout(gear)
	local children = currentLoadout:GetChildren()
	for i = 1, #children do
		if children[i]:IsA "Frame" then
			local button = children[i]:GetChildren()
			if
				#button > 0
				and button[1].GearReference.Value
				and button[1].GearReference.Value == gear
			then
				return true
			end
		end
	end
	return false
end

local function updateGridActive()
	for _, v in pairs(backpackItems) do
		if buttons[v] then
			local gear
			local gearRef = buttons[v]:FindFirstChild "GearReference"

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

local function swapGearSlot(slot, newGearButton)
	if not swapSlot.Value then -- signal loadout to swap a gear out
		swapSlot.Slot.Value = slot
		swapSlot.GearButton.Value = newGearButton
		swapSlot.Value = true
		updateGridActive()
	end
end

local function resizeGrid()
	for _, v in pairs(backpackItems) do
		if not v:FindFirstChild "RobloxBuildTool" then
			if not buttons[v] then
				local buttonClone = Hydrate(gearButton:clone()) {
					Parent = grid.ScrollingFrame,
					Visible = true,
					Image = v.TextureId,
				}
				if v.TextureId == "" then
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
					buttonClone.Background.ZIndex = 10
					buttonClone.ZIndex = 10
					beginPos = value
				end)
				buttonClone.DragStopped:connect(function(x, y)
					waitForChild(buttonClone, "Background")
					buttonClone.Background.ZIndex = 1
					buttonClone.ZIndex = 2
					if beginPos ~= buttonClone.Position then
						if not checkForSwap(buttonClone, x, y) then
							buttonClone:TweenPosition(
								beginPos,
								Enum.EasingDirection.Out,
								Enum.EasingStyle.Quad,
								0.5,
								true
							)
							buttonClone.Draggable = false
							delay(0.5, function()
								buttonClone.Draggable = true
							end)
						else
							buttonClone.Position = beginPos
						end
					end
				end)
				local clickTime = tick()
				mouseEnterCons[buttonClone] = buttonClone.MouseEnter:connect(
					function()
						previewGear(buttonClone)
					end
				)
				mouseClickCons[buttonClone] = buttonClone.MouseButton1Click:connect(
					function()
						local newClickTime = tick()
						if
							buttonClone.Active
							and (newClickTime - clickTime) < 0.5
						then
							local slot = findEmptySlot()
							if slot then
								buttonClone.ZIndex = 1
								swapGearSlot(slot, buttonClone)
							end
						else
							buttonClick(buttonClone)
						end
						clickTime = newClickTime
					end
				)
			end
		end
	end
	recalculateScroll()
end

local function resize()
	local size = gearPreview.AbsoluteSize.Y > gearPreview.AbsoluteSize.X
			and gearPreview.AbsoluteSize.X * 0.75
		or gearPreview.AbsoluteSize.Y * 0.75

	waitForChild(gearPreview, "GearImage")
	gearPreview.GearImage.Size = UDim2.new(0, size, 0, size)
	gearPreview.GearImage.Position =
		UDim2.new(0, gearPreview.AbsoluteSize.X / 2 - size / 2, 0.75, -size)

	resizeGrid()
end

local function addToGrid(child: Tool | HopperBin)
	if
		not (child:IsA "Tool" or child:IsA "HopperBin")
		or child:FindFirstChild "RobloxBuildTool"
	then
		return
	end

	for _, v in pairs(backpackItems) do -- check to see if we already have this gear registered
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
	local ancestryCon
	ancestryCon = child.AncestryChanged:connect(function()
		local thisObject
		for _, v in pairs(backpackItems) do
			if v == child then
				thisObject = v
				break
			end
		end

		waitForProperty(player, "Character")
		waitForChild(player, "Backpack")
		if
			child.Parent ~= player.Backpack
			and child.Parent ~= player.Character
		then
			if ancestryCon then
				ancestryCon:disconnect()
			end
			if changeCon then
				changeCon:disconnect()
			end

			for _, v in pairs(backpackItems) do
				if v == thisObject then
					if mouseEnterCons[buttons[v]] then
						mouseEnterCons[buttons[v]]:disconnect()
					end
					if mouseClickCons[buttons[v]] then
						mouseClickCons[buttons[v]]:disconnect()
					end
					buttons[v].Parent = nil
					buttons[v] = nil
					break
				end
			end

			removeFromMap(backpackItems, thisObject)
		end
		resizeGrid()
		updateGridActive()
	end)
	resizeGrid()
end

local function unequipGear(physGear)
	physGear.Parent = playerBackpack
	updateGridActive()
end

local function highlight(button)
	button.TextColor3 = Color3.new(0, 0, 0)
	button.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
end

local function clearHighlight(button)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.new(0, 0, 0)
end

function checkForSwap(button, x, y)
	local loadoutChildren = currentLoadout:GetChildren()
	for i = 1, #loadoutChildren do
		if
			loadoutChildren[i]:IsA "Frame"
			and string.find(loadoutChildren[i].Name, "Slot")
		then
			if
				x >= loadoutChildren[i].AbsolutePosition.x
				and x
					<= (loadoutChildren[i].AbsolutePosition.x + loadoutChildren[i].AbsoluteSize.x)
			then
				if
					y >= loadoutChildren[i].AbsolutePosition.y
					and y
						<= (loadoutChildren[i].AbsolutePosition.y + loadoutChildren[i].AbsoluteSize.y)
				then
					local slot =
						tonumber(string.sub(loadoutChildren[i].Name, 5))
					swapGearSlot(slot, button)
					return true
				end
			end
		end
	end
	return false
end

local UnequipGearMenuClick = function(element, menu)
	if type(element.Action) ~= "number" then
		return
	end
	local num = element.Action
	if num == 1 then -- remove from loadout
		unequipGear(menu.Parent.GearReference.Value)
		local inventoryButton = menu.Parent
		local gearToUnequip = inventoryButton.GearReference.Value
		local loadoutChildren = currentLoadout:GetChildren()
		local slot = -1
		for i = 1, #loadoutChildren do
			if loadoutChildren[i]:IsA "Frame" then
				local button = loadoutChildren[i]:GetChildren()
				if
					button[1]
					and button[1].GearReference.Value == gearToUnequip
				then
					slot = button[1].SlotNumber.Text
					break
				end
			end
		end
		swapGearSlot(slot, nil)
	end
end

local function clearPreview()
	gearPreview.GearImage.Image = ""
	gearPreview.GearStats.GearName.Text = ""
end

function getGearContextMenu()
	local gearContextMenu = New "Frame" {
		Active = true,
		Name = "UnequipContextMenu",
		Size = UDim2.new(0, 115, 0, 70),
		Position = UDim2.new(0, -16, 0, -16),
		BackgroundTransparency = 1,
		Visible = false,
	}

	local gearContextMenuButton = New "TextButton" {
		Name = "UnequipContextMenuButton",
		Text = "",
		Style = Enum.ButtonStyle.RobloxButtonDefault,
		ZIndex = 8,
		Size = UDim2.new(1, 0, 1, -20),
		Visible = true,
		Parent = gearContextMenu,
	}

	local elementHeight = 12

	local contextMenuElements = {}
	local contextMenuElementsName = { "Remove Hotkey" }

	for i = 1, #contextMenuElementsName do
		local element = {}
		element.Type = "Button"
		element.Text = contextMenuElementsName[i]
		element.Action = i
		element.DoIt = UnequipGearMenuClick
		table.insert(contextMenuElements, element)
	end

	for i, contextElement in ipairs(contextMenuElements) do
		local element = contextElement
		if element.Type == "Button" then
			local button = New "TextButton" {
				Name = "UnequipContextButton" .. i,
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = ` {contextElement.Text}`,
				Font = Enum.Font.Arial,
				FontSize = Enum.FontSize.Size14,
				Size = UDim2.new(1, 8, 0, elementHeight),
				Position = UDim2.new(0, 0, 0, elementHeight * i),
				TextColor3 = Color3.new(1, 1, 1),
				ZIndex = 9,
				Parent = gearContextMenuButton,
			}

			if not IsTouchDevice() then
				button.MouseButton1Click:connect(function()
					if button.Active and not gearContextMenu.Parent.Active then
						pcall(function()
							element.DoIt(element, gearContextMenu)
						end)
						browsingMenu = false
						gearContextMenu.Visible = false
						clearHighlight(button)
						clearPreview()
					end
				end)

				button.MouseEnter:connect(function()
					if button.Active and gearContextMenu.Parent.Active then
						highlight(button)
					end
				end)
				button.MouseLeave:connect(function()
					if button.Active and gearContextMenu.Parent.Active then
						clearHighlight(button)
					end
				end)
			end

			contextElement.Button = button
			contextElement.Element = button
		elseif element.Type == "Label" then
			local frame = Instance.new "Frame"
			frame.Name = `ContextLabel{i}`
			frame.BackgroundTransparency = 1
			frame.Size = UDim2.new(1, 8, 0, elementHeight)

			element.Label1 = New "TextLabel" {
				Name = "Text1",
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.ArialBold,
				FontSize = Enum.FontSize.Size14,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0.5, 0, 1, 0),
				TextColor3 = Color3.new(1, 1, 1),
				ZIndex = 9,
				Parent = frame,
			}

			if element.GetText2 then
				element.Label2 = New "TextLabel" {
					Name = "Text2",
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
					Parent = frame,
				}
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
		clearPreview()
	end)
	robloxLock(gearContextMenu)

	return gearContextMenu
end

local function showPartialGrid(subset)
	for _, v in pairs(buttons) do
		v.Parent = nil
	end
	if subset then
		for _, v in pairs(subset) do
			v.Parent = grid.ScrollingFrame
		end
	end
	recalculateScroll()
end

local function showEntireGrid()
	for _, v in pairs(buttons) do
		v.Parent = grid.ScrollingFrame
	end
	recalculateScroll()
end

local function centerGear(loadoutChildren)
	local gearButtons = {}
	local lastSlotAdd
	for i = 1, #loadoutChildren do
		if
			loadoutChildren[i]:IsA "Frame"
			and #loadoutChildren[i]:GetChildren() > 0
		then
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
		gearButtons[i]:TweenPosition(
			UDim2.new(startPos + ((i - 1) * 0.1), 0, 0, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.25,
			true
		)
	end
end

local function backpackOpenHandler(currentTab)
	if currentTab and currentTab ~= StaticTabName then
		backpack.Gear.Visible = false
		return
	end

	backpack.Gear.Visible = true
	updateGridActive()

	resizeGrid()
	resize()
	tellBackpackReadyFunc:Invoke()
end

local function backpackCloseHandler(currentTab)
	if currentTab and currentTab ~= StaticTabName then
		backpack.Gear.Visible = false
		return
	end

	backpack.Gear.Visible = false

	resizeGrid()
	resize()
	tellBackpackReadyFunc:Invoke()
end

local function tabClickHandler(tabName)
	if tabName == StaticTabName then
		backpackOpenHandler(tabName)
	else
		backpackCloseHandler(tabName)
	end
end

local function loadoutCheck(
	child: Instance & {
		GearReference: ObjectValue,
	},
	selectState
)
	if not child:IsA "ImageButton" then
		return
	end
	for _, v in pairs(backpackItems) do
		if buttons[v] then
			if
				child:FindFirstChild "GearReference"
				and buttons[v]:FindFirstChild "GearReference"
				and buttons[v].GearReference.Value
					== child.GearReference.Value
			then
				buttons[v].Active = selectState
				break
			end
		end
	end
end

-- local function removeAllEquippedGear(physGear)
-- 	local stuff = player.Character:GetChildren()
-- 	for i = 1, #stuff do
-- 		if
-- 			(stuff[i]:IsA "Tool" or stuff[i]:IsA "HopperBin")
-- 			and stuff[i] ~= physGear
-- 		then
-- 			stuff[i].Parent = playerBackpack
-- 		end
-- 	end
-- end

-- local function equipGear(physGear)
-- 	removeAllEquippedGear(physGear)
-- 	physGear.Parent = player.Character
-- 	updateGridActive()
-- end

local function setupCharacterConnections()
	if backpackAddCon then
		backpackAddCon:disconnect()
	end
	backpackAddCon = game.Players.LocalPlayer.Backpack.ChildAdded:connect(
		function(child)
			addToGrid(child)
		end
	)

	-- make sure we get all the children
	local backpackChildren = game.Players.LocalPlayer.Backpack:GetChildren()
	for i = 1, #backpackChildren do
		addToGrid(backpackChildren[i])
	end

	if characterChildAddedCon then
		characterChildAddedCon:disconnect()
	end
	characterChildAddedCon = game.Players.LocalPlayer.Character.ChildAdded:connect(
		function(child)
			addToGrid(child)
			updateGridActive()
		end
	)

	if characterChildRemovedCon then
		characterChildRemovedCon:disconnect()
	end
	characterChildRemovedCon = game.Players.LocalPlayer.Character.ChildRemoved:connect(
		function(_)
			updateGridActive()
		end
	)

	wait()
	centerGear(currentLoadout:GetChildren())
end

function removeCharacterConnections()
	if characterChildAddedCon then
		characterChildAddedCon:disconnect()
	end
	if characterChildRemovedCon then
		characterChildRemovedCon:disconnect()
	end
	if backpackAddCon then
		backpackAddCon:disconnect()
	end
end

local function trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function filterGear(terms)
	local filteredGear = {}
	for _, v in pairs(backpackItems) do
		local button = buttons[v]
		if button then
			local gearString = string.lower(button.GearReference.Value.Name)
			gearString = trim(gearString)
			for i = 1, #terms do
				if string.match(gearString, terms[i]) then
					table.insert(filteredGear, button)
					break
				end
			end
		end
	end

	return filteredGear
end

local function splitByWhitespace(text)
	if type(text) ~= "string" then
		return nil
	end

	local terms = {}
	for token in string.gmatch(text, "[^%s]+") do
		if string.len(token) > 0 then
			table.insert(terms, token)
		end
	end
	return terms
end

local function showSearchGear(searchTerms)
	if not backpack.Gear.Visible then
		return
	end -- currently not active tab

	local searchTermTable = splitByWhitespace(searchTerms)
	local currSearchTerms
	if searchTermTable and (#searchTermTable > 0) then
		currSearchTerms = searchTermTable
	else
		currSearchTerms = nil
	end

	if searchTermTable == nil then
		showEntireGrid()
		return
	end

	local filteredButtons = filterGear(currSearchTerms)
	showPartialGrid(filteredButtons)
end

local function nukeBackpack()
	while #buttons > 0 do
		table.remove(buttons)
	end
	buttons = {}
	while #backpackItems > 0 do
		table.remove(backpackItems)
	end
	backpackItems = {}
	local scrollingFrameChildren = grid.ScrollingFrame:GetChildren()
	for i = 1, #scrollingFrameChildren do
		scrollingFrameChildren[i]:remove()
	end
end

local function coreGuiChanged(coreGuiType, enabled)
	if
		coreGuiType == Enum.CoreGuiType.Backpack
		or coreGuiType == Enum.CoreGuiType.All
	then
		if not enabled then
			backpack.Gear.Visible = false
		end
	end
end

local backpackChildren = player.Backpack:GetChildren()
for i = 1, #backpackChildren do
	addToGrid(backpackChildren[i])
end

------------------------- Start Lifelong Connections -----------------------

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
	loadoutCheck(child, false)
end)
currentLoadout.ChildRemoved:connect(function(child)
	loadoutCheck(child, true)
end)

currentLoadout.DescendantAdded:connect(function(descendant)
	if
		not backpack.Visible
		and (descendant:IsA "ImageButton" or descendant:IsA "TextButton")
	then
		centerGear(currentLoadout:GetChildren())
	end
end)
currentLoadout.DescendantRemoving:connect(function(descendant)
	if
		not backpack.Visible
		and (descendant:IsA "ImageButton" or descendant:IsA "TextButton")
	then
		wait()
		centerGear(currentLoadout:GetChildren())
	end
end)

grid.MouseEnter:connect(function()
	clearPreview()
end)
grid.MouseLeave:connect(function()
	clearPreview()
end)

player.CharacterRemoving:connect(function()
	removeCharacterConnections()
	nukeBackpack()
end)
player.CharacterAdded:connect(function()
	setupCharacterConnections()
end)

player.ChildAdded:connect(function(child)
	if child:IsA "Backpack" then
		playerBackpack = child
		if backpackAddCon then
			backpackAddCon:disconnect()
		end
		backpackAddCon = game.Players.LocalPlayer.Backpack.ChildAdded:connect(
			function(child2)
				addToGrid(child2)
			end
		)
	end
end)

swapSlot.Changed:connect(function()
	if not swapSlot.Value then
		updateGridActive()
	end
end)

local loadoutChildren = currentLoadout:GetChildren()
for i = 1, #loadoutChildren do
	if
		loadoutChildren[i]:IsA "Frame"
		and string.find(loadoutChildren[i].Name, "Slot")
	then
		loadoutChildren[i].ChildRemoved:connect(function()
			updateGridActive()
		end)
		loadoutChildren[i].ChildAdded:connect(function()
			updateGridActive()
		end)
	end
end
------------------------- End Lifelong Connections -----------------------

pcall(function()
	coreGuiChanged(
		Enum.CoreGuiType.Backpack,
		Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
	)
	Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)

resize()
resizeGrid()

-- make sure any items in the loadout are accounted for in inventory
loadoutChildren = currentLoadout:GetChildren()
for i = 1, #loadoutChildren do
	loadoutCheck(loadoutChildren[i], false)
end
if not backpack.Visible then
	centerGear(currentLoadout:GetChildren())
end

-- make sure that inventory is listening to gear reparenting
if characterChildAddedCon == nil and game.Players.LocalPlayer.Character then
	setupCharacterConnections()
end
if not backpackAddCon then
	backpackAddCon = game.Players.LocalPlayer.Backpack.ChildAdded:connect(
		function(child)
			addToGrid(child)
		end
	)
end

backpackOpenEvent.Event:connect(backpackOpenHandler)
backpackCloseEvent.Event:connect(backpackCloseHandler)
tabClickedEvent.Event:connect(tabClickHandler)
searchRequestedEvent.Event:connect(showSearchGear)

recalculateScrollLoadout()
