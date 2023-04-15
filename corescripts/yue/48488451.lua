local New
New = function(className, name, props)
	if not (props ~= nil) then
		props = name
		name = nil
	end
	local obj = New(className)
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
local popupFrame = New("Frame", "Popup", {
	Position = UDim2.new(0.5, -165, 0.5, -175),
	Size = UDim2.new(0, 330, 0, 350),
	Style = Enum.FrameStyle.RobloxRound,
	ZIndex = 4,
	Visible = false,
	Parent = script.Parent,
	New("TextLabel", "PopupText", {
		Size = UDim2.new(1, 0, 0.8, 0),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size36,
		BackgroundTransparency = 1,
		Text = "Hello I'm a popup",
		TextColor3 = Color3.new(248 / 255, 248 / 255, 248 / 255),
		TextWrap = true,
		ZIndex = 5
	}),
	New("TextButton", "AcceptButton", {
		Position = UDim2.new(0, 20, 0, 270),
		Size = UDim2.new(0, 100, 0, 50),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size24,
		Style = Enum.ButtonStyle.RobloxButton,
		TextColor3 = Color3.new(248 / 255, 248 / 255, 248 / 255),
		Text = "Yes",
		ZIndex = 5
	}),
	New("ImageLabel", "PopupImage", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -140, 0, 0),
		Size = UDim2.new(0, 280, 0, 280),
		ZIndex = 3,
		New("ImageLabel", "Backing", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Image = "http://www.roblox.com/asset/?id=47574181",
			ZIndex = 2
		})
	})
})
local AcceptButton = popupFrame.AcceptButton
do
	local _with_0 = popupFrame:clone()
	_with_0.Name = "Darken"
	_with_0.Size = UDim2.new(1, 16, 1, 16)
	_with_0.Position = UDim2.new(0, -8, 0, -8)
	_with_0.ZIndex = 1
	_with_0.Parent = popupFrame
end
do
	local _with_0 = AcceptButton:clone()
	_with_0.Name = "DeclineButton"
	_with_0.Position = UDim2.new(1, -120, 0, 270)
	_with_0.Text = "No"
	_with_0.Parent = popupFrame
end
do
	local _with_0 = AcceptButton:clone()
	_with_0.Name = "OKButton"
	_with_0.Text = "OK"
	_with_0.Position = UDim2.new(0.5, -50, 0, 270)
	_with_0.Visible = false
	_with_0.Parent = popupFrame
end
return script:remove()
