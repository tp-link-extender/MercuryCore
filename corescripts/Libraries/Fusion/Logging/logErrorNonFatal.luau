--!strict

--[[
	Utility function to log a Fusion-specific error, without halting execution.
]]

local Types = require "../Types"
local messages = require "../Logging/messages"

local function logErrorNonFatal(messageID: string, errObj: Types.Error?, ...)
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
			string.format(`[Fusion] {formatString}\n(ID: {messageID})`, ...)
		)
	else
		formatString =
			string.gsub(formatString, "ERROR_MESSAGE", tostring(errObj.message))
		errorString = string.format(
			`[Fusion] {formatString}\n(ID: {messageID})\n---- Stack trace ----\n{tostring(
				errObj.trace
			)}`,
			...
		)
	end

	coroutine.wrap(function()
		error(string.gsub(errorString, "\n", "\n    "), 0)
	end)()
end

return logErrorNonFatal
