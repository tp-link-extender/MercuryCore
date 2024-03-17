-- RbxGui
print "[Mercury]: Loaded corescript 45284430"

local New = require "../Modules/New"

local RbxGui = {}

local function ScopedConnect(
	parentInstance,
	instance,
	event,
	signalFunc,
	syncFunc,
	removeFunc
)
	local eventConnection

	--Connection on parentInstance is scoped by parentInstance (when destroyed, it goes away)
	local tryConnect = function()
		if game:IsAncestorOf(parentInstance) then
			--Entering the world, make sure we are connected/synced
			if not eventConnection then
				eventConnection = instance[event]:connect(signalFunc)
				if syncFunc then
					syncFunc()
				end
			end
		else
			--Probably leaving the world, so disconnect for now
			if eventConnection then
				eventConnection:disconnect()
				if removeFunc then
					removeFunc()
				end
			end
		end
	end

	--Hook it up to ancestryChanged signal
	local connection = parentInstance.AncestryChanged:connect(tryConnect)

	--Now connect us if we're already in the world
	tryConnect()

	return connection
end

local function getScreenGuiAncestor(instance)
	local localInstance = instance
	while localInstance and not localInstance:IsA "ScreenGui" do
		localInstance = localInstance.Parent
	end
	return localInstance
end

local function CreateButtons(frame, buttons, yPos, ySize)
	local buttonNum = 1
	local buttonObjs = {}
	for _, obj in ipairs(buttons) do
		local button = Instance.new "TextButton"
		button.Name = "Button" .. buttonNum
		button.Font = Enum.Font.Arial
		button.FontSize = Enum.FontSize.Size18
		button.AutoButtonColor = true
		button.Modal = true
		if obj.Style then
			button.Style = obj.Style
		else
			button.Style = Enum.ButtonStyle.RobloxButton
		end
		button.Text = obj.Text
		button.TextColor3 = Color3.new(1, 1, 1)
		button.MouseButton1Click:connect(obj.Function)
		button.Parent = frame
		buttonObjs[buttonNum] = button

		buttonNum += 1
	end
	local numButtons = buttonNum - 1

	if numButtons == 1 then
		frame.Button1.Position = UDim2.new(0.35, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(0.4, 0, ySize.Scale, ySize.Offset)
	elseif numButtons == 2 then
		frame.Button1.Position = UDim2.new(0.1, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(0.8 / 3, 0, ySize.Scale, ySize.Offset)

		frame.Button2.Position = UDim2.new(0.55, 0, yPos.Scale, yPos.Offset)
		frame.Button2.Size = UDim2.new(0.35, 0, ySize.Scale, ySize.Offset)
	elseif numButtons >= 3 then
		local spacing = 0.1 / numButtons
		local buttonSize = 0.9 / numButtons

		buttonNum = 1
		while buttonNum <= numButtons do
			buttonObjs[buttonNum].Position = UDim2.new(
				spacing * buttonNum + (buttonNum - 1) * buttonSize,
				0,
				yPos.Scale,
				yPos.Offset
			)
			buttonObjs[buttonNum].Size =
				UDim2.new(buttonSize, 0, ySize.Scale, ySize.Offset)
			buttonNum += 1
		end
	end
end

local function setSliderPos(newAbsPosX, slider, sliderPosition, bar, steps)
	local newStep = steps - 1 --otherwise we really get one more step than we want
	local relativePosX = math.min(
		1,
		math.max(0, (newAbsPosX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
	)
	local wholeNum, remainder = math.modf(relativePosX * newStep)
	if remainder > 0.5 then
		wholeNum += 1
	end
	relativePosX = wholeNum / newStep

	local result = math.ceil(relativePosX * newStep)
	if sliderPosition.Value ~= (result + 1) then --only update if we moved a step
		sliderPosition.Value = result + 1
		slider.Position = UDim2.new(
			relativePosX,
			-slider.AbsoluteSize.X / 2,
			slider.Position.Y.Scale,
			slider.Position.Y.Offset
		)
	end
end

local areaSoakMouseMoveCon

local function cancelSlide(areaSoak)
	areaSoak.Visible = false
	if areaSoakMouseMoveCon then
		areaSoakMouseMoveCon:disconnect()
	end
end

RbxGui.CreateStyledMessageDialog = function(title, message, style, buttons)
	local frame = New "Frame" {
		Size = UDim2.new(0.5, 0, 0, 165),
		Position = UDim2.new(0.25, 0, 0.5, -72.5),
		Name = "MessageDialog",
		Active = true,
		Style = Enum.FrameStyle.RobloxRound,
		New "TextLabel" {
			Name = "Title",
			Text = title,
			TextStrokeTransparency = 0,
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(221 / 255, 221 / 255, 221 / 255),
			Position = UDim2.new(0, 80, 0, 0),
			Size = UDim2.new(1, -80, 0, 40),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		},
		New "TextLabel" {
			Name = "Message",
			Text = message,
			TextStrokeTransparency = 0,
			TextColor3 = Color3.new(221 / 255, 221 / 255, 221 / 255),
			Position = UDim2.new(0.025, 80, 0, 45),
			Size = UDim2.new(0.95, -80, 0, 55),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextWrap = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		},
	}

	local styleImage = New "ImageLabel" {
		Name = "StyleImage",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 5, 0, 15),
	}

	if style == "error" or style == "Error" then
		styleImage.Size = UDim2.new(0, 71, 0, 71)
		styleImage.Image = "http://banland.xyz/asset?id=42565285"
	elseif style == "notify" or style == "Notify" then
		styleImage.Size = UDim2.new(0, 71, 0, 71)
		styleImage.Image = "http://banland.xyz/asset?id=42604978"
	elseif style == "confirm" or style == "Confirm" then
		styleImage.Size = UDim2.new(0, 74, 0, 76)
		styleImage.Image = "http://banland.xyz/asset?id=42557901"
	else
		return RbxGui.CreateMessageDialog(title, message, buttons)
	end
	styleImage.Parent = frame

	CreateButtons(frame, buttons, UDim.new(0, 105), UDim.new(0, 40))

	return frame
end

RbxGui.CreateMessageDialog = function(title, message, buttons)
	local frame = New "Frame" {
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.25, 0, 0.25, 0),
		Name = "MessageDialog",
		Active = true,
		Style = Enum.FrameStyle.RobloxRound,
		New "TextLabel" {
			Name = "Title",
			Text = title,
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(221 / 255, 221 / 255, 221 / 255),
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0.15, 0),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		},
		New "TextLabel" {
			Name = "Message",
			Text = message,
			TextColor3 = Color3.new(221 / 255, 221 / 255, 221 / 255),
			Position = UDim2.new(0.025, 0, 0.175, 0),
			Size = UDim2.new(0.95, 0, 0.55, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextWrap = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		},
	}

	CreateButtons(frame, buttons, UDim.new(0.8, 0), UDim.new(0.15, 0))

	return frame
end

local scrollMouseCount
RbxGui.CreateDropDownMenu = function(items, onSelect, forRoblox)
	local width = UDim.new(0, 100)
	local height = UDim.new(0, 32)

	local frame = New "Frame" {
		Name = "DropDownMenu",
		BackgroundTransparency = 1,
		Size = UDim2.new(width, height),
	}

	local dropDownMenu = New "TextButton" {
		Name = "DropDownMenuButton",
		TextWrap = true,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "Choose One",
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size18,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundTransparency = 1,
		AutoButtonColor = true,
		Style = Enum.ButtonStyle.RobloxButton,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = frame,
		ZIndex = 2,
		New "ImageLabel" {
			Name = "Icon",
			Active = false,
			Image = "http://banland.xyz/asset/?id=45732894",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 11, 0, 6),
			Position = UDim2.new(1, -11, 0.5, -2),
			ZIndex = 2,
		},
	}

	local itemCount = #items
	local dropDownItemCount = #items
	local useScrollButtons = false
	if dropDownItemCount > 6 then
		useScrollButtons = true
		dropDownItemCount = 6
	end

	local droppedDownMenu = New "TextButton" {
		Name = "List",
		Text = "",
		BackgroundTransparency = 1,
		-- AutoButtonColor = true
		Style = Enum.ButtonStyle.RobloxButton,
		Visible = false,
		Active = true, --Blocks clicks
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, (1 + dropDownItemCount) * 0.8, 0),
		Parent = frame,
		ZIndex = 2,
	}

	local choiceButton = New "TextButton" {
		Name = "ChoiceButton",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "ReplaceMe",
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		TextWrap = true,
		ZIndex = 2,
	}

	if useScrollButtons then
		choiceButton.Size =
			UDim2.new(1, -13, 0.8 / ((dropDownItemCount + 1) * 0.8), 0)
	else
		choiceButton.Size =
			UDim2.new(1, 0, 0.8 / ((dropDownItemCount + 1) * 0.8), 0)
	end

	local areaSoak = New "TextButton" {
		Name = "AreaSoak",
		Text = "",
		BackgroundTransparency = 1,
		Active = true,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		ZIndex = 3,
	}

	local dropDownSelected = false

	local scrollUpButton
	local scrollDownButton
	scrollMouseCount = 0

	local setZIndex = function(baseZIndex)
		droppedDownMenu.ZIndex = baseZIndex + 1
		if scrollUpButton then
			scrollUpButton.ZIndex = baseZIndex + 3
		end
		if scrollDownButton then
			scrollDownButton.ZIndex = baseZIndex + 3
		end

		local children = droppedDownMenu:GetChildren()
		if children then
			for _, child in ipairs(children) do
				if child.Name == "ChoiceButton" then
					child.ZIndex = baseZIndex + 2
				elseif child.Name == "ClickCaptureButton" then
					child.ZIndex = baseZIndex
				end
			end
		end
	end

	local scrollBarPosition = 1
	local updateScroll = function()
		if scrollUpButton then
			scrollUpButton.Active = scrollBarPosition > 1
		end
		if scrollDownButton then
			scrollDownButton.Active = scrollBarPosition + dropDownItemCount
				<= itemCount
		end

		local children = droppedDownMenu:GetChildren()
		if not children then
			return
		end

		local childNum = 1
		for _, obj in ipairs(children) do
			if obj.Name == "ChoiceButton" then
				if
					childNum < scrollBarPosition
					or childNum >= scrollBarPosition + dropDownItemCount
				then
					obj.Visible = false
				else
					obj.Position = UDim2.new(
						0,
						0,
						((childNum - scrollBarPosition + 1) * 0.8)
							/ ((dropDownItemCount + 1) * 0.8),
						0
					)
					obj.Visible = true
				end
				obj.TextColor3 = Color3.new(1, 1, 1)
				obj.BackgroundTransparency = 1

				childNum += 1
			end
		end
	end
	local toggleVisibility = function()
		dropDownSelected = not dropDownSelected

		areaSoak.Visible = not areaSoak.Visible
		dropDownMenu.Visible = not dropDownSelected
		droppedDownMenu.Visible = dropDownSelected
		if dropDownSelected then
			setZIndex(4)
		else
			setZIndex(2)
		end
		if useScrollButtons then
			updateScroll()
		end
	end
	droppedDownMenu.MouseButton1Click:connect(toggleVisibility)

	local updateSelection = function(text)
		local foundItem = false
		local children = droppedDownMenu:GetChildren()
		local childNum = 1
		if children then
			for _, obj in ipairs(children) do
				if obj.Name == "ChoiceButton" then
					if obj.Text == text then
						obj.Font = Enum.Font.ArialBold
						foundItem = true
						scrollBarPosition = childNum
					else
						obj.Font = Enum.Font.Arial
					end
					childNum += 1
				end
			end
		end
		if not text then
			dropDownMenu.Text = "Choose One"
			scrollBarPosition = 1
		else
			if not foundItem then
				error("Invalid Selection Update -- " .. text)
			end

			if scrollBarPosition + dropDownItemCount > itemCount + 1 then
				scrollBarPosition = itemCount - dropDownItemCount + 1
			end

			dropDownMenu.Text = text
		end
	end

	local function scrollDown()
		if scrollBarPosition + dropDownItemCount <= itemCount then
			scrollBarPosition += 1
			updateScroll()
			return true
		end
		return false
	end
	local function scrollUp()
		if scrollBarPosition > 1 then
			scrollBarPosition -= 1
			updateScroll()
			return true
		end
		return false
	end

	if useScrollButtons then
		--Make some scroll buttons
		scrollUpButton = New "ImageButton" {
			Name = "ScrollUpButton",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/scrollbuttonUp.png",
			Size = UDim2.new(0, 17, 0, 17),
			Position = UDim2.new(
				1,
				-11,
				(1 * 0.8) / ((dropDownItemCount + 1) * 0.8),
				0
			),
		}
		scrollUpButton.MouseButton1Click:connect(function()
			scrollMouseCount += 1
		end)
		scrollUpButton.MouseLeave:connect(function()
			scrollMouseCount += 1
		end)
		scrollUpButton.MouseButton1Down:connect(function()
			scrollMouseCount += 1

			scrollUp()
			local val = scrollMouseCount
			wait(0.5)
			while val == scrollMouseCount do
				if scrollUp() == false then
					break
				end
				wait(0.1)
			end
		end)

		scrollUpButton.Parent = droppedDownMenu

		scrollDownButton = New "ImageButton" {
			Name = "ScrollDownButton",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/scrollbuttonDown.png",
			Size = UDim2.new(0, 17, 0, 17),
			Position = UDim2.new(1, -11, 1, -11),
			Parent = droppedDownMenu,
		}
		scrollDownButton.MouseButton1Click:connect(function()
			scrollMouseCount += 1
		end)
		scrollDownButton.MouseLeave:connect(function()
			scrollMouseCount += 1
		end)
		scrollDownButton.MouseButton1Down:connect(function()
			scrollMouseCount += 1

			scrollDown()
			local val = scrollMouseCount
			wait(0.5)
			while val == scrollMouseCount do
				if scrollDown() == false then
					break
				end
				wait(0.1)
			end
		end)

		New "ImageLabel" {
			Name = "ScrollBar",
			Image = "rbxasset://textures/ui/scrollbar.png",
			BackgroundTransparency = 1,
			Size = UDim2.new(
				0,
				18,
				(dropDownItemCount * 0.8) / ((dropDownItemCount + 1) * 0.8),
				-17 - 11 - 4
			),
			Position = UDim2.new(
				1,
				-11,
				(1 * 0.8) / ((dropDownItemCount + 1) * 0.8),
				17 + 2
			),
			Parent = droppedDownMenu,
		}
	end

	for _, item in ipairs(items) do
		-- needed to maintain local scope for items in event listeners below
		local button = choiceButton:clone()
		if forRoblox then
			button.RobloxLocked = true
		end
		button.Text = item
		button.Parent = droppedDownMenu
		button.MouseButton1Click:connect(function()
			--Remove Highlight
			button.TextColor3 = Color3.new(1, 1, 1)
			button.BackgroundTransparency = 1

			updateSelection(item)
			onSelect(item)

			toggleVisibility()
		end)
		button.MouseEnter:connect(function()
			--Add Highlight
			button.TextColor3 = Color3.new(0, 0, 0)
			button.BackgroundTransparency = 0
		end)

		button.MouseLeave:connect(function()
			--Remove Highlight
			button.TextColor3 = Color3.new(1, 1, 1)
			button.BackgroundTransparency = 1
		end)
	end

	--This does the initial layout of the buttons
	updateScroll()

	frame.AncestryChanged:connect(function(_, parent)
		if parent == nil then
			areaSoak.Parent = nil
		else
			areaSoak.Parent = getScreenGuiAncestor(frame)
		end
	end)

	dropDownMenu.MouseButton1Click:connect(toggleVisibility)
	areaSoak.MouseButton1Click:connect(toggleVisibility)
	return frame, updateSelection
end

RbxGui.CreatePropertyDropDownMenu = function(instance, property, enum)
	local items = enum:GetEnumItems()
	local names = {}
	local nameToItem = {}
	for i, obj in ipairs(items) do
		names[i] = obj.Name
		nameToItem[obj.Name] = obj
	end

	local frame
	local updateSelection
	frame, updateSelection = RbxGui.CreateDropDownMenu(names, function(text)
		instance[property] = nameToItem[text]
	end)

	ScopedConnect(frame, instance, "Changed", function(prop)
		if prop == property then
			updateSelection(instance[property].Name)
		end
	end, function()
		updateSelection(instance[property].Name)
	end)

	return frame
end

RbxGui.GetFontHeight = function(font, fontSize)
	if font == nil or fontSize == nil then
		error "Font and FontSize must be non-nil"
	end

	if font == Enum.Font.Legacy then
		if fontSize == Enum.FontSize.Size8 then
			return 12
		elseif fontSize == Enum.FontSize.Size9 then
			return 14
		elseif fontSize == Enum.FontSize.Size10 then
			return 15
		elseif fontSize == Enum.FontSize.Size11 then
			return 17
		elseif fontSize == Enum.FontSize.Size12 then
			return 18
		elseif fontSize == Enum.FontSize.Size14 then
			return 21
		elseif fontSize == Enum.FontSize.Size18 then
			return 27
		elseif fontSize == Enum.FontSize.Size24 then
			return 36
		elseif fontSize == Enum.FontSize.Size36 then
			return 54
		elseif fontSize == Enum.FontSize.Size48 then
			return 72
		else
			error "Unknown FontSize"
		end
	elseif font == Enum.Font.Arial or font == Enum.Font.ArialBold then
		if fontSize == Enum.FontSize.Size8 then
			return 8
		elseif fontSize == Enum.FontSize.Size9 then
			return 9
		elseif fontSize == Enum.FontSize.Size10 then
			return 10
		elseif fontSize == Enum.FontSize.Size11 then
			return 11
		elseif fontSize == Enum.FontSize.Size12 then
			return 12
		elseif fontSize == Enum.FontSize.Size14 then
			return 14
		elseif fontSize == Enum.FontSize.Size18 then
			return 18
		elseif fontSize == Enum.FontSize.Size24 then
			return 24
		elseif fontSize == Enum.FontSize.Size36 then
			return 36
		elseif fontSize == Enum.FontSize.Size48 then
			return 48
		else
			error "Unknown FontSize"
		end
	else
		error("Unknown Font " .. font)
	end
end

local function layoutGuiObjectsHelper(frame, guiObjects, settingsTable)
	local totalPixels = frame.AbsoluteSize.Y
	local pixelsRemaining = frame.AbsoluteSize.Y
	for _, child in ipairs(guiObjects) do
		if child:IsA "TextLabel" or child:IsA "TextButton" then
			local isLabel = child:IsA "TextLabel"
			if isLabel then
				pixelsRemaining = pixelsRemaining
					- settingsTable.TextLabelPositionPadY
			else
				pixelsRemaining = pixelsRemaining
					- settingsTable.TextButtonPositionPadY
			end
			child.Position = UDim2.new(
				child.Position.X.Scale,
				child.Position.X.Offset,
				0,
				totalPixels - pixelsRemaining
			)
			child.Size = UDim2.new(
				child.Size.X.Scale,
				child.Size.X.Offset,
				0,
				pixelsRemaining
			)

			if child.TextFits and child.TextBounds.Y < pixelsRemaining then
				child.Visible = true
				if isLabel then
					child.Size = UDim2.new(
						child.Size.X.Scale,
						child.Size.X.Offset,
						0,
						child.TextBounds.Y + settingsTable.TextLabelSizePadY
					)
				else
					child.Size = UDim2.new(
						child.Size.X.Scale,
						child.Size.X.Offset,
						0,
						child.TextBounds.Y + settingsTable.TextButtonSizePadY
					)
				end

				while not child.TextFits do
					child.Size = UDim2.new(
						child.Size.X.Scale,
						child.Size.X.Offset,
						0,
						child.AbsoluteSize.Y + 1
					)
				end
				pixelsRemaining -= child.AbsoluteSize.Y

				if isLabel then
					pixelsRemaining = pixelsRemaining
						- settingsTable.TextLabelPositionPadY
				else
					pixelsRemaining = pixelsRemaining
						- settingsTable.TextButtonPositionPadY
				end
			else
				child.Visible = false
				pixelsRemaining = -1
			end
		else
			--GuiObject
			child.Position = UDim2.new(
				child.Position.X.Scale,
				child.Position.X.Offset,
				0,
				totalPixels - pixelsRemaining
			)
			pixelsRemaining -= child.AbsoluteSize.Y
			child.Visible = (pixelsRemaining >= 0)
		end
	end
end

RbxGui.LayoutGuiObjects = function(frame, guiObjects, settingsTable)
	if not frame:IsA "GuiObject" then
		error "Frame must be a GuiObject"
	end
	for _, child in ipairs(guiObjects) do
		if not child:IsA "GuiObject" then
			error "All elements that are layed out must be of type GuiObject"
		end
	end

	if not settingsTable then
		settingsTable = {}
	end

	if not settingsTable.TextLabelSizePadY then
		settingsTable.TextLabelSizePadY = 0
	end
	if not settingsTable.TextLabelPositionPadY then
		settingsTable.TextLabelPositionPadY = 0
	end
	if not settingsTable.TextButtonSizePadY then
		settingsTable.TextButtonSizePadY = 12
	end
	if not settingsTable.TextButtonPositionPadY then
		settingsTable.TextButtonPositionPadY = 2
	end

	--Wrapper frame takes care of styled objects
	local wrapperFrame = Instance.new "Frame"
	wrapperFrame.Name = "WrapperFrame"
	wrapperFrame.BackgroundTransparency = 1
	wrapperFrame.Size = UDim2.new(1, 0, 1, 0)
	wrapperFrame.Parent = frame

	for _, child in ipairs(guiObjects) do
		child.Parent = wrapperFrame
	end

	local recalculate = function()
		wait()
		layoutGuiObjectsHelper(wrapperFrame, guiObjects, settingsTable)
	end

	frame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			--Wait a heartbeat for it to sync in
			recalculate()
		end
	end)
	frame.AncestryChanged:connect(recalculate)

	layoutGuiObjectsHelper(wrapperFrame, guiObjects, settingsTable)
end

RbxGui.CreateSlider = function(steps, width, position)
	local sliderGui = Instance.new "Frame"
	sliderGui.Size = UDim2.new(1, 0, 1, 0)
	sliderGui.BackgroundTransparency = 1
	sliderGui.Name = "SliderGui"

	local sliderSteps = Instance.new "IntValue"
	sliderSteps.Name = "SliderSteps"
	sliderSteps.Value = steps
	sliderSteps.Parent = sliderGui

	local areaSoak = Instance.new "TextButton"
	areaSoak.Name = "AreaSoak"
	areaSoak.Text = ""
	areaSoak.BackgroundTransparency = 1
	areaSoak.Active = false
	areaSoak.Size = UDim2.new(1, 0, 1, 0)
	areaSoak.Visible = false
	areaSoak.ZIndex = 4

	sliderGui.AncestryChanged:connect(function(_, parent)
		if parent == nil then
			areaSoak.Parent = nil
		else
			areaSoak.Parent = getScreenGuiAncestor(sliderGui)
		end
	end)

	local sliderPosition = Instance.new "IntValue"
	sliderPosition.Name = "SliderPosition"
	sliderPosition.Value = 0
	sliderPosition.Parent = sliderGui

	local bar = Instance.new "TextButton"
	bar.Text = ""
	bar.AutoButtonColor = false
	bar.Name = "Bar"
	bar.BackgroundColor3 = Color3.new(0, 0, 0)
	if type(width) == "number" then
		bar.Size = UDim2.new(0, width, 0, 5)
	else
		bar.Size = UDim2.new(0, 200, 0, 5)
	end
	bar.BorderColor3 = Color3.new(95 / 255, 95 / 255, 95 / 255)
	bar.ZIndex = 2
	bar.Parent = sliderGui

	if
		position.X
		and position.X.Scale
		and position.X.Offset
		and position.Y
		and position.Y.Scale
		and position.Y.Offset
	then
		bar.Position = position
	end

	local slider = Instance.new "ImageButton"
	slider.Name = "Slider"
	slider.BackgroundTransparency = 1
	slider.Image = "rbxasset://textures/ui/Slider.png"
	slider.Position = UDim2.new(0, 0, 0.5, -10)
	slider.Size = UDim2.new(0, 20, 0, 20)
	slider.ZIndex = 3
	slider.Parent = bar

	areaSoak.MouseLeave:connect(function()
		if areaSoak.Visible then
			cancelSlide(areaSoak)
		end
	end)
	areaSoak.MouseButton1Up:connect(function()
		if areaSoak.Visible then
			cancelSlide(areaSoak)
		end
	end)

	slider.MouseButton1Down:connect(function()
		areaSoak.Visible = true
		if areaSoakMouseMoveCon then
			areaSoakMouseMoveCon:disconnect()
		end
		areaSoakMouseMoveCon = areaSoak.MouseMoved:connect(function(x, _)
			setSliderPos(x, slider, sliderPosition, bar, steps)
		end)
	end)

	slider.MouseButton1Up:connect(function()
		cancelSlide(areaSoak)
	end)

	sliderPosition.Changed:connect(function(_)
		sliderPosition.Value =
			math.min(steps, math.max(1, sliderPosition.Value))
		local relativePosX = (sliderPosition.Value - 1) / (steps - 1)
		slider.Position = UDim2.new(
			relativePosX,
			-slider.AbsoluteSize.X / 2,
			slider.Position.Y.Scale,
			slider.Position.Y.Offset
		)
	end)

	bar.MouseButton1Down:connect(function(x, _)
		setSliderPos(x, slider, sliderPosition, bar, steps)
	end)

	return sliderGui, sliderPosition, sliderSteps
end

RbxGui.CreateTrueScrollingFrame = function()
	local lowY
	local highY

	local dragCon
	local upCon

	local internalChange = false

	local descendantsChangeConMap = {}

	local scrollingFrame = Instance.new "Frame"
	scrollingFrame.Name = "ScrollingFrame"
	scrollingFrame.Active = true
	scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollingFrame.ClipsDescendants = true

	local controlFrame = Instance.new "Frame"
	controlFrame.Name = "ControlFrame"
	controlFrame.BackgroundTransparency = 1
	controlFrame.Size = UDim2.new(0, 18, 1, 0)
	controlFrame.Position = UDim2.new(1, -20, 0, 0)
	controlFrame.Parent = scrollingFrame

	local scrollBottom = Instance.new "BoolValue"
	scrollBottom.Value = false
	scrollBottom.Name = "ScrollBottom"
	scrollBottom.Parent = controlFrame

	local scrollUpValue = Instance.new "BoolValue"
	scrollUpValue.Value = false
	scrollUpValue.Name = "scrollUp"
	scrollUpValue.Parent = controlFrame

	local scrollUpButton = Instance.new "TextButton"
	scrollUpButton.Name = "ScrollUpButton"
	scrollUpButton.Text = ""
	scrollUpButton.AutoButtonColor = false
	scrollUpButton.BackgroundColor3 = Color3.new(0, 0, 0)
	scrollUpButton.BorderColor3 = Color3.new(1, 1, 1)
	scrollUpButton.BackgroundTransparency = 0.5
	scrollUpButton.Size = UDim2.new(0, 18, 0, 18)
	scrollUpButton.ZIndex = 2
	scrollUpButton.Parent = controlFrame
	for i = 1, 6 do
		local triFrame = Instance.new "Frame"
		triFrame.BorderColor3 = Color3.new(1, 1, 1)
		triFrame.Name = "tri" .. tostring(i)
		triFrame.ZIndex = 3
		triFrame.BackgroundTransparency = 0.5
		triFrame.Size = UDim2.new(0, 12 - ((i - 1) * 2), 0, 0)
		triFrame.Position = UDim2.new(0, 3 + (i - 1), 0.5, 2 - (i - 1))
		triFrame.Parent = scrollUpButton
	end
	scrollUpButton.MouseEnter:connect(function()
		scrollUpButton.BackgroundTransparency = 0.1
		local upChildren = scrollUpButton:GetChildren()
		for i = 1, #upChildren do
			upChildren[i].BackgroundTransparency = 0.1
		end
	end)
	scrollUpButton.MouseLeave:connect(function()
		scrollUpButton.BackgroundTransparency = 0.5
		local upChildren = scrollUpButton:GetChildren()
		for i = 1, #upChildren do
			upChildren[i].BackgroundTransparency = 0.5
		end
	end)

	local scrollDownButton = scrollUpButton:clone()
	scrollDownButton.Name = "ScrollDownButton"
	scrollDownButton.Position = UDim2.new(0, 0, 1, -18)
	local downChildren = scrollDownButton:GetChildren()
	for i = 1, #downChildren do
		downChildren[i].Position = UDim2.new(0, 3 + (i - 1), 0.5, -2 + (i - 1))
	end
	scrollDownButton.MouseEnter:connect(function()
		scrollDownButton.BackgroundTransparency = 0.1
		downChildren = scrollDownButton:GetChildren()
		for i = 1, #downChildren do
			downChildren[i].BackgroundTransparency = 0.1
		end
	end)
	scrollDownButton.MouseLeave:connect(function()
		scrollDownButton.BackgroundTransparency = 0.5
		downChildren = scrollDownButton:GetChildren()
		for i = 1, #downChildren do
			downChildren[i].BackgroundTransparency = 0.5
		end
	end)
	scrollDownButton.Parent = controlFrame

	local scrollTrack = Instance.new "Frame"
	scrollTrack.Name = "ScrollTrack"
	scrollTrack.BackgroundTransparency = 1
	scrollTrack.Size = UDim2.new(0, 18, 1, -38)
	scrollTrack.Position = UDim2.new(0, 0, 0, 19)
	scrollTrack.Parent = controlFrame

	local scrollbar = Instance.new "TextButton"
	scrollbar.BackgroundColor3 = Color3.new(0, 0, 0)
	scrollbar.BorderColor3 = Color3.new(1, 1, 1)
	scrollbar.BackgroundTransparency = 0.5
	scrollbar.AutoButtonColor = false
	scrollbar.Text = ""
	scrollbar.Active = true
	scrollbar.Name = "ScrollBar"
	scrollbar.ZIndex = 2
	scrollbar.BackgroundTransparency = 0.5
	scrollbar.Size = UDim2.new(0, 18, 0.1, 0)
	scrollbar.Position = UDim2.new(0, 0, 0, 0)
	scrollbar.Parent = scrollTrack

	local scrollNub = Instance.new "Frame"
	scrollNub.Name = "ScrollNub"
	scrollNub.BorderColor3 = Color3.new(1, 1, 1)
	scrollNub.Size = UDim2.new(0, 10, 0, 0)
	scrollNub.Position = UDim2.new(0.5, -5, 0.5, 0)
	scrollNub.ZIndex = 2
	scrollNub.BackgroundTransparency = 0.5
	scrollNub.Parent = scrollbar

	local newNub = scrollNub:clone()
	newNub.Position = UDim2.new(0.5, -5, 0.5, -2)
	newNub.Parent = scrollbar

	local lastNub = scrollNub:clone()
	lastNub.Position = UDim2.new(0.5, -5, 0.5, 2)
	lastNub.Parent = scrollbar

	scrollbar.MouseEnter:connect(function()
		scrollbar.BackgroundTransparency = 0.1
		scrollNub.BackgroundTransparency = 0.1
		newNub.BackgroundTransparency = 0.1
		lastNub.BackgroundTransparency = 0.1
	end)
	scrollbar.MouseLeave:connect(function()
		scrollbar.BackgroundTransparency = 0.5
		scrollNub.BackgroundTransparency = 0.5
		newNub.BackgroundTransparency = 0.5
		lastNub.BackgroundTransparency = 0.5
	end)

	local mouseDrag = Instance.new "ImageButton"
	mouseDrag.Active = false
	mouseDrag.Size = UDim2.new(1.5, 0, 1.5, 0)
	mouseDrag.AutoButtonColor = false
	mouseDrag.BackgroundTransparency = 1
	mouseDrag.Name = "mouseDrag"
	mouseDrag.Position = UDim2.new(-0.25, 0, -0.25, 0)
	mouseDrag.ZIndex = 10

	local function positionScrollBar(_, y, offset)
		local oldPos = scrollbar.Position

		if y < scrollTrack.AbsolutePosition.y then
			scrollbar.Position = UDim2.new(
				scrollbar.Position.X.Scale,
				scrollbar.Position.X.Offset,
				0,
				0
			)
			return (oldPos ~= scrollbar.Position)
		end

		local relativeSize = scrollbar.AbsoluteSize.Y
			/ scrollTrack.AbsoluteSize.Y

		if
			y > (scrollTrack.AbsolutePosition.y + scrollTrack.AbsoluteSize.y)
		then
			scrollbar.Position = UDim2.new(
				scrollbar.Position.X.Scale,
				scrollbar.Position.X.Offset,
				1 - relativeSize,
				0
			)
			return (oldPos ~= scrollbar.Position)
		end
		local newScaleYPos = (y - scrollTrack.AbsolutePosition.y - offset)
			/ scrollTrack.AbsoluteSize.y
		if newScaleYPos + relativeSize > 1 then
			newScaleYPos = 1 - relativeSize
			scrollBottom.Value = true
			scrollUpValue.Value = false
		elseif newScaleYPos <= 0 then
			newScaleYPos = 0
			scrollUpValue.Value = true
			scrollBottom.Value = false
		else
			scrollUpValue.Value = false
			scrollBottom.Value = false
		end
		scrollbar.Position = UDim2.new(
			scrollbar.Position.X.Scale,
			scrollbar.Position.X.Offset,
			newScaleYPos,
			0
		)

		return (oldPos ~= scrollbar.Position)
	end

	local function drillDownSetHighLow(instance)
		if not instance or not instance:IsA "GuiObject" then
			return
		end
		if instance == controlFrame then
			return
		end
		if instance:IsDescendantOf(controlFrame) then
			return
		end
		if not instance.Visible then
			return
		end

		if (lowY and lowY > instance.AbsolutePosition.Y) or not lowY then
			lowY = instance.AbsolutePosition.Y
		end
		if
			(
				highY
				and highY
					< (instance.AbsolutePosition.Y + instance.AbsoluteSize.Y)
			) or not highY
		then
			highY = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
		end
		local children = instance:GetChildren()
		for i = 1, #children do
			drillDownSetHighLow(children[i])
		end
	end

	local function resetHighLow()
		local firstChildren = scrollingFrame:GetChildren()

		for i = 1, #firstChildren do
			drillDownSetHighLow(firstChildren[i])
		end
	end

	local function recalculate()
		internalChange = true

		local percentFrame = 0
		if scrollbar.Position.Y.Scale > 0 then
			if scrollbar.Visible then
				percentFrame = scrollbar.Position.Y.Scale
					/ (
						(scrollTrack.AbsoluteSize.Y - scrollbar.AbsoluteSize.Y)
						/ scrollTrack.AbsoluteSize.Y
					)
			else
				percentFrame = 0
			end
		end
		if percentFrame > 0.99 then
			percentFrame = 1
		end

		local hiddenYAmount = (scrollingFrame.AbsoluteSize.Y - (highY - lowY))
			* percentFrame

		local guiChildren = scrollingFrame:GetChildren()
		for i = 1, #guiChildren do
			if guiChildren[i] ~= controlFrame then
				guiChildren[i].Position = UDim2.new(
					guiChildren[i].Position.X.Scale,
					guiChildren[i].Position.X.Offset,
					0,
					math.ceil(guiChildren[i].AbsolutePosition.Y)
						- math.ceil(lowY)
						+ hiddenYAmount
				)
			end
		end

		lowY = nil
		highY = nil
		resetHighLow()
		internalChange = false
	end

	local function setSliderSizeAndPosition()
		if not highY or not lowY then
			return
		end

		local totalYSpan = math.abs(highY - lowY)
		if totalYSpan == 0 then
			scrollbar.Visible = false
			scrollDownButton.Visible = false
			scrollUpButton.Visible = false

			if dragCon then
				dragCon:disconnect()
				dragCon = nil
			end
			if upCon then
				upCon:disconnect()
				upCon = nil
			end
			return
		end

		local percentShown = scrollingFrame.AbsoluteSize.Y / totalYSpan
		if percentShown >= 1 then
			scrollbar.Visible = false
			scrollDownButton.Visible = false
			scrollUpButton.Visible = false
			recalculate()
		else
			scrollbar.Visible = true
			scrollDownButton.Visible = true
			scrollUpButton.Visible = true

			scrollbar.Size = UDim2.new(
				scrollbar.Size.X.Scale,
				scrollbar.Size.X.Offset,
				percentShown,
				0
			)
		end

		local percentPosition = (scrollingFrame.AbsolutePosition.Y - lowY)
			/ totalYSpan
		scrollbar.Position = UDim2.new(
			scrollbar.Position.X.Scale,
			scrollbar.Position.X.Offset,
			percentPosition,
			-scrollbar.AbsoluteSize.X / 2
		)

		if scrollbar.AbsolutePosition.y < scrollTrack.AbsolutePosition.y then
			scrollbar.Position = UDim2.new(
				scrollbar.Position.X.Scale,
				scrollbar.Position.X.Offset,
				0,
				0
			)
		end

		if
			(scrollbar.AbsolutePosition.y + scrollbar.AbsoluteSize.Y)
			> (scrollTrack.AbsolutePosition.y + scrollTrack.AbsoluteSize.y)
		then
			local relativeSize = scrollbar.AbsoluteSize.Y
				/ scrollTrack.AbsoluteSize.Y
			scrollbar.Position = UDim2.new(
				scrollbar.Position.X.Scale,
				scrollbar.Position.X.Offset,
				1 - relativeSize,
				0
			)
		end
	end

	local buttonScrollAmountPixels = 7
	local reentrancyGuardScrollUp = false
	local function doScrollUp()
		if reentrancyGuardScrollUp then
			return
		end

		reentrancyGuardScrollUp = true
		if
			positionScrollBar(
				0,
				scrollbar.AbsolutePosition.Y - buttonScrollAmountPixels,
				0
			)
		then
			recalculate()
		end
		reentrancyGuardScrollUp = false
	end

	local reentrancyGuardScrollDown = false
	local function doScrollDown()
		if reentrancyGuardScrollDown then
			return
		end

		reentrancyGuardScrollDown = true
		if
			positionScrollBar(
				0,
				scrollbar.AbsolutePosition.Y + buttonScrollAmountPixels,
				0
			)
		then
			recalculate()
		end
		reentrancyGuardScrollDown = false
	end

	local scrollStamp

	local function scrollUp()
		if scrollUpButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			upCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				upCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollUp()
			wait(0.2)
			local t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollUp()
				if not scrollUpButton.Active then
					break
				end
				if tick() - t > 5 then
					w = 0
				elseif tick() - t > 2 then
					w = 0.06
				end
				wait(w)
			end
		end
	end

	local function scrollDown(mouseYPos)
		if scrollDownButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			local downCon
			downCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				downCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollDown()
			wait(0.2)
			local t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollDown()
				if
					mouseYPos
					and mouseYPos
						< (scrollbar.AbsolutePosition.y + scrollbar.AbsoluteSize.x)
				then
					break
				end
				if not scrollDownButton.Active then
					break
				end
				if tick() - t > 5 then
					w = 0
				elseif tick() - t > 2 then
					w = 0.06
				end
				wait(w)
			end
		end
	end

	scrollbar.MouseButton1Down:connect(function(_, y)
		if scrollbar.Active then
			local mouseOffset = y - scrollbar.AbsolutePosition.y
			if dragCon then
				dragCon:disconnect()
				dragCon = nil
			end
			if upCon then
				upCon:disconnect()
				upCon = nil
			end
			local reentrancyGuardMouseScroll = false
			dragCon = mouseDrag.MouseMoved:connect(function(x2, y2)
				if reentrancyGuardMouseScroll then
					return
				end

				reentrancyGuardMouseScroll = true
				if positionScrollBar(x2, y2, mouseOffset) then
					recalculate()
				end
				reentrancyGuardMouseScroll = false
			end)
			upCon = mouseDrag.MouseButton1Up:connect(function()
				mouseDrag.Parent = nil
				dragCon:disconnect()
				dragCon = nil
				upCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
		end
	end)

	scrollMouseCount = 0

	scrollUpButton.MouseButton1Down:connect(function()
		scrollUp()
	end)
	scrollDownButton.MouseButton1Down:connect(function()
		scrollDown()
	end)

	local function scrollTick()
		scrollStamp = tick()
	end

	scrollUpButton.MouseButton1Up:connect(scrollTick)
	scrollDownButton.MouseButton1Up:connect(scrollTick)
	scrollbar.MouseButton1Up:connect(scrollTick)

	-- local function heightCheck(instance)
	-- 	if (highY and (instance.AbsolutePosition.Y + instance.AbsoluteSize.Y) > highY) or not highY then
	-- 		highY = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
	-- 	end
	-- 	setSliderSizeAndPosition()
	-- end

	local function highLowRecheck()
		local oldLowY = lowY
		local oldHighY = highY
		lowY = nil
		highY = nil
		resetHighLow()

		if (lowY ~= oldLowY) or (highY ~= oldHighY) then
			setSliderSizeAndPosition()
		end
	end

	local function descendantChanged(this, prop)
		if internalChange then
			return
		end
		if not this.Visible then
			return
		end

		if prop == "Size" or prop == "Position" then
			wait()
			highLowRecheck()
		end
	end

	scrollingFrame.DescendantAdded:connect(function(instance)
		if not instance:IsA "GuiObject" then
			return
		end

		if instance.Visible then
			wait() -- wait a heartbeat for sizes to reconfig
			highLowRecheck()
		end

		descendantsChangeConMap[instance] = instance.Changed:connect(
			function(prop)
				descendantChanged(instance, prop)
			end
		)
	end)

	scrollingFrame.DescendantRemoving:connect(function(instance)
		if not instance:IsA "GuiObject" then
			return
		end
		if descendantsChangeConMap[instance] then
			descendantsChangeConMap[instance]:disconnect()
			descendantsChangeConMap[instance] = nil
		end
		wait() -- wait a heartbeat for sizes to reconfig
		highLowRecheck()
	end)

	scrollingFrame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			if not highY or not lowY then
				return
			end

			highLowRecheck()
			setSliderSizeAndPosition()
		end
	end)

	return scrollingFrame, controlFrame
end

RbxGui.CreateScrollingFrame = function(orderList, scrollStyle)
	local frame = New "Frame" {
		Name = "ScrollingFrame",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}

	local scrollUpButton = New "ImageButton" {
		Name = "ScrollUpButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/scrollbuttonUp.png",
		Size = UDim2.new(0, 17, 0, 17),
	}

	local scrollDownButton = New "ImageButton" {
		Name = "ScrollDownButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/scrollbuttonDown.png",
		Size = UDim2.new(0, 17, 0, 17),
	}

	local scrollbar = New "ImageButton" {
		Name = "ScrollBar",
		Image = "rbxasset://textures/ui/scrollbar.png",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 18, 0, 150),
	}

	local scrollStamp = 0

	local scrollDrag = New "ImageButton" {
		Image = "http://banland.xyz/asset/?id=61367186",
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Name = "ScrollDrag",
		Active = true,
		Parent = scrollbar,
	}

	local mouseDrag = New "ImageButton" {
		Active = false,
		Size = UDim2.new(1.5, 0, 1.5, 0),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Name = "mouseDrag",
		Position = UDim2.new(-0.25, 0, -0.25, 0),
		ZIndex = 10,
	}

	local style = "simple"
	if scrollStyle and tostring(scrollStyle) then
		style = scrollStyle
	end

	local scrollPosition = 1
	local rowSize = 0
	local howManyDisplayed = 0

	local layoutGridScrollBar = function()
		howManyDisplayed = 0
		local guiObjects = {}
		if orderList then
			for _, child in ipairs(orderList) do
				if child.Parent == frame then
					table.insert(guiObjects, child)
				end
			end
		else
			local children = frame:GetChildren()
			if children then
				for _, child in ipairs(children) do
					if child:IsA "GuiObject" then
						table.insert(guiObjects, child)
					end
				end
			end
		end
		if #guiObjects == 0 then
			scrollUpButton.Active = false
			scrollDownButton.Active = false
			scrollDrag.Active = false
			scrollPosition = 1
			return
		end

		if scrollPosition > #guiObjects then
			scrollPosition = #guiObjects
		end

		if scrollPosition < 1 then
			scrollPosition = 1
		end

		local totalPixelsY = frame.AbsoluteSize.Y
		local pixelsRemainingY = frame.AbsoluteSize.Y

		local totalPixelsX = frame.AbsoluteSize.X

		local xCounter = 0
		local rowSizeCounter = 0
		local setRowSize = true

		local pixelsBelowScrollbar = 0
		local pos = #guiObjects

		local currentRowY = 0

		pos = scrollPosition
		--count up from current scroll position to fill out grid
		while pos <= #guiObjects and pixelsBelowScrollbar < totalPixelsY do
			xCounter += guiObjects[pos].AbsoluteSize.X
			--previous pos was the end of a row
			if xCounter >= totalPixelsX then
				pixelsBelowScrollbar += currentRowY
				currentRowY = 0
				xCounter = guiObjects[pos].AbsoluteSize.X
			end
			if guiObjects[pos].AbsoluteSize.Y > currentRowY then
				currentRowY = guiObjects[pos].AbsoluteSize.Y
			end
			pos += 1
		end
		--Count wherever current row left off
		pixelsBelowScrollbar += currentRowY
		currentRowY = 0

		pos = scrollPosition - 1
		xCounter = 0

		--objects with varying X,Y dimensions can rarely cause minor errors
		--rechecking every new scrollPosition is necessary to avoid 100% of errors

		--count backwards from current scrollPosition to see if we can add more rows
		while pixelsBelowScrollbar + currentRowY < totalPixelsY and pos >= 1 do
			xCounter += guiObjects[pos].AbsoluteSize.X
			rowSizeCounter += 1
			if xCounter >= totalPixelsX then
				rowSize = rowSizeCounter - 1
				rowSizeCounter = 0
				xCounter = guiObjects[pos].AbsoluteSize.X
				if pixelsBelowScrollbar + currentRowY <= totalPixelsY then
					--It fits, so back up our scroll position
					pixelsBelowScrollbar += currentRowY
					if scrollPosition <= rowSize then
						scrollPosition = 1
						break
					else
						scrollPosition -= rowSize
					end
					currentRowY = 0
				else
					break
				end
			end

			if guiObjects[pos].AbsoluteSize.Y > currentRowY then
				currentRowY = guiObjects[pos].AbsoluteSize.Y
			end

			pos -= 1
		end

		--Do check last time if pos = 0
		if
			(pos == 0) and (pixelsBelowScrollbar + currentRowY <= totalPixelsY)
		then
			scrollPosition = 1
		end

		xCounter = 0
		--pos = scrollPosition
		rowSizeCounter = 0
		setRowSize = true
		local lastChildSize = 0

		local xOffset = 0
		local yOffset = 0
		if guiObjects[1] then
			yOffset = math.ceil(
				math.floor(
					math.fmod(totalPixelsY, guiObjects[1].AbsoluteSize.X)
				) / 2
			)
			xOffset = math.ceil(
				math.floor(
					math.fmod(totalPixelsX, guiObjects[1].AbsoluteSize.Y)
				) / 2
			)
		end

		for i, child in ipairs(guiObjects) do
			if i < scrollPosition then
				--print("Hiding " .. child.Name)
				child.Visible = false
			else
				if pixelsRemainingY < 0 then
					--print("Out of Space " .. child.Name)
					child.Visible = false
				else
					--print("Laying out " .. child.Name)
					--GuiObject
					if setRowSize then
						rowSizeCounter += 1
					end
					if xCounter + child.AbsoluteSize.X >= totalPixelsX then
						if setRowSize then
							rowSize = rowSizeCounter - 1
							setRowSize = false
						end
						xCounter = 0
						pixelsRemainingY = pixelsRemainingY
							- child.AbsoluteSize.Y
					end
					child.Position = UDim2.new(
						child.Position.X.Scale,
						xCounter + xOffset,
						0,
						totalPixelsY - pixelsRemainingY + yOffset
					)
					xCounter += child.AbsoluteSize.X
					child.Visible = (
						(pixelsRemainingY - child.AbsoluteSize.Y) >= 0
					)
					if child.Visible then
						howManyDisplayed += 1
					end
					lastChildSize = child.AbsoluteSize
				end
			end
		end

		scrollUpButton.Active = (scrollPosition > 1)
		if lastChildSize == 0 then
			scrollDownButton.Active = false
		else
			scrollDownButton.Active = ((pixelsRemainingY - lastChildSize.Y) < 0)
		end
		scrollDrag.Active = #guiObjects > howManyDisplayed
		scrollDrag.Visible = scrollDrag.Active
	end

	local layoutSimpleScrollBar = function()
		local guiObjects = {}
		howManyDisplayed = 0

		if orderList then
			for _, child in ipairs(orderList) do
				if child.Parent == frame then
					table.insert(guiObjects, child)
				end
			end
		else
			local children = frame:GetChildren()
			if children then
				for _, child in ipairs(children) do
					if child:IsA "GuiObject" then
						table.insert(guiObjects, child)
					end
				end
			end
		end
		if #guiObjects == 0 then
			scrollUpButton.Active = false
			scrollDownButton.Active = false
			scrollDrag.Active = false
			scrollPosition = 1
			return
		end

		if scrollPosition > #guiObjects then
			scrollPosition = #guiObjects
		end

		local totalPixels = frame.AbsoluteSize.Y
		local pixelsRemaining = frame.AbsoluteSize.Y

		local pixelsBelowScrollbar = 0
		local pos = #guiObjects
		while pixelsBelowScrollbar < totalPixels and pos >= 1 do
			if pos >= scrollPosition then
				pixelsBelowScrollbar = pixelsBelowScrollbar
					+ guiObjects[pos].AbsoluteSize.Y
			else
				if
					pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y
					<= totalPixels
				then
					--It fits, so back up our scroll position
					pixelsBelowScrollbar = pixelsBelowScrollbar
						+ guiObjects[pos].AbsoluteSize.Y
					if scrollPosition <= 1 then
						scrollPosition = 1
						break
					else
						--local ("Backing up ScrollPosition from -- " ..scrollPosition)
						scrollPosition -= 1
					end
				else
					break
				end
			end
			pos -= 1
		end

		pos = scrollPosition
		for i, child in ipairs(guiObjects) do
			if i < scrollPosition then
				--print("Hiding " .. child.Name)
				child.Visible = false
			else
				if pixelsRemaining < 0 then
					--print("Out of Space " .. child.Name)
					child.Visible = false
				else
					--print("Laying out " .. child.Name)
					--GuiObject
					child.Position = UDim2.new(
						child.Position.X.Scale,
						child.Position.X.Offset,
						0,
						totalPixels - pixelsRemaining
					)
					pixelsRemaining -= child.AbsoluteSize.Y
					if pixelsRemaining >= 0 then
						child.Visible = true
						howManyDisplayed += 1
					else
						child.Visible = false
					end
				end
			end
		end
		scrollUpButton.Active = (scrollPosition > 1)
		scrollDownButton.Active = (pixelsRemaining < 0)
		scrollDrag.Active = #guiObjects > howManyDisplayed
		scrollDrag.Visible = scrollDrag.Active
	end

	local moveDragger = function()
		local guiObjects = 0
		local children = frame:GetChildren()
		if children then
			for _, child in ipairs(children) do
				if child:IsA "GuiObject" then
					guiObjects += 1
				end
			end
		end

		if not scrollDrag.Parent then
			return
		end

		local dragSizeY = scrollDrag.Parent.AbsoluteSize.y
			* (1 / (guiObjects - howManyDisplayed + 1))
		if dragSizeY < 16 then
			dragSizeY = 16
		end
		scrollDrag.Size = UDim2.new(
			scrollDrag.Size.X.Scale,
			scrollDrag.Size.X.Offset,
			scrollDrag.Size.Y.Scale,
			dragSizeY
		)

		local relativeYPos = (scrollPosition - 1)
			/ (guiObjects - howManyDisplayed)
		if relativeYPos > 1 then
			relativeYPos = 1
		elseif relativeYPos < 0 then
			relativeYPos = 0
		end
		local absYPos = 0

		if relativeYPos ~= 0 then
			absYPos = (relativeYPos * scrollbar.AbsoluteSize.y)
				- (relativeYPos * scrollDrag.AbsoluteSize.y)
		end

		scrollDrag.Position = UDim2.new(
			scrollDrag.Position.X.Scale,
			scrollDrag.Position.X.Offset,
			scrollDrag.Position.Y.Scale,
			absYPos
		)
	end

	local reentrancyGuard = false
	local recalculate = function()
		if reentrancyGuard then
			return
		end
		reentrancyGuard = true
		wait()
		local success, err
		if style == "grid" then
			success, err = pcall(function()
				layoutGridScrollBar()
			end)
		elseif style == "simple" then
			success, err = pcall(function()
				layoutSimpleScrollBar()
			end)
		end
		if not success then
			print(err)
		end
		moveDragger()
		reentrancyGuard = false
	end

	local doScrollUp = function()
		scrollPosition -= rowSize
		if scrollPosition < 1 then
			scrollPosition = 1
		end
		recalculate()
	end

	local doScrollDown = function()
		scrollPosition += rowSize
		recalculate()
	end

	local function scrollUp(mouseYPos)
		if scrollUpButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			local upCon
			upCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				upCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollUp()
			wait(0.2)
			local t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollUp()
				if mouseYPos and mouseYPos > scrollDrag.AbsolutePosition.y then
					break
				end
				if not scrollUpButton.Active then
					break
				end
				if tick() - t > 5 then
					w = 0
				elseif tick() - t > 2 then
					w = 0.06
				end
				wait(w)
			end
		end
	end

	local function scrollDown(mouseYPos)
		if scrollDownButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			local downCon
			downCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				downCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollDown()
			wait(0.2)
			local t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollDown()
				if
					mouseYPos
					and mouseYPos
						< (scrollDrag.AbsolutePosition.y + scrollDrag.AbsoluteSize.x)
				then
					break
				end
				if not scrollDownButton.Active then
					break
				end
				if tick() - t > 5 then
					w = 0
				elseif tick() - t > 2 then
					w = 0.06
				end
				wait(w)
			end
		end
	end

	-- local y = 0
	scrollDrag.MouseButton1Down:connect(function(_, y)
		if scrollDrag.Active then
			scrollStamp = tick()
			local mouseOffset = y - scrollDrag.AbsolutePosition.y
			local dragCon
			local upCon
			dragCon = mouseDrag.MouseMoved:connect(function(_, y2)
				local barAbsPos = scrollbar.AbsolutePosition.y
				local barAbsSize = scrollbar.AbsoluteSize.y

				local dragAbsSize = scrollDrag.AbsoluteSize.y
				local barAbsOne = barAbsPos + barAbsSize - dragAbsSize
				y2 -= mouseOffset
				y2 = y2 < barAbsPos and barAbsPos
					or y2 > barAbsOne and barAbsOne
					or y2
				y2 -= barAbsPos

				local guiObjects = 0
				local children = frame:GetChildren()
				if children then
					for _, child in ipairs(children) do
						if child:IsA "GuiObject" then
							guiObjects += 1
						end
					end
				end

				local doublePercent = y2 / (barAbsSize - dragAbsSize)
				local rowDiff = rowSize
				local totalScrollCount = guiObjects - (howManyDisplayed - 1)
				local newScrollPosition = math.floor(
					(doublePercent * totalScrollCount) + 0.5
				) + rowDiff
				if newScrollPosition < scrollPosition then
					rowDiff = -rowDiff
				end

				if newScrollPosition < 1 then
					newScrollPosition = 1
				end

				scrollPosition = newScrollPosition
				recalculate()
			end)
			upCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				dragCon:disconnect()
				dragCon = nil
				upCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
		end
	end)

	scrollMouseCount = 0

	scrollUpButton.MouseButton1Down:connect(function()
		scrollUp()
	end)
	scrollUpButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)

	scrollDownButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollDownButton.MouseButton1Down:connect(function()
		scrollDown()
	end)

	scrollbar.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollbar.MouseButton1Down:connect(function(_, y)
		if y > (scrollDrag.AbsoluteSize.y + scrollDrag.AbsolutePosition.y) then
			scrollDown(y)
		elseif y < scrollDrag.AbsolutePosition.y then
			scrollUp(y)
		end
	end)

	frame.ChildAdded:connect(function()
		recalculate()
	end)

	frame.ChildRemoved:connect(function()
		recalculate()
	end)

	frame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			--Wait a heartbeat for it to sync in
			recalculate()
		end
	end)
	frame.AncestryChanged:connect(function()
		recalculate()
	end)

	return frame, scrollUpButton, scrollDownButton, recalculate, scrollbar
end
local function binaryGrow(min, max, fits)
	if min > max then
		return min
	end
	local biggestLegal = min

	while min <= max do
		local mid = min + math.floor((max - min) / 2)
		if fits(mid) and (biggestLegal == nil or biggestLegal < mid) then
			biggestLegal = mid

			--Try growing
			min = mid + 1
		else
			--Doesn't fit, shrink
			max = mid - 1
		end
	end
	return biggestLegal
end

local function binaryShrink(min, max, fits)
	if min > max then
		return min
	end
	local smallestLegal = max

	while min <= max do
		local mid = min + math.floor((max - min) / 2)
		if fits(mid) and (smallestLegal == nil or smallestLegal > mid) then
			smallestLegal = mid

			--It fits, shrink
			max = mid - 1
		else
			--Doesn't fit, grow
			min = mid + 1
		end
	end
	return smallestLegal
end

local function getGuiOwner(instance)
	while instance ~= nil do
		if instance:IsA "ScreenGui" or instance:IsA "BillboardGui" then
			return instance
		end
		instance = instance.Parent
	end
	return nil
end

RbxGui.AutoTruncateTextObject = function(textLabel)
	local text = textLabel.Text

	local fullLabel = textLabel:Clone()
	fullLabel.Name = "Full" .. textLabel.Name
	fullLabel.BorderSizePixel = 0
	fullLabel.BackgroundTransparency = 0
	fullLabel.Text = text
	fullLabel.TextXAlignment = Enum.TextXAlignment.Center
	fullLabel.Position = UDim2.new(0, -3, 0, 0)
	fullLabel.Size = UDim2.new(0, 100, 1, 0)
	fullLabel.Visible = false
	fullLabel.Parent = textLabel

	local shortText
	local mouseEnterConnection
	local mouseLeaveConnection

	local checkForResize = function()
		if getGuiOwner(textLabel) == nil then
			return
		end
		textLabel.Text = text
		if textLabel.TextFits then
			--Tear down the rollover if it is active
			if mouseEnterConnection then
				mouseEnterConnection:disconnect()
				mouseEnterConnection = nil
			end
			if mouseLeaveConnection then
				mouseLeaveConnection:disconnect()
				mouseLeaveConnection = nil
			end
		else
			local len = string.len(text)
			textLabel.Text = `{text}~`

			--Shrink the text
			local textSize = binaryGrow(0, len, function(pos)
				if pos == 0 then
					textLabel.Text = "~"
				else
					textLabel.Text = `{string.sub(text, 1, pos)}~`
				end
				return textLabel.TextFits
			end)
			shortText = `{string.sub(text, 1, textSize)}~`
			textLabel.Text = shortText

			--Make sure the fullLabel fits
			if not fullLabel.TextFits then
				--Already too small, grow it really bit to start
				fullLabel.Size = UDim2.new(0, 10000, 1, 0)
			end

			--Okay, now try to binary shrink it back down
			local fullLabelSize = binaryShrink(
				textLabel.AbsoluteSize.X,
				fullLabel.AbsoluteSize.X,
				function(size)
					fullLabel.Size = UDim2.new(0, size, 1, 0)
					return fullLabel.TextFits
				end
			)
			fullLabel.Size = UDim2.new(0, fullLabelSize + 6, 1, 0)

			--Now setup the rollover effects, if they are currently off
			if mouseEnterConnection == nil then
				mouseEnterConnection = textLabel.MouseEnter:connect(function()
					fullLabel.ZIndex = textLabel.ZIndex + 1
					fullLabel.Visible = true
					--textLabel.Text = ""
				end)
			end
			if mouseLeaveConnection == nil then
				mouseLeaveConnection = textLabel.MouseLeave:connect(function()
					fullLabel.Visible = false
					--textLabel.Text = shortText
				end)
			end
		end
	end
	textLabel.AncestryChanged:connect(checkForResize)
	textLabel.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			checkForResize()
		end
	end)

	checkForResize()

	local function changeText(newText)
		text = newText
		fullLabel.Text = text
		checkForResize()
	end

	return textLabel, changeText
end

local function TransitionTutorialPages(
	fromPage,
	toPage,
	transitionFrame,
	currentPageValue
)
	if fromPage then
		fromPage.Visible = false
		if transitionFrame.Visible == false then
			transitionFrame.Size = fromPage.Size
			transitionFrame.Position = fromPage.Position
		end
	else
		if transitionFrame.Visible == false then
			transitionFrame.Size = UDim2.new(0, 50, 0, 50)
			transitionFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
		end
	end
	transitionFrame.Visible = true
	currentPageValue.Value = nil

	local newSize, newPosition
	if toPage then
		--Make it visible so it resizes
		toPage.Visible = true

		newSize = toPage.Size
		newPosition = toPage.Position

		toPage.Visible = false
	else
		newSize = UDim2.new(0, 50, 0, 50)
		newPosition = UDim2.new(0.5, -25, 0.5, -25)
	end
	transitionFrame:TweenSizeAndPosition(
		newSize,
		newPosition,
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quad,
		0.3,
		true,
		function(state)
			if state == Enum.TweenStatus.Completed then
				transitionFrame.Visible = false
				if toPage then
					toPage.Visible = true
					currentPageValue.Value = toPage
				end
			end
		end
	)
end

RbxGui.CreateTutorial = function(name, tutorialKey, createButtons)
	local frame = New "Frame" {
		Name = "Tutorial-" .. name,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Position = UDim2.new(0.2, 0, 0.2, 0),
		New "BoolValue" {
			Name = "Buttons",
			Value = createButtons,
		},
	}

	local transitionFrame = New "Frame" {
		Name = "TransitionFrame",
		Style = Enum.FrameStyle.RobloxRound,
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Position = UDim2.new(0.2, 0, 0.2, 0),
		Visible = false,
		Parent = frame,
	}

	local currentPageValue = New "ObjectValue" {
		Name = "CurrentTutorialPage",
		Value = nil,
		Parent = frame,
	}

	local pages = New "Frame" {
		Name = "Pages",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = frame,
	}

	local function getVisiblePageAndHideOthers()
		local visiblePage
		local children = pages:GetChildren()
		if children then
			for _, child in ipairs(children) do
				if child.Visible then
					if visiblePage then
						child.Visible = false
					else
						visiblePage = child
					end
				end
			end
		end
		return visiblePage
	end

	local showTutorial = function(alwaysShow)
		if
			alwaysShow
			or UserSettings().GameSettings:GetTutorialState(tutorialKey)
				== false
		then
			print("Showing tutorial-", tutorialKey)
			local currentTutorialPage = getVisiblePageAndHideOthers()

			local firstPage = pages:FindFirstChild "TutorialPage1"
			if firstPage then
				TransitionTutorialPages(
					currentTutorialPage,
					firstPage,
					transitionFrame,
					currentPageValue
				)
			else
				error "Could not find TutorialPage1"
			end
		end
	end

	local dismissTutorial = function()
		local currentTutorialPage = getVisiblePageAndHideOthers()

		if currentTutorialPage then
			TransitionTutorialPages(
				currentTutorialPage,
				nil,
				transitionFrame,
				currentPageValue
			)
		end

		UserSettings().GameSettings:SetTutorialState(tutorialKey, true)
	end

	local gotoPage = function(pageNum)
		local page = pages:FindFirstChild("TutorialPage" .. pageNum)
		local currentTutorialPage = getVisiblePageAndHideOthers()
		TransitionTutorialPages(
			currentTutorialPage,
			page,
			transitionFrame,
			currentPageValue
		)
	end

	return frame, showTutorial, dismissTutorial, gotoPage
end

local function CreateBasicTutorialPage(
	name: string,
	handleResize: (number, number) -> (),
	skipTutorial,
	giveDoneButton
)
	local frame = New "Frame" {
		Name = "TutorialPage",
		Style = Enum.FrameStyle.RobloxRound,
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Position = UDim2.new(0.2, 0, 0.2, 0),
		Visible = false,
		New "TextLabel" {
			Name = "Header",
			Text = name,
			BackgroundTransparency = 1,
			FontSize = Enum.FontSize.Size24,
			Font = Enum.Font.ArialBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrap = true,
			Size = UDim2.new(1, -55, 0, 22),
			Position = UDim2.new(0, 0, 0, 0),
		},
		New "TextButton" {
			Name = "NextButton",
			Text = "Next",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Size = UDim2.new(0, 80, 0, 32),
			Position = UDim2.new(0.5, 5, 1, -32),
			Active = false,
			Visible = false,
		},
		New "TextButton" {
			Name = "PrevButton",
			Text = "Previous",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Style = Enum.ButtonStyle.RobloxButton,
			Size = UDim2.new(0, 80, 0, 32),
			Position = UDim2.new(0.5, -85, 1, -32),
			Active = false,
			Visible = false,
		},
	}

	local skipButton = New "ImageButton" {
		Name = "SkipButton",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/closeButton.png",
		Size = UDim2.new(0, 25, 0, 25),
		Position = UDim2.new(1, -25, 0, 0),
	}

	skipButton.MouseButton1Click:connect(function()
		skipTutorial()
	end)
	skipButton.MouseEnter:connect(function()
		skipButton.Image = "rbxasset://textures/ui/closeButton_dn.png"
	end)
	skipButton.MouseLeave:connect(function()
		skipButton.Image = "rbxasset://textures/ui/closeButton.png"
	end)
	skipButton.Parent = frame

	if giveDoneButton then
		local doneButton = New "TextButton" {
			Name = "DoneButton",
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Text = "Done",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			Size = UDim2.new(0, 100, 0, 50),
			Position = UDim2.new(0.5, -50, 1, -50),
		}

		if skipTutorial then
			doneButton.MouseButton1Click:connect(function()
				skipTutorial()
			end)
		end

		doneButton.Parent = frame
	end

	local innerFrame = New "Frame" {
		Name = "ContentFrame",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 25),
		Parent = frame,
	}

	if giveDoneButton then
		innerFrame.Size = UDim2.new(1, 0, 1, -75)
	else
		innerFrame.Size = UDim2.new(1, 0, 1, -22)
	end

	local parentConnection

	local function basicHandleResize()
		if frame.Visible and frame.Parent then
			local maxSize = math.min(
				frame.Parent.AbsoluteSize.X,
				frame.Parent.AbsoluteSize.Y
			)
			handleResize(200, maxSize)
		end
	end

	frame.Changed:connect(function(prop)
		if prop == "Parent" then
			if parentConnection ~= nil then
				parentConnection:disconnect()
				parentConnection = nil
			end
			if frame.Parent and frame.Parent:IsA "GuiObject" then
				parentConnection = frame.Parent.Changed:connect(
					function(parentProp)
						if parentProp == "AbsoluteSize" then
							wait()
							basicHandleResize()
						end
					end
				)
				basicHandleResize()
			end
		end

		if prop == "Visible" then
			basicHandleResize()
		end
	end)

	return frame, innerFrame
end

RbxGui.CreateTextTutorialPage = function(name, text, skipTutorialFunc)
	local frame
	local contentFrame

	local textLabel = New "TextLabel" {
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Text = text,
		TextWrap = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size14,
		Size = UDim2.new(1, 0, 1, 0),
	}

	local function handleResize(minSize, maxSize)
		local size = binaryShrink(minSize, maxSize, function(newSize)
			frame.Size = UDim2.new(0, newSize, 0, newSize)
			return textLabel.TextFits
		end)
		frame.Size = UDim2.new(0, size, 0, size)
		frame.Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2)
	end

	frame, contentFrame =
		CreateBasicTutorialPage(name, handleResize, skipTutorialFunc)
	textLabel.Parent = contentFrame

	return frame
end

RbxGui.CreateImageTutorialPage = function(
	name,
	imageAsset,
	x,
	y,
	skipTutorialFunc,
	giveDoneButton
)
	local frame
	local contentFrame

	-- local imageLabel = Instance.new "ImageLabel"
	-- imageLabel.BackgroundTransparency = 1
	-- imageLabel.Image = imageAsset
	-- imageLabel.Size = UDim2.new(0, x, 0, y)
	-- imageLabel.Position = UDim2.new(0.5, -x / 2, 0.5, -y / 2)
	local imageLabel = New "ImageLabel" {
		BackgroundTransparency = 1,
		Image = imageAsset,
		Size = UDim2.new(0, x, 0, y),
		Position = UDim2.new(0.5, -x / 2, 0.5, -y / 2),
	}

	local function handleResize(minSize, maxSize)
		local size = binaryShrink(minSize, maxSize, function(newSize)
			return newSize >= x and newSize >= y
		end)
		if size >= x and size >= y then
			imageLabel.Size = UDim2.new(0, x, 0, y)
			imageLabel.Position = UDim2.new(0.5, -x / 2, 0.5, -y / 2)
		else
			if x > y then
				--X is limiter, so
				imageLabel.Size = UDim2.new(1, 0, y / x, 0)
				imageLabel.Position = UDim2.new(0, 0, 0.5 - (y / x) / 2, 0)
			else
				--Y is limiter
				imageLabel.Size = UDim2.new(x / y, 0, 1, 0)
				imageLabel.Position = UDim2.new(0.5 - (x / y) / 2, 0, 0, 0)
			end
		end
		size += 50
		frame.Size = UDim2.new(0, size, 0, size)
		frame.Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2)
	end

	frame, contentFrame = CreateBasicTutorialPage(
		name,
		handleResize,
		skipTutorialFunc,
		giveDoneButton
	)
	imageLabel.Parent = contentFrame

	return frame
end

RbxGui.AddTutorialPage = function(tutorial, tutorialPage)
	local transitionFrame = tutorial.TransitionFrame
	local currentPageValue = tutorial.CurrentTutorialPage

	if not tutorial.Buttons.Value then
		tutorialPage.NextButton.Parent = nil
		tutorialPage.PrevButton.Parent = nil
	end

	local children = tutorial.Pages:GetChildren()
	if children and #children > 0 then
		tutorialPage.Name = "TutorialPage" .. (#children + 1)
		local previousPage = children[#children]
		if not previousPage:IsA "GuiObject" then
			error "All elements under Pages must be GuiObjects"
		end

		if tutorial.Buttons.Value then
			if previousPage.NextButton.Active then
				error "NextButton already Active on previousPage, please only add pages with RbxGui.AddTutorialPage function"
			end
			previousPage.NextButton.MouseButton1Click:connect(function()
				TransitionTutorialPages(
					previousPage,
					tutorialPage,
					transitionFrame,
					currentPageValue
				)
			end)
			previousPage.NextButton.Active = true
			previousPage.NextButton.Visible = true

			if tutorialPage.PrevButton.Active then
				error "PrevButton already Active on tutorialPage, please only add pages with RbxGui.AddTutorialPage function"
			end
			tutorialPage.PrevButton.MouseButton1Click:connect(function()
				TransitionTutorialPages(
					tutorialPage,
					previousPage,
					transitionFrame,
					currentPageValue
				)
			end)
			tutorialPage.PrevButton.Active = true
			tutorialPage.PrevButton.Visible = true
		end

		tutorialPage.Parent = tutorial.Pages
	else
		--First child
		tutorialPage.Name = "TutorialPage1"
		tutorialPage.Parent = tutorial.Pages
	end
end

RbxGui.CreateSetPanel = function(
	userIdsForSets,
	objectSelected,
	dialogClosed,
	size,
	position,
	showAdminCategories,
	useAssetVersionId
)
	if not userIdsForSets then
		error "CreateSetPanel: userIdsForSets (first arg) is nil, should be a table of number ids"
	end
	if
		type(userIdsForSets) ~= "table"
		and type(userIdsForSets) ~= "userdata"
	then
		error(
			`CreateSetPanel: userIdsForSets (first arg) is of type {type(
				userIdsForSets
			)}, should be of type table or userdata`
		)
	end
	if not objectSelected then
		error "CreateSetPanel: objectSelected (second arg) is nil, should be a callback function!"
	end
	if type(objectSelected) ~= "function" then
		error(
			`CreateSetPanel: objectSelected (second arg) is of type {type(
				objectSelected
			)}, should be of type function!`
		)
	end
	if dialogClosed and type(dialogClosed) ~= "function" then
		error(
			`CreateSetPanel: dialogClosed (third arg) is of type {type(
				dialogClosed
			)}, should be of type function!`
		)
	end

	if showAdminCategories == nil then -- by default, don't show beta sets
		showAdminCategories = false
	end

	local arrayPosition = 1
	local insertButtons = {}
	local insertButtonCons = {}
	local contents
	local setGui

	-- used for water selections
	local waterForceDirection = "NegX"
	local waterForce = "None"
	local waterGui, waterTypeChangedEvent

	local Data = {}
	Data.CurrentCategory = nil
	Data.Category = {}
	local SetCache = {}

	local userCategoryButtons

	local buttonWidth = 64
	local buttonHeight = buttonWidth

	local SmallThumbnailUrl
	local LargeThumbnailUrl
	local BaseUrl = game:GetService("ContentProvider").BaseUrl:lower()
	local ThumbUrl = `{BaseUrl}Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=`

	if useAssetVersionId then
		LargeThumbnailUrl = `{ThumbUrl}420&ht=420&assetversionid=`
		SmallThumbnailUrl = `{ThumbUrl}75&ht=75&assetversionid=`
	else
		LargeThumbnailUrl = `{ThumbUrl}420&ht=420&aid=`
		SmallThumbnailUrl = `{ThumbUrl}75&ht=75&aid=`
	end

	local function drillDownSetZIndex(parent, index)
		local children = parent:GetChildren()
		for i = 1, #children do
			if children[i]:IsA "GuiObject" then
				children[i].ZIndex = index
			end
			drillDownSetZIndex(children[i], index)
		end
	end

	-- for terrain stamping
	local currTerrainDropDownFrame
	local terrainShapes = {
		"Block",
		"Vertical Ramp",
		"Corner Wedge",
		"Inverse Corner Wedge",
		"Horizontal Ramp",
		"Auto-Wedge",
	}
	local terrainShapeMap = {}
	for i = 1, #terrainShapes do
		terrainShapeMap[terrainShapes[i]] = i - 1
	end
	terrainShapeMap[terrainShapes[#terrainShapes]] = 6

	local function createWaterGui()
		local waterForceDirections = { "NegX", "X", "NegY", "Y", "NegZ", "Z" }
		local waterForces = { "None", "Small", "Medium", "Strong", "Max" }

		local waterFrame = New "Frame" {
			Name = "WaterFrame",
			Style = Enum.FrameStyle.RobloxSquare,
			Size = UDim2.new(0, 150, 0, 110),
			Visible = false,
		}

		local waterForceLabel = New "TextLabel" {
			Name = "WaterForceLabel",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 12),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size12,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "Water Force",
			Parent = waterFrame,
		}

		local waterForceDirLabel = New(waterForceLabel:Clone()) {
			Name = "WaterForceDirectionLabel",
			Text = "Water Force Direction",
			Position = UDim2.new(0, 0, 0, 50),
			Parent = waterFrame,
		}

		waterTypeChangedEvent = New "BindableEvent" {
			Name = "WaterTypeChangedEvent",
			Parent = waterFrame,
		}

		local function waterForceDirectionSelected(newForceDirection)
			waterForceDirection = newForceDirection
			waterTypeChangedEvent:Fire { waterForce, waterForceDirection }
		end
		local function waterForceSelected(newForce)
			waterForce = newForce
			waterTypeChangedEvent:Fire { waterForce, waterForceDirection }
		end

		local waterForceDirectionDropDown, forceWaterDirectionSelection =
			RbxGui.CreateDropDownMenu(
				waterForceDirections,
				waterForceDirectionSelected
			)
		waterForceDirectionDropDown.Size = UDim2.new(1, 0, 0, 25)
		waterForceDirectionDropDown.Position = UDim2.new(0, 0, 1, 3)
		forceWaterDirectionSelection "NegX"
		waterForceDirectionDropDown.Parent = waterForceDirLabel

		local waterForceDropDown, forceWaterForceSelection =
			RbxGui.CreateDropDownMenu(waterForces, waterForceSelected)
		forceWaterForceSelection "None"
		waterForceDropDown.Size = UDim2.new(1, 0, 0, 25)
		waterForceDropDown.Position = UDim2.new(0, 0, 1, 3)
		waterForceDropDown.Parent = waterForceLabel

		return waterFrame, waterTypeChangedEvent
	end

	-- Helper Function that contructs gui elements
	local function createSetGui()
		setGui = New "ScreenGui" {
			Name = "SetGui",
		}

		local setsLists, controlFrame = RbxGui.CreateTrueScrollingFrame()

		drillDownSetZIndex(controlFrame, 7)

		local setPanel = New "Frame" {
			Name = "SetPanel",
			Active = true,
			BackgroundTransparency = 1,
			Style = Enum.FrameStyle.RobloxRound,
			ZIndex = 6,
			New "Frame" {
				Name = "ItemPreview",
				BackgroundTransparency = 1,
				Position = UDim2.new(0.8, 5, 0.085, 0),
				Size = UDim2.new(0.21, 0, 0.9, 0),
				ZIndex = 6,
				New "Frame" {
					Name = "TextPanel",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0.45, 0),
					Size = UDim2.new(1, 0, 0.55, 0),
					ZIndex = 6,
					New "TextLabel" {
						Name = "RolloverText",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 48),
						ZIndex = 6,
						Font = Enum.Font.ArialBold,
						FontSize = Enum.FontSize.Size24,
						Text = "",
						TextColor3 = Color3.new(1, 1, 1),
						TextWrap = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
					},
				},
				New "ImageLabel" {
					Name = "LargePreview",
					BackgroundTransparency = 1,
					Image = "",
					Size = UDim2.new(1, 0, 0, 170),
					ZIndex = 6,
				},
			},
			New "Frame" {
				Name = "Sets",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 5),
				Size = UDim2.new(0.23, 0, 1, -5),
				ZIndex = 6,
				New "Frame" {
					Name = "Line",
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 0.7,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -3, 0.06, 0),
					Size = UDim2.new(0, 3, 0.9, 0),
					ZIndex = 6,
				},
				New(setsLists) {
					Size = UDim2.new(1, -6, 0.94, 0),
					Position = UDim2.new(0, 0, 0.06, 0),
					BackgroundTransparency = 1,
					Name = "SetsLists",
					ZIndex = 6,
				},
				New "TextLabel" {
					Name = "SetsHeader",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 47, 0, 24),
					ZIndex = 6,
					Font = Enum.Font.ArialBold,
					FontSize = Enum.FontSize.Size24,
					Text = "Sets",
					TextColor3 = Color3.new(1, 1, 1),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
				},
			},
			New "TextButton" {
				Name = "CancelButton",
				Position = UDim2.new(1, -32, 0, -2),
				Size = UDim2.new(0, 34, 0, 34),
				Style = Enum.ButtonStyle.RobloxButtonDefault,
				ZIndex = 6,
				Text = "",
				Modal = true,
				New "ImageLabel" {
					Name = "CancelImage",
					BackgroundTransparency = 1,
					Image = "http://banland.xyz/asset?id=54135717",
					Position = UDim2.new(0, -2, 0, -2),
					Size = UDim2.new(0, 16, 0, 16),
					ZIndex = 6,
				},
			},
		}

		if position then
			setPanel.Position = position
		else
			setPanel.Position = UDim2.new(0.2, 29, 0.1, 24)
		end
		if size then
			setPanel.Size = size
		else
			setPanel.Size = UDim2.new(0.6, -58, 0.64, 0)
		end
		setPanel.Parent = setGui

		return setGui
	end

	local function createSetButton(text)
		return New "TextButton" {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.new(1, -5, 0, 18),
			ZIndex = 6,
			Visible = false,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = text or "",
		}
	end

	local function buildSetButton(name, setId, _, _, _)
		return New(createSetButton(name)) {
			Text = name,
			Name = "SetButton",
			Visible = true,
			New "IntValue" {
				Name = "SetId",
				Value = setId,
			},
			New "StringValue" {
				Name = "SetName",
				Value = name,
			},
		}
	end

	local function processCategory(sets)
		local setButtons = {}
		local numSkipped = 0
		for i = 1, #sets do
			if not showAdminCategories and sets[i].Name == "Beta" then
				numSkipped += 1
			else
				setButtons[i - numSkipped] = buildSetButton(
					sets[i].Name,
					sets[i].CategoryId,
					sets[i].ImageAssetId,
					i - numSkipped,
					#sets
				)
			end
		end
		return setButtons
	end

	local function handleResize()
		wait() -- neccessary to insure heartbeat happened

		local itemPreview = setGui.SetPanel.ItemPreview

		itemPreview.LargePreview.Size =
			UDim2.new(1, 0, 0, itemPreview.AbsoluteSize.X)
		itemPreview.LargePreview.Position =
			UDim2.new(0.5, -itemPreview.LargePreview.AbsoluteSize.X / 2, 0, 0)
		itemPreview.TextPanel.Position =
			UDim2.new(0, 0, 0, itemPreview.LargePreview.AbsoluteSize.Y)
		itemPreview.TextPanel.Size = UDim2.new(
			1,
			0,
			0,
			itemPreview.AbsoluteSize.Y - itemPreview.LargePreview.AbsoluteSize.Y
		)
	end

	local function makeInsertAssetButton()
		local insertAssetButtonExample = New "Frame" {
			Name = "InsertAssetButtonExample",
			Position = UDim2.new(0, 128, 0, 64),
			Size = UDim2.new(0, 64, 0, 64),
			BackgroundTransparency = 1,
			ZIndex = 6,
			Visible = false,
			New "IntValue" {
				Name = "AssetId",
				Value = 0,
			},
			New "StringValue" {
				Name = "AssetName",
				Value = "",
			},
		}

		local button = New "TextButton" {
			Name = "Button",
			Text = "",
			Style = Enum.ButtonStyle.RobloxButton,
			Position = UDim2.new(0.025, 0, 0.025, 0),
			Size = UDim2.new(0.95, 0, 0.95, 0),
			ZIndex = 6,
			Parent = insertAssetButtonExample,
		}

		local buttonImage = New "ImageLabel" {
			Name = "ButtonImage",
			Image = "",
			Position = UDim2.new(0, -7, 0, -7),
			Size = UDim2.new(1, 14, 1, 14),
			BackgroundTransparency = 1,
			ZIndex = 7,
			Parent = button,
		}

		New(buttonImage:Clone()) {
			Name = "ConfigIcon",
			Visible = false,
			Position = UDim2.new(1, -23, 1, -24),
			Size = UDim2.new(0, 16, 0, 16),
			Image = "",
			ZIndex = 6,
			Parent = insertAssetButtonExample,
		}

		return insertAssetButtonExample
	end

	local function showLargePreview(insertButton)
		if insertButton:FindFirstChild "AssetId" then
			delay(0, function()
				game:GetService("ContentProvider"):Preload(
					LargeThumbnailUrl .. tostring(insertButton.AssetId.Value)
				)
				setGui.SetPanel.ItemPreview.LargePreview.Image = LargeThumbnailUrl
					.. tostring(insertButton.AssetId.Value)
			end)
		end
		if insertButton:FindFirstChild "AssetName" then
			setGui.SetPanel.ItemPreview.TextPanel.RolloverText.Text =
				insertButton.AssetName.Value
		end
	end

	local function selectTerrainShape(shape)
		if currTerrainDropDownFrame then
			objectSelected(
				tostring(currTerrainDropDownFrame.AssetName.Value),
				tonumber(currTerrainDropDownFrame.AssetId.Value),
				shape
			)
		end
	end

	local function createTerrainTypeButton(name, parent)
		local dropDownTextButton = New "TextButton" {
			Name = `{name}Button`,
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size14,
			BorderSizePixel = 0,
			TextColor3 = Color3.new(1, 1, 1),
			Text = name,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			ZIndex = parent.ZIndex + 1,
			Size = UDim2.new(0, parent.Size.X.Offset - 2, 0, 16),
			Position = UDim2.new(0, 1, 0, 0),
		}

		dropDownTextButton.MouseEnter:connect(function()
			dropDownTextButton.BackgroundTransparency = 0
			dropDownTextButton.TextColor3 = Color3.new(0, 0, 0)
		end)

		dropDownTextButton.MouseLeave:connect(function()
			dropDownTextButton.BackgroundTransparency = 1
			dropDownTextButton.TextColor3 = Color3.new(1, 1, 1)
		end)

		dropDownTextButton.MouseButton1Click:connect(function()
			dropDownTextButton.BackgroundTransparency = 1
			dropDownTextButton.TextColor3 = Color3.new(1, 1, 1)
			if
				dropDownTextButton.Parent
				and dropDownTextButton.Parent:IsA "GuiObject"
			then
				dropDownTextButton.Parent.Visible = false
			end
			selectTerrainShape(terrainShapeMap[dropDownTextButton.Text])
		end)

		return dropDownTextButton
	end

	local function createTerrainDropDownMenu(zIndex)
		local dropDown = New "Frame" {
			Name = "TerrainDropDown",
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderColor3 = Color3.new(1, 0, 0),
			Size = UDim2.new(0, 200, 0, 0),
			Visible = false,
			ZIndex = zIndex,
			Parent = setGui,
		}

		for i = 1, #terrainShapes do
			local shapeButton =
				createTerrainTypeButton(terrainShapes[i], dropDown)
			shapeButton.Position =
				UDim2.new(0, 1, 0, (i - 1) * shapeButton.Size.Y.Offset)
			shapeButton.Parent = dropDown
			dropDown.Size = UDim2.new(
				0,
				200,
				0,
				dropDown.Size.Y.Offset + shapeButton.Size.Y.Offset
			)
		end

		dropDown.MouseLeave:connect(function()
			dropDown.Visible = false
		end)
	end

	local function createDropDownMenuButton(parent)
		-- local dropDownButton = Instance.new "ImageButton"
		-- dropDownButton.Name = "DropDownButton"
		-- dropDownButton.Image = "http://banland.xyz/asset/?id=67581509"
		-- dropDownButton.BackgroundTransparency = 1
		-- dropDownButton.Size = UDim2.new(0, 16, 0, 16)
		-- dropDownButton.Position = UDim2.new(1, -24, 0, 6)
		-- dropDownButton.ZIndex = parent.ZIndex + 2
		-- dropDownButton.Parent = parent
		local dropDownButton = New "ImageButton" {
			Name = "DropDownButton",
			Image = "http://banland.xyz/asset/?id=67581509",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(1, -24, 0, 6),
			ZIndex = parent.ZIndex + 2,
			Parent = parent,
		}

		if not setGui:FindFirstChild "TerrainDropDown" then
			createTerrainDropDownMenu(8)
		end

		dropDownButton.MouseButton1Click:connect(function()
			setGui.TerrainDropDown.Visible = true
			setGui.TerrainDropDown.Position = UDim2.new(
				0,
				parent.AbsolutePosition.X,
				0,
				parent.AbsolutePosition.Y
			)
			currTerrainDropDownFrame = parent
		end)
	end

	local function buildInsertButton()
		local insertButton = makeInsertAssetButton()
		insertButton.Name = "InsertAssetButton"
		insertButton.Visible = true

		if
			Data.Category[Data.CurrentCategory].SetName == "High Scalability"
		then
			createDropDownMenuButton(insertButton)
		end

		local lastEnter
		local mouseEnterCon = insertButton.MouseEnter:connect(function()
			lastEnter = insertButton
			delay(0.1, function()
				if lastEnter == insertButton then
					showLargePreview(insertButton)
				end
			end)
		end)
		return insertButton, mouseEnterCon
	end

	local function realignButtonGrid(columns)
		local x = 0
		local y = 0
		for i = 1, #insertButtons do
			insertButtons[i].Position =
				UDim2.new(0, buttonWidth * x, 0, buttonHeight * y)
			x += 1
			if x >= columns then
				x = 0
				y += 1
			end
		end
	end

	local function setInsertButtonImageBehavior(
		insertFrame,
		visible,
		name,
		assetId
	)
		if visible then
			insertFrame.AssetName.Value = name
			insertFrame.AssetId.Value = assetId
			local newImageUrl = SmallThumbnailUrl .. assetId
			if newImageUrl ~= insertFrame.Button.ButtonImage.Image then
				delay(0, function()
					game:GetService("ContentProvider")
						:Preload(SmallThumbnailUrl .. assetId)
					insertFrame.Button.ButtonImage.Image = SmallThumbnailUrl
						.. assetId
				end)
			end
			table.insert(
				insertButtonCons,
				insertFrame.Button.MouseButton1Click:connect(function()
					-- special case for water, show water selection gui
					local isWaterSelected = (name == "Water")
						and (
							Data.Category[Data.CurrentCategory].SetName
							== "High Scalability"
						)
					waterGui.Visible = isWaterSelected
					if isWaterSelected then
						objectSelected(name, tonumber(assetId), nil)
					else
						objectSelected(name, tonumber(assetId))
					end
				end)
			)
			insertFrame.Visible = true
		else
			insertFrame.Visible = false
		end
	end

	local function loadSectionOfItems(setGui, rows, columns)
		local pageSize = rows * columns

		if arrayPosition > #contents then
			return
		end

		local origArrayPos = arrayPosition

		for _ = 1, pageSize + 1 do
			if arrayPosition >= #contents + 1 then
				break
			end

			local buttonCon
			insertButtons[arrayPosition], buttonCon = buildInsertButton()
			table.insert(insertButtonCons, buttonCon)
			insertButtons[arrayPosition].Parent = setGui.SetPanel.ItemsFrame
			arrayPosition += 1
		end
		realignButtonGrid(columns)

		-- local indexCopy = origArrayPos
		for index = origArrayPos, arrayPosition do
			if insertButtons[index] then
				if contents[index] then
					-- we don't want water to have a drop down button
					if contents[index].Name == "Water" then
						if
							Data.Category[Data.CurrentCategory].SetName
							== "High Scalability"
						then
							insertButtons[index]
								:FindFirstChild("DropDownButton", true)
								:Destroy()
						end
					end

					local assetId
					if useAssetVersionId then
						assetId = contents[index].AssetVersionId
					else
						assetId = contents[index].AssetId
					end
					setInsertButtonImageBehavior(
						insertButtons[index],
						true,
						contents[index].Name,
						assetId
					)
				else
					break
				end
			else
				break
			end
			-- indexCopy = index
		end
	end

	local function setSetIndex()
		Data.Category[Data.CurrentCategory].Index = 0

		local rows = 7
		local columns =
			math.floor(setGui.SetPanel.ItemsFrame.AbsoluteSize.X / buttonWidth)

		contents = Data.Category[Data.CurrentCategory].Contents
		if contents then
			-- remove our buttons and their connections
			for i = 1, #insertButtons do
				insertButtons[i]:remove()
			end
			for i = 1, #insertButtonCons do
				if insertButtonCons[i] then
					insertButtonCons[i]:disconnect()
				end
			end
			insertButtonCons = {}
			insertButtons = {}

			arrayPosition = 1
			loadSectionOfItems(setGui, rows, columns)
		end
	end

	local function selectSet(button, setName, setId, _)
		if button and Data.Category[Data.CurrentCategory] ~= nil then
			if button ~= Data.Category[Data.CurrentCategory].Button then
				Data.Category[Data.CurrentCategory].Button = button

				if SetCache[setId] == nil then
					SetCache[setId] = game:GetService("InsertService")
						:GetCollection(setId)
				end
				Data.Category[Data.CurrentCategory].Contents = SetCache[setId]

				Data.Category[Data.CurrentCategory].SetName = setName
				Data.Category[Data.CurrentCategory].SetId = setId
			end
			setSetIndex()
		end
	end

	local function selectCategoryPage(buttons, _)
		if buttons ~= Data.CurrentCategory then
			if Data.CurrentCategory then
				for _, button in pairs(Data.CurrentCategory) do
					button.Visible = false
				end
			end

			Data.CurrentCategory = buttons
			if Data.Category[Data.CurrentCategory] == nil then
				Data.Category[Data.CurrentCategory] = {}
				if #buttons > 0 then
					selectSet(
						buttons[1],
						buttons[1].SetName.Value,
						buttons[1].SetId.Value,
						0
					)
				end
			else
				Data.Category[Data.CurrentCategory].Button = nil
				selectSet(
					Data.Category[Data.CurrentCategory].ButtonFrame,
					Data.Category[Data.CurrentCategory].SetName,
					Data.Category[Data.CurrentCategory].SetId,
					Data.Category[Data.CurrentCategory].Index
				)
			end
		end
	end

	local function selectCategory(category)
		selectCategoryPage(category, 0)
	end

	local function resetAllSetButtonSelection()
		local setButtons = setGui.SetPanel.Sets.SetsLists:GetChildren()
		for _, setButton in ipairs(setButtons) do
			if setButton:IsA "TextButton" then
				setButton.Selected = false
				setButton.BackgroundTransparency = 1
				setButton.TextColor3 = Color3.new(1, 1, 1)
				setButton.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end
	end

	local function populateSetsFrame()
		local currRow = 0
		for i = 1, #userCategoryButtons do
			local button = userCategoryButtons[i]
			button.Visible = true
			button.Position = UDim2.new(0, 5, 0, currRow * button.Size.Y.Offset)
			button.Parent = setGui.SetPanel.Sets.SetsLists

			if i == 1 then -- we will have this selected by default, so show it
				button.Selected = true
				button.BackgroundColor3 = Color3.new(0, 204 / 255, 0)
				button.TextColor3 = Color3.new(0, 0, 0)
				button.BackgroundTransparency = 0
			end

			button.MouseEnter:connect(function()
				if not button.Selected then
					button.BackgroundTransparency = 0
					button.TextColor3 = Color3.new(0, 0, 0)
				end
			end)
			button.MouseLeave:connect(function()
				if not button.Selected then
					button.BackgroundTransparency = 1
					button.TextColor3 = Color3.new(1, 1, 1)
				end
			end)
			button.MouseButton1Click:connect(function()
				resetAllSetButtonSelection()
				button.Selected = not button.Selected
				button.BackgroundColor3 = Color3.new(0, 204 / 255, 0)
				button.TextColor3 = Color3.new(0, 0, 0)
				button.BackgroundTransparency = 0
				selectSet(
					button,
					button.Text,
					userCategoryButtons[i].SetId.Value,
					0
				)
			end)

			currRow += 1
		end

		local buttons = setGui.SetPanel.Sets.SetsLists:GetChildren()

		-- set first category as loaded for default
		if buttons then
			for i = 1, #buttons do
				if buttons[i]:IsA "TextButton" then
					selectSet(
						buttons[i],
						buttons[i].Text,
						userCategoryButtons[i].SetId.Value,
						0
					)
					selectCategory(userCategoryButtons)
					break
				end
			end
		end
	end

	setGui = createSetGui()
	waterGui, waterTypeChangedEvent = createWaterGui()
	waterGui.Position = UDim2.new(0, 55, 0, 0)
	waterGui.Parent = setGui
	setGui.Changed:connect(
		function(prop) -- this resizes the preview image to always be the right size
			if prop == "AbsoluteSize" then
				handleResize()
				setSetIndex()
			end
		end
	)

	local scrollFrame, controlFrame = RbxGui.CreateTrueScrollingFrame()
	New(scrollFrame) {
		Size = UDim2.new(0.54, 0, 0.85, 0),
		Position = UDim2.new(0.24, 0, 0.085, 0),
		Name = "ItemsFrame",
		ZIndex = 6,
		Parent = setGui.SetPanel,
		BackgroundTransparency = 1,
	}

	drillDownSetZIndex(controlFrame, 7)

	controlFrame.Parent = setGui.SetPanel
	controlFrame.Position = UDim2.new(0.76, 5, 0, 0)

	local rows =
		math.floor(setGui.SetPanel.ItemsFrame.AbsoluteSize.Y / buttonHeight)
	local columns =
		math.floor(setGui.SetPanel.ItemsFrame.AbsoluteSize.X / buttonWidth)

	local debounce = false
	controlFrame.ScrollBottom.Changed:connect(function(_)
		if controlFrame.ScrollBottom.Value == true then
			if debounce then
				return
			end
			debounce = true
			loadSectionOfItems(setGui, rows, columns)
			debounce = false
		end
	end)

	local userData = {}
	for id = 1, #userIdsForSets do
		local newUserData = game:GetService("InsertService")
			:GetUserSets(userIdsForSets[id])
		if newUserData and #newUserData > 2 then
			-- start at #3 to skip over My Decals and My Models for each account
			for category = 3, #newUserData do
				if newUserData[category].Name == "High Scalability" then -- we want high scalability parts to show first
					table.insert(userData, 1, newUserData[category])
				else
					table.insert(userData, newUserData[category])
				end
			end
		end
	end
	if userData then
		userCategoryButtons = processCategory(userData)
	end

	populateSetsFrame()

	--[[local insertPanelCloseCon = ]]
	setGui.SetPanel.CancelButton.MouseButton1Click:connect(function()
		setGui.SetPanel.Visible = false
		if dialogClosed then
			dialogClosed()
		end
	end)

	local setVisibilityFunction = function(visible)
		if visible then
			setGui.SetPanel.Visible = true
		else
			setGui.SetPanel.Visible = false
		end
	end

	local getVisibilityFunction = function()
		if setGui then
			if setGui:FindFirstChild "SetPanel" then
				return setGui.SetPanel.Visible
			end
		end

		return false
	end

	return setGui,
		setVisibilityFunction,
		getVisibilityFunction,
		waterTypeChangedEvent
end

local function getEnumFromName(choice)
	if choice == "Grass" then
		return 1
	elseif choice == "Sand" then
		return 2
	elseif choice == "Erase" then
		return 0
	elseif choice == "Brick" then
		return 3
	elseif choice == "Granite" then
		return 4
	elseif choice == "Asphalt" then
		return 5
	elseif choice == "Iron" then
		return 6
	elseif choice == "Aluminum" then
		return 7
	elseif choice == "Gold" then
		return 8
	elseif choice == "Plank" then
		return 9
	elseif choice == "Log" then
		return 10
	elseif choice == "Gravel" then
		return 11
	elseif choice == "Cinder Block" then
		return 12
	elseif choice == "Stone Wall" then
		return 13
	elseif choice == "Concrete" then
		return 14
	elseif choice == "Plastic (red)" then
		return 15
	elseif choice == "Plastic (blue)" then
		return 16
	elseif choice == "Water" then
		return 17
	end
	return
end

local function getNameFromEnum(choice)
	if choice == Enum.CellMaterial.Grass or choice == 1 then
		return "Grass"
	elseif choice == Enum.CellMaterial.Sand or choice == 2 then
		return "Sand"
	elseif choice == Enum.CellMaterial.Empty or choice == 0 then
		return "Erase"
	elseif choice == Enum.CellMaterial.Brick or choice == 3 then
		return "Brick"
	elseif choice == Enum.CellMaterial.Granite or choice == 4 then
		return "Granite"
	elseif choice == Enum.CellMaterial.Asphalt or choice == 5 then
		return "Asphalt"
	elseif choice == Enum.CellMaterial.Iron or choice == 6 then
		return "Iron"
	elseif choice == Enum.CellMaterial.Aluminum or choice == 7 then
		return "Aluminum"
	elseif choice == Enum.CellMaterial.Gold or choice == 8 then
		return "Gold"
	elseif choice == Enum.CellMaterial.WoodPlank or choice == 9 then
		return "Plank"
	elseif choice == Enum.CellMaterial.WoodLog or choice == 10 then
		return "Log"
	elseif choice == Enum.CellMaterial.Gravel or choice == 11 then
		return "Gravel"
	elseif choice == Enum.CellMaterial.CinderBlock or choice == 12 then
		return "Cinder Block"
	elseif choice == Enum.CellMaterial.MossyStone or choice == 13 then
		return "Stone Wall"
	elseif choice == Enum.CellMaterial.Cement or choice == 14 then
		return "Concrete"
	elseif choice == Enum.CellMaterial.RedPlastic or choice == 15 then
		return "Plastic (red)"
	elseif choice == Enum.CellMaterial.BluePlastic or choice == 16 then
		return "Plastic (blue)"
	elseif choice == Enum.CellMaterial.Water or choice == 17 then
		return "Water"
	end
	return
end

RbxGui.CreateTerrainMaterialSelector = function(size, position)
	local terrainMaterialSelectionChanged = Instance.new "BindableEvent"
	terrainMaterialSelectionChanged.Name = "TerrainMaterialSelectionChanged"

	local selectedButton

	local frame = Instance.new "Frame"
	frame.Name = "TerrainMaterialSelector"
	frame.Size = size or UDim2.new(0, 245, 0, 230)
	if position then
		frame.Position = position
	end
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.Active = true

	terrainMaterialSelectionChanged.Parent = frame

	local materialToImageMap = {}
	local materialNames = {
		"Grass",
		"Sand",
		"Brick",
		"Granite",
		"Asphalt",
		"Iron",
		"Aluminum",
		"Gold",
		"Plank",
		"Log",
		"Gravel",
		"Cinder Block",
		"Stone Wall",
		"Concrete",
		"Plastic (red)",
		"Plastic (blue)",
		"Water",
	}

	local currentMaterial = 1

	local function updateMaterialChoice(choice)
		currentMaterial = getEnumFromName(choice)
		terrainMaterialSelectionChanged:Fire(currentMaterial)
	end

	-- we so need a better way to do this
	for _, v in pairs(materialNames) do
		local toAdd
		if v == "Grass" then
			toAdd = 56563112
		elseif v == "Sand" then
			toAdd = 62356652
		elseif v == "Brick" then
			toAdd = 65961537
		elseif v == "Granite" then
			toAdd = 67532153
		elseif v == "Asphalt" then
			toAdd = 67532038
		elseif v == "Iron" then
			toAdd = 67532093
		elseif v == "Aluminum" then
			toAdd = 67531995
		elseif v == "Gold" then
			toAdd = 67532118
		elseif v == "Plastic (red)" then
			toAdd = 67531848
		elseif v == "Plastic (blue)" then
			toAdd = 67531924
		elseif v == "Plank" then
			toAdd = 67532015
		elseif v == "Log" then
			toAdd = 67532051
		elseif v == "Gravel" then
			toAdd = 67532206
		elseif v == "Cinder Block" then
			toAdd = 67532103
		elseif v == "Stone Wall" then
			toAdd = 67531804
		elseif v == "Concrete" then
			toAdd = 67532059
		elseif v == "Water" then
			toAdd = 81407474
		else
			toAdd = 66887593 -- fill in the rest here!!
		end
		materialToImageMap[v] =
			{ Regular = `http://banland.xyz/asset/?id={toAdd}` }
	end

	local scrollFrame, scrollUp, scrollDown, recalculateScroll =
		RbxGui.CreateScrollingFrame(nil, "grid")
	scrollFrame.Size = UDim2.new(0.85, 0, 1, 0)
	scrollFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = frame

	scrollUp.Parent = frame
	scrollUp.Visible = true
	scrollUp.Position = UDim2.new(1, -19, 0, 0)

	scrollDown.Parent = frame
	scrollDown.Visible = true
	scrollDown.Position = UDim2.new(1, -19, 1, -17)

	local function goToNewMaterial(buttonWrap, materialName)
		updateMaterialChoice(materialName)
		buttonWrap.BackgroundTransparency = 0
		selectedButton.BackgroundTransparency = 1
		selectedButton = buttonWrap
	end

	local function createMaterialButton(name)
		local buttonWrap = New "TextButton" {
			Text = "",
			Size = UDim2.new(0, 32, 0, 32),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Name = tostring(name),
			New "NumberValue" {
				Name = "EnumType",
				Value = 0,
			},
		}

		local imageButton = New "ImageButton" {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(0, 1, 0, 1),
			Name = tostring(name),
			Parent = buttonWrap,
			Image = materialToImageMap[name].Regular,
		}

		imageButton.MouseEnter:connect(function()
			buttonWrap.BackgroundTransparency = 0
		end)
		imageButton.MouseLeave:connect(function()
			if selectedButton ~= buttonWrap then
				buttonWrap.BackgroundTransparency = 1
			end
		end)
		imageButton.MouseButton1Click:connect(function()
			if selectedButton ~= buttonWrap then
				goToNewMaterial(buttonWrap, tostring(name))
			end
		end)

		return buttonWrap
	end

	for i = 1, #materialNames do
		local imageButton = createMaterialButton(materialNames[i])

		if materialNames[i] == "Grass" then -- always start with grass as the default
			selectedButton = imageButton
			imageButton.BackgroundTransparency = 0
		end

		imageButton.Parent = scrollFrame
	end

	local forceTerrainMaterialSelection = function(newMaterialType)
		if not newMaterialType then
			return
		end
		if currentMaterial == newMaterialType then
			return
		end

		local matName = getNameFromEnum(newMaterialType)
		local buttons = scrollFrame:GetChildren()
		for i = 1, #buttons do
			if
				buttons[i].Name == "Plastic (blue)"
				and matName == "Plastic (blue)"
			then
				goToNewMaterial(buttons[i], matName)
				return
			end
			if
				buttons[i].Name == "Plastic (red)"
				and matName == "Plastic (red)"
			then
				goToNewMaterial(buttons[i], matName)
				return
			end
			if string.find(buttons[i].Name, matName) then
				goToNewMaterial(buttons[i], matName)
				return
			end
		end
	end

	frame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			recalculateScroll()
		end
	end)

	recalculateScroll()
	return frame, terrainMaterialSelectionChanged, forceTerrainMaterialSelection
end

RbxGui.CreateLoadingFrame = function(name, size, position)
	game:GetService("ContentProvider")
		:Preload "http://banland.xyz/asset/?id=35238053"

	local loadingFrame = New "Frame" {
		Name = "LoadingFrame",
		Style = Enum.FrameStyle.RobloxRound,
		New "TextLabel" {
			Name = "loadingName",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Position = UDim2.new(0, 0, 0, 2),
			Font = Enum.Font.Arial,
			Text = name,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 1,
			FontSize = Enum.FontSize.Size18,
		},
	}

	if size then
		loadingFrame.Size = size
	else
		loadingFrame.Size = UDim2.new(0, 300, 0, 160)
	end
	if position then
		loadingFrame.Position = position
	else
		loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
	end

	local loadingBar = New "Frame" {
		Name = "LoadingBar",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderColor3 = Color3.new(79 / 255, 79 / 255, 79 / 255),
		Position = UDim2.new(0, 0, 0, 41),
		Size = UDim2.new(1, 0, 0, 30),
		Parent = loadingFrame,
	}

	local loadingGreenBar = New "ImageLabel" {
		Name = "LoadingGreenBar",
		Image = "http://banland.xyz/asset/?id=35238053",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		Visible = false,
		Parent = loadingBar,
	}

	local loadingPercent = New "TextLabel" {
		Name = "LoadingPercent",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 14),
		Font = Enum.Font.Arial,
		Text = "0%",
		FontSize = Enum.FontSize.Size14,
		TextColor3 = Color3.new(1, 1, 1),
		Parent = loadingBar,
	}

	local cancelButton = New "TextButton" {
		Name = "CancelButton",
		Position = UDim2.new(0.5, -60, 1, -40),
		Size = UDim2.new(0, 120, 0, 40),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "Cancel",
		Style = Enum.ButtonStyle.RobloxButton,
		Parent = loadingFrame,
	}

	local cancelButtonClicked = New "BindableEvent" {
		Name = "CancelButtonClicked",
		Parent = cancelButton,
	}

	cancelButton.MouseButton1Click:connect(function()
		cancelButtonClicked:Fire()
	end)

	local function updateLoadingGuiPercent(
		percent: number, -- thats not a percent bruh
		tweenAction,
		tweenLength
	)
		if percent and type(percent) ~= "number" then
			error(
				`updateLoadingGuiPercent expects number as argument, got {type(
					percent
				)} instead`
			)
		end

		local newSize
		if percent < 0 then
			newSize = UDim2.new(0, 0, 1, 0)
		elseif percent > 1 then
			newSize = UDim2.new(1, 0, 1, 0)
		else
			newSize = UDim2.new(percent, 0, 1, 0)
		end

		if tweenAction then
			if not tweenLength then
				error "updateLoadingGuiPercent is set to tween new percentage, but got no tween time length! Please pass this in as third argument"
			end

			if newSize.X.Scale > 0 then
				loadingGreenBar.Visible = true
				loadingGreenBar:TweenSize(
					newSize,
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					tweenLength,
					true
				)
			else
				loadingGreenBar:TweenSize(
					newSize,
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					tweenLength,
					true,
					function()
						if newSize.X.Scale < 0 then
							loadingGreenBar.Visible = false
						end
					end
				)
			end
		else
			loadingGreenBar.Size = newSize
			loadingGreenBar.Visible = (newSize.X.Scale > 0)
		end
	end

	loadingGreenBar.Changed:connect(function(prop)
		if prop == "Size" then
			loadingPercent.Text =
				`{math.ceil(loadingGreenBar.Size.X.Scale * 100)}%`
		end
	end)

	return loadingFrame, updateLoadingGuiPercent, cancelButtonClicked
end

RbxGui.CreatePluginFrame = function(name, size, position, scrollable, parent)
	local function createMenuButton(
		size,
		position,
		text,
		fontsize,
		name,
		parent
	)
		local button = New "TextButton" {
			AutoButtonColor = false,
			Name = name,
			BackgroundTransparency = 1,
			Position = position,
			Size = size,
			Font = Enum.Font.ArialBold,
			FontSize = fontsize,
			Text = text,
			TextColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(20 / 255, 20 / 255, 20 / 255),
		}

		button.MouseEnter:connect(function()
			if button.Selected then
				return
			end
			button.BackgroundTransparency = 0
		end)
		button.MouseLeave:connect(function()
			if button.Selected then
				return
			end
			button.BackgroundTransparency = 1
		end)

		button.Parent = parent

		return button
	end

	local dragBar = New "ImageButton" {
		Name = `{name}DragBar`,
		BackgroundColor3 = Color3.new(39 / 255, 39 / 255, 39 / 255),
		BorderColor3 = Color3.new(0, 0, 0),
		Active = true,
		Draggable = true,
		-- plugin name label
		New "TextLabel" {
			Name = "BarNameLabel",
			Text = ` {name}`,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
		},
	}
	if size then
		dragBar.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 20)
			+ UDim2.new(0, 20, 0, 0)
	else
		dragBar.Size = UDim2.new(0, 183, 0, 20)
	end
	if position then
		dragBar.Position = position
	end
	--dragBar.Visible = false
	dragBar.MouseEnter:connect(function()
		dragBar.BackgroundColor3 = Color3.new(49 / 255, 49 / 255, 49 / 255)
	end)
	dragBar.MouseLeave:connect(function()
		dragBar.BackgroundColor3 = Color3.new(39 / 255, 39 / 255, 39 / 255)
	end)
	dragBar.Parent = parent

	-- close button
	local closeButton = createMenuButton(
		UDim2.new(0, 15, 0, 17),
		UDim2.new(1, -16, 0.5, -8),
		"X",
		Enum.FontSize.Size14,
		"CloseButton",
		dragBar
	)
	local closeEvent = New "BindableEvent" {
		Name = "CloseEvent",
		Parent = closeButton,
	}
	closeButton.MouseButton1Click:connect(function()
		closeEvent:Fire()
		closeButton.BackgroundTransparency = 1
	end)

	-- help button
	local helpButton = createMenuButton(
		UDim2.new(0, 15, 0, 17),
		UDim2.new(1, -51, 0.5, -8),
		"?",
		Enum.FontSize.Size14,
		"HelpButton",
		dragBar
	)

	local helpFrame = New "Frame" {
		Name = "HelpFrame",
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(0, 300, 0, 552),
		Position = UDim2.new(1, 5, 0, 0),
		Active = true,
		BorderSizePixel = 0,
		Visible = false,
		Parent = dragBar,
	}

	helpButton.MouseButton1Click:connect(function()
		helpFrame.Visible = not helpFrame.Visible
		if helpFrame.Visible then
			helpButton.Selected = true
			helpButton.BackgroundTransparency = 0
			local screenGui = getScreenGuiAncestor(helpFrame)
			if screenGui then
				if
					helpFrame.AbsolutePosition.X + helpFrame.AbsoluteSize.X
					> screenGui.AbsoluteSize.X
				then --position on left hand side
					helpFrame.Position =
						UDim2.new(0, -5 - helpFrame.AbsoluteSize.X, 0, 0)
				else -- position on right hand side
					helpFrame.Position = UDim2.new(1, 5, 0, 0)
				end
			else
				helpFrame.Position = UDim2.new(1, 5, 0, 0)
			end
		else
			helpButton.Selected = false
			helpButton.BackgroundTransparency = 1
		end
	end)

	local minimizeButton = createMenuButton(
		UDim2.new(0, 16, 0, 17),
		UDim2.new(1, -34, 0.5, -8),
		"-",
		Enum.FontSize.Size14,
		"MinimizeButton",
		dragBar
	)
	minimizeButton.TextYAlignment = Enum.TextYAlignment.Top

	local minimizeFrame = New "Frame" {
		Name = "MinimizeFrame",
		BackgroundColor3 = Color3.new(73 / 255, 73 / 255, 73 / 255),
		BorderColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(0, 0, 1, 0),
		Visible = false,
		Parent = dragBar,
	}
	if size then
		minimizeFrame.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 50)
			+ UDim2.new(0, 20, 0, 0)
	else
		minimizeFrame.Size = UDim2.new(0, 183, 0, 50)
	end
	minimizeFrame.Parent = dragBar

	local minimizeBigButton = New "TextButton" {
		Position = UDim2.new(0.5, -50, 0.5, -20),
		Size = UDim2.new(0, 100, 0, 40),
		Style = Enum.ButtonStyle.RobloxButton,
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size18,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "Show",
		Parent = minimizeFrame,
	}

	local separatingLine = New "Frame" {
		Name = "SeparatingLine",
		BackgroundColor3 = Color3.new(115 / 255, 115 / 255, 115 / 255),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -18, 0.5, -7),
		Size = UDim2.new(0, 1, 0, 14),
		Parent = dragBar,
	}
	-- otherSeparatingLine
	New(separatingLine:clone()) {
		Position = UDim2.new(1, -35, 0.5, -7),
		Parent = dragBar,
	}

	local widgetContainer = New "Frame" {
		Name = "WidgetContainer",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		BorderColor3 = Color3.new(0, 0, 0),
	}
	if not scrollable then
		widgetContainer.BackgroundTransparency = 0
		widgetContainer.BackgroundColor3 =
			Color3.new(72 / 255, 72 / 255, 72 / 255)
	end
	widgetContainer.Parent = dragBar

	if size then
		if scrollable then
			widgetContainer.Size = size
		else
			widgetContainer.Size = UDim2.new(
				0,
				dragBar.AbsoluteSize.X,
				size.Y.Scale,
				size.Y.Offset
			)
		end
	else
		if scrollable then
			widgetContainer.Size = UDim2.new(0, 163, 0, 400)
		else
			widgetContainer.Size = UDim2.new(0, dragBar.AbsoluteSize.X, 0, 400)
		end
	end
	if position then
		widgetContainer.Position = position + UDim2.new(0, 0, 0, 20)
	end

	local frame, control, verticalDragger
	if scrollable then
		--frame for widgets
		frame, control = RbxGui.CreateTrueScrollingFrame()
		New(frame) {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(72 / 255, 72 / 255, 72 / 255),
			BorderColor3 = Color3.new(0, 0, 0),
			Active = true,
			Parent = widgetContainer,
		}
		New(control) {
			BackgroundColor3 = Color3.new(72 / 255, 72 / 255, 72 / 255),
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			Position = UDim2.new(1, -21, 1, 1),
			New "Frame" {
				Name = "FakeLine",
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.new(0, 1, 1, 1),
				Position = UDim2.new(1, 0, 0, 0),
			},
		}
		if size then
			control.Size = UDim2.new(0, 21, size.Y.Scale, size.Y.Offset)
		else
			control.Size = UDim2.new(0, 21, 0, 400)
		end
		control:FindFirstChild("ScrollDownButton").Position =
			UDim2.new(0, 0, 1, -20)

		control.Parent = dragBar

		verticalDragger = New "TextButton" {
			ZIndex = 2,
			AutoButtonColor = false,
			Name = "VerticalDragger",
			BackgroundColor3 = Color3.new(50 / 255, 50 / 255, 50 / 255),
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 20, 0, 20),
			Position = UDim2.new(0, 0, 1, 0),
			Active = true,
			Text = "",
			Parent = widgetContainer,
		}

		local scrubFrame = New "Frame" {
			Name = "ScrubFrame",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, -5, 0.5, 0),
			Size = UDim2.new(0, 10, 0, 1),
			ZIndex = 5,
			Parent = verticalDragger,
		}
		-- scrubTwo
		New(scrubFrame:clone()) {
			Position = UDim2.new(0.5, -5, 0.5, -2),
			Parent = verticalDragger,
		}
		-- scrubThree
		New(scrubFrame:clone()) {
			Position = UDim2.new(0.5, -5, 0.5, 2),
			Parent = verticalDragger,
		}

		local areaSoak = New "TextButton" {
			Name = "AreaSoak",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			ZIndex = 10,
			Visible = false,
			Active = true,
			Parent = getScreenGuiAncestor(parent),
		}

		local draggingVertical = false
		local startYPos
		verticalDragger.MouseEnter:connect(function()
			verticalDragger.BackgroundColor3 =
				Color3.new(60 / 255, 60 / 255, 60 / 255)
		end)
		verticalDragger.MouseLeave:connect(function()
			verticalDragger.BackgroundColor3 =
				Color3.new(50 / 255, 50 / 255, 50 / 255)
		end)
		verticalDragger.MouseButton1Down:connect(function(_, y)
			draggingVertical = true
			areaSoak.Visible = true
			startYPos = y
		end)
		areaSoak.MouseButton1Up:connect(function()
			draggingVertical = false
			areaSoak.Visible = false
		end)
		areaSoak.MouseMoved:connect(function(_, y)
			if not draggingVertical then
				return
			end

			local yDelta = y - startYPos
			if not control.ScrollDownButton.Visible and yDelta > 0 then
				return
			end

			if (widgetContainer.Size.Y.Offset + yDelta) < 150 then
				widgetContainer.Size = UDim2.new(
					widgetContainer.Size.X.Scale,
					widgetContainer.Size.X.Offset,
					widgetContainer.Size.Y.Scale,
					150
				)
				control.Size = UDim2.new(0, 21, 0, 150)
				return
			end

			startYPos = y

			if widgetContainer.Size.Y.Offset + yDelta >= 0 then
				widgetContainer.Size = UDim2.new(
					widgetContainer.Size.X.Scale,
					widgetContainer.Size.X.Offset,
					widgetContainer.Size.Y.Scale,
					widgetContainer.Size.Y.Offset + yDelta
				)
				control.Size =
					UDim2.new(0, 21, 0, control.Size.Y.Offset + yDelta)
			end
		end)
	end

	local function switchMinimize()
		minimizeFrame.Visible = not minimizeFrame.Visible
		if scrollable then
			frame.Visible = not frame.Visible
			verticalDragger.Visible = not verticalDragger.Visible
			control.Visible = not control.Visible
		else
			widgetContainer.Visible = not widgetContainer.Visible
		end

		if minimizeFrame.Visible then
			minimizeButton.Text = "+"
		else
			minimizeButton.Text = "-"
		end
	end

	minimizeBigButton.MouseButton1Click:connect(function()
		switchMinimize()
	end)

	minimizeButton.MouseButton1Click:connect(function()
		switchMinimize()
	end)

	if scrollable then
		return dragBar, frame, helpFrame, closeEvent
	end
	return dragBar, widgetContainer, helpFrame, closeEvent
end

RbxGui.Help = function(funcNameOrFunc)
	--input argument can be a string or a function.  Should return a description (of arguments and expected side effects)
	if
		funcNameOrFunc == "CreatePropertyDropDownMenu"
		or funcNameOrFunc == RbxGui.CreatePropertyDropDownMenu
	then
		return "Function CreatePropertyDropDownMenu.  "
			.. "Arguments: (instance, propertyName, enumType).  "
			.. "Side effect: returns a container with a drop-down-box that is linked to the 'property' field of 'instance' which is of type 'enumType'"
	elseif
		funcNameOrFunc == "CreateDropDownMenu"
		or funcNameOrFunc == RbxGui.CreateDropDownMenu
	then
		return "Function CreateDropDownMenu.  "
			.. "Arguments: (items, onItemSelected).  "
			.. "Side effect: Returns 2 results, a container to the gui object and a 'updateSelection' function for external updating.  The container is a drop-down-box created around a list of items"
	elseif
		funcNameOrFunc == "CreateMessageDialog"
		or funcNameOrFunc == RbxGui.CreateMessageDialog
	then
		return "Function CreateMessageDialog.  "
			.. "Arguments: (title, message, buttons). "
			.. "Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in.  'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button"
	elseif
		funcNameOrFunc == "CreateStyledMessageDialog"
		or funcNameOrFunc == RbxGui.CreateStyledMessageDialog
	then
		return "Function CreateStyledMessageDialog.  "
			.. "Arguments: (title, message, style, buttons). "
			.. "Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in.  'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button, 'style' is a string, either Error, Notify or Confirm"
	elseif
		funcNameOrFunc == "GetFontHeight"
		or funcNameOrFunc == RbxGui.GetFontHeight
	then
		return "Function GetFontHeight.  "
			.. "Arguments: (font, fontSize). "
			.. "Side effect: returns the size in pixels of the given font + fontSize"
	elseif
		funcNameOrFunc == "CreateScrollingFrame"
		or funcNameOrFunc == RbxGui.CreateScrollingFrame
	then
		return "Function CreateScrollingFrame.  "
			.. "Arguments: (orderList, style) "
			.. "Side effect: returns 4 objects, (scrollFrame, scrollUpButton, scrollDownButton, recalculateFunction).  'scrollFrame' can be filled with GuiObjects.  It will lay them out and allow scrollUpButton/scrollDownButton to interact with them.  Orderlist is optional (and specifies the order to layout the children.  Without orderlist, it uses the children order. style is also optional, and allows for a 'grid' styling if style is passed 'grid' as a string.  recalculateFunction can be called when a relayout is needed (when orderList changes)"
	elseif
		funcNameOrFunc == "CreateTrueScrollingFrame"
		or funcNameOrFunc == RbxGui.CreateTrueScrollingFrame
	then
		return "Function CreateTrueScrollingFrame.  "
			.. "Arguments: (nil) "
			.. "Side effect: returns 2 objects, (scrollFrame, controlFrame).  'scrollFrame' can be filled with GuiObjects, and they will be clipped if not inside the frame's bounds. controlFrame has children scrollup and scrolldown, as well as a slider.  controlFrame can be parented to any guiobject and it will readjust itself to fit."
	elseif
		funcNameOrFunc == "AutoTruncateTextObject"
		or funcNameOrFunc == RbxGui.AutoTruncateTextObject
	then
		return "Function AutoTruncateTextObject.  "
			.. "Arguments: (textLabel) "
			.. "Side effect: returns 2 objects, (textLabel, changeText).  The 'textLabel' input is modified to automatically truncate text (with ellipsis), if it gets too small to fit.  'changeText' is a function that can be used to change the text, it takes 1 string as an argument"
	elseif
		funcNameOrFunc == "CreateSlider"
		or funcNameOrFunc == RbxGui.CreateSlider
	then
		return "Function CreateSlider.  "
			.. "Arguments: (steps, width, position) "
			.. "Side effect: returns 2 objects, (sliderGui, sliderPosition).  The 'steps' argument specifies how many different positions the slider can hold along the bar.  'width' specifies in pixels how wide the bar should be (modifiable afterwards if desired). 'position' argument should be a UDim2 for slider positioning. 'sliderPosition' is an IntValue whose current .Value specifies the specific step the slider is currently on."
	elseif
		funcNameOrFunc == "CreateLoadingFrame"
		or funcNameOrFunc == RbxGui.CreateLoadingFrame
	then
		return "Function CreateLoadingFrame.  "
			.. "Arguments: (name, size, position) "
			.. "Side effect: Creates a gui that can be manipulated to show progress for a particular action.  Name appears above the loading bar, and size and position are udim2 values (both size and position are optional arguments).  Returns 3 arguments, the first being the gui created. The second being updateLoadingGuiPercent, which is a bindable function.  This function takes one argument (two optionally), which should be a number between 0 and 1, representing the percentage the loading gui should be at.  The second argument to this function is a boolean value that if set to true will tween the current percentage value to the new percentage value, therefore our third argument is how long this tween should take. Our third returned argument is a BindableEvent, that when fired means that someone clicked the cancel button on the dialog."
	elseif
		funcNameOrFunc == "CreateTerrainMaterialSelector"
		or funcNameOrFunc == RbxGui.CreateTerrainMaterialSelector
	then
		return "Function CreateTerrainMaterialSelector.  "
			.. "Arguments: (size, position) "
			.. "Side effect: Size and position are UDim2 values that specifies the selector's size and position.  Both size and position are optional arguments. This method returns 3 objects (terrainSelectorGui, terrainSelected, forceTerrainSelection).  terrainSelectorGui is just the gui object that we generate with this function, parent it as you like. TerrainSelected is a BindableEvent that is fired whenever a new terrain type is selected in the gui.  ForceTerrainSelection is a function that takes an argument of Enum.CellMaterial and will force the gui to show that material as currently selected."
	end
	return "No help available for this function"
end

return RbxGui
