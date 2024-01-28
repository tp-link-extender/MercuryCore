--!strict

--[[
	Utility function to log a Fusion-specific error.
]]

local Types = require "../Types"
local messages = require "../Logging/messages"

local function logError(messageID: string, errObj: Types.Error?, ...)
	local formatString: string

	if messages[messageID] ~= nil then
		formatString = messages[messageID]
	else
		messageID = "unknownMessage"
		formatString = messages[messageID]
	end

	local errorString
	if errObj == nil then
		errorString = string.format(
			"[Fusion] " .. formatString .. "\n(ID: " .. messageID .. ")",
			...
		)
	else
		formatString =
			formatString:gsub("ERROR_MESSAGE", tostring(errObj.message))
		errorString = string.format(
			"[Fusion] "
				.. formatString
				.. "\n(ID: "
				.. messageID
				.. ")\n---- Stack trace ----\n"
				.. tostring(errObj.trace),
			...
		)
	end

	error(errorString:gsub("\n", "\n    "), 0)
end

return logError
