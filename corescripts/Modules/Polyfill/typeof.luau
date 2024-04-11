--!strict
-- A basic polyfill for the typeof function

return function(value: any): string
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

	-- Will short-circuit
	local tests = {
		{
			Type = "Instance",
			Props = { "ClassName" },
		},
		{
			Type = "EnumItem",
			Props = { "EnumType", "Name", "Value" },
		},
		{
			Type = "Enum",
			Props = { "GetEnumItems" },
		},
		{
			Type = "Enums",
			Props = { "MembershipType" }, -- lmao
		},
		{
			Type = "RBXScriptSignal",
			Props = {
				"connect",
				-- "connected",
				-- "connectFirst",
				-- "connectLast",
				"wait",
			},
		},
		{
			Type = "RBXScriptConnection",
			Props = {
				"connected",
				"disconnect",
			},
		},
		{
			Type = "TweenInfo",
			Props = {
				"EasingDirection",
				-- "Time",
				-- "DelayTime",
				"RepeatCount",
				"EasingStyle",
				-- "Reverses",
			},
		},
		{
			Type = "CFrame",
			Props = {
				"p",
				"x",
				"y",
				"z",
				"lookVector",
			},
		},
		{
			Type = "Vector3",
			Props = {
				"Lerp",
				-- "Cross",
				-- "Dot",
				"unit",
				"magnitude",
				"x",
				"y",
				"z",
			},
		},
		{
			Type = "Vector3int16",
			Props = { "z", "x", "y" },
		},
		{
			Type = "Vector2",
			Props = { "unit", "magnitude", "x", "y" },
		},
		{
			Type = "Vector2int16",
			Props = { "x", "y" },
		},
		{
			Type = "Region3",
			Props = { "CFrame", "Size" },
		},
		{
			Type = "Region3int16",
			Props = { "Min", "Max" },
		},
		{
			Type = "Ray",
			Props = {
				"Origin",
				"Direction",
				"Unit",
				"ClosestPoint",
				"Distance",
			},
		},
		{
			Type = "UDim",
			Props = { "Scale", "Offset" },
		},
		{
			Type = "Axes",
			Props = { "Z", "X", "Y" },
		},
		{
			Type = "UDim2",
			Props = { "X", "Y" },
		},
		{
			Type = "BrickColor",
			Props = {
				"Number",
				"Name",
				"Color",
				"r",
				"g",
				"b",
			},
		},
		{
			Type = "Color3",
			Props = { "r", "g", "b" },
		},
		{
			Type = "Faces",
			Props = {
				"Right",
				"Top",
				"Back",
				-- "Left",
				-- "Bottom",
				-- "Front",
			},
		},
	}

	for _, v in ipairs(tests) do
		local t, test = v.Type, v.Props

		local ok, result = pcall(function()
			for _, prop in ipairs(test) do
				if value[prop] == nil then
					return false
				end
				-- Cannot throw if the property does not exist,
				-- as userdatas may allow nil indexing
			end
			return true
		end)

		if ok and result then
			return t
		end
	end

	return basicType
end
