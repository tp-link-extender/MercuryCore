print("[Mercury]: Loaded corescript 152908679")
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
local contextActionService = Game:GetService("ContextActionService")
local isTouchDevice = Game:GetService("UserInputService").TouchEnabled
local functionTable = { }
local buttonVector = { }
local buttonScreenGui
local buttonFrame
local ContextDownImage = "http://www.banland.xyz/asset/?id=97166756"
local ContextUpImage = "http://www.banland.xyz/asset/?id=97166444"
local oldTouches = { }
local buttonPositionTable = {
	UDim2.new(0, 123, 0, 70),
	UDim2.new(0, 30, 0, 60),
	UDim2.new(0, 180, 0, 160),
	UDim2.new(0, 85, 0, -25),
	UDim2.new(0, 185, 0, -25),
	UDim2.new(0, 185, 0, 260),
	UDim2.new(0, 216, 0, 65)
}
local maxButtons = #buttonPositionTable
do
	local _with_0 = Game:GetService("ContentProvider")
	_with_0:Preload(ContextDownImage)
	_with_0:Preload(ContextUpImage)
end
while not Game.Players do
	wait()
end
while not Game.Players.LocalPlayer do
	wait()
end
local createContextActionGui
createContextActionGui = function()
	if not buttonScreenGui and isTouchDevice then
		buttonScreenGui = New("ScreenGui", "ContextActionGui", {
			New("Frame", "ContextButtonFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.3, 0, 0.5, 0),
				Position = UDim2.new(0.7, 0, 0.5, 0)
			})
		})
	end
end
local contextButtonDown
contextButtonDown = function(button, inputObject, actionName)
	if inputObject.UserInputType == Enum.UserInputType.Touch then
		button.Image = ContextDownImage
		return contextActionService:CallFunction(actionName, Enum.UserInputState.Begin)
	end
end
local contextButtonMoved
contextButtonMoved = function(button, inputObject, actionName)
	if inputObject.UserInputType == Enum.UserInputType.Touch then
		button.Image = ContextDownImage
		return contextActionService:CallFunction(actionName, Enum.UserInputState.Change)
	end
end
local contextButtonUp
contextButtonUp = function(button, inputObject, actionName)
	button.Image = ContextUpImage
	if inputObject.UserInputType == Enum.UserInputType.Touch and inputObject.UserInputState == Enum.UserInputState.End then
		return contextActionService:CallFunction(actionName, Enum.UserInputState.End, inputObject)
	end
end
local isSmallScreenDevice
isSmallScreenDevice = function()
	return Game:GetService("GuiService"):GetScreenResolution().y <= 320
end
local createNewButton
createNewButton = function(actionName, functionInfoTable)
	local contextButton = New("ImageButton", "ContextActionButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new((function()
			if isSmallScreenDevice() then
				return 0, 90, 0, 90
			else
				return 0, 70, 0, 70
			end
		end)()),
		Active = true,
		Image = ContextUpImage,
		Parent = buttonFrame
	})
	local currentButtonTouch
	Game:GetService("UserInputService").InputEnded:connect(function(inputObject)
		oldTouches[inputObject] = nil
	end)
	contextButton.InputBegan:connect(function(inputObject)
		if oldTouches[inputObject] then
			return
		end
		if inputObject.UserInputState == Enum.UserInputState.Begin and not (currentButtonTouch ~= nil) then
			currentButtonTouch = inputObject
			return contextButtonDown(contextButton, inputObject, actionName)
		end
	end)
	contextButton.InputChanged:connect(function(inputObject)
		if oldTouches[inputObject] or currentButtonTouch ~= inputObject then
			return
		end
		return contextButtonMoved(contextButton, inputObject, actionName)
	end)
	contextButton.InputEnded:connect(function(inputObject)
		if oldTouches[inputObject] or currentButtonTouch ~= inputObject then
			return
		end
		currentButtonTouch = nil
		oldTouches[inputObject] = true
		return contextButtonUp(contextButton, inputObject, actionName)
	end)
	local actionIcon = New("ImageLabel", "ActionIcon", {
		Position = UDim2.new(0.175, 0, 0.175, 0),
		Size = UDim2.new(0.65, 0, 0.65, 0),
		BackgroundTransparency = 1
	})
	if functionInfoTable["image"] and type(functionInfoTable["image"]) == "string" then
		actionIcon.Image = functionInfoTable["image"]
	end
	actionIcon.Parent = contextButton
	local actionTitle = New("TextLabel", "ActionTitle", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.new(1, 1, 1),
		TextStrokeTransparency = 0,
		FontSize = Enum.FontSize.Size18,
		TextWrapped = true,
		Text = ""
	})
	if functionInfoTable["title"] and type(functionInfoTable["title"]) == "string" then
		actionTitle.Text = functionInfoTable["title"]
	end
	actionTitle.Parent = contextButton
	return contextButton
end
local createButton
createButton = function(actionName, functionInfoTable)
	local button = createNewButton(actionName, functionInfoTable)
	local position
	for i = 1, #buttonVector do
		if buttonVector[i] == "empty" then
			position = i
			break
		end
	end
	if not position then
		position = #buttonVector + 1
	end
	if position > maxButtons then
		return
	end
	buttonVector[position] = button
	functionTable[actionName]["button"] = button
	button.Position = buttonPositionTable[position]
	button.Parent = buttonFrame
	if buttonScreenGui and not (buttonScreenGui.Parent ~= nil) then
		buttonScreenGui.Parent = Game.Players.LocalPlayer.PlayerGui
	end
end
local removeAction
removeAction = function(actionName)
	if not functionTable[actionName] then
		return
	end
	local actionButton = functionTable[actionName]["button"]
	if actionButton then
		actionButton.Parent = nil
		for i = 1, #buttonVector do
			if buttonVector[i] == actionButton then
				buttonVector[i] = "empty"
				break
			end
		end
		actionButton:Destroy()
	end
	functionTable[actionName] = nil
end
local addAction
addAction = function(actionName, createTouchButton, functionInfoTable)
	if functionTable[actionName] then
		removeAction(actionName)
	end
	functionTable[actionName] = {
		functionInfoTable
	}
	if createTouchButton and isTouchDevice then
		createContextActionGui()
		return createButton(actionName, functionInfoTable)
	end
end
contextActionService.BoundActionChanged:connect(function(actionName, changeName, changeTable)
	if functionTable[actionName] and changeTable then
		do
			local button = functionTable[actionName]["button"]
			if button then
				if changeName == "image" then
					button.ActionIcon.Image = changeTable[changeName]
				elseif changeName == "title" then
					button.ActionTitle.Text = changeTable[changeName]
				elseif changeName == "position" then
					button.Position = changeTable[changeName]
				end
			end
		end
	end
end)
contextActionService.BoundActionAdded:connect(function(actionName, createTouchButton, functionInfoTable)
	return addAction(actionName, createTouchButton, functionInfoTable)
end)
contextActionService.BoundActionRemoved:connect(function(actionName, _)
	return removeAction(actionName)
end)
contextActionService.GetActionButtonEvent:connect(function(actionName)
	if functionTable[actionName] then
		return contextActionService:FireActionButtonFoundSignal(actionName, functionTable[actionName]["button"])
	end
end)
local boundActions = contextActionService:GetAllBoundActionInfo()
for actionName, actionData in pairs(boundActions) do
	addAction(actionName, actionData["createTouchButton"], actionData)
end
