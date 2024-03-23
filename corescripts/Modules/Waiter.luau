-- Imagine a go waitgroup if it was good
return function(waitFunction: () -> ())
	return function(count: number)
		return {
			wait = function()
				repeat
					waitFunction()
				until count == 0
			end,
			finish = function()
				count -= 1
			end,
		}
	end
end
