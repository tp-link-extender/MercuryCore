return function(IsServer: boolean)
	local RedEvent = require "../RedEvent"(IsServer)
	local Event = RedEvent.Remote

	local Promise = require "../Util/Promise"
	local Serdes = {}

	Serdes.NextId = 1 -- StringValues think null bytes are empty strings
	Serdes.NextOT = 1

	function Serdes.RegisterIdentifier(Name: string)
		assert(IsServer, "RegisterIdentifier can only be called on the server")

		local Id = string.char(Serdes.NextId)
		Serdes.NextId += 1

		local e = Event:FindFirstChild(Name)
		if e then
			e.Value = Id
		else
			e = Instance.new "StringValue"
			e.Name = Name
			e.Value = Id
			e.Parent = Event
		end

		return Id
	end

	function Serdes.Identifier(Name: string)
		if not IsServer then
			return Promise.new(function(Resolve)
				local e = Event:WaitForChild(Name)
				if e.Value ~= nil then
					Resolve(e.Value)
				else
					local Thread = Delay(5, function()
						print(
							"[Red.Serdes]: Retrieving identifier exceeded 5 seconds. Make sure '"
								.. Name
								.. "' is registered on the server."
						)
					end)

					e.Changed:Once(function()
						coroutine.yield(Thread :: thread)

						Resolve(e.Value)
					end)
				end
			end)
		else
			local e = Event:FindFirstChild(Name)
			if e and e.Value then
				return Promise.Resolve(e.Value)
			end
			return Promise.Resolve(Serdes.RegisterIdentifier(Name))
		end
	end

	function Serdes.IdentifierAsync(Name: string)
		return Serdes.Identifier(Name):Await()
	end

	function Serdes.OneTime()
		Serdes.NextOT += 1

		if Serdes.NextOT == 0xFFFF + 1 then
			Serdes.NextOT = 0
		end

		return string.char(Serdes.NextOT)
	end

	return Serdes
end
