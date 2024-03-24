--!strict

local Players = game:GetService "Players"
local MaxLength = 35

local New = (require "../Modules/New").New

local logEvent: BindableEvent

local docs: { [string]: { string } } = {
	help = {
		"help()",
		"You've already found this command!",
	},
	printTable = {
		"printTable(t: { [any]: any }, max: number?)",
		"Prints the contents of a table to the console.",
		"`max` is the maximum number of entries to print. If not provided, all",
		"entries are printed.",
	},
	exit = {
		"exit()",
		"Exits the debug console.",
	},
}

local utility = {
	help = function()
		for _, doc in pairs(docs) do
			logEvent:Fire(doc[1], Color3.new(1, 1, 0.3))
			for i = 2, #doc do
				logEvent:Fire("\t" .. doc[i], Color3.new(1, 1, 1))
			end
		end
	end,
	printTable = function(t: { [any]: any }, max: number?)
		assert(type(t) == "table", "Expected table, got " .. type(t))

		local num = max or math.huge
		local len = 0
		for k, v in pairs(t) do
			len += 1
			if len < num then
				logEvent:Fire(tostring(k) .. " = " .. tostring(v))
			end
		end
		if len >= num then
			logEvent:Fire("... and " .. tostring(len - num) .. " more")
		end
	end,
	exit = function()
		logEvent:Fire("Goodbye!", Color3.new(1, 1, 0.3))
		wait(0.5)
		local debug = game.CoreGui:FindFirstChild "Debug console" :: ScreenGui
		debug:Destroy()
	end,
}

return function(parent: CoreGui)
	if not Players.LocalPlayer or Players.LocalPlayer.Name ~= "Heliodex" then -- Don't show the debug console for anyone but me
		return
	end

	logEvent = logEvent
		or New "BindableEvent" {
			Name = "Log",
			Parent = game,
		}

	local screen = New "ScreenGui" {
		Name = "Debug console",
		Parent = parent,
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
			logLineInstances[i].Text = line.Text
			logLineInstances[i].TextColor3 = line.Colour or Color3.new(1, 1, 1)
		end
	end

	logEvent.Event:connect(function(text: string, colour: Color3?)
		table.insert(logLines, {
			Text = text,
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

				local success, output = ypcall(fn)
				if success then
					logEvent:Fire(
						"= " .. tostring(output),
						Color3.new(0.5, 1, 0.5)
					)
				else
					logEvent:Fire(
						"! " .. tostring(output),
						Color3.new(1, 0.5, 0.5)
					)
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

	logEvent:Fire("[Reading access...]", Color3.new(0.5, 0.5, 0.5)) -- haxor text
	logEvent:Fire("[Access granted.]", Color3.new(0.5, 1, 0.5))
	logEvent:Fire(
		"Welcome to the Mercury Debug Console!",
		Color3.new(1, 1, 0.3)
	)
	logEvent:Fire("Type `help()` for a list of commands.", Color3.new(1, 1, 1))
	logEvent:Fire("")
end
