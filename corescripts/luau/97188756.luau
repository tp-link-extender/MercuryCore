--!strict
-- CoreGui.RobloxGui.CoreScripts/ChatScript
print "[Mercury]: Loaded corescript 97188756"

local RunService = game:GetService "RunService"

local SafeChat = require "../Modules/Safechat.yml" -- THANK YOU DARKLUA
local New = (require "../Modules/New").New

local forceChatGUI = false

-- Utility functions + Globals
local function WaitForChild(parent, childName)
	while parent:FindFirstChild(childName) == nil do
		parent.ChildAdded:wait(0.03)
	end
	return parent[childName]
end

while not Game.Players.LocalPlayer do
	RunService.Heartbeat:wait()
end

local Player = Game.Players.LocalPlayer
while not Player.Character do
	RunService.Heartbeat:wait()
end
local Camera = Game.Workspace.CurrentCamera

-- Services
local CoreGui = Game:GetService "CoreGui"
local Players = Game:GetService "Players"
local GuiService = Game:GetService "GuiService"

-- Lua Enums
local Enums = {}
local EnumName = {} -- used as unique key for enum name
local enum_mt = {
	__call = function(self, value)
		return self[value] or self[tonumber(value)]
	end,
	__index = {
		GetEnumItems = function(self)
			local t: { any } = {}
			for i, item in pairs(self) do
				if type(i) == "number" then
					t[#t + 1] = item
				end
			end
			table.sort(t, function(a, b)
				return a.Value < b.Value
			end)
			return t
		end,
	},
	__tostring = function(self)
		return `Enum.{self[EnumName]}`
	end,
}
local item_mt = {
	__call = function(self, value)
		return value == self or value == self.Name or value == self.Value
	end,
	__tostring = function(self)
		return `Enum.{self[EnumName]}.{self.Name}`
	end,
}
local function CreateEnum(enumName, t)
	local e = { [EnumName] = enumName }
	for i, name in pairs(t) do
		local item = setmetatable(
			{ Name = name, Value = i, Enum = e, [EnumName] = enumName },
			item_mt
		)
		e[i] = item
		e[name] = item
		e[item] = item
	end
	Enums[enumName] = e
	return setmetatable(e, enum_mt)
end
---------------------------------------------------
------------------ Input class --------------------
local Input = {
	Mouse = Player:GetMouse(),
	Speed = 0,

	Configuration = {
		DefaultSpeed = 1,
	},
	UserIsScrolling = false,
}

---------------------------------------------------
------------------ Chat class --------------------
local Chat = {
	ChatColors = {
		BrickColor.new "Bright red",
		BrickColor.new "Bright blue",
		BrickColor.new "Earth green",
		BrickColor.new "Bright violet",
		BrickColor.new "Bright orange",
		BrickColor.new "Bright yellow",
		BrickColor.new "Light reddish violet",
		BrickColor.new "Brick yellow",
	},

	Gui = nil,
	Frame = nil,
	RenderFrame = nil,
	TapToChatLabel = nil,
	ClickToChatButton = nil,

	ScrollingLock = false,
	EventListener = nil,

	-- This is actually a ring buffer
	-- Meaning at hitting the historyLength it wraps around
	-- Reuses the text objects, so chat atmost uses 100 text objects
	MessageQueue = {},

	-- Stores all the values for configuring chat
	Configuration = {
		FontSize = Enum.FontSize.Size12, -- 10 is good
		-- Also change this when you are changing the above, this is suboptimal but so is our interface to find FontSize
		NumFontSize = 12,
		HistoryLength = 20, -- stores up to 50 of the last chat messages for you to scroll through,
		Size = UDim2.new(0.38, 0, 0.20, 0),
		MessageColor = Color3.new(1, 1, 1),
		AdminMessageColor = Color3.new(1, 215 / 255, 0),
		XScale = 0.025,
		LifeTime = 45,
		Position = UDim2.new(0, 2, 0.35, 0),
		DefaultTweenSpeed = 0.15,
	},

	-- This could be redone by just using the previous and next fields of the Queue
	-- But the iterators cause issues, will be optimized later
	SlotPositions_List = {},
	-- To precompute and store all player null strings since its an expensive process
	CachedSpaceStrings_List = {},
	MouseOnFrame = false,
	GotFocus = false,

	Messages_List = {},
	MessageThread = nil,

	Admins_List = { "taskmanager", "Heliodex", "tako" },

	SafeChat_List = SafeChat,
	CreateEnum("SafeChat", { "Level1", "Level2", "Level3" }),
	SafeChatTree = {},
	TempSpaceLabel = nil,
}
---------------------------------------------------

local function GetNameValue(pName)
	local value = 0
	for index = 1, #pName do
		local cValue = string.byte(string.sub(pName, index, index))
		local reverseIndex = #pName - index + 1
		if #pName % 2 == 1 then
			reverseIndex -= 1
		end
		if reverseIndex % 4 >= 2 then
			cValue = -cValue
		end
		value += cValue
	end
	return value % 8
end

function Chat:ComputeChatColor(pName)
	return self.ChatColors[GetNameValue(pName) + 1].Color
end

-- This is context based scrolling
function Chat:EnableScrolling(toggle)
	-- Genius idea gone to fail, if we switch the camera type we can effectively lock the
	-- camera and do no click scrolling
	self.MouseOnFrame = false
	if self.RenderFrame then
		self.RenderFrame.MouseEnter:connect(function()
			local character = Player.Character
			local torso = WaitForChild(character, "Torso")
			local head = WaitForChild(character, "Head")
			if toggle then
				self.MouseOnFrame = true
				Camera.CameraType = "Scriptable"
				-- Get relative position of camera and keep to it
				Spawn(function()
					local currentRelativePos = Camera.CoordinateFrame.p
						- torso.Position
					while Chat.MouseOnFrame do
						Camera.CoordinateFrame = CFrame.new(
							torso.Position + currentRelativePos,
							head.Position
						)
						wait(0.015)
					end
				end)
			end
		end)

		self.RenderFrame.MouseLeave:connect(function()
			Camera.CameraType = "Custom"
			self.MouseOnFrame = false
		end)
	end
end

-- TODO: Scrolling using Mouse wheel
-- function Chat:OnScroll(speed)
-- 	if self.MouseOnFrame then
-- 		--
-- 	end
-- end

-- Scrolling
function Chat:ScrollQueue(value)
	for i = 1, #self.MessageQueue do
		if self.MessageQueue[i] then
			for _, label in pairs(self.MessageQueue[i]) do
				local Next = self.MessageQueue[i + 1]
				local Previous = self.MessageQueue[i - 1]
				if
					label
					and type(label) == "userdata" -- until i figure out what's going on
					and (label:IsA "TextLabel" or label:IsA "TextButton")
				then
					print(
						"scrolling",
						value,
						"|",
						Previous,
						"|",
						Previous and Previous.message or "none",
						"|",
						Next,
						"|",
						Next and Next.message or "none"
					)
					-- if value > 0 and Previous and Previous.Message then
					-- 	-- label.Position = previous.Message.Position
					-- 	label.Position += UDim2.new(0, 0, 1, 0)
					-- elseif value < 1 and Next.Message then
					-- 	-- label.Position = previous.Message.Position
					-- 	label.Position -= UDim2.new(0, 0, 1, 0)
					-- end
				end
			end
		end
	end
end

-- Handles the rendering of the text objects in their appropriate places
function Chat:UpdateQueue(field, diff)
	print "Updating queue"
	-- Have to do some sort of correction here
	for i = #self.MessageQueue, 1, -1 do
		if self.MessageQueue[i] then
			for _, label in pairs(self.MessageQueue[i]) do
				if
					label
					and type(label) ~= "table"
					and type(label) ~= "number"
				then
					if label:IsA "TextLabel" or label:IsA "TextButton" then
						if diff then
							label.Position = label.Position
								- UDim2.new(0, 0, diff, 0)
						else
							if field == self.MessageQueue[i] then
								label.Position = UDim2.new(
									self.Configuration.XScale,
									0,
									label.Position.Y.Scale
										- field.Message.Size.Y.Scale,
									0
								)
								-- Just to show up popping effect for the latest message in chat
								Spawn(function()
									wait(0.05)
									while label.TextTransparency >= 0 do
										label.TextTransparency = label.TextTransparency
											- 0.2
										wait(0.03)
									end
									if label == field.Message then
										label.TextStrokeTransparency = 0.8
									else
										label.TextStrokeTransparency = 1
									end
								end)
							else
								label.Position = UDim2.new(
									self.Configuration.XScale,
									0,
									label.Position.Y.Scale
										- field.Message.Size.Y.Scale,
									0
								)
							end
							if label.Position.Y.Scale < -0.01 then
								-- NOTE: Remove this fix when Textbounds is fixed
								label.Visible = false
								label:Destroy()
							end
						end
					end
				end
			end
		end
	end
end

function Chat:CreateScrollBar()
	-- Code for scrolling is in here, partially, but scroll bar drawing isn't drawn
	-- TODO: Implement
end

-- For scrolling, to see if we hit the bounds so that we can stop it from scrolling anymore
function Chat:CheckIfInBounds(value)
	if #Chat.MessageQueue < 3 then
		return true
	end

	if
		value > 0
		and Chat.MessageQueue[1]
		and Chat.MessageQueue[1].Player
		and Chat.MessageQueue[1].Player.Position.Y.Scale == 0
	then
		return true
	elseif
		value < 0
		and Chat.MessageQueue[1]
		and Chat.MessageQueue[1].Player
		and Chat.MessageQueue[1].Player.Position.Y.Scale < 0
	then
		return true
	end
	return false
end

-- This is to precompute all playerName space strings
-- This is used to offset the message by exactly this + 2 spacestrings
function Chat:ComputeSpaceString(pLabel)
	local nString = " "
	if not self.TempSpaceLabel then
		self.TempSpaceLabel = New "TextButton" {
			Size = UDim2.new(
				0,
				pLabel.AbsoluteSize.X,
				0,
				pLabel.AbsoluteSize.Y
			),
			FontSize = self.Configuration.FontSize,
			Parent = self.RenderFrame,
			BackgroundTransparency = 1,
			Text = nString,
			Name = "SpaceButton",
		}
	else
		self.TempSpaceLabel.Text = nString
	end

	while self.TempSpaceLabel.TextBounds.X < pLabel.TextBounds.X do
		nString ..= " "
		self.TempSpaceLabel.Text = nString
	end
	nString ..= " "
	self.CachedSpaceStrings_List[pLabel.Text] = nString
	self.TempSpaceLabel.Text = ""
	return nString
end

-- When the playerChatted event fires
-- The message is what the player chatted
function Chat:UpdateChat(cPlayer, message)
	local messageField = {
		["Player"] = cPlayer,
		["Message"] = message,
	}
	if coroutine.status(Chat.MessageThread) == "dead" then
		--Chat.Messages_List = {}
		table.insert(Chat.Messages_List, messageField)
		Chat.MessageThread = coroutine.create(function()
			for i = 1, #Chat.Messages_List do
				local field = Chat.Messages_List[i]
				Chat:CreateMessage(field.Player, field.Message)
			end
			Chat.Messages_List = {}
		end)
		coroutine.resume(Chat.MessageThread)
	else
		table.insert(Chat.Messages_List, messageField)
	end
end

-- function Chat:RecalculateSpacing()
-- 	for i = 1, #self.MessageQueue do
-- 		local pLabel = self.MessageQueue[i].Player
-- 		local mLabel = self.MessageQueue[i].Message

-- 		local prevYScale = mLabel.Size.Y.Scale
-- 		local prevText = mLabel.Text
-- 		mLabel.Text = prevText

-- 		local heightField = mLabel.TextBounds.Y

-- 		mLabel.Size =
-- 			UDim2.new(1, 0, heightField / self.RenderFrame.AbsoluteSize.Y, 0)
-- 		pLabel.Size = mLabel.Size

-- 		local diff = mLabel.Size.Y.Scale - prevYScale

-- 		Chat:UpdateQueue(self.MessageQueue[i], diff)
-- 	end
-- end

-- NOTE: Temporarily disabled ring buffer to allow for chat to always wrap around
function Chat:CreateMessage(cPlayer, message)
	local pName
	if not cPlayer then
		pName = ""
	else
		pName = cPlayer.Name
	end
	-- Users can use enough white spaces to spoof chatting as other players
	-- This  removes trailing and leading white spaces
	-- AFAIK, there is no reason for spam white spaces
	-- %S is whitespaces
	-- When we find the first non space character defined by ^%s we yank out anything in between that and the end of the string
	-- Everything else is replaced with %1 which is essentially nothing
	message = string.gsub(message, "^%s*(.-)%s*$", "%1")
	local pLabel
	local mLabel
	-- Our history stores upto 50 messages that is 100 textlabels
	-- If we ever hit the mark, which would be in every popular game btw
	-- we wrap around and reuse the labels
	if #self.MessageQueue > self.Configuration.HistoryLength then
		-- pLabel = self.MessageQueue[#self.MessageQueue].Player
		-- mLabel = self.MessageQueue[#self.MessageQueue].Message

		-- pLabel.Text = `{pName}:`
		-- pLabel.Name = pName

		-- if cPlayer.Neutral then
		-- 	pLabel.TextColor3 = Chat:ComputeChatColor(pName)
		-- else
		-- 	pLabel.TextColor3 = cPlayer.TeamColor.Color
		-- end

		-- local nString

		-- if not self.CachedSpaceStrings_List[pName] then
		-- 	nString = Chat:ComputeSpaceString(pLabel)
		-- else
		-- 	nString = self.CachedSpaceStrings_List[pName]
		-- end

		-- mLabel.Text = ""
		-- mLabel.Name = `{pName} - message`
		-- mLabel.Text = nString .. message

		-- mLabel.Parent = nil
		-- mLabel.Parent = self.RenderFrame

		-- mLabel.Position = UDim2.new(0, 0, 1, 0)
		-- pLabel.Position = UDim2.new(0, 0, 1, 0)

		-- Reinserted at the beginning, ring buffer
		self.MessageQueue[#self.MessageQueue] = nil
	end
	--else
	-- Haven't hit the mark yet, so keep creating
	pLabel = New "TextLabel" {
		Name = pName,
		Text = `{pName}:`,
		-- TextColor3 = pColor,
		FontSize = Chat.Configuration.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = self.RenderFrame,
		TextWrapped = false,
		Size = UDim2.new(1, 0, 0.1, 0),
		BackgroundTransparency = 1,
		TextTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		TextStrokeColor3 = Color3.new(0.5, 0.5, 0.5),
		TextStrokeTransparency = 0.75,
		--Active = false;
	}
	if cPlayer.Neutral then
		pLabel.TextColor3 = Chat:ComputeChatColor(pName)
	else
		pLabel.TextColor3 = cPlayer.TeamColor.Color
	end

	local nString

	if not self.CachedSpaceStrings_List[pName] then
		nString = Chat:ComputeSpaceString(pLabel)
	else
		nString = self.CachedSpaceStrings_List[pName]
	end

	mLabel = New "TextLabel" {
		Name = `{pName} - message`,
		-- Max is 3 lines
		Size = UDim2.new(1, 0, 0.5, 0),
		TextColor3 = Chat.Configuration.MessageColor,
		FontSize = Chat.Configuration.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "", -- this is to stop when the engine reverts the swear words to default, which is button, ugh
		Parent = self.RenderFrame,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		TextStrokeColor3 = Color3.new(0, 0, 0),
		--TextStrokeTransparency = 0.8;
		--Active = false;
	}
	mLabel.Text = nString .. message

	if not pName then
		pLabel.Text = ""
		mLabel.TextColor3 = Color3.new(0, 0.4, 1.0)
	end
	--end

	for _, adminName in pairs(self.Admins_List) do
		if string.lower(adminName) == string.lower(pName) then
			mLabel.TextColor3 = self.Configuration.AdminMessageColor
		end
	end

	pLabel.Visible = true
	mLabel.Visible = true

	-- This will give beautiful multilines as well
	local heightField = mLabel.TextBounds.Y

	mLabel.Size =
		UDim2.new(1, 0, heightField / self.RenderFrame.AbsoluteSize.Y, 0)
	pLabel.Size = mLabel.Size

	local queueField = {
		Player = pLabel,
		Message = mLabel,
		SpawnTime = tick(), -- Used for identifying when to make the message invisible
	}

	table.insert(self.MessageQueue, 1, queueField)
	Chat:UpdateQueue(queueField)
end

function Chat:ScreenSizeChanged()
	RunService.Heartbeat:wait()
	while self.Frame.AbsoluteSize.Y > 120 do
		(self.Frame :: Frame).Size -= UDim2.new(0, 0, 0.005, 0)
	end
	-- Chat:RecalculateSpacing()
end

function Chat:FindButtonTree(scButton, rootList)
	local list = {}
	rootList = rootList or self.SafeChatTree
	for button, _ in pairs(rootList) do
		if button == scButton then
			list = rootList[button]
		elseif type(rootList[button]) == "table" then
			list = Chat:FindButtonTree(scButton, rootList[button])
		end
	end
	return list
end

function Chat:FocusOnChatBar()
	if self.ClickToChatButton then
		self.ClickToChatButton.Visible = false
	end

	self.GotFocus = true
	if self.Frame.Background then
		self.Frame.Background.Visible = false
	end
	self.ChatBar:CaptureFocus()
end

-- Non touch devices, create the bottom chat bar
function Chat:CreateChatBar()
	-- okay now we do
	local status, result = pcall(function()
		return GuiService.UseLuaChat
	end)
	if forceChatGUI or (status and result) then
		self.ClickToChatButton = New "TextButton" {
			Name = "ClickToChat",
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			ZIndex = 2.0,
			Parent = self.Gui,
			Text = 'To chat click here or press "/" key',
			TextColor3 = Color3.new(1, 1, 0.9),
			Position = UDim2.new(0, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			FontSize = Enum.FontSize.Size12,
		}

		self.ChatBar = New "TextBox" {
			Name = "ChatBar",
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.new(0, 0, 1, 0),
			Text = "",
			ZIndex = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.25,
			Parent = self.Gui,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.new(1, 1, 1),
			FontSize = Enum.FontSize.Size12,
			ClearTextOnFocus = false,
		}

		-- Engine has code to offset the entire world, so if we do it by -20 pixels nothing gets in our chat's way
		--GuiService:SetGlobalSizeOffsetPixel(0, -20)
		local success = pcall(function()
			GuiService:SetGlobalGuiInset(0, 0, 0, 20)
		end)
		if not success then
			GuiService:SetGlobalSizeOffsetPixel(0, -20)
		end
		-- ChatHotKey is '/'
		GuiService:AddSpecialKey(Enum.SpecialKey.ChatHotkey)
		GuiService.SpecialKeyPressed:connect(function(key)
			if key == Enum.SpecialKey.ChatHotkey then
				Chat:FocusOnChatBar()
			end
		end)

		self.ClickToChatButton.MouseButton1Click:connect(function()
			Chat:FocusOnChatBar()
		end)
	end
end

-- Create the initial Chat stuff
-- Done only once
function Chat:CreateGui()
	self.Gui = WaitForChild(CoreGui, "RobloxGui")
	self.Frame = New "Frame" {
		Name = "ChatFrame",
		--Size = self.Configuration.Size;
		Size = UDim2.new(0, 500, 0, 120),
		Position = UDim2.new(0, 0, 0, 5),
		BackgroundTransparency = 1,
		--ClipsDescendants = true;
		ZIndex = 0,
		Parent = self.Gui,
		Active = false,

		New "ImageLabel" {
			Name = "Background",
			Image = "http://banland.xyz/asset?id=97120937", --96551212';
			Size = UDim2.new(1.3, 0, 1.64, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			ZIndex = 0,
			Visible = false,
		},

		New "Frame" {
			Name = "Border",
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0.8, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(236 / 255, 236 / 255, 236 / 255),
			BorderSizePixel = 0,
			Visible = false,
		},

		New "Frame" {
			Name = "ChatRenderFrame",
			Size = UDim2.new(1.02, 0, 1.01, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			--ClipsDescendants = true;
			ZIndex = 0,
			Active = false,
		},
	}

	self.RenderFrame = self.Frame.ChatRenderFrame
	if self.Frame.AbsoluteSize.Y > 120 then
		Chat:ScreenSizeChanged()
		self.Gui.Changed:connect(function(property)
			if property == "AbsoluteSize" then
				Chat:ScreenSizeChanged()
			end
		end)
	end

	if forceChatGUI or Player.ChatMode == Enum.ChatMode.TextAndMenu then
		Chat:CreateChatBar()

		if self.ChatBar then
			self.ChatBar.FocusLost:connect(function(enterPressed)
				Chat.GotFocus = false
				if enterPressed and self.ChatBar.Text ~= "" then
					local cText = self.ChatBar.Text
					if string.sub(self.ChatBar.Text, 1, 1) == "%" then
						cText = "(TEAM) " .. string.sub(cText, 2, #cText)
						pcall(Players.TeamChat, Players, cText)
					else
						pcall(Players.Chat, Players, cText)
					end

					if self.ClickToChatButton then
						self.ClickToChatButton.Visible = true
					end
					self.ChatBar.Text = ""
				end
				Spawn(function()
					wait(5)
					if not Chat.GotFocus then
						Chat.Frame.Background.Visible = false
					end
				end)
			end)
		end
	end
end

-- Scrolling function
-- Applies a speed(velocity) to have nice scrolling effect
function Input:OnMouseScroll()
	Spawn(function()
		-- How long should the speed last?
		while Input.Speed ~= 0 do
			if Input.Speed > 1 then
				while Input.Speed > 0 do
					Input.Speed -= 1
					wait(0.25)
				end
			elseif Input.Speed < 0 then
				while Input.Speed < 0 do
					Input.Speed += 1
					wait(0.25)
				end
			end
			wait(0.03)
		end
	end)
	if Chat:CheckIfInBounds(Input.Speed) then
		return
	end
	Chat:ScrollQueue(Input.Speed)
end

function Input:ApplySpeed(value)
	Input.Speed += value
	Input:OnMouseScroll()
end

function Input:Initialize()
	self.Mouse.WheelBackward:connect(function()
		Input:ApplySpeed(self.Configuration.DefaultSpeed)
	end)

	self.Mouse.WheelForward:connect(function()
		Input:ApplySpeed(self.Configuration.DefaultSpeed)
	end)
end

function Chat:FindMessageInSafeChat(message, list)
	for msg, _ in pairs(list) do
		if
			msg == message
			or type(list[msg]) == "table"
				and Chat:FindMessageInSafeChat(message, list[msg])
		then
			return true
		end
	end
	return false
end

-- Just a wrapper around our PlayerChatted event
function Chat:PlayerChatted(...)
	local args = { ... }
	-- local argCount = select("#", ...)
	local player
	local message
	-- This doesn't look very good, but what else to do?
	if args[2] then
		player = args[2]
	end
	if args[3] then
		message = args[3]
		if string.sub(message, 1, 1) == "%" then
			message = "(TEAM) " .. string.sub(message, 2, #message)
		end
	end

	if
		Players.ClassicChat
			and (not (string.sub(message, 1, 3) == "/e " or string.sub(
				message,
				1,
				7
			) == "/emote ") and (forceChatGUI or Player.ChatMode == Enum.ChatMode.TextAndMenu) or (Player.ChatMode == Enum.ChatMode.Menu and string.sub(
				message,
				1,
				3
			) == "/sc"))
		or (Chat:FindMessageInSafeChat(message, self.SafeChat_List))
	then
		Chat:UpdateChat(player, message)
	end
end

-- After Chat.Configuration.Lifetime seconds of existence, the labels become invisible
-- Runs only every 5 seconds and has to loop through 50 values
-- Shouldn't be too expensive
function Chat:CullThread()
	while true do
		if #self.MessageQueue > 0 then
			for _, field in pairs(self.MessageQueue) do
				if
					field.SpawnTime
					and field.Player
					and field.Message
					and tick() - field.SpawnTime
						> self.Configuration.LifeTime
				then
					field.Player.Visible = false
					field.Message.Visible = false
				end
			end
		end
		wait(5)
	end
end

-- RobloxLock everything so users can't delete them(?)
function Chat:LockAllFields(gui)
	local children = gui:GetChildren()
	for i = 1, #children do
		children[i].RobloxLocked = true
		if #children[i]:GetChildren() > 0 then
			Chat:LockAllFields(children[i])
		end
	end
end

function Chat:CoreGuiChanged(coreGuiType, enabled)
	if
		coreGuiType == Enum.CoreGuiType.Chat
		or coreGuiType == Enum.CoreGuiType.All
	then
		if self.Frame then
			self.Frame.Visible = enabled
		end

		if self.ChatBar then
			self.ChatBar.Visible = enabled
			GuiService:SetGlobalGuiInset(0, 0, 0, enabled and 20 or 0)
		end
	end
end

-- Constructor
-- This function initializes everything
function Chat:Initialize()
	Chat:CreateGui()

	pcall(function()
		Chat:CoreGuiChanged(
			Enum.CoreGuiType.Chat,
			Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
		)
		Game.StarterGui.CoreGuiChangedSignal:connect(
			function(coreGuiType, enabled)
				Chat:CoreGuiChanged(coreGuiType, enabled)
			end
		)
	end)

	local function chatted(...)
		-- This event has 4 callback arguments
		-- Enum.PlayerChatType.All, chatPlayer, message, targetPlayer
		Chat:PlayerChatted(...)
	end

	self.EventListener = Players.PlayerChatted:connect(chatted)

	self.MessageThread = coroutine.create(function() end)
	coroutine.resume(self.MessageThread)

	-- Initialize input for us
	Input:Initialize()
	-- Eww, everytime a player is added, you have to redo the connection
	-- Seems this is not automatic
	-- NOTE: PlayerAdded only fires on the server, hence ChildAdded is used here
	Players.ChildAdded:connect(function()
		Chat.EventListener:disconnect()
		self.EventListener = Players.PlayerChatted:connect(chatted)
	end)

	Spawn(function()
		Chat:CullThread()
	end)

	self.Frame.RobloxLocked = true
	Chat:LockAllFields(self.Frame)
	self.Frame.DescendantAdded:connect(function(descendant)
		Chat:LockAllFields(descendant)
	end)
end

Chat:Initialize()
