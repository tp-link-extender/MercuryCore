-- CoreGui.RobloxGui.CoreScripts/PopupScript
print "[Graphictoria]: Loaded corescript 48488451"

local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate

--build our gui

local popupFrame = New "Frame" {
	Name = "Popup",
	Position = UDim2.new(0.5, -165, 0.5, -175),
	Size = UDim2.new(0, 330, 0, 350),
	Style = Enum.FrameStyle.RobloxRound,
	ZIndex = 4,
	Visible = false,
	Parent = script.Parent,
	New "ImageLabel" {
		Name = "PopupImage",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -140, 0, 0),
		Size = UDim2.new(0, 280, 0, 280),
		ZIndex = 3,
		New "ImageLabel" {
			Name = "Backing",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Image = "http://banland.xyz/asset?id=47574181",
			ZIndex = 2,
		},
	},
	New "TextLabel" {
		Name = "PopupText",
		Size = UDim2.new(1, 0, 0.8, 0),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size36,
		BackgroundTransparency = 1,
		Text = "Hello I'm a popup",
		TextColor3 = Color3.new(248 / 255, 248 / 255, 248 / 255),
		TextWrap = true,
		ZIndex = 5,
	},
}
Hydrate(popupFrame:Clone()) {
	Name = "Darken",
	Size = UDim2.new(1, 16, 1, 16),
	Position = UDim2.new(0, -8, 0, -8),
	ZIndex = 1,
	Parent = popupFrame,
}
local acceptButton = New "TextButton" {
	Name = "AcceptButton",
	Position = UDim2.new(0, 20, 0, 270),
	Size = UDim2.new(0, 100, 0, 50),
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size24,
	Style = Enum.ButtonStyle.RobloxButton,
	TextColor3 = Color3.new(248 / 255, 248 / 255, 248 / 255),
	Text = "Yes",
	ZIndex = 5,
	Parent = popupFrame,
}
Hydrate(acceptButton:Clone()) {
	Name = "DeclineButton",
	Text = "No",
	Position = UDim2.new(1, -120, 0, 270),
	Parent = popupFrame,
}
Hydrate(acceptButton:Clone()) {
	Name = "OKButton",
	Text = "OK",
	Position = UDim2.new(0.5, -50, 0, 270),
	Visible = false,
	Parent = popupFrame,
}

script:remove()
