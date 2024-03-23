local Players = game:GetService "Players"

local New = (require "../Modules/New").New

return function(parent: Instance)
	local username = Players.LocalPlayer.Name
	if username ~= "Heliodex" then -- Don't show the debug console for anyone but me
		return
	end

	local logEvent = New "BindableEvent" {
		Name = "Log",
		Parent = parent,
	}

	local screen = New "ScreenGui" {
		Name = "Debug console",
		Parent = parent,
	}

	local frame = New "Frame" {
		Name = "Frame",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		Parent = screen
		New "TextBox" {
			Name = "Input",
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, -30),
			Size = UDim2.new(1, 0, 0, 30),
			Font = Enum.Font.SourceSans,
			FontSize = Enum.FontSize.Size14,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
		},
	}

	local console = New "TextBox" {
		Name = "Console",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -30),
		Size = UDim2.new(1, 0, 0, 30),
		Font = Enum.Font.SourceSans,
		FontSize = Enum.FontSize.Size14,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	}
end
