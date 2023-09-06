local __DARKLUA_BUNDLE_MODULES = {}

do
	__DARKLUA_BUNDLE_MODULES.c = {
		cannotAssignProperty = "The class type '%s' has no assignable property '%s'.",
		cannotConnectChange = "The %s class doesn't have a property called '%s'.",
		cannotConnectEvent = "The %s class doesn't have an event called '%s'.",
		cannotCreateClass = "Can't create a new instance of class '%s'.",
		computedCallbackError = "Computed callback error: ERROR_MESSAGE",
		destructorNeededValue = [[To save instances into Values, provide a destructor function. This will be an error soon - see discussion #183 on GitHub.]],
		destructorNeededComputed = [[To return instances from Computeds, provide a destructor function. This will be an error soon - see discussion #183 on GitHub.]],
		multiReturnComputed = [[Returning multiple values from Computeds is discouraged, as behaviour will change soon - see discussion #189 on GitHub.]],
		destructorNeededForKeys = [[To return instances from ForKeys, provide a destructor function. This will be an error soon - see discussion #183 on GitHub.]],
		destructorNeededForValues = [[To return instances from ForValues, provide a destructor function. This will be an error soon - see discussion #183 on GitHub.]],
		destructorNeededForPairs = [[To return instances from ForPairs, provide a destructor function. This will be an error soon - see discussion #183 on GitHub.]],
		forKeysProcessorError = "ForKeys callback error: ERROR_MESSAGE",
		forKeysKeyCollision = [[ForKeys should only write to output key '%s' once when processing key changes, but it wrote to it twice. Previously input key: '%s'; New input key: '%s']],
		forKeysDestructorError = "ForKeys destructor error: ERROR_MESSAGE",
		forPairsDestructorError = "ForPairs destructor error: ERROR_MESSAGE",
		forPairsKeyCollision = [[ForPairs should only write to output key '%s' once when processing key changes, but it wrote to it twice. Previous input pair: '[%s] = %s'; New input pair: '[%s] = %s']],
		forPairsProcessorError = "ForPairs callback error: ERROR_MESSAGE",
		forValuesProcessorError = "ForValues callback error: ERROR_MESSAGE",
		forValuesDestructorError = "ForValues destructor error: ERROR_MESSAGE",
		invalidChangeHandler = [[The change handler for the '%s' property must be a function.]],
		invalidEventHandler = "The handler for the '%s' event must be a function.",
		invalidPropertyType = "'%s.%s' expected a '%s' type, but got a '%s' type.",
		invalidRefType = "Instance refs must be Value objects.",
		invalidOutType = "[Out] properties must be given Value objects.",
		invalidOutProperty = "The %s class doesn't have a property called '%s'.",
		invalidSpringDamping = [[The damping ratio for a spring must be >= 0. (damping was %.2f)]],
		invalidSpringSpeed = "The speed of a spring must be >= 0. (speed was %.2f)",
		mistypedSpringDamping = "The damping ratio for a spring must be a number. (got a %s)",
		mistypedSpringSpeed = "The speed of a spring must be a number. (got a %s)",
		mistypedTweenInfo = "The tween info of a tween must be a TweenInfo. (got a %s)",
		springTypeMismatch = "The type '%s' doesn't match the spring's type '%s'.",
		stateGetWasRemoved = [[`StateObject:get()` has been replaced by `use()` and `peek()` - see discussion #217 on GitHub.]],
		strictReadError = "'%s' is not a valid member of '%s'.",
		unknownMessage = "Unknown error: ERROR_MESSAGE",
		unrecognisedChildType = "'%s' type children aren't accepted by `[Children]`.",
		unrecognisedPropertyKey = "'%s' keys aren't accepted in property tables.",
		unrecognisedPropertyStage = [['%s' isn't a valid stage for a special key to be applied at.]],
		invalidEasingStyle = [[The easing style must be a valid Enum.EasingStyle or a string of 'Linear', 'Quad', 'Cubic', 'Quart', 'Quint', 'Sine', 'Exponential', 'Circular', 'Elastic', 'Back', 'Bounce'. (got %s)]],
		invalidEasingDirection = [[The easing direction must be a valid Enum.EasingDirection or a string of 'In', 'Out', 'InOut', 'OutIn'. (got %s)]],
	}
end
do
	local messages = __DARKLUA_BUNDLE_MODULES.c

	local function logError(messageID, errObj, ...)
		local formatString

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

	__DARKLUA_BUNDLE_MODULES.d = logError
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d

	local function restrictRead(tableName, strictTable)
		local metatable = getmetatable(strictTable)

		if metatable == nil then
			metatable = {}

			setmetatable(strictTable, metatable)
		end

		function metatable:__index(memberName)
			logError("strictReadError", nil, tostring(memberName), tableName)
		end

		return strictTable
	end

	__DARKLUA_BUNDLE_MODULES.e = restrictRead
end
do
	local Oklab = {}

	function Oklab.to(rgb)
		local l = rgb.r * 0.4122214708
			+ rgb.g * 0.5363325363
			+ rgb.b * 0.0514459929
		local m = rgb.r * 0.2119034982
			+ rgb.g * 0.6806995451
			+ rgb.b * 0.1073969566
		local s = rgb.r * 0.0883024619
			+ rgb.g * 0.2817188376
			+ rgb.b * 0.6299787005
		local lRoot = l ^ 0.3333333333333333
		local mRoot = m ^ 0.3333333333333333
		local sRoot = s ^ 0.3333333333333333

		return Vector3.new(
			lRoot * 0.2104542553 + mRoot * 0.793617785 - sRoot * 0.0040720468,
			lRoot * 1.9779984951 - mRoot * 2.428592205 + sRoot * 0.4505937099,
			lRoot * 0.0259040371 + mRoot * 0.7827717662 - sRoot * 0.808675766
		)
	end
	function Oklab.from(lab, unclamped)
		local lRoot = lab.X + lab.Y * 0.3963377774 + lab.Z * 0.2158037573
		local mRoot = lab.X - lab.Y * 0.1055613458 - lab.Z * 0.0638541728
		local sRoot = lab.X - lab.Y * 0.0894841775 - lab.Z * 1.291485548
		local l = lRoot ^ 3
		local m = mRoot ^ 3
		local s = sRoot ^ 3
		local red = l * 4.0767416621 - m * 3.3077115913 + s * 0.2309699292
		local green = l * -1.2684380046 + m * 2.6097574011 - s * 0.3413193965
		local blue = l * -4.196086299999999E-3
			- m * 0.7034186147
			+ s * 1.707614701

		if not unclamped then
			red = math.max(0, math.min(red, 1))
			green = math.max(0, math.min(green, 1))
			blue = math.max(0, math.min(blue, 1))
		end

		return Color3.new(red, green, blue)
	end

	__DARKLUA_BUNDLE_MODULES.f = Oklab
end
do
	__DARKLUA_BUNDLE_MODULES.g = function(value)
		local basicType = type(value)

		if
			basicType == "nil"
			or basicType == "boolean"
			or basicType == "number"
			or basicType == "string"
			or basicType == "function"
			or basicType == "thread"
			or basicType == "table"
		then
			return basicType
		end

		local tests = {
			{
				"Instance",
				{
					"ClassName",
				},
			},
			{
				"EnumItem",
				{
					"EnumType",
					"Name",
					"Value",
				},
			},
			{
				"Enum",
				{
					"GetEnumItems",
				},
			},
			{
				"Enums",
				{
					"MembershipType",
				},
			},
			{
				"RBXScriptSignal",
				{
					"connect",
					"wait",
				},
			},
			{
				"RBXScriptConnection",
				{
					"connected",
					"disconnect",
				},
			},
			{
				"TweenInfo",
				{
					"EasingDirection",
					"RepeatCount",
					"EasingStyle",
				},
			},
			{
				"CFrame",
				{
					"p",
					"x",
					"y",
					"z",
					"lookVector",
				},
			},
			{
				"Vector3",
				{
					"Lerp",
					"unit",
					"magnitude",
					"x",
					"y",
					"z",
				},
			},
			{
				"Vector3int16",
				{
					"z",
					"x",
					"y",
				},
			},
			{
				"Vector2",
				{
					"unit",
					"magnitude",
					"x",
					"y",
				},
			},
			{
				"Vector2int16",
				{
					"x",
					"y",
				},
			},
			{
				"Region3",
				{
					"CFrame",
					"Size",
				},
			},
			{
				"Region3int16",
				{
					"Min",
					"Max",
				},
			},
			{
				"Ray",
				{
					"Origin",
					"Direction",
					"Unit",
					"ClosestPoint",
					"Distance",
				},
			},
			{
				"UDim",
				{
					"Scale",
					"Offset",
				},
			},
			{
				"Axes",
				{
					"Z",
					"X",
					"Y",
				},
			},
			{
				"UDim2",
				{
					"X",
					"Y",
				},
			},
			{
				"BrickColor",
				{
					"Number",
					"Name",
					"Color",
					"r",
					"g",
					"b",
				},
			},
			{
				"Color3",
				{
					"r",
					"g",
					"b",
				},
			},
			{
				"Faces",
				{
					"Right",
					"Top",
					"Back",
				},
			},
		}

		for _, v in ipairs(tests) do
			local t, test = v[1], v[2]
			local ok, result = pcall(function()
				for _, prop in ipairs(test) do
					if value[prop] == nil then
						return false
					end
				end

				return true
			end)

			if ok and result then
				return t
			end
		end
	end
end
do
	local Oklab = __DARKLUA_BUNDLE_MODULES.f
	local typeof = __DARKLUA_BUNDLE_MODULES.g

	local function lerpType(from, to, ratio)
		local typeString = typeof(from)

		if typeof(to) == typeString then
			if typeString == "number" then
				return (to - from) * ratio + from
			elseif typeString == "CFrame" then
				return from:Lerp(to, ratio)
			elseif typeString == "Color3" then
				local fromLab = Oklab.to(from)
				local toLab = Oklab.to(to)

				return Oklab.from(fromLab:Lerp(toLab, ratio), false)
			elseif typeString == "Ray" then
				return Ray.new(
					from.Origin:Lerp(to.Origin, ratio),
					from.Direction:Lerp(to.Direction, ratio)
				)
			elseif typeString == "Region3" then
				local position =
					from.CFrame.Position:Lerp(to.CFrame.Position, ratio)
				local halfSize = from.Size:Lerp(to.Size, ratio) / 2

				return Region3.new(position - halfSize, position + halfSize)
			elseif typeString == "Region3int16" then
				return Region3int16.new(
					Vector3int16.new(
						(to.Min.X - from.Min.X) * ratio + from.Min.X,
						(to.Min.Y - from.Min.Y) * ratio + from.Min.Y,
						(to.Min.Z - from.Min.Z) * ratio + from.Min.Z
					),
					Vector3int16.new(
						(to.Max.X - from.Max.X) * ratio + from.Max.X,
						(to.Max.Y - from.Max.Y) * ratio + from.Max.Y,
						(to.Max.Z - from.Max.Z) * ratio + from.Max.Z
					)
				)
			elseif typeString == "UDim" then
				return UDim.new(
					(to.Scale - from.Scale) * ratio + from.Scale,
					(to.Offset - from.Offset) * ratio + from.Offset
				)
			elseif typeString == "UDim2" then
				return UDim2.new(
					(to.X.Scale - from.X.Scale) * ratio + from.X.Scale,
					(to.X.Offset - from.X.Offset) * ratio + from.X.Offset,
					(to.Y.Scale - from.Y.Scale) * ratio + from.Y.Scale,
					(to.Y.Offset - from.Y.Offset) * ratio + from.Y.Offset
				)
			elseif typeString == "Vector2" or typeString == "Vector3" then
				return from:Lerp(to, ratio)
			elseif typeString == "Vector2int16" then
				return Vector2int16.new(
					(to.X - from.X) * ratio + from.X,
					(to.Y - from.Y) * ratio + from.Y
				)
			elseif typeString == "Vector3int16" then
				return Vector3int16.new(
					(to.X - from.X) * ratio + from.X,
					(to.Y - from.Y) * ratio + from.Y,
					(to.Z - from.Z) * ratio + from.Z
				)
			end
		end
		if ratio < 0.5 then
			return from
		end

		return to
	end

	__DARKLUA_BUNDLE_MODULES.h = lerpType
end
do
	local pow = math.pow
	local sin = math.sin
	local cos = math.cos
	local pi = math.pi
	local sqrt = math.sqrt
	local abs = math.abs
	local asin = math.asin
	local easing = {
		Linear = {},
		Quad = {},
		Cubic = {},
		Quart = {},
		Quint = {},
		Sine = {},
		Exponential = {},
		Circular = {},
		Elastic = {},
		Back = {},
		Bounce = {},
	}
	local linear = function(t, b, c)
		return c * t + b
	end

	easing.Linear.In = linear
	easing.Linear.Out = linear
	easing.Linear.InOut = linear
	easing.Linear.OutIn = linear
	easing.Quad.In = function(t, b, c)
		return c * pow(t, 2) + b
	end
	easing.Quad.Out = function(t, b, c)
		return -c * t * (t - 2) + b
	end
	easing.Quad.InOut = function(t, b, c)
		t = t * 2

		if t < 1 then
			return c / 2 * pow(t, 2) + b
		end

		return -c / 2 * ((t - 1) * (t - 3) - 1) + b
	end
	easing.Quad.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Quad.Out(t * 2, b, c / 2)
		end

		return easing.Quad.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Cubic.In = function(t, b, c)
		return c * pow(t, 3) + b
	end
	easing.Cubic.Out = function(t, b, c)
		t = t - 1

		return c * (pow(t, 3) + 1) + b
	end
	easing.Cubic.InOut = function(t, b, c)
		t = t * 2

		if t < 1 then
			return c / 2 * t * t * t + b
		end

		t = t - 2

		return c / 2 * (t * t * t + 2) + b
	end
	easing.Cubic.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Cubic.Out(t * 2, b, c / 2)
		end

		return easing.Cubic.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Quart.In = function(t, b, c)
		return c * pow(t, 4) + b
	end
	easing.Quart.Out = function(t, b, c)
		t = t - 1

		return -c * (pow(t, 4) - 1) + b
	end
	easing.Quart.InOut = function(t, b, c)
		t = t * 2

		if t < 1 then
			return c / 2 * pow(t, 4) + b
		end

		t = t - 2

		return -c / 2 * (pow(t, 4) - 2) + b
	end
	easing.Quart.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Quart.Out(t * 2, b, c / 2)
		end

		return easing.Quart.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Quint.In = function(t, b, c)
		return c * pow(t, 5) + b
	end
	easing.Quint.Out = function(t, b, c)
		t = t - 1

		return c * (pow(t, 5) + 1) + b
	end
	easing.Quint.InOut = function(t, b, c)
		t = t * 2

		if t < 1 then
			return c / 2 * pow(t, 5) + b
		end

		t = t - 2

		return c / 2 * (pow(t, 5) + 2) + b
	end
	easing.Quint.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Quint.Out(t * 2, b, c / 2)
		end

		return easing.Quint.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Sine.In = function(t, b, c)
		return -c * cos(t * (pi / 2)) + c + b
	end
	easing.Sine.Out = function(t, b, c)
		return c * sin(t * (pi / 2)) + b
	end
	easing.Sine.InOut = function(t, b, c)
		return -c / 2 * (cos(pi * t) - 1) + b
	end
	easing.Sine.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Sine.Out(t * 2, b, c / 2)
		end

		return easing.Sine.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Exponential.In = function(t, b, c)
		if t == 0 then
			return b
		end

		return c * pow(2, 10 * (t - 1)) + b - c * 0.001
	end
	easing.Exponential.Out = function(t, b, c)
		if t == 1 then
			return b + c
		end

		return c * 1.001 * (-pow(2, -10 * t) + 1) + b
	end
	easing.Exponential.InOut = function(t, b, c)
		if t == 0 then
			return b
		elseif t == 1 then
			return b + c
		end

		t = t * 2

		if t < 1 then
			return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
		end

		t = t - 1

		return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
	end
	easing.Exponential.OutIn = function(t, b, c)
		if t < 0.5 then
			return t.Exponential.Out(t * 2, b, c / 2)
		end

		return t.Exponential.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Circular.In = function(t, b, c)
		return (-c * (sqrt(1 - pow(t, 2)) - 1) + b)
	end
	easing.Circular.Out = function(t, b, c)
		t = t - 1

		return (c * sqrt(1 - pow(t, 2)) + b)
	end
	easing.Circular.InOut = function(t, b, c)
		t = t * 2

		if t < 1 then
			return -c / 2 * (sqrt(1 - t * t) - 1) + b
		end

		t = t - 2

		return c / 2 * (sqrt(1 - t * t) + 1) + b
	end
	easing.Circular.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Circular.Out(t * 2, b, c / 2)
		end

		return easing.Circular.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Elastic.In = function(t, b, c)
		if t == 0 then
			return b
		elseif t == 1 then
			return b + c
		end

		local p = 0.3
		local s

		s = p / 4
		t = t - 1

		return -(c * pow(2, 10 * t) * sin((t * 1 - s) * (2 * pi) / p)) + b
	end
	easing.Elastic.Out = function(t, b, c)
		if t == 0 then
			return b
		elseif t == 1 then
			return b + c
		end

		local p = 0.3
		local s

		s = p / 4

		return c * pow(2, -10 * t) * sin((t - s) * (2 * pi) / p) + c + b
	end
	easing.Elastic.InOut = function(t, b, c)
		if t == 0 then
			return b
		end

		t = t * 2

		if t == 2 then
			return b + c
		end

		local p = 0.45
		local a = 0
		local s

		if not a or a < abs(c) then
			a = c
			s = p / 4
		else
			s = p / (2 * pi) * asin(c / a)
		end

		t = t - 1

		if t < 1 then
			return -0.5 * (a * pow(2, 10 * t) * sin((t - s) * (2 * pi) / p)) + b
		end

		return a * pow(2, -10 * t) * sin((t - s) * (2 * pi) / p) * 0.5 + c + b
	end
	easing.Elastic.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Elastic.Out(t * 2, b, c / 2)
		end

		return easing.Elastic.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Back.In = function(t, b, c)
		local s = 1.70158

		return c * t * t * ((s + 1) * t - s) + b
	end
	easing.Back.Out = function(t, b, c)
		local s = 1.70158

		t = t - 1

		return c * (t * t * ((s + 1) * t + s) + 1) + b
	end
	easing.Back.InOut = function(t, b, c)
		local s = 2.5949095

		t = t * 2

		if t < 1 then
			return c / 2 * (t * t * ((s + 1) * t - s)) + b
		end

		t = t - 2

		return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	end
	easing.Back.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Back.Out(t * 2, b, c / 2)
		end

		return easing.Back.In((t * 2) - 1, b + c / 2, c / 2)
	end
	easing.Bounce.Out = function(t, b, c)
		if t < 0.36363636363636365 then
			return c * (7.5625 * t * t) + b
		elseif t < 0.7272727272727273 then
			t = t - 0.5454545454545454

			return c * (7.5625 * t * t + 0.75) + b
		elseif t < 0.9090909090909091 then
			t = t - 0.8181818181818182

			return c * (7.5625 * t * t + 0.9375) + b
		end

		t = t - 0.9545454545454546

		return c * (7.5625 * t * t + 0.984375) + b
	end
	easing.Bounce.In = function(t, b, c)
		return c - easing.Bounce.Out(1 - t, 0, c) + b
	end
	easing.Bounce.InOut = function(t, b, c)
		if t < 0.5 then
			return easing.Bounce.In(t * 2, 0, c) * 0.5 + b
		end

		return easing.Bounce.Out(t * 2 - 1, 0, c) * 0.5 + c * 0.5 + b
	end
	easing.Bounce.OutIn = function(t, b, c)
		if t < 0.5 then
			return easing.Bounce.Out(t * 2, b, c / 2)
		end

		return easing.Bounce.In((t * 2) - 1, b + c / 2, c / 2)
	end
	__DARKLUA_BUNDLE_MODULES.i = easing
end
do
	local easing = __DARKLUA_BUNDLE_MODULES.i

	local function getTweenRatio(tweenInfo, currentTime)
		local delay = tweenInfo.DelayTime
		local duration = tweenInfo.Time
		local reverses = tweenInfo.Reverses
		local numCycles = 1 + tweenInfo.RepeatCount
		local easeStyle = tweenInfo.EasingStyle
		local easeDirection = tweenInfo.EasingDirection
		local cycleDuration = delay + duration

		if reverses then
			cycleDuration = cycleDuration + duration
		end
		if
			currentTime >= cycleDuration * numCycles
			and tweenInfo.RepeatCount > -1
		then
			return 1
		end

		local cycleTime = currentTime % cycleDuration

		if cycleTime <= delay then
			return 0
		end

		local tweenProgress = (cycleTime - delay) / duration

		if tweenProgress > 1 then
			tweenProgress = 2 - tweenProgress
		end

		return easing[easeStyle][easeDirection](tweenProgress, 0, 1)
	end

	__DARKLUA_BUNDLE_MODULES.j = getTweenRatio
end
do
	local function updateAll(root)
		local counters = {}
		local flags = {}
		local queue = {}
		local queueSize = 0
		local queuePos = 1

		for object in pairs(root.dependentSet) do
			queueSize = queueSize + 1
			queue[queueSize] = object
			flags[object] = true
		end

		while queuePos <= queueSize do
			local next = queue[queuePos]
			local counter = counters[next]

			counters[next] = (function()
				if counter == nil then
					return 1
				else
					return counter + 1
				end
			end)()

			if next.dependentSet ~= nil then
				for object in pairs(next.dependentSet) do
					queueSize = queueSize + 1
					queue[queueSize] = object
				end
			end

			queuePos = queuePos + 1
		end

		queuePos = 1

		while queuePos <= queueSize do
			local next = queue[queuePos]
			local counter = counters[next] - 1

			counters[next] = counter

			if
				counter == 0
				and flags[next]
				and next:update()
				and next.dependentSet ~= nil
			then
				for object in pairs(next.dependentSet) do
					flags[object] = true
				end
			end

			queuePos = queuePos + 1
		end
	end

	__DARKLUA_BUNDLE_MODULES.k = updateAll
end
do
	local lerpType = __DARKLUA_BUNDLE_MODULES.h
	local getTweenRatio = __DARKLUA_BUNDLE_MODULES.j
	local updateAll = __DARKLUA_BUNDLE_MODULES.k
	local TweenScheduler = {}
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}
	local allTweens = {}

	setmetatable(allTweens, WEAK_KEYS_METATABLE)

	function TweenScheduler.add(tween)
		allTweens[tween] = true
	end
	function TweenScheduler.remove(tween)
		allTweens[tween] = nil
	end
	function TweenScheduler.updateAllTweens()
		local now = time()

		for tween in pairs(allTweens) do
			local currentTime = now - tween._currentTweenStartTime

			if
				currentTime > tween._currentTweenDuration
				and tween._currentTweenInfo.RepeatCount > -1
			then
				if tween._currentTweenInfo.Reverses then
					tween._currentValue = tween._prevValue
				else
					tween._currentValue = tween._nextValue
				end

				tween._currentlyAnimating = false

				updateAll(tween)
				TweenScheduler.remove(tween)
			else
				local ratio =
					getTweenRatio(tween._currentTweenInfo, currentTime)
				local currentValue =
					lerpType(tween._prevValue, tween._nextValue, ratio)

				tween._currentValue = currentValue
				tween._currentlyAnimating = true

				updateAll(tween)
			end
		end
	end

	__DARKLUA_BUNDLE_MODULES.l = TweenScheduler
end
do
	local Oklab = __DARKLUA_BUNDLE_MODULES.f

	local function packType(numbers, typeString)
		if typeString == "number" then
			return numbers[1]
		elseif typeString == "CFrame" then
			return CFrame.new(numbers[1], numbers[2], numbers[3])
				* CFrame.fromAxisAngle(
					Vector3.new(numbers[4], numbers[5], numbers[6]).Unit,
					numbers[7]
				)
		elseif typeString == "Color3" then
			return Oklab.from(
				Vector3.new(numbers[1], numbers[2], numbers[3]),
				false
			)
		elseif typeString == "ColorSequenceKeypoint" then
			return ColorSequenceKeypoint.new(
				numbers[4],
				Oklab.from(
					Vector3.new(numbers[1], numbers[2], numbers[3]),
					false
				)
			)
		elseif typeString == "DateTime" then
			return DateTime.fromUnixTimestampMillis(numbers[1])
		elseif typeString == "NumberRange" then
			return NumberRange.new(numbers[1], numbers[2])
		elseif typeString == "NumberSequenceKeypoint" then
			return NumberSequenceKeypoint.new(
				numbers[2],
				numbers[1],
				numbers[3]
			)
		elseif typeString == "PhysicalProperties" then
			return PhysicalProperties.new(
				numbers[1],
				numbers[2],
				numbers[3],
				numbers[4],
				numbers[5]
			)
		elseif typeString == "Ray" then
			return Ray.new(
				Vector3.new(numbers[1], numbers[2], numbers[3]),
				Vector3.new(numbers[4], numbers[5], numbers[6])
			)
		elseif typeString == "Rect" then
			return Rect.new(numbers[1], numbers[2], numbers[3], numbers[4])
		elseif typeString == "Region3" then
			local position = Vector3.new(numbers[1], numbers[2], numbers[3])
			local halfSize =
				Vector3.new(numbers[4] / 2, numbers[5] / 2, numbers[6] / 2)

			return Region3.new(position - halfSize, position + halfSize)
		elseif typeString == "Region3int16" then
			return Region3int16.new(
				Vector3int16.new(numbers[1], numbers[2], numbers[3]),
				Vector3int16.new(numbers[4], numbers[5], numbers[6])
			)
		elseif typeString == "UDim" then
			return UDim.new(numbers[1], numbers[2])
		elseif typeString == "UDim2" then
			return UDim2.new(numbers[1], numbers[2], numbers[3], numbers[4])
		elseif typeString == "Vector2" then
			return Vector2.new(numbers[1], numbers[2])
		elseif typeString == "Vector2int16" then
			return Vector2int16.new(numbers[1], numbers[2])
		elseif typeString == "Vector3" then
			return Vector3.new(numbers[1], numbers[2], numbers[3])
		elseif typeString == "Vector3int16" then
			return Vector3int16.new(numbers[1], numbers[2], numbers[3])
		else
			return nil
		end
	end

	__DARKLUA_BUNDLE_MODULES.m = packType
end
do
	local function springCoefficients(time, damping, speed)
		if time == 0 or speed == 0 then
			return 1, 0, 0, 1
		end

		local posPos, posVel, velPos, velVel

		if damping > 1 then
			local scaledTime = time * speed
			local alpha = math.sqrt(damping ^ 2 - 1)
			local scaledInvAlpha = -0.5 / alpha
			local z1 = -alpha - damping
			local z2 = 1 / z1
			local expZ1 = math.exp(scaledTime * z1)
			local expZ2 = math.exp(scaledTime * z2)

			posPos = (expZ2 * z1 - expZ1 * z2) * scaledInvAlpha
			posVel = (expZ1 - expZ2) * scaledInvAlpha / speed
			velPos = (expZ2 - expZ1) * scaledInvAlpha * speed
			velVel = (expZ1 * z1 - expZ2 * z2) * scaledInvAlpha
		elseif damping == 1 then
			local scaledTime = time * speed
			local expTerm = math.exp(-scaledTime)

			posPos = expTerm * (1 + scaledTime)
			posVel = expTerm * time
			velPos = expTerm * (-scaledTime * speed)
			velVel = expTerm * (1 - scaledTime)
		else
			local scaledTime = time * speed
			local alpha = math.sqrt(1 - damping ^ 2)
			local invAlpha = 1 / alpha
			local alphaTime = alpha * scaledTime
			local expTerm = math.exp(-scaledTime * damping)
			local sinTerm = expTerm * math.sin(alphaTime)
			local cosTerm = expTerm * math.cos(alphaTime)
			local sinInvAlpha = sinTerm * invAlpha
			local sinInvAlphaDamp = sinInvAlpha * damping

			posPos = sinInvAlphaDamp + cosTerm
			posVel = sinInvAlpha
			velPos = -(sinInvAlphaDamp * damping + sinTerm * alpha)
			velVel = cosTerm - sinInvAlphaDamp
		end

		return posPos, posVel, velPos, velVel
	end

	__DARKLUA_BUNDLE_MODULES.n = springCoefficients
end
do
	local packType = __DARKLUA_BUNDLE_MODULES.m
	local springCoefficients = __DARKLUA_BUNDLE_MODULES.n
	local updateAll = __DARKLUA_BUNDLE_MODULES.k
	local SpringScheduler = {}
	local EPSILON = 0.0001
	local activeSprings = {}
	local lastUpdateTime = time()

	function SpringScheduler.add(spring)
		spring._lastSchedule = lastUpdateTime
		spring._startDisplacements = {}
		spring._startVelocities = {}

		for index, goal in ipairs(spring._springGoals) do
			spring._startDisplacements[index] = spring._springPositions[index]
				- goal
			spring._startVelocities[index] = spring._springVelocities[index]
		end

		activeSprings[spring] = true
	end
	function SpringScheduler.remove(spring)
		activeSprings[spring] = nil
	end
	function SpringScheduler.updateAllSprings()
		local springsToSleep = {}

		lastUpdateTime = time()

		for spring in pairs(activeSprings) do
			local posPos, posVel, velPos, velVel = springCoefficients(
				lastUpdateTime - spring._lastSchedule,
				spring._currentDamping,
				spring._currentSpeed
			)
			local positions = spring._springPositions
			local velocities = spring._springVelocities
			local startDisplacements = spring._startDisplacements
			local startVelocities = spring._startVelocities
			local isMoving = false

			for index, goal in ipairs(spring._springGoals) do
				local oldDisplacement = startDisplacements[index]
				local oldVelocity = startVelocities[index]
				local newDisplacement = oldDisplacement * posPos
					+ oldVelocity * posVel
				local newVelocity = oldDisplacement * velPos
					+ oldVelocity * velVel

				if
					math.abs(newDisplacement) > EPSILON
					or math.abs(newVelocity) > EPSILON
				then
					isMoving = true
				end

				positions[index] = newDisplacement + goal
				velocities[index] = newVelocity
			end

			if not isMoving then
				springsToSleep[spring] = true
			end
		end
		for spring in pairs(activeSprings) do
			spring._currentValue =
				packType(spring._springPositions, spring._currentType)

			updateAll(spring)
		end
		for spring in pairs(springsToSleep) do
			activeSprings[spring] = nil
			spring._currentValue =
				packType(spring._springGoals, spring._currentType)
		end
	end

	__DARKLUA_BUNDLE_MODULES.o = SpringScheduler
end
do
	local RunService = game:GetService "RunService"
	local TweenScheduler = __DARKLUA_BUNDLE_MODULES.l
	local SpringScheduler = __DARKLUA_BUNDLE_MODULES.o

	local function bindScheduler()
		RunService.RenderStepped:connect(TweenScheduler.updateAllTweens)
		RunService.RenderStepped:connect(SpringScheduler.updateAllSprings)
	end

	__DARKLUA_BUNDLE_MODULES.p = bindScheduler
end
do
	__DARKLUA_BUNDLE_MODULES.q = {
		BillboardGui = { Active = true },
		Frame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			FontSize = Enum.FontSize.Size14,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			FontSize = Enum.FontSize.Size14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			FontSize = Enum.FontSize.Size14,
		},
		ImageLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			AutoButtonColor = false,
		},
		SpawnLocation = { Duration = 0 },
		Part = {
			Anchored = true,
			Size = Vector3.new(1, 1, 1),
			FrontSurface = Enum.SurfaceType.Smooth,
			BackSurface = Enum.SurfaceType.Smooth,
			LeftSurface = Enum.SurfaceType.Smooth,
			RightSurface = Enum.SurfaceType.Smooth,
			TopSurface = Enum.SurfaceType.Smooth,
			BottomSurface = Enum.SurfaceType.Smooth,
		},
		TrussPart = {
			Anchored = true,
			Size = Vector3.new(2, 2, 2),
			FrontSurface = Enum.SurfaceType.Smooth,
			BackSurface = Enum.SurfaceType.Smooth,
			LeftSurface = Enum.SurfaceType.Smooth,
			RightSurface = Enum.SurfaceType.Smooth,
			TopSurface = Enum.SurfaceType.Smooth,
			BottomSurface = Enum.SurfaceType.Smooth,
		},
		CornerWedgePart = {
			Anchored = true,
			Size = Vector3.new(1, 1, 1),
			FrontSurface = Enum.SurfaceType.Smooth,
			BackSurface = Enum.SurfaceType.Smooth,
			LeftSurface = Enum.SurfaceType.Smooth,
			RightSurface = Enum.SurfaceType.Smooth,
			TopSurface = Enum.SurfaceType.Smooth,
			BottomSurface = Enum.SurfaceType.Smooth,
		},
		VehicleSeat = {
			Anchored = true,
			Size = Vector3.new(1, 1, 1),
			FrontSurface = Enum.SurfaceType.Smooth,
			BackSurface = Enum.SurfaceType.Smooth,
			LeftSurface = Enum.SurfaceType.Smooth,
			RightSurface = Enum.SurfaceType.Smooth,
			TopSurface = Enum.SurfaceType.Smooth,
			BottomSurface = Enum.SurfaceType.Smooth,
		},
	}
end
do
	local typeof = __DARKLUA_BUNDLE_MODULES.g

	local function cleanupOne(task)
		local taskType = typeof(task)

		if taskType == "Instance" then
			task:Destroy()
		elseif taskType == "RBXScriptConnection" then
			task:disconnect()
		elseif taskType == "function" then
			task()
		elseif taskType == "table" then
			if type(task.destroy) == "function" then
				task:destroy()
			elseif type(task.Destroy) == "function" then
				task:Destroy()
			elseif task[1] ~= nil then
				for _, subtask in ipairs(task) do
					cleanupOne(subtask)
				end
			end
		end
	end
	local function cleanup(...)
		for index = 1, select("#", ...) do
			cleanupOne(select(index, ...))
		end
	end

	__DARKLUA_BUNDLE_MODULES.r = cleanup
end
do
	local typeof = __DARKLUA_BUNDLE_MODULES.g

	local function xtypeof(x)
		local typeString = typeof(x)

		if typeString == "table" and type(x.type) == "string" then
			return x.type
		else
			return typeString
		end
	end

	__DARKLUA_BUNDLE_MODULES.s = xtypeof
end
do
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local strongRefs = {}

	function class:update()
		for _, callback in pairs(self._changeListeners) do
			Spawn(callback)
		end

		return false
	end
	function class:onChange(callback)
		local uniqueIdentifier = {}

		self._numChangeListeners = self._numChangeListeners + 1
		self._changeListeners[uniqueIdentifier] = callback
		strongRefs[self] = true

		local disconnected = false

		return function()
			if disconnected then
				return
			end

			disconnected = true
			self._changeListeners[uniqueIdentifier] = nil
			self._numChangeListeners = self._numChangeListeners - 1

			if self._numChangeListeners == 0 then
				strongRefs[self] = nil
			end
		end
	end
	function class:onBind(callback)
		Spawn(callback)

		return self:onChange(callback)
	end

	local function Observer(watchedState)
		local self = setmetatable({
			type = "State",
			kind = "Observer",
			dependencySet = { [watchedState] = true },
			dependentSet = {},
			_changeListeners = {},
			_numChangeListeners = 0,
		}, CLASS_METATABLE)

		watchedState.dependentSet[self] = true

		return self
	end

	__DARKLUA_BUNDLE_MODULES.t = Observer
end
do
	local function isState(target)
		return type(target) == "table" and type(target._peek) == "function"
	end

	__DARKLUA_BUNDLE_MODULES.u = isState
end
do
	local isState = __DARKLUA_BUNDLE_MODULES.u

	local function peek(target)
		if isState(target) then
			return (target):_peek()
		end

		return target
	end

	__DARKLUA_BUNDLE_MODULES.v = peek
end
do
	local cleanup = __DARKLUA_BUNDLE_MODULES.r
	local xtypeof = __DARKLUA_BUNDLE_MODULES.s
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local Observer = __DARKLUA_BUNDLE_MODULES.t
	local peek = __DARKLUA_BUNDLE_MODULES.v
	local typeof = __DARKLUA_BUNDLE_MODULES.g

	local function setProperty_unsafe(instance, property, value)
		(instance)[property] = value
	end
	local function testPropertyAssignable(instance, property)
		(instance)[property] = (instance)[property]
	end
	local function setProperty(instance, property, value)
		if not pcall(setProperty_unsafe, instance, property, value) then
			if not pcall(testPropertyAssignable, instance, property) then
				if instance == nil then
					logError(
						"setPropertyNilRef",
						nil,
						property,
						tostring(value)
					)
				else
					logError(
						"cannotAssignProperty",
						nil,
						instance.ClassName,
						property
					)
				end
			else
				local givenType = typeof(value)
				local expectedType = typeof((instance)[property])

				logError(
					"invalidPropertyType",
					nil,
					instance.ClassName,
					property,
					expectedType,
					givenType
				)
			end
		end
	end
	local function bindProperty(instance, property, value, cleanupTasks)
		if xtypeof(value) == "State" then
			local willUpdate = false

			local function updateLater()
				if not willUpdate then
					willUpdate = true

					coroutine.resume(coroutine.create(function()
						willUpdate = false

						setProperty(instance, property, peek(value))
					end))
				end
			end

			setProperty(instance, property, peek(value))
			table.insert(cleanupTasks, Observer(value):onChange(updateLater))
		else
			setProperty(instance, property, value)
		end
	end
	local function applyInstanceProps(props, applyTo)
		local specialKeys = {
			self = {},
			descendants = {},
			ancestor = {},
			observer = {},
		}
		local cleanupTasks = {}

		for key, value in pairs(props) do
			local keyType = xtypeof(key)

			if keyType == "string" then
				if key ~= "Parent" then
					bindProperty(applyTo, key, value, cleanupTasks)
				end
			elseif keyType == "SpecialKey" then
				local stage = (key).stage
				local keys = specialKeys[stage]

				if keys == nil then
					logError("unrecognisedPropertyStage", nil, stage)
				else
					keys[key] = value
				end
			else
				logError("unrecognisedPropertyKey", nil, xtypeof(key))
			end
		end
		for key, value in pairs(specialKeys.self) do
			key:apply(value, applyTo, cleanupTasks)
		end
		for key, value in pairs(specialKeys.descendants) do
			key:apply(value, applyTo, cleanupTasks)
		end

		if props.Parent ~= nil then
			bindProperty(applyTo, "Parent", props.Parent, cleanupTasks)
		end

		for key, value in pairs(specialKeys.ancestor) do
			key:apply(value, applyTo, cleanupTasks)
		end
		for key, value in pairs(specialKeys.observer) do
			key:apply(value, applyTo, cleanupTasks)
		end

		if applyTo.Parent then
			game.DescendantRemoving:connect(function(descendant)
				if descendant == applyTo then
					cleanup(cleanupTasks)
				end
			end)
		end
	end

	__DARKLUA_BUNDLE_MODULES.w = applyInstanceProps
end
do
	local defaultProps = __DARKLUA_BUNDLE_MODULES.q
	local applyInstanceProps = __DARKLUA_BUNDLE_MODULES.w
	local logError = __DARKLUA_BUNDLE_MODULES.d

	local function New(className)
		return function(props)
			local ok, instance = pcall(Instance.new, className)

			if not ok then
				logError("cannotCreateClass", nil, className)
			end

			local classDefaults = defaultProps[className]

			if classDefaults ~= nil then
				for defaultProp, defaultValue in pairs(classDefaults) do
					instance[defaultProp] = defaultValue
				end
			end

			applyInstanceProps(props, instance)

			return instance
		end
	end

	__DARKLUA_BUNDLE_MODULES.x = New
end
do
	local applyInstanceProps = __DARKLUA_BUNDLE_MODULES.w

	local function Hydrate(target)
		return function(props)
			applyInstanceProps(props, target)

			return target
		end
	end

	__DARKLUA_BUNDLE_MODULES.y = Hydrate
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local xtypeof = __DARKLUA_BUNDLE_MODULES.s
	local Ref = {}

	Ref.type = "SpecialKey"
	Ref.kind = "Ref"
	Ref.stage = "observer"

	function Ref:apply(refState, applyTo, cleanupTasks)
		if xtypeof(refState) ~= "State" or refState.kind ~= "Value" then
			logError "invalidRefType"
		else
			refState:set(applyTo)
			table.insert(cleanupTasks, function()
				refState:set(nil)
			end)
		end
	end

	__DARKLUA_BUNDLE_MODULES.z = Ref
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local xtypeof = __DARKLUA_BUNDLE_MODULES.s

	local function Out(propertyName)
		local outKey = {}

		outKey.type = "SpecialKey"
		outKey.kind = "Out"
		outKey.stage = "observer"

		function outKey:apply(outState, applyTo, cleanupTasks)
			local ok, event = pcall(function()
				return applyTo.Changed
			end)

			if not ok then
				logError(
					"invalidOutProperty",
					nil,
					applyTo.ClassName,
					propertyName
				)
			elseif xtypeof(outState) ~= "State" or outState.kind ~= "Value" then
				logError "invalidOutType"
			else
				outState:set((applyTo)[propertyName])
				table.insert(
					cleanupTasks,
					event:connect(function(prop)
						if prop == propertyName then
							outState:set((applyTo)[propertyName])
						end
					end)
				)
				table.insert(cleanupTasks, function()
					outState:set(nil)
				end)
			end
		end

		return outKey
	end

	__DARKLUA_BUNDLE_MODULES.A = Out
end
do
	local Cleanup = {}

	Cleanup.type = "SpecialKey"
	Cleanup.kind = "Cleanup"
	Cleanup.stage = "observer"

	function Cleanup:apply(userTask, _, cleanupTasks)
		table.insert(cleanupTasks, userTask)
	end

	__DARKLUA_BUNDLE_MODULES.B = Cleanup
end
do
	local messages = __DARKLUA_BUNDLE_MODULES.c

	local function logWarn(messageID, ...)
		local formatString

		if messages[messageID] ~= nil then
			formatString = messages[messageID]
		else
			messageID = "unknownMessage"
			formatString = messages[messageID]
		end

		warn(
			string.format(
				"[Fusion] " .. formatString .. "\n(ID: " .. messageID .. ")",
				...
			)
		)
	end

	__DARKLUA_BUNDLE_MODULES.C = logWarn
end
do
	local logWarn = __DARKLUA_BUNDLE_MODULES.C
	local Observer = __DARKLUA_BUNDLE_MODULES.t
	local peek = __DARKLUA_BUNDLE_MODULES.v
	local isState = __DARKLUA_BUNDLE_MODULES.u
	local typeof = __DARKLUA_BUNDLE_MODULES.g
	local EXPERIMENTAL_AUTO_NAMING = false
	local Children = {}

	Children.type = "SpecialKey"
	Children.kind = "Children"
	Children.stage = "descendants"

	function Children:apply(propValue, applyTo, cleanupTasks)
		local newParented = {}
		local oldParented = {}
		local newDisconnects = {}
		local oldDisconnects = {}
		local updateQueued = false
		local queueUpdate

		local function updateChildren()
			if not updateQueued then
				return
			end

			updateQueued = false
			oldParented, newParented = newParented, oldParented
			oldDisconnects, newDisconnects = newDisconnects, oldDisconnects

			for i, _ in pairs(newParented) do
				newParented[i] = nil
			end
			for i, _ in pairs(newDisconnects) do
				newDisconnects[i] = nil
			end

			local function processChild(child, autoName)
				local childType = typeof(child)

				if childType == "Instance" then
					newParented[child] = true

					if oldParented[child] == nil then
						child.Parent = applyTo
					else
						oldParented[child] = nil
					end
					if EXPERIMENTAL_AUTO_NAMING and autoName ~= nil then
						child.Name = autoName
					end
				elseif isState(child) then
					local value = peek(child)

					if value ~= nil then
						processChild(value, autoName)
					end

					local disconnect = oldDisconnects[child]

					if disconnect == nil then
						disconnect = Observer(child):onChange(queueUpdate)
					else
						oldDisconnects[child] = nil
					end

					newDisconnects[child] = disconnect
				elseif childType == "table" then
					for key, subChild in pairs(child) do
						local keyType = typeof(key)
						local subAutoName = nil

						if keyType == "string" then
							subAutoName = key
						elseif keyType == "number" and autoName ~= nil then
							subAutoName = autoName .. "_" .. key
						end

						processChild(subChild, subAutoName)
					end
				else
					logWarn("unrecognisedChildType", childType)
				end
			end

			if propValue ~= nil then
				processChild(propValue)
			end

			for oldInstance in pairs(oldParented) do
				oldInstance.Parent = nil
			end
			for _, disconnect in pairs(oldDisconnects) do
				disconnect()
			end
		end

		queueUpdate = function()
			if not updateQueued then
				updateQueued = true

				coroutine.resume(coroutine.create(updateChildren))
			end
		end

		table.insert(cleanupTasks, function()
			propValue = nil
			updateQueued = true

			updateChildren()
		end)

		updateQueued = true

		updateChildren()
	end

	__DARKLUA_BUNDLE_MODULES.D = Children
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local typeof = __DARKLUA_BUNDLE_MODULES.g

	local function getProperty_unsafe(instance, property)
		return (instance)[property]
	end
	local function OnEvent(eventName)
		local eventKey = {}

		eventKey.type = "SpecialKey"
		eventKey.kind = "OnEvent"
		eventKey.stage = "observer"

		function eventKey:apply(callback, applyTo, cleanupTasks)
			local ok, event = pcall(getProperty_unsafe, applyTo, eventName)

			if not ok or typeof(event) ~= "RBXScriptSignal" then
				logError(
					"cannotConnectEvent",
					nil,
					applyTo.ClassName,
					eventName
				)
			elseif typeof(callback) ~= "function" then
				logError("invalidEventHandler", nil, eventName)
			else
				table.insert(cleanupTasks, event:connect(callback))
			end
		end

		return eventKey
	end

	__DARKLUA_BUNDLE_MODULES.E = OnEvent
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local typeof = __DARKLUA_BUNDLE_MODULES.g

	local function OnChange(propertyName)
		local changeKey = {}

		changeKey.type = "SpecialKey"
		changeKey.kind = "OnChange"
		changeKey.stage = "observer"

		function changeKey:apply(callback, applyTo, cleanupTasks)
			local ok, event = pcall(function()
				return applyTo.Changed
			end)

			if not ok then
				logError(
					"cannotConnectChange",
					nil,
					applyTo.ClassName,
					propertyName
				)
			elseif typeof(callback) ~= "function" then
				logError("invalidChangeHandler", nil, propertyName)
			else
				table.insert(
					cleanupTasks,
					event:connect(function(prop)
						if prop == propertyName then
							callback((applyTo)[propertyName])
						end
					end)
				)
			end
		end

		return changeKey
	end

	__DARKLUA_BUNDLE_MODULES.F = OnChange
end
do
	local function isSimilar(a, b)
		if type(a) == "table" then
			return false
		end

		return a == b
	end

	__DARKLUA_BUNDLE_MODULES.G = isSimilar
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local updateAll = __DARKLUA_BUNDLE_MODULES.k
	local isSimilar = __DARKLUA_BUNDLE_MODULES.G
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}

	function class:set(newValue, force)
		local oldValue = self._value

		if force or not isSimilar(oldValue, newValue) then
			self._value = newValue

			updateAll(self)
		end
	end
	function class:_peek()
		return self._value
	end
	function class:get()
		logError "stateGetWasRemoved"
	end

	local function Value(initialValue)
		local self = setmetatable({
			type = "State",
			kind = "Value",
			dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
			_value = initialValue,
		}, CLASS_METATABLE)

		return self
	end

	__DARKLUA_BUNDLE_MODULES.H = Value
end
do
	local messages = __DARKLUA_BUNDLE_MODULES.c

	local function logErrorNonFatal(messageID, errObj, ...)
		local formatString

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

		Spawn(function()
			error(errorString:gsub("\n", "\n    "), 0)
		end, ...)
	end

	__DARKLUA_BUNDLE_MODULES.I = logErrorNonFatal
end
do
	local function parseError(err)
		local trace = "Traceback not available"

		if debug and debug.traceback then
			trace = debug.traceback(nil, 2)
		end

		return {
			type = "Error",
			raw = err,
			message = err:gsub("^.+:%d+:%s*", ""),
			trace = trace,
		}
	end

	__DARKLUA_BUNDLE_MODULES.J = parseError
end
do
	local typeof = __DARKLUA_BUNDLE_MODULES.g

	local function needsDestruction(x)
		return typeof(x) == "Instance"
	end

	__DARKLUA_BUNDLE_MODULES.K = needsDestruction
end
do
	local isState = __DARKLUA_BUNDLE_MODULES.u

	local function makeUseCallback(dependencySet)
		local function use(target)
			if isState(target) then
				dependencySet[target] = true

				return (target):_peek()
			end

			return target
		end

		return use
	end

	__DARKLUA_BUNDLE_MODULES.L = makeUseCallback
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local logErrorNonFatal = __DARKLUA_BUNDLE_MODULES.I
	local logWarn = __DARKLUA_BUNDLE_MODULES.C
	local parseError = __DARKLUA_BUNDLE_MODULES.J
	local isSimilar = __DARKLUA_BUNDLE_MODULES.G
	local needsDestruction = __DARKLUA_BUNDLE_MODULES.K
	local makeUseCallback = __DARKLUA_BUNDLE_MODULES.L
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}

	function class:update()
		for dependency in pairs(self.dependencySet) do
			dependency.dependentSet[self] = nil
		end

		self._oldDependencySet, self.dependencySet =
			self.dependencySet, self._oldDependencySet

		for i, _ in pairs(self.dependencySet) do
			self.dependencySet[i] = nil
		end

		local use = makeUseCallback(self.dependencySet)
		local ok, newValue, newMetaValue = pcall(self._processor, use)

		if ok then
			if self._destructor == nil and needsDestruction(newValue) then
				logWarn "destructorNeededComputed"
			end
			if newMetaValue ~= nil then
				logWarn "multiReturnComputed"
			end

			local oldValue = self._value
			local similar = isSimilar(oldValue, newValue)

			if self._destructor ~= nil then
				self._destructor(oldValue)
			end

			self._value = newValue

			for dependency in pairs(self.dependencySet) do
				dependency.dependentSet[self] = true
			end

			return not similar
		else
			logErrorNonFatal("computedCallbackError", parseError(newValue))

			self._oldDependencySet, self.dependencySet =
				self.dependencySet, self._oldDependencySet

			for dependency in pairs(self.dependencySet) do
				dependency.dependentSet[self] = true
			end

			return false
		end
	end
	function class:_peek()
		return self._value
	end
	function class:get()
		logError "stateGetWasRemoved"
	end

	local function Computed(processor, destructor)
		local dependencySet = {}
		local self = setmetatable({
			type = "State",
			kind = "Computed",
			dependencySet = dependencySet,
			dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
			_oldDependencySet = {},
			_processor = processor,
			_destructor = destructor,
			_value = nil,
		}, CLASS_METATABLE)

		self:update()

		return self
	end

	__DARKLUA_BUNDLE_MODULES.M = Computed
end
do
	local parseError = __DARKLUA_BUNDLE_MODULES.J
	local logErrorNonFatal = __DARKLUA_BUNDLE_MODULES.I
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local logWarn = __DARKLUA_BUNDLE_MODULES.C
	local cleanup = __DARKLUA_BUNDLE_MODULES.r
	local needsDestruction = __DARKLUA_BUNDLE_MODULES.K
	local peek = __DARKLUA_BUNDLE_MODULES.v
	local makeUseCallback = __DARKLUA_BUNDLE_MODULES.L
	local isState = __DARKLUA_BUNDLE_MODULES.u
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}

	function class:update()
		local inputIsState = self._inputIsState
		local newInputTable = peek(self._inputTable)
		local oldInputTable = self._oldInputTable
		local keyIOMap = self._keyIOMap
		local meta = self._meta
		local didChange = false

		for dependency in pairs(self.dependencySet) do
			dependency.dependentSet[self] = nil
		end

		self._oldDependencySet, self.dependencySet =
			self.dependencySet, self._oldDependencySet

		for i, _ in pairs(self.dependencySet) do
			self.dependencySet[i] = nil
		end

		if inputIsState then
			self._inputTable.dependentSet[self] = true
			self.dependencySet[self._inputTable] = true
		end

		self._oldOutputTable, self._outputTable =
			self._outputTable, self._oldOutputTable

		local oldOutputTable = self._oldOutputTable
		local newOutputTable = self._outputTable

		for i, _ in pairs(newOutputTable) do
			newOutputTable[i] = nil
		end
		for newInKey, newInValue in pairs(newInputTable) do
			local keyData = self._keyData[newInKey]

			if keyData == nil then
				keyData = {
					dependencySet = setmetatable({}, WEAK_KEYS_METATABLE),
					oldDependencySet = setmetatable({}, WEAK_KEYS_METATABLE),
					dependencyValues = setmetatable({}, WEAK_KEYS_METATABLE),
				}
				self._keyData[newInKey] = keyData
			end

			local shouldRecalculate = oldInputTable[newInKey] ~= newInValue

			if shouldRecalculate == false then
				for dependency, oldValue in pairs(keyData.dependencyValues) do
					if oldValue ~= peek(dependency) then
						shouldRecalculate = true

						break
					end
				end
			end
			if shouldRecalculate then
				keyData.oldDependencySet, keyData.dependencySet =
					keyData.dependencySet, keyData.oldDependencySet

				for i, _ in pairs(keyData.dependencySet) do
					keyData.dependencySet[i] = nil
				end

				local use = makeUseCallback(keyData.dependencySet)
				local processOK, newOutKey, newOutValue, newMetaValue =
					pcall(self._processor, use, newInKey, newInValue)

				if processOK then
					if
						self._destructor == nil
						and (
							needsDestruction(newOutKey)
							or needsDestruction(newOutValue)
							or needsDestruction(newMetaValue)
						)
					then
						logWarn "destructorNeededForPairs"
					end
					if newOutputTable[newOutKey] ~= nil then
						local previousNewKey, previousNewValue

						for inKey, outKey in pairs(keyIOMap) do
							if outKey == newOutKey then
								previousNewValue = newInputTable[inKey]

								if previousNewValue ~= nil then
									previousNewKey = inKey

									break
								end
							end
						end

						if previousNewKey ~= nil then
							logError(
								"forPairsKeyCollision",
								nil,
								tostring(newOutKey),
								tostring(previousNewKey),
								tostring(previousNewValue),
								tostring(newInKey),
								tostring(newInValue)
							)
						end
					end

					local oldOutValue = oldOutputTable[newOutKey]

					if oldOutValue ~= newOutValue then
						local oldMetaValue = meta[newOutKey]

						if oldOutValue ~= nil then
							local destructOK, err = pcall(
								self._destructor or cleanup,
								newOutKey,
								oldOutValue,
								oldMetaValue
							)

							if not destructOK then
								logErrorNonFatal(
									"forPairsDestructorError",
									parseError(err)
								)
							end
						end

						oldOutputTable[newOutKey] = nil
					end

					oldInputTable[newInKey] = newInValue
					keyIOMap[newInKey] = newOutKey
					meta[newOutKey] = newMetaValue
					newOutputTable[newOutKey] = newOutValue
					didChange = true
				else
					keyData.oldDependencySet, keyData.dependencySet =
						keyData.dependencySet, keyData.oldDependencySet

					logErrorNonFatal(
						"forPairsProcessorError",
						parseError(newOutKey)
					)
				end
			else
				local storedOutKey = keyIOMap[newInKey]

				if newOutputTable[storedOutKey] ~= nil then
					local previousNewKey, previousNewValue

					for inKey, outKey in pairs(keyIOMap) do
						if storedOutKey == outKey then
							previousNewValue = newInputTable[inKey]

							if previousNewValue ~= nil then
								previousNewKey = inKey

								break
							end
						end
					end

					if previousNewKey ~= nil then
						logError(
							"forPairsKeyCollision",
							nil,
							tostring(storedOutKey),
							tostring(previousNewKey),
							tostring(previousNewValue),
							tostring(newInKey),
							tostring(newInValue)
						)
					end
				end

				newOutputTable[storedOutKey] = oldOutputTable[storedOutKey]
			end

			for dependency in pairs(keyData.dependencySet) do
				keyData.dependencyValues[dependency] = peek(dependency)
				self.dependencySet[dependency] = true
				dependency.dependentSet[self] = true
			end
		end
		for oldOutKey, oldOutValue in pairs(oldOutputTable) do
			if newOutputTable[oldOutKey] ~= oldOutValue then
				local oldMetaValue = meta[oldOutKey]

				if oldOutValue ~= nil then
					local destructOK, err = pcall(
						self._destructor or cleanup,
						oldOutKey,
						oldOutValue,
						oldMetaValue
					)

					if not destructOK then
						logErrorNonFatal(
							"forPairsDestructorError",
							parseError(err)
						)
					end
				end
				if newOutputTable[oldOutKey] == nil then
					meta[oldOutKey] = nil
					self._keyData[oldOutKey] = nil
				end

				didChange = true
			end
		end
		for key in pairs(oldInputTable) do
			if newInputTable[key] == nil then
				oldInputTable[key] = nil
				keyIOMap[key] = nil
			end
		end

		return didChange
	end
	function class:_peek()
		return self._outputTable
	end
	function class:get()
		logError "stateGetWasRemoved"
	end

	local function ForPairs(inputTable, processor, destructor)
		local inputIsState = isState(inputTable)
		local self = setmetatable({
			type = "State",
			kind = "ForPairs",
			dependencySet = {},
			dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
			_oldDependencySet = {},
			_processor = processor,
			_destructor = destructor,
			_inputIsState = inputIsState,
			_inputTable = inputTable,
			_oldInputTable = {},
			_outputTable = {},
			_oldOutputTable = {},
			_keyIOMap = {},
			_keyData = {},
			_meta = {},
		}, CLASS_METATABLE)

		self:update()

		return self
	end

	__DARKLUA_BUNDLE_MODULES.N = ForPairs
end
do
	local parseError = __DARKLUA_BUNDLE_MODULES.J
	local logErrorNonFatal = __DARKLUA_BUNDLE_MODULES.I
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local logWarn = __DARKLUA_BUNDLE_MODULES.C
	local cleanup = __DARKLUA_BUNDLE_MODULES.r
	local needsDestruction = __DARKLUA_BUNDLE_MODULES.K
	local peek = __DARKLUA_BUNDLE_MODULES.v
	local makeUseCallback = __DARKLUA_BUNDLE_MODULES.L
	local isState = __DARKLUA_BUNDLE_MODULES.u
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}

	function class:update()
		local inputIsState = self._inputIsState
		local newInputTable = peek(self._inputTable)
		local oldInputTable = self._oldInputTable
		local outputTable = self._outputTable
		local keyOIMap = self._keyOIMap
		local keyIOMap = self._keyIOMap
		local meta = self._meta
		local didChange = false

		for dependency in pairs(self.dependencySet) do
			dependency.dependentSet[self] = nil
		end

		self._oldDependencySet, self.dependencySet =
			self.dependencySet, self._oldDependencySet

		for i, _ in pairs(self.dependencySet) do
			self.dependencySet[i] = nil
		end

		if inputIsState then
			self._inputTable.dependentSet[self] = true
			self.dependencySet[self._inputTable] = true
		end

		for newInKey, value in pairs(newInputTable) do
			local keyData = self._keyData[newInKey]

			if keyData == nil then
				keyData = {
					dependencySet = setmetatable({}, WEAK_KEYS_METATABLE),
					oldDependencySet = setmetatable({}, WEAK_KEYS_METATABLE),
					dependencyValues = setmetatable({}, WEAK_KEYS_METATABLE),
				}
				self._keyData[newInKey] = keyData
			end

			local shouldRecalculate = oldInputTable[newInKey] == nil

			if shouldRecalculate == false then
				for dependency, oldValue in pairs(keyData.dependencyValues) do
					if oldValue ~= peek(dependency) then
						shouldRecalculate = true

						break
					end
				end
			end
			if shouldRecalculate then
				keyData.oldDependencySet, keyData.dependencySet =
					keyData.dependencySet, keyData.oldDependencySet

				for i, _ in pairs(keyData.dependencySet) do
					keyData.dependencySet[i] = nil
				end

				local use = makeUseCallback(keyData.dependencySet)
				local processOK, newOutKey, newMetaValue =
					pcall(self._processor, use, newInKey)

				if processOK then
					if
						self._destructor == nil
						and (
							needsDestruction(newOutKey)
							or needsDestruction(newMetaValue)
						)
					then
						logWarn "destructorNeededForKeys"
					end

					local oldInKey = keyOIMap[newOutKey]
					local oldOutKey = keyIOMap[newInKey]

					if
						oldInKey ~= newInKey
						and newInputTable[oldInKey] ~= nil
					then
						logError(
							"forKeysKeyCollision",
							nil,
							tostring(newOutKey),
							tostring(oldInKey),
							tostring(newOutKey)
						)
					end
					if
						oldOutKey ~= newOutKey
						and keyOIMap[oldOutKey] == newInKey
					then
						local oldMetaValue = meta[oldOutKey]
						local destructOK, err = pcall(
							self._destructor or cleanup,
							oldOutKey,
							oldMetaValue
						)

						if not destructOK then
							logErrorNonFatal(
								"forKeysDestructorError",
								parseError(err)
							)
						end

						keyOIMap[oldOutKey] = nil
						outputTable[oldOutKey] = nil
						meta[oldOutKey] = nil
					end

					oldInputTable[newInKey] = value
					meta[newOutKey] = newMetaValue
					keyOIMap[newOutKey] = newInKey
					keyIOMap[newInKey] = newOutKey
					outputTable[newOutKey] = value
					didChange = true
				else
					keyData.oldDependencySet, keyData.dependencySet =
						keyData.dependencySet, keyData.oldDependencySet

					logErrorNonFatal(
						"forKeysProcessorError",
						parseError(newOutKey)
					)
				end
			end

			for dependency in pairs(keyData.dependencySet) do
				keyData.dependencyValues[dependency] = peek(dependency)
				self.dependencySet[dependency] = true
				dependency.dependentSet[self] = true
			end
		end
		for outputKey, inputKey in pairs(keyOIMap) do
			if newInputTable[inputKey] == nil then
				local oldMetaValue = meta[outputKey]
				local destructOK, err =
					pcall(self._destructor or cleanup, outputKey, oldMetaValue)

				if not destructOK then
					logErrorNonFatal("forKeysDestructorError", parseError(err))
				end

				oldInputTable[inputKey] = nil
				meta[outputKey] = nil
				keyOIMap[outputKey] = nil
				keyIOMap[inputKey] = nil
				outputTable[outputKey] = nil
				self._keyData[inputKey] = nil
				didChange = true
			end
		end

		return didChange
	end
	function class:_peek()
		return self._outputTable
	end
	function class:get()
		logError "stateGetWasRemoved"
	end

	local function ForKeys(inputTable, processor, destructor)
		local inputIsState = isState(inputTable)
		local self = setmetatable({
			type = "State",
			kind = "ForKeys",
			dependencySet = {},
			dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
			_oldDependencySet = {},
			_processor = processor,
			_destructor = destructor,
			_inputIsState = inputIsState,
			_inputTable = inputTable,
			_oldInputTable = {},
			_outputTable = {},
			_keyOIMap = {},
			_keyIOMap = {},
			_keyData = {},
			_meta = {},
		}, CLASS_METATABLE)

		self:update()

		return self
	end

	__DARKLUA_BUNDLE_MODULES.O = ForKeys
end
do
	local parseError = __DARKLUA_BUNDLE_MODULES.J
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local logErrorNonFatal = __DARKLUA_BUNDLE_MODULES.I
	local logWarn = __DARKLUA_BUNDLE_MODULES.C
	local cleanup = __DARKLUA_BUNDLE_MODULES.r
	local needsDestruction = __DARKLUA_BUNDLE_MODULES.K
	local peek = __DARKLUA_BUNDLE_MODULES.v
	local makeUseCallback = __DARKLUA_BUNDLE_MODULES.L
	local isState = __DARKLUA_BUNDLE_MODULES.u
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}

	function class:update()
		local inputIsState = self._inputIsState
		local inputTable = peek(self._inputTable)
		local outputValues = {}
		local didChange = false

		self._oldValueCache, self._valueCache =
			self._valueCache, self._oldValueCache

		local newValueCache = self._valueCache
		local oldValueCache = self._oldValueCache

		for i, _ in pairs(newValueCache) do
			newValueCache[i] = nil
		end
		for dependency in pairs(self.dependencySet) do
			dependency.dependentSet[self] = nil
		end

		self._oldDependencySet, self.dependencySet =
			self.dependencySet, self._oldDependencySet

		for i, _ in pairs(self.dependencySet) do
			self.dependencySet[i] = nil
		end

		if inputIsState then
			self._inputTable.dependentSet[self] = true
			self.dependencySet[self._inputTable] = true
		end

		for inKey, inValue in pairs(inputTable) do
			local oldCachedValues = oldValueCache[inValue]
			local shouldRecalculate = oldCachedValues == nil
			local value, valueData, meta

			if type(oldCachedValues) == "table" and #oldCachedValues > 0 then
				local valueInfo =
					table.remove(oldCachedValues, #oldCachedValues)

				value = valueInfo.value
				valueData = valueInfo.valueData
				meta = valueInfo.meta

				if #oldCachedValues <= 0 then
					oldValueCache[inValue] = nil
				end
			elseif oldCachedValues ~= nil then
				oldValueCache[inValue] = nil
				shouldRecalculate = true
			end
			if valueData == nil then
				valueData = {
					dependencySet = setmetatable({}, WEAK_KEYS_METATABLE),
					oldDependencySet = setmetatable({}, WEAK_KEYS_METATABLE),
					dependencyValues = setmetatable({}, WEAK_KEYS_METATABLE),
				}
			end
			if shouldRecalculate == false then
				for dependency, oldValue in pairs(valueData.dependencyValues) do
					if oldValue ~= peek(dependency) then
						shouldRecalculate = true

						break
					end
				end
			end
			if shouldRecalculate then
				valueData.oldDependencySet, valueData.dependencySet =
					valueData.dependencySet, valueData.oldDependencySet

				for i, _ in pairs(valueData.dependencySet) do
					valueData.dependencySet[i] = nil
				end

				local use = makeUseCallback(valueData.dependencySet)
				local processOK, newOutValue, newMetaValue =
					pcall(self._processor, use, inValue)

				if processOK then
					if
						self._destructor == nil
						and (
							needsDestruction(newOutValue)
							or needsDestruction(newMetaValue)
						)
					then
						logWarn "destructorNeededForValues"
					end
					if value ~= nil then
						local destructOK, err =
							pcall(self._destructor or cleanup, value, meta)

						if not destructOK then
							logErrorNonFatal(
								"forValuesDestructorError",
								parseError(err)
							)
						end
					end

					value = newOutValue
					meta = newMetaValue
					didChange = true
				else
					valueData.oldDependencySet, valueData.dependencySet =
						valueData.dependencySet, valueData.oldDependencySet

					logErrorNonFatal(
						"forValuesProcessorError",
						parseError(newOutValue)
					)
				end
			end

			local newCachedValues = newValueCache[inValue]

			if newCachedValues == nil then
				newCachedValues = {}
				newValueCache[inValue] = newCachedValues
			end

			table.insert(newCachedValues, {
				value = value,
				valueData = valueData,
				meta = meta,
			})

			outputValues[inKey] = value

			for dependency in pairs(valueData.dependencySet) do
				valueData.dependencyValues[dependency] = peek(dependency)
				self.dependencySet[dependency] = true
				dependency.dependentSet[self] = true
			end
		end
		for _oldInValue, oldCachedValueInfo in pairs(oldValueCache) do
			for _, valueInfo in ipairs(oldCachedValueInfo) do
				local oldValue = valueInfo.value
				local oldMetaValue = valueInfo.meta
				local destructOK, err =
					pcall(self._destructor or cleanup, oldValue, oldMetaValue)

				if not destructOK then
					logErrorNonFatal(
						"forValuesDestructorError",
						parseError(err)
					)
				end

				didChange = true
			end
			for i, _ in pairs(oldCachedValueInfo) do
				oldCachedValueInfo[i] = nil
			end
		end

		self._outputTable = outputValues

		return didChange
	end
	function class:_peek()
		return self._outputTable
	end
	function class:get()
		logError "stateGetWasRemoved"
	end

	local function ForValues(inputTable, processor, destructor)
		local inputIsState = isState(inputTable)
		local self = setmetatable({
			type = "State",
			kind = "ForValues",
			dependencySet = {},
			dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
			_oldDependencySet = {},
			_processor = processor,
			_destructor = destructor,
			_inputIsState = inputIsState,
			_inputTable = inputTable,
			_outputTable = {},
			_valueCache = {},
			_oldValueCache = {},
		}, CLASS_METATABLE)

		self:update()

		return self
	end

	__DARKLUA_BUNDLE_MODULES.P = ForValues
end
do
	local TweenScheduler = __DARKLUA_BUNDLE_MODULES.l
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local logErrorNonFatal = __DARKLUA_BUNDLE_MODULES.I
	local xtypeof = __DARKLUA_BUNDLE_MODULES.s
	local peek = __DARKLUA_BUNDLE_MODULES.v
	local typeof = __DARKLUA_BUNDLE_MODULES.g
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}

	function class:update()
		local goalValue = peek(self._goalState)

		if goalValue == self._nextValue and not self._currentlyAnimating then
			return false
		end

		local tweenInfo = peek(self._tweenInfo)

		if typeof(tweenInfo) ~= "TweenInfo" then
			logErrorNonFatal("mistypedTweenInfo", nil, typeof(tweenInfo))

			return false
		end

		self._prevValue = self._currentValue
		self._nextValue = goalValue
		self._currentTweenStartTime = time()
		self._currentTweenInfo = tweenInfo

		local tweenDuration = tweenInfo.DelayTime + tweenInfo.Time

		if tweenInfo.Reverses then
			tweenDuration = tweenDuration + tweenInfo.Time
		end

		tweenDuration = tweenDuration * (tweenInfo.RepeatCount + 1)
		self._currentTweenDuration = tweenDuration

		TweenScheduler.add(self)

		return false
	end
	function class:_peek()
		return self._currentValue
	end
	function class:get()
		logError "stateGetWasRemoved"
	end

	local function Tween(goalState, tweenInfo)
		local currentValue = peek(goalState)

		if tweenInfo == nil then
			tweenInfo = TweenInfo.new()
		end

		local dependencySet = { [goalState] = true }
		local tweenInfoIsState = xtypeof(tweenInfo) == "State"

		if tweenInfoIsState then
			dependencySet[tweenInfo] = true
		end

		local startingTweenInfo = peek(tweenInfo)

		if typeof(startingTweenInfo) ~= "TweenInfo" then
			logError("mistypedTweenInfo", nil, typeof(startingTweenInfo))
		end

		local self = setmetatable({
			type = "State",
			kind = "Tween",
			dependencySet = dependencySet,
			dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
			_goalState = goalState,
			_tweenInfo = tweenInfo,
			_tweenInfoIsState = tweenInfoIsState,
			_prevValue = currentValue,
			_nextValue = currentValue,
			_currentValue = currentValue,
			_currentTweenInfo = tweenInfo,
			_currentTweenDuration = 0,
			_currentTweenStartTime = 0,
			_currentlyAnimating = false,
		}, CLASS_METATABLE)

		goalState.dependentSet[self] = true

		return self
	end

	__DARKLUA_BUNDLE_MODULES.Q = Tween
end
do
	local Oklab = __DARKLUA_BUNDLE_MODULES.f

	local function unpackType(value, typeString)
		if typeString == "number" then
			return { value }
		elseif typeString == "CFrame" then
			local axis, angle = value:ToAxisAngle()

			return {
				value.X,
				value.Y,
				value.Z,
				axis.X,
				axis.Y,
				axis.Z,
				angle,
			}
		elseif typeString == "Color3" then
			local lab = Oklab.to(value)

			return {
				lab.X,
				lab.Y,
				lab.Z,
			}
		elseif typeString == "ColorSequenceKeypoint" then
			local lab = Oklab.to(value.Value)

			return {
				lab.X,
				lab.Y,
				lab.Z,
				value.Time,
			}
		elseif typeString == "DateTime" then
			return {
				value.UnixTimestampMillis,
			}
		elseif typeString == "NumberRange" then
			return {
				value.Min,
				value.Max,
			}
		elseif typeString == "NumberSequenceKeypoint" then
			return {
				value.Value,
				value.Time,
				value.Envelope,
			}
		elseif typeString == "PhysicalProperties" then
			return {
				value.Density,
				value.Friction,
				value.Elasticity,
				value.FrictionWeight,
				value.ElasticityWeight,
			}
		elseif typeString == "Ray" then
			return {
				value.Origin.X,
				value.Origin.Y,
				value.Origin.Z,
				value.Direction.X,
				value.Direction.Y,
				value.Direction.Z,
			}
		elseif typeString == "Rect" then
			return {
				value.Min.X,
				value.Min.Y,
				value.Max.X,
				value.Max.Y,
			}
		elseif typeString == "Region3" then
			return {
				value.CFrame.X,
				value.CFrame.Y,
				value.CFrame.Z,
				value.Size.X,
				value.Size.Y,
				value.Size.Z,
			}
		elseif typeString == "Region3int16" then
			return {
				value.Min.X,
				value.Min.Y,
				value.Min.Z,
				value.Max.X,
				value.Max.Y,
				value.Max.Z,
			}
		elseif typeString == "UDim" then
			return {
				value.Scale,
				value.Offset,
			}
		elseif typeString == "UDim2" then
			return {
				value.X.Scale,
				value.X.Offset,
				value.Y.Scale,
				value.Y.Offset,
			}
		elseif typeString == "Vector2" then
			return {
				value.X,
				value.Y,
			}
		elseif typeString == "Vector2int16" then
			return {
				value.X,
				value.Y,
			}
		elseif typeString == "Vector3" then
			return {
				value.X,
				value.Y,
				value.Z,
			}
		elseif typeString == "Vector3int16" then
			return {
				value.X,
				value.Y,
				value.Z,
			}
		else
			return {}
		end
	end

	__DARKLUA_BUNDLE_MODULES.R = unpackType
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local logErrorNonFatal = __DARKLUA_BUNDLE_MODULES.I
	local unpackType = __DARKLUA_BUNDLE_MODULES.R
	local SpringScheduler = __DARKLUA_BUNDLE_MODULES.o
	local updateAll = __DARKLUA_BUNDLE_MODULES.k
	local xtypeof = __DARKLUA_BUNDLE_MODULES.s
	local peek = __DARKLUA_BUNDLE_MODULES.v
	local typeof = __DARKLUA_BUNDLE_MODULES.g
	local class = {}
	local CLASS_METATABLE = { __index = class }
	local WEAK_KEYS_METATABLE = {
		__mode = "k",
	}

	function class:setPosition(newValue)
		local newType = typeof(newValue)

		if newType ~= self._currentType then
			logError("springTypeMismatch", nil, newType, self._currentType)
		end

		self._springPositions = unpackType(newValue, newType)
		self._currentValue = newValue

		SpringScheduler.add(self)
		updateAll(self)
	end
	function class:setVelocity(newValue)
		local newType = typeof(newValue)

		if newType ~= self._currentType then
			logError("springTypeMismatch", nil, newType, self._currentType)
		end

		self._springVelocities = unpackType(newValue, newType)

		SpringScheduler.add(self)
	end
	function class:addVelocity(deltaValue)
		local deltaType = typeof(deltaValue)

		if deltaType ~= self._currentType then
			logError("springTypeMismatch", nil, deltaType, self._currentType)
		end

		local springDeltas = unpackType(deltaValue, deltaType)

		for index, delta in ipairs(springDeltas) do
			do
				local __DARKLUA_VAR = self._springVelocities

				__DARKLUA_VAR[index] = __DARKLUA_VAR[index] + delta
			end
		end

		SpringScheduler.add(self)
	end
	function class:update()
		local goalValue = peek(self._goalState)

		if goalValue == self._goalValue then
			local damping = peek(self._damping)

			if typeof(damping) ~= "number" then
				logErrorNonFatal("mistypedSpringDamping", nil, typeof(damping))
			elseif damping < 0 then
				logErrorNonFatal("invalidSpringDamping", nil, damping)
			else
				self._currentDamping = damping
			end

			local speed = peek(self._speed)

			if typeof(speed) ~= "number" then
				logErrorNonFatal("mistypedSpringSpeed", nil, typeof(speed))
			elseif speed < 0 then
				logErrorNonFatal("invalidSpringSpeed", nil, speed)
			else
				self._currentSpeed = speed
			end

			return false
		else
			self._goalValue = goalValue

			local oldType = self._currentType
			local newType = typeof(goalValue)

			self._currentType = newType

			local springGoals = unpackType(goalValue, newType)
			local numSprings = #springGoals

			self._springGoals = springGoals

			if newType ~= oldType then
				self._currentValue = self._goalValue

				local springPositions = {}

				for i = 1, numSprings do
					springPositions[i] = 0
				end

				local springVelocities = {}

				for i = 1, numSprings do
					springVelocities[i] = 0
				end

				for index, springGoal in ipairs(springGoals) do
					springPositions[index] = springGoal
				end

				self._springPositions = springPositions
				self._springVelocities = springVelocities

				SpringScheduler.remove(self)

				return true
			elseif numSprings == 0 then
				self._currentValue = self._goalValue

				return true
			else
				SpringScheduler.add(self)

				return false
			end
		end
	end
	function class:_peek()
		return self._currentValue
	end
	function class:get()
		logError "stateGetWasRemoved"
	end

	local function Spring(goalState, speed, damping)
		if speed == nil then
			speed = 10
		end
		if damping == nil then
			damping = 1
		end

		local dependencySet = { [goalState] = true }

		if xtypeof(speed) == "State" then
			dependencySet[speed] = true
		end
		if xtypeof(damping) == "State" then
			dependencySet[damping] = true
		end

		local self = setmetatable({
			type = "State",
			kind = "Spring",
			dependencySet = dependencySet,
			dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
			_speed = speed,
			_damping = damping,
			_goalState = goalState,
			_goalValue = nil,
			_currentType = nil,
			_currentValue = nil,
			_currentSpeed = peek(speed),
			_currentDamping = peek(damping),
			_springPositions = nil,
			_springGoals = nil,
			_springVelocities = nil,
		}, CLASS_METATABLE)

		goalState.dependentSet[self] = true

		self:update()

		return self
	end

	__DARKLUA_BUNDLE_MODULES.S = Spring
end
do
	local function doNothing() end

	__DARKLUA_BUNDLE_MODULES.T = doNothing
end
do
	local logError = __DARKLUA_BUNDLE_MODULES.d
	local TweenInfo = {}

	function TweenInfo.new(
		time,
		easingStyle,
		easingDirection,
		repeatCount,
		reverses,
		delayTime
	)
		local proxy = newproxy(true)
		local mt = getmetatable(proxy)

		if type(easingStyle) ~= "string" then
			if easingStyle then
				easingStyle = tostring(easingStyle):gsub("Enum.%w+.", "")
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
				logError("invalidEasingStyle", nil, easingStyle)
			end
		end
		if type(easingDirection) ~= "string" then
			if easingDirection then
				easingDirection =
					tostring(easingDirection):gsub("Enum.%w+.", "")
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
				logError("invalidEasingDirection", nil, easingDirection)
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
		mt.__newindex = function(_, prop)
			error(prop .. " cannot be assigned to", math.huge)
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
				.. easingDirection
				.. " EasingStyle:"
				.. easingStyle
		end
		mt.__metatable = "The metatable is locked"

		return proxy
	end

	__DARKLUA_BUNDLE_MODULES.U = TweenInfo
end

local restrictRead = __DARKLUA_BUNDLE_MODULES.e
local bindScheduler = __DARKLUA_BUNDLE_MODULES.p
local Fusion = restrictRead("Fusion", {
	version = {
		major = 0,
		minor = 3,
		isRelease = false,
	},
	New = __DARKLUA_BUNDLE_MODULES.x,
	Hydrate = __DARKLUA_BUNDLE_MODULES.y,
	Ref = __DARKLUA_BUNDLE_MODULES.z,
	Out = __DARKLUA_BUNDLE_MODULES.A,
	Cleanup = __DARKLUA_BUNDLE_MODULES.B,
	Children = __DARKLUA_BUNDLE_MODULES.D,
	OnEvent = __DARKLUA_BUNDLE_MODULES.E,
	OnChange = __DARKLUA_BUNDLE_MODULES.F,
	Value = __DARKLUA_BUNDLE_MODULES.H,
	Computed = __DARKLUA_BUNDLE_MODULES.M,
	ForPairs = __DARKLUA_BUNDLE_MODULES.N,
	ForKeys = __DARKLUA_BUNDLE_MODULES.O,
	ForValues = __DARKLUA_BUNDLE_MODULES.P,
	Observer = __DARKLUA_BUNDLE_MODULES.t,
	Tween = __DARKLUA_BUNDLE_MODULES.Q,
	Spring = __DARKLUA_BUNDLE_MODULES.S,
	cleanup = __DARKLUA_BUNDLE_MODULES.r,
	doNothing = __DARKLUA_BUNDLE_MODULES.T,
	peek = __DARKLUA_BUNDLE_MODULES.v,
	typeof = __DARKLUA_BUNDLE_MODULES.g,
	TweenInfo = __DARKLUA_BUNDLE_MODULES.U,
	Help = function()
		return "See https://elttob.uk/Fusion/0.3/ for more information."
	end,
})

bindScheduler()

return Fusion
