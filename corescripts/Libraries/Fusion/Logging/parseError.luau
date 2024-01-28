--!strict

--[[
	An xpcall() error handler to collect and parse useful information about
	errors, such as clean messages and stack traces.
]]

local Types = require "../Types"

local function parseError(err: string): Types.Error
	local trace
	if debug and debug.traceback then
		trace = debug.traceback(nil, 2)
	end

	return {
		type = "Error",
		raw = err,
		message = err:gsub("^.+:%d+:%s*", ""),
		trace = trace or "Traceback not available",
	}
end

return parseError
