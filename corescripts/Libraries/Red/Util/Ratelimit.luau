return function<T>(Limit: number, Interval: number)
	assert(Limit > 0, "Limit must be greater than 0")

	local CountMap = {} :: { [T]: number }
	local CountKeyless = 0

	return function(Key: T?)
		if Key then
			local Count = CountMap[Key]

			if Count == nil then
				Count = 0

				Delay(Interval, function()
					CountMap[Key] = nil
				end)
			end

			if Count >= Limit then
				return false
			end

			CountMap[Key] = Count + 1
		else
			if CountKeyless == 0 then
				Delay(Interval, function()
					CountKeyless = 0
				end)
			end

			if CountKeyless >= Limit then
				return false
			end

			CountKeyless += 1
		end

		return true
	end
end
