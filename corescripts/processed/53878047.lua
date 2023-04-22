if game.CoreGui.Version < 3 then
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
local gui = script.Parent
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
local IsTouchDevice
IsTouchDevice = function()
	local touchEnabled = false
pcall(function()
		touchEnabled = Game:GetService("UserInputService").TouchEnabled
	end)
	return touchEnabled
end
local IsPhone
IsPhone = function()
	if gui.AbsoluteSize.Y <= 320 then
		return true
	else
		return false
	end
end
waitForChild(game, "Players")
waitForProperty(game.Players, "LocalPlayer")
local CurrentLoadout = New("Frame", "CurrentLoadout", {
	Position = UDim2.new(0.5, -300, 1, -85),
	Size = UDim2.new(0, 600, 0, 54),
	BackgroundTransparency = 1,
	RobloxLocked = true,
	Parent = gui,
	New("BoolValue", "Debounce", {
		RobloxLocked = true
	}),
	New("ImageLabel", "Background", {
		Size = UDim2.new(1.2, 0, 1.2, 0),
		Image = "http://www.roblox.com/asset/?id=96536002",
		BackgroundTransparency = 1,
		Position = UDim2.new(-0.1, 0, -0.1, 0),
		ZIndex = 0.0,
		Visible = false,
		New("ImageLabel", {
			Size = UDim2.new(1, 0, 0.025, 1),
			Position = UDim2.new(0, 0, 0, 0),
			Image = "http://www.roblox.com/asset/?id=97662207",
			BackgroundTransparency = 1
		})
	})
})
waitForChild(gui, "ControlFrame")
New("ImageButton", "BackpackButton", {
	RobloxLocked = true,
	Visible = false,
	BackgroundTransparency = 1,
	Image = "http://www.roblox.com/asset/?id=97617958",
	Position = UDim2.new(0.5, -60, 1, -108),
	Size = UDim2.new(0, 120, 0, 18),
	Parent = gui.ControlFrame
})
local NumSlots = 9
if IsPhone() then
	NumSlots = 3
	CurrentLoadout.Size = UDim2.new(0, 180, 0, 54)
	CurrentLoadout.Position = UDim2.new(0.5, -90, 1, -85)
end
for i = 0, NumSlots do
	local slotFrame = New("Frame", {
		Name = "Slot" .. tostring(i),
		RobloxLocked = true,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.new(1, 1, 1),
		ZIndex = 4.0,
		Position = UDim2.new((function()
			if i == 0 then
				return 0.9, 0, 0, 0
			else
				return (i - 1) * 0.1, (i - 1) * 6, 0, 0
			end
		end)()),
		Size = UDim2.new(0, 54, 1, 0),
		Parent = CurrentLoadout
	})
	if gui.AbsoluteSize.Y <= 320 then
		slotFrame.Position = UDim2.new(0, (i - 1) * 60, 0, -50)
		print("Well got here", slotFrame, slotFrame.Position.X.Scale, slotFrame.Position.X.Offset)
		if i == 0 then
			slotFrame:Destroy()
		end
	end
end
local TempSlot = New("ImageButton", "TempSlot", {
	Active = true,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Style = "Custom",
	Visible = false,
	RobloxLocked = true,
	ZIndex = 3.0,
	Parent = CurrentLoadout,
	New("ImageLabel", "Background", {
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=97613075",
		Size = UDim2.new(1, 0, 1, 0)
	}),
	New("ObjectValue", "GearReference", {
		RobloxLocked = true
	}),
	New("TextLabel", "ToolTipLabel", {
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
		Size = UDim2.new(1, 60, 0, 20),
		Position = UDim2.new(0, -30, 0, -30)
	}),
	New("BoolValue", "Kill", {
		RobloxLocked = true
	}),
	New("TextLabel", "GearText", {
		RobloxLocked = true,
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size14,
		Position = UDim2.new(0, -8, 0, -8),
		Size = UDim2.new(1, 16, 1, 16),
		Text = "",
		TextColor3 = Color3.new(1, 1, 1),
		TextWrap = true,
		ZIndex = 5.0
	}),
	New("ImageLabel", "GearImage", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 5.0,
		RobloxLocked = true
	})
})
local SlotNumber = New("TextLabel", "SlotNumber", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size18,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(0, 10, 0, 15),
	TextColor3 = Color3.new(1, 1, 1),
	TextTransparency = 0,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Bottom,
	RobloxLocked = true,
	Parent = TempSlot,
	ZIndex = 5
})
if IsTouchDevice() then
	SlotNumber.Visible = false
end
local SlotNumberDownShadow
do
	local _with_0 = SlotNumber:Clone()
	_with_0.Name = "SlotNumberDownShadow"
	_with_0.TextColor3 = Color3.new(0, 0, 0)
	_with_0.Position = UDim2.new(0, 1, 0, -1)
	_with_0.Parent = TempSlot
	_with_0.ZIndex = 2
	SlotNumberDownShadow = _with_0
end
do
	local _with_0 = SlotNumberDownShadow:Clone()
	_with_0.Name = "SlotNumberUpShadow"
	_with_0.Position = UDim2.new(0, -1, 0, -1)
	_with_0.Parent = TempSlot
end
local Backpack = New("Frame", "Backpack", {
	RobloxLocked = true,
	Visible = false,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	BackgroundColor3 = Color3.new(32 / 255, 32 / 255, 32 / 255),
	BackgroundTransparency = 0.0,
	BorderSizePixel = 0,
	Parent = gui,
	Active = true,
	New("BoolValue", "SwapSlot", {
		RobloxLocked = true,
		New("IntValue", "Slot", {
			RobloxLocked = true
		}),
		New("ObjectValue", "GearButton", {
			RobloxLocked = true
		})
	}),
	New("Frame", "SearchFrame", {
		RobloxLocked = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -220, 0, 2),
		Size = UDim2.new(0, 220, 0, 24),
		New("ImageButton", "SearchButton", {
			RobloxLocked = true,
			Size = UDim2.new(0, 25, 0, 25),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/SearchIcon.png"
		}),
		New("TextButton", "ResetButton", {
			RobloxLocked = true,
			Visible = false,
			Position = UDim2.new(1, -26, 0, 3),
			Size = UDim2.new(0, 20, 0, 20),
			Style = Enum.ButtonStyle.RobloxButtonDefault,
			Text = "X",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			ZIndex = 3
		}),
		New("TextButton", "SearchBoxFrame", {
			RobloxLocked = true,
			Position = UDim2.new(0, 25, 0, 0),
			Size = UDim2.new(1, -28, 0, 26),
			Text = "",
			Style = Enum.ButtonStyle.RobloxButton,
			New("TextBox", "SearchBox", {
				RobloxLocked = true,
				BackgroundTransparency = 1,
				Font = Enum.Font.ArialBold,
				FontSize = Enum.FontSize.Size12,
				Position = UDim2.new(0, -5, 0, -5),
				Size = UDim2.new(1, 10, 1, 10),
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				TextWrap = true,
				Text = "Search..."
			})
		})
	})
})
local Tabs = New("Frame", "Tabs", {
	Visible = false,
	Active = false,
	RobloxLocked = true,
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.08,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, -0.1, -4),
	Size = UDim2.new(1, 0, 0.1, 4),
	Parent = Backpack,
	New("Frame", "TabLine", {
		RobloxLocked = true,
		BackgroundColor3 = Color3.new(53 / 255, 53 / 255, 53 / 255),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 5, 1, -4),
		Size = UDim2.new(1, -10, 0, 4),
		ZIndex = 2
	}),
	New("TextButton", "InventoryButton", {
		RobloxLocked = true,
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
		ZIndex = 3
	}),
	New("TextButton", "CloseButton", {
		RobloxLocked = true,
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size24,
		Position = UDim2.new(1, -33, 0, 4),
		Size = UDim2.new(0, 30, 0, 30),
		Style = Enum.ButtonStyle.RobloxButton,
		Text = "",
		TextColor3 = Color3.new(1, 1, 1),
		Modal = true,
		New("ImageLabel", "XImage", {
			RobloxLocked = true,
			Image = (function()
				game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=75547445")
				return "http://www.roblox.com/asset/?id=75547445"
			end)(),
			BackgroundTransparency = 1,
			Position = UDim2.new(-0.25, -1, -0.25, -1),
			Size = UDim2.new(1.5, 2, 1.5, 2),
			ZIndex = 2
		})
	})
})
if game.CoreGui.Version >= 8 then
	New("TextButton", "WardrobeButton", {
		RobloxLocked = true,
		Size = UDim2.new(0, 90, 0, 30),
		Position = UDim2.new(0, 77, 1, -31),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size18,
		Text = "Wardrobe",
		AutoButtonColor = false,
		TextColor3 = Color3.new(1, 1, 1),
		Selected = false,
		Active = true,
		Parent = Tabs
	})
end
local Gear = New("Frame", "Gear", {
	RobloxLocked = true,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 1, 0),
	ClipsDescendants = true,
	Parent = Backpack,
	New("Frame", "AssetsList", {
		RobloxLocked = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.2, 0, 1, 0),
		Style = Enum.FrameStyle.RobloxSquare,
		Visible = false
	}),
	New("Frame", "GearGrid", {
		RobloxLocked = true,
		Size = UDim2.new(0.95, 0, 1, 0),
		BackgroundTransparency = 1,
		New("ImageButton", "GearButton", {
			RobloxLocked = true,
			Visible = false,
			Size = UDim2.new(0, 54, 0, 54),
			Style = "Custom",
			BackgroundTransparency = 1,
			New("ImageLabel", "Background", {
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=97613075",
				Size = UDim2.new(1, 0, 1, 0)
			}),
			New("ObjectValue", "GearReference", {
				RobloxLocked = true
			}),
			New("Frame", "GreyOutButton", {
				RobloxLocked = true,
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 1, 0),
				Active = true,
				Visible = false,
				ZIndex = 3
			}),
			New("TextLabel", "GearText", {
				RobloxLocked = true,
				BackgroundTransparency = 1,
				Font = Enum.Font.Arial,
				FontSize = Enum.FontSize.Size14,
				Position = UDim2.new(0, -8, 0, -8),
				Size = UDim2.new(1, 16, 1, 16),
				Text = "",
				ZIndex = 2,
				TextColor3 = Color3.new(1, 1, 1),
				TextWrap = true
			})
		})
	})
})
local GearGridScrollingArea = New("Frame", "GearGridScrollingArea", {
	RobloxLocked = true,
	Position = UDim2.new(1, -19, 0, 35),
	Size = UDim2.new(0, 17, 1, -45),
	BackgroundTransparency = 1,
	Parent = Gear
})
local GearLoadouts = New("Frame", "GearLoadouts", {
	RobloxLocked = true,
	BackgroundTransparency = 1,
	Position = UDim2.new(0.7, 23, 0.5, 1),
	Size = UDim2.new(0.3, -23, 0.5, -1),
	Parent = Gear,
	Visible = false,
	New("Frame", "LoadoutsList", {
		RobloxLocked = true,
		Position = UDim2.new(0, 0, 0.15, 2),
		Size = UDim2.new(1, -17, 0.85, -2),
		Style = Enum.FrameStyle.RobloxSquare
	}),
	New("Frame", "GearLoadoutsHeader", {
		RobloxLocked = true,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.2,
		BorderColor3 = Color3.new(1, 0, 0),
		Size = UDim2.new(1, 2, 0.15, -1),
		New("TextLabel", "LoadoutsHeaderText", {
			RobloxLocked = true,
			BackgroundTransparency = 1,
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "Loadouts",
			TextColor3 = Color3.new(1, 1, 1)
		})
	})
})
do
	local _with_0 = GearGridScrollingArea:Clone()
	_with_0.Name = "GearLoadoutsScrollingArea"
	_with_0.RobloxLocked = true
	_with_0.Position = UDim2.new(1, -15, 0.15, 2)
	_with_0.Size = UDim2.new(0, 17, 0.85, -2)
	_with_0.Parent = GearLoadouts
end
local GearPreview = New("Frame", "GearPreview", {
	RobloxLocked = true,
	Position = UDim2.new(0.7, 23, 0, 0),
	Size = UDim2.new(0.3, -28, 0.5, -1),
	BackgroundTransparency = 1,
	ZIndex = 7,
	Parent = Gear,
	New("Frame", "GearStats", {
		RobloxLocked = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0.75, 0),
		Size = UDim2.new(1, 0, 0.25, 0),
		ZIndex = 8,
		New("TextLabel", "GearName", {
			RobloxLocked = true,
			BackgroundTransparency = 1,
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0, -3, 0, 0),
			Size = UDim2.new(1, 6, 1, 5),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			TextWrap = true,
			ZIndex = 9
		})
	}),
	New("ImageLabel", "GearImage", {
		RobloxLocked = true,
		Image = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.125, 0, 0, 0),
		Size = UDim2.new(0.75, 0, 0.75, 0),
		ZIndex = 8,
		New("Frame", "GearIcons", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			RobloxLocked = true,
			Position = UDim2.new(0.4, 2, 0.85, -2),
			Size = UDim2.new(0.6, 0, 0.15, 0),
			Visible = false,
			ZIndex = 9,
			New("ImageLabel", "GenreImage", {
				RobloxLocked = true,
				BackgroundColor3 = Color3.new(102 / 255, 153 / 255, 1),
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				Size = UDim2.new(0.25, 0, 1, 0)
			})
		})
	})
})
local GearIcons, GenreImage
do
	local _obj_0 = GearPreview.GearImage
	GearIcons, GenreImage = _obj_0.GearIcons, _obj_0.GearIcons.GenreImage
end
do
	local _with_0 = GenreImage:Clone()
	_with_0.Name = "AttributeOneImage"
	_with_0.RobloxLocked = true
	_with_0.BackgroundColor3 = Color3.new(1, 51 / 255, 0)
	_with_0.Position = UDim2.new(0.25, 0, 0, 0)
	_with_0.Parent = GearIcons
end
do
	local _with_0 = GenreImage:Clone()
	_with_0.Name = "AttributeTwoImage"
	_with_0.RobloxLocked = true
	_with_0.BackgroundColor3 = Color3.new(153 / 255, 1, 153 / 255)
	_with_0.Position = UDim2.new(0.5, 0, 0, 0)
	_with_0.Parent = GearIcons
end
do
	local _with_0 = GenreImage:Clone()
	_with_0.Name = "AttributeThreeImage"
	_with_0.RobloxLocked = true
	_with_0.BackgroundColor3 = Color3.new(0, 0.5, 0.5)
	_with_0.Position = UDim2.new(0.75, 0, 0, 0)
	_with_0.Parent = GearIcons
end
if game.CoreGui.Version < 8 then
	script:remove()
	return
end
local makeCharFrame
makeCharFrame = function(frameName, parent)
	return New("Frame", tostring(frameName), {
		RobloxLocked = true,
		Size = UDim2.new(1, 0, 1, -70),
		Position = UDim2.new(0, 0, 0, 20),
		BackgroundTransparency = 1,
		Parent = parent,
		Visible = false
	})
end
local makeZone
makeZone = function(zoneName, image, size, position, parent)
	return New("ImageLabel", tostring(zoneName), {
		RobloxLocked = true,
		Image = image,
		Size = size,
		BackgroundTransparency = 1,
		Position = position,
		Parent = parent
	})
end
local makeStyledButton
makeStyledButton = function(buttonName, size, position, parent, buttonStyle)
	local button = New("ImageButton", tostring(buttonName), {
		RobloxLocked = true,
		Size = size,
		Position = position
	})
	if buttonStyle then
		button.Style = buttonStyle
	else
		button.BackgroundColor3 = Color3.new(0, 0, 0)
		button.BorderColor3 = Color3.new(1, 1, 1)
	end
	button.Parent = parent
	return button
end
local makeTextLabel
makeTextLabel = function(TextLabelName, text, position, parent)
	return New("TextLabel", {
		Name = TextLabelName,
		RobloxLocked = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 32, 0, 14),
		Font = Enum.Font.Arial,
		TextColor3 = Color3.new(1, 1, 1),
		FontSize = Enum.FontSize.Size14,
		Text = text,
		Position = position,
		Parent = parent
	})
end
local Wardrobe = New("Frame", "Wardrobe", {
	RobloxLocked = true,
	BackgroundTransparency = 1,
	Visible = false,
	Size = UDim2.new(1, 0, 1, 0),
	Parent = Backpack,
	New("Frame", "AssetList", {
		RobloxLocked = true,
		Position = UDim2.new(0, 4, 0, 5),
		Size = UDim2.new(0, 85, 1, -5),
		BackgroundTransparency = 1,
		Visible = true
	}),
	New("TextButton", "PreviewButton", {
		RobloxLocked = true,
		Text = "Rotate",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderColor3 = Color3.new(1, 1, 1),
		Position = UDim2.new(1.2, -62, 1, -50),
		Size = UDim2.new(0, 125, 0, 50),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size24,
		TextColor3 = Color3.new(1, 1, 1),
		TextWrapped = true,
		TextStrokeTransparency = 0
	})
})
local PreviewAssetFrame = New("Frame", "PreviewAssetFrame", {
	RobloxLocked = true,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -240, 0, 30),
	Size = UDim2.new(0, 250, 0, 250),
	Parent = Wardrobe
})
local PreviewAssetBacking = New("TextButton", "PreviewAssetBacking", {
	RobloxLocked = true,
	Active = false,
	Text = "",
	AutoButtonColor = false,
	Size = UDim2.new(1, 0, 1, 0),
	Style = Enum.ButtonStyle.RobloxButton,
	Visible = false,
	ZIndex = 9,
	Parent = PreviewAssetFrame,
	New("ImageLabel", "PreviewAssetImage", {
		RobloxLocked = true,
		BackgroundTransparency = 0.8,
		Position = UDim2.new(0.5, -100, 0, 0),
		Size = UDim2.new(0, 200, 0, 200),
		BorderSizePixel = 0,
		ZIndex = 10
	})
})
local AssetNameLabel = New("TextLabel", "AssetNameLabel", {
	RobloxLocked = true,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 1, -20),
	Size = UDim2.new(0.5, 0, 0, 24),
	ZIndex = 10,
	Font = Enum.Font.Arial,
	Text = "",
	TextColor3 = Color3.new(1, 1, 1),
	TextScaled = true,
	Parent = PreviewAssetBacking
})
do
	local _with_0 = AssetNameLabel:Clone()
	_with_0.Name = "AssetTypeLabel"
	_with_0.RobloxLocked = true
	_with_0.TextScaled = false
	_with_0.FontSize = Enum.FontSize.Size18
	_with_0.Position = UDim2.new(0.5, 3, 1, -20)
	_with_0.Parent = PreviewAssetBacking
end
local CharacterPane = New("Frame", "CharacterPane", {
	RobloxLocked = true,
	Position = UDim2.new(1, -220, 0, 32),
	Size = UDim2.new(0, 220, 1, -40),
	BackgroundTransparency = 1,
	Visible = true,
	Parent = Wardrobe,
	New("TextLabel", "CategoryLabel", {
		RobloxLocked = true,
		BackgroundTransparency = 1,
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0, 0, 0, -7),
		Size = UDim2.new(1, 0, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Center,
		Text = "All",
		TextColor3 = Color3.new(1, 1, 1)
	}),
	New("TextButton", "SaveButton", {
		RobloxLocked = true,
		Size = UDim2.new(0.6, 0, 0, 50),
		Position = UDim2.new(0.2, 0, 1, -50),
		Style = Enum.ButtonStyle.RobloxButton,
		Selected = false,
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size18,
		Text = "Save",
		TextColor3 = Color3.new(1, 1, 1)
	})
})
local FaceFrame = makeCharFrame("FacesFrame", CharacterPane)
game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=75460621")
makeZone("FaceZone", "http://www.roblox.com/asset/?id=75460621", UDim2.new(0, 157, 0, 137), UDim2.new(0.5, -78, 0.5, -68), FaceFrame)
makeStyledButton("Face", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -32, 0.5, -135), FaceFrame)
local HeadFrame = makeCharFrame("HeadsFrame", CharacterPane)
makeZone("FaceZone", "http://www.roblox.com/asset/?id=75460621", UDim2.new(0, 157, 0, 137), UDim2.new(0.5, -78, 0.5, -68), HeadFrame)
makeStyledButton("Head", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -32, 0.5, -135), HeadFrame)
local HatsFrame = makeCharFrame("HatsFrame", CharacterPane)
game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=75457888")
local HatsZone = makeZone("HatsZone", "http://www.roblox.com/asset/?id=75457888", UDim2.new(0, 186, 0, 184), UDim2.new(0.5, -93, 0.5, -100), HatsFrame)
makeStyledButton("Hat1Button", UDim2.new(0, 64, 0, 64), UDim2.new(0, -1, 0, -1), HatsZone, Enum.ButtonStyle.RobloxButton)
makeStyledButton("Hat2Button", UDim2.new(0, 64, 0, 64), UDim2.new(0, 63, 0, -1), HatsZone, Enum.ButtonStyle.RobloxButton)
makeStyledButton("Hat3Button", UDim2.new(0, 64, 0, 64), UDim2.new(0, 127, 0, -1), HatsZone, Enum.ButtonStyle.RobloxButton)
local PantsFrame = makeCharFrame("PantsFrame", CharacterPane)
game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=75457920")
makeZone("PantsZone", "http://www.roblox.com/asset/?id=75457920", UDim2.new(0, 121, 0, 99), UDim2.new(0.5, -60, 0.5, -100), PantsFrame)
local pantFrame = New("Frame", "PantFrame", {
	RobloxLocked = true,
	Size = UDim2.new(0, 25, 0, 56),
	Position = UDim2.new(0.5, -26, 0.5, 0),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BorderColor3 = Color3.new(1, 1, 1),
	Parent = PantsFrame
})
do
	local _with_0 = pantFrame:Clone()
	_with_0.Position = UDim2.new(0.5, 3, 0.5, 0)
	_with_0.RobloxLocked = true
	_with_0.Parent = PantsFrame
end
New("ImageButton", "CurrentPants", {
	RobloxLocked = true,
	BackgroundTransparency = 1,
	ZIndex = 2,
	Position = UDim2.new(0.5, -31, 0.5, -4),
	Size = UDim2.new(0, 54, 0, 59),
	Parent = PantsFrame
})
local MeshFrame = makeCharFrame("PackagesFrame", CharacterPane)
local torsoButton = makeStyledButton("TorsoMeshButton", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -32, 0.5, -110), MeshFrame, Enum.ButtonStyle.RobloxButton)
makeTextLabel("TorsoLabel", "Torso", UDim2.new(0.5, -16, 0, -25), torsoButton)
local leftLegButton = makeStyledButton("LeftLegMeshButton", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, 0, 0.5, -25), MeshFrame, Enum.ButtonStyle.RobloxButton)
makeTextLabel("LeftLegLabel", "Left Leg", UDim2.new(0.5, -16, 0, -25), leftLegButton)
local rightLegButton = makeStyledButton("RightLegMeshButton", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -64, 0.5, -25), MeshFrame, Enum.ButtonStyle.RobloxButton)
makeTextLabel("RightLegLabel", "Right Leg", UDim2.new(0.5, -16, 0, -25), rightLegButton)
local rightArmButton = makeStyledButton("RightArmMeshButton", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -96, 0.5, -110), MeshFrame, Enum.ButtonStyle.RobloxButton)
makeTextLabel("RightArmLabel", "Right Arm", UDim2.new(0.5, -16, 0, -25), rightArmButton)
local leftArmButton = makeStyledButton("LeftArmMeshButton", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, 32, 0.5, -110), MeshFrame, Enum.ButtonStyle.RobloxButton)
makeTextLabel("LeftArmLabel", "Left Arm", UDim2.new(0.5, -16, 0, -25), leftArmButton)
local TShirtFrame = makeCharFrame("T-ShirtsFrame", CharacterPane)
game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=75460642")
makeZone("TShirtZone", "http://www.roblox.com/asset/?id=75460642", UDim2.new(0, 121, 0, 154), UDim2.new(0.5, -60, 0.5, -100), TShirtFrame)
makeStyledButton("TShirtButton", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -32, 0.5, -64), TShirtFrame)
local ShirtFrame = makeCharFrame("ShirtsFrame", CharacterPane)
makeZone("ShirtZone", "http://www.roblox.com/asset/?id=75460642", UDim2.new(0, 121, 0, 154), UDim2.new(0.5, -60, 0.5, -100), ShirtFrame)
makeStyledButton("ShirtButton", UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -32, 0.5, -64), ShirtFrame)
local ColorFrame = makeCharFrame("ColorFrame", CharacterPane)
game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=76049888")
local ColorZone = makeZone("ColorZone", "http://www.roblox.com/asset/?id=76049888", UDim2.new(0, 120, 0, 150), UDim2.new(0.5, -60, 0.5, -100), ColorFrame)
makeStyledButton("Head", UDim2.new(0.26, 0, 0.19, 0), UDim2.new(0.37, 0, 0.02, 0), ColorZone).AutoButtonColor = false
makeStyledButton("LeftArm", UDim2.new(0.19, 0, 0.36, 0), UDim2.new(0.78, 0, 0.26, 0), ColorZone).AutoButtonColor = false
makeStyledButton("RightArm", UDim2.new(0.19, 0, 0.36, 0), UDim2.new(0.025, 0, 0.26, 0), ColorZone).AutoButtonColor = false
makeStyledButton("Torso", UDim2.new(0.43, 0, 0.36, 0), UDim2.new(0.28, 0, 0.26, 0), ColorZone).AutoButtonColor = false
makeStyledButton("RightLeg", UDim2.new(0.19, 0, 0.31, 0), UDim2.new(0.275, 0, 0.67, 0), ColorZone).AutoButtonColor = false
makeStyledButton("LeftLeg", UDim2.new(0.19, 0, 0.31, 0), UDim2.new(0.525, 0, 0.67, 0), ColorZone).AutoButtonColor = false
return script:Destroy()
