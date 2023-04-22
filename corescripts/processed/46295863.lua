print("[Mercury]: Loaded corescript 46295863")
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
local waitForChild
waitForChild = function(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end
local waitForProperty
waitForProperty = function(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end
local gui
if script.Parent:FindFirstChild("ControlFrame") then
	gui = script.Parent:FindFirstChild("ControlFrame")
else
	gui = script.Parent
end
local syncVideoCaptureSetting
local settingsButton, helpButton, settingsFrame, mouseLockLabel
local updateCameraDropDownSelection
local updateVideoCaptureDropDownSelection
local tweenTime = 0.2
local mouseLockLookScreenUrl = "http://www.roblox.com/asset?id=54071825"
local classicLookScreenUrl = "http://www.roblox.com/Asset?id=45915798"
local hasGraphicsSlider = game:GetService("CoreGui").Version >= 5
local GraphicsQualityLevels = 10
local recordingVideo = false
local currentMenuSelection
local lastMenuSelection = { }
local centerDialogs = { }
local mainShield
local inStudioMode = UserSettings().GameSettings:InStudioMode()
local macClient = false
local success, isMac = pcall(function()
	return not game.GuiService.IsWindows
end)
macClient = success and isMac
local Color3I
Color3I = function(r, g, b)
	return Color3.new(r / 255, g / 255, b / 255)
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
local resumeGameFunction
resumeGameFunction = function(shield)
	shield.Settings:TweenPosition(UDim2.new(0.5, -262, -0.5, -200), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
	return delay(tweenTime, function()
		shield.Visible = false
		for i = 1, #centerDialogs do
			centerDialogs[i].Visible = false
			game.GuiService:RemoveCenterDialog(centerDialogs[i])
		end
		game.GuiService:RemoveCenterDialog(shield)
		settingsButton.Active = true
		currentMenuSelection = nil
		lastMenuSelection = { }
	end)
end
local goToMenu
goToMenu = function(container, menuName, moveDirection, size, position)
	if type(menuName) ~= "string" then
		return
	end
	table.insert(lastMenuSelection, currentMenuSelection)
	if menuName == "GameMainMenu" then
		lastMenuSelection = { }
	end
	local containerChildren = container:GetChildren()
	for i = 1, #containerChildren do
		if containerChildren[i].Name == menuName then
			containerChildren[i].Visible = true
			currentMenuSelection = {
				container = container,
				name = menuName,
				direction = moveDirection,
				lastSize = size
			}
			if size and position then
				containerChildren[i]:TweenSizeAndPosition(size, position, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
			elseif size then
				containerChildren[i]:TweenSizeAndPosition(size, UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
			else
				containerChildren[i]:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
			end
		else
			if moveDirection == "left" then
				containerChildren[i]:TweenPosition(UDim2.new(-1, -525, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
			elseif moveDirection == "right" then
				containerChildren[i]:TweenPosition(UDim2.new(1, 525, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
			elseif moveDirection == "up" then
				containerChildren[i]:TweenPosition(UDim2.new(0, 0, -1, -400), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
			elseif moveDirection == "down" then
				containerChildren[i]:TweenPosition(UDim2.new(0, 0, 1, 400), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
			end
			delay(tweenTime, function()
				containerChildren[i].Visible = false
			end)
		end
	end
end
local resetLocalCharacter
resetLocalCharacter = function()
	local player = game.Players.LocalPlayer
	if player then
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.Health = 0
		end
	end
end
local createTextButton
createTextButton = function(text, style, fontSize, buttonSize, buttonPosition)
	return New("TextButton", {
		Font = Enum.Font.Arial,
		FontSize = fontSize,
		Size = buttonSize,
		Position = buttonPosition,
		Style = style,
		TextColor3 = Color3.new(1, 1, 1),
		Text = text
	})
end
local CreateTextButtons
CreateTextButtons = function(frame, buttons, yPos, ySize)
	if #buttons < 1 then
		error("Must have more than one button")
	end
	local buttonNum = 1
	local buttonObjs = { }
	local toggleSelection
	toggleSelection = function(button)
		for _, obj in ipairs(buttonObjs) do
			if obj == button then
				obj.Style = Enum.ButtonStyle.RobloxButtonDefault
			else
				obj.Style = Enum.ButtonStyle.RobloxButton
			end
		end
	end
	for _, obj in ipairs(buttons) do
		local button = New("TextButton", "Button" .. tostring(buttonNum), {
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			AutoButtonColor = true,
			Style = Enum.ButtonStyle.RobloxButton,
			Text = obj.Text,
			TextColor3 = Color3.new(1, 1, 1)
		})
		button.MouseButton1Click:connect(function()
			toggleSelection(button)
			return obj.Function()
		end)
		button.Parent = frame
		buttonObjs[buttonNum] = button
		buttonNum = buttonNum + 1
	end
	toggleSelection(buttonObjs[1])
	local numButtons = buttonNum - 1
	if numButtons == 1 then
		frame.Button1.Position = UDim2.new(0.35, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(0.4, 0, ySize.Scale, ySize.Offset)
	elseif numButtons == 2 then
		frame.Button1.Position = UDim2.new(0.1, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(0.35, 0, ySize.Scale, ySize.Offset)
		frame.Button2.Position = UDim2.new(0.55, 0, yPos.Scale, yPos.Offset)
		frame.Button2.Size = UDim2.new(0.35, 0, ySize.Scale, ySize.Offset)
	elseif numButtons >= 3 then
		local spacing = 0.1 / numButtons
		local buttonSize = 0.9 / numButtons
		buttonNum = 1
		while buttonNum <= numButtons do
			buttonObjs[buttonNum].Position = UDim2.new(spacing * buttonNum + (buttonNum - 1) * buttonSize, 0, yPos.Scale, yPos.Offset)
			buttonObjs[buttonNum].Size = UDim2.new(buttonSize, 0, ySize.Scale, ySize.Offset)
			buttonNum = buttonNum + 1
		end
	end
end
local setRecordGui
setRecordGui = function(recording, stopRecordButton, recordVideoButton)
	if recording then
		stopRecordButton.Visible = true
		recordVideoButton.Text = "Stop Recording"
	else
		stopRecordButton.Visible = false
		recordVideoButton.Text = "Record Video"
	end
end
local recordVideoClick
recordVideoClick = function(recordVideoButton, stopRecordButton)
	recordingVideo = not recordingVideo
	return setRecordGui(recordingVideo, stopRecordButton, recordVideoButton)
end
local backToGame
backToGame = function(buttonClicked, shield, settingsButton)
	buttonClicked.Parent.Parent.Parent.Parent.Visible = false
	shield.Visible = false
	for i = 1, #centerDialogs do
		game.GuiService:RemoveCenterDialog(centerDialogs[i])
		centerDialogs[i].Visible = false
	end
	centerDialogs = { }
	game.GuiService:RemoveCenterDialog(shield)
	settingsButton.Active = true
end
local setDisabledState
setDisabledState = function(guiObject)
	if not guiObject then
		return
	end
	if guiObject:IsA("TextLabel") then
		guiObject.TextTransparency = 0.9
	elseif guiObject:IsA("TextButton") then
		guiObject.TextTransparency = 0.9
		guiObject.Active = false
	else
		if guiObject["ClassName"] then
			return print("setDisabledState() got object of unsupported type.  object type is ", guiObject.ClassName)
		end
	end
end
local createHelpDialog
createHelpDialog = function(baseZIndex)
	if not (helpButton ~= nil) then
		if gui:FindFirstChild("TopLeftControl" and gui.TopLeftControl:FindFirstChild("Help")) then
			helpButton = gui.TopLeftControl.Help
		elseif gui:FindFirstChild("BottomRightControl" and gui.BottomRightControl:FindFirstChild("Help")) then
			helpButton = gui.BottomRightControl.Help
		end
	end
	local shield = New("Frame", "HelpDialogShield", {
		Active = true,
		Visible = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3I(51, 51, 51),
		BorderColor3 = Color3I(27, 42, 53),
		BackgroundTransparency = 0.4,
		ZIndex = baseZIndex + 1
	})
	local helpDialog = New("Frame", "HelpDialog", {
		Style = Enum.FrameStyle.RobloxRound,
		Position = UDim2.new(0.2, 0, 0.2, 0),
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Active = true,
		Parent = shield,
		New("TextLabel", "Title", {
			Text = "Keyboard & Mouse Controls",
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			Position = UDim2.new(0, 0, 0.025, 0),
			Size = UDim2.new(1, 0, 0, 40),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1
		})
	})
	local buttonRow = New("Frame", "Buttons", {
		Position = UDim2.new(0.1, 0, 0.07, 40),
		Size = UDim2.new(0.8, 0, 0, 45),
		BackgroundTransparency = 1,
		Parent = helpDialog
	})
	local imageFrame = New("Frame", "ImageFrame", {
		Position = UDim2.new(0.05, 0, 0.075, 80),
		Size = UDim2.new(0.9, 0, 0.9, -120),
		BackgroundTransparency = 1,
		Parent = helpDialog
	})
	local layoutFrame = New("Frame", "LayoutFrame", {
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1.5, 0, 1, 0),
		BackgroundTransparency = 1,
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Parent = imageFrame
	})
	local image = New("ImageLabel", "Image")
	if UserSettings().GameSettings.ControlMode == Enum.ControlMode["Mouse Lock Switch"] then
		image.Image = mouseLockLookScreenUrl
	else
		image.Image = classicLookScreenUrl
	end
	image.Position = UDim2.new(-0.5, 0, 0, 0)
	image.Size = UDim2.new(1, 0, 1, 0)
	image.BackgroundTransparency = 1
	image.Parent = layoutFrame
	local buttons = { }
	buttons[1] = { }
	buttons[1].Text = "Look"
	buttons[1].Function = function()
		if UserSettings().GameSettings.ControlMode == Enum.ControlMode["Mouse Lock Switch"] then
			image.Image = mouseLockLookScreenUrl
		else
			image.Image = classicLookScreenUrl
		end
	end
	buttons[2] = { }
	buttons[2].Text = "Move"
	buttons[2].Function = function()
		image.Image = "http://www.roblox.com/Asset?id=45915811"
	end
	buttons[3] = { }
	buttons[3].Text = "Gear"
	buttons[3].Function = function()
		image.Image = "http://www.roblox.com/Asset?id=45917596"
	end
	buttons[4] = { }
	buttons[4].Text = "Zoom"
	buttons[4].Function = function()
		image.Image = "http://www.roblox.com/Asset?id=45915825"
	end
	CreateTextButtons(buttonRow, buttons, UDim.new(0, 0), UDim.new(1, 0))
	delay(0, function()
		waitForChild(gui, "UserSettingsShield")
		waitForChild(gui.UserSettingsShield, "Settings")
		waitForChild(gui.UserSettingsShield.Settings, "SettingsStyle")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle, "GameSettingsMenu")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu, "CameraField")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField, "DropDownMenuButton")
		return gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Changed:connect(function(prop)
			if prop ~= "Text" then
				return
			end
			if buttonRow.Button1.Style == Enum.ButtonStyle.RobloxButtonDefault then
				if gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Text == "Classic" then
					image.Image = classicLookScreenUrl
				else
					image.Image = mouseLockLookScreenUrl
				end
			end
		end)
	end)
	local okBtn = New("TextButton", "OkBtn", {
		Text = "OK",
		Modal = true,
		Size = UDim2.new(0.3, 0, 0, 45),
		Position = UDim2.new(0.35, 0, 0.975, -50),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Style = Enum.ButtonStyle.RobloxButtonDefault,
		Parent = helpDialog
	})
	okBtn.MouseButton1Click:connect(function()
		shield.Visible = false
		return game.GuiService:RemoveCenterDialog(shield)
	end)
	robloxLock(shield)
	return shield
end
local createLeaveConfirmationMenu
createLeaveConfirmationMenu = function(baseZIndex, shield)
	local frame = New("Frame", "LeaveConfirmationMenu", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 2, 400),
		ZIndex = baseZIndex + 4,
		New("TextLabel", "LeaveText", {
			Text = "Leave this game?",
			Size = UDim2.new(1, 0, 0.8, 0),
			TextWrap = true,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			BackgroundTransparency = 1,
			ZIndex = baseZIndex + 4
		})
	})
	do
		local _with_0 = createTextButton("Leave", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size24, UDim2.new(0, 128, 0, 50), UDim2.new(0, 313, 0.8, 0))
		_with_0.Name = "YesButton"
		_with_0.ZIndex = baseZIndex + 4
		_with_0.Parent = frame
		_with_0.Modal = true
		_with_0:SetVerb("Exit")
	end
	do
		local _with_0 = createTextButton("Stay", Enum.ButtonStyle.RobloxButtonDefault, Enum.FontSize.Size24, UDim2.new(0, 128, 0, 50), UDim2.new(0, 90, 0.8, 0))
		_with_0.Name = "NoButton"
		_with_0.Parent = frame
		_with_0.ZIndex = baseZIndex + 4
		_with_0.MouseButton1Click:connect(function()
			goToMenu(shield.Settings.SettingsStyle, "GameMainMenu", "down", UDim2.new(0, 525, 0, 430))
			return shield.Settings:TweenSize(UDim2.new(0, 525, 0, 430), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
		end)
	end
	return frame
end
local createResetConfirmationMenu
createResetConfirmationMenu = function(baseZIndex, shield)
	local frame = New("Frame", "ResetConfirmationMenu", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 2, 400),
		ZIndex = baseZIndex + 4
	})
	do
		local _with_0 = createTextButton("Reset", Enum.ButtonStyle.RobloxButtonDefault, Enum.FontSize.Size24, UDim2.new(0, 128, 0, 50), UDim2.new(0, 313, 0, 299))
		_with_0.Name = "YesButton"
		_with_0.ZIndex = baseZIndex + 4
		_with_0.Parent = frame
		_with_0.Modal = true
		_with_0.MouseButton1Click:connect(function()
			resumeGameFunction(shield)
			return resetLocalCharacter()
		end)
	end
	do
		local _with_0 = createTextButton("Cancel", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size24, UDim2.new(0, 128, 0, 50), UDim2.new(0, 90, 0, 299))
		_with_0.Name = "NoButton"
		_with_0.Parent = frame
		_with_0.ZIndex = baseZIndex + 4
		_with_0.MouseButton1Click:connect(function()
			goToMenu(shield.Settings.SettingsStyle, "GameMainMenu", "down", UDim2.new(0, 525, 0, 430))
			return shield.Settings:TweenSize(UDim2.new(0, 525, 0, 430), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
		end)
	end
	local resetCharacterText = New("TextLabel", "ResetCharacterText", {
		Text = "Are you sure you want to reset your character?",
		Size = UDim2.new(1, 0, 0.8, 0),
		TextWrap = true,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size36,
		BackgroundTransparency = 1,
		ZIndex = baseZIndex + 4,
		Parent = frame
	})
	do
		local _with_0 = resetCharacterText:Clone()
		_with_0.Name = "FineResetCharacterText"
		_with_0.Text = "You will be put back on a spawn point"
		_with_0.Size = UDim2.new(0, 303, 0, 18)
		_with_0.Position = UDim2.new(0, 109, 0, 215)
		_with_0.FontSize = Enum.FontSize.Size18
		_with_0.Parent = frame
	end
	return frame
end
local createGameMainMenu
createGameMainMenu = function(baseZIndex, shield)
	local gameMainMenuFrame = New("Frame", "GameMainMenu", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = baseZIndex + 4,
		Parent = settingsFrame,
		New("TextLabel", "Title", {
			Text = "Game Menu",
			BackgroundTransparency = 1,
			TextStrokeTransparency = 0,
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			Size = UDim2.new(1, 0, 0, 36),
			Position = UDim2.new(0, 0, 0, 4),
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = baseZIndex + 4
		})
	})
	local robloxHelpButton = createTextButton("Help", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size18, UDim2.new(0, 164, 0, 50), UDim2.new(0, 82, 0, 256))
	robloxHelpButton.Name = "HelpButton"
	robloxHelpButton.ZIndex = baseZIndex + 4
	robloxHelpButton.Parent = gameMainMenuFrame
	helpButton = robloxHelpButton
	local helpDialog = createHelpDialog(baseZIndex)
	helpDialog.Parent = gui
	helpButton.MouseButton1Click:connect(function()
		table.insert(centerDialogs, helpDialog)
		return game.GuiService:AddCenterDialog(helpDialog, Enum.CenterDialogType.ModalDialog, function()
			helpDialog.Visible = true
			mainShield.Visible = false
		end, function()
			helpDialog.Visible = false
		end)
	end)
	helpButton.Active = true
	local helpShortcut = New("TextLabel", "HelpShortcutText", {
		Text = "F1",
		Visible = false,
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size12,
		Position = UDim2.new(0, 85, 0, 0),
		Size = UDim2.new(0, 30, 0, 30),
		TextColor3 = Color3.new(0, 1, 0),
		ZIndex = baseZIndex + 4,
		Parent = robloxHelpButton
	})
	local screenshotButton = createTextButton("Screenshot", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size18, UDim2.new(0, 168, 0, 50), UDim2.new(0, 254, 0, 256))
	screenshotButton.Name = "ScreenshotButton"
	screenshotButton.ZIndex = baseZIndex + 4
	screenshotButton.Parent = gameMainMenuFrame
	screenshotButton.Visible = not macClient
	screenshotButton:SetVerb("Screenshot")
	do
		local _with_0 = helpShortcut:clone()
		_with_0.Name = "ScreenshotShortcutText"
		_with_0.Text = "PrintSc"
		_with_0.Position = UDim2.new(0, 118, 0, 0)
		_with_0.Visible = true
		_with_0.Parent = screenshotButton
	end
	local recordVideoButton = createTextButton("Record Video", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size18, UDim2.new(0, 168, 0, 50), UDim2.new(0, 254, 0, 306))
	recordVideoButton.Name = "RecordVideoButton"
	recordVideoButton.ZIndex = baseZIndex + 4
	recordVideoButton.Parent = gameMainMenuFrame
	recordVideoButton.Visible = not macClient
	recordVideoButton:SetVerb("RecordToggle")
	do
		local _with_0 = helpShortcut:clone()
		_with_0.Name = "RecordVideoShortcutText"
		_with_0.Visible = hasGraphicsSlider
		_with_0.Text = "F12"
		_with_0.Position = UDim2.new(0, 120, 0, 0)
		_with_0.Parent = recordVideoButton
	end
	local stopRecordButton = New("ImageButton", "StopRecordButton", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/RecordStop.png",
		Size = UDim2.new(0, 59, 0, 27)
	})
	stopRecordButton:SetVerb("RecordToggle")
	stopRecordButton.MouseButton1Click:connect(function()
		return recordVideoClick(recordVideoButton, stopRecordButton)
	end)
	stopRecordButton.Visible = false
	stopRecordButton.Parent = gui
	local reportAbuseButton = createTextButton("Report Abuse", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size18, UDim2.new(0, 164, 0, 50), UDim2.new(0, 82, 0, 306))
	reportAbuseButton.Name = "ReportAbuseButton"
	reportAbuseButton.ZIndex = baseZIndex + 4
	reportAbuseButton.Parent = gameMainMenuFrame
	do
		local _with_0 = createTextButton("Leave Game", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size24, UDim2.new(0, 340, 0, 50), UDim2.new(0, 82, 0, 358))
		_with_0.Name = "LeaveGameButton"
		_with_0.ZIndex = baseZIndex + 4
		_with_0.Parent = gameMainMenuFrame
	end
	do
		local _with_0 = createTextButton("Resume Game", Enum.ButtonStyle.RobloxButtonDefault, Enum.FontSize.Size24, UDim2.new(0, 340, 0, 50), UDim2.new(0, 82, 0, 54))
		_with_0.Name = "resumeGameButton"
		_with_0.ZIndex = baseZIndex + 4
		_with_0.Parent = gameMainMenuFrame
		_with_0.Modal = true
		_with_0.MouseButton1Click:connect(function()
			return resumeGameFunction(shield)
		end)
	end
	local gameSettingsButton = createTextButton("Game Settings", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size24, UDim2.new(0, 340, 0, 50), UDim2.new(0, 82, 0, 156))
	gameSettingsButton.Name = "SettingsButton"
	gameSettingsButton.ZIndex = baseZIndex + 4
	gameSettingsButton.Parent = gameMainMenuFrame
	if game:FindFirstChild("LoadingGuiService" and #game.LoadingGuiService:GetChildren() > 0) then
		gameSettingsButton = createTextButton("Game Instructions", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size24, UDim2.new(0, 340, 0, 50), UDim2.new(0, 82, 0, 207))
		gameSettingsButton.Name = "GameInstructions"
		gameSettingsButton.ZIndex = baseZIndex + 4
		gameSettingsButton.Parent = gameMainMenuFrame
		gameSettingsButton.MouseButton1Click:connect(function()
			if game:FindFirstChild("Players" and game.Players["LocalPlayer"]) then
				local loadingGui = game.Players.LocalPlayer:FindFirstChild("PlayerLoadingGui")
				if loadingGui then
					loadingGui.Visible = true
				end
			end
		end)
	end
	local resetButton = createTextButton("Reset Character", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size24, UDim2.new(0, 340, 0, 50), UDim2.new(0, 82, 0, 105))
	resetButton.Name = "ResetButton"
	resetButton.ZIndex = baseZIndex + 4
	resetButton.Parent = gameMainMenuFrame
	return gameMainMenuFrame
end
local createGameSettingsMenu
createGameSettingsMenu = function(baseZIndex, _)
	local gameSettingsMenuFrame = New("Frame", "GameSettingsMenu", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = baseZIndex + 4,
		New("TextLabel", "Title", {
			Text = "Settings",
			Size = UDim2.new(1, 0, 0, 48),
			Position = UDim2.new(0, 9, 0, -9),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = baseZIndex + 4,
			BackgroundTransparency = 1
		}),
		New("TextLabel", "FullscreenText", {
			Text = "Fullscreen Mode",
			Size = UDim2.new(0, 124, 0, 18),
			Position = UDim2.new(0, 62, 0, 145),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = baseZIndex + 4,
			BackgroundTransparency = 1
		})
	})
	local fullscreenShortcut = New("TextLabel", "FullscreenShortcutText", {
		Visible = hasGraphicsSlider,
		Text = "F11",
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size12,
		Position = UDim2.new(0, 186, 0, 141),
		Size = UDim2.new(0, 30, 0, 30),
		TextColor3 = Color3.new(0, 1, 0),
		ZIndex = baseZIndex + 4,
		Parent = gameSettingsMenuFrame
	})
	local studioText = New("TextLabel", "StudioText", {
		Visible = false,
		Text = "Studio Mode",
		Size = UDim2.new(0, 95, 0, 18),
		Position = UDim2.new(0, 62, 0, 179),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		TextColor3 = Color3.new(1, 1, 1),
		ZIndex = baseZIndex + 4,
		BackgroundTransparency = 1,
		Parent = gameSettingsMenuFrame
	})
	local studioShortcut = fullscreenShortcut:clone()
	studioShortcut.Name = "StudioShortcutText"
	studioShortcut.Visible = false
	studioShortcut.Text = "F2"
	studioShortcut.Position = UDim2.new(0, 154, 0, 175)
	studioShortcut.Parent = gameSettingsMenuFrame
	local studioCheckbox
	if hasGraphicsSlider then
		local qualityText = New("TextLabel", "QualityText", {
			Text = "Graphics Quality",
			Size = UDim2.new(0, 128, 0, 18),
			Position = UDim2.new(0, 30, 0, 239),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = baseZIndex + 4,
			BackgroundTransparency = 1,
			Parent = gameSettingsMenuFrame,
			Visible = not inStudioMode
		})
		local autoText = qualityText:clone()
		autoText.Name = "AutoText"
		autoText.Text = "Auto"
		autoText.Position = UDim2.new(0, 183, 0, 214)
		autoText.TextColor3 = Color3.new(0.5, 0.5, 0.5)
		autoText.Size = UDim2.new(0, 34, 0, 18)
		autoText.Parent = gameSettingsMenuFrame
		autoText.Visible = not inStudioMode
		local fasterText = autoText:clone()
		fasterText.Name = "FasterText"
		fasterText.Text = "Faster"
		fasterText.Position = UDim2.new(0, 185, 0, 274)
		fasterText.TextColor3 = Color3.new(95, 95, 95)
		fasterText.FontSize = Enum.FontSize.Size14
		fasterText.Parent = gameSettingsMenuFrame
		fasterText.Visible = not inStudioMode
		local fasterShortcut = fullscreenShortcut:clone()
		fasterShortcut.Name = "FasterShortcutText"
		fasterShortcut.Text = "F10 + Shift"
		fasterShortcut.Position = UDim2.new(0, 185, 0, 283)
		fasterShortcut.Parent = gameSettingsMenuFrame
		fasterShortcut.Visible = not inStudioMode
		local betterQualityText = autoText:clone()
		betterQualityText.Name = "BetterQualityText"
		betterQualityText.Text = "Better Quality"
		betterQualityText.TextWrap = true
		betterQualityText.Size = UDim2.new(0, 41, 0, 28)
		betterQualityText.Position = UDim2.new(0, 390, 0, 269)
		betterQualityText.TextColor3 = Color3.new(95, 95, 95)
		betterQualityText.FontSize = Enum.FontSize.Size14
		betterQualityText.Parent = gameSettingsMenuFrame
		betterQualityText.Visible = not inStudioMode
		local betterQualityShortcut = fullscreenShortcut:clone()({
			Name = "BetterQualityShortcut",
			Text = "F10",
			Position = UDim2.new(0, 394, 0, 288),
			Parent = gameSettingsMenuFrame,
			Visible = not inStudioMode
		})
		local autoGraphicsButton = createTextButton("X", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size18, UDim2.new(0, 25, 0, 25), UDim2.new(0, 187, 0, 239))
		autoGraphicsButton.Name = "AutoGraphicsButton"
		autoGraphicsButton.ZIndex = baseZIndex + 4
		autoGraphicsButton.Parent = gameSettingsMenuFrame
		autoGraphicsButton.Visible = not inStudioMode
		local graphicsSlider, graphicsLevel
		graphicsSlider, graphicsLevel = RbxGui.CreateSlider(GraphicsQualityLevels, 150, UDim2.new(0, 230, 0, 280))
		graphicsSlider.Parent = gameSettingsMenuFrame
		graphicsSlider.Bar.ZIndex = baseZIndex + 4
		graphicsSlider.Bar.Slider.ZIndex = baseZIndex + 5
		graphicsSlider.Visible = not inStudioMode
		graphicsLevel.Value = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) / 2)
		local graphicsSetter = New("TextBox", "GraphicsSetter", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderColor3 = Color3.new(0.5, 0.5, 0.5),
			Size = UDim2.new(0, 50, 0, 25),
			Position = UDim2.new(0, 450, 0, 269),
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Text = "Auto",
			ZIndex = 1,
			TextWrap = true,
			Parent = gameSettingsMenuFrame,
			Visible = not inStudioMode
		})
		local isAutoGraphics = true
		if not inStudioMode then
			isAutoGraphics = UserSettings().GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic
		else
			settings().Rendering.EnableFRM = false
		end
		local listenToGraphicsLevelChange = true
		local setAutoGraphicsGui
		setAutoGraphicsGui = function(active)
			isAutoGraphics = active
			if active then
				autoGraphicsButton.Text = "X"
				betterQualityText.ZIndex = 1
				betterQualityShortcut.ZIndex = 1
				fasterShortcut.ZIndex = 1
				fasterText.ZIndex = 1
				graphicsSlider.Bar.ZIndex = 1
				graphicsSlider.Bar.Slider.ZIndex = 1
				graphicsSetter.ZIndex = 1
				graphicsSetter.Text = "Auto"
			else
				autoGraphicsButton.Text = ""
				graphicsSlider.Bar.ZIndex = baseZIndex + 4
				graphicsSlider.Bar.Slider.ZIndex = baseZIndex + 5
				betterQualityShortcut.ZIndex = baseZIndex + 4
				fasterShortcut.ZIndex = baseZIndex + 4
				betterQualityText.ZIndex = baseZIndex + 4
				fasterText.ZIndex = baseZIndex + 4
				graphicsSetter.ZIndex = baseZIndex + 4
			end
		end
		local goToAutoGraphics
		goToAutoGraphics = function()
			setAutoGraphicsGui(true)
			UserSettings().GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		end
		local setGraphicsQualityLevel
		setGraphicsQualityLevel = function(newLevel)
			local percentage = newLevel / GraphicsQualityLevels
			local newSetting = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) * percentage)
			if newSetting == 20 then
				newSetting = 21
			elseif newLevel == 1 then
				newSetting = 1
			elseif newSetting > settings().Rendering:GetMaxQualityLevel() then
				newSetting = settings().Rendering:GetMaxQualityLevel() - 1
			end
			UserSettings().GameSettings.SavedQualityLevel = newLevel
			settings().Rendering.QualityLevel = newSetting
		end
		local goToManualGraphics
		goToManualGraphics = function(explicitLevel)
			setAutoGraphicsGui(false)
			if explicitLevel then
				graphicsLevel.Value = explicitLevel
			else
				graphicsLevel.Value = math.floor((settings().Rendering.AutoFRMLevel / (settings().Rendering:GetMaxQualityLevel() - 1))({
					GraphicsQualityLevels
				}))
			end
			if explicitLevel == graphicsLevel.Value then
				setGraphicsQualityLevel(graphicsLevel.Value)
			end
			if not explicitLevel then
				UserSettings().GameSettings.SavedQualityLevel = graphicsLevel.Value
			end
			graphicsSetter.Text = tostring(graphicsLevel.Value)
		end
		local showAutoGraphics
		showAutoGraphics = function()
			autoText.ZIndex = baseZIndex + 4
			autoGraphicsButton.ZIndex = baseZIndex + 4
		end
		local hideAutoGraphics
		hideAutoGraphics = function()
			autoText.ZIndex = 1
			autoGraphicsButton.ZIndex = 1
		end
		local showManualGraphics
		showManualGraphics = function()
			graphicsSlider.Bar.ZIndex = baseZIndex + 4
			graphicsSlider.Bar.Slider.ZIndex = baseZIndex + 5
			betterQualityShortcut.ZIndex = baseZIndex + 4
			fasterShortcut.ZIndex = baseZIndex + 4
			betterQualityText.ZIndex = baseZIndex + 4
			fasterText.ZIndex = baseZIndex + 4
			graphicsSetter.ZIndex = baseZIndex + 4
		end
		local hideManualGraphics
		hideManualGraphics = function()
			betterQualityText.ZIndex = 1
			betterQualityShortcut.ZIndex = 1
			fasterShortcut.ZIndex = 1
			fasterText.ZIndex = 1
			graphicsSlider.Bar.ZIndex = 1
			graphicsSlider.Bar.Slider.ZIndex = 1
			graphicsSetter.ZIndex = 1
		end
		local translateSavedQualityLevelToInt
		translateSavedQualityLevelToInt = function(savedQualityLevel)
			if Enum.SavedQualitySetting.Automatic == savedQualityLevel then
				return 0
			elseif Enum.SavedQualitySetting.QualityLevel1 == savedQualityLevel then
				return 1
			elseif Enum.SavedQualitySetting.QualityLevel2 == savedQualityLevel then
				return 2
			elseif Enum.SavedQualitySetting.QualityLevel3 == savedQualityLevel then
				return 3
			elseif Enum.SavedQualitySetting.QualityLevel4 == savedQualityLevel then
				return 4
			elseif Enum.SavedQualitySetting.QualityLevel5 == savedQualityLevel then
				return 5
			elseif Enum.SavedQualitySetting.QualityLevel6 == savedQualityLevel then
				return 6
			elseif Enum.SavedQualitySetting.QualityLevel7 == savedQualityLevel then
				return 7
			elseif Enum.SavedQualitySetting.QualityLevel8 == savedQualityLevel then
				return 8
			elseif Enum.SavedQualitySetting.QualityLevel9 == savedQualityLevel then
				return 9
			elseif Enum.SavedQualitySetting.QualityLevel10 == savedQualityLevel then
				return 10
			end
		end
		local enableGraphicsWidget
		enableGraphicsWidget = function()
			settings().Rendering.EnableFRM = true
			isAutoGraphics = (UserSettings().GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic)
			if isAutoGraphics then
				showAutoGraphics()
				return goToAutoGraphics()
			else
				showAutoGraphics()
				showManualGraphics()
				return goToManualGraphics(translateSavedQualityLevelToInt(UserSettings().GameSettings.SavedQualityLevel))
			end
		end
		local disableGraphicsWidget
		disableGraphicsWidget = function()
			hideManualGraphics()
			hideAutoGraphics()
			settings().Rendering.EnableFRM = false
		end
		graphicsSetter.FocusLost:connect(function()
			if isAutoGraphics then
				graphicsSetter.Text = tostring(graphicsLevel.Value)
				return
			end
			local newGraphicsValue = tonumber(graphicsSetter.Text)
			if not (newGraphicsValue ~= nil) then
				graphicsSetter.Text = tostring(graphicsLevel.Value)
				return
			end
			if newGraphicsValue < 1 then
				newGraphicsValue = 1
			elseif newGraphicsValue >= settings().Rendering:GetMaxQualityLevel() then
				newGraphicsValue = settings().Rendering:GetMaxQualityLevel() - 1
			end
			graphicsLevel.Value = newGraphicsValue
			setGraphicsQualityLevel(graphicsLevel.Value)
			graphicsSetter.Text = tostring(graphicsLevel.Value)
		end)
		graphicsLevel.Changed:connect(function(_)
			if isAutoGraphics then
				return
			end
			if not listenToGraphicsLevelChange then
				return
			end
			graphicsSetter.Text = tostring(graphicsLevel.Value)
			return setGraphicsQualityLevel(graphicsLevel.Value)
		end)
		if inStudioMode or UserSettings().GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic then
			if inStudioMode then
				settings().Rendering.EnableFRM = false
				disableGraphicsWidget()
			else
				settings().Rendering.EnableFRM = true
				goToAutoGraphics()
			end
		else
			settings().Rendering.EnableFRM = true
			goToManualGraphics(translateSavedQualityLevelToInt(UserSettings().GameSettings.SavedQualityLevel))
		end
		autoGraphicsButton.MouseButton1Click:connect(function()
			if inStudioMode and not game.Players.LocalPlayer then
				return
			end
			if not isAutoGraphics then
				return goToAutoGraphics()
			else
				return goToManualGraphics(graphicsLevel.Value)
			end
		end)
		game.GraphicsQualityChangeRequest:connect(function(graphicsIncrease)
			if isAutoGraphics then
				return
			end
			if graphicsIncrease then
				if (graphicsLevel.Value + 1) > GraphicsQualityLevels then
					return
				end
				graphicsLevel.Value = graphicsLevel.Value + 1
				graphicsSetter.Text = tostring(graphicsLevel.Value)
				setGraphicsQualityLevel(graphicsLevel.Value)
				return game:GetService("GuiService"):SendNotification("Graphics Quality", "Increased to (" .. tostring(graphicsSetter.Text) .. ")", "", 2, function() end)
			else
				if (graphicsLevel.Value - 1) <= 0 then
					return
				end
				graphicsLevel.Value = graphicsLevel.Value - 1
				graphicsSetter.Text = tostring(graphicsLevel.Value)
				setGraphicsQualityLevel(graphicsLevel.Value)
				return game:GetService("GuiService"):SendNotification("Graphics Quality", "Decreased to (" .. tostring(graphicsSetter.Text) .. ")", "", 2, function() end)
			end
		end)
		game.Players.PlayerAdded:connect(function(player)
			if player == game.Players.LocalPlayer and inStudioMode then
				return enableGraphicsWidget()
			end
		end)
		game.Players.PlayerRemoving:connect(function(player)
			if player == game.Players.LocalPlayer and inStudioMode then
				return disableGraphicsWidget()
			end
		end)
		studioCheckbox = createTextButton("", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size18, UDim2.new(0, 25, 0, 25), UDim2.new(0, 30, 0, 176))
		studioCheckbox.Name = "StudioCheckbox"
		studioCheckbox.ZIndex = baseZIndex + 4
		studioCheckbox:SetVerb("TogglePlayMode")
		studioCheckbox.Visible = false
		local wasManualGraphics = (settings().Rendering.QualityLevel ~= Enum.QualityLevel.Automatic)
		if inStudioMode and not game.Players.LocalPlayer then
			studioCheckbox.Text = "X"
			disableGraphicsWidget()
		elseif inStudioMode then
			studioCheckbox.Text = "X"
			enableGraphicsWidget()
		end
		if hasGraphicsSlider then
			UserSettings().GameSettings.StudioModeChanged:connect(function(isStudioMode)
				inStudioMode = isStudioMode
				if isStudioMode then
					wasManualGraphics = (settings().Rendering.QualityLevel ~= Enum.QualityLevel.Automatic)
					goToAutoGraphics()
					studioCheckbox.Text = "X"
					autoGraphicsButton.ZIndex = 1
					autoText.ZIndex = 1
				else
					if wasManualGraphics then
						goToManualGraphics()
					end
					studioCheckbox.Text = ""
					autoGraphicsButton.ZIndex = baseZIndex + 4
					autoText.ZIndex = baseZIndex + 4
				end
			end)
		else
			studioCheckbox.MouseButton1Click:connect(function()
				if not studioCheckbox.Active then
					return
				end
				if studioCheckbox.Text == "" then
					studioCheckbox.Text = "X"
				else
					studioCheckbox.Text = ""
				end
			end)
		end
	end
	local fullscreenCheckbox = createTextButton("", Enum.ButtonStyle.RobloxButton, Enum.FontSize.Size18, UDim2.new(0, 25, 0, 25), UDim2.new(0, 30, 0, 144))
	fullscreenCheckbox.Name = "FullscreenCheckbox"
	fullscreenCheckbox.ZIndex = baseZIndex + 4
	fullscreenCheckbox.Parent = gameSettingsMenuFrame
	fullscreenCheckbox:SetVerb("ToggleFullScreen")
	if UserSettings().GameSettings:InFullScreen() then
		fullscreenCheckbox.Text = "X"
	end
	if hasGraphicsSlider then
		UserSettings().GameSettings.FullscreenChanged:connect(function(isFullscreen)
			if isFullscreen then
				fullscreenCheckbox.Text = "X"
			else
				fullscreenCheckbox.Text = ""
			end
		end)
	else
		fullscreenCheckbox.MouseButton1Click:connect(function()
			if fullscreenCheckbox.Text == "" then
				fullscreenCheckbox.Text = "X"
			else
				fullscreenCheckbox.Text = ""
			end
		end)
	end
	if game:FindFirstChild("NetworkClient") then
		setDisabledState(studioText)
		setDisabledState(studioShortcut)
		setDisabledState(studioCheckbox)
	end
	local backButton
	if hasGraphicsSlider then
		backButton = createTextButton("OK", Enum.ButtonStyle.RobloxButtonDefault, Enum.FontSize.Size24, UDim2.new(0, 180, 0, 50), UDim2.new(0, 170, 0, 330))
		backButton.Modal = true
	else
		backButton = createTextButton("OK", Enum.ButtonStyle.RobloxButtonDefault, Enum.FontSize.Size24, UDim2.new(0, 180, 0, 50), UDim2.new(0, 170, 0, 270))
		backButton.Modal = true
	end
	backButton.Name = "BackButton"
	backButton.ZIndex = baseZIndex + 4
	backButton.Parent = gameSettingsMenuFrame
	if not macClient then
		New("TextLabel", "VideoCaptureLabel", {
			Text = "After Capturing Video",
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0, 32, 0, 100),
			Size = UDim2.new(0, 164, 0, 18),
			BackgroundTransparency = 1,
			TextColor3 = Color3I(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = baseZIndex + 4,
			Parent = gameSettingsMenuFrame
		})
		local videoNames = { }
		local videoNameToItem = { }
		videoNames[1] = "Just Save to Disk"
		videoNameToItem[videoNames[1]] = Enum.UploadSetting["Never"]
		videoNames[2] = "Upload to YouTube"
		videoNameToItem[videoNames[2]] = Enum.UploadSetting["Ask me first"]
		local videoCaptureDropDown
		videoCaptureDropDown, updateVideoCaptureDropDownSelection = RbxGui.CreateDropDownMenu(videoNames, function(text)
			UserSettings().GameSettings.VideoUploadPromptBehavior = videoNameToItem[text]
		end)
		videoCaptureDropDown.Name = "VideoCaptureField"
		videoCaptureDropDown.ZIndex = baseZIndex + 4
		videoCaptureDropDown.DropDownMenuButton.ZIndex = baseZIndex + 4
		videoCaptureDropDown.DropDownMenuButton.Icon.ZIndex = baseZIndex + 4
		videoCaptureDropDown.Position = UDim2.new(0, 270, 0, 94)
		videoCaptureDropDown.Size = UDim2.new(0, 200, 0, 32)
		videoCaptureDropDown.Parent = gameSettingsMenuFrame
		syncVideoCaptureSetting = function()
			return updateVideoCaptureDropDownSelection((function()
				if UserSettings().GameSettings.VideoUploadPromptBehavior == Enum.UploadSetting["Never"] then
					return videoNames[1]
				elseif UserSettings().GameSettings.VideoUploadPromptBehavior == Enum.UploadSetting["Ask me first"] then
					return videoNames[2]
				else
					UserSettings().GameSettings.VideoUploadPromptBehavior = Enum.UploadSetting["Ask me first"]
					return videoNames[2]
				end
			end)())
		end
	end
	New("TextLabel", "CameraLabel", {
		Text = "Character & Camera Controls",
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0, 31, 0, 58),
		Size = UDim2.new(0, 224, 0, 18),
		TextColor3 = Color3I(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		ZIndex = baseZIndex + 4,
		Parent = gameSettingsMenuFrame
	})
	mouseLockLabel = game.CoreGui.RobloxGui:FindFirstChild("MouseLockLabel", true)
	local enumItems = Enum.ControlMode:GetEnumItems()
	local enumNames = { }
	local enumNameToItem = { }
	for i, obj in ipairs(enumItems) do
		enumNames[i] = obj.Name
		enumNameToItem[obj.Name] = obj
	end
	local cameraDropDown
	cameraDropDown, updateCameraDropDownSelection = RbxGui.CreateDropDownMenu(enumNames, function(text)
		UserSettings().GameSettings.ControlMode = enumNameToItem[text]
		return pcall(function()
			if mouseLockLabel and UserSettings().GameSettings.ControlMode == Enum.ControlMode["Mouse Lock Switch"] then
				mouseLockLabel.Visible = true
			elseif mouseLockLabel then
				mouseLockLabel.Visible = false
			end
		end)
	end)
	cameraDropDown.Name = "CameraField"
	cameraDropDown.ZIndex = baseZIndex + 4
	cameraDropDown.DropDownMenuButton.ZIndex = baseZIndex + 4
	cameraDropDown.DropDownMenuButton.Icon.ZIndex = baseZIndex + 4
	cameraDropDown.Position = UDim2.new(0, 270, 0, 52)
	cameraDropDown.Size = UDim2.new(0, 200, 0, 32)
	cameraDropDown.Parent = gameSettingsMenuFrame
	return gameSettingsMenuFrame
end
if LoadLibrary then
	RbxGui = LoadLibrary("RbxGui")
	local baseZIndex = 0
	if UserSettings then
		local createSettingsDialog
		createSettingsDialog = function()
			waitForChild(gui, "BottomLeftControl")
			settingsButton = gui.BottomLeftControl:FindFirstChild("SettingsButton")
			if not (settingsButton ~= nil) then
				settingsButton = New("ImageButton", "SettingsButton", {
					Image = "rbxasset://textures/ui/SettingsButton.png",
					BackgroundTransparency = 1,
					Active = false,
					Size = UDim2.new(0, 54, 0, 46),
					Position = UDim2.new(0, 2, 0, 50),
					Parent = gui.BottomLeftControl
				})
			end
			local shield = New("TextButton", "UserSettingsShield", {
				Text = "",
				Active = true,
				AutoButtonColor = false,
				Visible = false,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3I(51, 51, 51),
				BorderColor3 = Color3I(27, 42, 53),
				BackgroundTransparency = 0.4,
				ZIndex = baseZIndex + 2
			})
			mainShield = shield
			local frame = New("Frame", "Settings", {
				Position = UDim2.new(0.5, -262, -0.5, -200),
				Size = UDim2.new(0, 525, 0, 430),
				BackgroundTransparency = 1,
				Active = true,
				Parent = shield
			})
			settingsFrame = New("Frame", "SettingsStyle", {
				Size = UDim2.new(1, 0, 1, 0),
				Style = Enum.FrameStyle.RobloxRound,
				Active = true,
				ZIndex = baseZIndex + 3,
				Parent = frame
			})
			local gameMainMenu = createGameMainMenu(baseZIndex, shield)
			gameMainMenu.Parent = settingsFrame
			gameMainMenu.ScreenshotButton.MouseButton1Click:connect(function()
				return backToGame(gameMainMenu.ScreenshotButton, shield, settingsButton)
			end)
			gameMainMenu.RecordVideoButton.MouseButton1Click:connect(function()
				recordVideoClick(gameMainMenu.RecordVideoButton, gui.StopRecordButton)
				return backToGame(gameMainMenu.RecordVideoButton, shield, settingsButton)
			end)
			if settings():FindFirstChild("Game Options") then
pcall(function()
					return settings():FindFirstChild("Game Options").VideoRecordingChangeRequest:connect(function(recording)
						recordingVideo = recording
						return setRecordGui(recording, gui.StopRecordButton, gameMainMenu.RecordVideoButton)
					end)
				end)
			end
			game.CoreGui.RobloxGui.Changed:connect(function(prop)
				if prop == "AbsoluteSize" and recordingVideo then
					return recordVideoClick(gameMainMenu.RecordVideoButton, gui.StopRecordButton)
				end
			end)
			local localPlayerChange
			localPlayerChange = function()
				gameMainMenu.ResetButton.Visible = game.Players.LocalPlayer
				if game.Players.LocalPlayer then
					settings().Rendering.EnableFRM = true
				elseif inStudioMode then
					settings().Rendering.EnableFRM = false
				end
			end
			gameMainMenu.ResetButton.Visible = game.Players.LocalPlayer
			if (game.Players.LocalPlayer ~= nil) then
				game.Players.LocalPlayer.Changed:connect(function()
					return localPlayerChange()
				end)
			else
				delay(0, function()
					waitForProperty(game.Players, "LocalPlayer")
					gameMainMenu.ResetButton.Visible = game.Players.LocalPlayer
					return game.Players.LocalPlayer.Changed:connect(function()
						return localPlayerChange()
					end)
				end)
			end
			gameMainMenu.ReportAbuseButton.Visible = game:FindFirstChild("NetworkClient")
			if not gameMainMenu.ReportAbuseButton.Visible then
				game.ChildAdded:connect(function(child)
					if child:IsA("NetworkClient") then
						gameMainMenu.ReportAbuseButton.Visible = game:FindFirstChild("NetworkClient")
					end
				end)
			end
			gameMainMenu.ResetButton.MouseButton1Click:connect(function()
				return goToMenu(settingsFrame, "ResetConfirmationMenu", "up", UDim2.new(0, 525, 0, 370))
			end)
			gameMainMenu.LeaveGameButton.MouseButton1Click:connect(function()
				return goToMenu(settingsFrame, "LeaveConfirmationMenu", "down", UDim2.new(0, 525, 0, 300))
			end)
			if game.CoreGui.Version >= 4 then
				game:GetService("GuiService").EscapeKeyPressed:connect(function()
					if not (currentMenuSelection ~= nil) then
						return game.GuiService:AddCenterDialog(shield, Enum.CenterDialogType.ModalDialog, function()
							settingsButton.Active = false
							updateCameraDropDownSelection(UserSettings().GameSettings.ControlMode.Name)
							if syncVideoCaptureSetting ~= nil then
								syncVideoCaptureSetting()
							end
							goToMenu(settingsFrame, "GameMainMenu", "right", UDim2.new(0, 525, 0, 430))
							shield.Visible = true
							shield.Active = true
							settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262, 0.5, -200), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
							return settingsFrame.Parent:TweenSize(UDim2.new(0, 525, 0, 430), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
						end, function()
							settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262, -0.5, -200), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
							settingsFrame.Parent:TweenSize(UDim2.new(0, 525, 0, 430), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
							shield.Visible = false
							settingsButton.Active = true
						end)
					elseif #lastMenuSelection > 0 then
						if #centerDialogs > 0 then
							for i = 1, #centerDialogs do
								game.GuiService:RemoveCenterDialog(centerDialogs[i])
								centerDialogs[i].Visible = false
							end
							centerDialogs = { }
						end
						goToMenu(lastMenuSelection[#lastMenuSelection]["container"], lastMenuSelection[#lastMenuSelection]["name"], lastMenuSelection[#lastMenuSelection]["direction"], lastMenuSelection[#lastMenuSelection]["lastSize"])
						table.remove(lastMenuSelection, #lastMenuSelection)
						if #lastMenuSelection == 1 then
							lastMenuSelection = { }
						end
					else
						return resumeGameFunction(shield)
					end
				end)
			end
			local gameSettingsMenu = createGameSettingsMenu(baseZIndex, shield)
			gameSettingsMenu.Visible = false
			gameSettingsMenu.Parent = settingsFrame
			gameMainMenu.SettingsButton.MouseButton1Click:connect(function()
				return goToMenu(settingsFrame, "GameSettingsMenu", "left", UDim2.new(0, 525, 0, 350))
			end)
			gameSettingsMenu.BackButton.MouseButton1Click:connect(function()
				return goToMenu(settingsFrame, "GameMainMenu", "right", UDim2.new(0, 525, 0, 430))
			end)
			local resetConfirmationWindow = createResetConfirmationMenu(baseZIndex, shield)
			resetConfirmationWindow.Visible = false
			resetConfirmationWindow.Parent = settingsFrame
			local leaveConfirmationWindow = createLeaveConfirmationMenu(baseZIndex, shield)
			leaveConfirmationWindow.Visible = false
			leaveConfirmationWindow.Parent = settingsFrame
			robloxLock(shield)
			settingsButton.MouseButton1Click:connect(function()
				return game.GuiService:AddCenterDialog(shield, Enum.CenterDialogType.ModalDialog, function()
					settingsButton.Active = false
					updateCameraDropDownSelection(UserSettings().GameSettings.ControlMode.Name)
					if syncVideoCaptureSetting ~= nil then
						syncVideoCaptureSetting()
					end
					goToMenu(settingsFrame, "GameMainMenu", "right", UDim2.new(0, 525, 0, 430))
					shield.Visible = true
					settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262, 0.5, -200), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
					return settingsFrame.Parent:TweenSize(UDim2.new(0, 525, 0, 430), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
				end, function()
					settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262, -0.5, -200), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
					settingsFrame.Parent:TweenSize(UDim2.new(0, 525, 0, 430), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, tweenTime, true)
					shield.Visible = false
					settingsButton.Active = true
				end)
			end)
			return shield
		end
		delay(0, function()
			createSettingsDialog().Parent = gui
			gui.BottomLeftControl.SettingsButton.Active = true
			gui.BottomLeftControl.SettingsButton.Position = UDim2.new(0, 2, 0, -2)
			if mouseLockLabel and UserSettings().GameSettings.ControlMode == Enum.ControlMode["Mouse Lock Switch"] then
				mouseLockLabel.Visible = true
			elseif mouseLockLabel then
				mouseLockLabel.Visible = false
			end
			local leaveGameButton = gui.BottomLeftControl:FindFirstChild("Exit")
			if leaveGameButton then
				leaveGameButton:Remove()
			end
			local topLeft = gui:FindFirstChild("TopLeftControl")
			if topLeft then
				leaveGameButton = topLeft:FindFirstChild("Exit")
				if leaveGameButton then
					leaveGameButton:Remove()
				end
				return topLeft:Remove()
			end
		end)
	end
	local createSaveDialogs
	createSaveDialogs = function()
		local shield = New("TextButton", "SaveDialogShield", {
			Text = "",
			AutoButtonColor = false,
			Active = true,
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3I(51, 51, 51),
			BorderColor3 = Color3I(27, 42, 53),
			BackgroundTransparency = 0.4,
			ZIndex = baseZIndex + 1
		})
		local clearAndResetDialog, save, saveLocal, dontSave, cancel
		local messageBoxButtons = { }
		messageBoxButtons[1] = { }
		messageBoxButtons[1].Text = "Save"
		messageBoxButtons[1].Style = Enum.ButtonStyle.RobloxButtonDefault
		messageBoxButtons[1].Function = function()
			return save()
		end
		messageBoxButtons[2] = { }
		messageBoxButtons[2].Text = "Cancel"
		messageBoxButtons[2].Function = function()
			return cancel()
		end
		messageBoxButtons[3] = { }
		messageBoxButtons[3].Text = "Don't Save"
		messageBoxButtons[3].Function = function()
			return dontSave()
		end
		local saveDialogMessageBox = RbxGui.CreateStyledMessageDialog("Unsaved Changes", "Save your changes to Mercury before leaving?", "Confirm", messageBoxButtons)
		saveDialogMessageBox.Visible = true
		saveDialogMessageBox.Parent = shield
		local errorBoxButtons = { }
		local buttonOffset = 1
		if game.LocalSaveEnabled then
			errorBoxButtons[buttonOffset] = { }
			errorBoxButtons[buttonOffset].Text = "Save to Disk"
			errorBoxButtons[buttonOffset].Function = function()
				return saveLocal()
			end
			buttonOffset = buttonOffset + 1
		end
		errorBoxButtons[buttonOffset] = { }
		errorBoxButtons[buttonOffset].Text = "Keep Playing"
		errorBoxButtons[buttonOffset].Function = function()
			return cancel()
		end
		errorBoxButtons[buttonOffset + 1] = { }
		errorBoxButtons[buttonOffset + 1].Text = "Don't Save"
		errorBoxButtons[buttonOffset + 1].Function = function()
			return dontSave()
		end
		local errorDialogMessageBox = RbxGui.CreateStyledMessageDialog("Upload Failed", "Sorry, we could not save your changes to Mercury.", "Error", errorBoxButtons)
		errorDialogMessageBox.Visible = false
		errorDialogMessageBox.Parent = shield
		local spinnerDialog = New("Frame", "SpinnerDialog", {
			Style = Enum.FrameStyle.RobloxRound,
			Size = UDim2.new(0, 350, 0, 150),
			Position = UDim2.new(0.5, -175, 0.5, -75),
			Visible = false,
			Active = true,
			Parent = shield,
			New("TextLabel", "WaitingLabel", {
				Text = "Saving to Mercury...",
				Font = Enum.Font.ArialBold,
				FontSize = Enum.FontSize.Size18,
				Position = UDim2.new(0.5, 25, 0.5, 0),
				TextColor3 = Color3.new(1, 1, 1)
			})
		})
		local spinnerFrame = New("Frame", "Spinner", {
			Size = UDim2.new(0, 80, 0, 80),
			Position = UDim2.new(0.5, -150, 0.5, -40),
			BackgroundTransparency = 1,
			Parent = spinnerDialog
		})
		local spinnerIcons = { }
		local spinnerNum = 1
		while spinnerNum <= 8 do
			local spinnerImage = New("ImageLabel", "Spinner" .. tostring(spinnerNum), {
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0.5 + 0.3 * math.cos(math.rad(45 * spinnerNum)), -8, 0.5 + 0.3 * math.sin(math.rad(45 * spinnerNum)), -8),
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/Asset?id=45880710",
				Parent = spinnerFrame
			})
			spinnerIcons[spinnerNum] = spinnerImage
			spinnerNum = spinnerNum + 1
		end
		save = function()
			saveDialogMessageBox.Visible = false
			spinnerDialog.Visible = true
			local spin = true
			delay(0, function()
				local spinPos = 0
				while spin do
					local pos = 0
					while pos < 8 do
						spinnerIcons[pos + 1].Image = "http://www.roblox.com/Asset?id=" .. (function()
							if pos == spinPos or pos == ((spinPos + 1) % 8) then
								return 45880668
							else
								return 45880710
							end
						end)()
						pos = pos + 1
					end
					spinPos = (spinPos + 1) % 8
					wait(0.2)
				end
			end)
			local result = game:SaveToRoblox()
			if not result then
				result = game:SaveToRoblox()
			end
			spinnerDialog.Visible = false
			spin = false
			if result then
				game:FinishShutdown(false)
				return clearAndResetDialog()
			else
				errorDialogMessageBox.Visible = true
			end
		end
		saveLocal = function()
			errorDialogMessageBox.Visible = false
			game:FinishShutdown(true)
			return clearAndResetDialog()
		end
		dontSave = function()
			saveDialogMessageBox.Visible = false
			errorDialogMessageBox.Visible = false
			game:FinishShutdown(false)
			return clearAndResetDialog()
		end
		cancel = function()
			saveDialogMessageBox.Visible = false
			errorDialogMessageBox.Visible = false
			return clearAndResetDialog()
		end
		clearAndResetDialog = function()
			saveDialogMessageBox.Visible = true
			errorDialogMessageBox.Visible = false
			spinnerDialog.Visible = false
			shield.Visible = false
			return game.GuiService:RemoveCenterDialog(shield)
		end
		robloxLock(shield)
		shield.Visible = false
		return shield
	end
	local createReportAbuseDialog
	createReportAbuseDialog = function()
		waitForChild(game, "NetworkClient")
		waitForChild(game, "Players")
		waitForProperty(game.Players, "LocalPlayer")
		local localPlayer = game.Players.LocalPlayer
		local reportAbuseButton
		waitForChild(gui, "UserSettingsShield")
		waitForChild(gui.UserSettingsShield, "Settings")
		waitForChild(gui.UserSettingsShield.Settings, "SettingsStyle")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle, "GameMainMenu")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu, "ReportAbuseButton")
		reportAbuseButton = gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.ReportAbuseButton
		local shield = New("TextButton", "ReportAbuseShield", {
			Text = "",
			AutoButtonColor = false,
			Active = true,
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3I(51, 51, 51),
			BorderColor3 = Color3I(27, 42, 53),
			BackgroundTransparency = 0.4,
			ZIndex = baseZIndex + 1
		})
		local closeAndResetDialog
		local messageBoxButtons = { }
		messageBoxButtons[1] = { }
		messageBoxButtons[1].Text = "Ok"
		messageBoxButtons[1].Modal = true
		messageBoxButtons[1].Function = function()
			return closeAndResetDialog()
		end
		local calmingMessageBox = RbxGui.CreateMessageDialog("Thanks for your report!", "Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.\n\nIf anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats", messageBoxButtons)
		calmingMessageBox.Visible = false
		calmingMessageBox.Parent = shield
		local recordedMessageBox = RbxGui.CreateMessageDialog("Thanks for your report!", "We've recorded your report for evaluation.", messageBoxButtons)
		recordedMessageBox.Visible = false
		recordedMessageBox.Parent = shield
		local normalMessageBox = RbxGui.CreateMessageDialog("Thanks for your report!", "Our moderators will review the chat logs and determine what happened.", messageBoxButtons)
		normalMessageBox.Visible = false
		normalMessageBox.Parent = shield
		local frame = New("Frame", "Settings", {
			Position = UDim2.new(0.5, -250, 0.5, -200),
			Size = UDim2.new(0, 500, 0, 400),
			BackgroundTransparency = 1,
			Active = true,
			Parent = shield
		})
		settingsFrame = New("Frame", "ReportAbuseStyle", {
			Size = UDim2.new(1, 0, 1, 0),
			Style = Enum.FrameStyle.RobloxRound,
			Active = true,
			ZIndex = baseZIndex + 1,
			Parent = frame,
			New("TextLabel", "Title", {
				Text = "Report Abuse",
				TextColor3 = Color3I(221, 221, 221),
				Position = UDim2.new(0.5, 0, 0, 30),
				Font = Enum.Font.ArialBold,
				FontSize = Enum.FontSize.Size36,
				ZIndex = baseZIndex + 2
			}),
			New("TextLabel", "Description", {
				Text = "This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.",
				TextColor3 = Color3I(221, 221, 221),
				Position = UDim2.new(0, 0, 0, 55),
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
				Font = Enum.Font.Arial,
				FontSize = Enum.FontSize.Size18,
				TextWrap = true,
				ZIndex = baseZIndex + 2,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			New("TextLabel", "PlayerLabel", {
				Text = "Which player?",
				BackgroundTransparency = 1,
				Font = Enum.Font.Arial,
				FontSize = Enum.FontSize.Size18,
				Position = UDim2.new(0.025, 0, 0, 100),
				Size = UDim2.new(0.4, 0, 0, 36),
				TextColor3 = Color3I(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = baseZIndex + 2
			}),
			New("TextLabel", "AbuseLabel", {
				Text = "Type of Abuse:",
				Font = Enum.Font.Arial,
				BackgroundTransparency = 1,
				FontSize = Enum.FontSize.Size18,
				Position = UDim2.new(0.025, 0, 0, 140),
				Size = UDim2.new(0.4, 0, 0, 36),
				TextColor3 = Color3I(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = baseZIndex + 2
			})
		})
		local abusingPlayer, abuse, submitReportButton
		local updatePlayerSelection
		local createPlayersDropDown
		createPlayersDropDown = function()
			local players = game:GetService("Players")
			local playerNames = { }
			local nameToPlayer = { }
			local children = players:GetChildren()
			local pos = 1
			if children then
				for _, player in ipairs(children) do
					if player:IsA("Player") and player ~= localPlayer then
						playerNames[pos] = player.Name
						nameToPlayer[player.Name] = player
						pos = pos + 1
					end
				end
			end
			local playerDropDown
			playerDropDown, updatePlayerSelection = RbxGui.CreateDropDownMenu(playerNames, function(playerName)
				abusingPlayer = nameToPlayer[playerName]
				if abuse and abusingPlayer then
					submitReportButton.Active = true
				end
			end)
			playerDropDown.Name = "PlayersComboBox"
			playerDropDown.ZIndex = baseZIndex + 2
			playerDropDown.Position = UDim2.new(0.425, 0, 0, 102)
			playerDropDown.Size = UDim2.new(0.55, 0, 0, 32)
			return playerDropDown
		end
		local abuses = {
			"Swearing",
			"Bullying",
			"Scamming",
			"Dating",
			"Cheating/Exploiting",
			"Personal Questions",
			"Offsite Links",
			"Bad Model or Script",
			"Bad Username"
		}
		local abuseDropDown, updateAbuseSelection
		abuseDropDown, updateAbuseSelection = RbxGui.CreateDropDownMenu(abuses, function(abuseText)
			abuse = abuseText
			if abuse and abusingPlayer then
				submitReportButton.Active = true
			end
		end, true)
		abuseDropDown.Name = "AbuseComboBox"
		abuseDropDown.ZIndex = baseZIndex + 2
		abuseDropDown.Position = UDim2.new(0.425, 0, 0, 142)
		abuseDropDown.Size = UDim2.new(0.55, 0, 0, 32)
		abuseDropDown.Parent = settingsFrame
		New("TextLabel", "ShortDescriptionLabel", {
			Text = "Short Description: (optional)",
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0.025, 0, 0, 180),
			Size = UDim2.new(0.95, 0, 0, 36),
			TextColor3 = Color3I(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			ZIndex = baseZIndex + 2,
			Parent = settingsFrame
		})
		local shortDescriptionWrapper = New("Frame", "ShortDescriptionWrapper", {
			Position = UDim2.new(0.025, 0, 0, 220),
			Size = UDim2.new(0.95, 0, 1, -310),
			BackgroundColor3 = Color3I(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = baseZIndex + 2,
			Parent = settingsFrame
		})
		local shortDescriptionBox = New("TextBox", "TextBox", {
			Text = "",
			ClearTextOnFocus = false,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0, 3, 0, 3),
			Size = UDim2.new(1, -6, 1, -6),
			TextColor3 = Color3I(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrap = true,
			BackgroundColor3 = Color3I(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = baseZIndex + 2,
			Parent = shortDescriptionWrapper
		})
		submitReportButton = New("TextButton", "SubmitReportBtn", {
			Active = false,
			Modal = true,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0.1, 0, 1, -80),
			Size = UDim2.new(0.35, 0, 0, 50),
			AutoButtonColor = true,
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Text = "Submit Report",
			TextColor3 = Color3I(255, 255, 255),
			ZIndex = baseZIndex + 2,
			Parent = settingsFrame
		})
		submitReportButton.MouseButton1Click:connect(function()
			if submitReportButton.Active then
				if abuse and abusingPlayer then
					frame.Visible = false
					game.Players:ReportAbuse(abusingPlayer, abuse, shortDescriptionBox.Text)
					if abuse == "Cheating/Exploiting" then
						recordedMessageBox.Visible = true
					elseif abuse == "Bullying" or abuse == "Swearing" then
						calmingMessageBox.Visible = true
					else
						normalMessageBox.Visible = true
					end
				else
					return closeAndResetDialog()
				end
			end
		end)
		local cancelButton = New("TextButton", "CancelBtn", {
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0.55, 0, 1, -80),
			Size = UDim2.new(0.35, 0, 0, 50),
			AutoButtonColor = true,
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Text = "Cancel",
			TextColor3 = Color3I(255, 255, 255),
			ZIndex = baseZIndex + 2,
			Parent = settingsFrame
		})
		closeAndResetDialog = function()
			local oldComboBox = settingsFrame:FindFirstChild("PlayersComboBox")
			if oldComboBox then
				oldComboBox.Parent = nil
			end
			abusingPlayer = nil
			updatePlayerSelection(nil)
			abuse = nil
			updateAbuseSelection(nil)
			submitReportButton.Active = false
			shortDescriptionBox.Text = ""
			frame.Visible = true
			calmingMessageBox.Visible = false
			recordedMessageBox.Visible = false
			normalMessageBox.Visible = false
			shield.Visible = false
			reportAbuseButton.Active = true
			return game.GuiService:RemoveCenterDialog(shield)
		end
		cancelButton.MouseButton1Click:connect(closeAndResetDialog)
		reportAbuseButton.MouseButton1Click:connect(function()
			createPlayersDropDown().Parent = settingsFrame
			table.insert(centerDialogs, shield)
			return game.GuiService:AddCenterDialog(shield, Enum.CenterDialogType.ModalDialog, function()
				reportAbuseButton.Active = false
				shield.Visible = true
				mainShield.Visible = false
			end, function()
				reportAbuseButton.Active = true
				shield.Visible = false
			end)
		end)
		robloxLock(shield)
		return shield
	end
	local isSaveDialogSupported = pcall(function() end)
	if isSaveDialogSupported then
		delay(0, function()
			local saveDialogs = createSaveDialogs()
			saveDialogs.Parent = gui
			game.RequestShutdown = function()
				table.insert(centerDialogs, saveDialogs)
				game.GuiService:AddCenterDialog(saveDialogs, Enum.CenterDialogType.QuitDialog, function()
					saveDialogs.Visible = true
				end, function()
					saveDialogs.Visible = false
				end)
				return true
			end
		end)
	end
	delay(0, function()
		createReportAbuseDialog().Parent = gui
		waitForChild(gui, "UserSettingsShield")
		waitForChild(gui.UserSettingsShield, "Settings")
		waitForChild(gui.UserSettingsShield.Settings, "SettingsStyle")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle, "GameMainMenu")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu, "ReportAbuseButton")
		gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.ReportAbuseButton.Active = true
	end)
pcall(function()
		return game.GuiService.UseLuaChat
	end)
	local BurningManPlaceID = 41324860
	return delay(0, function()
		waitForChild(game, "NetworkClient")
		waitForChild(game, "Players")
		waitForProperty(game.Players, "LocalPlayer")
		waitForProperty(game.Players.LocalPlayer, "Character")
		waitForChild(game.Players.LocalPlayer.Character, "Humanoid")
		waitForProperty(game, "PlaceId")
		if game.PlaceId == BurningManPlaceID then
			game.Players.LocalPlayer.Character.Humanoid:SetClickToWalkEnabled(false)
			return game.Players.LocalPlayer.CharacterAdded:connect(function(character)
				waitForChild(character, "Humanoid")
				return character.Humanoid:SetClickToWalkEnabled(false)
			end)
		end
	end)
end
