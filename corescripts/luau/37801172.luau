--!strict
-- Script Context.StarterScript
print "[Mercury]: Loaded corescript 37801172"

local ScriptContext = game:GetService "ScriptContext"
local CoreGui = game:GetService "CoreGui"

require "../Modules/DebugConsole"(CoreGui)

-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user

-- library registration
ScriptContext:AddCoreScript(
	60595695,
	ScriptContext,
	"/Libraries/LibraryRegistration/LibraryRegistration"
)

local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

waitForChild(CoreGui, "RobloxGui")
local screenGui = CoreGui:FindFirstChild "RobloxGui"

local scripts = {
	[36868950] = "CoreScripts/ToolTip", -- ToolTipper  (creates tool tips for gui)
	[46295863] = "CoreScripts/Settings", -- SettingsScript
	[39250920] = "CoreScripts/MainBotChatScript", -- MainBotChatScript
	[48488451] = "CoreScripts/PopupScript", -- Popup Script
	[48488398] = "CoreScripts/NotificationScript", -- Friend Notification Script (probably can use this script to expand out to other notifications)
	[97188756] = "CoreScripts/ChatScript", -- Chat script
	[107893730] = "CoreScripts/PurchasePromptScript", -- Purchase Prompt Script
}

for id, path in pairs(scripts) do
	ScriptContext:AddCoreScript(id, screenGui, path)
end

if screenGui.AbsoluteSize.Y >= 600 then
	-- New Player List
	ScriptContext:AddCoreScript(
		48488235,
		screenGui,
		"CoreScripts/PlayerListScript"
	)
else
	delay(5, function()
		if screenGui.AbsoluteSize.Y >= 600 then
			-- New Player List
			ScriptContext:AddCoreScript(
				48488235,
				screenGui,
				"CoreScripts/PlayerListScript"
			)
		end
	end)
end

-- Backpack Builder, creates most of the backpack gui
ScriptContext:AddCoreScript(
	53878047,
	screenGui,
	"CoreScripts/BackpackScripts/BackpackBuilder"
)

waitForChild(screenGui, "CurrentLoadout")
waitForChild(screenGui, "Backpack")
local Backpack = screenGui.Backpack

-- Manager handles all big backpack state changes, other scripts subscribe to this and do things accordingly
ScriptContext:AddCoreScript(
	89449093,
	Backpack,
	"CoreScripts/BackpackScripts/BackpackManager"
)

-- Backpack Gear (handles all backpack gear tab stuff)
ScriptContext:AddCoreScript(
	89449008,
	Backpack,
	"CoreScripts/BackpackScripts/BackpackGear"
)
-- Loadout Script, used for gear hotkeys
ScriptContext:AddCoreScript(
	53878057,
	screenGui.CurrentLoadout,
	"CoreScripts/BackpackScripts/LoadoutScript"
)

-- Personal servers are disabled, the corescript for it is not present
