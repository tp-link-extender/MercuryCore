--!strict

return function(IsServer: boolean)
	local RunService = game:GetService "RunService"

	local RedEvent = require "../RedEvent"(IsServer)
	local Remote = RedEvent.Remote

	local Serdes = require "./Serdes"(IsServer)

	local Spawn = require "../Util/Spawn"
	local Promise = require "../Util/Promise"
	local Clock = require "../Util/Clock"

	local Event = {}
	local nil_symbol = { __nil = true }

	Event.Callbacks = {} :: { [string]: ((...any) -> ...any)? }
	Event.Outgoing = {} :: any

	if not IsServer then
		Event.ActiveCalls = {}
	end

	function Event.Listen()
		-- debug.setmemorycategory "Red.Listen"
		if not IsServer then
			Remote.OnClientEvent:connect(
				function(SingleFire, MultipleFire, IncomingCall)
					-- debug.profilebegin "Red.Listen.Incoming"

					-- replace nil symbols with nil
					if SingleFire.__nil then
						SingleFire = nil
					end
					if MultipleFire.__nil then
						MultipleFire = nil
					end
					if IncomingCall.__nil then
						IncomingCall = nil
					end

					if SingleFire then
						-- debug.profilebegin "Red.Listen.Incoming.SingleFire"

						for EventId, Call in pairs(SingleFire) do
							local Callback = Event.Callbacks[EventId]

							local c = 0
							repeat -- bruh
								RunService.Stepped:wait()
								Callback = Event.Callbacks[EventId]
								c += 1
							until Callback or c > 500 -- random

							if Callback then
								if type(Call) == "table" then
									Spawn(Callback, unpack(Call))
								else
									Spawn(Callback, Call)
								end
							else
								print "[Red]: Callback not found!"
							end
						end

						-- debug.profileend()
					end

					if MultipleFire then
						-- debug.profilebegin "Red.Listen.Incoming.Fire"

						for EventId, Calls in pairs(MultipleFire) do
							local Callback = Event.Callbacks[EventId]

							if Callback then
								for _, Call in ipairs(Calls) do
									if type(Call) == "table" then
										Spawn(Callback, unpack(Call))
									else
										Spawn(Callback, Call)
									end
								end
							end
						end

						-- debug.profileend()
					end

					if IncomingCall then
						-- debug.profilebegin "Red.Listen.Incoming.Call"

						for _, Call in pairs(IncomingCall) do
							local CallId = table.remove(Call, 1)
							local Success = table.remove(Call, 1)

							if Event.ActiveCalls[CallId] then
								if Success then
									Event.ActiveCalls[CallId].Resolve(
										unpack(Call)
									)
								else
									Event.ActiveCalls[CallId].Reject(
										unpack(Call)
									)
								end

								Event.ActiveCalls[CallId] = nil
							end
						end

						-- debug.profileend()
					end

					-- debug.profileend()
				end
			)

			Clock.new(1 / 60, function()
				-- debug.profilebegin "Red.Listen.Outgoing"

				if not next(Event.Outgoing) then
					return
				end

				local SingleFire = {}
				local SendSingleFire = false

				if Event.Outgoing[1] then
					for EventId, Calls in pairs(Event.Outgoing[1]) do
						if #Calls == 1 then
							SingleFire[EventId] = Calls[1]
							Event.Outgoing[1][EventId] = nil

							SendSingleFire = true
						end
					end
				end

				-- nils cannot be sent properly across remoteevents in 2013,
				-- so we have to use a symbol to represent nil
				local sf = nil_symbol
				if SendSingleFire then
					sf = SingleFire
				end

				local eo1, eo2 = Event.Outgoing[1], Event.Outgoing[2]
				if eo1 == nil then
					eo1 = nil_symbol
				end
				if eo2 == nil then
					eo2 = nil_symbol
				end

				Remote:FireServer(sf, eo1, eo2)

				-- table.clear(Event.Outgoing)
				for i, _ in pairs(Event.Outgoing) do
					Event.Outgoing[i] = nil
				end

				-- debug.profileend()
			end)
			return
		end
		Remote.OnServerEvent:connect(
			function(Player, SingleFire, MultipleFire, IncomingCall)
				-- debug.profilebegin "Red.Listen.Incoming"

				-- replace nil symbols with nil
				if SingleFire.__nil then
					SingleFire = nil
				end
				if MultipleFire.__nil then
					MultipleFire = nil
				end
				if IncomingCall.__nil then
					IncomingCall = nil
				end

				if SingleFire then
					-- debug.profilebegin "Red.Listen.Incoming.SingleFire"

					for EventId, Call in pairs(SingleFire) do
						local Callback = Event.Callbacks[EventId]

						if Callback then
							if type(Call) == "table" then
								Spawn(Callback, Player, unpack(Call))
							else
								Spawn(Callback, Player, Call)
							end
						end
					end

					-- debug.profileend()
				end

				if MultipleFire then
					-- debug.profilebegin "Red.Listen.Incoming.MultipleFire"

					for EventId, Calls in pairs(MultipleFire) do
						local Callback = Event.Callbacks[EventId]

						if Callback then
							for _, Call in ipairs(Calls) do
								if type(Call) == "table" then
									Spawn(Callback, Player, unpack(Call))
								else
									Spawn(Callback, Player, Call)
								end
							end
						end
					end

					-- debug.profileend()
				end

				if IncomingCall then
					-- debug.profilebegin "Red.Listen.Incoming.Call"

					for EventId, Calls in pairs(IncomingCall) do
						if Event.Callbacks[EventId] then
							for _, Call in ipairs(Calls) do
								Spawn(function()
									local CallId = table.remove(Call, 1)
									local Result = {
										CallId,
										pcall(
											Event.Callbacks[EventId],
											Player,
											unpack(Call)
										),
									}

									if Event.Outgoing[Player] == nil then
										Event.Outgoing[Player] = {}
									end

									if Event.Outgoing[Player][2] == nil then
										Event.Outgoing[Player][2] = {}
									end

									table.insert(
										Event.Outgoing[Player][2],
										Result
									)
								end)
							end
						else
							if Event.Outgoing[Player] == nil then
								Event.Outgoing[Player] = {}
							end

							if Event.Outgoing[Player][2] == nil then
								Event.Outgoing[Player][2] = {}
							end

							for _, Call in ipairs(Calls) do
								table.insert(Event.Outgoing[Player][2], {
									Call[1],
									false,
									"[Red]: Event not found",
								})
							end
						end
					end

					-- debug.profileend()
				end

				-- debug.profileend()
			end
		)

		RunService.Heartbeat:connect(function()
			-- debug.profilebegin "Red.Listen.Outgoing"

			for Player, Packets in pairs(Event.Outgoing) do
				local SingleCall = {}
				local SendSingleCall = false

				if Packets[1] then
					for EventId, Calls in pairs(Packets[1]) do
						if #Calls == 1 then
							SingleCall[EventId] = Calls[1]
							Packets[1][EventId] = nil

							SendSingleCall = true
						end
					end
				end

				-- nils cannot be sent properly across remoteevents in 2013,
				-- so we have to use a symbol to represent nil
				local sc = nil_symbol
				if SendSingleCall then
					sc = SingleCall
				end

				local p1, p2 = Packets[1], Packets[2]

				if p1 == nil then
					p1 = nil_symbol
				end
				if p2 == nil then
					p2 = nil_symbol
				end

				Remote:FireClient(Player, sc, p1, p2)
			end

			-- table.clear(Event.Outgoing)
			for i, _ in pairs(Event.Outgoing) do
				Event.Outgoing[i] = nil
			end

			-- debug.profileend()
		end)
	end

	function Event.AddQueue(Queue: { any }, Call: { any })
		local Length = #Call

		if Length == 1 then
			local Type = type(Call[1])

			if Type ~= "table" then
				table.insert(Queue, Call[1])
			else
				table.insert(Queue, Call)
			end
		else
			table.insert(Queue, Call)
		end
	end

	function Event.FireClient(Player: Player, EventName: string, ...)
		assert(IsServer, "Event.FireClient can only be called from the server")

		local EventId = Serdes.IdentifierAsync(EventName)

		if Event.Outgoing[Player] == nil then
			Event.Outgoing[Player] = {}
		end

		if Event.Outgoing[Player][1] == nil then
			Event.Outgoing[Player][1] = {}
		end

		if Event.Outgoing[Player][1][EventId] == nil then
			Event.Outgoing[Player][1][EventId] = {}
		end

		Event.AddQueue(Event.Outgoing[Player][1][EventId], { ... })
	end

	function Event.FireServer(EventName: string, ...)
		assert(
			not IsServer,
			"Event.FireServer can only be called on the client"
		)

		local Args = { ... }

		return Serdes.Identifier(EventName):Then(function(EventId)
			if Event.Outgoing[1] == nil then
				Event.Outgoing[1] = {}
			end

			if Event.Outgoing[1][EventId] == nil then
				Event.Outgoing[1][EventId] = {}
			end

			Event.AddQueue(Event.Outgoing[1][EventId], Args)
		end)
	end

	function Event.Call(EventName: string, ...)
		assert(not IsServer, "Event.Call can only be called on the client")

		local Args = { ... }

		return Promise.new(function(Resolve, Reject)
			local CallId = Serdes.OneTime()
			local EventId = Serdes.IdentifierAsync(EventName)

			if Event.Outgoing[2] == nil then
				Event.Outgoing[2] = {}
			end

			if Event.Outgoing[2][EventId] == nil then
				Event.Outgoing[2][EventId] = {}
			end

			table.insert(Args, 1, CallId)
			table.insert(Event.Outgoing[2][EventId], Args)

			Event.ActiveCalls[CallId] = {
				Resolve = Resolve,
				Reject = Reject,
			}
		end)
	end

	function Event.SetCallback(EventName: string, Callback: ((...any) -> any)?)
		return Serdes.Identifier(EventName):Then(function(EventId)
			Event.Callbacks[EventId] = Callback
		end)
	end

	return Event
end
