-- CoreGui.RobloxGui.CoreScripts/BackpackScripts/BackpackBuild
print "[Mercury]: Loaded corescript 53878047"

local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate

-- This script creates almost all gui elements found in the backpack (warning: there are a lot!)
-- TODO: automate this process

local gui = script.Parent

-- A couple of necessary functions
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

waitForChild(game, "Players")
waitForProperty(game.Players, "LocalPlayer")

-- Components

local function SlotNumber()
	return New "TextLabel" {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size18,
		Size = UDim2.new(0, 10, 0, 15),
		TextTransparency = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		RobloxLocked = true,
	}
end

local function GearGridScrollingArea()
	return New "Frame" {
		RobloxLocked = true,
		Name = "GearGridScrollingArea",
		Position = UDim2.new(1, -19, 0, 35),
		Size = UDim2.new(0, 17, 1, -45),
		BackgroundTransparency = 1,
	}
end

local function AttributeImage()
	return New "ImageLabel" {
		RobloxLocked = true,
		Name = "GenreImage",
		BackgroundColor3 = Color3.new(102 / 255, 153 / 255, 1),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(0.25, 0, 1, 0),
	}
end

-- First up is the current loadout
local CurrentLoadout = New "Frame" {
	Name = "CurrentLoadout",
	Position = UDim2.new(0.5, -300, 1, -85),
	Size = UDim2.new(0, 600, 0, 54),
	BackgroundTransparency = 1,
	RobloxLocked = true,
	Parent = gui,
	New "ImageLabel" {
		Name = "Background",
		Size = UDim2.new(1.2, 0, 1.2, 0),
		Image = "http://banland.xyz/asset?id=96536002",
		BackgroundTransparency = 1,
		Position = UDim2.new(-0.1, 0, -0.1, 0),
		ZIndex = 0.0,
		Visible = false,
		New "ImageLabel" {
			Size = UDim2.new(1, 0, 0.025, 1),
			Position = UDim2.new(0, 0, 0, 0),
			Image = "http://banland.xyz/asset?id=97662207",
			BackgroundTransparency = 1,
		},
	},
	New "BoolValue" {
		Name = "Debounce",
		RobloxLocked = true,
	},
	New "ImageButton" {
		Name = "TempSlot",
		Active = true,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Style = "Custom",
		Visible = false,
		RobloxLocked = true,
		ZIndex = 3.0,
		New "ImageLabel" {
			Name = "Background",
			BackgroundTransparency = 1,
			Image = "http://banland.xyz/asset?id=97613075",
			Size = UDim2.new(1, 0, 1, 0),
		},
		-- New "ImageLabel" {
		-- 	Name = "Highlight",
		-- 	BackgroundTransparency = 1,
		-- 	Image = "http://banland.xyz/asset?id=97643886",
		-- 	Size = UDim2.new(1, 0, 1, 0),
		-- 	Visible = false,
		-- }
		New "ObjectValue" {
			Name = "GearReference",
			RobloxLocked = true,
		},
		New "TextLabel" {
			Name = "ToolTipLabel",
			RobloxLocked = true,
			Text = "",
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Visible = false,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			TextStrokeTransparency = 0,
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size14,
			-- TextWrapped = true,
			Size = UDim2.new(1, 60, 0, 20),
			Position = UDim2.new(0, -30, 0, -30),
		},
		New "BoolValue" {
			Name = "Kill",
			RobloxLocked = true,
		},
		New "ImageLabel" {
			Name = "GearImage",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 5.0,
			RobloxLocked = true,
		},
		New "TextLabel" {
			RobloxLocked = true,
			Name = "GearText",
			BackgroundTransparency = 1,
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size14,
			Position = UDim2.new(0, -8, 0, -8),
			Size = UDim2.new(1, 16, 1, 16),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			TextWrapped = true,
			ZIndex = 5.0,
		},
		Hydrate(SlotNumber()) {
			Name = "SlotNumber",
			TextColor3 = Color3.new(1, 1, 1),
			Position = UDim2.new(0, 0, 0, 0),
			ZIndex = 5,
		},
		Hydrate(SlotNumber()) {
			Name = "SlotNumberDownShadow",
			TextColor3 = Color3.new(0, 0, 0),
			Position = UDim2.new(0, 1, 0, -1),
			ZIndex = 2,
		},
		Hydrate(SlotNumber()) {
			Name = "SlotNumberUpShadow",
			TextColor3 = Color3.new(0, 0, 0),
			Position = UDim2.new(0, -1, 0, -1),
			ZIndex = 2,
		},
	},
}

waitForChild(gui, "ControlFrame")

New "ImageButton" {
	RobloxLocked = true,
	Visible = false,
	Name = "BackpackButton",
	BackgroundTransparency = 1,
	Image = "http://banland.xyz/asset?id=97617958",
	Position = UDim2.new(0.5, -60, 1, -108),
	Size = UDim2.new(0, 120, 0, 18),
	Parent = gui.ControlFrame,
}

for i = 0, 9 do
	local slotFrame = New "Frame" {
		RobloxLocked = true,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.new(1, 1, 1),
		Name = "Slot" .. i,
		ZIndex = 4.0,
		Size = UDim2.new(0, 54, 1, 0),
	}
	if i == 0 then
		slotFrame.Position = UDim2.new(0.9, 0, 0, 0)
	else
		slotFrame.Position = UDim2.new((i - 1) * 0.1, (i - 1) * 6, 0, 0)
	end

	slotFrame.Parent = CurrentLoadout
end

-- Great, now lets make the inventory!
-- Ultimate nested trees of whitespace supremacy time

New "Frame" {
	RobloxLocked = true,
	Name = "Backpack",
	Visible = false,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	BackgroundColor3 = Color3.new(32 / 255, 32 / 255, 32 / 255),
	BackgroundTransparency = 0.0,
	BorderSizePixel = 0,
	Parent = gui,
	Active = true,
	New "Frame" {
		RobloxLocked = true,
		Name = "Tabs",
		Visible = false,
		Active = false,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, -0.1, -4),
		Size = UDim2.new(1, 0, 0.1, 4),
		New "Frame" {
			RobloxLocked = true,
			Name = "TabLine",
			BackgroundColor3 = Color3.new(53 / 255, 53 / 255, 53 / 255),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 5, 1, -4),
			Size = UDim2.new(1, -10, 0, 4),
			ZIndex = 2,
		},
		New "TextButton" {
			RobloxLocked = true,
			Name = "InventoryButton",
			Size = UDim2.new(0, 60, 0, 30),
			Position = UDim2.new(0, 7, 1, -31),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			Text = "Gear",
			AutoButtonColor = false,
			TextColor3 = Color3.new(0, 0, 0),
			Selected = true,
			Active = true,
			ZIndex = 3,
		},
		New "TextButton" {
			RobloxLocked = true,
			Name = "CloseButton",
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size24,
			Position = UDim2.new(1, -33, 0, 4),
			Size = UDim2.new(0, 30, 0, 30),
			Style = Enum.ButtonStyle.RobloxButton,
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			Modal = true,
			New "ImageLabel" {
				RobloxLocked = true,
				Name = "XImage",
				Image = "http://banland.xyz/asset?id=75547445",
				BackgroundTransparency = 1,
				Position = UDim2.new(-0.25, -1, -0.25, -1),
				Size = UDim2.new(1.5, 2, 1.5, 2),
				ZIndex = 2,
			},
		},
	},
	-- Generic Search gui used across backpack
	New "Frame" {
		RobloxLocked = true,
		Name = "SearchFrame",
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -220, 0, 2),
		Size = UDim2.new(0, 220, 0, 24),
		New "ImageButton" {
			RobloxLocked = true,
			Name = "SearchButton",
			Size = UDim2.new(0, 25, 0, 25),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/SearchIcon.png",
		},
		New "TextButton" {
			RobloxLocked = true,
			Position = UDim2.new(0, 25, 0, 0),
			Size = UDim2.new(1, -28, 0, 26),
			Name = "SearchBoxFrame",
			Text = "",
			Style = Enum.ButtonStyle.RobloxButton,
			New "TextBox" {
				RobloxLocked = true,
				Name = "SearchBox",
				BackgroundTransparency = 1,
				Font = Enum.Font.ArialBold,
				FontSize = Enum.FontSize.Size12,
				Position = UDim2.new(0, -5, 0, -5),
				Size = UDim2.new(1, 10, 1, 10),
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				TextWrapped = true,
				Text = "Search...",
			},
		},
		New "TextButton" {
			RobloxLocked = true,
			Visible = false,
			Name = "ResetButton",
			Position = UDim2.new(1, -26, 0, 3),
			Size = UDim2.new(0, 20, 0, 20),
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Text = "X",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			ZIndex = 3,
		},
	},
	New "BoolValue" {
		RobloxLocked = true,
		Name = "SwapSlot",
		New "IntValue" {
			RobloxLocked = true,
			Name = "Slot",
		},
		New "ObjectValue" {
			RobloxLocked = true,
			Name = "GearButton",
		},
	},
	New "Frame" {
		Name = "Gear",
		RobloxLocked = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDescendants = true,
		New "Frame" {
			RobloxLocked = true,
			Name = "AssetsList",
			BackgroundTransparency = 1,
			Size = UDim2.new(0.2, 0, 1, 0),
			Style = Enum.FrameStyle.RobloxSquare,
			Visible = false,
		},
		GearGridScrollingArea(),
		New "Frame" {
			RobloxLocked = true,
			Name = "GearLoadouts",
			BackgroundTransparency = 1,
			Position = UDim2.new(0.7, 23, 0.5, 1),
			Size = UDim2.new(0.3, -23, 0.5, -1),
			Visible = false,
			New "Frame" {
				RobloxLocked = true,
				Name = "GearLoadoutsHeader",
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0.2,
				BorderColor3 = Color3.new(1, 0, 0),
				Size = UDim2.new(1, 2, 0.15, -1),
				New "TextLabel" {
					RobloxLocked = true,
					Name = "LoadoutsHeaderText",
					BackgroundTransparency = 1,
					Font = Enum.Font.ArialBold,
					FontSize = Enum.FontSize.Size18,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "Loadouts",
					TextColor3 = Color3.new(1, 1, 1),
				},
			},
			Hydrate(GearGridScrollingArea()) {
				Name = "GearLoadoutsScrollingArea",
				Position = UDim2.new(1, -15, 0.15, 2),
				Size = UDim2.new(0, 17, 0.85, -2),
			},
			New "Frame" {
				RobloxLocked = true,
				Name = "LoadoutsList",
				Position = UDim2.new(0, 0, 0.15, 2),
				Size = UDim2.new(1, -17, 0.85, -2),
				Style = Enum.FrameStyle.RobloxSquare,
			},
		},
		New "Frame" {
			RobloxLocked = true,
			Name = "GearPreview",
			Position = UDim2.new(0.7, 23, 0, 0),
			Size = UDim2.new(0.3, -28, 0.5, -1),
			BackgroundTransparency = 1,
			ZIndex = 7,
			New "Frame" {
				RobloxLocked = true,
				Name = "GearStats",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0.75, 0),
				Size = UDim2.new(1, 0, 0.25, 0),
				ZIndex = 8,
				New "TextLabel" {
					RobloxLocked = true,
					Name = "GearName",
					BackgroundTransparency = 1,
					Font = Enum.Font.ArialBold,
					FontSize = Enum.FontSize.Size18,
					Position = UDim2.new(0, -3, 0, 0),
					Size = UDim2.new(1, 6, 1, 5),
					Text = "",
					TextColor3 = Color3.new(1, 1, 1),
					TextWrapped = true,
					ZIndex = 9,
				},
			},
			New "ImageLabel" {
				RobloxLocked = true,
				Name = "GearImage",
				Image = "",
				BackgroundTransparency = 1,
				Position = UDim2.new(0.125, 0, 0, 0),
				Size = UDim2.new(0.75, 0, 0.75, 0),
				ZIndex = 8,
				New "Frame" {
					BackgroundColor3 = Color3.new(0, 0, 0),
					BackgroundTransparency = 0.5,
					BorderSizePixel = 0,
					RobloxLocked = true,
					Name = "GearIcons",
					Position = UDim2.new(0.4, 2, 0.85, -2),
					Size = UDim2.new(0.6, 0, 0.15, 0),
					Visible = false,
					ZIndex = 9,
					AttributeImage(),
					Hydrate(AttributeImage()) {
						Name = "AttributeOneImage",
						BackgroundColor3 = Color3.new(1, 51 / 255, 0),
						Position = UDim2.new(0.25, 0, 0, 0),
					},
					Hydrate(AttributeImage()) {
						Name = "AttributeTwoImage",
						BackgroundColor3 = Color3.new(153 / 255, 1, 153 / 255),
						Position = UDim2.new(0.5, 0, 0, 0),
					},
					Hydrate(AttributeImage()) {
						Name = "AttributeThreeImage",
						BackgroundColor3 = Color3.new(0, 0.5, 0.5),
						Position = UDim2.new(0.75, 0, 0, 0),
					},
				},
			},
		},
		New "Frame" {
			RobloxLocked = true,
			Name = "GearGrid",
			Size = UDim2.new(0.95, 0, 1, 0),
			BackgroundTransparency = 1,
			New "ImageButton" {
				RobloxLocked = true,
				Visible = false,
				Name = "GearButton",
				Size = UDim2.new(0, 54, 0, 54),
				Style = "Custom",
				BackgroundTransparency = 1,
				New "Frame" {
					RobloxLocked = true,
					Name = "GreyOutButton",
					BackgroundTransparency = 0.5,
					Size = UDim2.new(1, 0, 1, 0),
					Active = true,
					Visible = false,
					ZIndex = 3,
				},
				New "ImageLabel" {
					Name = "Background",
					BackgroundTransparency = 1,
					Image = "http://banland.xyz/asset?id=97613075",
					Size = UDim2.new(1, 0, 1, 0),
				},
				New "ObjectValue" {
					RobloxLocked = true,
					Name = "GearReference",
				},
				New "TextLabel" {
					RobloxLocked = true,
					Name = "GearText",
					BackgroundTransparency = 1,
					Font = Enum.Font.Arial,
					FontSize = Enum.FontSize.Size14,
					Position = UDim2.new(0, -8, 0, -8),
					Size = UDim2.new(1, 16, 1, 16),
					Text = "",
					ZIndex = 2,
					TextColor3 = Color3.new(1, 1, 1),
					TextWrapped = true,
				},
			},
		},
	},
}

-- wardrobe is gone lmao
