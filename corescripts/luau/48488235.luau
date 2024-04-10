--!strict
-- CoreGui.RobloxGui.CoreScripts/PlayerListScript
print "[Mercury]: Loaded corescript 48488235"

local RunService = game:GetService "RunService"

local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate
local log = require "../Modules/Logger"

--------------------
-- Super Util
--------------------

local ADMINS = {
	taskmanager = 1,
	heliodex = 1,
	multako = "http://banland.xyz/asset?id=6923328292",
	mercury = 1,
	pizzaboxer = "http://banland.xyz/asset?id=6917566633",
}

local Images = {
	bottomDark = 94691904,
	bottomLight = 94691940,
	midDark = 94691980,
	midLight = 94692025,
	LargeDark = 96098866,
	LargeLight = 96098920,
	LargeHeader = 96097470,
	NormalHeader = 94692054,
	LargeBottom = 96397271,
	NormalBottom = 94754966,
	DarkBluePopupMid = 97114905,
	LightBluePopupMid = 97114905,
	DarkPopupMid = 97112126,
	LightPopupMid = 97109338,
	DarkBluePopupTop = 97114838,
	DarkBluePopupBottom = 97114758,
	DarkPopupBottom = 100869219,
	LightPopupBottom = 97109175,
}

local BASE_TWEEN = 0.25

local MOUSE_DRAG_DISTANCE = 15

--[[
	makes a full sized background for a guiobject
	@Args:
	imgName		asset name of image to fill background
	@Return:	background gui object
--]]
local function MakeBackgroundGuiObj(imgName)
	return New "ImageLabel" {
		Name = "Background",
		BackgroundTransparency = 1,
		Image = imgName,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
	}
end
--[[ turns 255 integer color value to a color3 --]]
local function Colour3(r: number, g: number, b: number)
	return Color3.new(r / 255, g / 255, b / 255)
end

--[[
	Gets correct icon for builder's club status to display by name
	@Args:
	membershipType		Enum of membership status
	@Return: 			string of image asset
--]]
local function getMembershipTypeIcon(membershipType, playerName)
	if ADMINS[string.lower(playerName)] ~= nil then
		if ADMINS[string.lower(playerName)] == 1 then
			return "http://banland.xyz/asset?id=6923330951"
		end
		return ADMINS[string.lower(playerName)]
	elseif membershipType == Enum.MembershipType.None then
		return ""
	elseif membershipType == Enum.MembershipType.BuildersClub then
		return "rbxasset://textures/ui/TinyBcIcon.png"
	elseif membershipType == Enum.MembershipType.TurboBuildersClub then
		return "rbxasset://textures/ui/TinyTbcIcon.png"
	elseif membershipType == Enum.MembershipType.OutrageousBuildersClub then
		return "rbxasset://textures/ui/TinyObcIcon.png"
	else
		error("Unknown membershipType " .. membershipType)
	end
end

local function getFriendStatusIcon(friendStatus)
	if
		friendStatus == Enum.FriendStatus.Unknown
		or friendStatus == Enum.FriendStatus.NotFriend
	then
		return ""
	elseif friendStatus == Enum.FriendStatus.Friend then
		return "http://banland.xyz/asset?id=99749771"
	elseif friendStatus == Enum.FriendStatus.FriendRequestSent then
		return "http://banland.xyz/asset?id=99776888"
	elseif friendStatus == Enum.FriendStatus.FriendRequestReceived then
		return "http://banland.xyz/asset?id=99776838"
	else
		error("Unknown FriendStatus " .. friendStatus)
	end
end

---------------------------
-- Workspace Objects
---------------------------

-- might want to move all this to an init function, wait for localplayer elsewhere
local ContentProvider = game:GetService "ContentProvider"
local PersonalServerService = game:GetService "PersonalServerService"
local Players = game:GetService "Players"

-- make sure this doesn't run on the server(it will if you dont do this)
while not Players.LocalPlayer do
	Players.Changed:wait()
end

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = New "Frame" {
	Name = "PlayerListScreen",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Parent = script.Parent,
}
local MainFrame = New "Frame" {
	Name = "LeaderBoardFrame",
	Position = UDim2.new(1, -150, 0.005, 0),
	Size = UDim2.new(0, 150, 0, 800),
	BackgroundTransparency = 1,
	Parent = ScreenGui,
}

-- frame used for expanding leaderstats when frame is "focussed"
local FocusFrame = New "Frame" {
	Name = "FocusFrame",
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 100),
	BackgroundTransparency = 1,
	Active = true,
	Parent = MainFrame,
}

-- HEADER
local HeaderFrame = New "Frame" {
	Name = "Header",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0.07, 0),
	Parent = MainFrame,
	MakeBackgroundGuiObj "http://banland.xyz/asset?id=94692054",
}
local HeaderFrameHeight = HeaderFrame.Size.Y.Scale
local MaximizeButton = New "ImageButton" {
	Name = "MaximizeButton",
	Active = true,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = HeaderFrame,
}
local HeaderName = New "TextLabel" {
	Name = "PlayerName",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.01, 0),
	Size = UDim2.new(0.98, 0, 0.38, 0),
	Parent = HeaderFrame,
	Font = "ArialBold",
	Text = LocalPlayer.Name,
	FontSize = "Size24",
	--TextScaled = true,
	TextColor3 = Color3.new(1, 1, 1),
	TextStrokeColor3 = Color3.new(0, 0, 0),
	TextStrokeTransparency = 0,
	TextXAlignment = "Right",
	TextYAlignment = "Center",
}
local HeaderScore = New "TextLabel" {
	Name = "PlayerScore",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.4, 0),
	Size = UDim2.new(0.98, 0, 0, 30),
	Parent = HeaderFrame,
	Font = "ArialBold",
	Text = "",
	FontSize = "Size24",
	TextYAlignment = "Top",
	--TextScaled = true,
	TextColor3 = Color3.new(1, 1, 1),
	TextStrokeTransparency = 1,
	TextXAlignment = "Right",
}
-- BOTTOM
--used for shifting bottom frame for mouse over effects
local BottomShiftFrame = New "Frame" {
	Name = "BottomShiftFrame",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, HeaderFrameHeight, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = MainFrame,
}
local BottomFrame = New "Frame" {
	Name = "Bottom",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.07, 0),
	Size = UDim2.new(1, 0, 0.03, 0),
	Parent = BottomShiftFrame,
	MakeBackgroundGuiObj "http://banland.xyz/asset?id=94754966",
}
local ExtendButton = New "ImageButton" {
	Name = "bigbutton",
	Active = true,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1.5, 0),
	ZIndex = 3,
	Parent = BottomFrame,
}
local ExtendTab = New "ImageButton" {
	Name = "extendTab",
	Active = true,
	BackgroundTransparency = 1,
	Image = "http://banland.xyz/asset?id=94692731",
	Position = UDim2.new(0.608, 0, 0.3, 0),
	Size = UDim2.new(0.3, 0, 0.7, 0),
	Parent = BottomFrame,
}
local TopClipFrame = New "Frame" {
	Name = "ListFrame",
	BackgroundTransparency = 1,
	Position = UDim2.new(-1, 0, 0.07, 0),
	Size = UDim2.new(2, 0, 1, 0),
	Parent = MainFrame,
	ClipsDescendants = true,
}
local BottomClipFrame = New "Frame" {
	Name = "BottomFrame",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, -0.8, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = TopClipFrame,
	ClipsDescendants = true,
}
local ScrollBarFrame = New "Frame" {
	Name = "ScrollBarFrame",
	BackgroundTransparency = 1,
	Position = UDim2.new(0.987, 0, 0.8, 0),
	Size = UDim2.new(0.01, 0, 0.2, 0),
	Parent = BottomClipFrame,
}
local ScrollBar = New "Frame" {
	Name = "ScrollBar",
	BackgroundTransparency = 0,
	BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0.5, 0),
	ZIndex = 5,
	Parent = ScrollBarFrame,
}
local ListFrame = New "Frame" {
	Name = "SubFrame",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.8, 0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = BottomClipFrame,
}
local PopUpClipFrame = New "Frame" {
	Name = "PopUpFrame",
	BackgroundTransparency = 1,
	SizeConstraint = "RelativeXX",
	Position = MainFrame.Position + UDim2.new(0, -150, 0, 0),
	Size = UDim2.new(0, 150, 0, 800),
	Parent = MainFrame,
	ClipsDescendants = true,
	ZIndex = 7,
}
local PopUpPanel
local PopUpPanelTemplate = New "Frame" {
	Name = "Panel",
	BackgroundTransparency = 1,
	Position = UDim2.new(1, 0, 0, 0),
	Size = UDim2.new(1, 0, 0.032, 0),
	Parent = PopUpClipFrame,
}

local StatTitles = New "Frame" {
	Name = "StatTitles",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 1, -10),
	Size = UDim2.new(1, 0, 0, 0),
	Parent = HeaderFrame,
}

local IsMinimized = Instance.new "BoolValue"
local IsMaximized = Instance.new "BoolValue"
local IsTabified = Instance.new "BoolValue"
local AreNamesExpanded = Instance.new "BoolValue"

local MiddleTemplate = New "Frame" {
	Name = "MidTemplate",
	BackgroundTransparency = 1,
	Position = UDim2.new(100, 0, 0.07, 0),
	Size = UDim2.new(0.5, 0, 0.025, 0), --UDim2.new(1, 0, .03, 0),
	New "ImageLabel" {
		Name = "BCLabel",
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.005, 5, 0.20, 0),
		Size = UDim2.new(0, 16, 0, 16),
		SizeConstraint = "RelativeYY",
		Image = "",
		ZIndex = 3,
	},
	New "ImageLabel" {
		Name = "FriendLabel",
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.005, 5, 0.15, 0),
		Size = UDim2.new(0, 16, 0, 16),
		SizeConstraint = "RelativeYY",
		Image = "",
		ZIndex = 3,
	},
	New "ImageButton" {
		Name = "ClickListener",
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.005, 1, 0, 0),
		Size = UDim2.new(0.96, 0, 1, 0),
		ZIndex = 3,
	},
	New "Frame" {
		Name = "TitleFrame",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.01, 0, 0, 0),
		Size = UDim2.new(0, 140, 1, 0),
		ClipsDescendants = true,
		New "TextLabel" {
			Name = "Title",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(100, 0, 1, 0),
			Font = "Arial",
			FontSize = "Size14",
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			ZIndex = 3,
		},
	},

	New "TextLabel" {
		Name = "PlayerScore",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Font = "ArialBold",
		Text = "",
		FontSize = "Size14",
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = "Right",
		TextYAlignment = "Center",
		ZIndex = 3,
	},
	-- New "IntValue" {
	-- 	Name = "ID",
	-- },
	-- New "ObjectValue" {
	-- 	Name = "Player",
	-- },
	-- New "IntValue" {
	-- 	Name = "Score",
	-- },
	ZIndex = 3,
}
local MiddleBGTemplate = New "Frame" {
	Name = "MidBGTemplate",
	BackgroundTransparency = 1,
	Position = UDim2.new(100, 0, 0.07, 0),
	Size = UDim2.new(0.5, 0, 0.025, 0), --UDim2.new(1, 0, .03, 0),
	MakeBackgroundGuiObj "http://banland.xyz/asset?id=94692025",
}

-- REPORT ABUSE OBJECTS

local ReportAbuseShield = New "TextButton" {
	Name = "ReportAbuseShield",
	Text = "",
	AutoButtonColor = false,
	Active = true,
	Visible = true,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = Colour3(51, 51, 51),
	BorderColor3 = Colour3(27, 42, 53),
	BackgroundTransparency = 1,
}

local ReportAbuseFrame = New "Frame" {
	Name = "Settings",
	Position = UDim2.new(0.5, -250, 0.5, -200),
	Size = UDim2.new(0, 500, 0, 400),
	BackgroundTransparency = 1,
	Active = true,
	Parent = ReportAbuseShield,
}

local AbuseSettingsFrame = New "Frame" {
	Name = "ReportAbuseStyle",
	Size = UDim2.new(1, 0, 1, 0),
	Active = true,
	BackgroundTransparency = 1,
	MakeBackgroundGuiObj "http://banland.xyz/asset?id=96488767", -- 96480351",
	New "TextLabel" {
		Name = "Title",
		Text = "Report Abuse",
		TextColor3 = Colour3(221, 221, 221),
		Position = UDim2.new(0.5, 0, 0, 30),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size36,
	},
	New "TextLabel" {
		Name = "Description",
		Text = "This will send a complete report to a moderator. The moderator will review the chat log and take appropriate action.",
		TextColor3 = Colour3(221, 221, 221),
		Position = UDim2.new(0.01, 0, 0, 55),
		Size = UDim2.new(0.99, 0, 0, 40),
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	},
	New "TextLabel" {
		Name = "AbuseLabel",
		Text = "What did they do?",
		Font = Enum.Font.Arial,
		BackgroundTransparency = 1,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025, 0, 0, 140),
		Size = UDim2.new(0.4, 0, 0, 36),
		TextColor3 = Colour3(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
	},
	New "TextLabel" {
		Name = "ShortDescriptionLabel",
		Text = "Short Description: (optional)",
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025, 0, 0, 180),
		Size = UDim2.new(0.95, 0, 0, 36),
		TextColor3 = Colour3(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
	},
	New "TextLabel" {
		Name = "ReportingPlayerLabel",
		Text = "Reporting Player",
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025, 0, 0, 100),
		Size = UDim2.new(0.95, 0, 0, 36),
		TextColor3 = Colour3(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
	},

	Parent = ReportAbuseFrame,
}

local AbusePlayerLabel = New "TextLabel" {
	Name = "PlayerLabel",
	Text = "",
	BackgroundTransparency = 1,
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size18,
	Position = UDim2.new(0.025, 0, 0, 100),
	Size = UDim2.new(0.95, 0, 0, 36),
	TextColor3 = Colour3(255, 255, 255),
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = AbuseSettingsFrame,
}

local SubmitReportButton = New "ImageButton" {
	Name = "SubmitReportBtn",
	Active = false,
	BackgroundTransparency = 1,
	Position = UDim2.new(0.5, -200, 1, -80),
	Size = UDim2.new(0, 150, 0, 50),
	AutoButtonColor = false,
	Image = "http://banland.xyz/asset?id=96502438", -- 96501119',
	Parent = AbuseSettingsFrame,
}

local CancelReportButton = New "ImageButton" {
	Name = "CancelBtn",
	BackgroundTransparency = 1,
	Position = UDim2.new(0.5, 50, 1, -80),
	Size = UDim2.new(0, 150, 0, 50),
	AutoButtonColor = true,
	Image = "http://banland.xyz/asset?id=96500683",
	Parent = AbuseSettingsFrame,
}

local AbuseDescriptionWrapper = New "Frame" {
	Name = "AbuseDescriptionWrapper",
	Position = UDim2.new(0.025, 0, 0, 220),
	Size = UDim2.new(0.95, 0, 1, -310),
	BackgroundColor3 = Colour3(0, 0, 0),
	BorderSizePixel = 0,
	Parent = AbuseSettingsFrame,
}

local AbuseDescriptionBox

local OriginalAbuseDescriptionBox = New "TextBox" {
	Name = "TextBox",
	Text = "",
	ClearTextOnFocus = false,
	Font = Enum.Font.Arial,
	FontSize = Enum.FontSize.Size18,
	Position = UDim2.new(0, 3, 0, 3),
	Size = UDim2.new(1, -6, 1, -6),
	TextColor3 = Colour3(255, 255, 255),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrapped = true,
	BackgroundColor3 = Colour3(0, 0, 0),
	BorderSizePixel = 0,
}

local CalmingAbuseBox = New "Frame" {
	Name = "AbuseFeedbackBox",
	BackgroundTransparency = 1,
	Position = UDim2.new(0.25, 0, 0.300000012, 0),
	Size = UDim2.new(0.5, 0, 0.370000005, 0),
	MakeBackgroundGuiObj "http://banland.xyz/asset?id=96506233",
	New "TextLabel" {
		Name = "Header",
		Position = UDim2.new(0, 10, 0.05, 0),
		Size = UDim2.new(1, -30, 0.15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "Thanks for your report!",
		TextColor3 = Color3.new(1, 1, 1),
		FontSize = Enum.FontSize.Size48,
		Font = "ArialBold",
	},
	New "TextLabel" {
		Name = "content",
		Position = UDim2.new(0, 10, 0.20, 0),
		Size = UDim2.new(1, -30, 0.40, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "Our moderators will review the chat logs and determine what happened. The other user is probably just trying to make you mad.\n\nIf anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats",
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		FontSize = Enum.FontSize.Size24,
		Font = "Arial",
	},
	New "ImageButton" {
		Name = "OkButton",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -75, 1, -80),
		Size = UDim2.new(0, 150, 0, 50),
		AutoButtonColor = true,
		Image = "http://banland.xyz/asset?id=96507959",
	},
}
local NormalAbuseBox = New "Frame" {
	Name = "AbuseFeedbackBox",
	BackgroundTransparency = 1,
	Position = UDim2.new(0.25, 0, 0.300000012, 0),
	Size = UDim2.new(0.5, 0, 0.370000005, 0),
	MakeBackgroundGuiObj "http://banland.xyz/asset?id=96506233",
	New "TextLabel" {
		Name = "Header",
		Position = UDim2.new(0, 10, 0.05, 0),
		Size = UDim2.new(1, -30, 0.15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "Thanks for your report!",
		FontSize = Enum.FontSize.Size48,
		Font = "ArialBold",
	},
	New "TextLabel" {
		Name = "content",
		Position = UDim2.new(0, 10, 0.20, 0),
		Size = UDim2.new(1, -30, 0.15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "Our moderators will review the chat logs and determine what happened.",
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		FontSize = Enum.FontSize.Size24,
		Font = "Arial",
	},
	New "ImageButton" {
		Name = "OkButton",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -75, 1, -80),
		Size = UDim2.new(0, 150, 0, 50),
		AutoButtonColor = true,
		Image = "http://banland.xyz/asset?id=96507959",
	},
}

local BigButton = New "ImageButton" {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 8,
	Visible = false,
	-- Active = false,
	Parent = ScreenGui,
}

--[[
	obligatory wait for child function
	@Args:
	parent		Parent object to look for child in
	child		name of child object to look for
	@Return: object waited for
--]]
local function WaitForChild(parent, child)
	while not parent:FindFirstChild(child) do
		RunService.Heartbeat:wait()
		log(` child {parent.Name} waiting for {child}`)
	end
	return parent[child]
end

-------------------------
-- Script objects
-------------------------
local RbxGui = assert(LoadLibrary "RbxGui")

-- number of entries to show if you click minimize
local DefaultEntriesOnScreen = 8

for _, i in pairs(Images) do
	ContentProvider:Preload("http://banland.xyz/asset?id=" .. i)
end

-- ordered array of 'score data', each entry has:
-- Name(String)
-- Priority(number)
-- IsPrimary (bool, should it be shown in upper right)
-- MaxLength (integer, of the length of the longest element for this column)
local ScoreNames = {}
-- prevents flipping in playerlist panels
local AddId = 0
-- intermediate table form of all player entries in format of:
-- Frame
-- Player
-- Score
-- ID
-- MyTeam (team ENRTY(not actual team) I am currently on)
local PlayerFrames: {
	{
		Frame: Frame,
		Player: Player,
		Score: number,
		ID: number,
		MyTeam: nil,
	}
} =
	{}
-- intermediate ordered frame array, composed of Entrys of
-- Frame
-- MyTeam (my team object)
-- MyPlayers ( an ordered array of all player frames in team )
-- AutoHide (bool saying whether it should be hidden)
-- IsHidden (bool)
-- ID (int to prevent flipping out of leaderboard, fun times)
local TeamFrames: { any } = {}
-- one special entry from teamFrames, for unaffiliated players, only shown if players non - empty
local NeutralTeam

-- final 'to be displayed' list of frames
local MiddleFrames = {}
local MiddleFrameBackgrounds = {}
-- time of last click
local LastClick = 0
local ButtonCooldown = 0.25

-- local OnIos = false
-- pcall(function()
-- 	OnIos = UserInputService.TouchEnabled
-- end)

-- you get 200 of x screen space per stat added, start width 16%
local BaseScreenXSize = 150
local SpacingPerStat = 10 --spacing between stats

local MaximizedBounds = UDim2.new(0.5, 0, 1, 0)
local MaximizedPosition = UDim2.new(0.25, 0, 0.1, 0)
local NormalBounds = UDim2.new(0, BaseScreenXSize, 0, 800)
local NormalPosition = UDim2.new(1, -BaseScreenXSize, 0.005, 0)

--free space to give last stat on the right
local RightEdgeSpace = -0.04

-- where the scroll par currently is positioned

local DefaultBottomClipPos = BottomClipFrame.Position.Y.Scale

local SelectedPlayerEntry, SelectedPlayer

-- locks(semaphores) for stopping race conditions
local AddingFrameLock = false
local AddingStatLock = false
local BaseUpdateLock = false
local WaitForClickLock = false
local InPopupWaitForClick = false
local PlayerChangedLock = false
local NeutralTeamLock = false

local ScrollWheelConnections: { RBXScriptConnection }? = {}

-- local DefaultListSize = 8
-- if not OnIos then
-- 	DefaultListSize = 12
-- end
local DidMinimizeDrag = false

--local PlaceCreatorId=game.CreatorId

-- report abuse objects
local AbuseName
local Abuses = {
	"Bad Words or Threats",
	"Bad Username",
	"Talking about Dating",
	"Account Trading or Sharing",
	"Asking Personal Questions",
	"Rude or Mean Behavior",
	"False Reporting Me",
}
local UpdateAbuseFunction, AbuseDropDown

local PrivilegeLevel = {
	Owner = 255,
	Admin = 240,
	Member = 128,
	Visitor = 10,
	Banned = 0,
}

-- local IsPersonalServer = workspace:FindFirstChild "PSVariable"

-- workspace.ChildAdded:connect(function(nchild)
-- 	if nchild.Name == "PSVariable" and nchild:IsA "BoolValue" then
-- 		IsPersonalServer = true
-- 	end
-- end)
-------------------------------
-- Static Functions
-------------------------------

local function AreAllEntriesOnScreen()
	return #MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale
		<= 1 + DefaultBottomClipPos
end

local function GetMaxScroll()
	return DefaultBottomClipPos * -1
end

-- can be optimized by caching when this varible changes
local function GetMinScroll()
	if AreAllEntriesOnScreen() then
		return GetMaxScroll()
	end
	return (
		GetMaxScroll()
		- (#MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale)
	) + (1 + DefaultBottomClipPos)
end

local function AbsoluteToPercent(x, y)
	return Vector2.new(x, y) / ScreenGui.AbsoluteSize
end

--[[
	tweens property of element from starta to enda over length of time
	Warning: should be put in a Spawn call
	@Args:
	element		textobject to tween transparency on
	propName
	starta		alpha to start tweening
	enda		alpha to end tweening on
	length		how many seconds to spend tweening
--]]
local function TweenProperty(obj, propName, inita: number, enda: number, length)
	local startTime = tick()
	while tick() - startTime < length do
		obj[propName] = ((enda - inita) * ((tick() - startTime) / length))
			+ inita
		RunService.Heartbeat:wait()
	end
	obj[propName] = enda
end

--[[
	UGLY UGLY HACK FUNCTION
	replace with some sort of global input catching A.S.A. FREAKING P.
	creates a fullsize gui element to catch next mouse up event(completeing a click)
	@Args:
	frameParent		Object to parent fullscreen gui to
	polledFunction	function to call on mouse moved events in this gui
	exitFunction	function to call when click event is fired
--]]
local function WaitForClick(frameParent, polledFunction, exitFunction)
	if WaitForClickLock then
		return
	end
	WaitForClickLock = true
	local connection, connection2
	connection = BigButton.MouseButton1Up:connect(function()
		exitFunction()
		BigButton.Visible = false
		connection:disconnect()
		if connection2 then
			connection2:disconnect()
		end
		-- log "mouse up!"
	end)
	connection2 = BigButton.MouseMoved:connect(function(nx, ny)
		polledFunction(nx, ny)
	end)

	-- log "waiting for click!"
	BigButton.Visible = true
	BigButton.Active = true
	BigButton.Parent = frameParent
	frameParent.AncestryChanged:connect(function(child, nparent)
		if child == frameParent and nparent == nil then
			exitFunction()
			BigButton.Visible = false
			connection:disconnect()
			connection2:disconnect()
			log "forced out of wait for click"
		end
	end)
	WaitForClickLock = false
end

---------------------------
--Personal Server Handling
---------------------------
--[[
	returns privilege level based on integer rank
	Note: these privilege levels seem completely arbitrary, but no documentation exists
	this is all from the old player list, really weird
	@Args:
	rank	Integer rank value for player
	@Return		Normalized integer value for rank?
--]]
-- function GetPrivilegeType(rank)
-- 	if rank <= PrivilegeLevel.Banned then
-- 		return PrivilegeLevel.Banned
-- 	elseif rank <= PrivilegeLevel.Visitor then
-- 		return PrivilegeLevel.Visitor
-- 	elseif rank <= PrivilegeLevel.Member then
-- 		return PrivilegeLevel.Member
-- 	elseif rank <= PrivilegeLevel.Admin then
-- 		return PrivilegeLevel.Admin
-- 	else
-- 		return PrivilegeLevel.Owner
-- 	end
-- end

--[[
	gives a player a new privilage rank
	Note: Very odd that I have to use loops with this instead of directly setting the rank
	but no documentation for personal server service exists
	@Args:
	player		player to change rank of
	nrank		new integer rank to give player
--]]
local function SetPrivilegeRank(player, nrank: number)
	while player.PersonalServerRank < nrank do
		PersonalServerService:Promote(player)
	end
	while player.PersonalServerRank > nrank do
		PersonalServerService:Demote(player)
	end
end

--[[
	Highlights current rank of this player in the popup menu
	@Args:
	player		Player to check for rank on
--]]
local function HighlightMyRank(
	player,
	BanPlayerButton,
	VisitorButton,
	MemberButton,
	AdminButton
)
	BanPlayerButton.Image = "http://banland.xyz/asset?id="
		.. Images.LightPopupMid
	VisitorButton.Image = "http://banland.xyz/asset?id=" .. Images.DarkPopupMid
	MemberButton.Image = "http://banland.xyz/asset?id=" .. Images.LightPopupMid
	AdminButton.Image = "http://banland.xyz/asset?id=" .. Images.DarkPopupBottom

	local rank = player.PersonalServerRank
	if rank <= PrivilegeLevel.Banned then
		BanPlayerButton.Image =
			`http://banland.xyz/asset?id={Images.LightBluePopupMid}`
	elseif rank <= PrivilegeLevel.Visitor then
		VisitorButton.Image =
			`http://banland.xyz/asset?id={Images.DarkBluePopupMid}`
	elseif rank <= PrivilegeLevel.Member then
		MemberButton.Image =
			`http://banland.xyz/asset?id={Images.LightBluePopupMid}`
	elseif rank <= PrivilegeLevel.Admin then
		AdminButton.Image =
			`http://banland.xyz/asset?id={Images.DarkBluePopupBottom}`
	end
end

--[[
	called when player selects new privilege level from popup menu
	@Args:
	player		player to set privileges on
	nlevel		new privilege level for this player
--]]
local function OnPrivilegeLevelSelect(
	player,
	nlevel,
	BanPlayerButton,
	VisitorButton,
	MemberButton,
	AdminButton
)
	log "setting privilege level"
	SetPrivilegeRank(player, nlevel)
	HighlightMyRank(
		player,
		BanPlayerButton,
		VisitorButton,
		MemberButton,
		AdminButton
	)
end

--------------------------
-- Report abuse handling
--------------------------

--[[
	resets and closes abuse dialog
--]]
local function CloseAbuseDialog()
	AbuseName = nil
	SubmitReportButton.Active = false
	SubmitReportButton.Image = "http://banland.xyz/asset?id=96502438" -- 96501119",
	AbuseDescriptionBox:Destroy()
	CalmingAbuseBox.Parent = nil
	NormalAbuseBox.Parent = nil
	ReportAbuseShield.Parent = nil
	AbuseSettingsFrame.Visible = true
end

--[[
	does final reporting of abuse on selected player, calls closeAbuseDialog
--]]
local function OnSubmitAbuse()
	if SubmitReportButton.Active then
		if AbuseName and SelectedPlayer then
			AbuseSettingsFrame.Visible = false
			game.Players:ReportAbuse(
				SelectedPlayer,
				AbuseName,
				AbuseDescriptionBox.Text
			)
			if
				AbuseName == "Rude or Mean Behavior"
				or AbuseName == "False Reporting Me"
			then
				CalmingAbuseBox.Parent = ReportAbuseShield
			else
				log "opening abuse box"
				NormalAbuseBox.Parent = ReportAbuseShield
			end
		else
			CloseAbuseDialog()
		end
	end
end

local function ClosePopUpPanel()
	if SelectedPlayerEntry then
		local tframe = SelectedPlayerEntry.Frame
		Spawn(function()
			TweenProperty(tframe, "BackgroundTransparency", 0.5, 1, BASE_TWEEN)
		end)
	end
	PopUpPanel:TweenPosition(
		UDim2.new(1, 0, 0, 0),
		"Out",
		"Linear",
		BASE_TWEEN,
		true
	)
	wait(0.1)
	InPopupWaitForClick = false
	SelectedPlayerEntry = nil
end

--[[
	opens the abuse dialog, initialises text to display selectedplayer
--]]
local function OpenAbuseDialog()
	log "adding report dialog"
	AbusePlayerLabel.Text = SelectedPlayer.Name
	--AbuseDescriptionBox.Text = ""
	PopUpPanel:TweenPosition(
		UDim2.new(1, 0, 0, 0),
		"Out",
		"Linear",
		BASE_TWEEN,
		true
	)
	AbuseDescriptionBox = OriginalAbuseDescriptionBox:Clone()
	AbuseDescriptionBox.Parent = AbuseDescriptionWrapper
	ReportAbuseShield.Parent = ScreenGui
	ClosePopUpPanel()
end

--[[
	creates dropdownbox, registers all listeners for abuse dialog
--]]
local function InitReportAbuse()
	function UpdateAbuseFunction(abuseText)
		AbuseName = abuseText
		if AbuseName and SelectedPlayer then
			SubmitReportButton.Active = true
			SubmitReportButton.Image = "http://banland.xyz/asset?id=96501119"
		end
	end

	AbuseDropDown = RbxGui.CreateDropDownMenu(Abuses, UpdateAbuseFunction, true)
	AbuseDropDown.Name = "AbuseComboBox"
	AbuseDropDown.Position = UDim2.new(0.425, 0, 0, 142)
	AbuseDropDown.Size = UDim2.new(0.55, 0, 0, 32)
	AbuseDropDown.Parent = AbuseSettingsFrame

	CancelReportButton.MouseButton1Click:connect(CloseAbuseDialog)
	SubmitReportButton.MouseButton1Click:connect(OnSubmitAbuse)

	CalmingAbuseBox:FindFirstChild("OkButton").MouseButton1Down
		:connect(CloseAbuseDialog)
	NormalAbuseBox:FindFirstChild("OkButton").MouseButton1Down
		:connect(CloseAbuseDialog)
end

-------------------------------------
-- Friend/unfriending
-------------------------------------
--[[
	gets enum val of friend status, uses pcall for some reason?(from old playerlist)
	@Args:
	player	player object to check if friends with
	@Return: enum of friend status
--]]
local function GetFriendStatus(player: Player)
	if player == game.Players.LocalPlayer then
		return Enum.FriendStatus.NotFriend
	end
	local ok, result = pcall(function()
		return game.Players.LocalPlayer:GetFriendStatus(player)
	end)
	if ok then
		return result
	end
	return Enum.FriendStatus.NotFriend
end

--[[
	when friend button is clicked, tries to take appropriate action,
	based on current friend status with SelectedPlayer
--]]
local function OnFriendButtonSelect()
	local friendStatus = GetFriendStatus(SelectedPlayer)
	if friendStatus == Enum.FriendStatus.Friend then
		LocalPlayer:RevokeFriendship(SelectedPlayer)
	elseif
		friendStatus == Enum.FriendStatus.Unknown
		or friendStatus == Enum.FriendStatus.NotFriend
		or friendStatus == Enum.FriendStatus.FriendRequestSent
		or friendStatus == Enum.FriendStatus.FriendRequestReceived
	then
		LocalPlayer:RequestFriendship(SelectedPlayer)
	end
	--PersonalServerPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", .5,true)
	ClosePopUpPanel()
	--PopUpPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Linear", BASE_TWEEN,true)
end

local function OnFriendRefuseButtonSelect()
	LocalPlayer:RevokeFriendship(SelectedPlayer)
	ClosePopUpPanel()
	PopUpPanel:TweenPosition(
		UDim2.new(1, 0, 0, 0),
		"Out",
		"Linear",
		BASE_TWEEN,
		true
	)
end
------------------------------------
-- Player Entry Handling
------------------------------------

type Plr = {
	Score: number,
	Player: Player,
}

--[[
	used by lua's table.sort to sort player entries
--]]
local function PlayerSortFunction(a: Plr, b: Plr)
	-- prevents flipping out leaderboard
	if a.Score == b.Score then
		return a.Player.Name:upper() < b.Player.Name:upper()
	elseif not a.Score then
		return false
	elseif not b.Score then
		return true
	end
	return a.Score < b.Score
end

---------------------------------
-- Stat Handling
---------------------------------

---------------------------
-- Minimizing and maximizing
---------------------------

local function ExpandNames()
	if #ScoreNames ~= 0 then
		for _, i in pairs(StatTitles:GetChildren()) do
			Spawn(function()
				TweenProperty(
					i,
					"TextTransparency",
					i.TextTransparency,
					0,
					BASE_TWEEN
				)
			end)
		end
		HeaderFrameHeight = 0.09
		--as of writing, this and 'CloseNames' are the only places headerframe is resized
		HeaderFrame:TweenSizeAndPosition(
			UDim2.new(
				HeaderFrame.Size.X.Scale,
				HeaderFrame.Size.X.Offset,
				HeaderFrameHeight,
				0
			),
			HeaderFrame.Position,
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		TopClipFrame:TweenPosition(
			UDim2.new(TopClipFrame.Position.X.Scale, 0, HeaderFrameHeight, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		BottomShiftFrame:TweenPosition(
			UDim2.new(0, 0, HeaderFrameHeight, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
	end
end

local function CloseNames()
	if #ScoreNames ~= 0 then
		HeaderFrameHeight = 0.07
		if not IsMaximized.Value then
			for _, i in pairs(StatTitles:GetChildren()) do
				Spawn(function()
					TweenProperty(
						i,
						"TextTransparency",
						i.TextTransparency,
						1,
						BASE_TWEEN
					)
				end)
			end
		end
		BottomShiftFrame:TweenPosition(
			UDim2.new(0, 0, HeaderFrameHeight, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		HeaderFrame:TweenSizeAndPosition(
			UDim2.new(
				HeaderFrame.Size.X.Scale,
				HeaderFrame.Size.X.Offset,
				HeaderFrameHeight,
				0
			),
			HeaderFrame.Position,
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		TopClipFrame:TweenPosition(
			UDim2.new(TopClipFrame.Position.X.Scale, 0, HeaderFrameHeight, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
	end
end

local function UpdateStatNames()
	if not AreNamesExpanded.Value or IsMinimized.Value then
		CloseNames()
	else
		ExpandNames()
	end
end

local function ToggleMinimize()
	IsMinimized.Value = not IsMinimized.Value
	UpdateStatNames()
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
	"Size48",
}

--[[
	Will fit the player's name to the bounds of the header
	called on resize of the window and playedr name change events
	HACK: cannot use 'Textscaled' due to unable to find text bounds when scaled
--]]
local function UpdateHeaderNameSize()
	local tHeader = HeaderName:Clone()
	tHeader.Position = UDim2.new(2, 0, 2, 0)
	tHeader.Parent = ScreenGui
	local fSize = 7 --Size24 in table
	tHeader.FontSize = FONT_SIZES[fSize]
	Delay(0.2, function()
		while tHeader.TextBounds.x == 0 do
			RunService.Heartbeat:wait()
		end
		while tHeader.TextBounds.x - NormalBounds.X.Offset > 1 do
			fSize -= 1
			tHeader.FontSize = FONT_SIZES[fSize]
			wait(0.2)
		end
		HeaderName.FontSize = tHeader.FontSize
		tHeader:Destroy()
	end)
end
ScreenGui.Changed:connect(UpdateHeaderNameSize)

local UpdateMinimize

--[[
	Manages the position/size of the mainFrame, swaps out different resolution images for the frame
	fades in and out the stat names, moves position of headername and header score
--]]
local function UpdateMaximize()
	if IsMaximized.Value then
		for j = 1, #ScoreNames, 1 do
			local scoreval = ScoreNames[j]
			StatTitles[scoreval.Name]:TweenPosition(
				UDim2.new(0.4 + ((0.6 / #ScoreNames) * (j - 1)) - 1, 0, 0, 0),
				"Out",
				"Linear",
				BASE_TWEEN,
				true
			)
		end

		if IsMinimized.Value then
			ToggleMinimize()
		else
			UpdateMinimize()
		end

		MainFrame:TweenSizeAndPosition(
			MaximizedBounds,
			MaximizedPosition,
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		HeaderScore:TweenPosition(
			UDim2.new(0, 0, HeaderName.Position.Y.Scale, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		HeaderName:TweenPosition(
			UDim2.new(
				-0.1,
				-HeaderScore.TextBounds.x,
				HeaderName.Position.Y.Scale,
				0
			),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		HeaderFrame.Background.Image = "http://banland.xyz/asset?id="
			.. Images.LargeHeader
		BottomFrame.Background.Image = "http://banland.xyz/asset?id="
			.. Images.LargeBottom
		for index, i in ipairs(MiddleFrameBackgrounds) do
			if (index % 2) ~= 1 then
				i.Background.Image = "http://banland.xyz/asset?id="
					.. Images.LargeDark
			else
				i.Background.Image = "http://banland.xyz/asset?id="
					.. Images.LargeLight
			end
		end
		for _, i in ipairs(MiddleFrames) do
			if i:FindFirstChild "ClickListener" then
				i.ClickListener.Size =
					UDim2.new(0.974, 0, i.ClickListener.Size.Y.Scale, 0)
			end
			for j = 1, #ScoreNames, 1 do
				local scoreval = ScoreNames[j]
				if i:FindFirstChild(scoreval.Name) then
					i[scoreval.Name]:TweenPosition(
						UDim2.new(
							0.4 + ((0.6 / #ScoreNames) * (j - 1)) - 1,
							0,
							0,
							0
						),
						"Out",
						"Linear",
						BASE_TWEEN,
						true
					)
				end
			end
		end
		for _, entry in ipairs(PlayerFrames) do
			WaitForChild(entry.Frame, "TitleFrame").Size =
				UDim2.new(0.38, 0, entry.Frame.TitleFrame.Size.Y.Scale, 0)
		end

		for _, entry in ipairs(TeamFrames) do
			WaitForChild(entry.Frame, "TitleFrame").Size =
				UDim2.new(0.38, 0, entry.Frame.TitleFrame.Size.Y.Scale, 0)
		end
	else
		if not IsMinimized.Value then
			MainFrame:TweenSizeAndPosition(
				NormalBounds,
				NormalPosition,
				"Out",
				"Linear",
				BASE_TWEEN * 1.2,
				true
			)
		end
		HeaderScore:TweenPosition(
			UDim2.new(0, 0, 0.4, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		HeaderName:TweenPosition(
			UDim2.new(0, 0, HeaderName.Position.Y.Scale, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		HeaderFrame.Background.Image = "http://banland.xyz/asset?id="
			.. Images.NormalHeader
		BottomFrame.Background.Image = "http://banland.xyz/asset?id="
			.. Images.NormalBottom
		for index, i in ipairs(MiddleFrameBackgrounds) do
			if index % 2 ~= 1 then
				i.Background.Image = "http://banland.xyz/asset?id="
					.. Images.midDark
			else
				i.Background.Image = "http://banland.xyz/asset?id="
					.. Images.midLight
			end
		end
		for _, i in ipairs(MiddleFrames) do
			if i:FindFirstChild "ClickListener" then
				i.ClickListener.Size =
					UDim2.new(0.96, 0, i.ClickListener.Size.Y.Scale, 0)
				for j = 1, #ScoreNames, 1 do
					local scoreval = ScoreNames[j]
					if i:FindFirstChild(scoreval.Name) and scoreval.XOffset then
						-- print(`updateing stat position {scoreval["Name"]}`)
						i[scoreval.Name]:TweenPosition(
							UDim2.new(RightEdgeSpace, -scoreval.XOffset, 0, 0),
							"Out",
							"Linear",
							BASE_TWEEN,
							true
						)
					end
				end
			end
		end

		for _, entry in ipairs(TeamFrames) do
			WaitForChild(entry.Frame, "TitleFrame").Size = UDim2.new(
				0,
				BaseScreenXSize * 0.9,
				entry.Frame.TitleFrame.Size.Y.Scale,
				0
			)
		end
		for _, entry in ipairs(PlayerFrames) do
			WaitForChild(entry.Frame, "TitleFrame").Size = UDim2.new(
				0,
				BaseScreenXSize * 0.9,
				entry.Frame.TitleFrame.Size.Y.Scale,
				0
			)
		end
	end
end

local function GetScoreValue(score: ValueBase): number
	if
		score:IsA "DoubleConstrainedValue" or score:IsA "IntConstrainedValue"
	then
		return score.ConstrainedValue
	elseif score:IsA "BoolValue" then
		return score.Value and 1 or 0
	end
	return score.Value
end

--[[
	updates size of scrollbar depending on how many entries exist
--]]
local function UpdateScrollBarSize()
	local entryListSize = #MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale
	local shownAreaSize = (BottomClipFrame.Position.Y.Scale + 1)
	ScrollBar.Size = UDim2.new(1, 0, shownAreaSize / entryListSize, 0)
end

--[[
	updates whether the scroll bar should be showing, if it is showing, updates
	the size of it
--]]
local function UpdateScrollBarVisibility()
	if AreAllEntriesOnScreen() then
		ScrollBar.BackgroundTransparency = 1
	else
		ScrollBar.BackgroundTransparency = 0
		UpdateScrollBarSize()
	end
end

--[[
	updates position of listframe so that no gaps at the bottom or top of the list are visible
	updates position of scrollbar to match what parts of the list are visible
--]]
local function UpdateScrollPosition()
	local minPos = GetMinScroll()
	local maxPos = GetMaxScroll()
	local scrollLength = maxPos - minPos

	local yscrollpos =
		math.max(math.min(ListFrame.Position.Y.Scale, maxPos), minPos)
	ListFrame.Position = UDim2.new(
		ListFrame.Position.X.Scale,
		ListFrame.Position.X.Offset,
		yscrollpos,
		ListFrame.Position.Y.Offset
	)

	local adjustedLength = 1 - ScrollBar.Size.Y.Scale
	ScrollBar.Position = UDim2.new(
		0,
		0,
		adjustedLength
			- (
				adjustedLength
				* ((ListFrame.Position.Y.Scale - minPos) / scrollLength)
			),
		0
	)
end

--[[
	turns a list of team entries with sub lists of players into a single ordered
	list, in the correct order,and of the correct length
	@Args:
	tframes		the team entries to unroll
	outframes	the list to unroll these entries into
--]]
local function UnrollTeams(tframes: { any }, outframes: { any })
	local numEntries = 0
	if NeutralTeam and not NeutralTeam.IsHidden then
		for _, val in ipairs(NeutralTeam.MyPlayers) do
			numEntries += 1
			outframes[numEntries] = val.Frame
		end
		numEntries += 1
		outframes[numEntries] = NeutralTeam.Frame
	end
	for _, val in ipairs(tframes) do
		if not val.IsHidden then
			for _, pval in ipairs(val.MyPlayers) do
				numEntries += 1
				outframes[numEntries] = pval.Frame
			end
			numEntries += 1
			outframes[numEntries] = val.Frame
		end
	end
	-- clear any additional entries from outframes
	for i = numEntries + 1, #outframes, 1 do
		outframes[i] = nil
	end
end

-- OUTLINE
--[[
	adds up all the score of this team's players to form the team score
	@Args:
	team		team entry to sum the scores of
--]]
local function AddTeamScores(team)
	for j = 1, #ScoreNames, 1 do
		local i = ScoreNames[j]
		local tscore = 0
		for _, k in ipairs(team.MyPlayers) do
			local tval = k.Player:FindFirstChild "leaderstats"
				and k.Player.leaderstats:FindFirstChild(i.Name)
			if tval and not tval:IsA "StringValue" then
				tscore += GetScoreValue((k.Player.leaderstats)[i.Name])
			end
		end
		if team.Frame:FindFirstChild(i.Name) then
			-- team.Frame[i.Name].Size = UDim2.new(
			-- 	1 - (ScrollBarFrame.Size.X.Scale * 2),
			-- 	-((j - 1) * SpacingPerStat),
			-- 	1,
			-- 	0
			-- )
			team.Frame[i.Name].Text = tostring(tscore)
		end
	end
	UpdateMinimize()
end

--[[
	uses lua's table.sort to sort the teams
--]]
local function TeamSortFunc(a, b)
	if a.TeamScore == b.TeamScore then
		return a.ID < b.ID
	end
	if not a.TeamScore then
		return false
	end
	if not b.TeamScore then
		return true
	end
	return a.TeamScore < b.TeamScore
end

--[[
	consider adding lock with wait for performance
	sorts each of the team's player lists induvidually, adds up the team scores.
	@Args:
	tentries		table of team entries
--]]
local function SortTeams(tentries)
	for _, val in ipairs(tentries) do
		table.sort(val.MyPlayers, PlayerSortFunction)
		AddTeamScores(val)
	end
	table.sort(tentries, TeamSortFunc)
end

local RecreateScoreColumns

--[[
	base update for team mode, adds up the scores of all teams, sorts them,
	then unrolls them into middleframes
--]]
local function TeamListModeUpdate()
	RecreateScoreColumns(PlayerFrames)
	SortTeams(TeamFrames)
	if NeutralTeam then
		AddTeamScores(NeutralTeam)
		-- RecreateScoreColumns(NeutralTeam.MyPlayers)
	end
	UnrollTeams(TeamFrames, MiddleFrames)
end

-- OUTLINE
--[[
		the basic update for the playerlist mode's state,
		assures the order and length of the player frames
	--]]
local function PlayerListModeUpdate()
	RecreateScoreColumns(PlayerFrames)
	table.sort(PlayerFrames, PlayerSortFunction)
	for i, val in ipairs(PlayerFrames) do
		MiddleFrames[i] = val.Frame
	end
	for i = #PlayerFrames + 1, #MiddleFrames, 1 do
		MiddleFrames[i] = nil
	end
	UpdateMinimize()
end

--[[
	called when ANYTHING changes the state of the playerlist
	re-sorts everything,assures correct positions of all elements
--]]
local function BaseUpdate()
	while BaseUpdateLock do
		log "in baseupdate lock"
		RunService.Heartbeat:wait()
	end
	BaseUpdateLock = true
	-- print "baseupdate"
	UpdateStatNames()

	if #TeamFrames == 0 and not NeutralTeam then
		PlayerListModeUpdate()
	else
		TeamListModeUpdate()
	end
	for i, key in ipairs(MiddleFrames) do
		if key.Parent ~= nil then
			key:TweenPosition(
				UDim2.new(0.5, 0, ((#MiddleFrames - i) * key.Size.Y.Scale), 0),
				"Out",
				"Linear",
				BASE_TWEEN,
				true
			)
		end
	end
	if not IsMinimized.Value and #MiddleFrames > DefaultEntriesOnScreen then
		UpdateScrollPosition()
	end

	UpdateMinimize()

	UpdateScrollBarSize()
	UpdateScrollPosition()

	UpdateScrollBarVisibility()
	-- log "EndBaseUpdate"
	BaseUpdateLock = false
end

function RecreateScoreColumns(ptable)
	-- OUTLINE
	local function MakeScoreEntry(entry, scoreval, panel)
		if not panel:FindFirstChild "PlayerScore" then
			return
		end
		local nscoretxt = panel:FindFirstChild("PlayerScore"):Clone()
		local thisScore
		-- here lies the resting place of a once great and terrible bug
		-- may its treachery never be forgotten, lest its survivors fall for it again
		-- RIP the leaderstat bug, oct 2012-nov 2012
		RunService.Heartbeat:wait()
		if
			entry.Player:FindFirstChild "leaderstats"
			and entry.Player.leaderstats:FindFirstChild(scoreval.Name)
		then
			thisScore = entry.Player
				:FindFirstChild("leaderstats")
				:FindFirstChild(scoreval.Name)
		else
			return
		end

		if not entry.Player.Parent then
			return
		end

		nscoretxt.Name = scoreval.Name
		nscoretxt.Text = tostring(GetScoreValue(thisScore))
		if scoreval.Name == ScoreNames[1]["Name"] then
			log "changing score"
			entry.Score = GetScoreValue(thisScore)
			if entry.Player == LocalPlayer then
				HeaderScore.Text = tostring(GetScoreValue(thisScore))
			end
		end

		thisScore.Changed:connect(function()
			if not thisScore.Parent then
				return
			elseif scoreval.Name == ScoreNames[1]["Name"] then
				entry.Score = GetScoreValue(thisScore)
				if entry.Player == LocalPlayer then
					HeaderScore.Text = tostring(GetScoreValue(thisScore))
				end
			end
			nscoretxt.Text = tostring(GetScoreValue(thisScore))
			BaseUpdate()
		end)
		return nscoretxt
	end

	while AddingStatLock do
		log "In Adding Stat Lock2"
		RunService.Heartbeat:wait()
	end
	AddingStatLock = true
	local Xoffset = 5 --15 --current offset from Right
	local maxXOffset = Xoffset
	local MaxSizeColumn = 0 --max size for this column

	-- foreach known leaderstat
	for j = #ScoreNames, 1, -1 do
		local scoreval = ScoreNames[j]

		MaxSizeColumn = 0
		-- for each entry in this player table
		for _, entry in ipairs(ptable) do
			local panel = entry.Frame
			-- if this panel does not have an element named after this stat
			if not panel:FindFirstChild(scoreval.Name) then
				-- make an entry for this object
				local nentry = MakeScoreEntry(entry, scoreval, panel)
				if nentry then
					log(`adding {nentry.Name} to {entry.Player.Name}`)
					nentry.Parent = panel
					-- add score to team
					if
						entry.MyTeam
						and entry.MyTeam ~= NeutralTeam
						and not entry.MyTeam.Frame:FindFirstChild(scoreval.Name)
					then
						local ntitle = nentry:Clone()
						-- ntitle.TextXAlignment = "Right"
						ntitle.Parent = entry.MyTeam.Frame
					end
				end
			end
			scoreval.XOffset = Xoffset

			if panel:FindFirstChild(scoreval.Name) then
				MaxSizeColumn =
					math.max(MaxSizeColumn, panel[scoreval.Name].TextBounds.X)
			end
		end

		if AreNamesExpanded.Value then
			MaxSizeColumn =
				math.max(MaxSizeColumn, StatTitles[scoreval.Name].TextBounds.X)
			StatTitles[scoreval.Name]:TweenPosition(
				UDim2.new(RightEdgeSpace, -Xoffset, 0, 0),
				"Out",
				"Linear",
				BASE_TWEEN,
				true
			)
		else
			StatTitles[scoreval.Name]:TweenPosition(
				UDim2.new((0.4 + ((0.6 / #ScoreNames) * (j - 1))) - 1, 0, 0, 0),
				"Out",
				"Linear",
				BASE_TWEEN,
				true
			)
		end
		scoreval.ColumnSize = MaxSizeColumn
		Xoffset += SpacingPerStat + MaxSizeColumn
		maxXOffset = math.max(Xoffset, maxXOffset)
	end
	NormalBounds =
		UDim2.new(0, BaseScreenXSize + maxXOffset - SpacingPerStat, 0, 800)
	NormalPosition =
		UDim2.new(1, -NormalBounds.X.Offset, NormalPosition.Y.Scale, 0)
	UpdateHeaderNameSize()
	UpdateMaximize()

	AddingStatLock = false
end

local function ToggleMaximize()
	IsMaximized.Value = not IsMaximized.Value
	RecreateScoreColumns(PlayerFrames) -- done to re-position stat names NOTE: optimize-able
end

--[[
	Does more than it looks like
	monitors positions of the clipping frames and bottom frames
	called from EVERYWHERE, too much probably
--]]
function UpdateMinimize()
	if IsMinimized.Value then
		if IsMaximized.Value then
			ToggleMaximize()
		end
		if not IsTabified.Value then
			MainFrame:TweenSizeAndPosition(
				UDim2.new(
					0.010,
					HeaderName.TextBounds.X,
					NormalBounds.Y.Scale,
					NormalBounds.Y.Offset
				),
				UDim2.new(
					0.990,
					-HeaderName.TextBounds.X,
					NormalPosition.Y.Scale,
					0
				),
				"Out",
				"Linear",
				BASE_TWEEN * 1.2,
				true
			)
		else
			MainFrame:TweenSizeAndPosition(
				NormalBounds,
				NormalPosition,
				"Out",
				"Linear",
				BASE_TWEEN * 1.2,
				true
			)
		end
		--(#MiddleFrameBackgrounds*MiddleBGTemplate.Size.Y.Scale)
		BottomClipFrame:TweenPosition(
			UDim2.new(0, 0, -1, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		BottomFrame:TweenPosition(
			UDim2.new(0, 0, 0, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
		FocusFrame.Size = UDim2.new(1, 0, HeaderFrameHeight, 0)
		ExtendTab.Image = "http://banland.xyz/asset?id=94692731"
	else
		if not IsMaximized.Value then
			MainFrame:TweenSizeAndPosition(
				NormalBounds,
				NormalPosition,
				"Out",
				"Linear",
				BASE_TWEEN * 1.2,
				true
			)
		end
		--do limiting
		DefaultBottomClipPos = math.min(
			math.max(DefaultBottomClipPos, -1),
			-1 + (#MiddleFrameBackgrounds * MiddleBGTemplate.Size.Y.Scale)
		)
		UpdateScrollPosition()

		BottomClipFrame.Position = UDim2.new(0, 0, DefaultBottomClipPos, 0)
		local bottomPositon = (
			DefaultBottomClipPos + BottomClipFrame.Size.Y.Scale
		)
		BottomFrame.Position = UDim2.new(0, 0, bottomPositon, 0)
		FocusFrame.Size = UDim2.new(1, 0, bottomPositon + HeaderFrameHeight, 0)
		ExtendTab.Image = "http://banland.xyz/asset?id=94825585"
	end
end

local function Tabify()
	IsTabified.Value = true
	IsMaximized.Value = false
	IsMinimized.Value = true
	UpdateMinimize()
	IsTabified.Value = true
	ScreenGui:TweenPosition(
		UDim2.new(NormalBounds.X.Scale, NormalBounds.X.Offset - 10, 0, 0),
		"Out",
		"Linear",
		BASE_TWEEN * 1.2,
		true
	)
end

local function UnTabify()
	if IsTabified.Value then
		IsTabified.Value = false
		ScreenGui:TweenPosition(
			UDim2.new(0, 0, 0, 0),
			"Out",
			"Linear",
			BASE_TWEEN * 1.2,
			true
		)
	end
end

-- removes and closes all leaderboard stuffs
local function BlowThisPopsicleStand()
	-- ScreenGui:Destroy()
	-- script:Destroy()
	--time to make the fanboys rage...
	Tabify()
end
--[[
	used by lua's table.sort to prioritize score entries
--]]
local function StatSort(a, b)
	-- primary stats should be shown before all others
	if a.IsPrimary ~= b.IsPrimary then
		return a.IsPrimary
	end
	-- if priorities are equal, then return the first added one
	if a.Priority == b.Priority then
		return a.AddId < b.AddId
	end
	return a.Priority < b.Priority
end

--[[
	doing WAAY too much here, for optimization update only your team
	@Args:
	playerEntry		Entry of player who had a stat change
	property		Name of stat changed
--]]
local function StatChanged(_, _) --playerEntry, property)
	-- if playerEntry["MyTeam"] then
	-- 	UpdateSingleTeam(playerEntry["MyTeam"])
	-- else
	BaseUpdate()
	-- end
end

local function CreateStatTitle(statName)
	local ntitle = MiddleTemplate:FindFirstChild("PlayerScore"):Clone()
	ntitle.Name = statName
	ntitle.Text = statName
	-- ntitle
	if IsMaximized.Value then
		ntitle.TextTransparency = 0
	else
		ntitle.TextTransparency = 1
	end
	ntitle.Parent = StatTitles
end

--[[
	Called when stat is added
	if playerEntry is localplayer, will add to score names and re-sort the stats, and resize the width of the leaderboard
	for all players, will add a listener for if this stat changes
	if stat is a string value, crashes the leaderboard
	Note:change crash to a 'tabify' leaderboard later
	@Args:
	nchild			new child value to leaderstats
	playerEntry		entry this stat was added to
--]]
local function StatAdded(nchild, playerEntry)
	-- dont re - add a leaderstat I alreday have
	while AddingStatLock do
		log "in stat added function lock"
		RunService.Heartbeat:wait()
	end
	AddingStatLock = true
	if
		not (
			nchild:IsA "StringValue"
			or nchild:IsA "IntValue"
			or nchild:IsA "BoolValue"
			or nchild:IsA "NumberValue"
			or nchild:IsA "DoubleConstrainedValue"
			or nchild:IsA "IntConstrainedValue"
		)
	then
		BlowThisPopsicleStand()
	else
		local haveScore = false
		for _, i in pairs(ScoreNames) do
			if i.Name == nchild.Name then
				haveScore = true
			end
		end
		if not haveScore then
			local nstat = {}
			nstat.Name = nchild.Name
			nstat.Priority = 0
			if nchild:FindFirstChild "Priority" then
				nstat.Priority = nchild.Priority
			end
			nstat.IsPrimary = false
			if nchild:FindFirstChild "IsPrimary" then
				nstat.IsPrimary = true
			end
			nstat.AddId = AddId
			AddId += 1
			table.insert(ScoreNames, nstat)
			table.sort(ScoreNames, StatSort)
			if not StatTitles:FindFirstChild(nstat.Name) then
				CreateStatTitle(nstat.Name)
			end
			UpdateMaximize()
		end
	end
	AddingStatLock = false
	StatChanged(playerEntry)
	nchild.Changed:connect(function(property)
		StatChanged(playerEntry, property)
	end)
end

--returns whether any of the existing players has this stat
local function DoesStatExist(statName, exception)
	for _, playerf in pairs(PlayerFrames) do
		if
			playerf.Player ~= exception
			and playerf.Player:FindFirstChild "leaderstats"
			and playerf.Player.leaderstats:FindFirstChild(statName)
		then
			-- print(`player {playerf.Player.Name} has stat`)
			return true
		end
	end
	return false
end

--[[
	Called when stat is removed from player
	for all players, destroys the stat frame associated with this value,
	then calls statchanged(to resize frame)
	if playerEntry==localplayer, will remove from scorenames
	@Args:
	nchild			___value to be removed
	playerEntry		entry of player value is being removed from
--]]
local function StatRemoved(nchild, playerEntry)
	while AddingStatLock do
		log "In Adding Stat Lock1"
		RunService.Heartbeat:wait()
	end
	AddingStatLock = true
	if playerEntry.Frame:FindFirstChild(nchild.Name) then
		log "Destroyed frame!"
		playerEntry.Frame[nchild.Name].Parent = nil
	end
	if not DoesStatExist(nchild.Name, playerEntry.Player) then
		for i, val in ipairs(ScoreNames) do
			if val.Name == nchild.Name then
				table.remove(ScoreNames, i)
				if StatTitles:FindFirstChild(nchild.Name) then
					StatTitles[nchild.Name]:Destroy()
				end
				for _, teamf in pairs(TeamFrames) do
					if teamf.Frame:FindFirstChild(nchild.Name) then
						teamf.Frame[nchild.Name]:Destroy()
					end
				end
			end
		end
	end
	AddingStatLock = false
	StatChanged(playerEntry)
end
--[[
	clears all stats from a given playerEntry
	used when leaderstats are removed, or when new leaderstats are added(for weird edge case)+
--]]
local function RemoveAllStats(playerEntry)
	for _, val in ipairs(ScoreNames) do
		StatRemoved(val, playerEntry)
	end
end

local function OnScrollWheelMove(direction)
	if not (IsTabified.Value or IsMinimized.Value or InPopupWaitForClick) then
		local StartFrame = ListFrame.Position
		local newFrameY = math.max(
			math.min(StartFrame.Y.Scale + direction, GetMaxScroll()),
			GetMinScroll()
		)

		ListFrame.Position = UDim2.new(
			StartFrame.X.Scale,
			StartFrame.X.Offset,
			newFrameY,
			StartFrame.Y.Offset
		)
		UpdateScrollPosition()
	end
end

local function AttachScrollWheel()
	if ScrollWheelConnections then
		return
	end
	ScrollWheelConnections = {
		Mouse.WheelForward:connect(function()
			OnScrollWheelMove(0.05)
		end),
		Mouse.WheelBackward:connect(function()
			OnScrollWheelMove(-0.05)
		end),
	}
end

local function DetachScrollWheel()
	if ScrollWheelConnections then
		for _, i in pairs(ScrollWheelConnections) do
			i:disconnect()
		end
	end
	ScrollWheelConnections = nil
end

FocusFrame.MouseEnter:connect(function()
	if not (IsMinimized.Value or IsTabified.Value) then
		AttachScrollWheel()
	end
end)
FocusFrame.MouseLeave:connect(function()
	--if not (IsMaximized.Value or IsMinimized.Value) then
	DetachScrollWheel()
	--end
end)

------------------------
-- Scroll Bar functions
------------------------

--[[
	Utility function to create buttons for the popup menus
	@Args:
	nparent		what to parent this button to
	ntext		text to put on this button
	index		number index of this entry in menu
	last		is this the last element of the popup menu
	@Return:	a popup menu button
--]]
local function MakePopupButton(nparent, ntext, index, last: boolean?)
	local tobj = New "ImageButton" {
		Name = "ReportButton",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1 * index, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 7,
		New "TextLabel" {
			Name = "ButtonText",
			BackgroundTransparency = 1,
			Position = UDim2.new(0.07, 0, 0.07, 0),
			Size = UDim2.new(0.86, 0, 0.86, 0),
			Parent = HeaderFrame,
			Font = "ArialBold",
			Text = ntext,
			FontSize = "Size14",
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 1,
			ZIndex = 7,
		},
		Parent = nparent,
	}
	if index == 0 then
		tobj.Image = "http://banland.xyz/asset?id=97108784"
	elseif last then
		tobj.Image = index % 2 == 1
				and "http://banland.xyz/asset?id=" .. Images.LightPopupBottom
			or "http://banland.xyz/asset?id=" .. Images.DarkPopupBottom
	else
		tobj.Image = index % 2 == 1 and "http://banland.xyz/asset?id=97112126"
			or "http://banland.xyz/asset?id=97109338"
	end
	return tobj
end

--[[
	prepares the needed popup to be tweened on screen, and updates the position of the popup clip
	frame to match the selected player frame's position
--]]
local function InitMovingPanel(entry, player)
	PopUpClipFrame.Parent = ScreenGui

	if PopUpPanel then
		PopUpPanel:Destroy()
	end
	PopUpPanel = Hydrate(PopUpPanelTemplate:Clone()) {
		Parent = PopUpClipFrame,
	}

	local nextIndex = 2
	local friendStatus = GetFriendStatus(player)
	log(tostring(friendStatus))
	local showRankMenu = false
	-- IsPersonalServer
	-- and LocalPlayer.PersonalServerRank >= PrivilegeLevel.Admin
	-- and LocalPlayer.PersonalServerRank
	-- 	> SelectedPlayer.PersonalServerRank

	local ReportPlayerButton = MakePopupButton(PopUpPanel, "Report Player", 0)
	ReportPlayerButton.MouseButton1Click:connect(function()
		OpenAbuseDialog()
	end)
	local FriendPlayerButton = MakePopupButton(
		PopUpPanel,
		"Friend",
		1,
		-- not showRankMenu and
		friendStatus ~= Enum.FriendStatus.FriendRequestReceived
	)
	FriendPlayerButton.MouseButton1Click:connect(OnFriendButtonSelect)

	if friendStatus == Enum.FriendStatus.Friend then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "UnFriend Player"
	elseif
		friendStatus == Enum.FriendStatus.Unknown
		or friendStatus == Enum.FriendStatus.NotFriend
	then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "Send Request"
	elseif friendStatus == Enum.FriendStatus.FriendRequestSent then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "Revoke Request"
	elseif friendStatus == Enum.FriendStatus.FriendRequestReceived then
		FriendPlayerButton:FindFirstChild("ButtonText").Text = "Accept Friend"
		local FriendRefuseButton =
			MakePopupButton(PopUpPanel, "Decline Friend", 2, not showRankMenu)
		FriendRefuseButton.MouseButton1Click:connect(OnFriendRefuseButtonSelect)
		nextIndex += 1
	end

	if showRankMenu then
		local BanPlayerButton = MakePopupButton(PopUpPanel, "Ban", nextIndex)
		local VisitorButton =
			MakePopupButton(PopUpPanel, "Visitor", nextIndex + 1)
		local MemberButton =
			MakePopupButton(PopUpPanel, "Member", nextIndex + 2)
		local AdminButton =
			MakePopupButton(PopUpPanel, "Admin", nextIndex + 3, true)

		BanPlayerButton.MouseButton1Click:connect(function()
			OnPrivilegeLevelSelect(
				player,
				PrivilegeLevel.Banned,
				BanPlayerButton,
				VisitorButton,
				MemberButton,
				AdminButton
			)
		end)
		VisitorButton.MouseButton1Click:connect(function()
			OnPrivilegeLevelSelect(
				player,
				PrivilegeLevel.Visitor,
				BanPlayerButton,
				VisitorButton,
				MemberButton,
				AdminButton
			)
		end)
		MemberButton.MouseButton1Click:connect(function()
			OnPrivilegeLevelSelect(
				player,
				PrivilegeLevel.Member,
				BanPlayerButton,
				VisitorButton,
				MemberButton,
				AdminButton
			)
		end)
		AdminButton.MouseButton1Click:connect(function()
			OnPrivilegeLevelSelect(
				player,
				PrivilegeLevel.Admin,
				BanPlayerButton,
				VisitorButton,
				MemberButton,
				AdminButton
			)
		end)

		HighlightMyRank(
			SelectedPlayer,
			BanPlayerButton,
			VisitorButton,
			MemberButton,
			AdminButton
		)
	end

	PopUpPanel:TweenPosition(
		UDim2.new(0, 0, 0, 0),
		"Out",
		"Linear",
		BASE_TWEEN,
		true
	)
	Delay(0, function()
		local tconnection
		tconnection = Mouse.Button1Down:connect(function()
			tconnection:disconnect()
			ClosePopUpPanel()
		end)
	end)

	local myFrame = entry.Frame
	-- THIS IS GARBAGE.
	-- if I parent to frame to auto update position, it gets clipped
	-- sometimes garbage is the only option.
	Spawn(function()
		while InPopupWaitForClick do
			PopUpClipFrame.Position = UDim2.new(
				0,
				myFrame.AbsolutePosition.X - PopUpClipFrame.Size.X.Offset,
				0,
				myFrame.AbsolutePosition.Y
			)
			RunService.Heartbeat:wait()
		end
	end)
end

local function ActivatePlayerEntryPanel(entry)
	entry.Frame.BackgroundColor3 = Color3.new(0, 1, 1)
	Spawn(function()
		TweenProperty(entry.Frame, "BackgroundTransparency", 1, 0.5, 0.5)
	end)
	InPopupWaitForClick = true
	InitMovingPanel(entry, entry.Player)
end

--[[
	WARNING:this is in a working state, but uses massive hacks
	revize when global input is available
	Manages scrolling of the playerlist on mouse drag
--]]
local function StartDrag(entry, startx, starty)
	local openPanel = true
	--[[local draggedFrame = ]]
	WaitForChild(entry.Frame, "ClickListener")
	local function dragExit()
		-- stopDrag = true
		if
			entry.Player
			and SelectedPlayer
			and openPanel
			and entry.Player ~= LocalPlayer
			and SelectedPlayer.userId > 1
			and LocalPlayer.userId > 1
		then
			ActivatePlayerEntryPanel(entry)
		end
	end
	local startY
	local StartFrame = ListFrame.Position
	local function dragpoll(nx, ny)
		if not startY then
			startY = AbsoluteToPercent(nx, ny).Y
		end
		local nowY = AbsoluteToPercent(nx, ny).Y
		log(`drag dist {Vector2.new(startx - nx, starty - ny).magnitude}`)
		if
			Vector2.new(startx - nx, starty - ny).magnitude
			> MOUSE_DRAG_DISTANCE
		then
			openPanel = false
		end

		local newFrameY = math.max(
			math.min(StartFrame.Y.Scale + (nowY - startY), GetMaxScroll()),
			GetMinScroll()
		)
		ListFrame.Position = UDim2.new(
			StartFrame.X.Scale,
			StartFrame.X.Offset,
			newFrameY,
			StartFrame.Y.Offset
		)
		UpdateScrollPosition()
	end
	WaitForClick(ScreenGui, dragpoll, dragExit)
end

local function StartMinimizeDrag()
	Delay(0, function()
		local startTime = tick()
		log "Got Click2"
		local function dragExit()
			-- log "undone click2"
			if tick() - startTime < 0.25 then --was click
				ToggleMinimize()
			else --was drag
				DidMinimizeDrag = true
				if IsMinimized.Value then
					ToggleMinimize()
				end
			end
			-- stopDrag = true
		end
		local startY
		local StartFrame = DefaultBottomClipPos
		local function dragpoll(nx, ny)
			if not IsMinimized.Value then
				if not startY then
					startY = AbsoluteToPercent(nx, ny).Y
				end
				local nowY = AbsoluteToPercent(nx, ny).Y
				local newFrameY
				newFrameY = math.min(
					math.max(StartFrame + (nowY - startY), -1),
					-1
						+ (
							#MiddleFrameBackgrounds
							* MiddleBGTemplate.Size.Y.Scale
						)
				)
				DefaultBottomClipPos = newFrameY
				UpdateMinimize()
				ScrollBarFrame.Size = UDim2.new(
					ScrollBarFrame.Size.X.Scale,
					0,
					(DefaultBottomClipPos + BottomClipFrame.Size.Y.Scale),
					0
				)
				ScrollBarFrame.Position = UDim2.new(
					ScrollBarFrame.Position.X.Scale,
					0,
					1 - ScrollBarFrame.Size.Y.Scale,
					0
				)
				UpdateScrollBarSize()
				UpdateScrollPosition()
				UpdateScrollBarVisibility()
			end
		end
		Spawn(function()
			WaitForClick(ScreenGui, dragpoll, dragExit)
		end)
	end)
end

-------------------------------
-- Input Callback functions
-------------------------------
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
		UnTabify()
	else
		StartMinimizeDrag()
	end
end)

MaximizeButton.MouseButton1Click:connect(function()
	if (time() - LastClick < ButtonCooldown) or InPopupWaitForClick then
		return
	end
	LastClick = time()
	if IsTabified.Value then
		UnTabify()
	elseif not AreNamesExpanded.Value then
		AreNamesExpanded.Value = true
		BaseUpdate()
	else
		ToggleMaximize()
	end
end)

MaximizeButton.MouseButton2Click:connect(function()
	if (time() - LastClick < ButtonCooldown) or InPopupWaitForClick then
		return
	end
	LastClick = time()
	if IsTabified.Value then
		UnTabify()
	elseif IsMaximized.Value then
		ToggleMaximize()
	elseif AreNamesExpanded.Value then
		AreNamesExpanded.Value = false
		BaseUpdate()
	else
		Tabify()
	end
end)

-------------------------------
-- MiddleFrames management
-------------------------------
--[[
	adds a background frame to the listframe
--]]
local function AddMiddleBGFrame()
	local nBGFrame = MiddleBGTemplate:Clone()
	nBGFrame.Position =
		UDim2.new(0.5, 0, (#MiddleFrameBackgrounds * nBGFrame.Size.Y.Scale), 0)

	local function applyImage(id: string)
		nBGFrame.Background.Image = "http://banland.xyz/asset?id=" .. id
	end

	if (#MiddleFrameBackgrounds + 1) % 2 ~= 1 then
		if IsMaximized.Value then
			applyImage(Images.LargeDark)
		else
			applyImage(Images.midDark)
		end
	elseif IsMaximized.Value then
		applyImage(Images.LargeLight)
	else
		applyImage(Images.midLight)
	end

	nBGFrame.Parent = ListFrame
	table.insert(MiddleFrameBackgrounds, nBGFrame)

	if
		#MiddleFrameBackgrounds --[[DefaultListSize]]
			< 12
		and not DidMinimizeDrag
	then
		-- print "readjusting bottom clip"
		DefaultBottomClipPos = -1
			+ (#MiddleFrameBackgrounds * MiddleBGTemplate.Size.Y.Scale)
	end

	if not IsMinimized.Value then
		UpdateMinimize()
	end
end
--[[
	removes a background from from the listframe
--]]
local function RemoveMiddleBGFrame()
	MiddleFrameBackgrounds[#MiddleFrameBackgrounds]:Destroy()
	table.remove(MiddleFrameBackgrounds, #MiddleFrameBackgrounds)
	if not IsMinimized.Value then
		UpdateMinimize()
	end
end
-------------------------------
-- Player Callback functions
-------------------------------

--[[
	note:should probably set to something other than mainFrame.AbsoluteSize, should work for now
	if textbounds ever works on textscaled, switch to that :(
--]]
local function ChangeHeaderName(nname)
	HeaderName.Text = nname
	UpdateHeaderNameSize()
end

--[[
	called only when the leaderstats object is added to a given player entry
	removes old stats, adds any existing stats, and sets up listeners for new stats
	@Args:
	playerEntry		A reference to the ENTRY(table) of the player who had leaderstats added
--]]
local function LeaderstatsAdded(playerEntry)
	--RemoveAllStats(playerEntry)
	local nplayer = playerEntry.Player
	for _, i in pairs(nplayer.leaderstats:GetChildren()) do
		StatAdded(i, playerEntry)
	end
	nplayer.leaderstats.ChildAdded:connect(function(nchild)
		StatAdded(nchild, playerEntry)
	end)
	nplayer.leaderstats.ChildRemoved:connect(function(nchild)
		StatRemoved(nchild, playerEntry)
	end)
end
--[[
	called when leaderstats object is removed from play in player entry
	Note: may not be needed, might be able to just rely on leaderstats added
	@Args:
	oldLeaderstats	leaderstats object to be removed
	playerEntry		A reference to the ENTRY(table) of the player
--]]
local function LeaderstatsRemoved(_, playerEntry)
	while AddingFrameLock do
		log(`waiting to insert {playerEntry.Player.Name}`)
		RunService.Heartbeat:wait()
	end
	AddingFrameLock = true
	RemoveAllStats(playerEntry)
	AddingFrameLock = false
end

--[[
	Called when a player entry in the leaderboard is clicked
	either will highlight entry and start the drag event, or open a popup menu
	@Args:
	entry	the player entry clicked
--]]
local function OnPlayerEntrySelect(entry, startx, starty)
	if not InPopupWaitForClick then
		SelectedPlayerEntry = entry
		SelectedPlayer = entry.Player

		StartDrag(entry, startx, starty)
	end
end

local function RemoveNeutralTeam()
	while NeutralTeamLock do
		log "in neutral team lock"
		RunService.Heartbeat:wait()
	end
	NeutralTeamLock = true
	NeutralTeam.Frame:Destroy()
	NeutralTeam = nil
	RemoveMiddleBGFrame()
	NeutralTeamLock = false
end

--[[
	removes a single player from a given team (not usually called directly)
	@Args:
	teamEntry		team entry to remove player from
	index			index of player in 'MyPlayers' list to remove
--]]
local function RemovePlayerFromTeam(teamEntry, index)
	table.remove(teamEntry.MyPlayers, index)
	--if teamEntry.AutoHide and #teamEntry.MyPlayers == 0 then
	if teamEntry == NeutralTeam and #teamEntry.MyPlayers == 0 then
		RemoveNeutralTeam()
	end
end

--[[
	finds previous team this player was on, and if it exists calls removeplayerfromteam
	@Args
	entry	Player entry
--]]
local function FindRemovePlayerFromTeam(entry)
	if entry.MyTeam then
		for j, oldEntry in ipairs(entry.MyTeam.MyPlayers) do
			if oldEntry.Player == entry.Player then
				RemovePlayerFromTeam(entry.MyTeam, j)
				return
			end
		end
	elseif NeutralTeam then
		for j, oldEntry in ipairs(NeutralTeam.MyPlayers) do
			if oldEntry.Player == entry.Player then
				RemovePlayerFromTeam(NeutralTeam, j)
				return
			end
		end
	end
end

--[[
	adds player entry entry to teamentry
	removes them from any previous team
	@Args:
	teamEntry		entry of team to add player to
	entry			player entry to add to this team
--]]
local function AddPlayerToTeam(teamEntry, entry)
	FindRemovePlayerFromTeam(entry)
	table.insert(teamEntry.MyPlayers, entry)
	entry.MyTeam = teamEntry
	if teamEntry.IsHidden then
		teamEntry.Frame.Parent = ListFrame
		AddMiddleBGFrame()
	end
	teamEntry.IsHidden = false
end

--[[
	adds a neutral team if nessisary
	Note: a lot of redundant code here, might want to refactor to share a function with insertteamframe
--]]
local function AddNeutralTeam()
	while NeutralTeamLock do
		log "in neutral team 2 lock"
		RunService.Heartbeat:wait()
	end
	NeutralTeamLock = true

	local defaultTeam = New "Team" {
		TeamColor = BrickColor.new "White",
		Name = "Neutral",
	}
	local nentry = {
		MyTeam = defaultTeam,
		MyPlayers = {},
		Frame = MiddleTemplate:Clone(),
	}
	WaitForChild(WaitForChild(nentry.Frame, "TitleFrame"), "Title").Text =
		defaultTeam.Name
	nentry.Frame.TitleFrame.Position = UDim2.new(
		nentry.Frame.TitleFrame.Position.X.Scale,
		nentry.Frame.TitleFrame.Position.X.Offset,
		0.1,
		0
	)
	nentry.Frame.TitleFrame.Size = UDim2.new(
		nentry.Frame.TitleFrame.Size.X.Scale,
		nentry.Frame.TitleFrame.Size.X.Offset,
		0.8,
		0
	)
	nentry.Frame.TitleFrame.Title.Font = "ArialBold"
	nentry.Frame.Position =
		UDim2.new(1, 0, (#MiddleFrames * nentry.Frame.Size.Y.Scale), 0)
	WaitForChild(nentry.Frame, "ClickListener").MouseButton1Down:connect(
		function(nx, ny)
			StartDrag(nentry, nx, ny)
		end
	)
	nentry.Frame.ClickListener.BackgroundColor3 = Color3.new(1, 1, 1)
	nentry.Frame.ClickListener.BackgroundTransparency = 0.7
	nentry.Frame.ClickListener.AutoButtonColor = false
	nentry.AutoHide = true
	nentry.IsHidden = true
	for _, i in pairs(PlayerFrames) do
		if i.Player.Neutral or not i.MyTeam then
			AddPlayerToTeam(nentry, i)
		end
	end
	if #nentry.MyPlayers > 0 then
		NeutralTeam = nentry
		UpdateMinimize()
		BaseUpdate()
	end
	NeutralTeamLock = false
end

local function SetPlayerToTeam(entry)
	FindRemovePlayerFromTeam(entry)
	-- check to see if team exists, if it does add to that team
	local setToTeam = false
	for _, tframe in ipairs(TeamFrames) do
		-- add my entry on the new team
		if tframe.MyTeam.TeamColor == entry.Player.TeamColor then
			AddPlayerToTeam(tframe, entry)
			setToTeam = true
		end
	end
	-- if player was set to an invalid team, then set it back to neutral
	if not setToTeam and #(game.Teams:GetTeams()) > 0 then
		log(`{entry.Player.Name} could not find team`)
		entry.MyTeam = nil
		if not NeutralTeam then
			AddNeutralTeam()
		else
			AddPlayerToTeam(NeutralTeam, entry)
		end
	end
end

--[[
	Note:another big one, consiter breaking up
	called when any children of player changes
	handles 'Neutral', teamColor, Name and MembershipType changes
	@Args
	entry		Player entry changed
	property	name of property changed
--]]
local function PlayerChanged(entry, property)
	while PlayerChangedLock do
		log "in playerchanged lock"
		RunService.Heartbeat:wait()
	end
	PlayerChangedLock = true
	if property == "Neutral" then
		-- if player changing to neutral
		if entry.Player.Neutral and #(game.Teams:GetTeams()) > 0 then
			log(entry.Player.Name .. " setting to neutral")
			FindRemovePlayerFromTeam(entry)
			entry.MyTeam = nil
			if not NeutralTeam then
				log(entry.Player.Name .. " creating neutral team")
				AddNeutralTeam()
			else
				log(entry.Player.Name .. " adding to neutral team")
				AddPlayerToTeam(NeutralTeam, entry)
			end
		elseif #(game.Teams:GetTeams()) > 0 then -- else player switching to a team, or a weird edgecase
			log(entry.Player.Name .. " has been set non-neutral")
			SetPlayerToTeam(entry)
		end
		BaseUpdate()
	elseif
		property == "TeamColor"
		and not entry.Player.Neutral
		and entry.Player ~= entry.MyTeam
	then
		log(entry.Player.Name .. " setting to new team")
		SetPlayerToTeam(entry)
		BaseUpdate()
	elseif property == "Name" or property == "MembershipType" then
		entry.Frame:FindFirstChild("BCLabel").Image = getMembershipTypeIcon(
			entry.Player.MembershipType,
			entry.Player.Name
		)
		entry.Frame.Name = entry.Player.Name
		entry.Frame.TitleFrame.Title.Text = entry.Player.Name
		if entry.Frame.BCLabel.Image ~= "" then
			entry.Frame.TitleFrame.Title.Position = UDim2.new(0.01, 30, 0.1, 0)
		end
		if entry.Player == LocalPlayer then
			entry.Frame.TitleFrame.DropShadow.Text = entry.Player.Name
			ChangeHeaderName(entry.Player.Name)
		end
		BaseUpdate()
	end
	PlayerChangedLock = false
end

--[[
	this one's a doozie, happens when a player is added to the game
	inits their player frame and player entry, assigns them to a team if possible,
	and hooks up their leaderstats
	@Args:
	nplayer		new player object to insert
--]]
local function InsertPlayerFrame(nplayer)
	while AddingFrameLock do
		log("waiting to insert " .. nplayer.Name)
		RunService.Heartbeat:wait()
	end
	AddingFrameLock = true

	local nFrame = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nFrame, "TitleFrame"), "Title").Text =
		nplayer.Name

	nFrame.Position = UDim2.new(1, 0, (#MiddleFrames * nFrame.Size.Y.Scale), 0)

	local nfriendstatus = GetFriendStatus(nplayer)

	nFrame:FindFirstChild("BCLabel").Image =
		getMembershipTypeIcon(nplayer.MembershipType, nplayer.Name)
	nFrame:FindFirstChild("FriendLabel").Image =
		getFriendStatusIcon(nfriendstatus)
	nFrame.Name = nplayer.Name
	WaitForChild(WaitForChild(nFrame, "TitleFrame"), "Title").Text =
		nplayer.Name

	--move for bc label
	nFrame.FriendLabel.Position = nFrame.FriendLabel.Position
		+ UDim2.new(0, 17, 0, 0)
	nFrame.TitleFrame.Title.Position = nFrame.TitleFrame.Title.Position
		+ UDim2.new(0, 17, 0, 0)

	if nFrame:FindFirstChild("FriendLabel").Image ~= "" then
		nFrame.TitleFrame.Title.Position = nFrame.TitleFrame.Title.Position
			+ UDim2.new(0, 17, 0, 0)
	end

	if nplayer.Name == LocalPlayer.Name then
		nFrame.TitleFrame.Title.Font = "ArialBold"
		nFrame.PlayerScore.Font = "ArialBold"
		ChangeHeaderName(nplayer.Name)
		local dropShadow = nFrame.TitleFrame.Title:Clone()
		dropShadow.TextColor3 = Color3.new(0, 0, 0)
		dropShadow.TextTransparency = 0
		dropShadow.ZIndex = 2
		dropShadow.Position = nFrame.TitleFrame.Title.Position
			+ UDim2.new(0, 1, 0, 1)
		dropShadow.Name = "DropShadow"
		dropShadow.Parent = nFrame.TitleFrame
		-- else
		-- 	--Delay(2, function () OnFriendshipChanged(nplayer,LocalPlayer:GetFriendStatus(nplayer)) end)
	end
	nFrame.TitleFrame.Title.Font = "ArialBold"

	nFrame.Parent = ListFrame
	nFrame:TweenPosition(
		UDim2.new(0.5, 0, (#MiddleFrames * nFrame.Size.Y.Scale), 0),
		"Out",
		"Linear",
		BASE_TWEEN,
		true
	)
	UpdateMinimize()
	local nentry = {
		Frame = nFrame,
		Player = nplayer,
		ID = AddId,
	}
	AddId += 1
	table.insert(PlayerFrames, nentry)
	if #TeamFrames ~= 0 then
		if nplayer.Neutral then
			nentry.MyTeam = nil
			if not NeutralTeam then
				AddNeutralTeam()
			else
				AddPlayerToTeam(NeutralTeam, nentry)
			end
		else
			local addedToTeam = false
			for _, tval in ipairs(TeamFrames) do
				if tval.MyTeam.TeamColor == nplayer.TeamColor then
					AddPlayerToTeam(tval, nentry)
					nentry.MyTeam = tval
					addedToTeam = true
				end
			end
			if not addedToTeam then
				nentry.MyTeam = nil
				if not NeutralTeam then
					AddNeutralTeam()
				else
					AddPlayerToTeam(NeutralTeam, nentry)
				end
				nentry.MyTeam = NeutralTeam
			end
		end
	end

	if nplayer:FindFirstChild "leaderstats" then
		LeaderstatsAdded(nentry)
	end

	nplayer.ChildAdded:connect(function(nchild)
		if nchild.Name == "leaderstats" then
			while AddingFrameLock do
				log "in adding leaderstats lock"
				RunService.Heartbeat:wait()
			end
			AddingFrameLock = true
			LeaderstatsAdded(nentry)
			AddingFrameLock = false
		end
	end)

	nplayer.ChildRemoved:connect(function(nchild)
		if nplayer == LocalPlayer and nchild.Name == "leaderstats" then
			LeaderstatsRemoved(nchild, nentry)
		end
	end)
	nplayer.Changed:connect(function(prop)
		PlayerChanged(nentry, prop)
	end)

	local listener = WaitForChild(nFrame, "ClickListener")
	listener.Active = true
	listener.MouseButton1Down:connect(function(nx, ny)
		OnPlayerEntrySelect(nentry, nx, ny)
	end)

	AddMiddleBGFrame()
	BaseUpdate()
	AddingFrameLock = false
end

--[[
	Note:major optimization can be done here
	removes this player's frame if it exists, calls base update
--]]
local function RemovePlayerFrame(tplayer)
	while AddingFrameLock do
		log "in removing player frame lock"
		RunService.Heartbeat:wait()
	end
	AddingFrameLock = true

	local tteam
	for i, key in ipairs(PlayerFrames) do
		if tplayer == key.Player then
			if PopUpClipFrame.Parent == key.Frame then
				PopUpClipFrame.Parent = nil
			end
			key.Frame:Destroy()
			tteam = key.MyTeam
			table.remove(PlayerFrames, i)
		end
	end
	if tteam then
		for j, tentry in ipairs(tteam.MyPlayers) do
			if tentry.Player == tplayer then
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

----------------------------
-- Team Callback Functions
----------------------------

local function OnFriendshipChanged(player, friendStatus)
	Delay(0.5, function()
		log(
			`friend status changed for {player.Name} {friendStatus} vs {GetFriendStatus(
				player
			)}`
		)
		for _, entry in ipairs(PlayerFrames) do
			if entry.Player == player then
				local nicon = getFriendStatusIcon(friendStatus)
				if nicon == "" and entry.Frame.FriendLabel.Image ~= "" then
					entry.Frame.TitleFrame.Title.Position = entry.Frame.TitleFrame.Title.Position
						- UDim2.new(0, 17, 0, 0)
				elseif nicon ~= "" and entry.Frame.FriendLabel.Image == "" then
					entry.Frame.TitleFrame.Title.Position = entry.Frame.TitleFrame.Title.Position
						+ UDim2.new(0, 17, 0, 0)
					log("confirmed status " .. player.Name)
				end
				entry.Frame.FriendLabel.Image = nicon
				return
			end
		end
	end)
end

LocalPlayer.FriendStatusChanged:connect(OnFriendshipChanged)

local function TeamScoreChanged(entry, nscore)
	WaitForChild(entry.Frame, "PlayerScore").Text = tostring(nscore)
	entry.TeamScore = nscore
end

--[[
	called when child added to a team, used for autohide functionality
	Note: still has teamscore, consiter removing
--]]
local function TeamChildAdded(entry, nchild)
	if nchild.Name == "AutoHide" then
		entry.AutoHide = true
	elseif nchild.Name == "TeamScore" then
		WaitForChild(entry.Frame, "PlayerScore").Text = tostring(nchild.Value)
		entry.TeamScore = nchild.Value
		nchild.Changed:connect(function()
			TeamScoreChanged(entry, nchild.Value)
		end)
	end
end
--[[
	called when child added to a team, used for autohide functionality
	Note: still has teamscore, consiter removing
--]]
local function TeamChildRemoved(entry, nchild)
	if nchild.Name == "AutoHide" then
		entry.AutoHide = false
	elseif nchild.Name == "TeamScore" then
		WaitForChild(entry.Frame, "PlayerScore").Text = ""
		entry.TeamScore = nil
	end
end

--[[
	removes team from team list
	@Args:
	nteam		Teamobject to remove
--]]
local function RemoveTeamFrame(nteam)
	while AddingFrameLock do
		log "in removing team frame lock"
		RunService.Heartbeat:wait()
	end
	AddingFrameLock = true
	-- if IsMinimized.Value then
	-- end
	local myEntry
	for i, key in ipairs(TeamFrames) do
		if nteam == key.MyTeam then
			myEntry = key
			key.Frame:Destroy()
			table.remove(TeamFrames, i)
		end
	end
	if #TeamFrames == 0 then
		log "removeteamframe, remove neutral"
		if NeutralTeam then
			RemoveNeutralTeam()
		end
	end
	for i, key in ipairs(myEntry.MyPlayers) do
		RemovePlayerFromTeam(myEntry, i)
		PlayerChanged(key, "TeamColor")
	end
	RemoveMiddleBGFrame()
	BaseUpdate()
	AddingFrameLock = false
end

local function TeamChanged(entry, property)
	if property == "Name" then
		WaitForChild(WaitForChild(entry.Frame, "TitleFrame"), "Title").Text =
			entry.MyTeam.Name
	elseif property == "TeamColor" then
		entry.Frame.ClickListener.BackgroundColor3 =
			entry.MyTeam.TeamColor.Color

		for _, i in pairs(TeamFrames) do
			if i.MyTeam.TeamColor == entry.MyTeam then
				RemoveTeamFrame(entry.MyTeam) --NO DUPLICATE TEAMS!
			end
		end

		entry.MyPlayers = {}

		for _, i in pairs(PlayerFrames) do
			SetPlayerToTeam(i)
		end
		BaseUpdate()
	end
end

--[[
	creates team entry and frame for this team, sets up listeners for this team
	adds any players intended for this team,Creates neutral team if this is the first team added
	Note:might be best to break this into multiple functions to simplify
	@Args:
	nteam	new team object added
--]]
local function InsertTeamFrame(nteam)
	while AddingFrameLock do
		log "in adding team frame lock"
		RunService.Heartbeat:wait()
	end
	AddingFrameLock = true
	--for _,i in pairs(TeamFrames) do
	local nentry = {}
	nentry.MyTeam = nteam
	nentry.MyPlayers = {}
	nentry.Frame = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nentry.Frame, "TitleFrame"), "Title").Text =
		nteam.Name
	nentry.Frame.TitleFrame.Title.Font = "ArialBold"
	nentry.Frame.TitleFrame.Title.FontSize = "Size18"
	nentry.Frame.TitleFrame.Position = UDim2.new(
		nentry.Frame.TitleFrame.Position.X.Scale,
		nentry.Frame.TitleFrame.Position.X.Offset,
		0.1,
		0
	)
	nentry.Frame.TitleFrame.Size = UDim2.new(
		nentry.Frame.TitleFrame.Size.X.Scale,
		nentry.Frame.TitleFrame.Size.X.Offset,
		0.8,
		0
	)
	nentry.Frame.Position =
		UDim2.new(1, 0, (#MiddleFrames * nentry.Frame.Size.Y.Scale), 0)
	WaitForChild(nentry.Frame, "ClickListener").MouseButton1Down:connect(
		function(nx, ny)
			StartDrag(nentry, nx, ny)
		end
	)
	nentry.Frame.ClickListener.BackgroundColor3 = nteam.TeamColor.Color
	nentry.Frame.ClickListener.BackgroundTransparency = 0.7
	nentry.Frame.ClickListener.AutoButtonColor = false
	AddId += 1
	nentry.ID = AddId
	nentry.AutoHide = false
	if nteam:FindFirstChild "AutoHide" then
		nentry.AutoHide = true
	end
	if nteam:FindFirstChild "TeamScore" then
		TeamChildAdded(nentry, nteam.TeamScore)
	end

	nteam.ChildAdded:connect(function(nchild)
		TeamChildAdded(nentry, nchild)
	end)
	nteam.ChildRemoved:connect(function(nchild)
		TeamChildRemoved(nentry, nchild)
	end)
	nteam.Changed:connect(function(prop)
		TeamChanged(nentry, prop)
	end)

	for _, i in pairs(PlayerFrames) do
		if not i.Player.Neutral and i.Player.TeamColor == nteam.TeamColor then
			AddPlayerToTeam(nentry, i)
		end
	end
	nentry.IsHidden = false
	if not nentry.AutoHide or #nentry.MyPlayers > 0 then
		nentry.Frame.Parent = ListFrame
		nentry.Frame:TweenPosition(
			UDim2.new(0.5, 0, (#MiddleFrames * nentry.Frame.Size.Y.Scale), 0),
			"Out",
			"Linear",
			BASE_TWEEN,
			true
		)
		AddMiddleBGFrame()
	else
		nentry.IsHidden = true
		nentry.Frame.Parent = nil
	end

	table.insert(TeamFrames, nentry)
	UpdateMinimize()
	BaseUpdate()
	if #TeamFrames == 1 and not NeutralTeam then
		AddNeutralTeam()
	end
	AddingFrameLock = false
end

local function TeamAdded(nteam)
	InsertTeamFrame(nteam)
end

local function TeamRemoved(nteam)
	RemoveTeamFrame(nteam)
end
---------------------------------

--[[
	code for attaching tab key to maximizing player list
--]]
game.GuiService:AddKey "\t"
local LastTabTime = time()
game.GuiService.KeyPressed:connect(function(key)
	if key == "\t" then
		log "caught tab key"
		local modalCheck, isModal = pcall(function()
			return game.GuiService.IsModalDialog
		end)
		if modalCheck == false or (modalCheck and isModal == false) then
			if time() - LastTabTime > 0.4 then
				LastTabTime = time()
				if IsTabified.Value then
					if not IsMaximized.Value then
						ScreenGui:TweenPosition(
							UDim2.new(0, 0, 0, 0),
							"Out",
							"Linear",
							BASE_TWEEN * 1.2,
							true
						)
						IsMaximized.Value = true
					else
						ScreenGui:TweenPosition(
							UDim2.new(
								NormalBounds.X.Scale,
								NormalBounds.X.Offset - 10,
								0,
								0
							),
							"Out",
							"Linear",
							BASE_TWEEN * 1.2,
							true
						)
						IsMaximized.Value = false
						IsMinimized.Value = true
					end
				else
					ToggleMaximize()
				end
			end
		end
	end
end)

local function debugPlayerAdd(p)
	InsertPlayerFrame(p)
end

local function coreGuiChanged(coreGuiType, enabled)
	if
		coreGuiType == Enum.CoreGuiType.All
		or coreGuiType == Enum.CoreGuiType.PlayerList
	then
		MainFrame.Visible = enabled
	end
end

pcall(function()
	coreGuiChanged(
		Enum.CoreGuiType.PlayerList,
		game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
	)
	game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)

while not game:GetService "Teams" do
	RunService.Heartbeat:wait()
	log "Waiting For Teams"
end
for _, i in pairs(game.Teams:GetTeams()) do
	TeamAdded(i)
end
for _, i in pairs(Players:GetPlayers()) do
	Spawn(function()
		debugPlayerAdd(i)
	end)
end

local function PlayersChildAdded(tplayer)
	if tplayer:IsA "Player" then
		Spawn(function()
			debugPlayerAdd(tplayer)
		end)
	else
		BlowThisPopsicleStand()
	end
end

local function TeamsChildAdded(nteam)
	if nteam:IsA "Team" then
		TeamAdded(nteam)
	else
		BlowThisPopsicleStand()
	end
end

local function TeamsChildRemoved(nteam)
	if nteam:IsA "Team" then
		TeamRemoved(nteam)
	else
		BlowThisPopsicleStand()
	end
end

----------------------------
-- Hookups and initialization
----------------------------

game.Teams.ChildAdded:connect(TeamsChildAdded)
game.Teams.ChildRemoved:connect(TeamsChildRemoved)
Players.ChildAdded:connect(PlayersChildAdded)

InitReportAbuse()
AreNamesExpanded.Value = true
BaseUpdate()

-- UGGGLY, find a better way later
-- wait(2)
-- IsPersonalServer = workspace:FindFirstChild "PSVariable"
