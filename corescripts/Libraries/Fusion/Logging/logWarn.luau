--!strict

--[[
	Utility function to log a Fusion-specific warning.
]]

local messages = require "../Logging/messages"

local function logWarn(messageID, ...)
	local formatString: string

	if messages[messageID] ~= nil then
		formatString = messages[messageID]
	else
		messageID = "unknownMessage"
		formatString = messages[messageID]
	end

	warn(string.format(`[Fusion] {formatString}\n(ID: {messageID})`, ...))
end

return logWarn
