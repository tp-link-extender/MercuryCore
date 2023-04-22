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
				if syncFunc ~= nil then
					syncFunc()
				end
			end
			if eventConnection then
				eventConnection:disconnect()
				if removeFunc ~= nil then
					return removeFunc()
				end
				return nil
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
	local _obj_0 = areaSoakMouseMoveCon
	if _obj_0 ~= nil then
		return _obj_0:disconnect()
	end
	return nil
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
	local itemCount = #items
	local dropDownItemCount = itemCount
	local useScrollButtons = false
	if dropDownItemCount > 6 then
		useScrollButtons = true
		dropDownItemCount = 6
	end
	local frame = New("Frame", "DropDownMenu", {
		BackgroundTransparency = 1,
		Size = UDim2.new(width, height),
		New("TextButton", "List", {
			Text = "",
			BackgroundTransparency = 1,
			Style = Enum.ButtonStyle.RobloxButton,
			Visible = false,
			Active = true,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, (1 + dropDownItemCount) * 0.8, 0),
			ZIndex = 2
		}),
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
	local dropDownMenu, droppedDownMenu = frame.DropDownMenuButton, frame.List
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
		Size = UDim2.new((function()
			if useScrollButtons then
				return 1, -13, 0.8 / ((dropDownItemCount + 1) * 0.8), 0
			else
				return 1, 0, 0.8 / ((dropDownItemCount + 1) * 0.8), 0
			end
		end)()),
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
	local scrollUpButton, scrollDownButton
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
	local frame, updateSelection = t.CreateDropDownMenu(names, function(text)
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
	local pixelsRemaining = totalPixels
	for _, child in ipairs(guiObjects) do
		if child:IsA("TextLabel") or child:IsA("TextButton") then
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
	local slider, bar, sliderPosition, sliderSteps = sliderGui.Bar.Slider, sliderGui.Bar, sliderGui.SliderPosition, sliderGui.SliderSteps
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
		if areaSoakMouseMoveCon ~= nil then
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
	local desantsChangeConMap = { }
	local scrollingFrame = New("Frame", "ScrollingFrame", {
		Active = true,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDesants = true,
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
	do
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
	end
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
		if instance:IsDesantOf(controlFrame) then
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
			if dragCon ~= nil then
				dragCon:disconnect()
			end
			dragCon = nil
			if upCon ~= nil then
				upCon:disconnect()
			end
			upCon = nil
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
		if scrollbar.AbsolutePosition.y + scrollbar.AbsoluteSize.Y > scrollTrack.AbsolutePosition.y + scrollTrack.AbsoluteSize.y then
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
	scrollbar.MouseButton1Down:connect(function(_, y)
		if scrollbar.Active then
			scrollStamp = tick()
			local mouseOffset = y - scrollbar.AbsolutePosition.y
			if dragCon ~= nil then
				dragCon:disconnect()
			end
			dragCon = nil
			if upCon ~= nil then
				upCon:disconnect()
			end
			upCon = nil
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
	local desantChanged
	desantChanged = function(this, prop)
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
	scrollingFrame.DesantAdded:connect(function(instance)
		if not instance:IsA("GuiObject") then
			return
		end
		if instance.Visible then
			wait()
			highLowRecheck()
		end
		desantsChangeConMap[instance] = instance.Changed:connect(function(prop)
			return desantChanged(instance, prop)
		end)
	end)
	scrollingFrame.DesantRemoving:connect(function(instance)
		if not instance:IsA("GuiObject") then
			return
		end
		if desantsChangeConMap[instance] then
			desantsChangeConMap[instance]:disconnect()
			desantsChangeConMap[instance] = nil
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
t.CreateScrollingFrame = function(orderList, scrollStyle)
	local frame = New("Frame", "ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	})
	local scrollUpButton = New("ImageButton", "ScrollUpButton", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/scrollbuttonUp.png",
		Size = UDim2.new(0, 17, 0, 17)
	})
	local scrollDownButton = New("ImageButton", "ScrollDownButton", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/scrollbuttonDown.png",
		Size = UDim2.new(0, 17, 0, 17)
	})
	local scrollbar = New("ImageButton", "ScrollBar", {
		Image = "rbxasset://textures/ui/scrollbar.png",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 18, 0, 150),
		New("ImageButton", "ScrollDrag", {
			Image = "http://www.roblox.com/asset/?id=61367186",
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Active = true
		})
	})
	local scrollDrag = scrollbar.scrollDrag
	local mouseDrag = New("ImageButton", "mouseDrag", {
		Active = false,
		Size = UDim2.new(1.5, 0, 1.5, 0),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Position = UDim2.new(-0.25, 0, -0.25, 0),
		ZIndex = 10
	})
	local scrollStamp = 0
	local style = "simple"
	if scrollStyle and tostring(scrollStyle) then
		style = scrollStyle
	end
	local scrollPosition = 1
	local rowSize = 0
	local howManyDisplayed = 0
	local layoutGridScrollBar
	layoutGridScrollBar = function()
		howManyDisplayed = 0
		local guiObjects = { }
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
					if child:IsA("GuiObject") then
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
		while pos <= #guiObjects and pixelsBelowScrollbar < totalPixelsY do
			xCounter = xCounter + guiObjects[pos].AbsoluteSize.X
			if xCounter >= totalPixelsX then
				pixelsBelowScrollbar = pixelsBelowScrollbar + currentRowY
				currentRowY = 0
				xCounter = guiObjects[pos].AbsoluteSize.X
			end
			if guiObjects[pos].AbsoluteSize.Y > currentRowY then
				currentRowY = guiObjects[pos].AbsoluteSize.Y
			end
			pos = pos + 1
		end
		pixelsBelowScrollbar = pixelsBelowScrollbar + currentRowY
		currentRowY = 0
		pos = scrollPosition - 1
		xCounter = 0
		while pixelsBelowScrollbar + currentRowY < totalPixelsY and pos >= 1 do
			xCounter = xCounter + guiObjects[pos].AbsoluteSize.X
			rowSizeCounter = rowSizeCounter + 1
			if xCounter >= totalPixelsX then
				rowSize = rowSizeCounter - 1
				rowSizeCounter = 0
				xCounter = guiObjects[pos].AbsoluteSize.X
				if pixelsBelowScrollbar + currentRowY <= totalPixelsY then
					pixelsBelowScrollbar = pixelsBelowScrollbar + currentRowY
					if scrollPosition <= rowSize then
						scrollPosition = 1
						break
					else
						scrollPosition = scrollPosition - rowSize
					end
					currentRowY = 0
				else
					break
				end
			end
			if guiObjects[pos].AbsoluteSize.Y > currentRowY then
				currentRowY = guiObjects[pos].AbsoluteSize.Y
			end
			pos = pos - 1
		end
		if (pos == 0) and (pixelsBelowScrollbar + currentRowY <= totalPixelsY) then
			scrollPosition = 1
		end
		xCounter = 0
		rowSizeCounter = 0
		setRowSize = true
		local lastChildSize = 0
		local xOffset = 0
		local yOffset = 0
		if guiObjects[1] then
			yOffset = math.ceil(math.floor(math.fmod(totalPixelsY, guiObjects[1].AbsoluteSize.X)) / 2)
			xOffset = math.ceil(math.floor(math.fmod(totalPixelsX, guiObjects[1].AbsoluteSize.Y)) / 2)
		end
		for i, child in ipairs(guiObjects) do
			if i < scrollPosition then
				child.Visible = false
			else
				if pixelsRemainingY < 0 then
					child.Visible = false
				else
					if setRowSize then
						rowSizeCounter = rowSizeCounter + 1
					end
					if xCounter + child.AbsoluteSize.X >= totalPixelsX then
						if setRowSize then
							rowSize = rowSizeCounter - 1
							setRowSize = false
						end
						xCounter = 0
						pixelsRemainingY = pixelsRemainingY - child.AbsoluteSize.Y
					end
					child.Position = UDim2.new(child.Position.X.Scale, xCounter + xOffset, 0, totalPixelsY - pixelsRemainingY + yOffset)
					xCounter = xCounter + child.AbsoluteSize.X
					child.Visible = ((pixelsRemainingY - child.AbsoluteSize.Y) >= 0)
					if child.Visible then
						howManyDisplayed = howManyDisplayed + 1
					end
					lastChildSize = child.AbsoluteSize
				end
			end
		end
		scrollUpButton.Active = (scrollPosition > 1)
		if lastChildSize == 0 then
			scrollDownButton.Active = false
		else
			scrollDownButton.Active = (pixelsRemainingY - lastChildSize.Y) < 0
		end
		scrollDrag.Active = #guiObjects > howManyDisplayed
		scrollDrag.Visible = scrollDrag.Active
	end
	local layoutSimpleScrollBar
	layoutSimpleScrollBar = function()
		local guiObjects = { }
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
					if child:IsA("GuiObject") then
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
				pixelsBelowScrollbar = pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y
			else
				if pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y <= totalPixels then
					pixelsBelowScrollbar = pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y
					if scrollPosition <= 1 then
						scrollPosition = 1
						break
					else
						scrollPosition = scrollPosition - 1
					end
				else
					break
				end
			end
			pos = pos - 1
		end
		pos = scrollPosition
		for i, child in ipairs(guiObjects) do
			if i < scrollPosition then
				child.Visible = false
			else
				if pixelsRemaining < 0 then
					child.Visible = false
				else
					child.Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, totalPixels - pixelsRemaining)
					pixelsRemaining = pixelsRemaining - child.AbsoluteSize.Y
					if pixelsRemaining >= 0 then
						child.Visible = true
						howManyDisplayed = howManyDisplayed + 1
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
	local moveDragger
	moveDragger = function()
		local guiObjects = 0
		local children = frame:GetChildren()
		if children then
			for _, child in ipairs(children) do
				if child:IsA("GuiObject") then
					guiObjects = guiObjects + 1
				end
			end
		end
		if not scrollDrag.Parent then
			return
		end
		local dragSizeY = scrollDrag.Parent.AbsoluteSize.y * (1 / (guiObjects - howManyDisplayed + 1))
		if dragSizeY < 16 then
			dragSizeY = 16
		end
		scrollDrag.Size = UDim2.new(scrollDrag.Size.X.Scale, scrollDrag.Size.X.Offset, scrollDrag.Size.Y.Scale, dragSizeY)
		local relativeYPos = (scrollPosition - 1) / (guiObjects - howManyDisplayed)
		if relativeYPos > 1 then
			relativeYPos = 1
		elseif relativeYPos < 0 then
			relativeYPos = 0
		end
		local absYPos = 0
		if relativeYPos ~= 0 then
			absYPos = (relativeYPos * scrollbar.AbsoluteSize.y) - (relativeYPos * scrollDrag.AbsoluteSize.y)
		end
		scrollDrag.Position = UDim2.new(scrollDrag.Position.X.Scale, scrollDrag.Position.X.Offset, scrollDrag.Position.Y.Scale, absYPos)
	end
	local reentrancyGuard = false
	local recalculate
	recalculate = function()
		if reentrancyGuard then
			return
		end
		reentrancyGuard = true
		wait()
		local success, err
		if style == "grid" then
			success, err = pcall(function()
				return layoutGridScrollBar()
			end)
		elseif style == "simple" then
			success, err = pcall(function()
				return layoutSimpleScrollBar()
			end)
		end
		if not success then
			print(err)
		end
		moveDragger()
		reentrancyGuard = false
	end
	local doScrollUp
	doScrollUp = function()
		scrollPosition = scrollPosition - rowSize
		if scrollPosition < 1 then
			scrollPosition = 1
		end
		return recalculate(nil)
	end
	local doScrollDown
	doScrollDown = function()
		scrollPosition = scrollPosition + rowSize
		return recalculate(nil)
	end
	local scrollUp
	scrollUp = function(mouseYPos)
		if scrollUpButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			local upCon = mouseDrag.MouseButton1Up:connect(function()
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
	local scrollDown
	scrollDown = function(mouseYPos)
		if scrollDownButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			local downCon = mouseDrag.MouseButton1Up:connect(function()
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
				if mouseYPos and mouseYPos < (scrollDrag.AbsolutePosition.y + scrollDrag.AbsoluteSize.x) then
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
	scrollDrag.MouseButton1Down:connect(function(_, y)
		if scrollDrag.Active then
			scrollStamp = tick()
			local mouseOffset = y - scrollDrag.AbsolutePosition.y
			local dragCon, upCon
			dragCon = mouseDrag.MouseMoved:connect(function(_, y)
				local barAbsPos = scrollbar.AbsolutePosition.y
				local barAbsSize = scrollbar.AbsoluteSize.y
				local dragAbsSize = scrollDrag.AbsoluteSize.y
				local barAbsOne = barAbsPos + barAbsSize - dragAbsSize
				y = y - mouseOffset
				y = y < barAbsPos and barAbsPos or y > barAbsOne and barAbsOne or y
				y = y - barAbsPos
				local guiObjects = 0
				local children = frame:GetChildren()
				if children then
					for _, child in ipairs(children) do
						if child:IsA("GuiObject") then
							guiObjects = guiObjects + 1
						end
					end
				end
				local doublePercent = y / (barAbsSize - dragAbsSize)
				local rowDiff = rowSize
				local totalScrollCount = guiObjects - (howManyDisplayed - 1)
				local newScrollPosition = math.floor((doublePercent * totalScrollCount) + 0.5) + rowDiff
				if newScrollPosition < scrollPosition then
					rowDiff = -rowDiff
				end
				if newScrollPosition < 1 then
					newScrollPosition = 1
				end
				scrollPosition = newScrollPosition
				return recalculate(nil)
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
	scrollUpButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollDownButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollbar.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollbar.MouseButton1Down:connect(function(_, y)
		if y > (scrollDrag.AbsoluteSize.y + scrollDrag.AbsolutePosition.y) then
			return scrollDown(y)
		elseif y < scrollDrag.AbsolutePosition.y then
			return scrollUp(y)
		end
	end)
	frame.ChildAdded:connect(function()
		return recalculate(nil)
	end)
	frame.ChildRemoved:connect(function()
		return recalculate(nil)
	end)
	frame.AncestryChanged:connect(function()
		return recalculate(nil)
	end)
	frame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			return recalculate(nil)
		end
	end)
	return frame, scrollUpButton, scrollDownButton, recalculate, scrollbar
end
local binaryGrow
binaryGrow = function(min, max, fits)
	if min > max then
		return min
	end
	local biggestLegal = min
	while min <= max do
		local mid = min + math.floor((max - min) / 2)
		if fits(mid) and (not (biggestLegal ~= nil) or biggestLegal < mid) then
			biggestLegal = mid
			min = mid + 1
		else
			max = mid - 1
		end
	end
	return biggestLegal
end
local binaryShrink
binaryShrink = function(min, max, fits)
	if min > max then
		return min
	end
	local smallestLegal = max
	while min <= max do
		local mid = min + math.floor((max - min) / 2)
		if fits(mid) and (not (smallestLegal ~= nil) or smallestLegal > mid) then
			smallestLegal = mid
			max = mid - 1
		else
			min = mid + 1
		end
	end
	return smallestLegal
end
local getGuiOwner
getGuiOwner = function(instance)
	while (instance ~= nil) do
		if instance:IsA("ScreenGui") or instance:IsA("BillboardGui") then
			return instance
		end
		instance = instance.Parent
	end
end
t.AutoTruncateTextObject = function(textLabel)
	local text = textLabel.Text
	local fullLabel = textLabel:Clone()
	fullLabel.Name = "Full" .. tostring(textLabel.Name)
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
	local checkForResize
	checkForResize = function()
		if not (getGuiOwner(textLabel) ~= nil) then
			return
		end
		textLabel.Text = text
		if textLabel.TextFits then
			if mouseEnterConnection ~= nil then
				mouseEnterConnection:disconnect()
			end
			mouseEnterConnection = nil
			if mouseLeaveConnection ~= nil then
				mouseLeaveConnection:disconnect()
			end
			mouseLeaveConnection = nil
		else
			local len = string.len(text)
			textLabel.Text = tostring(text) .. "~"
			local textSize = binaryGrow(0, len, function(pos)
				if pos == 0 then
					textLabel.Text = "~"
				else
					textLabel.Text = tostring(string.sub(text, 1, pos)) .. "~"
				end
				return textLabel.TextFits
			end)
			shortText = tostring(string.sub(text, 1, textSize)) .. "~"
			textLabel.Text = shortText
			if not fullLabel.TextFits then
				fullLabel.Size = UDim2.new(0, 10000, 1, 0)
			end
			local fullLabelSize = binaryShrink(textLabel.AbsoluteSize.X, fullLabel.AbsoluteSize.X, function(size)
				fullLabel.Size = UDim2.new(0, size, 1, 0)
				return fullLabel.TextFits
			end)
			fullLabel.Size = UDim2.new(0, fullLabelSize + 6, 1, 0)
			if not (mouseEnterConnection ~= nil) then
				mouseEnterConnection = textLabel.MouseEnter:connect(function()
					fullLabel.ZIndex = textLabel.ZIndex + 1
					fullLabel.Visible = true
				end)
			end
			if not (mouseLeaveConnection ~= nil) then
				mouseLeaveConnection = textLabel.MouseLeave:connect(function()
					fullLabel.Visible = false
				end)
			end
		end
	end
	textLabel.AncestryChanged:connect(checkForResize)
	textLabel.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			return checkForResize()
		end
	end)
	checkForResize()
	local changeText
	changeText = function(newText)
		text = newText
		fullLabel.Text = text
		return checkForResize()
	end
	return textLabel, changeText
end
local TransitionTutorialPages
TransitionTutorialPages = function(fromPage, toPage, transitionFrame, currentPageValue)
	if fromPage then
		fromPage.Visible = false
		if transitionFrame.Visible == false then
			transitionFrame.Size = fromPage.Size
			transitionFrame.Position = fromPage.Position
		end
	elseif transitionFrame.Visible == false then
		transitionFrame.Size = UDim2.new(0, 50, 0, 50)
		transitionFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
	end
	transitionFrame.Visible = true
	currentPageValue.Value = nil
	local newSize, newPosition
	if toPage then
		toPage.Visible = true
		newSize = toPage.Size
		newPosition = toPage.Position
		toPage.Visible = false
	else
		newSize = UDim2.new(0, 50, 0, 50)
		newPosition = UDim2.new(0.5, -25, 0.5, -25)
	end
	return transitionFrame:TweenSizeAndPosition(newSize, newPosition, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true, function(state)
		if state == Enum.TweenStatus.Completed then
			transitionFrame.Visible = false
			if toPage then
				toPage.Visible = true
				currentPageValue.Value = toPage
			end
		end
	end)
end
t.CreateTutorial = function(name, tutorialKey, createButtons)
	local frame = New("Frame", "Tutorial-" .. tostring(name), {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Position = UDim2.new(0.2, 0, 0.2, 0),
		New("Frame", "TransitionFrame", {
			Style = Enum.FrameStyle.RobloxRound,
			Size = UDim2.new(0.6, 0, 0.6, 0),
			Position = UDim2.new(0.2, 0, 0.2, 0),
			Visible = false
		}),
		New("ObjectValue", "CurrentTutorialPage", {
			Value = nil
		}),
		New("BoolValue", "Buttons", {
			Value = createButtons
		}),
		New("Frame", "Pages", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		})
	})
	local transitionFrame, currentPageValue, pages = frame.TransitionFrame, frame.CurrentTutorialPage, frame.Pages
	local getVisiblePageAndHideOthers
	getVisiblePageAndHideOthers = function()
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
	local showTutorial
	showTutorial = function(alwaysShow)
		if alwaysShow or UserSettings().GameSettings:GetTutorialState(tutorialKey) == false then
			print("Showing tutorial-", tutorialKey)
			local currentTutorialPage = getVisiblePageAndHideOthers()
			local firstPage = pages:FindFirstChild("TutorialPage1")
			if firstPage then
				return TransitionTutorialPages(currentTutorialPage, firstPage, transitionFrame, currentPageValue)
			else
				return error("Could not find TutorialPage1")
			end
		end
	end
	local dismissTutorial
	dismissTutorial = function()
		local currentTutorialPage = getVisiblePageAndHideOthers()
		if currentTutorialPage then
			TransitionTutorialPages(currentTutorialPage, nil, transitionFrame, currentPageValue)
		end
		return UserSettings().GameSettings:SetTutorialState(tutorialKey, true)
	end
	local gotoPage
	gotoPage = function(pageNum)
		local page = pages:FindFirstChild("TutorialPage" .. tostring(pageNum))
		local currentTutorialPage = getVisiblePageAndHideOthers()
		return TransitionTutorialPages(currentTutorialPage, page, transitionFrame, currentPageValue)
	end
	return frame, showTutorial, dismissTutorial, gotoPage
end
local CreateBasicTutorialPage
CreateBasicTutorialPage = function(name, handleResize, skipTutorial, giveDoneButton)
	local frame = New("Frame", "TutorialPage", {
		Style = Enum.FrameStyle.RobloxRound,
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Position = UDim2.new(0.2, 0, 0.2, 0),
		Visible = false,
		New("TextLabel", "Header", {
			Text = name,
			BackgroundTransparency = 1,
			FontSize = Enum.FontSize.Size24,
			Font = Enum.Font.ArialBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrap = true,
			Size = UDim2.new(1, -55, 0, 22),
			Position = UDim2.new(0, 0, 0, 0)
		}),
		New("ImageButton", "SkipButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/closeButton.png",
			Size = UDim2.new(0, 25, 0, 25),
			Position = UDim2.new(1, -25, 0, 0)
		}),
		New("TextButton", "NextButton", {
			Text = "Next",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Size = UDim2.new(0, 80, 0, 32),
			Position = UDim2.new(0.5, 5, 1, -32),
			Active = false,
			Visible = false
		}),
		New("TextButton", "PrevButton", {
			Text = "Previous",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Style = Enum.ButtonStyle.RobloxButton,
			Size = UDim2.new(0, 80, 0, 32),
			Position = UDim2.new(0.5, -85, 1, -32),
			Active = false,
			Visible = false
		}),
		New("Frame", "ContentFrame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 25)
		})
	})
	local innerFrame = frame.ContentFrame
	do
		local _with_0 = frame.SkipButton
		_with_0.MouseButton1Click:connect(function()
			return skipTutorial()
		end)
		_with_0.MouseEnter:connect(function()
			_with_0.Image = "rbxasset://textures/ui/closeButton_dn.png"
		end)
		_with_0.MouseLeave:connect(function()
			_with_0.Image = "rbxasset://textures/ui/closeButton.png"
		end)
	end
	if giveDoneButton then
		local doneButton = New("TextButton", "DoneButton", {
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Text = "Done",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			Size = UDim2.new(0, 100, 0, 50),
			Position = UDim2.new(0.5, -50, 1, -50),
			Parent = frame
		})
		if skipTutorial then
			doneButton.MouseButton1Click:connect(function()
				return skipTutorial()
			end)
		end
	end
	if giveDoneButton then
		innerFrame.Size = UDim2.new(1, 0, 1, -75)
	else
		innerFrame.Size = UDim2.new(1, 0, 1, -22)
	end
	local parentConnection
	local basicHandleResize
	basicHandleResize = function()
		if frame.Visible and frame.Parent then
			local maxSize = math.min(frame.Parent.AbsoluteSize.X, frame.Parent.AbsoluteSize.Y)
			return handleResize(200, maxSize)
		end
	end
	frame.Changed:connect(function(prop)
		if prop == "Parent" then
			if parentConnection ~= nil then
				parentConnection:disconnect()
			end
			parentConnection = nil
			if frame.Parent and frame.Parent:IsA("GuiObject") then
				parentConnection = frame.Parent.Changed:connect(function(parentProp)
					if parentProp == "AbsoluteSize" then
						wait()
						return basicHandleResize()
					end
				end)
				basicHandleResize()
			end
		end
		if prop == "Visible" then
			return basicHandleResize()
		end
	end)
	return frame, innerFrame
end
t.CreateTextTutorialPage = function(name, text, skipTutorialFunc)
	local frame
	local textLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Text = text,
		TextWrap = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size14,
		Size = UDim2.new(1, 0, 1, 0)
	})
	local handleResize
	handleResize = function(minSize, maxSize)
		local size = binaryShrink(minSize, maxSize, function(size)
			frame.Size = UDim2.new(0, size, 0, size)
			return textLabel.TextFits
		end)
		frame.Size = UDim2.new(0, size, 0, size)
		frame.Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2)
	end
	local contentFrame
	frame, contentFrame = CreateBasicTutorialPage(name, handleResize, skipTutorialFunc)
	textLabel.Parent = contentFrame
	return frame
end
t.CreateImageTutorialPage = function(name, imageAsset, x, y, skipTutorialFunc, giveDoneButton)
	local frame, contentFrame
	local imageLabel = New("ImageLabel", {
		BackgroundTransparency = 1,
		Image = imageAsset,
		Size = UDim2.new(0, x, 0, y),
		Position = UDim2.new(0.5, -x / 2, 0.5, -y / 2)
	})
	local handleResize
	handleResize = function(minSize, maxSize)
		local size = binaryShrink(minSize, maxSize, function(size)
			return size >= x and size >= y
		end)
		if size >= x and size >= y then
			imageLabel.Size = UDim2.new(0, x, 0, y)
			imageLabel.Position = UDim2.new(0.5, -x / 2, 0.5, -y / 2)
		else
			if x > y then
				imageLabel.Size, imageLabel.Position = UDim2.new(1, 0, y / x, 0), UDim2.new(0, 0, 0.5 - (y / x) / 2, 0)
			else
				imageLabel.Size, imageLabel.Position = UDim2.new(x / y, 0, 1, 0), UDim2.new(0.5 - (x / y) / 2, 0, 0, 0)
			end
		end
		size = size + 50
		frame.Size = UDim2.new(0, size, 0, size)
		frame.Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2)
	end
	frame, contentFrame = CreateBasicTutorialPage(name, handleResize, skipTutorialFunc, giveDoneButton)
	imageLabel.Parent = contentFrame
	return frame
end
t.AddTutorialPage = function(tutorial, tutorialPage)
	local transitionFrame = tutorial.TransitionFrame
	local currentPageValue = tutorial.CurrentTutorialPage
	if not tutorial.Buttons.Value then
		tutorialPage.NextButton.Parent = nil
		tutorialPage.PrevButton.Parent = nil
	end
	local children = tutorial.Pages:GetChildren()
	if children and #children > 0 then
		tutorialPage.Name = "TutorialPage" .. tostring(#children + 1)
		local previousPage = children[#children]
		if not previousPage:IsA("GuiObject") then
			error("All elements under Pages must be GuiObjects")
		end
		if tutorial.Buttons.Value then
			if previousPage.NextButton.Active then
				error("NextButton already Active on previousPage, please only add pages with RbxGui.AddTutorialPage function")
			end
			previousPage.NextButton.MouseButton1Click:connect(function()
				return TransitionTutorialPages(previousPage, tutorialPage, transitionFrame, currentPageValue)
			end)
			previousPage.NextButton.Active = true
			previousPage.NextButton.Visible = true
			if tutorialPage.PrevButton.Active then
				error("PrevButton already Active on tutorialPage, please only add pages with RbxGui.AddTutorialPage function")
			end
			tutorialPage.PrevButton.MouseButton1Click:connect(function()
				return TransitionTutorialPages(tutorialPage, previousPage, transitionFrame, currentPageValue)
			end)
			tutorialPage.PrevButton.Active = true
			tutorialPage.PrevButton.Visible = true
		end
		tutorialPage.Parent = tutorial.Pages
	else
		tutorialPage.Name = "TutorialPage1"
		tutorialPage.Parent = tutorial.Pages
	end
end
t.CreateSetPanel = function(userIdsForSets, objectSelected, dialogClosed, size, position, showAdminCategories, useAssetVersionId)
	if not userIdsForSets then
		error("CreateSetPanel: userIdsForSets (first arg) is nil, should be a table of number ids")
	end
	if type(userIdsForSets) ~= "table" and type(userIdsForSets) ~= "userdata" then
		error("CreateSetPanel: userIdsForSets (first arg) is of type " .. tostring(type(userIdsForSets)) .. ", should be of type table or userdata")
	end
	if not objectSelected then
		error("CreateSetPanel: objectSelected (second arg) is nil, should be a callback function!")
	end
	if type(objectSelected) ~= "function" then
		error("CreateSetPanel: objectSelected (second arg) is of type " .. tostring(type(objectSelected)) .. ", should be of type function!")
	end
	if dialogClosed and type(dialogClosed) ~= "function" then
		error("CreateSetPanel: dialogClosed (third arg) is of type " .. tostring(type(dialogClosed)) .. ", should be of type function!")
	end
	if not (showAdminCategories ~= nil) then
		showAdminCategories = false
	end
	local arrayPosition = 1
	local insertButtons = { }
	local insertButtonCons = { }
	local contents, setGui
	local waterForceDirection = "NegX"
	local waterForce = "None"
	local waterGui, waterTypeChangedEvent
	local Data = { }
	Data.CurrentCategory = nil
	Data.Category = { }
	local SetCache = { }
	local userCategoryButtons
	local buttonWidth = 64
	local buttonHeight = buttonWidth
	local SmallThumbnailUrl, LargeThumbnailUrl
	local BaseUrl = game:GetService("ContentProvider").BaseUrl:lower()
	if useAssetVersionId then
		LargeThumbnailUrl, SmallThumbnailUrl = tostring(BaseUrl) .. "Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&assetversionid=", tostring(BaseUrl) .. "Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&assetversionid="
	else
		LargeThumbnailUrl, SmallThumbnailUrl = tostring(BaseUrl) .. "Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=420&ht=420&aid=", tostring(BaseUrl) .. "Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&aid="
	end
	local drillDownSetZIndex
	drillDownSetZIndex = function(parent, index)
		local children = parent:GetChildren()
		for i = 1, #children do
			if children[i]:IsA("GuiObject") then
				children[i].ZIndex = index
			end
			drillDownSetZIndex(children[i], index)
		end
	end
	local currTerrainDropDownFrame
	local terrainShapes = {
		"Block",
		"Vertical Ramp",
		"Corner Wedge",
		"Inverse Corner Wedge",
		"Horizontal Ramp",
		"Auto-Wedge"
	}
	local terrainShapeMap = { }
	for i = 1, #terrainShapes do
		terrainShapeMap[terrainShapes[i]] = i - 1
	end
	terrainShapeMap[terrainShapes[#terrainShapes]] = 6
	local createWaterGui
	createWaterGui = function()
		local waterForceDirections = {
			"NegX",
			"X",
			"NegY",
			"Y",
			"NegZ",
			"Z"
		}
		local waterForces = {
			"None",
			"Small",
			"Medium",
			"Strong",
			"Max"
		}
		local waterFrame = New("Frame", "WaterFrame", {
			Style = Enum.FrameStyle.RobloxSquare,
			Size = UDim2.new(0, 150, 0, 110),
			Visible = false
		})
		local waterForceLabel = New("TextLabel", "WaterForceLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 12),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size12,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "Water Force",
			Parent = waterFrame
		})
		local waterForceDirLabel = waterForceLabel:Clone()
		waterForceDirLabel.Name = "WaterForceDirectionLabel"
		waterForceDirLabel.Text = "Water Force Direction"
		waterForceDirLabel.Position = UDim2.new(0, 0, 0, 50)
		waterForceDirLabel.Parent = waterFrame
		waterTypeChangedEvent = New("BindableEvent", "WaterTypeChangedEvent", {
			Parent = waterFrame
		})
		local waterForceDirectionSelectedFunc
		waterForceDirectionSelectedFunc = function(newForceDirection)
			waterForceDirection = newForceDirection
			return waterTypeChangedEvent:Fire({
				waterForce,
				waterForceDirection
			})
		end
		local waterForceSelectedFunc
		waterForceSelectedFunc = function(newForce)
			waterForce = newForce
			return waterTypeChangedEvent:Fire({
				waterForce,
				waterForceDirection
			})
		end
		local waterForceDirectionDropDown, forceWaterDirectionSelection = t.CreateDropDownMenu(waterForceDirections, waterForceDirectionSelectedFunc)
		waterForceDirectionDropDown.Size = UDim2.new(1, 0, 0, 25)
		waterForceDirectionDropDown.Position = UDim2.new(0, 0, 1, 3)
		forceWaterDirectionSelection("NegX")
		waterForceDirectionDropDown.Parent = waterForceDirLabel
		local waterForceDropDown, forceWaterForceSelection = t.CreateDropDownMenu(waterForces, waterForceSelectedFunc)
		forceWaterForceSelection("None")
		waterForceDropDown.Size = UDim2.new(1, 0, 0, 25)
		waterForceDropDown.Position = UDim2.new(0, 0, 1, 3)
		waterForceDropDown.Parent = waterForceLabel
		return waterFrame, waterTypeChangedEvent
	end
	local createSetGui
	createSetGui = function()
		setGui = Instance.new("ScreenGui")
		setGui.Name = "SetGui"
		local setPanel = New("Frame", "SetPanel", {
			Active = true,
			BackgroundTransparency = 1,
			Position = position or UDim2.new(0.2, 29, 0.1, 24),
			Size = size or UDim2.new(0.6, -58, 0.64, 0),
			Style = Enum.FrameStyle.RobloxRound,
			ZIndex = 6,
			Parent = setGui,
			New("TextButton", "CancelButton", {
				Position = UDim2.new(1, -32, 0, -2),
				Size = UDim2.new(0, 34, 0, 34),
				Style = Enum.ButtonStyle.RobloxButtonDefault,
				ZIndex = 6,
				Text = "",
				Modal = true,
				New("ImageLabel", "CancelImage", {
					BackgroundTransparency = 1,
					Image = "http://www.roblox.com/asset?id=54135717",
					Position = UDim2.new(0, -2, 0, -2),
					Size = UDim2.new(0, 16, 0, 16),
					ZIndex = 6
				})
			}),
			New("Frame", "ItemPreview", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.8, 5, 0.085, 0),
				Size = UDim2.new(0.21, 0, 0.9, 0),
				ZIndex = 6,
				New("ImageLabel", "LargePreview", {
					BackgroundTransparency = 1,
					Image = "",
					Size = UDim2.new(1, 0, 0, 170),
					ZIndex = 6
				}),
				New("Frame", "TextPanel", {
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0.45, 0),
					Size = UDim2.new(1, 0, 0.55, 0),
					ZIndex = 6,
					New("TextLabel", "RolloverText", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 48),
						ZIndex = 6,
						Font = Enum.Font.ArialBold,
						FontSize = Enum.FontSize.Size24,
						Text = "",
						TextColor3 = Color3.new(1, 1, 1),
						TextWrap = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					})
				})
			}),
			New("Frame", "Sets", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 5),
				Size = UDim2.new(0.23, 0, 1, -5),
				ZIndex = 6,
				New("Frame", "Line", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 0.7,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -3, 0.06, 0),
					Size = UDim2.new(0, 3, 0.9, 0),
					ZIndex = 6
				}),
				New("TextLabel", "SetsHeader", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 47, 0, 24),
					ZIndex = 6,
					Font = Enum.Font.ArialBold,
					FontSize = Enum.FontSize.Size24,
					Text = "Sets",
					TextColor3 = Color3.new(1, 1, 1),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top
				})
			})
		})
		local setsLists, controlFrame = t.CreateTrueScrollingFrame()
		setsLists.Size = UDim2.new(1, -6, 0.94, 0)
		setsLists.Position = UDim2.new(0, 0, 0.06, 0)
		setsLists.BackgroundTransparency = 1
		setsLists.Name = "SetsLists"
		setsLists.ZIndex = 6
		setsLists.Parent = setPanel.Sets
		drillDownSetZIndex(controlFrame, 7)
		return setGui
	end
	local createSetButton
	createSetButton = function(text)
		local setButton = New("TextButton", {
			Text = text or "",
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
			TextXAlignment = Enum.TextXAlignment.Left
		})
		return setButton
	end
	local buildSetButton
	buildSetButton = function(name, setId, _, _, _)
		local button = createSetButton(name)
		button.Text = name
		button.Name = "SetButton"
		button.Visible = true
		New("IntValue", "SetId", {
			Value = setId,
			Parent = button
		})
		New("StringValue", "SetName", {
			Value = name,
			Parent = button
		})
		return button
	end
	local processCategory
	processCategory = function(sets)
		local setButtons = { }
		local numSkipped = 0
		for i = 1, #sets do
			if not showAdminCategories and sets[i].Name == "Beta" then
				numSkipped = numSkipped + 1
			else
				setButtons[i - numSkipped] = buildSetButton(sets[i].Name, sets[i].CategoryId, sets[i].ImageAssetId, i - numSkipped, #sets)
			end
		end
		return setButtons
	end
	local handleResize
	handleResize = function()
		wait()
		local _with_0 = setGui.SetPanel.ItemPreview
		_with_0.LargePreview.Size = UDim2.new(1, 0, 0, _with_0.AbsoluteSize.X)
		_with_0.LargePreview.Position = UDim2.new(0.5, -_with_0.LargePreview.AbsoluteSize.X / 2, 0, 0)
		_with_0.TextPanel.Position = UDim2.new(0, 0, 0, _with_0.LargePreview.AbsoluteSize.Y)
		_with_0.TextPanel.Size = UDim2.new(1, 0, 0, _with_0.AbsoluteSize.Y - _with_0.LargePreview.AbsoluteSize.Y)
		return _with_0
	end
	local makeInsertAssetButton
	makeInsertAssetButton = function()
		local insertAssetButtonExample = New("Frame", "InsertAssetButtonExample", {
			Position = UDim2.new(0, 128, 0, 64),
			Size = UDim2.new(0, 64, 0, 64),
			BackgroundTransparency = 1,
			ZIndex = 6,
			Visible = false,
			New("IntValue", "AssetId", {
				Value = 0
			}),
			New("StringValue", "AssetName", {
				Value = ""
			}),
			New("TextButton", "Button", {
				Text = "",
				Style = Enum.ButtonStyle.RobloxButton,
				Position = UDim2.new(0.025, 0, 0.025, 0),
				Size = UDim2.new(0.95, 0, 0.95, 0),
				ZIndex = 6,
				New("ImageLabel", "ButtonImage", {
					Image = "",
					Position = UDim2.new(0, -7, 0, -7),
					Size = UDim2.new(1, 14, 1, 14),
					BackgroundTransparency = 1,
					ZIndex = 7
				})
			})
		})
		do
			local _with_0 = insertAssetButtonExample.button.ButtonImage:clone()
			_with_0.Name = "ConfigIcon"
			_with_0.Visible = false
			_with_0.Position = UDim2.new(1, -23, 1, -24)
			_with_0.Size = UDim2.new(0, 16, 0, 16)
			_with_0.Image = ""
			_with_0.ZIndex = 6
			_with_0.Parent = insertAssetButtonExample
		end
		return insertAssetButtonExample
	end
	local showLargePreview
	showLargePreview = function(insertButton)
		if insertButton:FindFirstChild("AssetId") then
			delay(0, function()
				game:GetService("ContentProvider"):Preload(LargeThumbnailUrl .. tostring(insertButton.AssetId.Value))
				setGui.SetPanel.ItemPreview.LargePreview.Image = LargeThumbnailUrl .. tostring(insertButton.AssetId.Value)
			end)
		end
		if insertButton:FindFirstChild("AssetName") then
			setGui.SetPanel.ItemPreview.TextPanel.RolloverText.Text = insertButton.AssetName.Value
		end
	end
	local selectTerrainShape
	selectTerrainShape = function(shape)
		if currTerrainDropDownFrame then
			return objectSelected(tostring(currTerrainDropDownFrame.AssetName.Value), tonumber(currTerrainDropDownFrame.AssetId.Value), shape)
		end
	end
	local createTerrainTypeButton
	createTerrainTypeButton = function(name, parent)
		local dropDownTextButton = New("TextButton", tostring(name) .. "Button", {
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size14,
			BorderSizePixel = 0,
			TextColor3 = Color3.new(1, 1, 1),
			Text = name,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			ZIndex = parent.ZIndex + 1,
			Size = UDim2.new(0, parent.Size.X.Offset - 2, 0, 16),
			Position = UDim2.new(0, 1, 0, 0)
		})
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
			if dropDownTextButton.Parent and dropDownTextButton.Parent:IsA("GuiObject") then
				dropDownTextButton.Parent.Visible = false
			end
			return selectTerrainShape(terrainShapeMap[dropDownTextButton.Text])
		end)
		return dropDownTextButton
	end
	local createTerrainDropDownMenu
	createTerrainDropDownMenu = function(zIndex)
		local dropDown = New("Frame", "TerrainDropDown", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderColor3 = Color3.new(1, 0, 0),
			Size = UDim2.new(0, 200, 0, 0),
			Visible = false,
			ZIndex = zIndex,
			Parent = setGui
		})
		for i = 1, #terrainShapes do
			local shapeButton = createTerrainTypeButton(terrainShapes[i], dropDown)
			shapeButton.Position = UDim2.new(0, 1, 0, (i - 1) * shapeButton.Size.Y.Offset)
			shapeButton.Parent = dropDown
			dropDown.Size = UDim2.new(0, 200, 0, dropDown.Size.Y.Offset + shapeButton.Size.Y.Offset)
		end
		return dropDown.MouseLeave:connect(function()
			dropDown.Visible = false
		end)
	end
	local createDropDownMenuButton
	createDropDownMenuButton = function(parent)
		local dropDownButton = New("ImageButton", {
			Name = "DropDownButton",
			Image = "http://www.roblox.com/asset/?id=67581509",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(1, -24, 0, 6),
			ZIndex = parent.ZIndex + 2,
			Parent = parent
		})
		if not setGui:FindFirstChild("TerrainDropDown") then
			createTerrainDropDownMenu(8)
		end
		return dropDownButton.MouseButton1Click:connect(function()
			setGui.TerrainDropDown.Visible = true
			setGui.TerrainDropDown.Position = UDim2.new(0, parent.AbsolutePosition.X, 0, parent.AbsolutePosition.Y)
			currTerrainDropDownFrame = parent
		end)
	end
	local buildInsertButton
	buildInsertButton = function()
		local insertButton = makeInsertAssetButton()
		insertButton.Name = "InsertAssetButton"
		insertButton.Visible = true
		if Data.Category[Data.CurrentCategory].SetName == "High Scalability" then
			createDropDownMenuButton(insertButton)
		end
		local lastEnter = nil
		local mouseEnterCon = insertButton.MouseEnter:connect(function()
			lastEnter = insertButton
			return delay(0.1, function()
				if lastEnter == insertButton then
					return showLargePreview(insertButton)
				end
			end)
		end)
		return insertButton, mouseEnterCon
	end
	local realignButtonGrid
	realignButtonGrid = function(columns)
		local x = 0
		local y = 0
		for i = 1, #insertButtons do
			insertButtons[i].Position = UDim2.new(0, buttonWidth * x, 0, buttonHeight * y)
			x = x + 1
			if x >= columns then
				x = 0
				y = y + 1
			end
		end
	end
	local setInsertButtonImageBehavior
	setInsertButtonImageBehavior = function(insertFrame, visible, name, assetId)
		if visible then
			insertFrame.AssetName.Value = name
			insertFrame.AssetId.Value = assetId
			local newImageUrl = SmallThumbnailUrl .. assetId
			if newImageUrl ~= insertFrame.Button.ButtonImage.Image then
				delay(0, function()
					game:GetService("ContentProvider"):Preload(SmallThumbnailUrl .. assetId)
					insertFrame.Button.ButtonImage.Image = SmallThumbnailUrl .. assetId
				end)
			end
			table.insert(insertButtonCons, insertFrame.Button.MouseButton1Click:connect(function()
				local isWaterSelected = name == "Water" and (Data.Category[Data.CurrentCategory].SetName == "High Scalability")
				waterGui.Visible = isWaterSelected
				return objectSelected(name, (function()
					if isWaterSelected then
						return tonumber(assetId), nil
					else
						return tonumber(assetId)
					end
				end)())
			end))
			insertFrame.Visible = true
		else
			insertFrame.Visible = false
		end
	end
	local loadSectionOfItems
	loadSectionOfItems = function(setGui, rows, columns)
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
			arrayPosition = arrayPosition + 1
		end
		realignButtonGrid(columns)
		for index = origArrayPos, arrayPosition do
			if insertButtons[index] then
				if contents[index] then
					if contents[index].Name == "Water" and Data.Category[Data.CurrentCategory].SetName == "High Scalability" then
						insertButtons[index]:FindFirstChild("DropDownButton", true):Destroy()
					end
					local assetId
					if useAssetVersionId then
						assetId = contents[index].AssetVersionId
					else
						assetId = contents[index].AssetId
					end
					setInsertButtonImageBehavior(insertButtons[index], true, contents[index].Name, assetId)
				else
					break
				end
			else
				break
			end
		end
	end
	local setSetIndex
	setSetIndex = function()
		Data.Category[Data.CurrentCategory].Index = 0
		local rows = 7
		local columns = math.floor(setGui.SetPanel.ItemsFrame.AbsoluteSize.X / buttonWidth)
		contents = Data.Category[Data.CurrentCategory].Contents
		if contents then
			for i = 1, #insertButtons do
				insertButtons[i]:remove()
			end
			for i = 1, #insertButtonCons do
				if insertButtonCons[i] then
					insertButtonCons[i]:disconnect()
				end
			end
			insertButtonCons = { }
			insertButtons = { }
			arrayPosition = 1
			return loadSectionOfItems(setGui, rows, columns)
		end
	end
	local selectSet
	selectSet = function(button, setName, setId, _)
		if button and (Data.Category[Data.CurrentCategory] ~= nil) then
			do
				local _with_0 = Data.Category[Data.CurrentCategory]
				if button ~= _with_0.Button then
					_with_0.Button = button
					if not (SetCache[setId] ~= nil) then
						SetCache[setId] = game:GetService("InsertService"):GetCollection(setId)
					end
					_with_0.Contents = SetCache[setId]
					_with_0.SetName = setName
					_with_0.SetId = setId
				end
			end
			return setSetIndex()
		end
	end
	local selectCategoryPage
	selectCategoryPage = function(buttons, _)
		if buttons ~= Data.CurrentCategory then
			if Data.CurrentCategory then
				for _, button in pairs(Data.CurrentCategory) do
					button.Visible = false
				end
			end
			Data.CurrentCategory = buttons
			if not (Data.Category[Data.CurrentCategory] ~= nil) then
				Data.Category[Data.CurrentCategory] = { }
				if #buttons > 0 then
					return selectSet(buttons[1], buttons[1].SetName.Value, buttons[1].SetId.Value, 0)
				end
			else
				local _with_0 = Data.Category[Data.CurrentCategory]
				_with_0.Button = nil
				selectSet(_with_0.ButtonFrame, _with_0.SetName, _with_0.SetId, _with_0.Index)
				return _with_0
			end
		end
	end
	local selectCategory
	selectCategory = function(category)
		return selectCategoryPage(category, 0)
	end
	local resetAllSetButtonSelection
	resetAllSetButtonSelection = function()
		local setButtons = setGui.SetPanel.Sets.SetsLists:GetChildren()
		for i = 1, #setButtons do
			do
				local _with_0 = setButtons[i]
				if _with_0:IsA("TextButton") then
					_with_0.Selected = false
					_with_0.BackgroundTransparency = 1
					_with_0.TextColor3 = Color3.new(1, 1, 1)
					_with_0.BackgroundColor3 = Color3.new(1, 1, 1)
				end
			end
		end
	end
	local populateSetsFrame
	populateSetsFrame = function()
		local currRow = 0
		for i = 1, #userCategoryButtons do
			do
				local button = userCategoryButtons[i]
				button.Visible = true
				button.Position = UDim2.new(0, 5, 0, currRow * button.Size.Y.Offset)
				button.Parent = setGui.SetPanel.Sets.SetsLists
				if i == 1 then
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
					return selectSet(button, button.Text, userCategoryButtons[i].SetId.Value, 0)
				end)
				currRow = currRow + 1
			end
		end
		local buttons = setGui.SetPanel.Sets.SetsLists:GetChildren()
		if buttons then
			for i = 1, #buttons do
				if buttons[i]:IsA("TextButton") then
					selectSet(buttons[i], buttons[i].Text, userCategoryButtons[i].SetId.Value, 0)
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
	setGui.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			handleResize()
			return setSetIndex()
		end
	end)
	local scrollFrame, controlFrame = t.CreateTrueScrollingFrame()
	scrollFrame.Name = "ItemsFrame"
	scrollFrame.Size = UDim2.new(0.54, 0, 0.85, 0)
	scrollFrame.Position = UDim2.new(0.24, 0, 0.085, 0)
	scrollFrame.ZIndex = 6
	scrollFrame.Parent = setGui.SetPanel
	scrollFrame.BackgroundTransparency = 1
	drillDownSetZIndex(controlFrame, 7)
	controlFrame.Parent = setGui.SetPanel
	controlFrame.Position = UDim2.new(0.76, 5, 0, 0)
	local debounce = false
	local rows = math.floor(setGui.SetPanel.ItemsFrame.AbsoluteSize.Y / buttonHeight)
	local columns = math.floor(setGui.SetPanel.ItemsFrame.AbsoluteSize.X / buttonWidth)
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
	local userData = { }
	for id = 1, #userIdsForSets do
		local newUserData = game:GetService("InsertService"):GetUserSets(userIdsForSets[id])
		if newUserData and #newUserData > 2 then
			for category = 3, #newUserData do
				table.insert(userData, (function()
					if newUserData[category].Name == "High Scalability" then
						return 1, newUserData[category]
					else
						return newUserData[category]
					end
				end)())
			end
		end
	end
	if userData then
		userCategoryButtons = processCategory(userData)
	end
	populateSetsFrame()
	setGui.SetPanel.CancelButton.MouseButton1Click:connect(function()
		setGui.SetPanel.Visible = false
		if dialogClosed ~= nil then
			return dialogClosed()
		end
		return nil
	end)
	local setVisibilityFunction
	setVisibilityFunction = function(visible)
		setGui.SetPanel.Visible = not not visible
	end
	local getVisibilityFunction
	getVisibilityFunction = function()
		if (function()
			if setGui ~= nil then
				return setGui:FindFirstChild("SetPanel")
			end
			return nil
		end)() then
			return setGui.SetPanel.Visible
		end
		return false
	end
	return setGui, setVisibilityFunction, getVisibilityFunction, waterTypeChangedEvent
end
t.CreateTerrainMaterialSelector = function(size, position)
	local terrainMaterialSelectionChanged = Instance.new("BindableEvent")
	terrainMaterialSelectionChanged.Name = "TerrainMaterialSelectionChanged"
	local selectedButton
	local frame = New("Frame", "TerrainMaterialSelector", {
		Size = size or UDim2.new(0, 245, 0, 230),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Active = true
	})
	if position then
		frame.Position = position
	end
	terrainMaterialSelectionChanged.Parent = frame
	local materialToImageMap = { }
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
		"Water"
	}
	local currentMaterial = 1
	local getEnumFromName
	getEnumFromName = function(choice)
		for i, v in ipairs(materialNames) do
			if v == choice then
				return i
			end
		end
	end
	local getNameFromEnum
	getNameFromEnum = function(choice)
		if Enum.CellMaterial.Grass == choice or 1 == choice then
			return "Grass"
		elseif Enum.CellMaterial.Sand == choice or 2 == choice then
			return "Sand"
		elseif Enum.CellMaterial.Empty == choice or 0 == choice then
			return "Erase"
		elseif Enum.CellMaterial.Brick == choice or 3 == choice then
			return "Brick"
		elseif Enum.CellMaterial.Granite == choice or 4 == choice then
			return "Granite"
		elseif Enum.CellMaterial.Asphalt == choice or 5 == choice then
			return "Asphalt"
		elseif Enum.CellMaterial.Iron == choice or 6 == choice then
			return "Iron"
		elseif Enum.CellMaterial.Aluminum == choice or 7 == choice then
			return "Aluminum"
		elseif Enum.CellMaterial.Gold == choice or 8 == choice then
			return "Gold"
		elseif Enum.CellMaterial.WoodPlank == choice or 9 == choice then
			return "Plank"
		elseif Enum.CellMaterial.WoodLog == choice or 10 == choice then
			return "Log"
		elseif Enum.CellMaterial.Gravel == choice or 11 == choice then
			return "Gravel"
		elseif Enum.CellMaterial.CinderBlock == choice or 12 == choice then
			return "Cinder Block"
		elseif Enum.CellMaterial.MossyStone == choice or 13 == choice then
			return "Stone Wall"
		elseif Enum.CellMaterial.Cement == choice or 14 == choice then
			return "Concrete"
		elseif Enum.CellMaterial.RedPlastic == choice or 15 == choice then
			return "Plastic (red)"
		elseif Enum.CellMaterial.BluePlastic == choice or 16 == choice then
			return "Plastic (blue)"
		elseif Enum.CellMaterial.Water == choice or 17 == choice then
			return "Water"
		end
	end
	local updateMaterialChoice
	updateMaterialChoice = function(choice)
		currentMaterial = getEnumFromName(choice)
		return terrainMaterialSelectionChanged:Fire(currentMaterial)
	end
	for _, v in pairs(materialNames) do
		materialToImageMap[v] = { }
		materialToImageMap[v].Regular = "http://www.roblox.com/asset/?id=" .. tostring((function()
			if "Grass" == v then
				return 56563112
			elseif "Sand" == v then
				return 62356652
			elseif "Brick" == v then
				return 65961537
			elseif "Granite" == v then
				return 67532153
			elseif "Asphalt" == v then
				return 67532038
			elseif "Iron" == v then
				return 67532093
			elseif "Aluminum" == v then
				return 67531995
			elseif "Gold" == v then
				return 67532118
			elseif "Plastic (red)" == v then
				return 67531848
			elseif "Plastic (blue)" == v then
				return 67531924
			elseif "Plank" == v then
				return 67532015
			elseif "Log" == v then
				return 67532051
			elseif "Gravel" == v then
				return 67532206
			elseif "Cinder Block" == v then
				return 67532103
			elseif "Stone Wall" == v then
				return 67531804
			elseif "Concrete" == v then
				return 67532059
			elseif "Water" == v then
				return 81407474
			else
				return 66887593
			end
		end)())
	end
	local scrollFrame, scrollUp, scrollDown, recalculateScroll = t.CreateScrollingFrame(nil, "grid")
	scrollFrame.Size = UDim2.new(0.85, 0, 1, 0)
	scrollFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = frame
	scrollUp.Parent = frame
	scrollUp.Visible = true
	scrollUp.Position = UDim2.new(1, -19, 0, 0)
	scrollDown.Parent = frame
	scrollDown.Visible = true
	scrollDown.Position = UDim2.new(1, -19, 1, -17)
	local goToNewMaterial
	goToNewMaterial = function(buttonWrap, materialName)
		updateMaterialChoice(materialName)
		buttonWrap.BackgroundTransparency = 0
		selectedButton.BackgroundTransparency = 1
		selectedButton = buttonWrap
	end
	local createMaterialButton
	createMaterialButton = function(name)
		local buttonWrap = New("TextButton", tostring(name), {
			Text = "",
			Size = UDim2.new(0, 32, 0, 32),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			New("ImageButton", tostring(name), {
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 30, 0, 30),
				Position = UDim2.new(0, 1, 0, 1),
				Image = materialToImageMap[name].Regular
			}),
			New("NumberValue", "EnumType", {
				Value = 0
			})
		})
		do
			local _with_0 = buttonWrap.ImageButton
			_with_0.MouseEnter:connect(function()
				buttonWrap.BackgroundTransparency = 0
			end)
			_with_0.MouseLeave:connect(function()
				if selectedButton ~= buttonWrap then
					buttonWrap.BackgroundTransparency = 1
				end
			end)
			_with_0.MouseButton1Click:connect(function()
				if selectedButton ~= buttonWrap then
					return goToNewMaterial(buttonWrap, tostring(name))
				end
			end)
		end
		return buttonWrap
	end
	for i = 1, #materialNames do
		local imageButton = createMaterialButton(materialNames[i])
		if materialNames[i] == "Grass" then
			selectedButton = imageButton
			imageButton.BackgroundTransparency = 0
		end
		imageButton.Parent = scrollFrame
	end
	local forceTerrainMaterialSelection
	forceTerrainMaterialSelection = function(newMaterialType)
		if not newMaterialType then
			return
		end
		if currentMaterial == newMaterialType then
			return
		end
		local matName = getNameFromEnum(newMaterialType)
		local buttons = scrollFrame:GetChildren()
		for i = 1, #buttons do
			if (buttons[i].Name == "Plastic (blue)" and matName == "Plastic (blue)") or (buttons[i].Name == "Plastic (red)" and matName == "Plastic (red)") or (string.find(buttons[i].Name, matName)) then
				goToNewMaterial(buttons[i], matName)
				return
			end
		end
	end
	frame.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			return recalculateScroll()
		end
	end)
	recalculateScroll()
	return frame, terrainMaterialSelectionChanged, forceTerrainMaterialSelection
end
t.CreateLoadingFrame = function(name, size, position)
	game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=35238053")
	local loadingFrame = New("Frame", "LoadingFrame", {
		Style = Enum.FrameStyle.RobloxRound,
		Size = size or UDim2.new(0, 300, 0, 160),
		Position = position or UDim2.new(0.5, -150, 0.5, -80),
		New("TextLabel", "loadingName", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Position = UDim2.new(0, 0, 0, 2),
			Font = Enum.Font.Arial,
			Text = name,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 1,
			FontSize = Enum.FontSize.Size18
		}),
		New("TextButton", "CancelButton", {
			Position = UDim2.new(0.5, -60, 1, -40),
			Size = UDim2.new(0, 120, 0, 40),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "Cancel",
			Style = Enum.ButtonStyle.RobloxButton
		}),
		New("Frame", "LoadingBar", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderColor3 = Color3.new(79 / 255, 79 / 255, 79 / 255),
			Position = UDim2.new(0, 0, 0, 41),
			Size = UDim2.new(1, 0, 0, 30),
			New("ImageLabel", "LoadingGreenBar", {
				Image = "http://www.roblox.com/asset/?id=35238053",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 0, 1, 0),
				Visible = false
			}),
			New("TextLabel", "LoadingPercent", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 14),
				Font = Enum.Font.Arial,
				Text = "0%",
				FontSize = Enum.FontSize.Size14,
				TextColor3 = Color3.new(1, 1, 1)
			})
		})
	})
	local cancelButton, loadingGreenBar, loadingPercent = loadingFrame.CancelButton, loadingFrame.LoadingBar.LoadingGreenBar, loadingFrame.LoadingBar.LoadingPercent
	local cancelButtonClicked = New("BindableEvent", "CancelButtonClicked", {
		Parent = cancelButton
	})
	cancelButton.MouseButton1Click:connect(function()
		return cancelButtonClicked:Fire()
	end)
	local updateLoadingGuiPercent
	updateLoadingGuiPercent = function(percent, tweenAction, tweenLength)
		if percent and type(percent) ~= "number" then
			error("updateLoadingGuiPercent expects number as argument, got", type(percent), "instead")
		end
		local newSize = UDim2.new((function()
			if percent < 0 then
				return 0, 0, 1, 0
			elseif percent > 1 then
				return 1, 0, 1, 0
			else
				return percent, 0, 1, 0
			end
		end)())
		if tweenAction then
			if not tweenLength then
				error("updateLoadingGuiPercent is set to tween new percentage, but got no tween time length! Please pass this in as third argument")
			end
			return loadingGreenBar:TweenSize(newSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, tweenLength, (function()
				if newSize.X.Scale > 0 then
					loadingGreenBar.Visible = true
					return true
				else
					return true, function()
						if newSize.X.Scale < 0 then
							loadingGreenBar.Visible = false
						end
					end
				end
			end)())
		else
			loadingGreenBar.Size = newSize
			loadingGreenBar.Visible = newSize.X.Scale > 0
		end
	end
	loadingGreenBar.Changed:connect(function(prop)
		if prop == "Size" then
			loadingPercent.Text = tostring(math.ceil(loadingGreenBar.Size.X.Scale * 100)) .. "%"
		end
	end)
	return loadingFrame, updateLoadingGuiPercent, cancelButtonClicked
end
t.CreatePluginFrame = function(name, size, position, scrollable, parent)
	local createMenuButton
	createMenuButton = function(size, position, text, fontsize, name, parent)
		local _with_0 = New("TextButton", name, {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Position = position,
			Size = size,
			Font = Enum.Font.ArialBold,
			FontSize = fontsize,
			Text = text,
			TextColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(20 / 255, 20 / 255, 20 / 255)
		})
		_with_0.MouseEnter:connect(function()
			if _with_0.Selected then
				return
			end
			_with_0.BackgroundTransparency = 0
		end)
		_with_0.MouseLeave:connect(function()
			if _with_0.Selected then
				return
			end
			_with_0.BackgroundTransparency = 1
		end)
		_with_0.Parent = parent
		return _with_0
	end
	local dragBar = New("Frame", tostring(name) .. "DragBar", {
		BackgroundColor3 = Color3.new(39 / 255, 39 / 255, 39 / 255),
		BorderColor3 = Color3.new(0, 0, 0),
		Size = (function()
			if size then
				return UDim2.new(size.X.Scale, size.X.Offset, 0, 20) + UDim2.new(0, 20, 0, 0)
			else
				return UDim2.new(0, 183, 0, 20)
			end
		end)(),
		Active = true,
		Draggable = true,
		New("TextLabel", "BarNameLabel", {
			Text = " " .. tostring(name),
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1
		}),
		New("Frame", "HelpFrame", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(0, 300, 0, 552),
			Position = UDim2.new(1, 5, 0, 0),
			Active = true,
			BorderSizePixel = 0,
			Visible = false
		}),
		New("Frame", "SeparatingLine", {
			BackgroundColor3 = Color3.new(115 / 255, 115 / 255, 115 / 255),
			BorderSizePixel = 0,
			Position = UDim2.new(1, -18, 0.5, -7),
			Size = UDim2.new(0, 1, 0, 14)
		}),
		New("Frame", "MinimizeFrame", {
			BackgroundColor3 = Color3.new(73 / 255, 73 / 255, 73 / 255),
			BorderColor3 = Color3.new(0, 0, 0),
			Position = UDim2.new(0, 0, 1, 0),
			Size = (function()
				if size then
					return UDim2.new(size.X.Scale, size.X.Offset, 0, 50) + UDim2.new(0, 20, 0, 0)
				else
					return UDim2.new(0, 183, 0, 50)
				end
			end)(),
			Visible = false,
			New("TextButton", "MinimizeButton", {
				Position = UDim2.new(0.5, -50, 0.5, -20),
				Size = UDim2.new(0, 100, 0, 40),
				Style = Enum.ButtonStyle.RobloxButton,
				Font = Enum.Font.ArialBold,
				FontSize = Enum.FontSize.Size18,
				TextColor3 = Color3.new(1, 1, 1),
				Text = "Show"
			})
		})
	})
	if position then
		dragBar.Position = position
	end
	dragBar.MouseEnter:connect(function()
		dragBar.BackgroundColor3 = Color3.new(49 / 255, 49 / 255, 49 / 255)
	end)
	dragBar.MouseLeave:connect(function()
		dragBar.BackgroundColor3 = Color3.new(39 / 255, 39 / 255, 39 / 255)
	end)
	dragBar.Parent = parent
	local closeButton = createMenuButton(UDim2.new(0, 15, 0, 17), UDim2.new(1, -16, 0.5, -8), "X", Enum.FontSize.Size14, "CloseButton", dragBar)
	local closeEvent = New("BindableEvent", "CloseEvent", {
		Parent = closeButton
	})
	closeButton.MouseButton1Click:connect(function()
		closeEvent:Fire()
		closeButton.BackgroundTransparency = 1
	end)
	local helpButton = createMenuButton(UDim2.new(0, 15, 0, 17), UDim2.new(1, -51, 0.5, -8), "?", Enum.FontSize.Size14, "HelpButton", dragBar)
	local helpFrame, separatingLine, minimizeFrame, minimizeBigButton = dragBar.HelpFrame, dragBar.SeparatingLine, dragBar.MinimizeFrame, dragBar.MinimizeFrame.MinimizeBigButton
	helpButton.MouseButton1Click:connect(function()
		helpFrame.Visible = not helpFrame.Visible
		if helpFrame.Visible then
			helpButton.Selected = true
			helpButton.BackgroundTransparency = 0
			local screenGui = getScreenGuiAncestor(helpFrame)
			if screenGui then
				if helpFrame.AbsolutePosition.X + helpFrame.AbsoluteSize.X > screenGui.AbsoluteSize.X then
					helpFrame.Position = UDim2.new(0, -5 - helpFrame.AbsoluteSize.X, 0, 0)
				else
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
	local minimizeButton = createMenuButton(UDim2.new(0, 16, 0, 17), UDim2.new(1, -34, 0.5, -8), "-", Enum.FontSize.Size14, "MinimizeButton", dragBar)
	minimizeButton.TextYAlignment = Enum.TextYAlignment.Top
	do
		local _with_0 = separatingLine:clone()
		_with_0.Position = UDim2.new(1, -35, 0.5, -7)
		_with_0.Parent = dragBar
	end
	local widgetContainer = New("Frame", "WidgetContainer", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		BorderColor3 = Color3.new(0, 0, 0),
		New("TextButton", "VerticalDragger", {
			ZIndex = 2,
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(50 / 255, 50 / 255, 50 / 255),
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 20, 0, 20),
			Position = UDim2.new(0, 0, 1, 0),
			Active = true,
			Text = "",
			New("Frame", "ScrubFrame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, -5, 0.5, 0),
				Size = UDim2.new(0, 10, 0, 1),
				ZIndex = 5
			})
		})
	})
	local verticalDragger, scrubFrame = widgetContainer.VerticalDragger, widgetContainer.VerticalDragger.ScrubFrame
	if not scrollable then
		widgetContainer.BackgroundTransparency = 0
		widgetContainer.BackgroundColor3 = Color3.new(72 / 255, 72 / 255, 72 / 255)
	end
	widgetContainer.Parent = dragBar
	if size then
		if scrollable then
			widgetContainer.Size = size
		else
			widgetContainer.Size = UDim2.new(0, dragBar.AbsoluteSize.X, size.Y.Scale, size.Y.Offset)
		end
	else
		widgetContainer.Size = UDim2.new((function()
			if scrollable then
				return 0, 163, 0, 400
			else
				return 0, dragBar.AbsoluteSize.X, 0, 400
			end
		end)())
	end
	if position then
		widgetContainer.Position = position + UDim2.new(0, 0, 0, 20)
	end
	local frame, control
	if scrollable then
		frame, control = t.CreateTrueScrollingFrame()
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.new(72 / 255, 72 / 255, 72 / 255)
		frame.BorderColor3 = Color3.new(0, 0, 0)
		frame.Active = true
		frame.Parent = widgetContainer
		control.BackgroundColor3 = Color3.new(72 / 255, 72 / 255, 72 / 255)
		control.BorderSizePixel = 0
		control.BackgroundTransparency = 0
		control.Position = UDim2.new(1, -21, 1, 1)
		control.Size = UDim2.new(0, 21, (function()
			if size then
				return size.Y.Scale, size.Y.Offset
			else
				return 0, 400
			end
		end)())
		control:FindFirstChild("ScrollDownButton").Position = UDim2.new(0, 0, 1, -20)
		control.Parent = dragBar
		New("Frame", "FakeLine", {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(0, 1, 1, 1),
			Position = UDim2.new(1, 0, 0, 0),
			Parent = control
		})
		for _ = 1, 2 do
			do
				local _with_0 = scrubFrame:clone()
				_with_0.Position = UDim2.new(0.5, -5, 0.5, 2)
				_with_0.Parent = verticalDragger
			end
		end
		local areaSoak = New("TextButton", "AreaSoak", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			ZIndex = 10,
			Visible = false,
			Active = true,
			Parent = getScreenGuiAncestor(parent)
		})
		local draggingVertical = false
		local startYPos
		verticalDragger.MouseEnter:connect(function()
			verticalDragger.BackgroundColor3 = Color3.new(60 / 255, 60 / 255, 60 / 255)
		end)
		verticalDragger.MouseLeave:connect(function()
			verticalDragger.BackgroundColor3 = Color3.new(50 / 255, 50 / 255, 50 / 255)
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
				widgetContainer.Size = UDim2.new(widgetContainer.Size.X.Scale, widgetContainer.Size.X.Offset, widgetContainer.Size.Y.Scale, 150)
				control.Size = UDim2.new(0, 21, 0, 150)
				return
			end
			startYPos = y
			if widgetContainer.Size.Y.Offset + yDelta >= 0 then
				widgetContainer.Size = UDim2.new(widgetContainer.Size.X.Scale, widgetContainer.Size.X.Offset, widgetContainer.Size.Y.Scale, widgetContainer.Size.Y.Offset + yDelta)
				control.Size = UDim2.new(0, 21, 0, control.Size.Y.Offset + yDelta)
			end
		end)
	end
	local switchMinimize
	switchMinimize = function()
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
	minimizeBigButton.MouseButton1Click:connect(switchMinimize)
	minimizeButton.MouseButton1Click:connect(switchMinimize)
	return dragBar, (function()
		if scrollable then
			return frame, helpFrame, closeEvent
		else
			return widgetContainer, helpFrame, closeEvent
		end
	end)()
end
t.Help = function(funcNameOrFunc)
	if 'CreatePropertyDropDownMenu' == funcNameOrFunc or t.CreatePropertyDropDownMenu == funcNameOrFunc then
		return 'Function CreatePropertyDropDownMenu.  ' .. 'Arguments: (instance, propertyName, enumType).  ' .. 'Side effect: returns a container with a drop-down-box that is linked to the "property" field of "instance" which is of type "enumType"'
	elseif 'CreateDropDownMenu' == funcNameOrFunc or t.CreateDropDownMenu == funcNameOrFunc then
		return 'Function CreateDropDownMenu.  ' .. 'Arguments: (items, onItemSelected).  ' .. 'Side effect: Returns 2 results, a container to the gui object and a "updateSelection" function for external updating.  The container is a drop-down-box created around a list of items'
	elseif 'CreateMessageDialog' == funcNameOrFunc or t.CreateMessageDialog == funcNameOrFunc then
		return 'Function CreateMessageDialog.  ' .. 'Arguments: (title, message, buttons). ' .. 'Side effect: Returns a gui object of a message box with "title" and "message" as passed in.  "buttons" input is an array of Tables contains a "Text" and "Function" field for the text/callback of each button'
	elseif 'CreateStyledMessageDialog' == funcNameOrFunc or t.CreateStyledMessageDialog == funcNameOrFunc then
		return 'Function CreateStyledMessageDialog.  ' .. 'Arguments: (title, message, style, buttons). ' .. 'Side effect: Returns a gui object of a message box with "title" and "message" as passed in.  "buttons" input is an array of Tables contains a "Text" and "Function" field for the text/callback of each button, "style" is a string, either Error, Notify or Confirm'
	elseif 'GetFontHeight' == funcNameOrFunc or t.GetFontHeight == funcNameOrFunc then
		return 'Function GetFontHeight.  ' .. 'Arguments: (font, fontSize). ' .. 'Side effect: returns the size in pixels of the given font + fontSize'
	elseif 'CreateScrollingFrame' == funcNameOrFunc or t.CreateScrollingFrame == funcNameOrFunc then
		return 'Function CreateScrollingFrame.  ' .. 'Arguments: (orderList, style) ' .. 'Side effect: returns 4 objects, (scrollFrame, scrollUpButton, scrollDownButton, recalculateFunction).  "scrollFrame" can be filled with GuiObjects.  It will lay them out and allow scrollUpButton/scrollDownButton to interact with them.  Orderlist is optional (and specifies the order to layout the children.  Without orderlist, it uses the children order. style is also optional, and allows for a "grid" styling if style is passed "grid" as a string.  recalculateFunction can be called\n			when a relayout is needed (\n				when orderList changes)'
	elseif 'CreateTrueScrollingFrame' == funcNameOrFunc or t.CreateTrueScrollingFrame == funcNameOrFunc then
		return 'Function CreateTrueScrollingFrame.  ' .. 'Arguments: (nil) ' .. 'Side effect: returns 2 objects, (scrollFrame, controlFrame).  "scrollFrame" can be filled with GuiObjects, and they will be clipped if not inside the frame"s bounds. controlFrame has children scrollup and scrolldown, as well as a slider.  controlFrame can be parented to any guiobject and it will readjust itself to fit.'
	elseif 'AutoTruncateTextObject' == funcNameOrFunc or t.AutoTruncateTextObject == funcNameOrFunc then
		return 'Function AutoTruncateTextObject.  ' .. 'Arguments: (textLabel) ' .. 'Side effect: returns 2 objects, (textLabel, changeText).  The "textLabel" input is modified to automatically truncate text (with ellipsis), if it gets too small to fit.  "changeText" is a function that can be used to change the text, it takes 1 string as an argument'
	elseif 'CreateSlider' == funcNameOrFunc or t.CreateSlider == funcNameOrFunc then
		return 'Function CreateSlider.  ' .. 'Arguments: (steps, width, position) ' .. 'Side effect: returns 2 objects, (sliderGui, sliderPosition).  The "steps" argument specifies how many different positions the slider can hold along the bar.  "width" specifies in pixels how wide the bar should be (modifiable afterwards if desired). "position" argument should be a UDim2 for slider positioning. "sliderPosition" is an IntValue whose current .Value specifies the specific step the slider is currently on.'
	elseif 'CreateLoadingFrame' == funcNameOrFunc or t.CreateLoadingFrame == funcNameOrFunc then
		return 'Function CreateLoadingFrame.  ' .. 'Arguments: (name, size, position) ' .. 'Side effect: Creates a gui that can be manipulated to show progress for a particular action.  Name appears above the loading bar, and size and position are udim2 values (both size and position are optional arguments).  Returns 3 arguments, the first being the gui created. The second being updateLoadingGuiPercent, which is a bindable function.  This function takes one argument (two optionally), which should be a number between 0 and 1, representing the percentage the loading gui should be at.  The second argument to this function is a boolean value that if set to true will tween the current percentage value to the new percentage value, therefore our third argument is how long this tween should take. Our third returned argument is a BindableEvent, that\n			when fired means that someone clicked the cancel button on the dialog.'
	elseif 'CreateTerrainMaterialSelector' == funcNameOrFunc or t.CreateTerrainMaterialSelector == funcNameOrFunc then
		return 'Function CreateTerrainMaterialSelector.  ' .. 'Arguments: (size, position) ' .. 'Side effect: Size and position are UDim2 values that specifies the selector"s size and position.  Both size and position are optional arguments. This method returns 3 objects (terrainSelectorGui, terrainSelected, forceTerrainSelection).  terrainSelectorGui is just the gui object that we generate with this function, parent it as you like. TerrainSelected is a BindableEvent that is fired whenever a new terrain type is selected in the gui.  ForceTerrainSelection is a function that takes an argument of Enum.CellMaterial and will force the gui to show that material as currently selected.'
	end
end
