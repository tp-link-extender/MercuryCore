--!strict

--[[
	Linearly interpolates the given animatable types by a ratio.
	If the types are different or not animatable, then the first value will be
	returned for ratios below 0.5, and the second value for 0.5 and above.

	FIXME: This function uses a lot of redefinitions to suppress false positives
	from the Luau typechecker - ideally these wouldn't be required
]]

local Oklab = require "../Colour/Oklab"
local typeof = require "../../../Modules/Polyfill/typeof"

local function lerpType(from: any, to: any, ratio: number): any
	local typeString = typeof(from)

	if typeof(to) == typeString then
		-- both types must match for interpolation to make sense
		if typeString == "number" then
			return (to - from) * ratio + from
		elseif typeString == "CFrame" then
			return from:Lerp(to, ratio)
		elseif typeString == "Color3" then
			local fromLab = Oklab.to(from)
			local toLab = Oklab.to(to)
			return Oklab.from(fromLab:Lerp(toLab, ratio), false)
		-- elseif typeString == "ColorSequenceKeypoint" then
		-- 	local to, from =
		-- 		to :: ColorSequenceKeypoint, from :: ColorSequenceKeypoint
		-- 	local fromLab = Oklab.to(from.Value)
		-- 	local toLab = Oklab.to(to.Value)
		-- 	return ColorSequenceKeypoint.new(
		-- 		(to.Time - from.Time) * ratio + from.Time,
		-- 		Oklab.from(fromLab:Lerp(toLab, ratio), false)
		-- 	)
		-- elseif typeString == "DateTime" then
		-- 	local to, from = to :: DateTime, from :: DateTime
		-- 	return DateTime.fromUnixTimestampMillis(
		-- 		(to.UnixTimestampMillis - from.UnixTimestampMillis) * ratio
		-- 			+ from.UnixTimestampMillis
		-- 	)
		-- elseif typeString == "NumberRange" then
		-- 	local to, from = to :: NumberRange, from :: NumberRange
		-- 	return NumberRange.new(
		-- 		(to.Min - from.Min) * ratio + from.Min,
		-- 		(to.Max - from.Max) * ratio + from.Max
		-- 	)
		-- elseif typeString == "NumberSequenceKeypoint" then
		-- 	local to, from =
		-- 		to :: NumberSequenceKeypoint, from :: NumberSequenceKeypoint
		-- 	return NumberSequenceKeypoint.new(
		-- 		(to.Time - from.Time) * ratio + from.Time,
		-- 		(to.Value - from.Value) * ratio + from.Value,
		-- 		(to.Envelope - from.Envelope) * ratio + from.Envelope
		-- 	)
		-- elseif typeString == "PhysicalProperties" then
		-- 	local to, from =
		-- 		to :: PhysicalProperties, from :: PhysicalProperties
		-- 	return PhysicalProperties.new(
		-- 		(to.Density - from.Density) * ratio + from.Density,
		-- 		(to.Friction - from.Friction) * ratio + from.Friction,
		-- 		(to.Elasticity - from.Elasticity) * ratio + from.Elasticity,
		-- 		(to.FrictionWeight - from.FrictionWeight) * ratio
		-- 			+ from.FrictionWeight,
		-- 		(to.ElasticityWeight - from.ElasticityWeight) * ratio
		-- 			+ from.ElasticityWeight
		-- 	)
		elseif typeString == "Ray" then
			return Ray.new(
				from.Origin:Lerp(to.Origin, ratio),
				from.Direction:Lerp(to.Direction, ratio)
			)
		-- elseif typeString == "Rect" then
		-- 	local to, from = to :: Rect, from :: Rect
		-- 	return Rect.new(
		-- 		from.Min:Lerp(to.Min, ratio),
		-- 		from.Max:Lerp(to.Max, ratio)
		-- 	)
		elseif typeString == "Region3" then
			-- FUTURE: support rotated Region3s if/when they become constructable
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

	-- fallback case: the types are different or not animatable
	if ratio < 0.5 then
		return from
	end
	return to
end

return lerpType
