local t = { }
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
local ScopedConnect
ScopedConnect = function(parentInstance, instance, event, signalFunc, syncFunc, removeFunc)
	local eventConnection
	local tryConnect
	tryConnect = function()
		if game:IsAncestorOf(parentInstance) then
			if not eventConnection then
				eventConnection = instance[event]:connect(signalFunc)
				if syncFunc then
					syncFunc()
				end
			end
			if eventConnection then
				eventConnection:disconnect()
				if removeFunc then
					return removeFunc()
				end
			end
		end
	end
	local connection = parentInstance.AncestryChanged:connect(tryConnect)
	tryConnect()
	return connection
end
local getScreenGuiAncestor
getScreenGuiAncestor = function(instance)
	local localInstance = instance
	while localInstance and not localInstance:IsA("ScreenGui") do
		localInstance = localInstance.Parent
	end
	return localInstance
end
local CreateButtons
CreateButtons = function(frame, buttons, yPos, ySize)
	local buttonNum = 1
	local buttonObjs = { }
	for _, obj in ipairs(buttons) do
		local button = New("TextButton", "Button" .. tostring(buttonNum), {
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			AutoButtonColor = true,
			Modal = true,
			Style = (function()
				if obj["Style"] then
					return obj.Style
				else
					return Enum.ButtonStyle.RobloxButton
				end
			end)(),
			Text = obj.Text,
			TextColor3 = Color3.new(1, 1, 1),
			Parent = frame
		})
		button.MouseButton1Click:connect(obj.Function)
		buttonObjs[buttonNum] = button
		buttonNum = buttonNum + 1
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
			buttonObjs[buttonNum].Position = UDim2.new(spacing * buttonNum + buttonSize * (buttonNum - 1), 0, yPos.Scale, yPos.Offset)
			buttonObjs[buttonNum].Size = UDim2.new(buttonSize, 0, ySize.Scale, ySize.Offset)
			buttonNum = buttonNum + 1
		end
	end
end
local setSliderPos
setSliderPos = function(newAbsPosX, slider, sliderPosition, bar, steps)
	local newStep = steps - 1
	local relativePosX = math.min(1, math.max(0, (newAbsPosX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X))
	local wholeNum, remainder = math.modf(relativePosX * newStep)
	if remainder > 0.5 then
		wholeNum = wholeNum + 1
	end
	relativePosX = wholeNum / newStep
	local result = math.ceil(relativePosX * newStep)
	if sliderPosition.Value ~= result + 1 then
		sliderPosition.Value = result + 1
		slider.Position = UDim2.new(relativePosX, -slider.AbsoluteSize.X / 2, slider.Position.Y.Scale, slider.Position.Y.Offset)
	end
end
local cancelSlide
cancelSlide = function(areaSoak)
	areaSoak.Visible = false
	if areaSoakMouseMoveCon then
		return areaSoakMouseMoveCon:disconnect()
	end
end
t.CreateStyledMessageDialog = function(title, message, style, buttons)
	local frame = New("Frame", "MessageDialog", {
		Size = UDim2.new(0.5, 0, 0, 165),
		Position = UDim2.new(0.25, 0, 0.5, -72.5),
		Active = true,
		Style = Enum.FrameStyle.RobloxRound,
		New("ImageLabel", "StyleImage", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 15)
		}),
		New("TextLabel", "Title", {
			Text = title,
			TextStrokeTransparency = 0,
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(221 / 255, 221 / 255, 221 / 255),
			Position = UDim2.new(0, 80, 0, 0),
			Size = UDim2.new(1, -80, 0, 40),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		New("TextLabel", "Message", {
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
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
	local StyleImage = frame.StyleImage
	if style == "error" or style == "Error" then
		StyleImage.Size = UDim2.new(0, 71, 0, 71)
		StyleImage.Image = "http://www.roblox.com/asset?id=42565285"
	elseif style == "notify" or style == "Notify" then
		StyleImage.Size = UDim2.new(0, 71, 0, 71)
		StyleImage.Image = "http://www.roblox.com/asset?id=42604978"
	elseif style == "confirm" or style == "Confirm" then
		StyleImage.Size = UDim2.new(0, 74, 0, 76)
		StyleImage.Image = "http://www.roblox.com/asset?id=42557901"
	else
		return t.CreateMessageDialog(title, message, buttons)
	end
	CreateButtons(frame, buttons, UDim.new(0, 105), UDim.new(0, 40))
	return frame
end
t.CreateMessageDialog = function(title, message, buttons)
	local frame = New("Frame", "MessageDialog", {
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.25, 0, 0.25, 0),
		Active = true,
		Style = Enum.FrameStyle.RobloxRound,
		Parent = script.Parent,
		New("TextLabel", "Title", {
			Text = title,
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(221 / 255, 221 / 255, 221 / 255),
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0.15, 0),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		New("TextLabel", "Message", {
			Text = message,
			TextColor3 = Color3.new(221 / 255, 221 / 255, 221 / 255),
			Position = UDim2.new(0.025, 0, 0.175, 0),
			Size = UDim2.new(0.95, 0, 0.55, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextWrap = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
	CreateButtons(frame, buttons, UDim.new(0.8, 0), UDim.new(0.15, 0))
	return frame
end
t.CreateDropDownMenu = function(items, onSelect, forRoblox)
	local width = UDim.new(0, 100)
	local height = UDim.new(0, 32)
	local frame = New("Frame", "DropDownMenu", {
		BackgroundTransparency = 1,
		Size = UDim2.new(width, height),
		New("TextButton", "DropDownMenuButton", {
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
			ZIndex = 2,
			New("ImageLabel", "Icon", {
				Active = false,
				Image = "http://www.roblox.com/asset/?id=45732894",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 11, 0, 6),
				Position = UDim2.new(1, -11, 0.5, -2),
				ZIndex = 2
			})
		})
	})
	local dropDownMenu = frame.DropDownMenuButton
	local itemCount = #items
	local dropDownItemCount = #items
	local useScrollButtons = false
	if dropDownItemCount > 6 then
		useScrollButtons = true
		dropDownItemCount = 6
	end
	local droppedDownMenu = New("TextButton", "List", {
		Text = "",
		BackgroundTransparency = 1,
		Style = Enum.ButtonStyle.RobloxButton,
		Visible = false,
		Active = true,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, (1 + dropDownItemCount) * 0.8, 0),
		Parent = frame,
		ZIndex = 2
	})
	local choiceButton = New("TextButton", "ChoiceButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "ReplaceMe",
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Size = (function()
			if useScrollButtons then
				return UDim2.new(1, -13, 0.8 / ((dropDownItemCount + 1) * 0.8), 0)
			else
				return UDim2.new(1, 0, 0.8 / ((dropDownItemCount + 1) * 0.8), 0)
			end
		end)(),
		TextWrap = true,
		ZIndex = 2
	})
	local areaSoak = New("TextButton", "AreaSoak", {
		Text = "",
		BackgroundTransparency = 1,
		Active = true,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		ZIndex = 3
	})
	local dropDownSelected = false
	local scrollUpButton
	local scrollDownButton
	local scrollMouseCount = 0
	local setZIndex
	setZIndex = function(baseZIndex)
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
	local updateScroll
	updateScroll = function()
		if scrollUpButton then
			scrollUpButton.Active = scrollBarPosition > 1
		end
		if scrollDownButton then
			scrollDownButton.Active = scrollBarPosition + dropDownItemCount <= itemCount
		end
		local children = droppedDownMenu:GetChildren()
		if not children then
			return
		end
		local childNum = 1
		for _, obj in ipairs(children) do
			if obj.Name == "ChoiceButton" then
				if childNum < scrollBarPosition or childNum >= scrollBarPosition + dropDownItemCount then
					obj.Visible = false
				else
					obj.Position = UDim2.new(0, 0, ((childNum - scrollBarPosition + 1) * 0.8) / ((dropDownItemCount + 1) * 0.8), 0)
					obj.Visible = true
				end
				obj.TextColor3 = Color3.new(1, 1, 1)
				obj.BackgroundTransparency = 1
				childNum = childNum + 1
			end
		end
	end
	local toggleVisibility
	toggleVisibility = function()
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
			return updateScroll()
		end
	end
	droppedDownMenu.MouseButton1Click:connect(toggleVisibility)
	local updateSelection
	updateSelection = function(text)
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
					childNum = childNum + 1
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
	local scrollDown
	scrollDown = function()
		if scrollBarPosition + dropDownItemCount <= itemCount then
			scrollBarPosition = scrollBarPosition + 1
			updateScroll()
			return true
		end
		return false
	end
	local scrollUp
	scrollUp = function()
		if scrollBarPosition > 1 then
			scrollBarPosition = scrollBarPosition - 1
			updateScroll()
			return true
		end
		return false
	end
	if useScrollButtons then
		scrollUpButton = New("ImageButton", "ScrollUpButton", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/scrollbuttonUp.png",
			Size = UDim2.new(0, 17, 0, 17),
			Position = UDim2.new(1, -11, (1 * 0.8) / ((dropDownItemCount + 1) * 0.8), 0),
			Parent = droppedDownMenu
		})
		local incScrollMouseCount
		incScrollMouseCount = function()
			scrollMouseCount = scrollMouseCount + 1
		end
		scrollUpButton.MouseButton1Click:connect(incScrollMouseCount)
		scrollUpButton.MouseLeave:connect(incScrollMouseCount)
		scrollUpButton.MouseButton1Down:connect(function()
			scrollMouseCount = scrollMouseCount + 1
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
		scrollDownButton = New("ImageButton", "ScrollDownButton", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/scrollbuttonDown.png",
			Size = UDim2.new(0, 17, 0, 17),
			Position = UDim2.new(1, -11, 1, -11),
			Parent = droppedDownMenu
		})
		scrollDownButton.MouseButton1Click:connect(incScrollMouseCount)
		scrollDownButton.MouseLeave:connect(incScrollMouseCount)
		scrollDownButton.MouseButton1Down:connect(function()
			scrollMouseCount = scrollMouseCount + 1
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
		New("ImageLabel", "ScrollBar", {
			Image = "rbxasset://textures/ui/scrollbar.png",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 18, (dropDownItemCount * 0.8) / ((dropDownItemCount + 1) * 0.8), -17 - 11 - 4),
			Position = UDim2.new(1, -11, (1 * 0.8) / ((dropDownItemCount + 1) * 0.8), 17 + 2),
			Parent = droppedDownMenu
		})
	end
	for _, item in ipairs(items) do
		local button = choiceButton:clone()
		if forRoblox then
			button.RobloxLocked = true
		end
		button.Text = item
		button.Parent = droppedDownMenu
		button.MouseButton1Click:connect(function()
			button.TextColor3 = Color3.new(1, 1, 1)
			button.BackgroundTransparency = 1
			updateSelection(item)
			onSelect(item)
			return toggleVisibility()
		end)
		button.MouseEnter:connect(function()
			button.TextColor3 = Color3.new(0, 0, 0)
			button.BackgroundTransparency = 0
		end)
		button.MouseLeave:connect(function()
			button.TextColor3 = Color3.new(1, 1, 1)
			button.BackgroundTransparency = 1
		end)
	end
	updateScroll()
	frame.AncestryChanged:connect(function(_, parent)
		if not (parent ~= nil) then
			areaSoak.Parent = nil
		else
			areaSoak.Parent = getScreenGuiAncestor(frame)
		end
	end)
	dropDownMenu.MouseButton1Click:connect(toggleVisibility)
	areaSoak.MouseButton1Click:connect(toggleVisibility)
	return frame, updateSelection
end
t.CreatePropertyDropDownMenu = function(instance, property, enum)
	local items = enum:GetEnumItems()
	local names = { }
	local nameToItem = { }
	for i, obj in ipairs(items) do
		names[i] = obj.Name
		nameToItem[obj.Name] = obj
	end
	local frame, updateSelection
	frame, updateSelection = t.CreateDropDownMenu(names, function(text)
		instance[property] = nameToItem[text]
	end)
	local t1
	t1 = function(prop)
		if prop == property then
			return updateSelection(instance[property].Name)
		end
	end
	local t2
	t2 = function()
		return updateSelection(instance[property].Name)
	end
	ScopedConnect(frame, instance, "Changed", t1, t2)
	return frame
end
t.GetFontHeight = function(font, fontSize)
	if not ((font ~= nil) and (fontSize ~= nil)) then
		error("Font and FontSize must be non-nil")
	end
	if font == Enum.Font.Legacy then
		if Enum.FontSize.Size8 == fontSize then
			return 12
		elseif Enum.FontSize.Size9 == fontSize then
			return 14
		elseif Enum.FontSize.Size10 == fontSize then
			return 15
		elseif Enum.FontSize.Size11 == fontSize then
			return 17
		elseif Enum.FontSize.Size12 == fontSize then
			return 18
		elseif Enum.FontSize.Size14 == fontSize then
			return 21
		elseif Enum.FontSize.Size18 == fontSize then
			return 27
		elseif Enum.FontSize.Size24 == fontSize then
			return 36
		elseif Enum.FontSize.Size36 == fontSize then
			return 54
		elseif Enum.FontSize.Size48 == fontSize then
			return 72
		else
			return error("Unknown FontSize")
		end
	elseif font == Enum.Font.Arial or font == Enum.Font.ArialBold then
		if Enum.FontSize.Size8 == fontSize then
			return 8
		elseif Enum.FontSize.Size9 == fontSize then
			return 9
		elseif Enum.FontSize.Size10 == fontSize then
			return 10
		elseif Enum.FontSize.Size11 == fontSize then
			return 11
		elseif Enum.FontSize.Size12 == fontSize then
			return 12
		elseif Enum.FontSize.Size14 == fontSize then
			return 14
		elseif Enum.FontSize.Size18 == fontSize then
			return 18
		elseif Enum.FontSize.Size24 == fontSize then
			return 24
		elseif Enum.FontSize.Size36 == fontSize then
			return 36
		elseif Enum.FontSize.Size48 == fontSize then
			return 48
		else
			return error("Unknown FontSize")
		end
	else
		return error("Unknown Font " .. tostring(font))
	end
end
local layoutGuiObjectsHelper
layoutGuiObjectsHelper = function(frame, guiObjects, settingsTable)
	local totalPixels = frame.AbsoluteSize.Y
	local pixelsRemaining = frame.AbsoluteSize.Y
	for _, child in ipairs(guiObjects) do
		if child:IsA("TextLabel" or child:IsA("TextButton")) then
			local isLabel = child:IsA("TextLabel")
			local settingsTableIndex = "Text" .. tostring((function()
				if isLabel then
					return "Label"
				else
					return "Button"
				end
			end)()) .. "PositionPadY"
			pixelsRemaining = pixelsRemaining - settingsTable[settingsTableIndex]
			child.Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, totalPixels - pixelsRemaining)
			child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, pixelsRemaining)
			if child.TextFits and child.TextBounds.Y < pixelsRemaining then
				child.Visible = true
				child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, child.TextBounds.Y + settingsTable[settingsTableIndex])
				while not child.TextFits do
					child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, child.AbsoluteSize.Y + 1)
				end
				pixelsRemaining = pixelsRemaining - child.AbsoluteSize.Y
				pixelsRemaining = pixelsRemaining - settingsTable[settingsTableIndex]
			else
				child.Visible = false
				pixelsRemaining = -1
			end
		else
			child.Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, totalPixels - pixelsRemaining)
			pixelsRemaining = pixelsRemaining - child.AbsoluteSize.Y
			child.Visible = pixelsRemaining >= 0
		end
	end
end
t.LayoutGuiObjects = function(frame, guiObjects, settingsTable)
	if not frame:IsA("GuiObject") then
		error("Frame must be a GuiObject")
	end
	for _, child in ipairs(guiObjects) do
		if not child:IsA("GuiObject") then
			error("All elements that are layed out must be of type GuiObject")
		end
	end
	if not settingsTable then
		settingsTable = { }
	end
	if not settingsTable["TextLabelSizePadY"] then
		settingsTable["TextLabelSizePadY"] = 0
	end
	if not settingsTable["TextLabelPositionPadY"] then
		settingsTable["TextLabelPositionPadY"] = 0
	end
	if not settingsTable["TextButtonSizePadY"] then
		settingsTable["TextButtonSizePadY"] = 12
	end
	if not settingsTable["TextButtonPositionPadY"] then
		settingsTable["TextButtonPositionPadY"] = 2
	end
	local wrapperFrame = New("Frame", "WrapperFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = frame
	})
	for _, child in ipairs(guiObjects) do
		child.Parent = wrapperFrame
	end
	local recalculate
	recalculate = function()
		wait()
		return layoutGuiObjectsHelper(wrapperFrame, guiObjects, settingsTable)
	end
	frame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			return recalculate(nil)
		end
	end)
	frame.AncestryChanged:connect(recalculate)
	return layoutGuiObjectsHelper(wrapperFrame, guiObjects, settingsTable)
end
t.CreateSlider = function(steps, width, position)
	local sliderGui = New("Frame", "SliderGui", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		New("IntValue", "SliderSteps", {
			Value = steps
		}),
		New("IntValue", "SliderPosition", {
			Value = 0
		}),
		New("TextButton", "Bar", {
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(0, (function()
				if type(width) == "number" then
					return width
				else
					return 200
				end
			end)(), 0, 5),
			BorderColor3 = Color3.new(95 / 255, 95 / 255, 95 / 255),
			ZIndex = 2,
			New("ImageButton", "Slider", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/Slider.png",
				Position = UDim2.new(0, 0, 0.5, -10),
				Size = UDim2.new(0, 20, 0, 20),
				ZIndex = 3
			})
		})
	})
	local areaSoak = New("TextButton", "AreaSoak", {
		Text = "",
		BackgroundTransparency = 1,
		Active = false,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		ZIndex = 4
	})
	local sliderPosition, sliderSteps, slider, bar = sliderGui.SliderPosition, sliderGui.SliderSteps, sliderGui.Bar.Slider, sliderGui.Bar
	sliderGui.AncestryChanged:connect(function(_, parent)
		if not (parent ~= nil) then
			areaSoak.Parent = nil
		else
			areaSoak.Parent = getScreenGuiAncestor(sliderGui)
		end
	end)
	if position["X"] and position["X"]["Scale"] and position["X"]["Offset"] and position["Y"] and position["Y"]["Scale"] and position["Y"]["Offset"] then
		bar.Position = position
	end
	local areaSoakMouseMoveCon
	areaSoak.MouseLeave:connect(function()
		if areaSoak.Visible then
			return cancelSlide(areaSoak)
		end
	end)
	areaSoak.MouseButton1Up:connect(function()
		if areaSoak.Visible then
			return cancelSlide(areaSoak)
		end
	end)
	slider.MouseButton1Down:connect(function()
		areaSoak.Visible = true
		if areaSoakMouseMoveCon then
			areaSoakMouseMoveCon:disconnect()
		end
		areaSoakMouseMoveCon = areaSoak.MouseMoved:connect(function(x, _)
			return setSliderPos(x, slider, sliderPosition, bar, steps)
		end)
	end)
	slider.MouseButton1Up:connect(function()
		return cancelSlide(areaSoak)
	end)
	sliderPosition.Changed:connect(function(_)
		sliderPosition.Value = math.min(steps, math.max(1, sliderPosition.Value))
		local relativePosX = (sliderPosition.Value - 1) / (steps - 1)
		slider.Position = UDim2.new(relativePosX, -slider.AbsoluteSize.X / 2, slider.Position.Y.Scale, slider.Position.Y.Offset)
	end)
	bar.MouseButton1Down:connect(function(x, _)
		return setSliderPos(x, slider, sliderPosition, bar, steps)
	end)
	return sliderGui, sliderPosition, sliderSteps
end
t.CreateTrueScrollingFrame = function()
	local lowY, highY
	local dragCon, upCon
	local internalChange = false
	local descendantsChangeConMap = { }
	local scrollingFrame = New("Frame", "ScrollingFrame", {
		Active = true,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDescendants = true,
		New("Frame", "ControlFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 18, 1, 0),
			Position = UDim2.new(1, -20, 0, 0),
			New("BoolValue", "ScrollBottom", {
				Value = false
			}),
			New("BoolValue", "scrollUp", {
				Value = false
			}),
			New("TextButton", "ScrollUpButton", {
				Text = "",
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.5,
				Size = UDim2.new(0, 18, 0, 18),
				ZIndex = 2
			}),
			New("Frame", "ScrollTrack", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 18, 1, -38),
				Position = UDim2.new(0, 0, 0, 19),
				New("TextButton", "ScrollBar", {
					BackgroundColor3 = Color3.new(0, 0, 0),
					BorderColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 0.5,
					AutoButtonColor = false,
					Text = "",
					Active = true,
					ZIndex = 2,
					Size = UDim2.new(0, 18, 0.1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					New("Frame", "ScrollNub", {
						BorderColor3 = Color3.new(1, 1, 1),
						Size = UDim2.new(0, 10, 0, 0),
						Position = UDim2.new(0.5, -5, 0.5, 0),
						ZIndex = 2,
						BackgroundTransparency = 0.5
					})
				})
			})
		})
	})
	local controlFrame, scrollBottom, scrollUp, scrollUpButton, scrollTrack, scrollbar, scrollNub = scrollingFrame.ControlFrame, scrollingFrame.ControlFrame.ScrollBottom, scrollingFrame.ControlFrame.ScrollUp, scrollingFrame.ControlFrame.ScrollUpButton, scrollingFrame.ControlFrame.ScrollTrack, scrollingFrame.ControlFrame.ScrollTrack.ScrollBar, scrollingFrame.ControlFrame.ScrollTrack.ScrollBar.ScrollNub
	for i = 1, 6 do
		New("Frame", "tri" .. tostring(i), {
			BorderColor3 = Color3.new(1, 1, 1),
			ZIndex = 3,
			BackgroundTransparency = 0.5,
			Size = UDim2.new(0, 12 - ((i - 1) * 2), 0, 0),
			Position = UDim2.new(0, 3 + (i - 1), 0.5, 2 - (i - 1)),
			Parent = scrollUpButton
		})
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
	local mouseDrag = New("ImageButton", {
		Active = false,
		Size = UDim2.new(1.5, 0, 1.5, 0),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Name = "mouseDrag",
		Position = UDim2.new(-0.25, 0, -0.25, 0),
		ZIndex = 10
	})
	local positionScrollBar
	positionScrollBar = function(_, y, offset)
		local oldPos = scrollbar.Position
		if y < scrollTrack.AbsolutePosition.y then
			scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale, scrollbar.Position.X.Offset, 0, 0)
			return (oldPos ~= scrollbar.Position)
		end
		local relativeSize = scrollbar.AbsoluteSize.Y / scrollTrack.AbsoluteSize.Y
		if y > (scrollTrack.AbsolutePosition.y + scrollTrack.AbsoluteSize.y) then
			scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale, scrollbar.Position.X.Offset, 1 - relativeSize, 0)
			return (oldPos ~= scrollbar.Position)
		end
		local newScaleYPos = (y - scrollTrack.AbsolutePosition.y - offset) / scrollTrack.AbsoluteSize.y
		if newScaleYPos + relativeSize > 1 then
			newScaleYPos = 1 - relativeSize
			scrollBottom.Value = true
			scrollUp.Value = false
		elseif newScaleYPos <= 0 then
			newScaleYPos = 0
			scrollUp.Value = true
			scrollBottom.Value = false
		else
			scrollUp.Value = false
			scrollBottom.Value = false
		end
		scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale, scrollbar.Position.X.Offset, newScaleYPos, 0)
		return (oldPos ~= scrollbar.Position)
	end
	local drillDownSetHighLow
	drillDownSetHighLow = function(instance)
		if not instance or not instance:IsA("GuiObject") then
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
		if (highY and highY < (instance.AbsolutePosition.Y + instance.AbsoluteSize.Y)) or not highY then
			highY = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
		end
		local children = instance:GetChildren()
		for i = 1, #children do
			drillDownSetHighLow(children[i])
		end
	end
	local resetHighLow
	resetHighLow = function()
		local firstChildren = scrollingFrame:GetChildren()
		for i = 1, #firstChildren do
			drillDownSetHighLow(firstChildren[i])
		end
	end
	local recalculate
	recalculate = function()
		internalChange = true
		local percentFrame = 0
		if scrollbar.Position.Y.Scale > 0 then
			if scrollbar.Visible then
				percentFrame = scrollbar.Position.Y.Scale / ((scrollTrack.AbsoluteSize.Y - scrollbar.AbsoluteSize.Y) / scrollTrack.AbsoluteSize.Y)
			else
				percentFrame = 0
			end
		end
		if percentFrame > 0.99 then
			percentFrame = 1
		end
		local hiddenYAmount = (scrollingFrame.AbsoluteSize.Y - (highY - lowY)) * percentFrame
		local guiChildren = scrollingFrame:GetChildren()
		for i = 1, #guiChildren do
			if guiChildren[i] ~= controlFrame then
				guiChildren[i].Position = UDim2.new(guiChildren[i].Position.X.Scale, guiChildren[i].Position.X.Offset, 0, math.ceil(guiChildren[i].AbsolutePosition.Y) - math.ceil(lowY) + hiddenYAmount)
			end
		end
		lowY = nil
		highY = nil
		resetHighLow()
		internalChange = false
	end
	local setSliderSizeAndPosition
	setSliderSizeAndPosition = function()
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
			scrollbar.Size = UDim2.new(scrollbar.Size.X.Scale, scrollbar.Size.X.Offset, percentShown, 0)
		end
		local percentPosition = (scrollingFrame.AbsolutePosition.Y - lowY) / totalYSpan
		scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale, scrollbar.Position.X.Offset, percentPosition, -scrollbar.AbsoluteSize.X / 2)
		if scrollbar.AbsolutePosition.y < scrollTrack.AbsolutePosition.y then
			scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale, scrollbar.Position.X.Offset, 0, 0)
		end
		if (scrollbar.AbsolutePosition.y + scrollbar.AbsoluteSize.Y) > (scrollTrack.AbsolutePosition.y + scrollTrack.AbsoluteSize.y) then
			local relativeSize = scrollbar.AbsoluteSize.Y / scrollTrack.AbsoluteSize.Y
			scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale, scrollbar.Position.X.Offset, 1 - relativeSize, 0)
		end
	end
	local buttonScrollAmountPixels = 7
	local reentrancyGuardScrollUp = false
	local doScrollUp
	doScrollUp = function()
		if reentrancyGuardScrollUp then
			return
		end
		reentrancyGuardScrollUp = true
		if positionScrollBar(0, scrollbar.AbsolutePosition.Y - buttonScrollAmountPixels, 0) then
			recalculate()
		end
		reentrancyGuardScrollUp = false
	end
	local reentrancyGuardScrollDown = false
	local doScrollDown
	doScrollDown = function()
		if reentrancyGuardScrollDown then
			return
		end
		reentrancyGuardScrollDown = true
		if positionScrollBar(0, scrollbar.AbsolutePosition.Y + buttonScrollAmountPixels, 0) then
			recalculate()
		end
		reentrancyGuardScrollDown = false
	end
	scrollUp = function(mouseYPos)
		if scrollUpButton.Active then
			local scrollStamp = tick()
			local current = scrollStamp
			local upCon
			upCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				return upCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollUp()
			wait(0.2)
			t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollUp()
				if mouseYPos and mouseYPos > scrollbar.AbsolutePosition.y then
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
	local scrollDown
	scrollDown = function(mouseYPos)
		if scrollDownButton.Active then
			local scrollStamp = tick()
			local current = scrollStamp
			local downCon
			downCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				return downCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollDown()
			wait(0.2)
			t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollDown()
				if mouseYPos and mouseYPos < (scrollbar.AbsolutePosition.y + scrollbar.AbsoluteSize.x) then
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
	scrollbar.MouseButton1Down:connect(function(x, y)
		if scrollbar.Active then
			local scrollStamp = tick()
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
			dragCon = mouseDrag.MouseMoved:connect(function(x, y)
				if reentrancyGuardMouseScroll then
					return
				end
				reentrancyGuardMouseScroll = true
				if positionScrollBar(x, y, mouseOffset) then
					recalculate()
				end
				reentrancyGuardMouseScroll = false
			end)
			upCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				dragCon:disconnect()
				dragCon = nil
				upCon:disconnect()
				local drag = nil
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
		end
	end)
	local scrollMouseCount = 0
	scrollUpButton.MouseButton1Down:connect(function()
		return scrollUp()
	end)
	scrollDownButton.MouseButton1Down:connect(function()
		return scrollDown()
	end)
	local scrollTick
	scrollTick = function()
		scrollStamp = tick()
	end
	scrollUpButton.MouseButton1Up:connect(scrollTick)
	scrollDownButton.MouseButton1Up:connect(scrollTick)
	scrollbar.MouseButton1Up:connect(scrollTick)
	local highLowRecheck
	highLowRecheck = function()
		local oldLowY = lowY
		local oldHighY = highY
		lowY = nil
		highY = nil
		resetHighLow()
		if (lowY ~= oldLowY) or (highY ~= oldHighY) then
			return setSliderSizeAndPosition()
		end
	end
	local descendantChanged
	descendantChanged = function(this, prop)
		if internalChange then
			return
		end
		if not this.Visible then
			return
		end
		if prop == "Size" or prop == "Position" then
			wait()
			return highLowRecheck()
		end
	end
	scrollingFrame.DescendantAdded:connect(function(instance)
		if not instance:IsA("GuiObject") then
			return
		end
		if instance.Visible then
			wait()
			highLowRecheck()
		end
		descendantsChangeConMap[instance] = instance.Changed:connect(function(prop)
			return descendantChanged(instance, prop)
		end)
	end)
	scrollingFrame.DescendantRemoving:connect(function(instance)
		if not instance:IsA("GuiObject") then
			return
		end
		if descendantsChangeConMap[instance] then
			descendantsChangeConMap[instance]:disconnect()
			descendantsChangeConMap[instance] = nil
		end
		wait()
		return highLowRecheck()
	end)
	scrollingFrame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			if not highY or not lowY then
				return
			end
			highLowRecheck()
			return setSliderSizeAndPosition()
		end
	end)
	return scrollingFrame, controlFrame
end
