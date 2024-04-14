--!strict
-- CoreGui.RobloxGui.CoreScripts/Settings
print "[Mercury]: Loaded corescript 46295863"

local GuiService = game:GetService "GuiService"
local Players = game:GetService "Players"

local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate
local BaseUrl = require "../Modules/BaseUrl"
local path = BaseUrl.path

local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end
local function waitForProperty(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end

-- A Few Script Globals
local MercuryGui = script.Parent :: ScreenGui & { ControlFrame: Frame }
local gui = MercuryGui:FindFirstChild "ControlFrame" and MercuryGui.ControlFrame
	or MercuryGui

local RbxGui
local helpButton, updateCameraDropDownSelection, updateVideoCaptureDropDownSelection
local tweenTime = 0.2

local mouseLockLookScreenUrl = path "asset?id=54071825"
local classicLookScreenUrl = path "asset?id=45915798"

local hasGraphicsSlider = true
local GraphicsQualityLevels = 10 -- how many levels we allow on graphics slider
local recordingVideo = false

local currentMenuSelection
local lastMenuSelection = {}

-- local defaultPosition = UDim2.new(0, 0, 0, 0)
-- local newGuiPlaces = { 0, 41324860 }

local centerDialogs = {}
local mainShield

local inStudioMode = UserSettings().GameSettings:InStudioMode()

local macClient = false
local ok, isMac = pcall(function()
	return not GuiService.IsWindows
end)
macClient = ok and isMac

local function Colour3(r: number, g: number, b: number)
	return Color3.new(r / 255, g / 255, b / 255)
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

local settingsButton

local function resumeGameFunction(shield)
	shield.Settings:TweenPosition(
		UDim2.new(0.5, -262, -0.5, -200),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Sine,
		tweenTime,
		true
	)
	delay(tweenTime, function()
		shield.Visible = false
		for i = 1, #centerDialogs do
			centerDialogs[i].Visible = false
			GuiService:RemoveCenterDialog(centerDialogs[i])
		end
		GuiService:RemoveCenterDialog(shield)
		settingsButton.Active = true
		currentMenuSelection = nil
		lastMenuSelection = {}
	end)
end

local function goToMenu(container, menuName, moveDirection, size, position)
	if type(menuName) ~= "string" then
		return
	end

	table.insert(lastMenuSelection, currentMenuSelection)
	if menuName == "GameMainMenu" then
		lastMenuSelection = {}
	end

	local containerChildren = container:GetChildren()
	for i = 1, #containerChildren do
		if containerChildren[i].Name == menuName then
			containerChildren[i].Visible = true
			currentMenuSelection = {
				container = container,
				name = menuName,
				direction = moveDirection,
				lastSize = size,
			}
			-- selectedMenu = true
			if size and position then
				containerChildren[i]:TweenSizeAndPosition(
					size,
					position,
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Sine,
					tweenTime,
					true
				)
			elseif size then
				containerChildren[i]:TweenSizeAndPosition(
					size,
					UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Sine,
					tweenTime,
					true
				)
			else
				containerChildren[i]:TweenPosition(
					UDim2.new(0, 0, 0, 0),
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Sine,
					tweenTime,
					true
				)
			end
		else
			if moveDirection == "left" then
				containerChildren[i]:TweenPosition(
					UDim2.new(-1, -525, 0, 0),
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Sine,
					tweenTime,
					true
				)
			elseif moveDirection == "right" then
				containerChildren[i]:TweenPosition(
					UDim2.new(1, 525, 0, 0),
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Sine,
					tweenTime,
					true
				)
			elseif moveDirection == "up" then
				containerChildren[i]:TweenPosition(
					UDim2.new(0, 0, -1, -400),
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Sine,
					tweenTime,
					true
				)
			elseif moveDirection == "down" then
				containerChildren[i]:TweenPosition(
					UDim2.new(0, 0, 1, 400),
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Sine,
					tweenTime,
					true
				)
			end
			delay(tweenTime, function()
				containerChildren[i].Visible = false
			end)
		end
	end
end

local function resetLocalCharacter()
	local player = Players.LocalPlayer
	if player and player.Character then
		local humanoid = (player.Character:FindFirstChild "Humanoid") :: Humanoid
		if humanoid then
			humanoid.Health = 0
		end
	end
end

local function createTextButton(
	text: string,
	style: EnumItem,
	fontSize: EnumItem,
	buttonSize: UDim2,
	buttonPosition: UDim2
)
	return New "TextButton" {
		Font = Enum.Font.Arial,
		FontSize = fontSize,
		Size = buttonSize,
		Position = buttonPosition,
		Style = style,
		TextColor3 = Color3.new(1, 1, 1),
		Text = text,
	}
end

local function CreateTextButtons(frame, buttons, yPos, ySize)
	if #buttons < 1 then
		error "Must have more than one button"
	end

	local buttonNum = 1
	local buttonObjs = {}

	local function toggleSelection(button)
		for _, obj in ipairs(buttonObjs) do
			if obj == button then
				obj.Style = Enum.ButtonStyle.RobloxButtonDefault
			else
				obj.Style = Enum.ButtonStyle.RobloxButton
			end
		end
	end

	for _, obj in ipairs(buttons) do
		local button = New "TextButton" {
			Name = "Button" .. buttonNum,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			AutoButtonColor = true,
			Style = Enum.ButtonStyle.RobloxButton,
			Text = obj.Text,
			TextColor3 = Color3.new(1, 1, 1),
		}
		button.MouseButton1Click:connect(function()
			toggleSelection(button)
			obj.Function()
		end)
		button.Parent = frame
		buttonObjs[buttonNum] = button

		buttonNum += 1
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

local function setRecordGui(recording, stopRecordButton, recordVideoButton)
	if recording then
		stopRecordButton.Visible = true
		recordVideoButton.Text = "Stop Recording"
	else
		stopRecordButton.Visible = false
		recordVideoButton.Text = "Record Video"
	end
end

local function recordVideoClick(recordVideoButton, stopRecordButton)
	recordingVideo = not recordingVideo
	setRecordGui(recordingVideo, stopRecordButton, recordVideoButton)
end

local function backToGame(buttonClicked, shield, settingsButton2)
	buttonClicked.Parent.Parent.Parent.Parent.Visible = false
	shield.Visible = false
	for i = 1, #centerDialogs do
		GuiService:RemoveCenterDialog(centerDialogs[i])
		centerDialogs[i].Visible = false
	end
	centerDialogs = {}
	GuiService:RemoveCenterDialog(shield)
	settingsButton2.Active = true
end

local function setDisabledState(guiObject)
	if not guiObject then
		return
	elseif guiObject:IsA "TextLabel" then
		guiObject.TextTransparency = 0.9
	elseif guiObject:IsA "TextButton" then
		guiObject.TextTransparency = 0.9
		guiObject.Active = false
	elseif guiObject.ClassName then
		print(
			"setDisabledState() got object of unsupported type. object type is ",
			guiObject.ClassName
		)
	end
end

local function createHelpDialog(baseZIndex)
	if helpButton == nil then
		if
			gui:FindFirstChild "TopLeftControl"
			and gui.TopLeftControl:FindFirstChild "Help"
		then
			helpButton = gui.TopLeftControl.Help
		elseif
			gui:FindFirstChild "BottomRightControl"
			and gui.BottomRightControl:FindFirstChild "Help"
		then
			helpButton = gui.BottomRightControl.Help
		end
	end

	local shield = New "Frame" {
		Name = "HelpDialogShield",
		Active = true,
		Visible = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Colour3(51, 51, 51),
		BorderColor3 = Colour3(27, 42, 53),
		BackgroundTransparency = 0.4,
		ZIndex = baseZIndex + 1,
	}

	local helpDialog = New "Frame" {
		Name = "HelpDialog",
		Style = Enum.FrameStyle.RobloxRound,
		Position = UDim2.new(0.2, 0, 0.2, 0),
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Active = true,
		Parent = shield,
		New "TextLabel" {
			Name = "Title",
			Text = "Keyboard & Mouse Controls",
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			Position = UDim2.new(0, 0, 0.025, 0),
			Size = UDim2.new(1, 0, 0, 40),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
		},
	}

	local buttonRow = New "Frame" {
		Name = "Buttons",
		Position = UDim2.new(0.1, 0, 0.07, 40),
		Size = UDim2.new(0.8, 0, 0, 45),
		BackgroundTransparency = 1,
		Parent = helpDialog,
	}

	local imageFrame = New "Frame" {
		Name = "ImageFrame",
		Position = UDim2.new(0.05, 0, 0.075, 80),
		Size = UDim2.new(0.9, 0, 0.9, -120),
		BackgroundTransparency = 1,
		Parent = helpDialog,
	}

	local layoutFrame = New "Frame" {
		Name = "LayoutFrame",
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1.5, 0, 1, 0),
		BackgroundTransparency = 1,
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Parent = imageFrame,
	}

	local image = New "ImageLabel" {
		Name = "Image",
		Image = UserSettings().GameSettings.ControlMode
					== Enum.ControlMode["Mouse Lock Switch"]
				and mouseLockLookScreenUrl
			or classicLookScreenUrl,
		Position = UDim2.new(-0.5, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = layoutFrame,
	}

	CreateTextButtons(buttonRow, {
		{
			Text = "Look",
			Function = function()
				image.Image = UserSettings().GameSettings.ControlMode
							== Enum.ControlMode["Mouse Lock Switch"]
						and mouseLockLookScreenUrl
					or classicLookScreenUrl
			end,
		},
		{
			Text = "Move",
			Function = function()
				image.Image = path "asset?id=45915811"
			end,
		},
		{
			Text = "Gear",
			Function = function()
				image.Image = path "asset?id=45917596"
			end,
		},
		{
			Text = "Zoom",
			Function = function()
				image.Image = path "asset?id=45915825"
			end,
		},
	}, UDim.new(0, 0), UDim.new(1, 0))

	-- set up listeners for type of mouse mode, but keep constructing gui at same time
	delay(0, function()
		waitForChild(gui, "UserSettingsShield")
		waitForChild(gui.UserSettingsShield, "Settings")
		waitForChild(gui.UserSettingsShield.Settings, "SettingsStyle")
		waitForChild(
			gui.UserSettingsShield.Settings.SettingsStyle,
			"GameSettingsMenu"
		)
		waitForChild(
			gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu,
			"CameraField"
		)
		waitForChild(
			gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField,
			"DropDownMenuButton"
		)
		gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Changed:connect(
			function(prop)
				if
					prop ~= "Text"
					and buttonRow.Button1.Style
						== Enum.ButtonStyle.RobloxButtonDefault
				then -- only change if this is the currently selected panel
					image.Image = gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Text
								== "Classic"
							and classicLookScreenUrl
						or mouseLockLookScreenUrl
				end
			end
		)
	end)

	New "TextButton"({
		Name = "OkBtn",
		Text = "OK",
		Modal = true,
		Size = UDim2.new(0.3, 0, 0, 45),
		Position = UDim2.new(0.35, 0, 0.975, -50),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Style = Enum.ButtonStyle.RobloxButtonDefault,
		Parent = helpDialog,
	}).MouseButton1Click:connect(function()
		shield.Visible = false
		GuiService:RemoveCenterDialog(shield)
	end)

	robloxLock(shield)
	return shield
end

local function createLeaveConfirmationMenu(baseZIndex, shield)
	local frame = New "Frame" {
		Name = "LeaveConfirmationMenu",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 2, 400),
		ZIndex = baseZIndex + 4,
		New "TextLabel" {
			Name = "LeaveText",
			Text = "Leave this game?",
			Size = UDim2.new(1, 0, 0.8, 0),
			TextWrapped = true,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			BackgroundTransparency = 1,
			ZIndex = baseZIndex + 4,
		},
	}

	Hydrate(
		createTextButton(
			"Leave",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size24,
			UDim2.new(0, 128, 0, 50),
			UDim2.new(0, 313, 0.8, 0)
		)
	)({
		Name = "YesButton",
		ZIndex = baseZIndex + 4,
		Parent = frame,
		Modal = true,
	}):SetVerb "Exit"

	Hydrate(
		createTextButton(
			"Stay",
			Enum.ButtonStyle.RobloxButtonDefault,
			Enum.FontSize.Size24,
			UDim2.new(0, 128, 0, 50),
			UDim2.new(0, 90, 0.8, 0)
		)
	)({
		Name = "NoButton",
		Parent = frame,
		ZIndex = baseZIndex + 4,
	}).MouseButton1Click:connect(function()
		goToMenu(
			shield.Settings.SettingsStyle,
			"GameMainMenu",
			"down",
			UDim2.new(0, 525, 0, 430)
		)
		shield.Settings:TweenSize(
			UDim2.new(0, 525, 0, 430),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Sine,
			tweenTime,
			true
		)
	end)

	return frame
end

local function createResetConfirmationMenu(baseZIndex, shield)
	local function resetCharacterText()
		return New "TextLabel" {
			Size = UDim2.new(1, 0, 0.8, 0),
			TextWrapped = true,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			BackgroundTransparency = 1,
			ZIndex = baseZIndex + 4,
		}
	end

	local frame = New "Frame" {
		Name = "ResetConfirmationMenu",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 2, 400),
		ZIndex = baseZIndex + 4,
		Hydrate(resetCharacterText()) {
			Name = "ResetCharacterText",
			Text = "Are you sure you want to reset your character?",
			FontSize = Enum.FontSize.Size36,
		},
		Hydrate(resetCharacterText()) {
			Name = "FineResetCharacterText",
			Text = "You will be put back on a spawn point",
			Size = UDim2.new(0, 303, 0, 18),
			Position = UDim2.new(0, 109, 0, 215),
			FontSize = Enum.FontSize.Size18,
		},
	}

	Hydrate(
		createTextButton(
			"Reset",
			Enum.ButtonStyle.RobloxButtonDefault,
			Enum.FontSize.Size24,
			UDim2.new(0, 128, 0, 50),
			UDim2.new(0, 313, 0, 299)
		)
	)({
		Name = "YesButton",
		ZIndex = baseZIndex + 4,
		Parent = frame,
		Modal = true,
	}).MouseButton1Click:connect(function()
		resumeGameFunction(shield)
		resetLocalCharacter()
	end)

	Hydrate(
		createTextButton(
			"Cancel",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size24,
			UDim2.new(0, 128, 0, 50),
			UDim2.new(0, 90, 0, 299)
		)
	)({
		Name = "NoButton",
		Parent = frame,
		ZIndex = baseZIndex + 4,
	}).MouseButton1Click:connect(function()
		goToMenu(
			shield.Settings.SettingsStyle,
			"GameMainMenu",
			"down",
			UDim2.new(0, 525, 0, 430)
		)
		shield.Settings:TweenSize(
			UDim2.new(0, 525, 0, 430),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Sine,
			tweenTime,
			true
		)
	end)

	return frame
end

local settingsFrame

local function createGameMainMenu(baseZIndex, shield)
	local gameMainMenuFrame = New "Frame" {
		Name = "GameMainMenu",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = baseZIndex + 4,
		Parent = settingsFrame,
		New "TextLabel" {
			Name = "Title",
			Text = "Game Menu",
			BackgroundTransparency = 1,
			TextStrokeTransparency = 0,
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			Size = UDim2.new(1, 0, 0, 36),
			Position = UDim2.new(0, 0, 0, 4),
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = baseZIndex + 4,
		},
	}

	local function helpShortcutC()
		return New "TextLabel" {
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size12,
			Size = UDim2.new(0, 30, 0, 30),
			TextColor3 = Color3.new(0, 1, 0),
			ZIndex = baseZIndex + 4,
		}
	end

	local robloxHelpButton = Hydrate(
		createTextButton(
			"Help",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size18,
			UDim2.new(0, 164, 0, 50),
			UDim2.new(0, 82, 0, 256)
		)
	) {
		Name = "HelpButton",
		ZIndex = baseZIndex + 4,
		Parent = gameMainMenuFrame,
		Hydrate(helpShortcutC()) {
			Name = "HelpShortcutText",
			Text = "F1",
			Position = UDim2.new(0, 85, 0, 0),
			Visible = false,
		},
	}
	helpButton = robloxHelpButton

	local helpDialog = createHelpDialog(baseZIndex)
	helpDialog.Parent = gui

	helpButton.MouseButton1Click:connect(function()
		table.insert(centerDialogs, helpDialog)
		GuiService:AddCenterDialog(
			helpDialog,
			Enum.CenterDialogType.ModalDialog,
			--ShowFunction
			function()
				helpDialog.Visible = true
				mainShield.Visible = false
			end,
			--HideFunction
			function()
				helpDialog.Visible = false
			end
		)
	end)
	helpButton.Active = true

	local screenshotButton = Hydrate(
		createTextButton(
			"Screenshot",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size18,
			UDim2.new(0, 168, 0, 50),
			UDim2.new(0, 254, 0, 256)
		)
	) {
		Name = "ScreenshotButton",
		ZIndex = baseZIndex + 4,
		Parent = gameMainMenuFrame,
		Visible = not macClient,
		Hydrate(helpShortcutC()) {
			Name = "ScreenshotShortcutText",
			Text = "PrintSc",
			Position = UDim2.new(0, 118, 0, 0),
			Visible = true,
		},
	}
	screenshotButton:SetVerb "Screenshot"

	local recordVideoButton = Hydrate(
		createTextButton(
			"Record Video",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size18,
			UDim2.new(0, 168, 0, 50),
			UDim2.new(0, 254, 0, 306)
		)
	) {
		Name = "RecordVideoButton",
		ZIndex = baseZIndex + 4,
		Visible = not macClient,
		Parent = gameMainMenuFrame,
		Hydrate(helpShortcutC()) {
			Name = "RecordVideoShortcutText",
			Text = "F12",
			Position = UDim2.new(0, 120, 0, 0),
			Visible = hasGraphicsSlider,
		},
	}
	recordVideoButton:SetVerb "RecordToggle"

	local stopRecordButton = New "ImageButton" {
		Name = "StopRecordButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/RecordStop.png",
		Size = UDim2.new(0, 59, 0, 27),
		Visible = false,
	}
	stopRecordButton:SetVerb "RecordToggle"

	stopRecordButton.MouseButton1Click:connect(function()
		recordVideoClick(recordVideoButton, stopRecordButton)
	end)
	stopRecordButton.Parent = gui

	Hydrate(
		createTextButton(
			"Report Abuse",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size18,
			UDim2.new(0, 164, 0, 50),
			UDim2.new(0, 82, 0, 306)
		)
	) {
		Name = "ReportAbuseButton",
		ZIndex = baseZIndex + 4,
		Parent = gameMainMenuFrame,
	}

	Hydrate(
		createTextButton(
			"Leave Game",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size24,
			UDim2.new(0, 340, 0, 50),
			UDim2.new(0, 82, 0, 358)
		)
	) {
		Name = "LeaveGameButton",
		ZIndex = baseZIndex + 4,
		Parent = gameMainMenuFrame,
	}

	Hydrate(
		createTextButton(
			"Resume Game",
			Enum.ButtonStyle.RobloxButtonDefault,
			Enum.FontSize.Size24,
			UDim2.new(0, 340, 0, 50),
			UDim2.new(0, 82, 0, 54)
		)
	)({
		Name = "resumeGameButton",
		ZIndex = baseZIndex + 4,
		Parent = gameMainMenuFrame,
		Modal = true,
	}).MouseButton1Click:connect(function()
		resumeGameFunction(shield)
	end)

	local gameSettingsButton = Hydrate(
		createTextButton(
			"Game Settings",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size24,
			UDim2.new(0, 340, 0, 50),
			UDim2.new(0, 82, 0, 156)
		)
	) {
		Name = "SettingsButton",
		ZIndex = baseZIndex + 4,
		Parent = gameMainMenuFrame,
	}

	if
		game:FindFirstChild "LoadingGuiService"
		and #game.LoadingGuiService:GetChildren() > 0
	then
		gameSettingsButton = createTextButton(
			"Game Instructions",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size24,
			UDim2.new(0, 340, 0, 50),
			UDim2.new(0, 82, 0, 207)
		)
		gameSettingsButton.Name = "GameInstructions"
		gameSettingsButton.ZIndex = baseZIndex + 4
		gameSettingsButton.Parent = gameMainMenuFrame
		gameSettingsButton.MouseButton1Click:connect(function()
			if game:FindFirstChild "Players" and Players.LocalPlayer then
				local loadingGui =
					Players.LocalPlayer:FindFirstChild "PlayerLoadingGui"
				if loadingGui then
					loadingGui.Visible = true
				end
			end
		end)
	end

	Hydrate(
		createTextButton(
			"Reset Character",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size24,
			UDim2.new(0, 340, 0, 50),
			UDim2.new(0, 82, 0, 105)
		)
	) {
		Name = "ResetButton",
		ZIndex = baseZIndex + 4,
		Parent = gameMainMenuFrame,
	}

	return gameMainMenuFrame
end

local mouseLockLabel, syncVideoCaptureSetting

local function createGameSettingsMenu(baseZIndex: number)
	local function fullscreenShortcut()
		return New "TextLabel" {
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size12,
			Size = UDim2.new(0, 30, 0, 30),
			TextColor3 = Color3.new(0, 1, 0),
			ZIndex = baseZIndex + 4,
		}
	end

	local function qualityTextC()
		return New "TextLabel" {
			Font = Enum.Font.Arial,
			ZIndex = baseZIndex + 4,
			BackgroundTransparency = 1,
			Visible = not inStudioMode,
		}
	end

	local gameSettingsMenuFrame = New "Frame" {
		Name = "GameSettingsMenu",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = baseZIndex + 4,
		New "TextLabel" {
			Name = "Title",
			Text = "Settings",
			Size = UDim2.new(1, 0, 0, 48),
			Position = UDim2.new(0, 9, 0, -9),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = baseZIndex + 4,
			BackgroundTransparency = 1,
		},
		New "TextLabel" {
			Name = "FullscreenText",
			Text = "Fullscreen Mode",
			Size = UDim2.new(0, 124, 0, 18),
			Position = UDim2.new(0, 62, 0, 145),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = baseZIndex + 4,
			BackgroundTransparency = 1,
		},
		Hydrate(fullscreenShortcut()) {
			Name = "FullscreenShortcutText",
			Visible = hasGraphicsSlider,
			Text = "F11",
			Position = UDim2.new(0, 186, 0, 141),
		},
		Hydrate(qualityTextC()) {
			Name = "QualityText",
			Text = "Graphics Quality",
			Position = UDim2.new(0, 30, 0, 239),
			TextColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(0, 128, 0, 18),
			FontSize = Enum.FontSize.Size18,
		},
	}

	local studioText = New "TextLabel" {
		Name = "StudioText",
		Text = "Studio Mode",
		Visible = false,
		Size = UDim2.new(0, 95, 0, 18),
		Position = UDim2.new(0, 62, 0, 179),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		TextColor3 = Color3.new(1, 1, 1),
		ZIndex = baseZIndex + 4,
		BackgroundTransparency = 1,
		Parent = gameSettingsMenuFrame,
	}

	local studioShortcut = Hydrate(fullscreenShortcut()) {
		Name = "StudioShortcutText",
		Text = "F2",
		Visible = false, -- TODO: turn back on when f2 hack is fixed
		Position = UDim2.new(0, 154, 0, 175),
		Parent = gameSettingsMenuFrame,
	}

	local fasterShortcut = Hydrate(fullscreenShortcut()) {
		Name = "FasterShortcutText",
		Text = "Shift + F10",
		Visible = not inStudioMode,
		Position = UDim2.new(0, 185, 0, 283),
		Parent = gameSettingsMenuFrame,
	}

	local betterQualityShortcut = Hydrate(fullscreenShortcut()) {
		Name = "BetterQualityShortcut",
		Text = "F10",
		Position = UDim2.new(0, 394, 0, 288),
		Visible = not inStudioMode,
		Parent = gameSettingsMenuFrame,
	}

	local autoText = Hydrate(qualityTextC()) {
		Name = "AutoText",
		Text = "Auto",
		Position = UDim2.new(0, 183, 0, 214),
		TextColor3 = Color3.new(128 / 255, 128 / 255, 128 / 255),
		Size = UDim2.new(0, 34, 0, 18),
		FontSize = Enum.FontSize.Size18,
		Parent = gameSettingsMenuFrame,
	}

	local fasterText = Hydrate(qualityTextC()) {
		Name = "FasterText",
		Text = "Faster",
		Position = UDim2.new(0, 185, 0, 274),
		TextColor3 = Color3.new(95, 95, 95),
		Size = UDim2.new(0, 34, 0, 18),
		FontSize = Enum.FontSize.Size14,
		Visible = not inStudioMode,
		Parent = gameSettingsMenuFrame,
	}

	local betterQualityText = Hydrate(qualityTextC()) {
		Name = "BetterQualityText",
		Text = "Better Quality",
		TextWrapped = true,
		Size = UDim2.new(0, 41, 0, 28),
		Position = UDim2.new(0, 390, 0, 269),
		TextColor3 = Color3.new(95, 95, 95),
		FontSize = Enum.FontSize.Size14,
		Visible = not inStudioMode,
		Parent = gameSettingsMenuFrame,
	}

	local autoGraphicsButton = Hydrate(
		createTextButton(
			"X",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size18,
			UDim2.new(0, 25, 0, 25),
			UDim2.new(0, 187, 0, 239)
		)
	) {
		Name = "AutoGraphicsButton",
		ZIndex = baseZIndex + 4,
		Visible = not inStudioMode,
		Parent = gameSettingsMenuFrame,
	}

	local graphicsSlider, graphicsLevel: NumberValue = RbxGui.CreateSlider(
		GraphicsQualityLevels,
		150,
		UDim2.new(0, 230, 0, 280)
	) -- graphics - 1 because slider starts at 1 instead of 0

	Hydrate(graphicsSlider) {
		Parent = gameSettingsMenuFrame,
		Visible = not inStudioMode,
	}
	graphicsSlider.Bar.ZIndex = baseZIndex + 4
	graphicsSlider.Bar.Slider.ZIndex = baseZIndex + 5
	graphicsLevel.Value =
		math.floor((settings().Rendering:GetMaxQualityLevel() - 1) / 2)

	local graphicsSetter = New "TextBox" {
		Name = "GraphicsSetter",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderColor3 = Color3.new(128 / 255, 128 / 255, 128 / 255),
		Size = UDim2.new(0, 50, 0, 25),
		Position = UDim2.new(0, 450, 0, 269),
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Text = "Auto",
		ZIndex = 1,
		TextWrapped = true,
		Parent = gameSettingsMenuFrame,
		Visible = not inStudioMode,
	}

	local isAutoGraphics = true
	if not inStudioMode then
		isAutoGraphics = (
			UserSettings().GameSettings.SavedQualityLevel
			== Enum.SavedQualitySetting.Automatic
		)
	else
		settings().Rendering.EnableFRM = false
	end

	local listenToGraphicsLevelChange = true

	local function setAutoGraphicsGui(active)
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

	local function goToAutoGraphics()
		setAutoGraphicsGui(true)

		UserSettings().GameSettings.SavedQualityLevel =
			Enum.SavedQualitySetting.Automatic

		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
	end

	local function setGraphicsQualityLevel(newLevel: number)
		local percentage = newLevel / GraphicsQualityLevels
		local newSetting = math.floor(
			(settings().Rendering:GetMaxQualityLevel() - 1) * percentage
		)
		if newSetting == 20 then -- Level 20 is the same as level 21, except it doesn't render ambient occlusion
			newSetting = 21
		elseif newLevel == 1 then -- make sure we can go to lowest settings (for terrible computers)
			newSetting = 1
		elseif newSetting > settings().Rendering:GetMaxQualityLevel() then
			newSetting = settings().Rendering:GetMaxQualityLevel() - 1
		end

		UserSettings().GameSettings.SavedQualityLevel = newLevel
		settings().Rendering.QualityLevel = newSetting
	end

	local function goToManualGraphics(explicitLevel: number?)
		setAutoGraphicsGui(false)

		graphicsLevel.Value = explicitLevel
			or math.floor(
				(
					settings().Rendering.AutoFRMLevel
					/ (settings().Rendering:GetMaxQualityLevel() - 1)
				) * GraphicsQualityLevels
			)

		if explicitLevel == graphicsLevel.Value then -- make sure we are actually in right graphics mode
			setGraphicsQualityLevel(graphicsLevel.Value)
		end

		if not explicitLevel then
			UserSettings().GameSettings.SavedQualityLevel = graphicsLevel.Value
		end
		graphicsSetter.Text = tostring(graphicsLevel.Value)
	end

	local function showAutoGraphics()
		autoText.ZIndex = baseZIndex + 4
		autoGraphicsButton.ZIndex = baseZIndex + 4
	end

	local function hideAutoGraphics()
		autoText.ZIndex = 1
		autoGraphicsButton.ZIndex = 1
	end

	local function showManualGraphics()
		graphicsSlider.Bar.ZIndex = baseZIndex + 4
		graphicsSlider.Bar.Slider.ZIndex = baseZIndex + 5
		betterQualityShortcut.ZIndex = baseZIndex + 4
		fasterShortcut.ZIndex = baseZIndex + 4
		betterQualityText.ZIndex = baseZIndex + 4
		fasterText.ZIndex = baseZIndex + 4
		graphicsSetter.ZIndex = baseZIndex + 4
	end

	local function hideManualGraphics()
		betterQualityText.ZIndex = 1
		betterQualityShortcut.ZIndex = 1
		fasterShortcut.ZIndex = 1
		fasterText.ZIndex = 1
		graphicsSlider.Bar.ZIndex = 1
		graphicsSlider.Bar.Slider.ZIndex = 1
		graphicsSetter.ZIndex = 1
	end

	local function translateSavedQualityLevelToInt(savedQualityLevel)
		local sqs = Enum.SavedQualitySetting
		if savedQualityLevel == sqs.QualityLevel1 then
			return 1
		elseif savedQualityLevel == sqs.QualityLevel2 then
			return 2
		elseif savedQualityLevel == sqs.QualityLevel3 then
			return 3
		elseif savedQualityLevel == sqs.QualityLevel4 then
			return 4
		elseif savedQualityLevel == sqs.QualityLevel5 then
			return 5
		elseif savedQualityLevel == sqs.QualityLevel6 then
			return 6
		elseif savedQualityLevel == sqs.QualityLevel7 then
			return 7
		elseif savedQualityLevel == sqs.QualityLevel8 then
			return 8
		elseif savedQualityLevel == sqs.QualityLevel9 then
			return 9
		elseif savedQualityLevel == sqs.QualityLevel10 then
			return 10
		end
		return 0
	end

	local function enableGraphicsWidget()
		settings().Rendering.EnableFRM = true

		isAutoGraphics = (
			UserSettings().GameSettings.SavedQualityLevel
			== Enum.SavedQualitySetting.Automatic
		)
		if isAutoGraphics then
			showAutoGraphics()
			goToAutoGraphics()
		else
			showAutoGraphics()
			showManualGraphics()
			goToManualGraphics(
				translateSavedQualityLevelToInt(
					UserSettings().GameSettings.SavedQualityLevel
				)
			)
		end
	end

	local function disableGraphicsWidget()
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
		if newGraphicsValue == nil then
			graphicsSetter.Text = tostring(graphicsLevel.Value)
			return
		end

		if newGraphicsValue < 1 then
			newGraphicsValue = 1
		elseif
			newGraphicsValue >= settings().Rendering:GetMaxQualityLevel()
		then
			newGraphicsValue = settings().Rendering:GetMaxQualityLevel() - 1
		end

		graphicsLevel.Value = newGraphicsValue
		setGraphicsQualityLevel(graphicsLevel.Value)
		graphicsSetter.Text = tostring(graphicsLevel.Value)
	end)

	graphicsLevel.Changed:connect(function(_)
		if isAutoGraphics or not listenToGraphicsLevelChange then
			return
		end

		graphicsSetter.Text = tostring(graphicsLevel.Value)
		setGraphicsQualityLevel(graphicsLevel.Value)
	end)

	-- setup our graphic mode on load
	if
		inStudioMode
		or UserSettings().GameSettings.SavedQualityLevel
			== Enum.SavedQualitySetting.Automatic
	then
		if inStudioMode then
			settings().Rendering.EnableFRM = false
			disableGraphicsWidget()
		else
			settings().Rendering.EnableFRM = true
			goToAutoGraphics()
		end
	else
		settings().Rendering.EnableFRM = true
		goToManualGraphics(
			translateSavedQualityLevelToInt(
				UserSettings().GameSettings.SavedQualityLevel
			)
		)
	end

	autoGraphicsButton.MouseButton1Click:connect(function()
		if inStudioMode and not Players.LocalPlayer then
			return
		elseif not isAutoGraphics then
			goToAutoGraphics()
		else
			goToManualGraphics(graphicsLevel.Value)
		end
	end)

	game.GraphicsQualityChangeRequest:connect(function(graphicsIncrease)
		if isAutoGraphics then -- only can set graphics in manual mode
			return
		elseif graphicsIncrease then
			if (graphicsLevel.Value + 1) > GraphicsQualityLevels then
				return
			end
			graphicsLevel.Value += 1
			graphicsSetter.Text = tostring(graphicsLevel.Value)
			setGraphicsQualityLevel(graphicsLevel.Value)

			GuiService:SendNotification(
				"Graphics Quality",
				`Increased to ({graphicsSetter.Text})`,
				"",
				2,
				function() end
			)
		else
			if (graphicsLevel.Value - 1) <= 0 then
				return
			end
			graphicsLevel.Value -= 1
			graphicsSetter.Text = tostring(graphicsLevel.Value)
			setGraphicsQualityLevel(graphicsLevel.Value)

			GuiService:SendNotification(
				"Graphics Quality",
				`Decreased to ({graphicsSetter.Text})`,
				"",
				2,
				function() end
			)
		end
	end)

	Players.PlayerAdded:connect(function(player)
		if player == Players.LocalPlayer and inStudioMode then
			enableGraphicsWidget()
		end
	end)
	Players.PlayerRemoving:connect(function(player)
		if player == Players.LocalPlayer and inStudioMode then
			disableGraphicsWidget()
		end
	end)

	local studioCheckbox = Hydrate(
		createTextButton(
			"",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size18,
			UDim2.new(0, 25, 0, 25),
			UDim2.new(0, 30, 0, 176)
		)
	) {
		Name = "StudioCheckbox",
		ZIndex = baseZIndex + 4,
		-- Parent, = gameSettingsMenuFrame -- todo: enable when studio h4x aren't an issue anymore
		Visible = false, -- todo: enabled when studio h4x aren't an issue anymore
	}
	studioCheckbox:SetVerb "TogglePlayMode"

	local wasManualGraphics = (
		settings().Rendering.QualityLevel ~= Enum.QualityLevel.Automatic
	)
	if inStudioMode and not Players.LocalPlayer then
		studioCheckbox.Text = "X"
		disableGraphicsWidget()
	elseif inStudioMode then
		studioCheckbox.Text = "X"
		enableGraphicsWidget()
	end
	if hasGraphicsSlider then
		UserSettings().GameSettings.StudioModeChanged:connect(
			function(isStudioMode)
				inStudioMode = isStudioMode
				if isStudioMode then
					wasManualGraphics = (
						settings().Rendering.QualityLevel
						~= Enum.QualityLevel.Automatic
					)
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
			end
		)
	else
		studioCheckbox.MouseButton1Click:connect(function()
			if not studioCheckbox.Active then
				return
			elseif studioCheckbox.Text == "" then
				studioCheckbox.Text = "X"
			else
				studioCheckbox.Text = ""
			end
		end)
	end

	local fullscreenCheckbox = Hydrate(
		createTextButton(
			"",
			Enum.ButtonStyle.RobloxButton,
			Enum.FontSize.Size18,
			UDim2.new(0, 25, 0, 25),
			UDim2.new(0, 30, 0, 144)
		)
	) {
		Name = "FullscreenCheckbox",
		ZIndex = baseZIndex + 4,
	}
	fullscreenCheckbox:SetVerb "ToggleFullScreen"
	if UserSettings().GameSettings:InFullScreen() then
		fullscreenCheckbox.Text = "X"
	end
	if hasGraphicsSlider then
		UserSettings().GameSettings.FullscreenChanged:connect(
			function(isFullscreen)
				fullscreenCheckbox.Text = isFullscreen and "X" or ""
			end
		)
	else
		fullscreenCheckbox.MouseButton1Click:connect(function()
			fullscreenCheckbox.Text = fullscreenCheckbox.Text == "" and "X"
				or ""
		end)
	end
	fullscreenCheckbox.Parent = gameSettingsMenuFrame

	if game:FindFirstChild "NetworkClient" then -- we are playing online
		setDisabledState(studioText)
		setDisabledState(studioShortcut)
		setDisabledState(studioCheckbox)
	end

	local backButton
	if hasGraphicsSlider then
		backButton = createTextButton(
			"OK",
			Enum.ButtonStyle.RobloxButtonDefault,
			Enum.FontSize.Size24,
			UDim2.new(0, 180, 0, 50),
			UDim2.new(0, 170, 0, 330)
		)
		backButton.Modal = true
	else
		backButton = createTextButton(
			"OK",
			Enum.ButtonStyle.RobloxButtonDefault,
			Enum.FontSize.Size24,
			UDim2.new(0, 180, 0, 50),
			UDim2.new(0, 170, 0, 270)
		)
		backButton.Modal = true
	end

	Hydrate(backButton) {
		Name = "BackButton",
		ZIndex = baseZIndex + 4,
		Parent = gameSettingsMenuFrame,
	}

	syncVideoCaptureSetting = nil

	if not macClient then
		New "TextLabel" {
			Name = "VideoCaptureLabel",
			Text = "After Capturing Video",
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0, 32, 0, 100),
			Size = UDim2.new(0, 164, 0, 18),
			BackgroundTransparency = 1,
			TextColor3 = Colour3(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = baseZIndex + 4,
			Parent = gameSettingsMenuFrame,
		}

		local videoNames = {}
		local videoNameToItem = {}
		videoNames[1] = "Just Save to Disk"
		videoNameToItem[videoNames[1]] = Enum.UploadSetting.Never
		videoNames[2] = "Upload to YouTube"
		videoNameToItem[videoNames[2]] = Enum.UploadSetting["Ask me first"]

		local videoCaptureDropDown
		videoCaptureDropDown, updateVideoCaptureDropDownSelection = RbxGui.CreateDropDownMenu(
			videoNames,
			function(text)
				UserSettings().GameSettings.VideoUploadPromptBehavior =
					videoNameToItem[text]
			end
		)

		Hydrate(videoCaptureDropDown) {
			Name = "VideoCaptureField",
			ZIndex = baseZIndex + 4,
			Position = UDim2.new(0, 270, 0, 94),
			Size = UDim2.new(0, 200, 0, 32),
			Parent = gameSettingsMenuFrame,
		}
		videoCaptureDropDown.DropDownMenuButton.ZIndex = baseZIndex + 4
		videoCaptureDropDown.DropDownMenuButton.Icon.ZIndex = baseZIndex + 4

		function syncVideoCaptureSetting()
			if
				UserSettings().GameSettings.VideoUploadPromptBehavior
				== Enum.UploadSetting.Never
			then
				updateVideoCaptureDropDownSelection(videoNames[1])
			elseif
				UserSettings().GameSettings.VideoUploadPromptBehavior
				== Enum.UploadSetting.Ask
			then
				updateVideoCaptureDropDownSelection(videoNames[2])
			else
				UserSettings().GameSettings.VideoUploadPromptBehavior =
					Enum.UploadSetting.Ask
				updateVideoCaptureDropDownSelection(videoNames[2])
			end
		end
	end

	New "TextLabel" {
		Name = "CameraLabel",
		Text = "Character & Camera Controls",
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0, 31, 0, 58),
		Size = UDim2.new(0, 224, 0, 18),
		TextColor3 = Colour3(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		ZIndex = baseZIndex + 4,
		Parent = gameSettingsMenuFrame,
	}

	mouseLockLabel = MercuryGui:FindFirstChild("MouseLockLabel", true)

	local enumItems = Enum.ControlMode:GetEnumItems()
	local enumNames = {}
	local enumNameToItem = {}
	for i, obj in ipairs(enumItems) do
		enumNames[i] = obj.Name
		enumNameToItem[obj.Name] = obj
	end

	local cameraDropDown
	cameraDropDown, updateCameraDropDownSelection = RbxGui.CreateDropDownMenu(
		enumNames,
		function(text)
			UserSettings().GameSettings.ControlMode = enumNameToItem[text]

			pcall(function()
				mouseLockLabel.Visible = mouseLockLabel
					and UserSettings().GameSettings.ControlMode
						== Enum.ControlMode["Mouse Lock Switch"]
			end)
		end
	)

	Hydrate(cameraDropDown) {
		Name = "CameraField",
		ZIndex = baseZIndex + 4,
		Position = UDim2.new(0, 270, 0, 52),
		Size = UDim2.new(0, 200, 0, 32),
		Parent = gameSettingsMenuFrame,
	}
	cameraDropDown.DropDownMenuButton.ZIndex = baseZIndex + 4
	cameraDropDown.DropDownMenuButton.Icon.ZIndex = baseZIndex + 4

	return gameSettingsMenuFrame
end

if not LoadLibrary then
	return
end

RbxGui = LoadLibrary "RbxGui"

GuiService:AddKey "l"
GuiService:AddKey "r"

local baseZIndex = 0
if UserSettings then
	local function createSettingsDialog()
		waitForChild(gui, "BottomLeftControl")
		settingsButton = gui.BottomLeftControl:FindFirstChild "SettingsButton"

		if settingsButton == nil then
			settingsButton = New "ImageButton" {
				Name = "SettingsButton",
				Image = "rbxasset://textures/ui/SettingsButton.png",
				BackgroundTransparency = 1,
				Active = false,
				Size = UDim2.new(0, 54, 0, 46),
				Position = UDim2.new(0, 2, 0, 50),
				Parent = gui.BottomLeftControl,
			}
		end

		local shield = New "TextButton" {
			Text = "",
			Name = "UserSettingsShield",
			Active = true,
			AutoButtonColor = false,
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Colour3(51, 51, 51),
			BorderColor3 = Colour3(27, 42, 53),
			BackgroundTransparency = 0.4,
			ZIndex = baseZIndex + 2,
		}
		mainShield = shield

		local frame = New "Frame" {
			Name = "Settings",
			Position = UDim2.new(0.5, -262, -0.5, -200),
			Size = UDim2.new(0, 525, 0, 430),
			BackgroundTransparency = 1,
			Active = true,
			Parent = shield,
		}

		settingsFrame = New "Frame" {
			Name = "SettingsStyle",
			Size = UDim2.new(1, 0, 1, 0),
			Style = Enum.FrameStyle.RobloxRound,
			Active = true,
			ZIndex = baseZIndex + 3,
			Parent = frame,
		}

		local gameMainMenu = createGameMainMenu(baseZIndex, shield)
		gameMainMenu.Parent = settingsFrame

		gameMainMenu.ScreenshotButton.MouseButton1Click:connect(function()
			backToGame(gameMainMenu.ScreenshotButton, shield, settingsButton)
		end)

		gameMainMenu.RecordVideoButton.MouseButton1Click:connect(function()
			recordVideoClick(
				gameMainMenu.RecordVideoButton,
				gui.StopRecordButton
			)
			backToGame(gameMainMenu.RecordVideoButton, shield, settingsButton)
		end)

		local gameOptions = settings():FindFirstChild "Game Options"
		if gameOptions then
			pcall(function()
				gameOptions.VideoRecordingChangeRequest:connect(
					function(recording)
						recordingVideo = recording
						setRecordGui(
							recording,
							gui.StopRecordButton,
							gameMainMenu.RecordVideoButton
						)
					end
				)
			end)
		end

		MercuryGui.Changed:connect(
			function(prop) -- We have stopped recording when we resize
				if prop == "AbsoluteSize" and recordingVideo then
					recordVideoClick(
						gameMainMenu.RecordVideoButton,
						gui.StopRecordButton
					)
				end
			end
		)

		local function localPlayerChange()
			gameMainMenu.ResetButton.Visible = Players.LocalPlayer
			if Players.LocalPlayer then
				settings().Rendering.EnableFRM = true
			elseif inStudioMode then
				settings().Rendering.EnableFRM = false
			end
		end

		gameMainMenu.ResetButton.Visible = Players.LocalPlayer
		if Players.LocalPlayer ~= nil then
			Players.LocalPlayer.Changed:connect(function()
				localPlayerChange()
			end)
		else
			delay(0, function()
				waitForProperty(Players, "LocalPlayer")
				gameMainMenu.ResetButton.Visible = Players.LocalPlayer
				Players.LocalPlayer.Changed:connect(function()
					localPlayerChange()
				end)
			end)
		end

		gameMainMenu.ReportAbuseButton.Visible =
			game:FindFirstChild "NetworkClient"
		if not gameMainMenu.ReportAbuseButton.Visible then
			game.ChildAdded:connect(function(child)
				if child:IsA "NetworkClient" then
					gameMainMenu.ReportAbuseButton.Visible =
						game:FindFirstChild "NetworkClient"
				end
			end)
		end

		local function confirmReset()
			goToMenu(
				settingsFrame,
				"ResetConfirmationMenu",
				"up",
				UDim2.new(0, 525, 0, 370)
			)
		end

		local function confirmLeave()
			goToMenu(
				settingsFrame,
				"LeaveConfirmationMenu",
				"down",
				UDim2.new(0, 525, 0, 300)
			)
		end

		local hotkeysConn
		local function leaveResetHotkeys(key) -- esc, r, not enter (unfortunately)
			if hotkeysConn then
				hotkeysConn:disconnect()
			end
			if key == "r" then
				confirmReset()
			elseif key == "l" then
				confirmLeave()
			end
		end

		local function showFunction()
			settingsButton.Active = false
			updateCameraDropDownSelection(
				UserSettings().GameSettings.ControlMode.Name
			)

			if syncVideoCaptureSetting then
				syncVideoCaptureSetting()
			end

			goToMenu(
				settingsFrame,
				"GameMainMenu",
				"right",
				UDim2.new(0, 525, 0, 430)
			)
			shield.Visible = true
			shield.Active = true
			settingsFrame.Parent:TweenPosition(
				UDim2.new(0.5, -262, 0.5, -200),
				Enum.EasingDirection.InOut,
				Enum.EasingStyle.Sine,
				tweenTime,
				true
			)
			settingsFrame.Parent:TweenSize(
				UDim2.new(0, 525, 0, 430),
				Enum.EasingDirection.InOut,
				Enum.EasingStyle.Sine,
				tweenTime,
				true
			)
		end

		local function hideFunction()
			settingsFrame.Parent:TweenPosition(
				UDim2.new(0.5, -262, -0.5, -200),
				Enum.EasingDirection.InOut,
				Enum.EasingStyle.Sine,
				tweenTime,
				true
			)
			settingsFrame.Parent:TweenSize(
				UDim2.new(0, 525, 0, 430),
				Enum.EasingDirection.InOut,
				Enum.EasingStyle.Sine,
				tweenTime,
				true
			)
			shield.Visible = false
			settingsButton.Active = true
		end

		gameMainMenu.ResetButton.MouseButton1Click:connect(confirmReset)
		gameMainMenu.LeaveGameButton.MouseButton1Click:connect(confirmLeave)

		GuiService.EscapeKeyPressed:connect(function()
			if hotkeysConn then
				hotkeysConn:disconnect()
			end
			-- Prevent mysterious missing settings menu bugs
			delay(tweenTime, function()
				if hotkeysConn then
					hotkeysConn:disconnect()
				end
				hotkeysConn = GuiService.KeyPressed:connect(leaveResetHotkeys)
			end)
			if currentMenuSelection == nil then
				GuiService:AddCenterDialog(
					shield,
					Enum.CenterDialogType.ModalDialog,
					showFunction,
					hideFunction
				)
			elseif #lastMenuSelection > 0 then
				if #centerDialogs > 0 then
					for i = 1, #centerDialogs do
						GuiService:RemoveCenterDialog(centerDialogs[i])
						centerDialogs[i].Visible = false
					end
					centerDialogs = {}
				end

				goToMenu(
					lastMenuSelection[#lastMenuSelection].container,
					lastMenuSelection[#lastMenuSelection].name,
					lastMenuSelection[#lastMenuSelection].direction,
					lastMenuSelection[#lastMenuSelection].lastSize
				)

				table.remove(lastMenuSelection, #lastMenuSelection)
				if #lastMenuSelection == 1 then -- apparently lua can't reduce count to 0... T_T
					lastMenuSelection = {}
				end
			else
				resumeGameFunction(shield)
			end
		end)

		local gameSettingsMenu = createGameSettingsMenu(baseZIndex, shield)
		gameSettingsMenu.Visible = false
		gameSettingsMenu.Parent = settingsFrame

		gameMainMenu.SettingsButton.MouseButton1Click:connect(function()
			goToMenu(
				settingsFrame,
				"GameSettingsMenu",
				"left",
				UDim2.new(0, 525, 0, 350)
			)
		end)

		gameSettingsMenu.BackButton.MouseButton1Click:connect(function()
			goToMenu(
				settingsFrame,
				"GameMainMenu",
				"right",
				UDim2.new(0, 525, 0, 430)
			)
		end)

		local resetConfirmationWindow =
			createResetConfirmationMenu(baseZIndex, shield)
		resetConfirmationWindow.Visible = false
		resetConfirmationWindow.Parent = settingsFrame

		local leaveConfirmationWindow =
			createLeaveConfirmationMenu(baseZIndex, shield)
		leaveConfirmationWindow.Visible = false
		leaveConfirmationWindow.Parent = settingsFrame

		robloxLock(shield)

		settingsButton.MouseButton1Click:connect(function()
			GuiService:AddCenterDialog(
				shield,
				Enum.CenterDialogType.ModalDialog,
				--showFunction
				function()
					settingsButton.Active = false
					updateCameraDropDownSelection(
						UserSettings().GameSettings.ControlMode.Name
					)

					if syncVideoCaptureSetting then
						syncVideoCaptureSetting()
					end

					goToMenu(
						settingsFrame,
						"GameMainMenu",
						"right",
						UDim2.new(0, 525, 0, 430)
					)
					shield.Visible = true
					settingsFrame.Parent:TweenPosition(
						UDim2.new(0.5, -262, 0.5, -200),
						Enum.EasingDirection.InOut,
						Enum.EasingStyle.Sine,
						tweenTime,
						true
					)
					settingsFrame.Parent:TweenSize(
						UDim2.new(0, 525, 0, 430),
						Enum.EasingDirection.InOut,
						Enum.EasingStyle.Sine,
						tweenTime,
						true
					)
				end,
				--hideFunction
				function()
					settingsFrame.Parent:TweenPosition(
						UDim2.new(0.5, -262, -0.5, -200),
						Enum.EasingDirection.InOut,
						Enum.EasingStyle.Sine,
						tweenTime,
						true
					)
					settingsFrame.Parent:TweenSize(
						UDim2.new(0, 525, 0, 430),
						Enum.EasingDirection.InOut,
						Enum.EasingStyle.Sine,
						tweenTime,
						true
					)
					shield.Visible = false
					settingsButton.Active = true
				end
			)
		end)

		return shield
	end

	delay(0, function()
		createSettingsDialog().Parent = gui

		gui.BottomLeftControl.SettingsButton.Active = true
		gui.BottomLeftControl.SettingsButton.Position = UDim2.new(0, 2, 0, -2)

		if
			mouseLockLabel
			and UserSettings().GameSettings.ControlMode
				== Enum.ControlMode["Mouse Lock Switch"]
		then
			mouseLockLabel.Visible = true
		elseif mouseLockLabel then
			mouseLockLabel.Visible = false
		end

		-- our script has loaded, get rid of older buttons now
		local leaveGameButton = gui.BottomLeftControl:FindFirstChild "Exit"
		if leaveGameButton then
			leaveGameButton:Remove()
		end

		local topLeft = gui:FindFirstChild "TopLeftControl"
		if topLeft then
			leaveGameButton = topLeft:FindFirstChild "Exit"
			if leaveGameButton then
				leaveGameButton:Remove()
			end

			topLeft:Remove()
		end
	end)
end --UserSettings call

local function createSaveDialogs()
	local shield = New "TextButton" {
		Text = "",
		AutoButtonColor = false,
		Name = "SaveDialogShield",
		Active = true,
		Visible = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Colour3(51, 51, 51),
		BorderColor3 = Colour3(27, 42, 53),
		BackgroundTransparency = 0.4,
		ZIndex = baseZIndex + 1,
	}

	local clearAndResetDialog
	local save
	local saveLocal
	local dontSave
	local cancel

	local messageBoxButtons = {
		{
			Text = "Save",
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Function = function()
				save()
			end,
		},
		{
			Text = "Cancel",
			Function = function()
				cancel()
			end,
		},
		{
			Text = "Don't Save",
			Function = function()
				dontSave()
			end,
		},
	}

	local saveDialogMessageBox = RbxGui.CreateStyledMessageDialog(
		"Unsaved Changes",
		"Save your changes to Mercury before leaving?",
		"Confirm",
		messageBoxButtons
	)
	Hydrate(saveDialogMessageBox) {
		Visible = true,
		Parent = shield,
	}

	local errorBoxButtons = {}

	local buttonOffset = 1
	if game.LocalSaveEnabled then
		errorBoxButtons[buttonOffset] = {}
		errorBoxButtons[buttonOffset].Text = "Save to Disk"
		errorBoxButtons[buttonOffset].Function = function()
			saveLocal()
		end
		buttonOffset += 1
	end
	errorBoxButtons[buttonOffset] = {}
	errorBoxButtons[buttonOffset].Text = "Keep Playing"
	errorBoxButtons[buttonOffset].Function = function()
		cancel()
	end
	errorBoxButtons[buttonOffset + 1] = {}
	errorBoxButtons[buttonOffset + 1].Text = "Don't Save"
	errorBoxButtons[buttonOffset + 1].Function = function()
		dontSave()
	end

	local errorDialogMessageBox = RbxGui.CreateStyledMessageDialog(
		"Upload Failed",
		"Sorry, we could not save your changes to Mercury.",
		"Error",
		errorBoxButtons
	)
	errorDialogMessageBox.Visible = false
	errorDialogMessageBox.Parent = shield

	local spinnerDialog = New "Frame" {
		Name = "SpinnerDialog",
		Style = Enum.FrameStyle.RobloxRound,
		Size = UDim2.new(0, 350, 0, 150),
		Position = UDim2.new(0.5, -175, 0.5, -75),
		Visible = false,
		Active = true,
		Parent = shield,
		New "TextLabel" {
			Name = "WaitingLabel",
			Text = "Saving to Mercury...",
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0.5, 25, 0.5, 0),
			TextColor3 = Color3.new(1, 1, 1),
		},
	}

	local spinnerFrame = New "Frame" {
		Name = "Spinner",
		Size = UDim2.new(0, 80, 0, 80),
		Position = UDim2.new(0.5, -150, 0.5, -40),
		BackgroundTransparency = 1,
		Parent = spinnerDialog,
	}

	local spinnerIcons = {}
	for i = 1, 8 do
		table.insert(
			spinnerIcons,
			New "ImageLabel" {
				Name = "Spinner" .. i,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(
					0.5 + 0.3 * math.cos(math.rad(45 * i)),
					-8,
					0.5 + 0.3 * math.sin(math.rad(45 * i)),
					-8
				),
				BackgroundTransparency = 1,
				Image = path "asset?id=45880710",
				Parent = spinnerFrame,
			}
		)
	end

	function save()
		saveDialogMessageBox.Visible = false

		--Show the spinner dialog
		spinnerDialog.Visible = true
		local spin = true
		--Make it spin
		delay(0, function()
			local spinPos = 0
			while spin do
				local pos = 0

				while pos < 8 do
					spinnerIcons[pos + 1].Image = (
						pos == spinPos or pos == ((spinPos + 1) % 8)
					)
							and path "asset?id=45880668"
						or path "asset?id=45880710"

					pos += 1
				end
				spinPos = (spinPos + 1) % 8
				wait(0.2)
			end
		end)

		--Do the save while the spinner is going, function will wait
		local result = game:SaveToRoblox()
		if not result then
			--Try once more
			result = game:SaveToRoblox()
		end

		--Hide the spinner dialog
		spinnerDialog.Visible = false
		--And cause the delay thread to stop
		spin = false

		--Now process the result
		if result then
			--Success, close
			game:FinishShutdown(false)
			clearAndResetDialog()
		else
			--Failure, show the second dialog prompt
			errorDialogMessageBox.Visible = true
		end
	end

	function saveLocal()
		errorDialogMessageBox.Visible = false
		game:FinishShutdown(true)
		clearAndResetDialog()
	end

	function dontSave()
		saveDialogMessageBox.Visible = false
		errorDialogMessageBox.Visible = false
		game:FinishShutdown(false)
		clearAndResetDialog()
	end
	function cancel()
		saveDialogMessageBox.Visible = false
		errorDialogMessageBox.Visible = false
		clearAndResetDialog()
	end

	function clearAndResetDialog()
		saveDialogMessageBox.Visible = true
		errorDialogMessageBox.Visible = false
		spinnerDialog.Visible = false
		shield.Visible = false
		GuiService:RemoveCenterDialog(shield)
	end

	robloxLock(shield)
	shield.Visible = false
	return shield
end

local function createReportAbuseDialog()
	--Only show things if we are a NetworkClient
	waitForChild(game, "NetworkClient")

	waitForChild(game, "Players")
	waitForProperty(Players, "LocalPlayer")
	local localPlayer = Players.LocalPlayer

	local reportAbuseButton
	waitForChild(gui, "UserSettingsShield")
	waitForChild(gui.UserSettingsShield, "Settings")
	waitForChild(gui.UserSettingsShield.Settings, "SettingsStyle")
	waitForChild(gui.UserSettingsShield.Settings.SettingsStyle, "GameMainMenu")
	waitForChild(
		gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu,
		"ReportAbuseButton"
	)
	reportAbuseButton =
		gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.ReportAbuseButton

	local shield = New "TextButton" {
		Name = "ReportAbuseShield",
		Text = "",
		AutoButtonColor = false,
		Active = true,
		Visible = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Colour3(51, 51, 51),
		BorderColor3 = Colour3(27, 42, 53),
		BackgroundTransparency = 0.4,
		ZIndex = baseZIndex + 1,
	}

	local closeAndResetDialog

	local messageBoxButtons = {
		{
			Text = "Ok",
			Modal = true,
			Function = function()
				closeAndResetDialog()
			end,
		},
	}

	local calmingMessageBox = Hydrate(
		RbxGui.CreateMessageDialog(
			"Thanks for your report!",
			"Our moderators will review the chat logs and determine what happened. The other user is probably just trying to make you mad.\n\nIf anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats",
			messageBoxButtons
		)
	) {
		Visible = false,
		Parent = shield,
	}

	local recordedMessageBox = Hydrate(
		RbxGui.CreateMessageDialog(
			"Thanks for your report!",
			"We've recorded your report for evaluation.",
			messageBoxButtons
		)
	) {
		Visible = false,
		Parent = shield,
	}

	local normalMessageBox = Hydrate(
		RbxGui.CreateMessageDialog(
			"Thanks for your report!",
			"Our moderators will review the chat logs and determine what happened.",
			messageBoxButtons
		)
	) {
		Visible = false,
		Parent = shield,
	}

	local frame = New "Frame" {
		Name = "Settings",
		Position = UDim2.new(0.5, -250, 0.5, -200),
		Size = UDim2.new(0, 500, 0, 400),
		BackgroundTransparency = 1,
		Active = true,
		Parent = shield,
	}

	local abusingPlayer
	local abuse
	local submitReportButton

	local abuses = {
		"Swearing",
		"Bullying",
		"Scamming",
		"Dating",
		"Cheating/Exploiting",
		"Personal Questions",
		"Offsite Links",
		"Bad Model or Script",
		"Bad Username",
	}
	local abuseDropDown, updateAbuseSelection = RbxGui.CreateDropDownMenu(
		abuses,
		function(abuseText)
			abuse = abuseText
			if abuse and abusingPlayer then
				submitReportButton.Active = true
			end
		end,
		true
	)

	local reportAbuseFrame = New "Frame" {
		Name = "ReportAbuseStyle",
		Size = UDim2.new(1, 0, 1, 0),
		Style = Enum.FrameStyle.RobloxRound,
		Active = true,
		ZIndex = baseZIndex + 1,
		Parent = frame,
		New "TextLabel" {
			Name = "Title",
			Text = "Report Abuse",
			TextColor3 = Colour3(221, 221, 221),
			Position = UDim2.new(0.5, 0, 0, 30),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			ZIndex = baseZIndex + 2,
		},
		New "TextLabel" {
			Name = "Description",
			Text = "This will send a complete report to a moderator. The moderator will review the chat log and take appropriate action.",
			TextColor3 = Colour3(221, 221, 221),
			Position = UDim2.new(0, 0, 0, 55),
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			TextWrapped = true,
			ZIndex = baseZIndex + 2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		},
		New "TextLabel" {
			Name = "PlayerLabel",
			Text = "Which player?",
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0.025, 0, 0, 100),
			Size = UDim2.new(0.4, 0, 0, 36),
			TextColor3 = Colour3(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = baseZIndex + 2,
		},
		New "TextLabel" {
			Name = "AbuseLabel",
			Text = "Type of Abuse:",
			Font = Enum.Font.Arial,
			BackgroundTransparency = 1,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0.025, 0, 0, 140),
			Size = UDim2.new(0.4, 0, 0, 36),
			TextColor3 = Colour3(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = baseZIndex + 2,
		},
		Hydrate(abuseDropDown) {
			Name = "AbuseComboBox",
			ZIndex = baseZIndex + 2,
			Position = UDim2.new(0.425, 0, 0, 142),
			Size = UDim2.new(0.55, 0, 0, 32),
		},
		New "TextLabel" {
			Name = "ShortDescriptionLabel",
			Text = "Short Description: (optional)",
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0.025, 0, 0, 180),
			Size = UDim2.new(0.95, 0, 0, 36),
			TextColor3 = Colour3(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			ZIndex = baseZIndex + 2,
		},
	}

	local updatePlayerSelection
	local function createPlayersDropDown()
		local playerNames = {}
		local nameToPlayer = {}
		local children = Players:GetChildren()
		local pos = 1
		if children then
			for _, player in ipairs(children) do
				if player:IsA "Player" and player ~= localPlayer then
					playerNames[pos] = player.Name
					nameToPlayer[player.Name] = player
					pos += 1
				end
			end
		end
		local playerDropDown
		playerDropDown, updatePlayerSelection = RbxGui.CreateDropDownMenu(
			playerNames,
			function(playerName)
				abusingPlayer = nameToPlayer[playerName]
				if abuse and abusingPlayer then
					submitReportButton.Active = true
				end
			end
		)

		return Hydrate(playerDropDown) {
			Name = "PlayersComboBox",
			ZIndex = baseZIndex + 2,
			Position = UDim2.new(0.425, 0, 0, 102),
			Size = UDim2.new(0.55, 0, 0, 32),
		}
	end

	local shortDescriptionWrapper = New "Frame" {
		Name = "ShortDescriptionWrapper",
		Position = UDim2.new(0.025, 0, 0, 220),
		Size = UDim2.new(0.95, 0, 1, -310),
		BackgroundColor3 = Colour3(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = baseZIndex + 2,
		Parent = reportAbuseFrame,
	}

	local shortDescriptionBox = New "TextBox" {
		Name = "TextBox",
		Text = "",
		ClearTextOnFocus = false,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0, 3, 0, 3),
		Size = UDim2.new(1, -6, 1, -6),
		TextColor3 = Colour3(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundColor3 = Colour3(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = baseZIndex + 2,
		Parent = shortDescriptionWrapper,
	}

	submitReportButton = New "TextButton" {
		Name = "SubmitReportBtn",
		Active = false,
		Modal = true,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.1, 0, 1, -80),
		Size = UDim2.new(0.35, 0, 0, 50),
		AutoButtonColor = true,
		Style = Enum.ButtonStyle.RobloxButtonDefault,
		Text = "Submit Report",
		TextColor3 = Colour3(255, 255, 255),
		ZIndex = baseZIndex + 2,
		Parent = reportAbuseFrame,
	}

	submitReportButton.MouseButton1Click:connect(function()
		if submitReportButton.Active then
			if abuse and abusingPlayer then
				frame.Visible = false
				Players:ReportAbuse(
					abusingPlayer,
					abuse,
					shortDescriptionBox.Text
				)
				if abuse == "Cheating/Exploiting" then
					recordedMessageBox.Visible = true
				elseif abuse == "Bullying" or abuse == "Swearing" then
					calmingMessageBox.Visible = true
				else
					normalMessageBox.Visible = true
				end
			else
				closeAndResetDialog()
			end
		end
	end)

	local cancelButton = New "TextButton" {
		Name = "CancelBtn",
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.55, 0, 1, -80),
		Size = UDim2.new(0.35, 0, 0, 50),
		AutoButtonColor = true,
		Style = Enum.ButtonStyle.RobloxButtonDefault,
		Text = "Cancel",
		TextColor3 = Colour3(255, 255, 255),
		ZIndex = baseZIndex + 2,
		Parent = reportAbuseFrame,
	}

	function closeAndResetDialog()
		-- Delete old player combo box
		local oldComboBox = reportAbuseFrame:FindFirstChild "PlayersComboBox"
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
		GuiService:RemoveCenterDialog(shield)
	end

	cancelButton.MouseButton1Click:connect(closeAndResetDialog)

	reportAbuseButton.MouseButton1Click:connect(function()
		createPlayersDropDown().Parent = reportAbuseFrame
		table.insert(centerDialogs, shield)
		GuiService:AddCenterDialog(
			shield,
			Enum.CenterDialogType.ModalDialog,
			--ShowFunction
			function()
				reportAbuseButton.Active = false
				shield.Visible = true
				mainShield.Visible = false
			end,
			--HideFunction
			function()
				reportAbuseButton.Active = true
				shield.Visible = false
			end
		)
	end)

	robloxLock(shield)
	return shield
end

--Spawn a thread for the Save dialogs
local isSaveDialogSupported = pcall(function()
	-- local var = game.LocalSaveEnabled
end)
if isSaveDialogSupported then
	delay(0, function()
		local saveDialogs = createSaveDialogs()
		saveDialogs.Parent = gui

		function game.RequestShutdown()
			table.insert(centerDialogs, saveDialogs)
			GuiService:AddCenterDialog(
				saveDialogs,
				Enum.CenterDialogType.QuitDialog,
				--ShowFunction
				function()
					saveDialogs.Visible = true
				end,
				--HideFunction
				function()
					saveDialogs.Visible = false
				end
			)

			return true
		end
	end)
end

--Spawn a thread for the Report Abuse dialogs
delay(0, function()
	createReportAbuseDialog().Parent = gui
	waitForChild(gui, "UserSettingsShield")
	waitForChild(gui.UserSettingsShield, "Settings")
	waitForChild(gui.UserSettingsShield.Settings, "SettingsStyle")
	waitForChild(gui.UserSettingsShield.Settings.SettingsStyle, "GameMainMenu")
	waitForChild(
		gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu,
		"ReportAbuseButton"
	)
	gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.ReportAbuseButton.Active =
		true
end)
