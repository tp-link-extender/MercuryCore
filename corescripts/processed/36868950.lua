print("[Mercury]: Loaded corescript 36868950")
local controlFrame = script.Parent:FindFirstChild("ControlFrame")
if not controlFrame then
	return
end
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
local bottomLeftControl = controlFrame:FindFirstChild("BottomLeftControl")
local bottomRightControl = controlFrame:FindFirstChild("BottomRightControl")
local frameTip = New("TextLabel", "ToolTip", {
	Text = "",
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size12,
	TextColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	ZIndex = 10,
	Size = UDim2.new(2, 0, 1, 0),
	Position = UDim2.new(1, 0, 0, 0),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 1,
	TextTransparency = 1,
	TextWrap = true,
	New("BoolValue", "inside", {
		Value = false
	})
})
local setUpListeners
setUpListeners = function(frameToListen)
	local fadeSpeed = 0.1
	frameToListen.Parent.MouseEnter:connect(function()
		if frameToListen:FindFirstChild("inside") then
			frameToListen.inside.Value = true
			wait(1.2)
			if frameToListen.inside.Value then
				while frameToListen.inside.Value and frameToListen.BackgroundTransparency > 0 do
					frameToListen.BackgroundTransparency = frameToListen.BackgroundTransparency - fadeSpeed
					frameToListen.TextTransparency = frameToListen.TextTransparency - fadeSpeed
					wait()
				end
			end
		end
	end)
	local killTip
	killTip = function(killFrame)
		killFrame.inside.Value = false
		killFrame.BackgroundTransparency = 1
		killFrame.TextTransparency = 1
	end
	frameToListen.Parent.MouseLeave:connect(function()
		return killTip(frameToListen)
	end)
	return frameToListen.Parent.MouseButton1Click:connect(function()
		return killTip(frameToListen)
	end)
end
local createSettingsButtonTip
createSettingsButtonTip = function(parent)
	if not (parent ~= nil) then
		parent = bottomLeftControl:FindFirstChild("SettingsButton")
	end
	local toolTip = frameTip:clone()
	toolTip.RobloxLocked = true
	toolTip.Text = "Settings/Leave Game"
	toolTip.Position = UDim2.new(0, 0, 0, -18)
	toolTip.Size = UDim2.new(0, 120, 0, 20)
	toolTip.Parent = parent
	setUpListeners(toolTip)
	return toolTip
end
wait(5)
local bottomLeftChildren = bottomLeftControl:GetChildren()
for i = 1, #bottomLeftChildren do
	if bottomLeftChildren[i].Name == "Exit" then
		do
			local exitTip = frameTip:clone()
			exitTip.RobloxLocked = true
			exitTip.Text = "Leave Place"
			exitTip.Position = UDim2.new(0, 0, -1, 0)
			exitTip.Size = UDim2.new(1, 0, 1, 0)
			exitTip.Parent = bottomLeftChildren[i]
			setUpListeners(exitTip)
		end
	elseif bottomLeftChildren[i].Name == "SettingsButton" then
		createSettingsButtonTip(bottomLeftChildren[i])
	end
end
local bottomRightChildren = bottomRightControl:GetChildren()
for i = 1, #bottomRightChildren do
	if (bottomRightChildren[i].Name:find("Camera") ~= nil) then
		do
			local cameraTip = frameTip:clone()
			cameraTip.RobloxLocked = true
			cameraTip.Text = "Camera View"
			if bottomRightChildren[i].Name:find("Zoom") then
				cameraTip.Position = UDim2.new(-1, 0, -1.5)
			else
				cameraTip.Position = UDim2.new(0, 0, -1.5, 0)
			end
			cameraTip.Size = UDim2.new(2, 0, 1.25, 0)
			cameraTip.Parent = bottomRightChildren[i]
			setUpListeners(cameraTip)
		end
	end
end
