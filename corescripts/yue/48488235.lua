local ADMINS = {
	taskmanager = 1,
	Heliodex = 1,
	multako = "http://www.roblox.com/asset/?id=6923328292",
	mercury = 1,
	pizzaboxer = "http://www.roblox.com/asset/?id=6917566633"
}
local Images = {
	bottomDark = "94691904",
	bottomLight = "94691940",
	midDark = "94691980",
	midLight = "94692025",
	LargeDark = "96098866",
	LargeLight = "96098920",
	LargeHeader = "96097470",
	NormalHeader = "94692054",
	LargeBottom = "96397271",
	NormalBottom = "94754966",
	DarkBluePopupMid = "97114905",
	LightBluePopupMid = "97114905",
	DarkPopupMid = "97112126",
	LightPopupMid = "97109338",
	DarkBluePopupTop = "97114838",
	DarkBluePopupBottom = "97114758",
	DarkPopupBottom = "100869219",
	LightPopupBottom = "97109175"
}
local BASE_TWEEN = 0.25
local MOUSE_DRAG_DISTANCE = 15
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
local MakeBackgroundGuiObj
MakeBackgroundGuiObj = function(imgName)
	return New("ImageLabel", "Background", {
		BackgroundTransparency = 1,
		Image = imgName,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	})
end
local Color3I
Color3I = function(r, g, b)
	return Color3.new(r / 255, g / 255, b / 255)
end
local getMembershipTypeIcon
getMembershipTypeIcon = function(membershipType, playerName)
	if (ADMINS[string.lower(playerName)] ~= nil) then
		if ADMINS[string.lower(playerName)] == 1 then
			return "http://www.roblox.com/asset/?id=6923330951"
		else
			return ADMINS[string.lower(playerName)]
		end
	elseif membershipType == Enum.MembershipType.None then
		return ""
	elseif membershipType == Enum.MembershipType.BuildersClub then
		return "rbxasset://textures/ui/TinyBcIcon.png"
	elseif membershipType == Enum.MembershipType.TurboBuildersClub then
		return "rbxasset://textures/ui/TinyTbcIcon.png"
	elseif membershipType == Enum.MembershipType.OutrageousBuildersClub then
		return "rbxasset://textures/ui/TinyObcIcon.png"
	else
		return error("Unknown membershipType " .. tostring(membershipType))
	end
end
local getFriendStatusIcon
getFriendStatusIcon = function(friendStatus)
	if friendStatus == Enum.FriendStatus.Unknown or friendStatus == Enum.FriendStatus.NotFriend then
		return ""
	elseif friendStatus == Enum.FriendStatus.Friend then
		return "http://www.roblox.com/asset/?id=99749771"
	elseif friendStatus == Enum.FriendStatus.FriendRequestSent then
		return "http://www.roblox.com/asset/?id=99776888"
	elseif friendStatus == Enum.FriendStatus.FriendRequestReceived then
		return "http://www.roblox.com/asset/?id=99776838"
	else
		return error("Unknown FriendStatus: " .. tostring(friendStatus))
	end
end
local MakePopupButton
MakePopupButton = function(nparent, ntext, index, last)
	local tobj = New("ImageButton", "ReportButton", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1 * index, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 7,
		Parent = nparent,
		New("TextLabel", "ButtonText", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0.07, 0, 0.07, 0),
			Size = UDim2.new(0.86, 0, 0.86, 0),
			Font = "ArialBold",
			Text = ntext,
			FontSize = "Size14",
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 1,
			ZIndex = 7
		})
	})
	tobj.Image = "http://www.roblox.com/asset/?id=" .. (function()
		if index == 0 then
			return "97108784"
		elseif last then
			if index % 2 == 1 then
				return Images["LightPopupBottom"]
			else
				return Images["DarkPopupBottom"]
			end
		else
			if index % 2 == 1 then
				return "97112126"
			else
				return "97109338"
			end
		end
	end)()
	return tobj
end
local debugOutput
local DebugPrintEnabled = true
local debugprint
debugprint = function(str)
	if DebugPrintEnabled then
		debugOutput.Text = str
	end
end
local WaitForChild
WaitForChild = function(parent, child)
	while not parent:FindFirstChild(child) do
		wait()
		debugprint(" child " .. tostring(parent.Name) .. " waiting for " .. tostring(child))
	end
	return parent[child]
end
local Players = game:GetService("Players")
while not Players.LocalPlayer do
	Players.Changed:wait()
end
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ScreenGui = New("Frame", "PlayerListScreen", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Parent = script.Parent
})
local MainFrame = New("Frame", "LeaderBoardFrame", {
	Position = UDim2.new(1, -150, 0.005, 0),
	Size = UDim2.new(0, 150, 0, 800),
	BackgroundTransparency = 1,
	Parent = ScreenGui
})
local FocusFrame = New("Frame", "FocusFrame", {
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 100),
	BackgroundTransparency = 1,
	Active = true,
	Parent = MainFrame
})
local HeaderFrame = New("Frame", "Header", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0.07, 0),
	Parent = MainFrame,
	MakeBackgroundGuiObj("http://www.roblox.com/asset/?id=94692054")
})
local HeaderFrameHeight = HeaderFrame.Size.Y.Scale
local MaximizeButton = New("ImageButton", "MaximizeButton", {
	Active = true,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = HeaderFrame
})
local HeaderName = New("TextLabel", "PlayerName", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.01, 0),
	Size = UDim2.new(0.98, 0, 0.38, 0),
	Parent = HeaderFrame,
	Font = "ArialBold",
	Text = LocalPlayer.Name,
	FontSize = "Size24",
	TextColor3 = Color3.new(1, 1, 1),
	TextStrokeColor3 = Color3.new(0, 0, 0),
	TextStrokeTransparency = 0,
	TextXAlignment = "Right",
	TextYAlignment = "Center"
})
local HeaderScore = New("TextLabel", "PlayerScore", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.4, 0),
	Size = UDim2.new(0.98, 0, 0, 30),
	Parent = HeaderFrame,
	Font = "ArialBold",
	Text = "",
	FontSize = "Size24",
	TextYAlignment = "Top",
	TextColor3 = Color3.new(1, 1, 1),
	TextStrokeTransparency = 1,
	TextXAlignment = "Right"
})
local BottomShiftFrame = New("Frame", "BottomShiftFrame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, HeaderFrameHeight, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = MainFrame
})
local BottomFrame = New("Frame", "Bottom", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.07, 0),
	Size = UDim2.new(1, 0, 0.03, 0),
	Parent = BottomShiftFrame,
	MakeBackgroundGuiObj("http://www.roblox.com/asset/?id=94754966")
})
local ExtendButton = New("ImageButton", "bigbutton", {
	Active = true,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1.5, 0),
	ZIndex = 3,
	Parent = BottomFrame
})
local ExtendTab = New("ImageButton", "extendTab", {
	Active = true,
	BackgroundTransparency = 1,
	Image = "http://www.roblox.com/asset/?id=94692731",
	Position = UDim2.new(0.608, 0, 0.3, 0),
	Size = UDim2.new(0.3, 0, 0.7, 0),
	Parent = BottomFrame
})
local TopClipFrame = New("Frame", "ListFrame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(-1, 0, 0.07, 0),
	Size = UDim2.new(2, 0, 1, 0),
	Parent = MainFrame,
	ClipsDescendants = true
})
local BottomClipFrame = New("Frame", "BottomFrame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, -0.8, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = TopClipFrame,
	ClipsDescendants = true
})
local ScrollBarFrame = New("Frame", "ScrollBarFrame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0.987, 0, 0.8, 0),
	Size = UDim2.new(0.01, 0, 0.2, 0),
	Parent = BottomClipFrame
})
local ScrollBar = New("Frame", "ScrollBar", {
	BackgroundTransparency = 0,
	BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0.5, 0),
	ZIndex = 5,
	Parent = ScrollBarFrame
})
local ListFrame = New("Frame", "SubFrame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.8, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = BottomClipFrame
})
local PopUpClipFrame = New("Frame", "PopUpFrame", {
	BackgroundTransparency = 1,
	SizeConstraint = "RelativeXX",
	Position = MainFrame.Position + UDim2.new(0, -150, 0, 0),
	Size = UDim2.new(0, 150, 0, 800),
	Parent = MainFrame,
	ClipsDescendants = true,
	ZIndex = 7
})
local PopUpPanel = nil
local PopUpPanelTemplate = New("Frame", "Panel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(1, 0, 0, 0),
	Size = UDim2.new(1, 0, 0.032, 0),
	Parent = PopUpClipFrame
})
local StatTitles = New("Frame", "StatTitles", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 1, -10),
	Size = UDim2.new(1, 0, 0, 0),
	Parent = HeaderFrame
})
local IsMinimized = Instance.new("BoolValue")
local IsMaximized = Instance.new("BoolValue")
local IsTabified = Instance.new("BoolValue")
local AreNamesExpanded = Instance.new("BoolValue")
local MiddleTemplate = New("Frame", {
	Name = "MidTemplate",
	BackgroundTransparency = 1,
	Position = UDim2.new(100, 0, 0.07, 0),
	Size = UDim2.new(0.5, 0, 0.025, 0),
	New("ImageLabel", {
		Name = "BCLabel",
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.005, 5, 0.20, 0),
		Size = UDim2.new(0, 16, 0, 16),
		SizeConstraint = "RelativeYY",
		Image = "",
		ZIndex = 3
	}),
	New("ImageLabel", {
		Name = "FriendLabel",
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.005, 5, 0.15, 0),
		Size = UDim2.new(0, 16, 0, 16),
		SizeConstraint = "RelativeYY",
		Image = "",
		ZIndex = 3
	}),
	New("ImageButton", "ClickListener", {
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.005, 1, 0, 0),
		Size = UDim2.new(0.96, 0, 1, 0),
		ZIndex = 3
	}),
	New("Frame", "TitleFrame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.01, 0, 0, 0),
		Size = UDim2.new(0, 140, 1, 0),
		ClipsDescendants = true,
		New("TextLabel", "Title", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(100, 0, 1, 0),
			Font = "Arial",
			FontSize = "Size14",
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			ZIndex = 3
		})
	}),
	New("TextLabel", "PlayerScore", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Font = "ArialBold",
		Text = "",
		FontSize = "Size14",
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = "Right",
		TextYAlignment = "Center",
		ZIndex = 3
	}),
	ZIndex = 3
})
local MiddleBGTemplate = New("Frame", "MidBGTemplate", {
	BackgroundTransparency = 1,
	Position = UDim2.new(100, 0, 0.07, 0),
	Size = UDim2.new(0.5, 0, 0.025, 0),
	MakeBackgroundGuiObj("http://www.roblox.com/asset/?id=94692025")
})
local ReportAbuseShield = New("TextButton", "ReportAbuseShield", {
	Text = "",
	AutoButtonColor = false,
	Active = true,
	Visible = true,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = Color3I(51, 51, 51),
	BorderColor3 = Color3I(27, 42, 53),
	BackgroundTransparency = 1
})
local ReportAbuseFrame = New("Frame", "Settings", {
	Position = UDim2.new(0.5, -250, 0.5, -200),
	Size = UDim2.new(0, 500, 0, 400),
	BackgroundTransparency = 1,
	Active = true,
	Parent = ReportAbuseShield
})
local AbuseSettingsFrame
AbuseSettingsFrame = New("Frame", "ReportAbuseStyle", {
	Size = UDim2.new(1, 0, 1, 0),
	Active = true,
	BackgroundTransparency = 1,
	Parent = ReportAbuseFrame,
	MakeBackgroundGuiObj("http://www.roblox.com/asset/?id=96488767"),
	New("TextLabel", "Title", {
		Text = "Report Abuse",
		TextColor3 = Color3I(221, 221, 221),
		Position = UDim2.new(0.5, 0, 0, 30),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size36
	}),
	New("TextLabel", "Description", {
		Text = "This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.",
		TextColor3 = Color3I(221, 221, 221),
		Position = UDim2.new(0.01, 0, 0, 55),
		Size = UDim2.new(0.99, 0, 0, 40),
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		TextWrap = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	}),
	New("TextLabel", "AbuseLabel", {
		Text = "What did they do?",
		Font = Enum.Font.Arial,
		BackgroundTransparency = 1,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025, 0, 0, 140),
		Size = UDim2.new(0.4, 0, 0, 36),
		TextColor3 = Color3I(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left
	}),
	New("TextLabel", "ShortDescriptionLabel", {
		Text = "Short Description: (optional)",
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025, 0, 0, 180),
		Size = UDim2.new(0.95, 0, 0, 36),
		TextColor3 = Color3I(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	}),
	New("TextLabel", "ReportingPlayerLabel", {
		Text = "Reporting Player",
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025, 0, 0, 100),
		Size = UDim2.new(0.95, 0, 0, 36),
		TextColor3 = Color3I(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = AbuseSettingsFrame
	})
})
local AbusePlayerLabel = New("TextLabel", "PlayerLabel", {
	Text = "",
	BackgroundTransparency = 1,
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size18,
	Position = UDim2.new(0.025, 0, 0, 100),
	Size = UDim2.new(0.95, 0, 0, 36),
	TextColor3 = Color3I(255, 255, 255),
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = AbuseSettingsFrame
})
local SubmitReportButton = New("ImageButton", "SubmitReportBtn", {
	Active = false,
	BackgroundTransparency = 1,
	Position = UDim2.new(0.5, -200, 1, -80),
	Size = UDim2.new(0, 150, 0, 50),
	AutoButtonColor = false,
	Image = "http://www.roblox.com/asset/?id=96502438",
	Parent = AbuseSettingsFrame
})
local CancelReportButton = New("ImageButton", "CancelBtn", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0.5, 50, 1, -80),
	Size = UDim2.new(0, 150, 0, 50),
	AutoButtonColor = true,
	Image = "http://www.roblox.com/asset/?id=96500683",
	Parent = AbuseSettingsFrame
})
local AbuseDescriptionWrapper = New("Frame", "AbuseDescriptionWrapper", {
	Position = UDim2.new(0.025, 0, 0, 220),
	Size = UDim2.new(0.95, 0, 1, -310),
	BackgroundColor3 = Color3I(0, 0, 0),
	BorderSizePixel = 0,
	Parent = AbuseSettingsFrame
})
local AbuseDescriptionBox
local OriginalAbuseDescriptionBox = New("TextBox", {
	Text = "",
	ClearTextOnFocus = false,
	Font = Enum.Font.Arial,
	FontSize = Enum.FontSize.Size18,
	Position = UDim2.new(0, 3, 0, 3),
	Size = UDim2.new(1, -6, 1, -6),
	TextColor3 = Color3I(255, 255, 255),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrap = true,
	BackgroundColor3 = Color3I(0, 0, 0),
	BorderSizePixel = 0
})
local CalmingAbuseBox = New("Frame", "AbuseFeedbackBox", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0.25, 0, 0.3, 0),
	Size = UDim2.new(0.5, 0, 0.37, 0),
	MakeBackgroundGuiObj("http://www.roblox.com/asset/?id=96506233"),
	New("TextLabel", "Header", {
		Position = UDim2.new(0, 10, 0.05, 0),
		Size = UDim2.new(1, -30, 0.15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "Thanks for your report!",
		TextColor3 = Color3.new(1, 1, 1),
		FontSize = Enum.FontSize.Size48,
		Font = "ArialBold"
	}),
	New("TextLabel", "content", {
		Position = UDim2.new(0, 10, 0.20, 0),
		Size = UDim2.new(1, -30, 0.40, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.\n\nIf anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats",
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		FontSize = Enum.FontSize.Size24,
		Font = "Arial"
	}),
	New("ImageButton", "OkButton", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -75, 1, -80),
		Size = UDim2.new(0, 150, 0, 50),
		AutoButtonColor = true,
		Image = "http://www.roblox.com/asset/?id=96507959"
	})
})
local NormalAbuseBox = New("Frame", "AbuseFeedbackBox", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0.25, 0, 0.300000012, 0),
	Size = UDim2.new(0.5, 0, 0.370000005, 0),
	MakeBackgroundGuiObj("http://www.roblox.com/asset/?id=96506233"),
	New("TextLabel", "Header", {
		Position = UDim2.new(0, 10, 0.05, 0),
		Size = UDim2.new(1, -30, 0.15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "Thanks for your report!",
		FontSize = Enum.FontSize.Size48,
		Font = "ArialBold"
	}),
	New("TextLabel", "content", {
		Position = UDim2.new(0, 10, 0.20, 0),
		Size = UDim2.new(1, -30, 0.15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "Our moderators will review the chat logs and determine what happened.",
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		FontSize = Enum.FontSize.Size24,
		Font = "Arial"
	}),
	New("ImageButton", "OkButton", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -75, 1, -80),
		Size = UDim2.new(0, 150, 0, 50),
		AutoButtonColor = true,
		Image = "http://www.roblox.com/asset/?id=96507959"
	})
})
local BigButton = New("ImageButton", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 8,
	Visible = false,
	Parent = ScreenGui
})
local debugFrame = New("Frame", "debugframe", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0.25, 0, 0.3, 0),
	Size = UDim2.new(0.5, 0, 0.37, 0),
	MakeBackgroundGuiObj("http://www.roblox.com/asset/?id=96506233")
})
local debugplayers = New("TextLabel", {
	BackgroundTransparency = 0.8,
	Position = UDim2.new(0, 0, 0.01, 0),
	Size = UDim2.new(1, 0, 0.5, 0),
	Parent = debugFrame,
	Font = "ArialBold",
	Text = "--",
	FontSize = "Size14",
	TextWrapped = true,
	TextColor3 = Color3.new(1, 1, 1),
	TextStrokeColor3 = Color3.new(0, 0, 0),
	TextStrokeTransparency = 0,
	TextXAlignment = "Right",
	TextYAlignment = "Center"
})
debugOutput = New("TextLabel", {
	BackgroundTransparency = 0.8,
	Position = UDim2.new(0, 0, 0.5, 0),
	Size = UDim2.new(1, 0, 0.5, 0),
	Parent = debugFrame,
	Font = "ArialBold",
	Text = "--",
	FontSize = "Size14",
	TextWrapped = true,
	TextColor3 = Color3.new(1, 1, 1),
	TextStrokeColor3 = Color3.new(0, 0, 0),
	TextStrokeTransparency = 0,
	TextXAlignment = "Right",
	TextYAlignment = "Center"
})
local RbxGui = assert(LoadLibrary("RbxGui"))
local DefaultEntriesOnScreen = 8
for _, i in pairs(Images) do
	Game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=" .. tostring(i))
end
local ScoreNames = { }
local AddId = 0
local PlayerFrames = { }
local TeamFrames = { }
local NeutralTeam
local MiddleFrames = { }
local MiddleFrameBackgrounds = { }
local LastClick = 0
local ButtonCooldown = 0.25
local OnIos = false
pcall(function()
	OnIos = Game:GetService("UserInputService").TouchEnabled
end)
local BaseScreenXSize = 150
local SpacingPerStat = 10
local MaximizedBounds = UDim2.new(0.5, 0, 1, 0)
local MaximizedPosition = UDim2.new(0.25, 0, 0.1, 0)
local NormalBounds = UDim2.new(0, BaseScreenXSize, 0, 800)
local NormalPosition = UDim2.new(1, -BaseScreenXSize, 0.005, 0)
local RightEdgeSpace = -0.04
local DefaultBottomClipPos = BottomClipFrame.Position.Y.Scale
local SelectedPlayerEntry
local SelectedPlayer
local AddingFrameLock = false
local AddingStatLock = false
local BaseUpdateLock = false
local WaitForClickLock = false
local InPopupWaitForClick = false
local PlayerChangedLock = false
local NeutralTeamLock = false
local ScrollWheelConnections = { }
local DefaultListSize = 8
if not OnIos then
	DefaultListSize = 12
end
local DidMinimizeDrag = false
local AbuseName
local Abuses = {
	"Bad Words or Threats",
	"Bad Username",
	"Talking about Dating",
	"Account Trading or Sharing",
	"Asking Personal Questions",
	"Rude or Mean Behavior",
	"False Reporting Me"
}
local UpdateAbuseFunction
local AbuseDropDown
local PrivilegeLevel = {
	Owner = 255,
	Admin = 240,
	Member = 128,
	Visitor = 10,
	Banned = 0
}
local IsPersonalServer = not not game.Workspace:FindFirstChild("PSVariable")
game.Workspace.ChildAdded:connect(function(nchild)
	if nchild.Name == "PSVariable" and nchild:IsA("BoolValue") then
		IsPersonalServer = true
	end
end)
local AreAllEntriesOnScreen
AreAllEntriesOnScreen = function()
	return #MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale <= 1 + DefaultBottomClipPos
end
local GetMaxScroll
GetMaxScroll = function()
	return DefaultBottomClipPos * -1
end
local GetMinScroll
GetMinScroll = function()
	if AreAllEntriesOnScreen() then
		return GetMaxScroll()
	else
		return (GetMaxScroll() - (#MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale)) + (1 + DefaultBottomClipPos)
	end
end
local AbsoluteToPercent
AbsoluteToPercent = function(x, y)
	return Vector2.new(x, y) / ScreenGui.AbsoluteSize
end
local TweenProperty
TweenProperty = function(obj, propName, inita, enda, length)
	local startTime = tick()
	while tick() - startTime < length do
		obj[propName] = ((enda - inita) * ((tick() - startTime) / length)) + inita
		wait(1 / 30)
	end
	obj[propName] = enda
end
local WaitForClick
WaitForClick = function(frameParent, polledFunction, exitFunction)
	if WaitForClickLock then
		return
	end
	WaitForClickLock = true
	local connection, connection2
	connection = BigButton.MouseButton1Up:connect(function(nx, ny)
		exitFunction(nx, ny)
		BigButton.Visible = false
		connection:disconnect()
		if connection2 ~= nil then
			return connection2:disconnect()
		end
		return nil
	end)
	connection2 = BigButton.MouseMoved:connect(function(nx, ny)
		return polledFunction(nx, ny)
	end)
	BigButton.Visible = true
	BigButton.Active = true
	BigButton.Parent = frameParent
	frameParent.AncestryChanged:connect(function(child, nparent)
		if child == frameParent and not (nparent ~= nil) then
			exitFunction(nx, ny)
			BigButton.Visible = false
			connection:disconnect()
			connection2:disconnect()
			return debugprint("forced out of wait for click")
		end
	end)
	WaitForClickLock = false
end
local SetPrivilegeRank
SetPrivilegeRank = function(player, nrank)
	while player.PersonalServerRank < nrank do
		game:GetService("PersonalServerService"):Promote(player)
	end
	while player.PersonalServerRank > nrank do
		game:GetService("PersonalServerService"):Demote(player)
	end
end
local assetid = "http://www.roblox.com/asset/?id="
local HighlightMyRank
HighlightMyRank = function(player, BanPlayerButton, VisitorButton, MemberButton, AdminButton)
	BanPlayerButton.Image = assetid .. Images["LightPopupMid"]
	VisitorButton.Image = assetid .. Images["DarkPopupMid"]
	MemberButton.Image = assetid .. Images["LightPopupMid"]
	AdminButton.Image = assetid .. Images["DarkPopupBottom"]
	local rank = player.PersonalServerRank
	if rank <= PrivilegeLevel["Banned"] then
		BanPlayerButton.Image = assetid .. Images["LightBluePopupMid"]
	elseif rank <= PrivilegeLevel["Visitor"] then
		VisitorButton.Image = assetid .. Images["DarkBluePopupMid"]
	elseif rank <= PrivilegeLevel["Member"] then
		MemberButton.Image = assetid .. Images["LightBluePopupMid"]
	elseif rank <= PrivilegeLevel["Admin"] then
		AdminButton.Image = assetid .. Images["DarkBluePopupBottom"]
	end
end
local OnPrivilegeLevelSelect
OnPrivilegeLevelSelect = function(player, nlevel, BanPlayerButton, VisitorButton, MemberButton, AdminButton)
	debugprint("setting privilege level")
	SetPrivilegeRank(player, nlevel)
	return HighlightMyRank(player, BanPlayerButton, VisitorButton, MemberButton, AdminButton)
end
local CloseAbuseDialog
CloseAbuseDialog = function()
	AbuseName = nil
	SubmitReportButton.Active = false
	SubmitReportButton.Image = "http://www.roblox.com/asset/?id=96502438"
	AbuseDescriptionBox:Destroy()
	CalmingAbuseBox.Parent = nil
	NormalAbuseBox.Parent = nil
	ReportAbuseShield.Parent = nil
	AbuseSettingsFrame.Visible = true
end
local OnSubmitAbuse
OnSubmitAbuse = function()
	if SubmitReportButton.Active then
		if AbuseName and SelectedPlayer then
			AbuseSettingsFrame.Visible = false
			game.Players:ReportAbuse(SelectedPlayer, AbuseName, AbuseDescriptionBox.Text)
			if AbuseName == "Rude or Mean Behavior" or AbuseName == "False Reporting Me" then
				CalmingAbuseBox.Parent = ReportAbuseShield
			else
				debugprint("opening abuse box")
				NormalAbuseBox.Parent = ReportAbuseShield
			end
		else
			return CloseAbuseDialog()
		end
	end
end
local ClosePopUpPanel
ClosePopUpPanel = function()
	if SelectedPlayerEntry then
		local tframe = SelectedPlayerEntry["Frame"]
		Spawn(function()
			return TweenProperty(tframe, "BackgroundTransparency", 0.5, 1, BASE_TWEEN)
		end)
	end
	PopUpPanel:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Linear", BASE_TWEEN, true)
	wait(0.1)
	InPopupWaitForClick = false
	SelectedPlayerEntry = nil
end
local OpenAbuseDialog
OpenAbuseDialog = function()
	debugprint("adding report dialog")
	AbusePlayerLabel.Text = SelectedPlayer.Name
	PopUpPanel:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Linear", BASE_TWEEN, true)
	AbuseDescriptionBox = OriginalAbuseDescriptionBox:Clone()
	AbuseDescriptionBox.Parent = AbuseDescriptionWrapper
	ReportAbuseShield.Parent = ScreenGui
	return ClosePopUpPanel()
end
local InitReportAbuse
InitReportAbuse = function()
	UpdateAbuseFunction = function(abuseText)
		AbuseName = abuseText
		if AbuseName and SelectedPlayer then
			SubmitReportButton.Active = true
			SubmitReportButton.Image = "http://www.roblox.com/asset/?id=96501119"
		end
	end
	local _
	AbuseDropDown, _ = RbxGui.CreateDropDownMenu(Abuses, UpdateAbuseFunction, true)
	AbuseDropDown.Name = "AbuseComboBox"
	AbuseDropDown.Position = UDim2.new(0.425, 0, 0, 142)
	AbuseDropDown.Size = UDim2.new(0.55, 0, 0, 32)
	AbuseDropDown.Parent = AbuseSettingsFrame
	CancelReportButton.MouseButton1Click:connect(CloseAbuseDialog)
	SubmitReportButton.MouseButton1Click:connect(OnSubmitAbuse)
	CalmingAbuseBox:FindFirstChild("OkButton").MouseButton1Down:connect(CloseAbuseDialog)
	return NormalAbuseBox:FindFirstChild("OkButton").MouseButton1Down:connect(CloseAbuseDialog)
end
local GetFriendStatus
GetFriendStatus = function(player)
	if player == game.Players.LocalPlayer then
		return Enum.FriendStatus.NotFriend
	else
		local success, result = pcall(function()
			return game.Players.LocalPlayer:GetFriendStatus(player)
		end)
		if success then
			return result
		else
			return Enum.FriendStatus.NotFriend
		end
	end
end
local OnFriendButtonSelect
OnFriendButtonSelect = function()
	local friendStatus = GetFriendStatus(SelectedPlayer)
	if friendStatus == Enum.FriendStatus.Friend then
		LocalPlayer:RevokeFriendship(SelectedPlayer)
	elseif friendStatus == Enum.FriendStatus.Unknown or friendStatus == Enum.FriendStatus.NotFriend or friendStatus == Enum.FriendStatus.FriendRequestSent or friendStatus == Enum.FriendStatus.FriendRequestReceived then
		LocalPlayer:RequestFriendship(SelectedPlayer)
	end
	return ClosePopUpPanel()
end
local OnFriendRefuseButtonSelect
OnFriendRefuseButtonSelect = function()
	LocalPlayer:RevokeFriendship(SelectedPlayer)
	ClosePopUpPanel()
	return PopUpPanel:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Linear", BASE_TWEEN, true)
end
local PlayerSortFunction
PlayerSortFunction = function(a, b)
	if a["Score"] == b["Score"] then
		return a["Player"].Name:upper() < b["Player"].Name:upper()
	end
	if not a["Score"] then
		return false
	end
	if not b["Score"] then
		return true
	end
	return a["Score"] < b["Score"]
end
local UpdateMinimize
local Tabify
Tabify = function()
	IsTabified.Value = true
	IsMaximized.Value = false
	IsMinimized.Value = true
	UpdateMinimize()
	IsTabified.Value = true
	return ScreenGui:TweenPosition(UDim2.new(NormalBounds.X.Scale, NormalBounds.X.Offset - 10, 0, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
end
local UnTabify
UnTabify = function()
	if IsTabified.Value then
		IsTabified.Value = false
		return ScreenGui:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
	end
end
local BlowThisPopsicleStand
BlowThisPopsicleStand = function()
	return Tabify()
end
local StatSort
StatSort = function(a, b)
	if a.IsPrimary ~= b.IsPrimary then
		return a.IsPrimary
	end
	if a.Priority == b.Priority then
		return a.AddId < b.AddId
	end
	return a.Priority < b.Priority
end
local BaseUpdate
local StatChanged
StatChanged = function(_, _)
	return BaseUpdate()
end
local CreateStatTitle
CreateStatTitle = function(statName)
	local _with_0 = MiddleTemplate:FindFirstChild("PlayerScore"):Clone()
	_with_0.Name = statName
	_with_0.Text = statName
	if IsMaximized.Value then
		_with_0.TextTransparency = 0
	else
		_with_0.TextTransparency = 1
	end
	_with_0.Parent = StatTitles
	return _with_0
end
local UpdateMaximize
local StatAdded
StatAdded = function(nchild, playerEntry)
	while AddingStatLock do
		debugprint("in stat added function lock")
		wait(1 / 30)
	end
	AddingStatLock = true
	if not (nchild:IsA("StringValue") or nchild:IsA("IntValue") or nchild:IsA("BoolValue") or nchild:IsA("NumberValue") or nchild:IsA("DoubleConstrainedValue") or nchild:IsA("IntConstrainedValue")) then
		BlowThisPopsicleStand()
	else
		local haveScore = false
		for _, i in pairs(ScoreNames) do
			if i["Name"] == nchild.Name then
				haveScore = true
			end
		end
		if not haveScore then
			local nstat = { }
			nstat["Name"] = nchild.Name
			nstat["Priority"] = 0
			if nchild:FindFirstChild("Priority") then
				nstat["Priority"] = nchild.Priority
			end
			nstat["IsPrimary"] = false
			if nchild:FindFirstChild("IsPrimary") then
				nstat["IsPrimary"] = true
			end
			nstat.AddId = AddId
			AddId = AddId + 1
			table.insert(ScoreNames, nstat)
			table.sort(ScoreNames, StatSort)
			if not StatTitles:FindFirstChild(nstat["Name"]) then
				CreateStatTitle(nstat["Name"])
			end
			UpdateMaximize()
		end
	end
	AddingStatLock = false
	StatChanged(playerEntry)
	return nchild.Changed:connect(function(property)
		return StatChanged(playerEntry, property)
	end)
end
local DoesStatExist
DoesStatExist = function(statName, exception)
	for _, playerf in pairs(PlayerFrames) do
		if playerf["Player"] ~= exception and playerf["Player"]:FindFirstChild("leaderstats" and playerf["Player"].leaderstats:FindFirstChild(statName)) then
			return true
		end
	end
	return false
end
local StatRemoved
StatRemoved = function(nchild, playerEntry)
	while AddingStatLock do
		debugprint("In Adding Stat Lock1")
		wait(1 / 30)
	end
	AddingStatLock = true
	if playerEntry["Frame"]:FindFirstChild(nchild.Name) then
		debugprint("Destroyed frame!")
		playerEntry["Frame"][nchild.Name].Parent = nil
	end
	if not DoesStatExist(nchild.Name, playerEntry["Player"]) then
		for i, val in ipairs(ScoreNames) do
			if val["Name"] == nchild.Name then
				table.remove(ScoreNames, i)
				if StatTitles:FindFirstChild(nchild.Name) then
					StatTitles[nchild.Name]:Destroy()
				end
				for _, teamf in pairs(TeamFrames) do
					if teamf["Frame"]:FindFirstChild(nchild.Name) then
						teamf["Frame"][nchild.Name]:Destroy()
					end
				end
			end
		end
	end
	AddingStatLock = false
	return StatChanged(playerEntry)
end
local RemoveAllStats
RemoveAllStats = function(playerEntry)
	for _, val in ipairs(ScoreNames) do
		StatRemoved(val, playerEntry)
	end
end
local GetScoreValue
GetScoreValue = function(score)
	if score:IsA("DoubleConstrainedValue") or score:IsA("IntConstrainedValue") then
		return score.ConstrainedValue
	elseif score:IsA("BoolValue") then
		if score.Value then
			return 1
		else
			return 0
		end
	else
		return score.Value
	end
end
local MakeScoreEntry
MakeScoreEntry = function(entry, scoreval, panel)
	if not panel:FindFirstChild("PlayerScore") then
		return
	end
	local nscoretxt = panel:FindFirstChild("PlayerScore"):Clone()
	local thisScore
	wait()
	if entry["Player"]:FindFirstChild("leaderstats") and entry["Player"].leaderstats:FindFirstChild(scoreval["Name"]) then
		thisScore = entry["Player"]:FindFirstChild("leaderstats"):FindFirstChild(scoreval["Name"])
	else
		return
	end
	if not entry["Player"].Parent then
		return
	end
	nscoretxt.Name = scoreval["Name"]
	nscoretxt.Text = tostring(GetScoreValue(thisScore))
	if scoreval["Name"] == ScoreNames[1]["Name"] then
		debugprint("changing score")
		entry["Score"] = GetScoreValue(thisScore)
		if entry["Player"] == LocalPlayer then
			HeaderScore.Text = tostring(GetScoreValue(thisScore))
		end
	end
	thisScore.Changed:connect(function()
		if not thisScore.Parent then
			return
		end
		if scoreval["Name"] == ScoreNames[1]["Name"] then
			entry["Score"] = GetScoreValue(thisScore)
			if entry["Player"] == LocalPlayer then
				HeaderScore.Text = tostring(GetScoreValue(thisScore))
			end
		end
		nscoretxt.Text = tostring(GetScoreValue(thisScore))
		return BaseUpdate()
	end)
	return nscoretxt
end
local FONT_SIZES = {
	"Size8",
	"Size9",
	"Size10",
	"Size11",
	"Size12",
	"Size14",
	"Size24",
	"Size36",
	"Size48"
}
local UpdateHeaderNameSize
UpdateHeaderNameSize = function()
	local tHeader = HeaderName:Clone()
	tHeader.Position = UDim2.new(2, 0, 2, 0)
	tHeader.Parent = ScreenGui
	local fSize = 7
	tHeader.FontSize = FONT_SIZES[fSize]
	return Delay(0.2, function()
		while tHeader.TextBounds.x == 0 do
			wait(1 / 30)
		end
		while tHeader.TextBounds.x - NormalBounds.X.Offset > 1 do
			fSize = fSize - 1
			tHeader.FontSize = FONT_SIZES[fSize]
			wait(0.2)
		end
		HeaderName.FontSize = tHeader.FontSize
		return tHeader:Destroy()
	end)
end
local RecreateScoreColumns
RecreateScoreColumns = function(ptable)
	while AddingStatLock do
		debugprint("In Adding Stat Lock2")
		wait(1 / 30)
	end
	AddingStatLock = true
	local Xoffset = 5
	local maxXOffset = Xoffset
	local MaxSizeColumn = 0
	for j = #ScoreNames, 1, -1 do
		local scoreval = ScoreNames[j]
		MaxSizeColumn = 0
		for _, entry in ipairs(ptable) do
			local panel = entry["Frame"]
			if not panel:FindFirstChild(scoreval["Name"]) then
				local nentry = MakeScoreEntry(entry, scoreval, panel)
				if nentry then
					debugprint("adding " .. tostring(nentry.Name) .. " to " .. tostring(entry["Player"].Name))
					nentry.Parent = panel
					if entry["MyTeam"] and entry["MyTeam"] ~= NeutralTeam and not entry["MyTeam"]["Frame"]:FindFirstChild(scoreval["Name"]) then
						local ntitle = nentry:Clone()
						ntitle.Parent = entry["MyTeam"]["Frame"]
					end
				end
			end
			scoreval["XOffset"] = Xoffset
			if panel:FindFirstChild(scoreval["Name"]) then
				MaxSizeColumn = math.max(MaxSizeColumn, panel[scoreval["Name"]].TextBounds.X)
			end
		end
		if AreNamesExpanded.Value then
			MaxSizeColumn = math.max(MaxSizeColumn, StatTitles[scoreval["Name"]].TextBounds.X)
			StatTitles[scoreval["Name"]]:TweenPosition(UDim2.new(RightEdgeSpace, -Xoffset, 0, 0), "Out", "Linear", BASE_TWEEN, true)
		else
			StatTitles[scoreval["Name"]]:TweenPosition(UDim2.new((0.4 + ((0.6 / #ScoreNames) * (j - 1))) - 1, 0, 0, 0), "Out", "Linear", BASE_TWEEN, true)
		end
		scoreval["ColumnSize"] = MaxSizeColumn
		Xoffset = Xoffset + (SpacingPerStat + MaxSizeColumn)
		maxXOffset = math.max(Xoffset, maxXOffset)
	end
	NormalBounds = UDim2.new(0, BaseScreenXSize + maxXOffset - SpacingPerStat, 0, 800)
	NormalPosition = UDim2.new(1, -NormalBounds.X.Offset, NormalPosition.Y.Scale, 0)
	UpdateHeaderNameSize()
	UpdateMaximize()
	AddingStatLock = false
end
local ExpandNames
ExpandNames = function()
	if #ScoreNames ~= 0 then
		for _, i in pairs(StatTitles:GetChildren()) do
			Spawn(function()
				return TweenProperty(i, "TextTransparency", i.TextTransparency, 0, BASE_TWEEN)
			end)
		end
		HeaderFrameHeight = 0.09
		HeaderFrame:TweenSizeAndPosition(UDim2.new(HeaderFrame.Size.X.Scale, HeaderFrame.Size.X.Offset, HeaderFrameHeight, 0), HeaderFrame.Position, "Out", "Linear", BASE_TWEEN * 1.2, true)
		TopClipFrame:TweenPosition(UDim2.new(TopClipFrame.Position.X.Scale, 0, HeaderFrameHeight, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		return BottomShiftFrame:TweenPosition(UDim2.new(0, 0, HeaderFrameHeight, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
	end
end
local CloseNames
CloseNames = function()
	if #ScoreNames ~= 0 then
		HeaderFrameHeight = 0.07
		if not IsMaximized.Value then
			for _, i in pairs(StatTitles:GetChildren()) do
				Spawn(function()
					return TweenProperty(i, "TextTransparency", i.TextTransparency, 1, BASE_TWEEN)
				end)
			end
		end
		BottomShiftFrame:TweenPosition(UDim2.new(0, 0, HeaderFrameHeight, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		HeaderFrame:TweenSizeAndPosition(UDim2.new(HeaderFrame.Size.X.Scale, HeaderFrame.Size.X.Offset, HeaderFrameHeight, 0), HeaderFrame.Position, "Out", "Linear", BASE_TWEEN * 1.2, true)
		return TopClipFrame:TweenPosition(UDim2.new(TopClipFrame.Position.X.Scale, 0, HeaderFrameHeight, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
	end
end
local UpdateStatNames
UpdateStatNames = function()
	if not AreNamesExpanded.Value or IsMinimized.Value then
		return CloseNames()
	else
		return ExpandNames()
	end
end
local ToggleMinimize
ToggleMinimize = function()
	IsMinimized.Value = not IsMinimized.Value
	return UpdateStatNames()
end
local ToggleMaximize
ToggleMaximize = function()
	IsMaximized.Value = not IsMaximized.Value
	return RecreateScoreColumns(PlayerFrames)
end
local UpdateScrollPosition
UpdateScrollPosition = function()
	local minPos = GetMinScroll()
	local maxPos = GetMaxScroll()
	local scrollLength = maxPos - minPos
	local yscrollpos = math.max(math.min(ListFrame.Position.Y.Scale, maxPos), minPos)
	ListFrame.Position = UDim2.new(ListFrame.Position.X.Scale, ListFrame.Position.X.Offset, yscrollpos, ListFrame.Position.Y.Offset)
	local adjustedLength = 1 - ScrollBar.Size.Y.Scale
	ScrollBar.Position = UDim2.new(0, 0, adjustedLength - (adjustedLength * ((ListFrame.Position.Y.Scale - minPos) / scrollLength)), 0)
end
UpdateMinimize = function()
	if IsMinimized.Value then
		if IsMaximized.Value then
			ToggleMaximize()
		end
		if not IsTabified.Value then
			MainFrame:TweenSizeAndPosition(UDim2.new(0.010, HeaderName.TextBounds.X, NormalBounds.Y.Scale, NormalBounds.Y.Offset), UDim2.new(0.990, -HeaderName.TextBounds.X, NormalPosition.Y.Scale, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		else
			MainFrame:TweenSizeAndPosition(NormalBounds, NormalPosition, "Out", "Linear", BASE_TWEEN * 1.2, true)
		end
		BottomClipFrame:TweenPosition(UDim2.new(0, 0, -1, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		BottomFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		FocusFrame.Size = UDim2.new(1, 0, HeaderFrameHeight, 0)
		ExtendTab.Image = "http://www.roblox.com/asset/?id=94692731"
	else
		if not IsMaximized.Value then
			MainFrame:TweenSizeAndPosition(NormalBounds, NormalPosition, "Out", "Linear", BASE_TWEEN * 1.2, true)
		end
		DefaultBottomClipPos = math.min(math.max(DefaultBottomClipPos, -1), -1 + #MiddleFrameBackgrounds * MiddleBGTemplate.Size.Y.Scale)
		UpdateScrollPosition()
		BottomClipFrame.Position = UDim2.new(0, 0, DefaultBottomClipPos, 0)
		local bottomPositon = DefaultBottomClipPos + BottomClipFrame.Size.Y.Scale
		BottomFrame.Position = UDim2.new(0, 0, bottomPositon, 0)
		FocusFrame.Size = UDim2.new(1, 0, bottomPositon + HeaderFrameHeight, 0)
		ExtendTab.Image = "http://www.roblox.com/asset/?id=94825585"
	end
end
UpdateMaximize = function()
	if IsMaximized.Value then
		for j = 1, #ScoreNames, 1 do
			local scoreval = ScoreNames[j]
			StatTitles[scoreval["Name"]]:TweenPosition(UDim2.new(0.4 + ((0.6 / #ScoreNames) * (j - 1)) - 1, 0, 0, 0), "Out", "Linear", BASE_TWEEN, true)
		end
		if IsMinimized.Value then
			ToggleMinimize()
		else
			UpdateMinimize()
		end
		MainFrame:TweenSizeAndPosition(MaximizedBounds, MaximizedPosition, "Out", "Linear", BASE_TWEEN * 1.2, true)
		HeaderScore:TweenPosition(UDim2.new(0, 0, HeaderName.Position.Y.Scale, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		HeaderName:TweenPosition(UDim2.new(-0.1, -HeaderScore.TextBounds.x, HeaderName.Position.Y.Scale, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		HeaderFrame.Background.Image = "http://www.roblox.com/asset/?id=" .. Images["LargeHeader"]
		BottomFrame.Background.Image = "http://www.roblox.com/asset/?id=" .. Images["LargeBottom"]
		for index, i in ipairs(MiddleFrameBackgrounds) do
			i.Background.Image = "http://www.roblox.com/asset/?id=" .. (function()
				if index % 2 ~= 1 then
					return Images["LargeDark"]
				else
					return Images["LargeLight"]
				end
			end)()
		end
		for _, i in ipairs(MiddleFrames) do
			if i:FindFirstChild("ClickListener") then
				i.ClickListener.Size = UDim2.new(0.974, 0, i.ClickListener.Size.Y.Scale, 0)
			end
			for j = 1, #ScoreNames, 1 do
				local scoreval = ScoreNames[j]
				if i:FindFirstChild(scoreval["Name"]) then
					i[scoreval["Name"]]:TweenPosition(UDim2.new(0.4 + ((0.6 / #ScoreNames) * (j - 1)) - 1, 0, 0, 0), "Out", "Linear", BASE_TWEEN, true)
				end
			end
		end
		for _, entry in ipairs(PlayerFrames) do
			WaitForChild(entry["Frame"], "TitleFrame").Size = UDim2.new(0.38, 0, entry["Frame"].TitleFrame.Size.Y.Scale, 0)
		end
		for _, entry in ipairs(TeamFrames) do
			WaitForChild(entry["Frame"], "TitleFrame").Size = UDim2.new(0.38, 0, entry["Frame"].TitleFrame.Size.Y.Scale, 0)
		end
	else
		if not IsMinimized.Value then
			MainFrame:TweenSizeAndPosition(NormalBounds, NormalPosition, "Out", "Linear", BASE_TWEEN * 1.2, true)
		end
		HeaderScore:TweenPosition(UDim2.new(0, 0, 0.4, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		HeaderName:TweenPosition(UDim2.new(0, 0, HeaderName.Position.Y.Scale, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
		HeaderFrame.Background.Image = "http://www.roblox.com/asset/?id=" .. Images["NormalHeader"]
		BottomFrame.Background.Image = "http://www.roblox.com/asset/?id=" .. Images["NormalBottom"]
		for index, i in ipairs(MiddleFrameBackgrounds) do
			i.Background.Image = "http://www.roblox.com/asset/?id=" .. (function()
				if index % 2 ~= 1 then
					return Images["midDark"]
				else
					return Images["midLight"]
				end
			end)()
		end
		for _, i in ipairs(MiddleFrames) do
			if i:FindFirstChild("ClickListener") then
				i.ClickListener.Size = UDim2.new(0.96, 0, i.ClickListener.Size.Y.Scale, 0)
				for j = 1, #ScoreNames, 1 do
					local scoreval = ScoreNames[j]
					if i:FindFirstChild(scoreval["Name"]) and scoreval["XOffset"] then
						i[scoreval["Name"]]:TweenPosition(UDim2.new(RightEdgeSpace, -scoreval["XOffset"], 0, 0), "Out", "Linear", BASE_TWEEN, true)
					end
				end
			end
		end
		for _, entry in ipairs(TeamFrames) do
			WaitForChild(entry["Frame"], "TitleFrame").Size = UDim2.new(0, BaseScreenXSize * 0.9, entry["Frame"].TitleFrame.Size.Y.Scale, 0)
		end
		for _, entry in ipairs(PlayerFrames) do
			WaitForChild(entry["Frame"], "TitleFrame").Size = UDim2.new(0, BaseScreenXSize * 0.9, entry["Frame"].TitleFrame.Size.Y.Scale, 0)
		end
	end
end
local OnScrollWheelMove
OnScrollWheelMove = function(direction)
	if not (IsTabified.Value or IsMinimized.Value or InPopupWaitForClick) then
		local StartFrame = ListFrame.Position
		local newFrameY = math.max(math.min(StartFrame.Y.Scale + direction, GetMaxScroll()), GetMinScroll())
		ListFrame.Position = UDim2.new(StartFrame.X.Scale, StartFrame.X.Offset, newFrameY, StartFrame.Y.Offset)
		return UpdateScrollPosition()
	end
end
local AttachScrollWheel
AttachScrollWheel = function()
	if ScrollWheelConnections then
		return
	end
	ScrollWheelConnections = { }
	table.insert(ScrollWheelConnections, Mouse.WheelForward:connect(function()
		return OnScrollWheelMove(0.05)
	end))
	return table.insert(ScrollWheelConnections, Mouse.WheelBackward:connect(function()
		return OnScrollWheelMove(-0.05)
	end))
end
local DetachScrollWheel
DetachScrollWheel = function()
	if ScrollWheelConnections then
		for _, i in pairs(ScrollWheelConnections) do
			i:disconnect()
		end
	end
	ScrollWheelConnections = nil
end
FocusFrame.MouseEnter:connect(function()
	if not (IsMinimized.Value or IsTabified.Value) then
		return AttachScrollWheel()
	end
end)
FocusFrame.MouseLeave:connect(function()
	return DetachScrollWheel()
end)
local UpdateScrollBarSize
UpdateScrollBarSize = function()
	local entryListSize = #MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale
	local shownAreaSize = BottomClipFrame.Position.Y.Scale + 1
	ScrollBar.Size = UDim2.new(1, 0, shownAreaSize / entryListSize, 0)
end
local InitMovingPanel
InitMovingPanel = function(entry, player)
	PopUpClipFrame.Parent = ScreenGui
	if PopUpPanel ~= nil then
		PopUpPanel:Destroy()
	end
	PopUpPanel = PopUpPanelTemplate:Clone()
	PopUpPanel.Parent = PopUpClipFrame
	local nextIndex = 2
	local friendStatus = GetFriendStatus(player)
	debugprint(tostring(friendStatus))
	local showRankMenu = IsPersonalServer and LocalPlayer.PersonalServerRank >= PrivilegeLevel["Admin"] and LocalPlayer.PersonalServerRank > SelectedPlayer.PersonalServerRank
	local ReportPlayerButton = MakePopupButton(PopUpPanel, "Report Player", 0)
	ReportPlayerButton.MouseButton1Click:connect(function()
		return OpenAbuseDialog()
	end)
	local FriendPlayerButton = MakePopupButton(PopUpPanel, "Friend", 1, not showRankMenu and friendStatus ~= Enum.FriendStatus.FriendRequestReceived)
	FriendPlayerButton.MouseButton1Click:connect(OnFriendButtonSelect)
	if friendStatus == Enum.FriendStatus.Friend then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "UnFriend Player"
	elseif friendStatus == Enum.FriendStatus.Unknown or friendStatus == Enum.FriendStatus.NotFriend then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "Send Request"
	elseif friendStatus == Enum.FriendStatus.FriendRequestSent then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "Revoke Request"
	elseif friendStatus == Enum.FriendStatus.FriendRequestReceived then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "Accept Friend"
		local FriendRefuseButton = MakePopupButton(PopUpPanel, "Decline Friend", 2, not showRankMenu)
		FriendRefuseButton.MouseButton1Click:connect(OnFriendRefuseButtonSelect)
		nextIndex = nextIndex + 1
	end
	if showRankMenu then
		local BanPlayerButton = MakePopupButton(PopUpPanel, "Ban", nextIndex)
		local VisitorButton = MakePopupButton(PopUpPanel, "Visitor", nextIndex + 1)
		local MemberButton = MakePopupButton(PopUpPanel, "Member", nextIndex + 2)
		local AdminButton = MakePopupButton(PopUpPanel, "Admin", nextIndex + 3, true)
		BanPlayerButton.MouseButton1Click:connect(function()
			return OnPrivilegeLevelSelect(player, PrivilegeLevel["Banned"], BanPlayerButton, VisitorButton, MemberButton, AdminButton)
		end)
		VisitorButton.MouseButton1Click:connect(function()
			return OnPrivilegeLevelSelect(player, PrivilegeLevel["Visitor"], BanPlayerButton, VisitorButton, MemberButton, AdminButton)
		end)
		MemberButton.MouseButton1Click:connect(function()
			return OnPrivilegeLevelSelect(player, PrivilegeLevel["Member"], BanPlayerButton, VisitorButton, MemberButton, AdminButton)
		end)
		AdminButton.MouseButton1Click:connect(function()
			return OnPrivilegeLevelSelect(player, PrivilegeLevel["Admin"], BanPlayerButton, VisitorButton, MemberButton, AdminButton)
		end)
		HighlightMyRank(SelectedPlayer, BanPlayerButton, VisitorButton, MemberButton, AdminButton)
	end
	PopUpPanel:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Linear", BASE_TWEEN, true)
	Delay(0, function()
		local tconnection = Mouse.Button1Down:connect(function()
			tconnection:disconnect()
			return ClosePopUpPanel()
		end)
	end)
	local myFrame = entry["Frame"]
	return Spawn(function()
		while InPopupWaitForClick do
			PopUpClipFrame.Position = UDim2.new(0, myFrame.AbsolutePosition.X - PopUpClipFrame.Size.X.Offset, 0, myFrame.AbsolutePosition.Y)
			wait()
		end
	end)
end
local UpdateScrollBarVisibility
UpdateScrollBarVisibility = function()
	if AreAllEntriesOnScreen() then
		ScrollBar.BackgroundTransparency = 1
	else
		ScrollBar.BackgroundTransparency = 0
		return UpdateScrollBarSize()
	end
end
local ActivatePlayerEntryPanel
ActivatePlayerEntryPanel = function(entry)
	entry["Frame"].BackgroundColor3 = Color3.new(0, 1, 1)
	Spawn(function()
		return TweenProperty(entry["Frame"], "BackgroundTransparency", 1, 0.5, 0.5)
	end)
	InPopupWaitForClick = true
	return InitMovingPanel(entry, entry["Player"])
end
local StartDrag
StartDrag = function(entry, startx, starty)
	local openPanel = true
	WaitForChild(entry["Frame"], "ClickListener")
	local dragExit
	dragExit = function()
		if entry["Player"] and SelectedPlayer and openPanel and entry["Player"] ~= LocalPlayer and SelectedPlayer.userId > 1 and LocalPlayer.userId > 1 then
			return ActivatePlayerEntryPanel(entry)
		end
	end
	local startY
	local StartFrame = ListFrame.Position
	local dragpoll
	dragpoll = function(nx, ny)
		if not startY then
			startY = AbsoluteToPercent(nx, ny).Y
		end
		local nowY = AbsoluteToPercent(nx, ny).Y
		debugprint("drag dist: " .. tostring(Vector2.new(startx - nx, starty - ny).magnitude))
		if Vector2.new(startx - nx, starty - ny).magnitude > MOUSE_DRAG_DISTANCE then
			openPanel = false
		end
		local newFrameY = math.max(math.min(StartFrame.Y.Scale + (nowY - startY), GetMaxScroll()), GetMinScroll())
		ListFrame.Position = UDim2.new(StartFrame.X.Scale, StartFrame.X.Offset, newFrameY, StartFrame.Y.Offset)
		return UpdateScrollPosition()
	end
	return WaitForClick(ScreenGui, dragpoll, dragExit)
end
local StartMinimizeDrag
StartMinimizeDrag = function()
	return Delay(0, function()
		local startTime = tick()
		debugprint("Got Click2")
		local dragExit
		dragExit = function()
			if tick() - startTime < 0.25 then
				return ToggleMinimize()
			else
				DidMinimizeDrag = true
				if IsMinimized.Value then
					return ToggleMinimize()
				end
			end
		end
		local startY
		local StartFrame = DefaultBottomClipPos
		local dragpoll
		dragpoll = function(nx, ny)
			if not IsMinimized.Value then
				if not startY then
					startY = AbsoluteToPercent(nx, ny).Y
				end
				local nowY = AbsoluteToPercent(nx, ny).Y
				local newFrameY = math.min(math.max(StartFrame + (nowY - startY), -1), -1 + #MiddleFrameBackgrounds * MiddleBGTemplate.Size.Y.Scale)
				DefaultBottomClipPos = newFrameY
				UpdateMinimize()
				ScrollBarFrame.Size = UDim2.new(ScrollBarFrame.Size.X.Scale, 0, (DefaultBottomClipPos + BottomClipFrame.Size.Y.Scale), 0)
				ScrollBarFrame.Position = UDim2.new(ScrollBarFrame.Position.X.Scale, 0, 1 - ScrollBarFrame.Size.Y.Scale, 0)
				UpdateScrollBarSize()
				UpdateScrollPosition()
				return UpdateScrollBarVisibility()
			end
		end
		return Spawn(function()
			return WaitForClick(ScreenGui, dragpoll, dragExit)
		end)
	end)
end
IsMaximized.Value = false
IsMinimized.Value = false
IsMaximized.Changed:connect(UpdateMaximize)
IsMinimized.Changed:connect(UpdateMinimize)
ExtendButton.MouseButton1Down:connect(function()
	if (time() - LastClick < ButtonCooldown) or InPopupWaitForClick then
		return
	end
	LastClick = time()
	if IsTabified.Value then
		return UnTabify()
	else
		return StartMinimizeDrag()
	end
end)
MaximizeButton.MouseButton1Click:connect(function()
	if (time() - LastClick < ButtonCooldown) or InPopupWaitForClick then
		return
	end
	LastClick = time()
	if IsTabified.Value then
		return UnTabify()
	elseif not AreNamesExpanded.Value then
		AreNamesExpanded.Value = true
		return BaseUpdate()
	else
		return ToggleMaximize()
	end
end)
MaximizeButton.MouseButton2Click:connect(function()
	if (time() - LastClick < ButtonCooldown) or InPopupWaitForClick then
		return
	end
	LastClick = time()
	if IsTabified.Value then
		return UnTabify()
	elseif IsMaximized.Value then
		return ToggleMaximize()
	elseif AreNamesExpanded.Value then
		AreNamesExpanded.Value = false
		return BaseUpdate()
	else
		return Tabify()
	end
end)
local AddMiddleBGFrame
AddMiddleBGFrame = function()
	local nBGFrame = MiddleBGTemplate:Clone()
	nBGFrame.Position = UDim2.new(0.5, 0, (#MiddleFrameBackgrounds * nBGFrame.Size.Y.Scale), 0)
	nBGFrame.Background.Image = "http://www.roblox.com/asset/?id=" .. (function()
		if (#MiddleFrameBackgrounds + 1) % 2 ~= 1 then
			if IsMaximized.Value then
				return Images["LargeDark"]
			else
				return Images["midDark"]
			end
		else
			if IsMaximized.Value then
				return Images["LargeLight"]
			else
				return Images["midLight"]
			end
		end
	end)()
	nBGFrame.Parent = ListFrame
	table.insert(MiddleFrameBackgrounds, nBGFrame)
	if #MiddleFrameBackgrounds < DefaultListSize and not DidMinimizeDrag then
		DefaultBottomClipPos = -1 + #MiddleFrameBackgrounds * MiddleBGTemplate.Size.Y.Scale
	end
	if not IsMinimized.Value then
		return UpdateMinimize()
	end
end
local RemoveMiddleBGFrame
RemoveMiddleBGFrame = function()
	MiddleFrameBackgrounds[#MiddleFrameBackgrounds]:Destroy()
	table.remove(MiddleFrameBackgrounds, #MiddleFrameBackgrounds)
	if not IsMinimized.Value then
		return UpdateMinimize()
	end
end
local ChangeHeaderName
ChangeHeaderName = function(nname)
	HeaderName.Text = nname
	return UpdateHeaderNameSize()
end
ScreenGui.Changed:connect(UpdateHeaderNameSize)
local LeaderstatsAdded
LeaderstatsAdded = function(playerEntry)
	local nplayer = playerEntry["Player"]
	for _, i in pairs(nplayer.leaderstats:GetChildren()) do
		StatAdded(i, playerEntry)
	end
	nplayer.leaderstats.ChildAdded:connect(function(nchild)
		return StatAdded(nchild, playerEntry)
	end)
	return nplayer.leaderstats.ChildRemoved:connect(function(nchild)
		return StatRemoved(nchild, playerEntry)
	end)
end
local LeaderstatsRemoved
LeaderstatsRemoved = function(_, playerEntry)
	while AddingFrameLock do
		debugprint("waiting to insert " .. tostring(playerEntry["Player"].Name))
		wait(1 / 30)
	end
	AddingFrameLock = true
	RemoveAllStats(playerEntry)
	AddingFrameLock = false
end
local OnPlayerEntrySelect
OnPlayerEntrySelect = function(entry, startx, starty)
	if not InPopupWaitForClick then
		SelectedPlayerEntry = entry
		SelectedPlayer = entry["Player"]
		return StartDrag(entry, startx, starty)
	end
end
local PlayerListModeUpdate
PlayerListModeUpdate = function()
	RecreateScoreColumns(PlayerFrames)
	table.sort(PlayerFrames, PlayerSortFunction)
	for i, val in ipairs(PlayerFrames) do
		MiddleFrames[i] = val["Frame"]
	end
	for i = #PlayerFrames + 1, #MiddleFrames, 1 do
		MiddleFrames[i] = nil
	end
	return UpdateMinimize()
end
local RemoveNeutralTeam
RemoveNeutralTeam = function()
	while NeutralTeamLock do
		debugprint("in neutral team lock")
		wait()
	end
	NeutralTeamLock = true
	NeutralTeam["Frame"]:Destroy()
	NeutralTeam = nil
	RemoveMiddleBGFrame()
	NeutralTeamLock = false
end
local RemovePlayerFromTeam
RemovePlayerFromTeam = function(teamEntry, index)
	table.remove(teamEntry["MyPlayers"], index)
	if teamEntry == NeutralTeam and #teamEntry["MyPlayers"] == 0 then
		return RemoveNeutralTeam()
	end
end
local FindRemovePlayerFromTeam
FindRemovePlayerFromTeam = function(entry)
	if entry["MyTeam"] then
		for j, oldEntry in ipairs(entry["MyTeam"]["MyPlayers"]) do
			if oldEntry["Player"] == entry["Player"] then
				RemovePlayerFromTeam(entry["MyTeam"], j)
				return
			end
		end
	elseif NeutralTeam then
		for j, oldEntry in ipairs(NeutralTeam["MyPlayers"]) do
			if oldEntry["Player"] == entry["Player"] then
				RemovePlayerFromTeam(NeutralTeam, j)
				return
			end
		end
	end
end
local AddPlayerToTeam
AddPlayerToTeam = function(teamEntry, entry)
	FindRemovePlayerFromTeam(entry)
	table.insert(teamEntry["MyPlayers"], entry)
	entry["MyTeam"] = teamEntry
	if teamEntry["IsHidden"] then
		teamEntry["Frame"].Parent = ListFrame
		AddMiddleBGFrame()
	end
	teamEntry["IsHidden"] = false
end
local AddNeutralTeam
AddNeutralTeam = function()
	while NeutralTeamLock do
		debugprint("in neutral team 2 lock")
		wait()
	end
	NeutralTeamLock = true
	local defaultTeam = Instance.new("Team")
	defaultTeam.TeamColor = BrickColor.new("White")
	defaultTeam.Name = "Neutral"
	local nentry = { }
	nentry["MyTeam"] = defaultTeam
	nentry["MyPlayers"] = { }
	nentry["Frame"] = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nentry["Frame"], "TitleFrame"), "Title").Text = defaultTeam.Name
	nentry["Frame"].TitleFrame.Position = UDim2.new(nentry["Frame"].TitleFrame.Position.X.Scale, nentry["Frame"].TitleFrame.Position.X.Offset, 0.1, 0)
	nentry["Frame"].TitleFrame.Size = UDim2.new(nentry["Frame"].TitleFrame.Size.X.Scale, nentry["Frame"].TitleFrame.Size.X.Offset, 0.8, 0)
	nentry["Frame"].TitleFrame.Title.Font = "ArialBold"
	nentry["Frame"].Position = UDim2.new(1, 0, (#MiddleFrames * nentry["Frame"].Size.Y.Scale), 0)
	WaitForChild(nentry["Frame"], "ClickListener").MouseButton1Down:connect(function(nx, ny)
		return StartDrag(nentry, nx, ny)
	end)
	nentry["Frame"].ClickListener.BackgroundColor3 = Color3.new(1, 1, 1)
	nentry["Frame"].ClickListener.BackgroundTransparency = 0.7
	nentry["Frame"].ClickListener.AutoButtonColor = false
	nentry["AutoHide"] = true
	nentry["IsHidden"] = true
	for _, i in pairs(PlayerFrames) do
		if i["Player"].Neutral or not i["MyTeam"] then
			AddPlayerToTeam(nentry, i)
		end
	end
	if #nentry["MyPlayers"] > 0 then
		NeutralTeam = nentry
		UpdateMinimize()
		BaseUpdate()
	end
	NeutralTeamLock = false
end
local SetPlayerToTeam
SetPlayerToTeam = function(entry)
	FindRemovePlayerFromTeam(entry)
	local setToTeam = false
	for _, tframe in ipairs(TeamFrames) do
		if tframe["MyTeam"].TeamColor == entry["Player"].TeamColor then
			AddPlayerToTeam(tframe, entry)
			setToTeam = true
		end
	end
	if not setToTeam and #(game.Teams:GetTeams()) > 0 then
		debugprint(tostring(entry["Player"].Name) .. " could not find team")
		entry["MyTeam"] = nil
		if not NeutralTeam then
			return AddNeutralTeam()
		else
			return AddPlayerToTeam(NeutralTeam, entry)
		end
	end
end
local PlayerChanged
PlayerChanged = function(entry, property)
	while PlayerChangedLock do
		debugprint("in playerchanged lock")
		wait(1 / 30)
	end
	PlayerChangedLock = true
	if property == "Neutral" then
		if entry["Player"].Neutral and #game.Teams:GetTeams() > 0 then
			debugprint(tostring(entry["Player"].Name) .. " setting to neutral")
			FindRemovePlayerFromTeam(entry)
			entry["MyTeam"] = nil
			if not NeutralTeam then
				debugprint(tostring(entry["Player"].Name) .. " creating neutral team")
				AddNeutralTeam()
			else
				debugprint(tostring(entry["Player"].Name) .. " adding to neutral team")
				AddPlayerToTeam(NeutralTeam, entry)
			end
		elseif #(game.Teams:GetTeams()) > 0 then
			debugprint(tostring(entry["Player"].Name) .. " has been set non-neutral")
			SetPlayerToTeam(entry)
		end
		BaseUpdate()
	elseif property == "TeamColor" and not entry["Player"].Neutral and entry["Player"] ~= entry["MyTeam"] then
		debugprint(tostring(entry["Player"].Name) .. " setting to new team")
		SetPlayerToTeam(entry)
		BaseUpdate()
	elseif property == "Name" or property == "MembershipType" then
		entry["Frame"]:FindFirstChild("BCLabel").Image = getMembershipTypeIcon(entry["Player"].MembershipType, entry["Player"].Name)
		entry["Frame"].Name = entry["Player"].Name
		entry["Frame"].TitleFrame.Title.Text = entry["Player"].Name
		if entry["Frame"].BCLabel.Image ~= "" then
			entry["Frame"].TitleFrame.Title.Position = UDim2.new(0.01, 30, 0.1, 0)
		end
		if entry["Player"] == LocalPlayer then
			entry["Frame"].TitleFrame.DropShadow.Text = entry["Player"].Name
			ChangeHeaderName(entry["Player"].Name)
		end
		BaseUpdate()
	end
	PlayerChangedLock = false
end
local InsertPlayerFrame
InsertPlayerFrame = function(nplayer)
	while AddingFrameLock do
		debugprint("waiting to insert " .. tostring(nplayer.Name))
		wait(1 / 30)
	end
	AddingFrameLock = true
	local nFrame = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nFrame, "TitleFrame"), "Title").Text = nplayer.Name
	nFrame.Position = UDim2.new(1, 0, (#MiddleFrames * nFrame.Size.Y.Scale), 0)
	local nfriendstatus = GetFriendStatus(nplayer)
	nFrame:FindFirstChild("BCLabel").Image = getMembershipTypeIcon(nplayer.MembershipType, nplayer.Name)
	nFrame:FindFirstChild("FriendLabel").Image = getFriendStatusIcon(nfriendstatus)
	nFrame.Name = nplayer.Name
	WaitForChild(WaitForChild(nFrame, "TitleFrame"), "Title").Text = nplayer.Name
	nFrame.FriendLabel.Position = nFrame.FriendLabel.Position + UDim2.new(0, 17, 0, 0)
	nFrame.TitleFrame.Title.Position = nFrame.TitleFrame.Title.Position + UDim2.new(0, 17, 0, 0)
	if nFrame:FindFirstChild("FriendLabel").Image ~= "" then
		nFrame.TitleFrame.Title.Position = nFrame.TitleFrame.Title.Position + UDim2.new(0, 17, 0, 0)
	end
	if nplayer.Name == LocalPlayer.Name then
		nFrame.TitleFrame.Title.Font = "ArialBold"
		nFrame.PlayerScore.Font = "ArialBold"
		ChangeHeaderName(nplayer.Name)
		do
			local _with_0 = nFrame.TitleFrame.Title:Clone()
			_with_0.TextColor3 = Color3.new(0, 0, 0)
			_with_0.TextTransparency = 0
			_with_0.ZIndex = 2
			_with_0.Position = nFrame.TitleFrame.Title.Position + UDim2.new(0, 1, 0, 1)
			_with_0.Name = "DropShadow"
			_with_0.Parent = nFrame.TitleFrame
		end
	end
	nFrame.TitleFrame.Title.Font = "ArialBold"
	nFrame.Parent = ListFrame
	nFrame:TweenPosition(UDim2.new(0.5, 0, (#MiddleFrames * nFrame.Size.Y.Scale), 0), "Out", "Linear", BASE_TWEEN, true)
	UpdateMinimize()
	local nentry = { }
	nentry["Frame"] = nFrame
	nentry["Player"] = nplayer
	nentry["ID"] = AddId
	AddId = AddId + 1
	table.insert(PlayerFrames, nentry)
	if #TeamFrames ~= 0 then
		if nplayer.Neutral then
			nentry["MyTeam"] = nil
			if not NeutralTeam then
				AddNeutralTeam()
			else
				AddPlayerToTeam(NeutralTeam, nentry)
			end
		else
			local addedToTeam = false
			for _, tval in ipairs(TeamFrames) do
				if tval["MyTeam"].TeamColor == nplayer.TeamColor then
					AddPlayerToTeam(tval, nentry)
					nentry["MyTeam"] = tval
					addedToTeam = true
				end
			end
			if not addedToTeam then
				nentry["MyTeam"] = nil
				if not NeutralTeam then
					AddNeutralTeam()
				else
					AddPlayerToTeam(NeutralTeam, nentry)
				end
				nentry["MyTeam"] = NeutralTeam
			end
		end
	end
	if nplayer:FindFirstChild("leaderstats") then
		LeaderstatsAdded(nentry)
	end
	nplayer.ChildAdded:connect(function(nchild)
		if nchild.Name == "leaderstats" then
			while AddingFrameLock do
				debugprint("in adding leaderstats lock")
				wait(1 / 30)
			end
			AddingFrameLock = true
			LeaderstatsAdded(nentry)
			AddingFrameLock = false
		end
	end)
	nplayer.ChildRemoved:connect(function(nchild)
		if nplayer == LocalPlayer and nchild.Name == "leaderstats" then
			return LeaderstatsRemoved(nchild, nentry)
		end
	end)
	nplayer.Changed:connect(function(prop)
		return PlayerChanged(nentry, prop)
	end)
	local listener = WaitForChild(nFrame, "ClickListener")
	listener.Active = true
	listener.MouseButton1Down:connect(function(nx, ny)
		return OnPlayerEntrySelect(nentry, nx, ny)
	end)
	AddMiddleBGFrame()
	BaseUpdate()
	AddingFrameLock = false
end
local RemovePlayerFrame
RemovePlayerFrame = function(tplayer)
	while AddingFrameLock do
		debugprint("in removing player frame lock")
		wait(1 / 30)
	end
	AddingFrameLock = true
	local tteam
	for i, key in ipairs(PlayerFrames) do
		if tplayer == key["Player"] then
			if PopUpClipFrame.Parent == key["Frame"] then
				PopUpClipFrame.Parent = nil
			end
			key["Frame"]:Destroy()
			tteam = key["MyTeam"]
			table.remove(PlayerFrames, i)
		end
	end
	if tteam then
		for j, tentry in ipairs(tteam["MyPlayers"]) do
			if tentry["Player"] == tplayer then
				RemovePlayerFromTeam(tteam, j)
			end
		end
	end
	RemoveMiddleBGFrame()
	UpdateMinimize()
	BaseUpdate()
	AddingFrameLock = false
end
Players.ChildRemoved:connect(RemovePlayerFrame)
local UnrollTeams
UnrollTeams = function(tframes, outframes)
	local numEntries = 0
	if NeutralTeam and not NeutralTeam["IsHidden"] then
		for _, val in ipairs(NeutralTeam["MyPlayers"]) do
			numEntries = numEntries + 1
			outframes[numEntries] = val["Frame"]
		end
		numEntries = numEntries + 1
		outframes[numEntries] = NeutralTeam["Frame"]
	end
	for _, val in ipairs(tframes) do
		if not val["IsHidden"] then
			for _, pval in ipairs(val.MyPlayers) do
				numEntries = numEntries + 1
				outframes[numEntries] = pval["Frame"]
			end
			numEntries = numEntries + 1
			outframes[numEntries] = val["Frame"]
		end
	end
	for i = numEntries + 1, #outframes, 1 do
		outframes[i] = nil
	end
end
local TeamSortFunc
TeamSortFunc = function(a, b)
	if a["TeamScore"] == b["TeamScore"] then
		return a["ID"] < b["ID"]
	end
	if not a["TeamScore"] then
		return false
	end
	if not b["TeamScore"] then
		return true
	end
	return a["TeamScore"] < b["TeamScore"]
end
local AddTeamScores
AddTeamScores = function(team)
	for j = 1, #ScoreNames, 1 do
		local i = ScoreNames[j]
		local tscore = 0
		for _, j in ipairs(team["MyPlayers"]) do
			local tval = j["Player"]:FindFirstChild("leaderstats" and j["Player"].leaderstats:FindFirstChild(i["Name"]))
			if tval and not tval:IsA("StringValue") then
				tscore = tscore + GetScoreValue((j["Player"].leaderstats)[i["Name"]])
			end
		end
		if team["Frame"]:FindFirstChild(i["Name"]) then
			team["Frame"][i["Name"]].Text = tostring(tscore)
		end
	end
	return UpdateMinimize()
end
local SortTeams
SortTeams = function(tentries)
	for _, val in ipairs(tentries) do
		table.sort(val["MyPlayers"], PlayerSortFunction)
		AddTeamScores(val)
	end
	return table.sort(tentries, TeamSortFunc)
end
local TeamListModeUpdate
TeamListModeUpdate = function()
	RecreateScoreColumns(PlayerFrames)
	SortTeams(TeamFrames)
	if NeutralTeam then
		AddTeamScores(NeutralTeam)
	end
	return UnrollTeams(TeamFrames, MiddleFrames)
end
local OnFriendshipChanged
OnFriendshipChanged = function(player, friendStatus)
	return Delay(0.5, function()
		debugprint("friend status changed for: " .. tostring(player.Name) .. " " .. tostring(friendStatus) .. " vs " .. tostring(GetFriendStatus(player)))
		for _, entry in ipairs(PlayerFrames) do
			if entry["Player"] == player then
				local nicon = getFriendStatusIcon(friendStatus)
				if nicon == "" and entry["Frame"].FriendLabel.Image ~= "" then
					entry["Frame"].TitleFrame.Title.Position = entry["Frame"].TitleFrame.Title.Position - UDim2.new(0, 17, 0, 0)
				elseif nicon ~= "" and entry["Frame"].FriendLabel.Image == "" then
					entry["Frame"].TitleFrame.Title.Position = entry["Frame"].TitleFrame.Title.Position + UDim2.new(0, 17, 0, 0)
					debugprint("confirmed status: " .. tostring(player.Name))
				end
				entry["Frame"].FriendLabel.Image = nicon
				return
			end
		end
	end)
end
LocalPlayer.FriendStatusChanged:connect(OnFriendshipChanged)
local TeamScoreChanged
TeamScoreChanged = function(entry, nscore)
	WaitForChild(entry["Frame"], "PlayerScore").Text = tostring(nscore)
	entry["TeamScore"] = nscore
end
local TeamChildAdded
TeamChildAdded = function(entry, nchild)
	if nchild.Name == "AutoHide" then
		entry["AutoHide"] = true
	elseif nchild.Name == "TeamScore" then
		WaitForChild(entry["Frame"], "PlayerScore").Text = tostring(nchild.Value)
		entry["TeamScore"] = nchild.Value
		return nchild.Changed:connect(function()
			return TeamScoreChanged(entry, nchild.Value)
		end)
	end
end
local TeamChildRemoved
TeamChildRemoved = function(entry, nchild)
	if nchild.Name == "AutoHide" then
		entry["AutoHide"] = false
	elseif nchild.Name == "TeamScore" then
		WaitForChild(entry["Frame"], "PlayerScore").Text = ""
		entry["TeamScore"] = nil
	end
end
local RemoveTeamFrame
RemoveTeamFrame = function(nteam)
	while AddingFrameLock do
		debugprint("in removing team frame lock")
		wait(1 / 30)
	end
	AddingFrameLock = true
	local myEntry
	for i, key in ipairs(TeamFrames) do
		if nteam == key["MyTeam"] then
			myEntry = key
			key["Frame"]:Destroy()
			table.remove(TeamFrames, i)
		end
	end
	if #TeamFrames == 0 then
		debugprint("removeteamframe, remove neutral")
		if NeutralTeam then
			RemoveNeutralTeam()
		end
	end
	for i, key in ipairs(myEntry["MyPlayers"]) do
		RemovePlayerFromTeam(myEntry, i)
		PlayerChanged(key, "TeamColor")
	end
	RemoveMiddleBGFrame()
	BaseUpdate()
	AddingFrameLock = false
end
local TeamChanged
TeamChanged = function(entry, property)
	if property == "Name" then
		WaitForChild(WaitForChild(entry["Frame"], "TitleFrame"), "Title").Text = entry["MyTeam"].Name
	elseif property == "TeamColor" then
		entry["Frame"].ClickListener.BackgroundColor3 = entry["MyTeam"].TeamColor.Color
		for _, i in pairs(TeamFrames) do
			if i["MyTeam"].TeamColor == entry["MyTeam"] then
				RemoveTeamFrame(entry["MyTeam"])
			end
		end
		entry["MyPlayers"] = { }
		for _, i in pairs(PlayerFrames) do
			SetPlayerToTeam(i)
		end
		return BaseUpdate()
	end
end
local InsertTeamFrame
InsertTeamFrame = function(nteam)
	while AddingFrameLock do
		debugprint("in adding team frame lock")
		wait(1 / 30)
	end
	AddingFrameLock = true
	local nentry = { }
	nentry["MyTeam"] = nteam
	nentry["MyPlayers"] = { }
	nentry["Frame"] = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nentry["Frame"], "TitleFrame"), "Title").Text = nteam.Name
	nentry["Frame"].TitleFrame.Title.Font = "ArialBold"
	nentry["Frame"].TitleFrame.Title.FontSize = "Size18"
	nentry["Frame"].TitleFrame.Position = UDim2.new(nentry["Frame"].TitleFrame.Position.X.Scale, nentry["Frame"].TitleFrame.Position.X.Offset, 0.1, 0)
	nentry["Frame"].TitleFrame.Size = UDim2.new(nentry["Frame"].TitleFrame.Size.X.Scale, nentry["Frame"].TitleFrame.Size.X.Offset, 0.8, 0)
	nentry["Frame"].Position = UDim2.new(1, 0, (#MiddleFrames * nentry["Frame"].Size.Y.Scale), 0)
	WaitForChild(nentry["Frame"], "ClickListener").MouseButton1Down:connect(function(nx, ny)
		return StartDrag(nentry, nx, ny)
	end)
	nentry["Frame"].ClickListener.BackgroundColor3 = nteam.TeamColor.Color
	nentry["Frame"].ClickListener.BackgroundTransparency = 0.7
	nentry["Frame"].ClickListener.AutoButtonColor = false
	AddId = AddId + 1
	nentry["ID"] = AddId
	nentry["AutoHide"] = false
	if nteam:FindFirstChild("AutoHide") then
		nentry["AutoHide"] = true
	end
	if nteam:FindFirstChild("TeamScore") then
		TeamChildAdded(nentry, nteam.TeamScore)
	end
	nteam.ChildAdded:connect(function(nchild)
		return TeamChildAdded(nentry, nchild)
	end)
	nteam.ChildRemoved:connect(function(nchild)
		return TeamChildRemoved(nentry, nchild)
	end)
	nteam.Changed:connect(function(prop)
		return TeamChanged(nentry, prop)
	end)
	for _, i in pairs(PlayerFrames) do
		if not i["Player"].Neutral and i["Player"].TeamColor == nteam.TeamColor then
			AddPlayerToTeam(nentry, i)
		end
	end
	nentry["IsHidden"] = false
	if not nentry["AutoHide"] or #nentry["MyPlayers"] > 0 then
		nentry["Frame"].Parent = ListFrame
		nentry["Frame"]:TweenPosition(UDim2.new(0.5, 0, (#MiddleFrames * nentry["Frame"].Size.Y.Scale), 0), "Out", "Linear", BASE_TWEEN, true)
		AddMiddleBGFrame()
	else
		nentry["IsHidden"] = true
		nentry["Frame"].Parent = nil
	end
	table.insert(TeamFrames, nentry)
	UpdateMinimize()
	BaseUpdate()
	if #TeamFrames == 1 and not NeutralTeam then
		AddNeutralTeam()
	end
	AddingFrameLock = false
end
local TeamAdded
TeamAdded = function(nteam)
	return InsertTeamFrame(nteam)
end
local TeamRemoved
TeamRemoved = function(nteam)
	return RemoveTeamFrame(nteam)
end
BaseUpdate = function()
	while BaseUpdateLock do
		debugprint("in baseupdate lock")
		wait(1 / 30)
	end
	BaseUpdateLock = true
	UpdateStatNames()
	if #TeamFrames == 0 and not NeutralTeam then
		PlayerListModeUpdate()
	else
		TeamListModeUpdate()
	end
	for i, key in ipairs(MiddleFrames) do
		if not (key.Parent ~= nil) then
			key:TweenPosition(UDim2.new(0.5, 0, ((#MiddleFrames - i) * key.Size.Y.Scale), 0), "Out", "Linear", BASE_TWEEN, true)
		end
	end
	if not IsMinimized.Value and #MiddleFrames > DefaultEntriesOnScreen then
		UpdateScrollPosition()
	end
	UpdateMinimize()
	UpdateScrollBarSize()
	UpdateScrollPosition()
	UpdateScrollBarVisibility()
	BaseUpdateLock = false
end
game.GuiService:AddKey("\t")
local LastTabTime = time()
game.GuiService.KeyPressed:connect(function(key)
	if key == "\t" then
		debugprint("caught tab key")
		local modalCheck, isModal
		modalCheck, isModal = pcall(function()
			return game.GuiService.IsModalDialog
		end)
		if modalCheck == false or (modalCheck and isModal == false) then
			if time() - LastTabTime > 0.4 then
				LastTabTime = time()
				if IsTabified.Value then
					if not IsMaximized.Value then
						ScreenGui:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
						IsMaximized.Value = true
					else
						ScreenGui:TweenPosition(UDim2.new(NormalBounds.X.Scale, NormalBounds.X.Offset - 10, 0, 0), "Out", "Linear", BASE_TWEEN * 1.2, true)
						IsMaximized.Value = false
						IsMinimized.Value = true
					end
				else
					return ToggleMaximize()
				end
			end
		end
	end
end)
local debugPlayerAdd
debugPlayerAdd = function(p)
	return InsertPlayerFrame(p)
end
local PlayersChildAdded
PlayersChildAdded = function(tplayer)
	if tplayer:IsA("Player") then
		return Spawn(function()
			return debugPlayerAdd(tplayer)
		end)
	else
		return BlowThisPopsicleStand()
	end
end
local coreGuiChanged
coreGuiChanged = function(coreGuiType, enabled)
	if coreGuiType == Enum.CoreGuiType.All or coreGuiType == Enum.CoreGuiType.PlayerList then
		MainFrame.Visible = enabled
	end
end
local TeamsChildAdded
TeamsChildAdded = function(nteam)
	if nteam:IsA("Team") then
		return TeamAdded(nteam)
	else
		return BlowThisPopsicleStand()
	end
end
local TeamsChildRemoved
TeamsChildRemoved = function(nteam)
	if nteam:IsA("Team") then
		return TeamRemoved(nteam)
	else
		return BlowThisPopsicleStand()
	end
end
pcall(function()
	coreGuiChanged(Enum.CoreGuiType.PlayerList, Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList))
	return Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)
while not game:GetService("Teams") do
	wait(1 / 30)
	debugprint("Waiting For Teams")
end
for _, i in pairs(game.Teams:GetTeams()) do
	TeamAdded(i)
end
for _, i in pairs(Players:GetPlayers()) do
	Spawn(function()
		return debugPlayerAdd(i)
	end)
end
game.Teams.ChildAdded:connect(TeamsChildAdded)
game.Teams.ChildRemoved:connect(TeamsChildRemoved)
Players.ChildAdded:connect(PlayersChildAdded)
InitReportAbuse()
AreNamesExpanded.Value = true
BaseUpdate()
wait(2)
IsPersonalServer = not not game.Workspace:FindFirstChild("PSVariable")
if LocalPlayer.Name == "newplayerlistisbad" or LocalPlayer.Name == "imtotallyadmin" then
	debugFrame.Parent = ScreenGui
	return Spawn(function()
		while true do
			local str_players
			str_players = ""
			for _, i in pairs(game.Players:GetPlayers()) do
				str_players = str_players .. " " .. tostring(i.Name)
			end
			debugplayers.Text = str_players
			wait(0.5)
		end
	end)
end