-- A basic polyfill for the TweenInfo.new function,
-- allows using Enum.EasingStyle/Direction or strings instead

local TweenInfo = {}

function TweenInfo.new(
	time: number?,
	easingStyle: Enum.EasingStyle | string?,
	easingDirection: Enum.EasingDirection | string?,
	repeatCount: number?,
	reverses: boolean?,
	delayTime: number?
): FakeTweenInfo
	local proxy = newproxy(true)
	local mt = getmetatable(proxy)

	-- if easingStyle or easingDirection is an enum,
	-- convert it to a string
	if type(easingStyle) ~= "string" then
		if easingStyle then
			easingStyle = string.gsub(tostring(easingStyle), "Enum.%w+.", "")
		end
	else
		local ok
		for _, s in ipairs {
			"Linear",
			"Quad",
			"Cubic",
			"Quart",
			"Quint",
			"Sine",
			"Exponential",
			"Circular",
			"Elastic",
			"Back",
			"Bounce",
		} do
			if easingStyle == s then
				ok = true
				break
			end
		end
		if not ok then
			error(
				`The easing style must be a valid Enum.EasingStyle or a string of 'Linear', 'Quad', 'Cubic', 'Quart', 'Quint', 'Sine', 'Exponential', 'Circular', 'Elastic', 'Back', 'Bounce'. (got {easingStyle})`,
				0
			)
		end
	end

	if type(easingDirection) ~= "string" then
		if easingDirection then
			easingDirection =
				string.gsub(tostring(easingDirection), "Enum.%w+.", "")
		end
	else
		local ok
		for _, d in ipairs {
			"In",
			"Out",
			"InOut",
			"OutIn",
		} do
			if easingDirection == d then
				ok = true
				break
			end
		end
		if not ok then
			error(
				`The easing direction must be a valid Enum.EasingDirection or a string of 'In', 'Out', 'InOut', 'OutIn'. (got {easingDirection})`,
				0
			)
		end
	end

	time = time or 1
	easingStyle = easingStyle or "Quad"
	easingDirection = easingDirection or "Out"
	repeatCount = repeatCount or 0
	reverses = reverses or false
	delayTime = delayTime or 0

	mt.__index = {
		Time = time,
		EasingStyle = easingStyle,
		EasingDirection = easingDirection,
		RepeatCount = repeatCount,
		Reverses = reverses,
		DelayTime = delayTime,
	}

	-- When attempting to assign to properties, throw an error
	mt.__newindex = function(_, prop)
		error(prop .. " cannot be assigned to", 99)
	end

	mt.__tostring = function()
		return "Time:"
			.. tostring(time)
			.. " DelayTime:"
			.. tostring(delayTime)
			.. " RepeatCount:"
			.. tostring(repeatCount)
			.. " Reverses:"
			.. (reverses and "True" or "False")
			.. " EasingDirection:"
			.. tostring(easingDirection)
			.. " EasingStyle:"
			.. tostring(easingStyle)
	end

	mt.__metatable = "The metatable is locked"

	return proxy
end

return TweenInfo
