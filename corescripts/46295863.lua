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
local gui
if script.Parent:FindFirstChild("ControlFrame") then
	gui = script.Parent:FindFirstChild("ControlFrame")
else
	gui = script.Parent
end

local helpButton = nil
local updateCameraDropDownSelection = nil
local updateVideoCaptureDropDownSelection = nil
local tweenTime = 0.2

local mouseLockLookScreenUrl = "http://www.roblox.com/asset?id=54071825"
local classicLookScreenUrl = "http://www.roblox.com/Asset?id=45915798"

local hasGraphicsSlider = (game:GetService("CoreGui").Version >= 5)
local GraphicsQualityLevels = 10 -- how many levels we allow on graphics slider
local recordingVideo = false

local currentMenuSelection = nil
local lastMenuSelection = {}

local defaultPosition = UDim2.new(0,0,0,0)
local newGuiPlaces = {0,41324860}

local centerDialogs = {}
local mainShield = nil

local inStudioMode = UserSettings().GameSettings:InStudioMode()

local macClient = false
local success, isMac = pcall(function() return not game.GuiService.IsWindows end)
macClient = success and isMac

local function Color3I(r,g,b)
  return Color3.new(r/255,g/255,b/255)
end

local function robloxLock(instance)
  instance.RobloxLocked = true
  children = instance:GetChildren()
  if children then
	 for i, child in ipairs(children) do
		robloxLock(child)
	 end
  end
end

function resumeGameFunction(shield)
	shield.Settings:TweenPosition(UDim2.new(0.5, -262,-0.5, -200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
	delay(tweenTime,function()
		shield.Visible = false
		for i = 1, #centerDialogs do
			centerDialogs[i].Visible = false
			game.GuiService:RemoveCenterDialog(centerDialogs[i])
		end
		game.GuiService:RemoveCenterDialog(shield)
		settingsButton.Active = true
		currentMenuSelection = nil
		lastMenuSelection = {}		
	end)
end

function goToMenu(container,menuName, moveDirection,size,position)
	if type(menuName) ~= "string" then return end
	
	table.insert(lastMenuSelection,currentMenuSelection)
	if menuName == "GameMainMenu" then
		lastMenuSelection = {}
	end

	local containerChildren = container:GetChildren()
	local selectedMenu = false
	for i = 1, #containerChildren do
		if containerChildren[i].Name == menuName then
			containerChildren[i].Visible = true
			currentMenuSelection = {container = container,name = menuName, direction = moveDirection, lastSize = size}
			selectedMenu = true
			if size and position then
				containerChildren[i]:TweenSizeAndPosition(size,position,Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
			elseif size then
				containerChildren[i]:TweenSizeAndPosition(size,UDim2.new(0.5,-size.X.Offset/2,0.5,-size.Y.Offset/2),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
			else
				containerChildren[i]:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
			end
		else
			if moveDirection == "left" then
				containerChildren[i]:TweenPosition(UDim2.new(-1,-525,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
			elseif moveDirection == "right" then
				containerChildren[i]:TweenPosition(UDim2.new(1,525,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
			elseif moveDirection == "up" then
				containerChildren[i]:TweenPosition(UDim2.new(0,0,-1,-400),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
			elseif moveDirection == "down" then
				containerChildren[i]:TweenPosition(UDim2.new(0,0,1,400),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
			end
			delay(tweenTime,function()
				containerChildren[i].Visible = false
			end)
		end
	end	
end

function resetLocalCharacter()
	local player = game.Players.LocalPlayer
	if player then
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.Health = 0
		end
	end
end

local function createTextButton(text,style,fontSize,buttonSize,buttonPosition)
	local newTextButton = Instance.new("TextButton")
	newTextButton.Font = Enum.Font.Arial
	newTextButton.FontSize = fontSize
	newTextButton.Size = buttonSize
	newTextButton.Position = buttonPosition
	newTextButton.Style = style
	newTextButton.TextColor3 = Color3.new(1,1,1)
	newTextButton.Text = text
	return newTextButton
end

local function CreateTextButtons(frame, buttons, yPos, ySize)
	if #buttons < 1 then
		error("Must have more than one button")
	end

	local buttonNum = 1
	local buttonObjs = {}

	local function toggleSelection(button)
		for i, obj in ipairs(buttonObjs) do
			if obj == button then
				obj.Style = Enum.ButtonStyle.RobloxButtonDefault
			else
				obj.Style = Enum.ButtonStyle.RobloxButton
			end
		end
	end

	for i, obj in ipairs(buttons) do 
		local button = Instance.new("TextButton")
		button.Name = "Button" .. buttonNum
		button.Font = Enum.Font.Arial
		button.FontSize = Enum.FontSize.Size18
		button.AutoButtonColor = true
		button.Style = Enum.ButtonStyle.RobloxButton
		button.Text = obj.Text
		button.TextColor3 = Color3.new(1,1,1)
		button.MouseButton1Click:connect(function() toggleSelection(button) obj.Function() end)
		button.Parent = frame
		buttonObjs[buttonNum] = button

		buttonNum = buttonNum + 1
	end
	
	toggleSelection(buttonObjs[1])

	local numButtons = buttonNum-1

	if numButtons == 1 then
		frame.Button1.Position = UDim2.new(0.35, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(.4,0,ySize.Scale, ySize.Offset)
	elseif numButtons == 2 then
		frame.Button1.Position = UDim2.new(0.1, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(.35,0, ySize.Scale, ySize.Offset)

		frame.Button2.Position = UDim2.new(0.55, 0, yPos.Scale, yPos.Offset)
		frame.Button2.Size = UDim2.new(.35,0, ySize.Scale, ySize.Offset)
	elseif numButtons >= 3 then
		local spacing = .1 / numButtons
		local buttonSize = .9 / numButtons

		buttonNum = 1
		while buttonNum <= numButtons do
			buttonObjs[buttonNum].Position = UDim2.new(spacing*buttonNum + (buttonNum-1) * buttonSize, 0, yPos.Scale, yPos.Offset)
			buttonObjs[buttonNum].Size = UDim2.new(buttonSize, 0, ySize.Scale, ySize.Offset)
			buttonNum = buttonNum + 1
		end
	end
end

function setRecordGui(recording, stopRecordButton, recordVideoButton)
	if recording then 
		stopRecordButton.Visible = true
		recordVideoButton.Text = "Stop Recording"
	else
		stopRecordButton.Visible = false
		recordVideoButton.Text = "Record Video"
	end
end

function recordVideoClick(recordVideoButton, stopRecordButton)
	recordingVideo = not recordingVideo
	setRecordGui(recordingVideo, stopRecordButton, recordVideoButton)
end

function backToGame(buttonClicked, shield, settingsButton)
	buttonClicked.Parent.Parent.Parent.Parent.Visible = false
	shield.Visible = false
	for i = 1, #centerDialogs do
		game.GuiService:RemoveCenterDialog(centerDialogs[i])
		centerDialogs[i].Visible = false
	end
	centerDialogs = {}
	game.GuiService:RemoveCenterDialog(shield)
	settingsButton.Active = true
end

function setDisabledState(guiObject)
	if not guiObject then return end
	
	if guiObject:IsA("TextLabel") then
		guiObject.TextTransparency = 0.9
	elseif guiObject:IsA("TextButton") then
		guiObject.TextTransparency = 0.9
		guiObject.Active = false
	else
		if guiObject["ClassName"] then
			print("setDisabledState() got object of unsupported type.  object type is ",guiObject.ClassName)
		end
	end
end

local function createHelpDialog(baseZIndex)

	if helpButton == nil then
		if gui:FindFirstChild("TopLeftControl") and gui.TopLeftControl:FindFirstChild("Help") then
			helpButton = gui.TopLeftControl.Help
		elseif gui:FindFirstChild("BottomRightControl") and gui.BottomRightControl:FindFirstChild("Help") then
			helpButton = gui.BottomRightControl.Help
		end
	end

	local shield = Instance.new("Frame")
	shield.Name = "HelpDialogShield"
	shield.Active = true
	shield.Visible = false
	shield.Size = UDim2.new(1,0,1,0)
	shield.BackgroundColor3 = Color3I(51,51,51)
	shield.BorderColor3 = Color3I(27,42,53)
	shield.BackgroundTransparency = 0.4
	shield.ZIndex = baseZIndex + 1

	local helpDialog = Instance.new("Frame")
	helpDialog.Name = "HelpDialog"
	helpDialog.Style = Enum.FrameStyle.RobloxRound
	helpDialog.Position = UDim2.new(.2, 0, .2, 0)
	helpDialog.Size = UDim2.new(0.6, 0, 0.6, 0)
	helpDialog.Active = true
	helpDialog.Parent = shield

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Text = "Keyboard & Mouse Controls"
	titleLabel.Font = Enum.Font.ArialBold
	titleLabel.FontSize = Enum.FontSize.Size36
	titleLabel.Position = UDim2.new(0, 0, 0.025, 0)
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.TextColor3 = Color3.new(1,1,1)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Parent = helpDialog

	local buttonRow = Instance.new("Frame")
	buttonRow.Name = "Buttons"
	buttonRow.Position = UDim2.new(0.1, 0, .07, 40)
	buttonRow.Size = UDim2.new(0.8, 0, 0, 45)
	buttonRow.BackgroundTransparency = 1
	buttonRow.Parent = helpDialog

	local imageFrame = Instance.new("Frame")
	imageFrame.Name = "ImageFrame"
	imageFrame.Position = UDim2.new(0.05, 0, 0.075, 80)
	imageFrame.Size = UDim2.new(0.9, 0, .9, -120)
	imageFrame.BackgroundTransparency = 1
	imageFrame.Parent = helpDialog

	local layoutFrame = Instance.new("Frame")
	layoutFrame.Name = "LayoutFrame"
	layoutFrame.Position = UDim2.new(0.5, 0, 0, 0)
	layoutFrame.Size = UDim2.new(1.5, 0, 1, 0)
	layoutFrame.BackgroundTransparency = 1
	layoutFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	layoutFrame.Parent = imageFrame

	local image = Instance.new("ImageLabel")
	image.Name = "Image"
	if UserSettings().GameSettings.ControlMode == Enum.ControlMode["Mouse Lock Switch"] then
		image.Image = mouseLockLookScreenUrl
	else
		image.Image = classicLookScreenUrl
	end
	image.Position = UDim2.new(-0.5, 0, 0, 0)
	image.Size = UDim2.new(1, 0, 1, 0)
	image.BackgroundTransparency = 1
	image.Parent = layoutFrame
	
	local buttons = {}
	buttons[1] = {}
	buttons[1].Text = "Look"
	buttons[1].Function = function()
		if UserSettings().GameSettings.ControlMode == Enum.ControlMode["Mouse Lock Switch"] then
			image.Image = mouseLockLookScreenUrl
		else
			image.Image = classicLookScreenUrl
		end
	end 
	buttons[2] = {}
	buttons[2].Text = "Move"
	buttons[2].Function = function() 
		image.Image = "http://www.roblox.com/Asset?id=45915811"
	end 
	buttons[3] = {}
	buttons[3].Text = "Gear"
	buttons[3].Function = function() 
		image.Image = "http://www.roblox.com/Asset?id=45917596"
	end
	buttons[4] = {}
	buttons[4].Text = "Zoom"
	buttons[4].Function = function() 	
		image.Image = "http://www.roblox.com/Asset?id=45915825"
	end 

	CreateTextButtons(buttonRow, buttons, UDim.new(0, 0), UDim.new(1,0))
	
		
	-- set up listeners for type of mouse mode, but keep constructing gui at same time
	delay(0, function()
		waitForChild(gui,"UserSettingsShield")
		waitForChild(gui.UserSettingsShield,"Settings")
		waitForChild(gui.UserSettingsShield.Settings,"SettingsStyle")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle, "GameSettingsMenu")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu, "CameraField")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField, "DropDownMenuButton")
		gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Changed:connect(function(prop)
			if prop ~= "Text" then return end
			if buttonRow.Button1.Style == Enum.ButtonStyle.RobloxButtonDefault then -- only change if this is the currently selected panel
				if gui.UserSettingsShield.Settings.SettingsStyle.GameSettingsMenu.CameraField.DropDownMenuButton.Text == "Classic" then
					image.Image = classicLookScreenUrl
				else
					image.Image = mouseLockLookScreenUrl
				end
			end
		end)
	end)


	local okBtn = Instance.new("TextButton")
	okBtn.Name = "OkBtn"
	okBtn.Text = "OK"
	okBtn.Modal = true
	okBtn.Size = UDim2.new(0.3, 0, 0, 45)
	okBtn.Position = UDim2.new(0.35, 0, .975, -50)
	okBtn.Font = Enum.Font.Arial
	okBtn.FontSize = Enum.FontSize.Size18
	okBtn.BackgroundTransparency = 1
	okBtn.TextColor3 = Color3.new(1,1,1)
	okBtn.Style = Enum.ButtonStyle.RobloxButtonDefault
	okBtn.MouseButton1Click:connect(
		function()
			shield.Visible = false
			game.GuiService:RemoveCenterDialog(shield)
		end)
	okBtn.Parent = helpDialog

	robloxLock(shield)
	return shield
end

local function createLeaveConfirmationMenu(baseZIndex,shield)
	local frame = Instance.new("Frame")
	frame.Name = "LeaveConfirmationMenu"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1,0,1,0)
	frame.Position = UDim2.new(0,0,2,400)
	frame.ZIndex = baseZIndex + 4
	
	local yesButton = createTextButton("Leave",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,313,0.8,0))
	yesButton.Name = "YesButton"
	yesButton.ZIndex = baseZIndex + 4
	yesButton.Parent = frame
	yesButton.Modal = true
	yesButton:SetVerb("Exit")
	
	local noButton = createTextButton("Stay",Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,90,0.8,0))
	noButton.Name = "NoButton"
	noButton.Parent = frame
	noButton.ZIndex = baseZIndex + 4
	noButton.MouseButton1Click:connect(function()
		goToMenu(shield.Settings.SettingsStyle,"GameMainMenu","down",UDim2.new(0,525,0,430))
		shield.Settings:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
	end)
	
	local leaveText = Instance.new("TextLabel")
	leaveText.Name = "LeaveText"
	leaveText.Text = "Leave this game?"
	leaveText.Size = UDim2.new(1,0,0.8,0)
	leaveText.TextWrap = true
	leaveText.TextColor3 = Color3.new(1,1,1)
	leaveText.Font = Enum.Font.ArialBold
	leaveText.FontSize = Enum.FontSize.Size36
	leaveText.BackgroundTransparency = 1
	leaveText.ZIndex = baseZIndex + 4
	leaveText.Parent = frame
	
	return frame
end

local function createResetConfirmationMenu(baseZIndex,shield)
	local frame = Instance.new("Frame")
	frame.Name = "ResetConfirmationMenu"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1,0,1,0)
	frame.Position = UDim2.new(0,0,2,400)
	frame.ZIndex = baseZIndex + 4
	
	local yesButton = createTextButton("Reset",Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,313,0,299))
	yesButton.Name = "YesButton"
	yesButton.ZIndex = baseZIndex + 4
	yesButton.Parent = frame
	yesButton.Modal  = true
	yesButton.MouseButton1Click:connect(function()
		resumeGameFunction(shield)
		resetLocalCharacter()
	end)
	
	local noButton = createTextButton("Cancel",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,128,0,50),UDim2.new(0,90,0,299))
	noButton.Name = "NoButton"
	noButton.Parent = frame
	noButton.ZIndex = baseZIndex + 4
	noButton.MouseButton1Click:connect(function()
		goToMenu(shield.Settings.SettingsStyle,"GameMainMenu","down",UDim2.new(0,525,0,430))
		shield.Settings:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
	end)
	
	local resetCharacterText = Instance.new("TextLabel")
	resetCharacterText.Name = "ResetCharacterText"
	resetCharacterText.Text = "Are you sure you want to reset your character?"
	resetCharacterText.Size = UDim2.new(1,0,0.8,0)
	resetCharacterText.TextWrap = true
	resetCharacterText.TextColor3 = Color3.new(1,1,1)
	resetCharacterText.Font = Enum.Font.ArialBold
	resetCharacterText.FontSize = Enum.FontSize.Size36
	resetCharacterText.BackgroundTransparency = 1
	resetCharacterText.ZIndex = baseZIndex + 4
	resetCharacterText.Parent = frame
	
	local fineResetCharacterText = resetCharacterText:Clone()
	fineResetCharacterText.Name = "FineResetCharacterText"
	fineResetCharacterText.Text = "You will be put back on a spawn point"
	fineResetCharacterText.Size = UDim2.new(0,303,0,18)
	fineResetCharacterText.Position = UDim2.new(0, 109, 0, 215)
	fineResetCharacterText.FontSize = Enum.FontSize.Size18
	fineResetCharacterText.Parent = frame
	
	return frame
end

local function createGameMainMenu(baseZIndex, shield)
	local gameMainMenuFrame = Instance.new("Frame")
	gameMainMenuFrame.Name = "GameMainMenu"
	gameMainMenuFrame.BackgroundTransparency = 1
	gameMainMenuFrame.Size = UDim2.new(1,0,1,0)
	gameMainMenuFrame.ZIndex = baseZIndex + 4
	gameMainMenuFrame.Parent = settingsFrame

	-- GameMainMenu Children
	
	local gameMainMenuTitle = Instance.new("TextLabel")
	gameMainMenuTitle.Name = "Title"
	gameMainMenuTitle.Text = "Game Menu"
	gameMainMenuTitle.BackgroundTransparency = 1
	gameMainMenuTitle.TextStrokeTransparency = 0
	gameMainMenuTitle.Font = Enum.Font.ArialBold
	gameMainMenuTitle.FontSize = Enum.FontSize.Size36
	gameMainMenuTitle.Size = UDim2.new(1,0,0,36)
	gameMainMenuTitle.Position = UDim2.new(0,0,0,4)
	gameMainMenuTitle.TextColor3 = Color3.new(1,1,1)
	gameMainMenuTitle.ZIndex = baseZIndex + 4
	gameMainMenuTitle.Parent = gameMainMenuFrame
	
	local robloxHelpButton = createTextButton("Help",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,164,0,50),UDim2.new(0,82,0,256))
	robloxHelpButton.Name = "HelpButton"
	robloxHelpButton.ZIndex = baseZIndex + 4
	robloxHelpButton.Parent = gameMainMenuFrame
	helpButton = robloxHelpButton
			
	local helpDialog = createHelpDialog(baseZIndex)
	helpDialog.Parent = gui
		
	helpButton.MouseButton1Click:connect(
		function() 
			table.insert(centerDialogs,helpDialog)
			game.GuiService:AddCenterDialog(helpDialog, Enum.CenterDialogType.ModalDialog,
				--ShowFunction
				function()
					helpDialog.Visible = true
					mainShield.Visible = false
				end,
				--HideFunction
				function()
					helpDialog.Visible = false
				end)
		end)
	helpButton.Active = true
	
	local helpShortcut = Instance.new("TextLabel")
	helpShortcut.Name = "HelpShortcutText"
	helpShortcut.Text = "F1"
	helpShortcut.Visible = false
	helpShortcut.BackgroundTransparency = 1
	helpShortcut.Font = Enum.Font.Arial
	helpShortcut.FontSize = Enum.FontSize.Size12
	helpShortcut.Position = UDim2.new(0,85,0,0)
	helpShortcut.Size = UDim2.new(0,30,0,30)
	helpShortcut.TextColor3 = Color3.new(0,1,0)
	helpShortcut.ZIndex = baseZIndex + 4
	helpShortcut.Parent = robloxHelpButton
	
	local screenshotButton = createTextButton("Screenshot",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.new(0,254,0,256))
	screenshotButton.Name = "ScreenshotButton"
	screenshotButton.ZIndex = baseZIndex + 4
	screenshotButton.Parent = gameMainMenuFrame
	screenshotButton.Visible = not macClient
	screenshotButton:SetVerb("Screenshot")
	
	local screenshotShortcut = helpShortcut:clone()
	screenshotShortcut.Name = "ScreenshotShortcutText"
	screenshotShortcut.Text = "PrintSc"
	screenshotShortcut.Position = UDim2.new(0,118,0,0)
	screenshotShortcut.Visible = true
	screenshotShortcut.Parent = screenshotButton
	
	
	local recordVideoButton = createTextButton("Record Video",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,168,0,50),UDim2.new(0,254,0,306))
	recordVideoButton.Name = "RecordVideoButton"
	recordVideoButton.ZIndex = baseZIndex + 4
	recordVideoButton.Parent = gameMainMenuFrame
	recordVideoButton.Visible = not macClient
	recordVideoButton:SetVerb("RecordToggle")
	
	local recordVideoShortcut = helpShortcut:clone()
	recordVideoShortcut.Visible = hasGraphicsSlider
	recordVideoShortcut.Name = "RecordVideoShortcutText"
	recordVideoShortcut.Text = "F12"
	recordVideoShortcut.Position = UDim2.new(0,120,0,0)
	recordVideoShortcut.Parent = recordVideoButton
	
	local stopRecordButton = Instance.new("ImageButton")
	stopRecordButton.Name = "StopRecordButton"
	stopRecordButton.BackgroundTransparency = 1
	stopRecordButton.Image = "rbxasset://textures/ui/RecordStop.png"
	stopRecordButton.Size = UDim2.new(0,59,0,27)
	stopRecordButton:SetVerb("RecordToggle")
	
	stopRecordButton.MouseButton1Click:connect(function() recordVideoClick(recordVideoButton, stopRecordButton) end)
	stopRecordButton.Visible = false
	stopRecordButton.Parent = gui
	
	local reportAbuseButton = createTextButton("Report Abuse",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,164,0,50),UDim2.new(0,82,0,306))
	reportAbuseButton.Name = "ReportAbuseButton"
	reportAbuseButton.ZIndex = baseZIndex + 4
	reportAbuseButton.Parent = gameMainMenuFrame
	
	local leaveGameButton = createTextButton("Leave Game",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,358))
	leaveGameButton.Name = "LeaveGameButton"
	leaveGameButton.ZIndex = baseZIndex + 4
	leaveGameButton.Parent = gameMainMenuFrame
	
	local resumeGameButton = createTextButton("Resume Game",Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,54))
	resumeGameButton.Name = "resumeGameButton"
	resumeGameButton.ZIndex = baseZIndex + 4
	resumeGameButton.Parent = gameMainMenuFrame
	resumeGameButton.Modal = true
	resumeGameButton.MouseButton1Click:connect(function() resumeGameFunction(shield) end)
	
	local gameSettingsButton = createTextButton("Game Settings",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,156))
	gameSettingsButton.Name = "SettingsButton"
	gameSettingsButton.ZIndex = baseZIndex + 4
	gameSettingsButton.Parent = gameMainMenuFrame
	
	if game:FindFirstChild("LoadingGuiService") and #game.LoadingGuiService:GetChildren() > 0 then
		local gameSettingsButton = createTextButton("Game Instructions",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,207))
		gameSettingsButton.Name = "GameInstructions"
		gameSettingsButton.ZIndex = baseZIndex + 4
		gameSettingsButton.Parent = gameMainMenuFrame
		gameSettingsButton.MouseButton1Click:connect(function()
			if game:FindFirstChild("Players") and game.Players["LocalPlayer"] then
				local loadingGui = game.Players.LocalPlayer:FindFirstChild("PlayerLoadingGui")
				if loadingGui then
					loadingGui.Visible = true
				end
			end
		end)
	end
	
	local resetButton = createTextButton("Reset Character",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size24,UDim2.new(0,340,0,50),UDim2.new(0,82,0,105))
	resetButton.Name = "ResetButton"
	resetButton.ZIndex = baseZIndex + 4
	resetButton.Parent = gameMainMenuFrame
	
	return gameMainMenuFrame
end

local function createGameSettingsMenu(baseZIndex, shield)
	local gameSettingsMenuFrame = Instance.new("Frame")
	gameSettingsMenuFrame.Name = "GameSettingsMenu"
	gameSettingsMenuFrame.BackgroundTransparency = 1
	gameSettingsMenuFrame.Size = UDim2.new(1,0,1,0)
	gameSettingsMenuFrame.ZIndex = baseZIndex + 4
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = "Settings"
	title.Size = UDim2.new(1,0,0,48)
	title.Position = UDim2.new(0,9,0,-9)
	title.Font = Enum.Font.ArialBold
	title.FontSize = Enum.FontSize.Size36
	title.TextColor3 = Color3.new(1,1,1)
	title.ZIndex = baseZIndex + 4
	title.BackgroundTransparency = 1
	title.Parent = gameSettingsMenuFrame
	
	local fullscreenText = Instance.new("TextLabel")
	fullscreenText.Name = "FullscreenText"
	fullscreenText.Text = "Fullscreen Mode"
	fullscreenText.Size = UDim2.new(0,124,0,18)
	fullscreenText.Position = UDim2.new(0,62,0,145)
	fullscreenText.Font = Enum.Font.Arial
	fullscreenText.FontSize = Enum.FontSize.Size18
	fullscreenText.TextColor3 = Color3.new(1,1,1)
	fullscreenText.ZIndex = baseZIndex + 4
	fullscreenText.BackgroundTransparency = 1
	fullscreenText.Parent = gameSettingsMenuFrame
	
	local fullscreenShortcut = Instance.new("TextLabel")
	fullscreenShortcut.Visible = hasGraphicsSlider
	fullscreenShortcut.Name = "FullscreenShortcutText"
	fullscreenShortcut.Text = "F11"
	fullscreenShortcut.BackgroundTransparency = 1
	fullscreenShortcut.Font = Enum.Font.Arial
	fullscreenShortcut.FontSize = Enum.FontSize.Size12
	fullscreenShortcut.Position = UDim2.new(0,186,0,141)
	fullscreenShortcut.Size = UDim2.new(0,30,0,30)
	fullscreenShortcut.TextColor3 = Color3.new(0,1,0)
	fullscreenShortcut.ZIndex = baseZIndex + 4
	fullscreenShortcut.Parent = gameSettingsMenuFrame
	
	local studioText = Instance.new("TextLabel")
	studioText.Visible = false
	studioText.Name = "StudioText"
	studioText.Text = "Studio Mode"
	studioText.Size = UDim2.new(0,95,0,18)
	studioText.Position = UDim2.new(0,62,0,179)
	studioText.Font = Enum.Font.Arial
	studioText.FontSize = Enum.FontSize.Size18
	studioText.TextColor3 = Color3.new(1,1,1)
	studioText.ZIndex = baseZIndex + 4
	studioText.BackgroundTransparency = 1
	studioText.Parent = gameSettingsMenuFrame
	
	local studioShortcut = fullscreenShortcut:clone()
	studioShortcut.Name = "StudioShortcutText"
	studioShortcut.Visible = false -- TODO: turn back on when f2 hack is fixed
	studioShortcut.Text = "F2"
	studioShortcut.Position = UDim2.new(0,154,0,175)
	studioShortcut.Parent = gameSettingsMenuFrame
	
	local studioCheckbox = nil
	
	if hasGraphicsSlider then
		local qualityText = Instance.new("TextLabel")
		qualityText.Name = "QualityText"
		qualityText.Text = "Graphics Quality"
		qualityText.Size = UDim2.new(0,128,0,18)
		qualityText.Position = UDim2.new(0,30,0,239)
		qualityText.Font = Enum.Font.Arial
		qualityText.FontSize = Enum.FontSize.Size18
		qualityText.TextColor3 = Color3.new(1,1,1)
		qualityText.ZIndex = baseZIndex + 4
		qualityText.BackgroundTransparency = 1
		qualityText.Parent = gameSettingsMenuFrame
		qualityText.Visible = not inStudioMode
		
		local autoText = qualityText:clone()
		autoText.Name = "AutoText"
		autoText.Text = "Auto"
		autoText.Position = UDim2.new(0,183,0,214)
		autoText.TextColor3 = Color3.new(128/255,128/255,128/255)
		autoText.Size = UDim2.new(0,34,0,18)
		autoText.Parent = gameSettingsMenuFrame
		autoText.Visible = not inStudioMode
		
		local fasterText = autoText:clone()
		fasterText.Name = "FasterText"
		fasterText.Text = "Faster"
		fasterText.Position = UDim2.new(0,185,0,274)
		fasterText.TextColor3 = Color3.new(95,95,95)
		fasterText.FontSize = Enum.FontSize.Size14
		fasterText.Parent = gameSettingsMenuFrame
		fasterText.Visible = not inStudioMode
		
		local fasterShortcut = fullscreenShortcut:clone()
		fasterShortcut.Name = "FasterShortcutText"
		fasterShortcut.Text = "F10 + Shift"
		fasterShortcut.Position = UDim2.new(0,185,0,283)
		fasterShortcut.Parent = gameSettingsMenuFrame
		fasterShortcut.Visible = not inStudioMode
		
		local betterQualityText = autoText:clone()
		betterQualityText.Name = "BetterQualityText"
		betterQualityText.Text = "Better Quality"
		betterQualityText.TextWrap = true
		betterQualityText.Size = UDim2.new(0,41,0,28)
		betterQualityText.Position = UDim2.new(0,390,0,269)
		betterQualityText.TextColor3 = Color3.new(95,95,95)
		betterQualityText.FontSize = Enum.FontSize.Size14
		betterQualityText.Parent = gameSettingsMenuFrame
		betterQualityText.Visible = not inStudioMode
		
		local betterQualityShortcut = fullscreenShortcut:clone()
		betterQualityShortcut.Name = "BetterQualityShortcut"
		betterQualityShortcut.Text = "F10"
		betterQualityShortcut.Position = UDim2.new(0,394,0,288)
		betterQualityShortcut.Parent = gameSettingsMenuFrame
		betterQualityShortcut.Visible = not inStudioMode
		
		local autoGraphicsButton = createTextButton("X",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,187,0,239))
		autoGraphicsButton.Name = "AutoGraphicsButton"
		autoGraphicsButton.ZIndex = baseZIndex + 4
		autoGraphicsButton.Parent = gameSettingsMenuFrame
		autoGraphicsButton.Visible = not inStudioMode
		
		local graphicsSlider, graphicsLevel = RbxGui.CreateSlider(GraphicsQualityLevels,150,UDim2.new(0, 230, 0, 280)) -- graphics - 1 because slider starts at 1 instead of 0
		graphicsSlider.Parent = gameSettingsMenuFrame
		graphicsSlider.Bar.ZIndex = baseZIndex + 4
		graphicsSlider.Bar.Slider.ZIndex = baseZIndex + 5
		graphicsSlider.Visible = not inStudioMode
		graphicsLevel.Value = math.floor((settings().Rendering:GetMaxQualityLevel() - 1)/2)
		
		local graphicsSetter = Instance.new("TextBox")
		graphicsSetter.Name = "GraphicsSetter"
		graphicsSetter.BackgroundColor3 = Color3.new(0,0,0)
		graphicsSetter.BorderColor3 = Color3.new(128/255,128/255,128/255)
		graphicsSetter.Size = UDim2.new(0,50,0,25)
		graphicsSetter.Position = UDim2.new(0,450,0,269)
		graphicsSetter.TextColor3 = Color3.new(1,1,1)
		graphicsSetter.Font = Enum.Font.Arial
		graphicsSetter.FontSize = Enum.FontSize.Size18
		graphicsSetter.Text = "Auto"
		graphicsSetter.ZIndex = 1
		graphicsSetter.TextWrap = true
		graphicsSetter.Parent = gameSettingsMenuFrame
		graphicsSetter.Visible = not inStudioMode

		local isAutoGraphics = true
		if not inStudioMode then
			isAutoGraphics = (UserSettings().GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic)
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
			
			UserSettings().GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
			
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		end
				
		local function setGraphicsQualityLevel(newLevel)
			local percentage = newLevel/GraphicsQualityLevels
			local newSetting = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) * percentage)
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
		
		local function goToManualGraphics(explicitLevel)
			 setAutoGraphicsGui(false)
			
			if explicitLevel then
				graphicsLevel.Value = explicitLevel
			else
				graphicsLevel.Value = math.floor((settings().Rendering.AutoFRMLevel/(settings().Rendering:GetMaxQualityLevel() - 1)) * GraphicsQualityLevels)
			end
			
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
			if savedQualityLevel == Enum.SavedQualitySetting.Automatic then
				return 0
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel1 then
				return 1
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel2 then
				return 2
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel3 then
				return 3
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel4 then
				return 4
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel5 then
				return 5
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel6 then
				return 6
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel7 then
				return 7
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel8 then
				return 8
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel9 then
				return 9
			elseif savedQualityLevel == Enum.SavedQualitySetting.QualityLevel10 then
				return 10
			end
		end
		
		local function enableGraphicsWidget()
			settings().Rendering.EnableFRM = true
			
			isAutoGraphics = (UserSettings().GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic)
			if isAutoGraphics then
				showAutoGraphics()
				goToAutoGraphics()
			else
				showAutoGraphics()
				showManualGraphics()
				goToManualGraphics(translateSavedQualityLevelToInt(UserSettings().GameSettings.SavedQualityLevel))
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
			
			if newGraphicsValue < 1 then newGraphicsValue = 1
			elseif newGraphicsValue >= settings().Rendering:GetMaxQualityLevel() then
				newGraphicsValue = settings().Rendering:GetMaxQualityLevel() - 1
			end
			
			graphicsLevel.Value = newGraphicsValue
			setGraphicsQualityLevel(graphicsLevel.Value)
			graphicsSetter.Text = tostring(graphicsLevel.Value)
		end)
		
		graphicsLevel.Changed:connect(function(prop)
			if isAutoGraphics then return end
			if not listenToGraphicsLevelChange then return end
			
			graphicsSetter.Text = tostring(graphicsLevel.Value)
			setGraphicsQualityLevel(graphicsLevel.Value)
		end)
		
		-- setup our graphic mode on load
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
			if inStudioMode and not game.Players.LocalPlayer then return end
			
			if not isAutoGraphics then
				goToAutoGraphics()
			else
				goToManualGraphics(graphicsLevel.Value)
			end
		end)
		
		local lastUpdate = nil
		game.GraphicsQualityChangeRequest:connect(function(graphicsIncrease)
			if isAutoGraphics then return end -- only can set graphics in manual mode
			
			if graphicsIncrease then
				if (graphicsLevel.Value + 1) > GraphicsQualityLevels then return end
				graphicsLevel.Value = graphicsLevel.Value + 1
				graphicsSetter.Text = tostring(graphicsLevel.Value)
				setGraphicsQualityLevel(graphicsLevel.Value)
				
				game:GetService("GuiService"):SendNotification("Graphics Quality",
					"Increased to (" .. graphicsSetter.Text .. ")",
					"",
					2,
					function()
				end)
			else
				if (graphicsLevel.Value - 1) <= 0 then return end
				graphicsLevel.Value = graphicsLevel.Value - 1
				graphicsSetter.Text = tostring(graphicsLevel.Value)
				setGraphicsQualityLevel(graphicsLevel.Value)
				
				game:GetService("GuiService"):SendNotification("Graphics Quality",
					"Decreased to (" .. graphicsSetter.Text .. ")",
					"",
					2,
					function()
				end)
			end
		end)
		
		game.Players.PlayerAdded:connect(function(player)
			if player == game.Players.LocalPlayer and inStudioMode then
				enableGraphicsWidget()
			end
		end)
		game.Players.PlayerRemoving:connect(function(player)
			if player == game.Players.LocalPlayer and inStudioMode then
				disableGraphicsWidget()
			end
		end)

		studioCheckbox = createTextButton("",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,30,0,176))
		studioCheckbox.Name = "StudioCheckbox"
		studioCheckbox.ZIndex = baseZIndex + 4
		--studioCheckbox.Parent = gameSettingsMenuFrame -- todo: enable when studio h4x aren't an issue anymore
		studioCheckbox:SetVerb("TogglePlayMode")
		studioCheckbox.Visible = false -- todo: enabled when studio h4x aren't an issue anymore
		
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
				if not studioCheckbox.Active then return end
				
				if studioCheckbox.Text == "" then
					studioCheckbox.Text = "X"
				else
					studioCheckbox.Text = ""
				end
			end)
		end
	end
	
	local fullscreenCheckbox = createTextButton("",Enum.ButtonStyle.RobloxButton,Enum.FontSize.Size18,UDim2.new(0,25,0,25),UDim2.new(0,30,0,144))
	fullscreenCheckbox.Name = "FullscreenCheckbox"
	fullscreenCheckbox.ZIndex = baseZIndex + 4
	fullscreenCheckbox.Parent = gameSettingsMenuFrame
	fullscreenCheckbox:SetVerb("ToggleFullScreen")
	if UserSettings().GameSettings:InFullScreen() then fullscreenCheckbox.Text = "X" end
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
	
	if game:FindFirstChild("NetworkClient") then -- we are playing online
		setDisabledState(studioText)
		setDisabledState(studioShortcut)
		setDisabledState(studioCheckbox)
	end
	
	local backButton
	if hasGraphicsSlider then
		backButton = createTextButton("OK",Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2.new(0,170,0,330))
		backButton.Modal = true
	else
		backButton = createTextButton("OK",Enum.ButtonStyle.RobloxButtonDefault,Enum.FontSize.Size24,UDim2.new(0,180,0,50),UDim2.new(0,170,0,270))
		backButton.Modal = true
	end
	
	backButton.Name = "BackButton"
	backButton.ZIndex = baseZIndex + 4
	backButton.Parent = gameSettingsMenuFrame
	
	local syncVideoCaptureSetting = nil

	if not macClient then
		local videoCaptureLabel = Instance.new("TextLabel")
		videoCaptureLabel.Name = "VideoCaptureLabel"
		videoCaptureLabel.Text = "After Capturing Video"
		videoCaptureLabel.Font = Enum.Font.Arial
		videoCaptureLabel.FontSize = Enum.FontSize.Size18
		videoCaptureLabel.Position = UDim2.new(0,32,0,100)
		videoCaptureLabel.Size = UDim2.new(0,164,0,18)
		videoCaptureLabel.BackgroundTransparency = 1
		videoCaptureLabel.TextColor3 = Color3I(255,255,255)
		videoCaptureLabel.TextXAlignment = Enum.TextXAlignment.Left
		videoCaptureLabel.ZIndex = baseZIndex + 4
		videoCaptureLabel.Parent = gameSettingsMenuFrame

		local videoNames = {}
		local videoNameToItem = {}
		videoNames[1] = "Just Save to Disk"
		videoNameToItem[videoNames[1]] = Enum.UploadSetting["Never"]
		videoNames[2] = "Upload to YouTube"
		videoNameToItem[videoNames[2]] = Enum.UploadSetting["Ask me first"]

		local videoCaptureDropDown = nil
		videoCaptureDropDown, updateVideoCaptureDropDownSelection = RbxGui.CreateDropDownMenu(videoNames, 
			function(text) 
				UserSettings().GameSettings.VideoUploadPromptBehavior = videoNameToItem[text]
			end)
		videoCaptureDropDown.Name = "VideoCaptureField"
		videoCaptureDropDown.ZIndex = baseZIndex + 4
		videoCaptureDropDown.DropDownMenuButton.ZIndex = baseZIndex + 4
		videoCaptureDropDown.DropDownMenuButton.Icon.ZIndex = baseZIndex + 4
		videoCaptureDropDown.Position = UDim2.new(0, 270, 0, 94)
		videoCaptureDropDown.Size = UDim2.new(0,200,0,32)
		videoCaptureDropDown.Parent = gameSettingsMenuFrame

		syncVideoCaptureSetting = function()
			if UserSettings().GameSettings.VideoUploadPromptBehavior == Enum.UploadSetting["Never"] then
				updateVideoCaptureDropDownSelection(videoNames[1])
			elseif UserSettings().GameSettings.VideoUploadPromptBehavior == Enum.UploadSetting["Ask me first"] then
				updateVideoCaptureDropDownSelection(videoNames[2])
			else
				UserSettings().GameSettings.VideoUploadPromptBehavior = Enum.UploadSetting["Ask me first"]
				updateVideoCaptureDropDownSelection(videoNames[2])
			end
		end
	end
	
	local cameraLabel = Instance.new("TextLabel")
	cameraLabel.Name = "CameraLabel"
	cameraLabel.Text = "Character & Camera Controls"
	cameraLabel.Font = Enum.Font.Arial
	cameraLabel.FontSize = Enum.FontSize.Size18
	cameraLabel.Position = UDim2.new(0,31,0,58)
	cameraLabel.Size = UDim2.new(0,224,0,18)
	cameraLabel.TextColor3 = Color3I(255,255,255)
	cameraLabel.TextXAlignment = Enum.TextXAlignment.Left
	cameraLabel.BackgroundTransparency = 1
	cameraLabel.ZIndex = baseZIndex + 4
	cameraLabel.Parent = gameSettingsMenuFrame

	local mouseLockLabel = game.CoreGui.RobloxGui:FindFirstChild("MouseLockLabel",true)

	local enumItems = Enum.ControlMode:GetEnumItems()
	local enumNames = {}
	local enumNameToItem = {}
	for i,obj in ipairs(enumItems) do
		enumNames[i] = obj.Name
		enumNameToItem[obj.Name] = obj
	end

	local cameraDropDown
	cameraDropDown, updateCameraDropDownSelection = RbxGui.CreateDropDownMenu(enumNames, 
		function(text) 
			UserSettings().GameSettings.ControlMode = enumNameToItem[text] 
			
			pcall(function()
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
	cameraDropDown.Size = UDim2.new(0,200,0,32)
	cameraDropDown.Parent = gameSettingsMenuFrame
	
	return gameSettingsMenuFrame
end

if LoadLibrary then
  RbxGui = LoadLibrary("RbxGui")
  local baseZIndex = 0
if UserSettings then

	local createSettingsDialog = function()
		waitForChild(gui,"BottomLeftControl")
		settingsButton = gui.BottomLeftControl:FindFirstChild("SettingsButton")
		
		if settingsButton == nil then
			settingsButton = Instance.new("ImageButton")
			settingsButton.Name = "SettingsButton"
			settingsButton.Image = "rbxasset://textures/ui/SettingsButton.png"
			settingsButton.BackgroundTransparency = 1
			settingsButton.Active = false
			settingsButton.Size = UDim2.new(0,54,0,46)
			settingsButton.Position = UDim2.new(0,2,0,50)
			settingsButton.Parent = gui.BottomLeftControl
		end

		local shield = Instance.new("TextButton")
		shield.Text = ""
		shield.Name = "UserSettingsShield"
		shield.Active = true
		shield.AutoButtonColor = false
		shield.Visible = false
		shield.Size = UDim2.new(1,0,1,0)
		shield.BackgroundColor3 = Color3I(51,51,51)
		shield.BorderColor3 = Color3I(27,42,53)
		shield.BackgroundTransparency = 0.4
		shield.ZIndex = baseZIndex + 2
		mainShield = shield

		local frame = Instance.new("Frame")
		frame.Name = "Settings"
		frame.Position = UDim2.new(0.5, -262, -0.5, -200)
		frame.Size = UDim2.new(0, 525, 0, 430)
		frame.BackgroundTransparency = 1
		frame.Active = true
		frame.Parent = shield

		local settingsFrame = Instance.new("Frame")
		settingsFrame.Name = "SettingsStyle"
		settingsFrame.Size = UDim2.new(1, 0, 1, 0)
		settingsFrame.Style = Enum.FrameStyle.RobloxRound
		settingsFrame.Active = true
		settingsFrame.ZIndex = baseZIndex + 3
		settingsFrame.Parent = frame
		
		local gameMainMenu = createGameMainMenu(baseZIndex, shield)
		gameMainMenu.Parent = settingsFrame
		
		gameMainMenu.ScreenshotButton.MouseButton1Click:connect(function()
			backToGame(gameMainMenu.ScreenshotButton, shield, settingsButton)	
		end)
			
		gameMainMenu.RecordVideoButton.MouseButton1Click:connect(function()
			recordVideoClick(gameMainMenu.RecordVideoButton, gui.StopRecordButton)
			backToGame(gameMainMenu.RecordVideoButton, shield, settingsButton)
		end)
		
		if settings():FindFirstChild("Game Options") then
			pcall(function()
				settings():FindFirstChild("Game Options").VideoRecordingChangeRequest:connect(function(recording)
					recordingVideo = recording
					setRecordGui(recording, gui.StopRecordButton, gameMainMenu.RecordVideoButton)
				end)
			end)
		end
		
		game.CoreGui.RobloxGui.Changed:connect(function(prop) -- We have stopped recording when we resize
			if prop == "AbsoluteSize" and recordingVideo then
				recordVideoClick(gameMainMenu.RecordVideoButton, gui.StopRecordButton)
			end
		end)
		
		function localPlayerChange()
			gameMainMenu.ResetButton.Visible = game.Players.LocalPlayer
			if game.Players.LocalPlayer then
				settings().Rendering.EnableFRM = true
			elseif inStudioMode then
				settings().Rendering.EnableFRM = false
			end
		end
		
		gameMainMenu.ResetButton.Visible = game.Players.LocalPlayer
		if game.Players.LocalPlayer ~= nil then
			game.Players.LocalPlayer.Changed:connect(function()
				localPlayerChange()
			end)
		else
			delay(0,function()
				waitForProperty(game.Players,"LocalPlayer")
				gameMainMenu.ResetButton.Visible = game.Players.LocalPlayer
				game.Players.LocalPlayer.Changed:connect(function()
					localPlayerChange()
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
			goToMenu(settingsFrame,"ResetConfirmationMenu","up",UDim2.new(0,525,0,370))
		end)
		
		gameMainMenu.LeaveGameButton.MouseButton1Click:connect(function()
			goToMenu(settingsFrame,"LeaveConfirmationMenu","down",UDim2.new(0,525,0,300))
		end)
		
		if game.CoreGui.Version >= 4 then -- we can use escape!
			game:GetService("GuiService").EscapeKeyPressed:connect(function()
				if currentMenuSelection == nil then
					game.GuiService:AddCenterDialog(shield, Enum.CenterDialogType.ModalDialog,
						--showFunction
						function()
							settingsButton.Active = false
							updateCameraDropDownSelection(UserSettings().GameSettings.ControlMode.Name)
						
							if syncVideoCaptureSetting then
  								syncVideoCaptureSetting()
							end

							goToMenu(settingsFrame,"GameMainMenu","right",UDim2.new(0,525,0,430))
							shield.Visible = true
							shield.Active = true
							settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262,0.5, -200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
							settingsFrame.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
						end,
						--hideFunction
						function()
							settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262,-0.5, -200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
							settingsFrame.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
							shield.Visible = false
							settingsButton.Active = true
						end)
				elseif #lastMenuSelection > 0 then
					if #centerDialogs > 0 then
						for i = 1, #centerDialogs do
							game.GuiService:RemoveCenterDialog(centerDialogs[i])
							centerDialogs[i].Visible = false
						end
						centerDialogs = {}
					end
					
					goToMenu(lastMenuSelection[#lastMenuSelection]["container"],lastMenuSelection[#lastMenuSelection]["name"],
						lastMenuSelection[#lastMenuSelection]["direction"],lastMenuSelection[#lastMenuSelection]["lastSize"])
						
					table.remove(lastMenuSelection,#lastMenuSelection)
					if #lastMenuSelection == 1 then -- apparently lua can't reduce count to 0... T_T
						lastMenuSelection = {}
					end
				else
					resumeGameFunction(shield)
				end
			end)
		end
			
		local gameSettingsMenu = createGameSettingsMenu(baseZIndex, shield)
		gameSettingsMenu.Visible = false
		gameSettingsMenu.Parent = settingsFrame
		
		gameMainMenu.SettingsButton.MouseButton1Click:connect(function() 
			goToMenu(settingsFrame,"GameSettingsMenu","left",UDim2.new(0,525,0,350))
		end)

		gameSettingsMenu.BackButton.MouseButton1Click:connect(function()
			goToMenu(settingsFrame,"GameMainMenu","right",UDim2.new(0,525,0,430))
		end)
		
		local resetConfirmationWindow = createResetConfirmationMenu(baseZIndex, shield)
		resetConfirmationWindow.Visible = false
		resetConfirmationWindow.Parent = settingsFrame
		
		local leaveConfirmationWindow = createLeaveConfirmationMenu(baseZIndex,shield)
		leaveConfirmationWindow.Visible = false
		leaveConfirmationWindow.Parent = settingsFrame

		robloxLock(shield)
		
		settingsButton.MouseButton1Click:connect(
			function()
				game.GuiService:AddCenterDialog(shield, Enum.CenterDialogType.ModalDialog,
					--showFunction
					function()
						settingsButton.Active = false
						updateCameraDropDownSelection(UserSettings().GameSettings.ControlMode.Name)
					
						if syncVideoCaptureSetting then
  							syncVideoCaptureSetting()
						end

						goToMenu(settingsFrame,"GameMainMenu","right",UDim2.new(0,525,0,430))
						shield.Visible = true
						settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262,0.5, -200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
						settingsFrame.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
					end,
					--hideFunction
					function()
						settingsFrame.Parent:TweenPosition(UDim2.new(0.5, -262,-0.5, -200),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
						settingsFrame.Parent:TweenSize(UDim2.new(0,525,0,430),Enum.EasingDirection.InOut,Enum.EasingStyle.Sine,tweenTime,true)
						shield.Visible = false
						settingsButton.Active = true
					end)
			end)
			
		return shield
	end

	delay(0, function()
		createSettingsDialog().Parent = gui
		
		gui.BottomLeftControl.SettingsButton.Active = true
		gui.BottomLeftControl.SettingsButton.Position = UDim2.new(0,2,0,-2)
		
		if mouseLockLabel and UserSettings().GameSettings.ControlMode == Enum.ControlMode["Mouse Lock Switch"] then
			mouseLockLabel.Visible = true
		elseif mouseLockLabel then
			mouseLockLabel.Visible = false
		end
		
		-- our script has loaded, get rid of older buttons now
		local leaveGameButton = gui.BottomLeftControl:FindFirstChild("Exit")
		if leaveGameButton then leaveGameButton:Remove() end
		
		local topLeft = gui:FindFirstChild("TopLeftControl")
		if topLeft then 
			leaveGameButton = topLeft:FindFirstChild("Exit")
			if leaveGameButton then leaveGameButton:Remove() end

			topLeft:Remove()
		end
	end)
	
end --UserSettings call

local createSaveDialogs = function()
	local shield = Instance.new("TextButton")
	shield.Text = ""
	shield.AutoButtonColor = false
	shield.Name = "SaveDialogShield"
	shield.Active = true
	shield.Visible = false
	shield.Size = UDim2.new(1,0,1,0)
	shield.BackgroundColor3 = Color3I(51,51,51)
	shield.BorderColor3 = Color3I(27,42,53)
	shield.BackgroundTransparency = 0.4
	shield.ZIndex = baseZIndex+1

	local clearAndResetDialog
	local save
	local saveLocal
	local dontSave
	local cancel

	local messageBoxButtons = {}
	messageBoxButtons[1] = {}
	messageBoxButtons[1].Text = "Save"
	messageBoxButtons[1].Style = Enum.ButtonStyle.RobloxButtonDefault
	messageBoxButtons[1].Function = function() save() end 
	messageBoxButtons[2] = {}
	messageBoxButtons[2].Text = "Cancel"
	messageBoxButtons[2].Function = function() cancel() end 
	messageBoxButtons[3] = {}
	messageBoxButtons[3].Text = "Don't Save"
	messageBoxButtons[3].Function = function() dontSave() end 

	local saveDialogMessageBox = RbxGui.CreateStyledMessageDialog("Unsaved Changes", "Save your changes to ROBLOX before leaving?", "Confirm", messageBoxButtons)
	saveDialogMessageBox.Visible = true
	saveDialogMessageBox.Parent = shield


	local errorBoxButtons = {}

	local buttonOffset = 1
	if game.LocalSaveEnabled then
		errorBoxButtons[buttonOffset] = {}
		errorBoxButtons[buttonOffset].Text = "Save to Disk"
		errorBoxButtons[buttonOffset].Function = function() saveLocal() end 
		buttonOffset = buttonOffset + 1
	end
	errorBoxButtons[buttonOffset] = {}
	errorBoxButtons[buttonOffset].Text = "Keep Playing"
	errorBoxButtons[buttonOffset].Function = function() cancel() end 
	errorBoxButtons[buttonOffset+1] = {}
	errorBoxButtons[buttonOffset+1].Text = "Don't Save"
	errorBoxButtons[buttonOffset+1].Function = function() dontSave() end 

	local errorDialogMessageBox = RbxGui.CreateStyledMessageDialog("Upload Failed", "Sorry, we could not save your changes to ROBLOX.", "Error", errorBoxButtons)
	errorDialogMessageBox.Visible = false
	errorDialogMessageBox.Parent = shield

	local spinnerDialog = Instance.new("Frame")
	spinnerDialog.Name = "SpinnerDialog"
	spinnerDialog.Style = Enum.FrameStyle.RobloxRound
	spinnerDialog.Size = UDim2.new(0, 350, 0, 150)
	spinnerDialog.Position = UDim2.new(.5, -175, .5, -75)
	spinnerDialog.Visible = false
	spinnerDialog.Active = true
	spinnerDialog.Parent = shield

	local waitingLabel = Instance.new("TextLabel")
	waitingLabel.Name = "WaitingLabel"
	waitingLabel.Text = "Saving to ROBLOX..."
	waitingLabel.Font = Enum.Font.ArialBold
	waitingLabel.FontSize = Enum.FontSize.Size18
	waitingLabel.Position = UDim2.new(0.5, 25, 0.5, 0)
	waitingLabel.TextColor3 = Color3.new(1,1,1)
	waitingLabel.Parent = spinnerDialog

	local spinnerFrame = Instance.new("Frame")
	spinnerFrame.Name = "Spinner"
	spinnerFrame.Size = UDim2.new(0, 80, 0, 80)
	spinnerFrame.Position = UDim2.new(0.5, -150, 0.5, -40)
	spinnerFrame.BackgroundTransparency = 1
	spinnerFrame.Parent = spinnerDialog

	local spinnerIcons = {}
	local spinnerNum = 1
	while spinnerNum <= 8 do
		local spinnerImage = Instance.new("ImageLabel")
	   spinnerImage.Name = "Spinner"..spinnerNum
		spinnerImage.Size = UDim2.new(0, 16, 0, 16)
		spinnerImage.Position = UDim2.new(.5+.3*math.cos(math.rad(45*spinnerNum)), -8, .5+.3*math.sin(math.rad(45*spinnerNum)), -8)
		spinnerImage.BackgroundTransparency = 1
	   spinnerImage.Image = "http://www.roblox.com/Asset?id=45880710"
		spinnerImage.Parent = spinnerFrame

	   spinnerIcons[spinnerNum] = spinnerImage
	   spinnerNum = spinnerNum + 1
	end

	save = function()
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
					if pos == spinPos or pos == ((spinPos+1)%8) then
						spinnerIcons[pos+1].Image = "http://www.roblox.com/Asset?id=45880668"
					else
						spinnerIcons[pos+1].Image = "http://www.roblox.com/Asset?id=45880710"
					end
					
					pos = pos + 1
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

	saveLocal = function()
		errorDialogMessageBox.Visible = false
		game:FinishShutdown(true)
		clearAndResetDialog()
	end

	dontSave = function()
		saveDialogMessageBox.Visible = false
		errorDialogMessageBox.Visible = false
		game:FinishShutdown(false)
		clearAndResetDialog()
	end
	cancel = function()
		saveDialogMessageBox.Visible = false
		errorDialogMessageBox.Visible = false
		clearAndResetDialog()
	end

	clearAndResetDialog = function()
		saveDialogMessageBox.Visible = true
		errorDialogMessageBox.Visible = false
		spinnerDialog.Visible = false
		shield.Visible = false
		game.GuiService:RemoveCenterDialog(shield)
	end

	robloxLock(shield)
	shield.Visible = false
	return shield
end

local createReportAbuseDialog = function()
	--Only show things if we are a NetworkClient
	waitForChild(game,"NetworkClient")

	waitForChild(game,"Players")
	waitForProperty(game.Players, "LocalPlayer")
	local localPlayer = game.Players.LocalPlayer
	
	local reportAbuseButton
	waitForChild(gui,"UserSettingsShield")
	waitForChild(gui.UserSettingsShield, "Settings")
	waitForChild(gui.UserSettingsShield.Settings,"SettingsStyle")
	waitForChild(gui.UserSettingsShield.Settings.SettingsStyle,"GameMainMenu")
	waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu, "ReportAbuseButton")
	reportAbuseButton = gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.ReportAbuseButton

	local shield = Instance.new("TextButton")
	shield.Name = "ReportAbuseShield"
	shield.Text = ""
	shield.AutoButtonColor = false
	shield.Active = true
	shield.Visible = false
	shield.Size = UDim2.new(1,0,1,0)
	shield.BackgroundColor3 = Color3I(51,51,51)
	shield.BorderColor3 = Color3I(27,42,53)
	shield.BackgroundTransparency = 0.4
	shield.ZIndex = baseZIndex + 1

	local closeAndResetDialgo

	local messageBoxButtons = {}
	messageBoxButtons[1] = {}
	messageBoxButtons[1].Text = "Ok"
	messageBoxButtons[1].Modal = true
	messageBoxButtons[1].Function = function() closeAndResetDialog() end 
	local calmingMessageBox = RbxGui.CreateMessageDialog("Thanks for your report!", "Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.\n\nIf anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats", messageBoxButtons)
	calmingMessageBox.Visible = false
	calmingMessageBox.Parent = shield

	local recordedMessageBox = RbxGui.CreateMessageDialog("Thanks for your report!","We've recorded your report for evaluation.", messageBoxButtons)
	recordedMessageBox.Visible = false
	recordedMessageBox.Parent = shield

	local normalMessageBox = RbxGui.CreateMessageDialog("Thanks for your report!", "Our moderators will review the chat logs and determine what happened.", messageBoxButtons)
	normalMessageBox.Visible = false
	normalMessageBox.Parent = shield

	local frame = Instance.new("Frame")
	frame.Name = "Settings"
	frame.Position = UDim2.new(0.5, -250, 0.5, -200)
	frame.Size = UDim2.new(0.0, 500, 0.0, 400)
	frame.BackgroundTransparency = 1
	frame.Active = true
	frame.Parent = shield

	local settingsFrame = Instance.new("Frame")
	settingsFrame.Name = "ReportAbuseStyle"
	settingsFrame.Size = UDim2.new(1, 0, 1, 0)
	settingsFrame.Style = Enum.FrameStyle.RobloxRound
	settingsFrame.Active = true
	settingsFrame.ZIndex = baseZIndex + 1
	settingsFrame.Parent = frame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = "Report Abuse"
	title.TextColor3 = Color3I(221,221,221)
	title.Position = UDim2.new(0.5, 0, 0, 30)
	title.Font = Enum.Font.ArialBold
	title.FontSize = Enum.FontSize.Size36
	title.ZIndex = baseZIndex + 2
	title.Parent = settingsFrame

	local description = Instance.new("TextLabel")
	description.Name = "Description"
	description.Text = "This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action."
	description.TextColor3 = Color3I(221,221,221)
	description.Position = UDim2.new(0, 0, 0, 55)
	description.Size = UDim2.new(1, 0, 0, 40)
	description.BackgroundTransparency = 1
	description.Font = Enum.Font.Arial
	description.FontSize = Enum.FontSize.Size18
	description.TextWrap = true
	description.ZIndex = baseZIndex + 2
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextYAlignment = Enum.TextYAlignment.Top
	description.Parent = settingsFrame

	local playerLabel = Instance.new("TextLabel")
	playerLabel.Name = "PlayerLabel"
	playerLabel.Text = "Which player?"
	playerLabel.BackgroundTransparency = 1
	playerLabel.Font = Enum.Font.Arial
	playerLabel.FontSize = Enum.FontSize.Size18
	playerLabel.Position = UDim2.new(0.025,0,0,100)
	playerLabel.Size 	   = UDim2.new(0.4,0,0,36)
	playerLabel.TextColor3 = Color3I(255,255,255)
	playerLabel.TextXAlignment = Enum.TextXAlignment.Left
	playerLabel.ZIndex = baseZIndex + 2
	playerLabel.Parent = settingsFrame

	local abusingPlayer = nil
	local abuse = nil
	local submitReportButton = nil

	local updatePlayerSelection = nil
	local createPlayersDropDown = function()
		local players = game:GetService("Players")
		local playerNames = {}
		local nameToPlayer = {}
		local children = players:GetChildren()
		local pos = 1
		if children then
		   for i, player in ipairs(children) do
				if player:IsA("Player") and player ~= localPlayer then
					playerNames[pos] = player.Name
					nameToPlayer[player.Name] = player
					pos = pos + 1
				end
			end
		end
		local playerDropDown = nil
		playerDropDown, updatePlayerSelection = RbxGui.CreateDropDownMenu(playerNames, 
			function(playerName) 
				abusingPlayer = nameToPlayer[playerName] 
				if abuse and abusingPlayer then
					submitReportButton.Active = true
				end
			end)
		playerDropDown.Name = "PlayersComboBox"
		playerDropDown.ZIndex = baseZIndex + 2
		playerDropDown.Position = UDim2.new(.425, 0, 0, 102)
		playerDropDown.Size = UDim2.new(.55,0,0,32)
		
		return playerDropDown
	end
	
	local abuseLabel = Instance.new("TextLabel")
	abuseLabel.Name = "AbuseLabel"
	abuseLabel.Text = "Type of Abuse:"
	abuseLabel.Font = Enum.Font.Arial
	abuseLabel.BackgroundTransparency = 1
	abuseLabel.FontSize = Enum.FontSize.Size18
	abuseLabel.Position = UDim2.new(0.025,0,0,140)
	abuseLabel.Size = UDim2.new(0.4,0,0,36)
	abuseLabel.TextColor3 = Color3I(255,255,255)
	abuseLabel.TextXAlignment = Enum.TextXAlignment.Left
	abuseLabel.ZIndex = baseZIndex + 2
	abuseLabel.Parent = settingsFrame

	local abuses = {"Swearing","Bullying","Scamming","Dating","Cheating/Exploiting","Personal Questions","Offsite Links","Bad Model or Script","Bad Username"}
	local abuseDropDown, updateAbuseSelection = RbxGui.CreateDropDownMenu(abuses, 
		function(abuseText) 
			abuse = abuseText 
			if abuse and abusingPlayer then
				submitReportButton.Active = true
			end
		end, true)
	abuseDropDown.Name = "AbuseComboBox"
	abuseDropDown.ZIndex = baseZIndex + 2
	abuseDropDown.Position = UDim2.new(0.425, 0, 0, 142)
	abuseDropDown.Size = UDim2.new(0.55,0,0,32)
	abuseDropDown.Parent = settingsFrame

	local shortDescriptionLabel = Instance.new("TextLabel")
	shortDescriptionLabel.Name = "ShortDescriptionLabel"
	shortDescriptionLabel.Text = "Short Description: (optional)"
	shortDescriptionLabel.Font = Enum.Font.Arial
	shortDescriptionLabel.FontSize = Enum.FontSize.Size18
	shortDescriptionLabel.Position = UDim2.new(0.025,0,0,180)
	shortDescriptionLabel.Size = UDim2.new(0.95,0,0,36)
	shortDescriptionLabel.TextColor3 = Color3I(255,255,255)
	shortDescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	shortDescriptionLabel.BackgroundTransparency = 1
	shortDescriptionLabel.ZIndex = baseZIndex + 2
	shortDescriptionLabel.Parent = settingsFrame

	local shortDescriptionWrapper = Instance.new("Frame")
	shortDescriptionWrapper.Name = "ShortDescriptionWrapper"
	shortDescriptionWrapper.Position = UDim2.new(0.025,0,0,220)
	shortDescriptionWrapper.Size = UDim2.new(0.95,0,1,-310)
	shortDescriptionWrapper.BackgroundColor3 = Color3I(0,0,0)
	shortDescriptionWrapper.BorderSizePixel = 0
	shortDescriptionWrapper.ZIndex = baseZIndex + 2
	shortDescriptionWrapper.Parent = settingsFrame

	local shortDescriptionBox = Instance.new("TextBox")
	shortDescriptionBox.Name = "TextBox"
	shortDescriptionBox.Text = ""
	shortDescriptionBox.ClearTextOnFocus = false
	shortDescriptionBox.Font = Enum.Font.Arial
	shortDescriptionBox.FontSize = Enum.FontSize.Size18
	shortDescriptionBox.Position = UDim2.new(0,3,0,3)
	shortDescriptionBox.Size = UDim2.new(1,-6,1,-6)
	shortDescriptionBox.TextColor3 = Color3I(255,255,255)
	shortDescriptionBox.TextXAlignment = Enum.TextXAlignment.Left
	shortDescriptionBox.TextYAlignment = Enum.TextYAlignment.Top
	shortDescriptionBox.TextWrap = true
	shortDescriptionBox.BackgroundColor3 = Color3I(0,0,0)
	shortDescriptionBox.BorderSizePixel = 0
	shortDescriptionBox.ZIndex = baseZIndex + 2
	shortDescriptionBox.Parent = shortDescriptionWrapper

	submitReportButton = Instance.new("TextButton")
	submitReportButton.Name = "SubmitReportBtn"
	submitReportButton.Active = false
	submitReportButton.Modal = true
	submitReportButton.Font = Enum.Font.Arial
	submitReportButton.FontSize = Enum.FontSize.Size18
	submitReportButton.Position = UDim2.new(0.1, 0, 1, -80)
	submitReportButton.Size = UDim2.new(0.35,0,0,50)
	submitReportButton.AutoButtonColor = true
	submitReportButton.Style = Enum.ButtonStyle.RobloxButtonDefault 
	submitReportButton.Text = "Submit Report"
	submitReportButton.TextColor3 = Color3I(255,255,255)
	submitReportButton.ZIndex = baseZIndex + 2
	submitReportButton.Parent = settingsFrame

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
				closeAndResetDialog()
			end
		end
	end)

	local cancelButton = Instance.new("TextButton")
	cancelButton.Name = "CancelBtn"
	cancelButton.Font = Enum.Font.Arial
	cancelButton.FontSize = Enum.FontSize.Size18
	cancelButton.Position = UDim2.new(0.55, 0, 1, -80)
	cancelButton.Size = UDim2.new(0.35,0,0,50)
	cancelButton.AutoButtonColor = true
	cancelButton.Style = Enum.ButtonStyle.RobloxButtonDefault 
	cancelButton.Text = "Cancel"
	cancelButton.TextColor3 = Color3I(255,255,255)
	cancelButton.ZIndex = baseZIndex + 2
	cancelButton.Parent = settingsFrame

	closeAndResetDialog = function()
		--Delete old player combo box
		local oldComboBox = settingsFrame:FindFirstChild("PlayersComboBox")
		if oldComboBox then
			oldComboBox.Parent = nil
		end
		
		abusingPlayer = nil updatePlayerSelection(nil)
		abuse = nil updateAbuseSelection(nil)
		submitReportButton.Active = false
		shortDescriptionBox.Text = ""
		frame.Visible = true
		calmingMessageBox.Visible = false
		recordedMessageBox.Visible = false
		normalMessageBox.Visible = false
		shield.Visible = false		
		reportAbuseButton.Active = true
		game.GuiService:RemoveCenterDialog(shield)
	end

	cancelButton.MouseButton1Click:connect(closeAndResetDialog)
	
	reportAbuseButton.MouseButton1Click:connect(
		function() 
			createPlayersDropDown().Parent = settingsFrame
			table.insert(centerDialogs,shield)
			game.GuiService:AddCenterDialog(shield, Enum.CenterDialogType.ModalDialog, 
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
				end)
		end)

	robloxLock(shield)
	return shield
end

local createChatBar = function()
	--Only show a chat bar if we are a NetworkClient
	waitForChild(game, "NetworkClient")

	waitForChild(game, "Players")
	waitForProperty(game.Players, "LocalPlayer")
	
	local chatBar = Instance.new("Frame")
	chatBar.Name = "ChatBar"
	chatBar.Size = UDim2.new(1, 0, 0, 22)
	chatBar.Position = UDim2.new(0, 0, 1, 0)
	chatBar.BackgroundColor3 = Color3.new(0,0,0)
	chatBar.BorderSizePixel = 0

	local chatBox = Instance.new("TextBox")
	chatBox.Text = ""
	chatBox.Visible = false
	chatBox.Size = UDim2.new(1,-4,1,0)
	chatBox.Position = UDim2.new(0,2,0,0)
	chatBox.TextXAlignment = Enum.TextXAlignment.Left
	chatBox.Font = Enum.Font.Arial
	chatBox.ClearTextOnFocus = false
	chatBox.FontSize = Enum.FontSize.Size14
	chatBox.TextColor3 = Color3.new(1,1,1)
	chatBox.BackgroundTransparency = 1
	--chatBox.Parent = chatBar

	local chatButton = Instance.new("TextButton")
	chatButton.Size = UDim2.new(1,-4,1,0)
	chatButton.Position = UDim2.new(0,2,0,0)
	chatButton.AutoButtonColor = false
	chatButton.Text = "To chat click here or press \"/\" key"
	chatButton.TextXAlignment = Enum.TextXAlignment.Left
	chatButton.Font = Enum.Font.Arial
	chatButton.FontSize = Enum.FontSize.Size14
	chatButton.TextColor3 = Color3.new(1,1,1)
	chatButton.BackgroundTransparency = 1
	--chatButton.Parent = chatBar

	local activateChat = function()
		if chatBox.Visible then
			return
		end
		chatButton.Visible = false
		chatBox.Text = ""
		chatBox.Visible = true
		chatBox:CaptureFocus()
	end

	chatButton.MouseButton1Click:connect(activateChat)

	local hotKeyEnabled = true
	local toggleHotKey = function(value)
		hotKeyEnabled = value
	end
	
	local guiService = game:GetService("GuiService")
	local newChatMode = pcall(function()
		--guiService:AddSpecialKey(Enum.SpecialKey.ChatHotkey)
		--guiService.SpecialKeyPressed:connect(function(key) if key == Enum.SpecialKey.ChatHotkey and hotKeyEnabled then activateChat() end end)
	end)
	if not newChatMode then
		--guiService:AddKey("/")
		--guiService.KeyPressed:connect(function(key) if key == "/" and hotKeyEnabled then activateChat() end end)
	end

	chatBox.FocusLost:connect(
		function(enterPressed)
			if enterPressed then
				if chatBox.Text ~= "" then
					local str = chatBox.Text
					if string.sub(str, 1, 1) == '%' then
						game.Players:TeamChat(string.sub(str, 2))
					else
						game.Players:Chat(str)
					end
				end
			end
			chatBox.Text = ""
			chatBox.Visible = false
			chatButton.Visible = true
		end)
	robloxLock(chatBar)
	return chatBar, toggleHotKey
end

--Spawn a thread for the Save dialogs
local isSaveDialogSupported = pcall(function() local var = game.LocalSaveEnabled end)
if isSaveDialogSupported then
	delay(0, 
		function()
			local saveDialogs = createSaveDialogs()
			saveDialogs.Parent = gui
		
			game.RequestShutdown = function()
				table.insert(centerDialogs,saveDialogs)
				game.GuiService:AddCenterDialog(saveDialogs, Enum.CenterDialogType.QuitDialog,
					--ShowFunction
					function()
						saveDialogs.Visible = true 
					end,
					--HideFunction
					function()
						saveDialogs.Visible = false
					end)

				return true
			end
		end)
end

--Spawn a thread for the Report Abuse dialogs
delay(0, 
	function()
		createReportAbuseDialog().Parent = gui
		waitForChild(gui,"UserSettingsShield")
		waitForChild(gui.UserSettingsShield, "Settings")
		waitForChild(gui.UserSettingsShield.Settings,"SettingsStyle")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle,"GameMainMenu")
		waitForChild(gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu, "ReportAbuseButton")
		gui.UserSettingsShield.Settings.SettingsStyle.GameMainMenu.ReportAbuseButton.Active = true
	end)

--Spawn a thread for Chat Bar
local coreGuiVersion = game.CoreGui.Version
local success, luaChat = pcall(function() return game.GuiService.UseLuaChat end)
if success and luaChat then

	--[[delay(0,
		function()
			waitForChild(game, "Players")
			waitForProperty(game.Players, "LocalPlayer")

			local advancedChatBarSupported = game.Players.LocalPlayer.ChatMode
			local chatBar, toggleHotKey = createChatBar()
			
			[if advancedChatBarSupported then
				local function toggleChatBar(chatMode)
					if chatMode == Enum.ChatMode.Menu then
						chatBar.Parent = nil
						game.GuiService:SetGlobalSizeOffsetPixel(0,0)
						toggleHotKey(false)
					elseif chatMode == Enum.ChatMode.TextAndMenu then
						--chatBar.Parent = gui
						--game.GuiService:SetGlobalSizeOffsetPixel(0,-22)
						toggleHotKey(true)
					end
				end
				game.Players.LocalPlayer.Changed:connect(
					function(prop)
						if prop == "ChatMode" then
							toggleChatBar(game.Players.LocalPlayer.ChatMode)
						end
					end)
				toggleChatBar(game.Players.LocalPlayer.ChatMode)
			else
				--chatBar.Parent = gui
				--game.GuiService:SetGlobalSizeOffsetPixel(0,-22)
			end
		end)]]
end


local BurningManPlaceID = 41324860
-- TODO: remove click to walk completely if testing shows we don't need it
-- Removes click to walk option from Burning Man
delay(0,
	function()
		waitForChild(game,"NetworkClient")
		waitForChild(game,"Players")
		waitForProperty(game.Players, "LocalPlayer")
		waitForProperty(game.Players.LocalPlayer, "Character")
		waitForChild(game.Players.LocalPlayer.Character, "Humanoid")
		waitForProperty(game, "PlaceId")
		
		if game.PlaceId == BurningManPlaceID then
			game.Players.LocalPlayer.Character.Humanoid:SetClickToWalkEnabled(false)
			game.Players.LocalPlayer.CharacterAdded:connect(function(character)
				waitForChild(character, "Humanoid")
				character.Humanoid:SetClickToWalkEnabled(false)
			end)
		end
	end)
	
end --LoadLibrary if
