-- CoreGui.RobloxGui.CoreScripts/ToolTip
print "[Mercury]: Loaded corescript 36868950"

local New = require "../Modules/New"

local controlFrame = script.Parent:FindFirstChild "ControlFrame"

if not controlFrame then
	return
end

local bottomLeftControl = controlFrame:FindFirstChild "BottomLeftControl"
local bottomRightControl = controlFrame:FindFirstChild "BottomRightControl"

local frameTip = New "TextLabel" {
	Name = "ToolTip",
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
	New "BoolValue" {
		Name = "inside",
		Value = false,
	},
}

local function setUpListeners(frameToListen)
	local fadeSpeed = 0.1
	frameToListen.Parent.MouseEnter:connect(function()
		if frameToListen:FindFirstChild "inside" then
			frameToListen.inside.Value = true
			wait(1.2)
			if frameToListen.inside.Value then
				while
					frameToListen.inside.Value
					and frameToListen.BackgroundTransparency > 0
				do
					frameToListen.BackgroundTransparency = frameToListen.BackgroundTransparency
						- fadeSpeed
					frameToListen.TextTransparency = frameToListen.TextTransparency
						- fadeSpeed
					wait()
				end
			end
		end
	end)

	local function killTip(killFrame)
		killFrame.inside.Value = false
		killFrame.BackgroundTransparency = 1
		killFrame.TextTransparency = 1
	end

	frameToListen.Parent.MouseLeave:connect(function()
		killTip(frameToListen)
	end)
	frameToListen.Parent.MouseButton1Click:connect(function()
		killTip(frameToListen)
	end)
end

local function createSettingsButtonTip(parent)
	if parent == nil then
		parent = bottomLeftControl:FindFirstChild "SettingsButton"
	end

	local toolTip = frameTip:clone()
	toolTip.RobloxLocked = true
	toolTip.Text = "Settings/Leave Game"
	toolTip.Position = UDim2.new(0, 0, 0, -18)
	toolTip.Size = UDim2.new(0, 120, 0, 20)
	toolTip.Parent = parent
	setUpListeners(toolTip)
end

wait(5) -- make sure we are loaded in, won't need tool tips for first 5 seconds anyway

---------------- set up Bottom Left Tool Tips -------------------------

local bottomLeftChildren = bottomLeftControl:GetChildren()

for i = 1, #bottomLeftChildren do
	if bottomLeftChildren[i].Name == "Exit" then
		local exitTip = New(frameTip:clone()) {
			RobloxLocked = true,
			Text = "Leave Place",
			Position = UDim2.new(0, 0, -1, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = bottomLeftChildren[i],
		}

		setUpListeners(exitTip)
	elseif bottomLeftChildren[i].Name == "SettingsButton" then
		createSettingsButtonTip(bottomLeftChildren[i])
	end
end

---------------- set up Bottom Right Tool Tips -------------------------

local bottomRightChildren = bottomRightControl:GetChildren()

for i = 1, #bottomRightChildren do
	if bottomRightChildren[i].Name:find "Camera" ~= nil then
		local cameraTip = New(frameTip:clone()) {
			RobloxLocked = true,
			Text = "Camera View",
			Size = UDim2.new(2, 0, 1.25, 0),
		}

		if bottomRightChildren[i].Name:find "Zoom" then
			cameraTip.Position = UDim2.new(-1, 0, -1.5)
		else
			cameraTip.Position = UDim2.new(0, 0, -1.5, 0)
		end

		cameraTip.Parent = bottomRightChildren[i]

		setUpListeners(cameraTip)
	end
end
