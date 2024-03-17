-- You know what this is guyz
-- HELIODEX'S BASIC NEW FUNCTION

return function(className: InstanceName | Instance)
	local obj
	if type(className) == "string" then
		obj = Instance.new(className)
	else
		obj = className
	end

	local parent = nil

	return function(props: { [string]: any })
		for k, v in pairs(props) do
			if type(k) == "string" then
				if k == "Parent" then
					parent = v
				else
					obj[k] = v
				end
			elseif type(k) == "number" and type(v) == "userdata" then
				v.Parent = obj
			end
		end

		obj.Parent = parent

		return obj
	end
end
