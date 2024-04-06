--!strict
-- Never trust the client

local CoreGui = game:GetService "CoreGui"
local Players = game:GetService "Players"
local RunService = game:GetService "RunService"
local MaxLength = 35

local New = (require "../Modules/New").New

local logEvent: BindableEvent

local function Colour3(r: number, g: number, b: number)
	return Color3.new(r / 255, g / 255, b / 255)
end

local docs = {
	{
		"printTable(t: { [any]: any }, max: number?)",
		"Prints the contents of a table to the console.",
		"`max` - the maximum number of entries to print.",
		"If not provided, all entries are printed.",
	},
	{
		"setWalkspeed(speed: number, plr: string?)",
		"Sets the walkspeed of a player. Go h4x0r mode!",
		"`speed` - the new walkspeed.",
		"`plr` - the name of the player to set the walkspeed of.",
		"If not provided, sets your own walkspeed.",
	},
	{
		"setHealth(health: number, plr: string?)",
		"Sets the health of a player. Become invincible!",
		"`health` - the new health value. Increases max health if necessary.",
		"`plr` - the name of the player to set the health of.",
		"If not provided, sets your own health.",
	},
	{
		"setMaxHealth(health: number, plr: string?)",
		"Sets the maximum health of a player.",
		"`health` - the new max health value.",
		"`plr` - the name of the player to set the max health of.",
		"If not provided, sets your own max health.",
	},
	{
		"setGravity(multi: number, plr: string?)",
		"Sets the gravity of a player. Float like a feather!",
		"`multi` - the multiplier to apply to gravity. 1 is normal, 2 is double,",
		"0.5 is half, etc. Beware of negative numbers!",
		"`plr` - the name of the player to set the gravity of.",
		"If not provided, changes your own gravity.",
	},
	{
		"sit(plr: string?)",
		"Sits a player down.",
		"`plr` - the name of the player to set the sitting state of.",
		"If not provided, sets your own sitting state.",
	},
	{
		"platformStand(plr: string?)",
		"Sets a player to stand on a platform.",
		"`plr` - the name of the player to set the platform standing state of.",
		"If not provided, sets your own platform standing state.",
	},
	{
		"stand(plr: string?)",
		"Stands a player up, and removes platform standing.",
		"`plr` - the name of the player to set the standing state of.",
		"If not provided, sets your own standing state.",
	},
	{
		"explode(plr: string?)",
		"Detonates a player, killing them instantly, and probably anyone nearby",
		"them too.",
		"`plr` - the name of the player to explode.",
		"If not provided, well... you know the deal.",
	},
	{
		"help(max: number?)",
		"You've already found this command!",
		"`max` - the maximum number of entries to print.",
		"If not provided, all entries are printed.",
	},
	{
		"exit()",
		"Exits the debug console. Watch out, you can't get back in!",
	},
}

local function Fire(should: boolean, ...: any)
	if should then
		logEvent:Fire(...)
	end
end

local utility = {
	CoreGui = CoreGui, -- convenience/shorthands
	Players = Players,
	RunService = RunService,
}

local function Assert(condition: any, message: string)
	if not condition then
		error(message, -1)
	end
end

local j = print -- j

function utility.print(...)
	local args = { ... }
	for i, v in ipairs(args) do
		args[i] = tostring(v)
	end
	local p = table.concat(args, " ")
	j(p)
	logEvent:Fire(p)
end

function utility.printTable(t: { [any]: any }, max: number?)
	assert(type(t) == "table", "Expected table, got " .. type(t))

	local num = max or math.huge
	local len = 0

	for k, v in pairs(t) do
		len += 1
		Fire(len < num, tostring(k) .. " = " .. tostring(v))
	end
	if len >= num then
		logEvent:Fire("... and " .. tostring(len - num) .. " more")
	end
end

-- I will not drown in a sea of tiny functions, I promise
local function getPlayerByUsername(username: string?)
	local player = (username and Players:FindFirstChild(username)) :: Player
	Assert(not username or player, "Player not found")
	player = player or Players.LocalPlayer
	Assert(player, "No player provided and no local player found")
	return player
end

local function getCharacterByUsername(username: string?)
	local player = getPlayerByUsername(username)
	return player.Character or player.CharacterAdded:wait(), player
end

local function getHumanoidByUsername(username: string?)
	local character, player = getCharacterByUsername(username)
	return character:WaitForChild "Humanoid" :: Humanoid, character, player
end

function utility.setWalkspeed(speed: number, plr: string?)
	Assert(type(speed) == "number", "Expected number, got " .. type(speed))

	local humanoid = getHumanoidByUsername(plr)

	humanoid.WalkSpeed = speed
end

function utility.setHealth(health: number, plr: string?)
	Assert(type(health) == "number", "Expected number, got " .. type(health))

	local humanoid = getHumanoidByUsername(plr)

	if humanoid.MaxHealth < health then
		humanoid.MaxHealth = health
	end
	humanoid.Health = health
end

function utility.setMaxHealth(health: number, plr: string?)
	Assert(type(health) == "number", "Expected number, got " .. type(health))

	local humanoid = getHumanoidByUsername(plr)

	humanoid.MaxHealth = health
end

function utility.sit(plr: string?)
	local humanoid = getHumanoidByUsername(plr)
	humanoid.Sit = true
end

function utility.platformStand(plr: string?)
	local humanoid = getHumanoidByUsername(plr)
	humanoid.PlatformStand = true
end

function utility.stand(plr: string?)
	local humanoid = getHumanoidByUsername(plr)
	humanoid.Sit = false
	humanoid.PlatformStand = false
end

function utility.explode(plr: string?)
	local character = getCharacterByUsername(plr)
	local torso = character:FindFirstChild "Torso" :: Part
	Assert(torso, "No torso found in character, required to explode")

	New "Explosion" {
		ExplosionType = Enum.ExplosionType.NoCraters,
		Parent = character,
		Position = torso.Position,
		BlastPressure = 15e5, -- engineering moment
		BlastRadius = 2,
	}
end

local grav = 3372 -- just enough keep you on the ground, as long as you don't jump

function utility.setGravity(multi: number, plr: string?)
	assert(type(multi) == "number", "Expected number, got " .. type(multi))

	local character = getCharacterByUsername(plr)
	local torso = character:FindFirstChild "Torso" :: Part
	Assert(torso, "No torso found in character, required to apply gravity")

	local bodyForce = torso:FindFirstChild "Gravity"
		or New "BodyForce" {
			Name = "Gravity",
			Parent = torso,
		}
	bodyForce.force = Vector3.new(0, grav * (1 - multi), 0)
end

function utility.help(max: number?)
	local num = max or math.huge
	local len = 0

	for _, doc in pairs(docs) do
		if len < num then
			RunService.RenderStepped:wait()
		end
		Fire(len < num, doc[1], Color3.new(1, 1, 0.3))
		len += 1
		for i = 2, #doc do
			Fire(len < num, "\t" .. doc[i], Color3.new(1, 1, 1))
			len += 1
		end
	end
	if len >= num then
		logEvent:Fire("... and " .. tostring(len - num) .. " more")
	end
end

function utility.exit()
	logEvent:Fire("Goodbye!", Color3.new(1, 1, 0.3))

	for i = 1, MaxLength do
		logEvent:Fire()
		RunService.RenderStepped:wait()
	end

	local debug = game.CoreGui:FindFirstChild "Debug console" :: ScreenGui
	debug:Destroy()
end

if not Players.LocalPlayer or Players.LocalPlayer.Name ~= "Heliodex" then -- Don't show the debug console for anyone but me
	return
end

logEvent = logEvent or New "BindableEvent" {
	Name = "Log",
	Parent = game,
}

local screen = New "ScreenGui" {
	Name = "Debug console",
	Parent = CoreGui,
}

local frame = New "Frame" {
	Name = "Frame",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.2, 0),
	Size = UDim2.new(0.25, 0, 0.7, 0),
	Parent = screen,
}

local console = New "Frame" {
	Name = "Console",
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.5,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, -30),
	Parent = frame,
}

local logLines = {}
local logLineInstances: { TextLabel } = {}
for i = 1, MaxLength do
	table.insert(logLines, {
		Text = "",
		Colour = Color3.new(1, 1, 1),
	})
	table.insert(
		logLineInstances,
		New "TextLabel" {
			Name = "LogLine",
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSans,
			FontSize = Enum.FontSize.Size18,
			Position = UDim2.new(0, 0, 0, (i - 1) * 18),
			Size = UDim2.new(1, 0, 0, 18),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = console,
		}
	)
end

local function recomputeLogLines()
	for i, line in ipairs(logLines) do
		logLineInstances[i].Text = " " .. line.Text -- yeah pad
		logLineInstances[i].TextColor3 = line.Colour or Color3.new(1, 1, 1)
	end
end

logEvent.Event:connect(function(text: string?, colour: Color3?)
	table.insert(logLines, {
		Text = text or "",
		Colour = colour or Color3.new(1, 1, 1),
	})
	if #logLines > MaxLength then
		table.remove(logLines, 1)
	end

	recomputeLogLines()
end)

local input = New "TextBox" {
	Name = "Input",
	BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	BackgroundTransparency = 0.2,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 1, -30),
	Size = UDim2.new(1, -30, 0, 30),
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size18,
	Text = "",
	TextColor3 = Color3.new(1, 1, 1),
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
	Parent = frame,
}

local upButton = New "TextButton" {
	Name = "UpButton",
	BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	BackgroundTransparency = 0.2,
	BorderSizePixel = 0,
	Position = UDim2.new(1, -30, 1, -30),
	Size = UDim2.new(0, 30, 0, 30),
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size24,
	Text = "^",
	TextColor3 = Color3.new(1, 1, 1),
	Parent = frame,
}

local history = {}
local historyPos = 1

-- on upButton pressed, go back in history
upButton.MouseButton1Click:connect(function()
	if historyPos > #history then
		return
	end

	input.Text = history[historyPos]
	historyPos += 1
end)

input.FocusLost:connect(function(enterPressed)
	if enterPressed then
		historyPos = 1
		local text = input.Text
		table.insert(history, 1, text)
		logEvent:Fire("> " .. text)

		-- run the command
		local fn = loadstring(text)

		if fn then
			local env = getfenv(fn)
			for k, v in pairs(utility) do
				env[k] = v
			end
			setfenv(fn, env)

			local ok, output = ypcall(fn)
			if ok then
				logEvent:Fire("= " .. tostring(output), Color3.new(0.5, 1, 0.5))
			else
				logEvent:Fire("! " .. tostring(output), Color3.new(1, 0.5, 0.5))
			end
		else
			logEvent:Fire("Invalid command", Color3.new(1, 0.3, 0.3))
		end

		input.Text = ""
		input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	end
end)

input.Changed:connect(function(property)
	if property ~= "Text" or input.Text == "" then
		return
	end

	input.BackgroundColor3 = Color3.new(0, 0, 0)
end)

local welcome: { { any } } = {
	{ "[Reading access...]", Color3.new(0.6, 0.6, 0.6) }, -- haxor text
	{ "[Access granted.]", Color3.new(0.5, 1, 0.5) }, -- i'm in
	{ "Welcome to the Mercury Debug Console!", Colour3(139, 82, 255) }, -- mercury light purple
	{ "Run `help()` for a list of functions.", Color3.new(1, 1, 1) },
	{ "" },
}

for _, line in ipairs(welcome) do
	logEvent:Fire(unpack(line))
	RunService.RenderStepped:wait()
end
