local function Red(Script)
	local _SERVER, _CLIENT

	if Script:IsA "LocalScript" then
		_CLIENT = true
	elseif Script:IsA "Script" then
		_SERVER = true
	else
		error("Argument must be the script itself", 2)
	end

	local success, result = ypcall(function()
		local __DARKLUA_BUNDLE_MODULES = {}

		do
			local ReplicatedStorage = game:GetService "ReplicatedStorage"
			local Players = game:GetService "Players"
			local RedEvent = {}
			local Remote, ClientFolder

			if _SERVER then
				Remote = Instance.new "RemoteEvent"
				Remote.Name = "RedEvent"
				Remote.Parent = ReplicatedStorage

				local function PlayerAdded(Player)
					ClientFolder = Instance.new "ScreenGui"
					ClientFolder.Name = "Red"
					ClientFolder.Parent = Player:FindFirstChild "PlayerGui"
				end

				Players.PlayerAdded:connect(PlayerAdded)

				for _, Player in ipairs(Players:GetPlayers()) do
					PlayerAdded(Player)
				end
			else
				Remote = ReplicatedStorage:WaitForChild "RedEvent"
				ClientFolder = (Players.LocalPlayer:FindFirstChild "PlayerGui"):WaitForChild "Red"
				ClientFolder.Parent = nil
			end

			RedEvent.Remote = Remote
			RedEvent.ClientFolder = ClientFolder
			__DARKLUA_BUNDLE_MODULES.a = RedEvent
		end
		do
			local FreeThread = nil

			local function FunctionPasser(fn, ...)
				local AquiredThread = FreeThread

				FreeThread = nil

				fn(...)

				FreeThread = AquiredThread
			end
			local function Yielder()
				while true do
					FunctionPasser(coroutine.yield())
				end
			end

			__DARKLUA_BUNDLE_MODULES.b = function(fn, ...)
				if not FreeThread then
					FreeThread = coroutine.create(Yielder)

					coroutine.resume(FreeThread)
				end

				coroutine.resume(FreeThread, fn, ...)
			end
		end
		do
			local RunService = game:GetService "RunService"
			local Spawn = __DARKLUA_BUNDLE_MODULES.b
			local Promise = {}

			Promise.__index = Promise

			function Promise.Promise(Callback)
				local self = setmetatable({}, Promise)

				self.Status = "Pending"
				self.OnResolve = {}
				self.OnReject = {}
				self.Value = {}
				self.Thread = nil
				self.Thread = coroutine.create(function()
					local ok, err = ypcall(Callback, function(...)
						self:_Resolve(...)
					end, function(...)
						self:_Reject(...)
					end)

					if not ok then
						self:_Reject(err)
					end
				end)

				coroutine.resume(self.Thread)

				return self
			end

			Promise.new = Promise.Promise

			function Promise.Resolve(...)
				local self = setmetatable({}, Promise)

				self.Status = "Resolved"
				self.OnResolve = {}
				self.OnReject = {}
				self.Value = { ... }
				self.Thread = nil

				return self
			end
			function Promise.Reject(...)
				local self = setmetatable({}, Promise)

				self.Status = "Rejected"
				self.OnResolve = {}
				self.OnReject = {}
				self.Value = { ... }
				self.Thread = nil

				return self
			end
			function Promise._Resolve(self, ...)
				assert(
					self.Status == "Pending",
					"Cannot resolve a promise that is not pending."
				)

				self.Status = "Resolved"
				self.Value = { ... }

				for _, Callback in ipairs(self.OnResolve) do
					Spawn(Callback, ...)
				end

				coroutine.resume(coroutine.create(function()
					coroutine.yield(self.Thread)
				end))
			end
			function Promise._Reject(self, ...)
				assert(
					self.Status == "Pending",
					"Cannot reject a promise that is not pending."
				)

				self.Status = "Rejected"
				self.Value = { ... }

				for _, Callback in ipairs(self.OnReject) do
					Spawn(Callback, ...)
				end

				coroutine.resume(coroutine.create(function()
					coroutine.yield(self.Thread)
				end))
			end
			function Promise.Then(self, OnResolve, OnReject)
				return Promise.Promise(function(Resolve, Reject)
					local function PromiseResolutionProcedure(Value, ...)
						if
							type(Value) == "table"
							and getmetatable(Value) == Promise
						then
							if Value.Status == "Pending" then
								table.insert(Value.OnResolve, Resolve)
								table.insert(Value.OnReject, Reject)
							elseif Value.Status == "Resolved" then
								Resolve(Value.Value)
							elseif Value.Status == "Rejected" then
								Reject(Value.Value)
							end
						else
							Resolve(Value, ...)
						end
					end

					if self.Status == "Pending" then
						if OnResolve then
							table.insert(self.OnResolve, function(...)
								PromiseResolutionProcedure(OnResolve(...))
							end)
						else
							table.insert(
								self.OnResolve,
								PromiseResolutionProcedure
							)
						end
						if OnReject then
							table.insert(self.OnReject, function(...)
								PromiseResolutionProcedure(OnReject(...))
							end)
						else
							table.insert(self.OnReject, Reject)
						end
					elseif self.Status == "Resolved" then
						if OnResolve then
							PromiseResolutionProcedure(
								OnResolve(unpack(self.Value))
							)
						else
							Resolve(unpack(self.Value))
						end
					elseif self.Status == "Rejected" then
						if OnReject then
							PromiseResolutionProcedure(
								OnReject(unpack(self.Value))
							)
						else
							Reject(unpack(self.Value))
						end
					end
				end)
			end
			function Promise.Catch(self, OnReject)
				return self:Then(nil, OnReject)
			end
			function Promise.Finally(self, Finally)
				return self:Then(function(...)
					Finally()

					return ...
				end, function(Error)
					Finally()
					error(Error)
				end)
			end
			function Promise.Await(self)
				if self.Status == "Resolved" then
					return unpack(self.Value)
				elseif self.Status == "Rejected" then
					return error(unpack(self.Value))
				end

				local c = 0

				repeat
					RunService.Stepped:wait()

					c = c + 1
				until self.Status ~= "Pending" or c > 500

				local Current = coroutine.running()

				local function Resume()
					coroutine.resume(Current)
				end

				table.insert(self.OnResolve, Resume)
				table.insert(self.OnReject, Resume)
				coroutine.yield()

				if self.Status == "Resolved" then
					return unpack(self.Value)
				end

				return error(unpack(self.Value))
			end

			__DARKLUA_BUNDLE_MODULES.c = Promise
		end
		do
			local RedEvent = __DARKLUA_BUNDLE_MODULES.a
			local Event = RedEvent.Remote
			local Promise = __DARKLUA_BUNDLE_MODULES.c
			local Serdes = {}

			Serdes.NextId = 1
			Serdes.NextOT = 1

			function Serdes.RegisterIdentifier(Name)
				assert(
					_SERVER,
					"RegisterIdentifier can only be called on the server"
				)

				local Id = string.char(Serdes.NextId)

				Serdes.NextId = Serdes.NextId + 1

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
			function Serdes.Identifier(Name)
				local e

				if _CLIENT then
					return Promise.new(function(Resolve)
						e = Event:WaitForChild(Name)

						if e.Value ~= nil then
							Resolve(e.Value)
						else
							local Thread = Delay(5, function()
								print(
									[[[Red.Serdes]: Retrieving identifier exceeded 5 seconds. Make sure ']]
										.. Name
										.. "' is registered on the server."
								)
							end)

							e.Changed:Once(function()
								coroutine.yield(Thread)
								Resolve(e.Value)
							end)
						end
					end)
				else
					e = Event:FindFirstChild(Name)

					if e and e.Value then
						return Promise.Resolve(e.Value)
					end

					return Promise.Resolve(Serdes.RegisterIdentifier(Name))
				end
			end
			function Serdes.IdentifierAsync(Name)
				return Serdes.Identifier(Name):Await()
			end
			function Serdes.OneTime()
				Serdes.NextOT = Serdes.NextOT + 1

				if Serdes.NextOT == 0xffff + 1 then
					Serdes.NextOT = 0
				end

				return string.char(Serdes.NextOT)
			end

			__DARKLUA_BUNDLE_MODULES.d = Serdes
		end
		do
			local RunService = game:GetService "RunService"

			local function MakeHeartbeatFunction(Clock)
				return function(Delta)
					Clock:Advance(Delta)
				end
			end

			local Clock = {}

			Clock.__index = Clock

			function Clock.Clock(Interval, Callback)
				local self = setmetatable({}, Clock)

				self.Interval = Interval
				self.Callback = Callback
				self.Delta = 0
				self.Connection =
					RunService.Heartbeat:connect(MakeHeartbeatFunction(self))

				return self
			end

			Clock.new = Clock.Clock

			function Clock.Pause(self)
				if self.Connection then
					self.Connection:Disconnect()
				end
			end
			function Clock.Resume(self)
				if self.Connection.Connected then
					return
				end

				self.Connection =
					RunService.Heartbeat:connect(MakeHeartbeatFunction(self))
			end
			function Clock.Advance(self, Delta)
				self.Delta = self.Delta + Delta

				if self.Delta >= self.Interval * 10 then
					local Skipped = math.floor(self.Delta / self.Interval)

					self.Delta = self.Delta - Skipped * self.Interval

					return
				end
				if self.Delta >= self.Interval then
					self.Delta = self.Delta - self.Interval

					self.Callback()
				end
			end

			__DARKLUA_BUNDLE_MODULES.e = Clock
		end
		do
			__DARKLUA_BUNDLE_MODULES.f = __DARKLUA_BUNDLE_MODULES.e
		end
		do
			local RunService = game:GetService "RunService"
			local RedEvent = __DARKLUA_BUNDLE_MODULES.a
			local Remote = RedEvent.Remote
			local Serdes = __DARKLUA_BUNDLE_MODULES.d
			local Spawn = __DARKLUA_BUNDLE_MODULES.b
			local Promise = __DARKLUA_BUNDLE_MODULES.c
			local Clock = __DARKLUA_BUNDLE_MODULES.f
			local Event = {}
			local nil_symbol = { __nil = true }

			Event.Callbacks = {}
			Event.Outgoing = {}

			if _CLIENT then
				Event.ActiveCalls = {}
			end

			function Event.Listen()
				if _CLIENT then
					Remote.OnClientEvent:connect(
						function(SingleFire, MultipleFire, IncomingCall)
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
								for EventId, Call in pairs(SingleFire) do
									local Callback = Event.Callbacks[EventId]
									local c = 0

									repeat
										RunService.Stepped:wait()

										Callback = Event.Callbacks[EventId]
										c = c + 1
									until Callback or c > 500

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
							end
							if MultipleFire then
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
							end
							if IncomingCall then
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
							end
						end
					)
					Clock.new(1 / 60, function()
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

						for i, _ in pairs(Event.Outgoing) do
							Event.Outgoing[i] = nil
						end
					end)
				else
					Remote.OnServerEvent:connect(
						function(Player, SingleFire, MultipleFire, IncomingCall)
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
								for EventId, Call in pairs(SingleFire) do
									local Callback = Event.Callbacks[EventId]

									if Callback then
										if type(Call) == "table" then
											Spawn(
												Callback,
												Player,
												unpack(Call)
											)
										else
											Spawn(Callback, Player, Call)
										end
									end
								end
							end
							if MultipleFire then
								for EventId, Calls in pairs(MultipleFire) do
									local Callback = Event.Callbacks[EventId]

									if Callback then
										for _, Call in ipairs(Calls) do
											if type(Call) == "table" then
												Spawn(
													Callback,
													Player,
													unpack(Call)
												)
											else
												Spawn(Callback, Player, Call)
											end
										end
									end
								end
							end
							if IncomingCall then
								for EventId, Calls in pairs(IncomingCall) do
									if Event.Callbacks[EventId] then
										for _, Call in ipairs(Calls) do
											Spawn(function()
												local CallId =
													table.remove(Call, 1)
												local Result = {
													CallId,
													pcall(
														Event.Callbacks[EventId],
														Player,
														unpack(Call)
													),
												}

												if
													Event.Outgoing[Player]
													== nil
												then
													Event.Outgoing[Player] = {}
												end
												if
													Event.Outgoing[Player][2]
													== nil
												then
													Event.Outgoing[Player][2] =
														{}
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
											table.insert(
												Event.Outgoing[Player][2],
												{
													Call[1],
													false,
													"[Red]: Event not found",
												}
											)
										end
									end
								end
							end
						end
					)
					RunService.Heartbeat:connect(function()
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
						for i, _ in pairs(Event.Outgoing) do
							Event.Outgoing[i] = nil
						end
					end)
				end
			end
			function Event.AddQueue(Queue, Call)
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
			function Event.FireClient(Player, EventName, ...)
				assert(
					not _CLIENT,
					"Event.FireClient can only be called from the server"
				)

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
			function Event.FireServer(EventName, ...)
				assert(
					_CLIENT,
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
			function Event.Call(EventName, ...)
				assert(_CLIENT, "Event.Call can only be called on the client")

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
			function Event.SetCallback(EventName, Callback)
				return Serdes.Identifier(EventName):Then(function(EventId)
					Event.Callbacks[EventId] = Callback
				end)
			end

			__DARKLUA_BUNDLE_MODULES.g = Event
		end
		do
			local Players = game:GetService "Players"
			local RedEvent = __DARKLUA_BUNDLE_MODULES.a
			local Remote = RedEvent.Remote
			local ClientFolder = RedEvent.ClientFolder
			local Serdes = __DARKLUA_BUNDLE_MODULES.d
			local Event = __DARKLUA_BUNDLE_MODULES.g
			local Server = {}

			Server.__index = Server

			function Server.Server(Name)
				local self = setmetatable({}, Server)

				self.Name = Name
				self.FolderInstance = nil

				return self
			end

			Server.new = Server.Server

			function Server.Fire(self, Player, EventName, ...)
				Event.FireClient(Player, self.Name .. "_" .. EventName, ...)
			end
			function Server.FireAll(self, EventName, ...)
				for _, Player in ipairs(Players:GetPlayers()) do
					self:Fire(Player, EventName, ...)
				end
			end
			function Server.FireAllExcept(self, Player, EventName, ...)
				for _, OtherPlayer in ipairs(Players:GetPlayers()) do
					if OtherPlayer ~= Player then
						self:Fire(OtherPlayer, EventName, ...)
					end
				end
			end
			function Server.FireList(self, PlayerList, EventName, ...)
				for _, Player in ipairs(PlayerList) do
					self:Fire(Player, EventName, ...)
				end
			end
			function Server.FireWithFilter(self, Filter, EventName, ...)
				for _, Player in ipairs(Players:GetPlayers()) do
					if Filter(Player) then
						self:Fire(Player, EventName, ...)
					end
				end
			end
			function Server.On(self, EventName, Callback)
				Event.SetCallback(self.Name .. "_" .. EventName, Callback)
			end
			function Server.Folder(self, Player)
				if Player then
					ClientFolder = (Player:FindFirstChild "PlayerGui").Red

					if ClientFolder:FindFirstChild(self.Name) then
						return ClientFolder:FindFirstChild(self.Name)
					else
						local Folder = Instance.new "Model"

						Folder.Name = self.Name
						Folder.Parent = ClientFolder

						return Folder
					end
				else
					if not self.FolderInstance then
						local Folder = Instance.new "Model"

						Folder.Name = self.Name
						Folder.Parent = Remote
						self.FolderInstance = Folder
					end

					return self.FolderInstance
				end
			end

			local Client = {}

			Client.__index = Client

			function Client.Client(Name)
				local self = setmetatable({}, Client)

				self.Name = Name
				self.FolderInstance = nil
				self.LocalFolderInstance = nil

				return self
			end

			Client.new = Client.Client

			function Client.Fire(self, EventName, ...)
				return Event.FireServer(self.Name .. "_" .. EventName, ...)
			end
			function Client.Call(self, EventName, ...)
				return Event.Call(self.Name .. "_" .. EventName, ...)
			end
			function Client.On(self, EventName, Callback)
				return Event.SetCallback(
					self.Name .. "_" .. EventName,
					Callback
				)
			end
			function Client.Folder(self)
				if not self.FolderInstance then
					self.FolderInstance = Remote:WaitForChild(self.Name)
				end

				return self.FolderInstance
			end
			function Client.LocalFolder(self)
				if not self.LocalFolderInstance then
					self.LocalFolderInstance =
						ClientFolder:WaitForChild(self.Name)
				end

				return self.LocalFolderInstance
			end

			local Net = {}

			Net.ServerNamespaceList = {}
			Net.ClientNamespaceList = {}

			function Net.Server(Name, Definitions)
				assert(_SERVER, "Net.Server can only be used on the server")

				if not Net.ServerNamespaceList[Name] then
					Net.ServerNamespaceList[Name] = Server.Server(Name)
				end
				if Definitions then
					for _, Term in ipairs(Definitions) do
						Serdes.Identifier(Name .. "_" .. Term)
					end
				end

				return Net.ServerNamespaceList[Name]
			end
			function Net.Client(Name)
				assert(_CLIENT, "Net.Client can only be used on the client")

				if Net.ClientNamespaceList[Name] == nil then
					Net.ClientNamespaceList[Name] = Client.Client(Name)
				end

				return Net.ClientNamespaceList[Name]
			end
			function Net.Identifier(Name)
				return Serdes.Identifier(Name)
			end

			Event.Listen()

			__DARKLUA_BUNDLE_MODULES.h = Net
		end
		do
			local CollectionService = game:GetService "CollectionService"
			local Spawn = __DARKLUA_BUNDLE_MODULES.b

			__DARKLUA_BUNDLE_MODULES.i = function(Tag, Start, Stop)
				local InstanceMap = {}

				for _, Instance in ipairs(CollectionService:GetTagged(Tag)) do
					Spawn(function()
						InstanceMap[Instance] = {
							Start(Instance),
						}
					end)
				end

				local AddConnection = CollectionService
					:GetInstanceAddedSignal(Tag)
					:connect(function(Instance)
						InstanceMap[Instance] = {
							Start(Instance),
						}
					end)
				local RemoveConnection = CollectionService
					:GetInstanceRemovedSignal(Tag)
					:connect(function(Instance)
						local Value = InstanceMap[Instance]

						if Value then
							InstanceMap[Instance] = nil

							Stop(unpack(Value))
						end
					end)

				return function()
					AddConnection:Disconnect()
					RemoveConnection:Disconnect()

					for Instance, Value in pairs(InstanceMap) do
						Spawn(Stop, unpack(Value))
					end
				end
			end
		end
		do
			__DARKLUA_BUNDLE_MODULES.j = function(Limit, Interval)
				assert(Limit > 0, "Limit must be greater than 0")

				local CountMap = {}
				local CountKeyless = 0

				return function(Key)
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

						CountKeyless = CountKeyless + 1
					end

					return true
				end
			end
		end
		do
			local Promise = __DARKLUA_BUNDLE_MODULES.c
			local Spawn = __DARKLUA_BUNDLE_MODULES.b
			local Signal = {}

			Signal.__index = Signal

			function Signal.new()
				return setmetatable({ Root = nil }, Signal)
			end
			function Signal.Connect(self, Callback)
				local Node = {
					Next = self.Root,
					Callback = Callback,
				}

				self.Root = Node

				return function()
					if self.Root == Node then
						self.Root = Node.Next
					else
						local Current = self.Root

						while Current do
							if Current.Next == Node then
								Current.Next = Node.Next

								break
							end

							Current = Current.Next
						end
					end
				end
			end
			function Signal.Wait(self)
				return Promise.new(function(Resolve)
					local Disconnect

					Disconnect = self:Connect(function(...)
						Disconnect()
						Resolve(...)
					end)
				end)
			end
			function Signal.Fire(self, ...)
				local Current = self.Root

				while Current do
					Spawn(Current.Callback, ...)

					Current = Current.Next
				end
			end
			function Signal.DisconnectAll(self)
				self.Root = nil
			end

			__DARKLUA_BUNDLE_MODULES.k = Signal
		end
		do
			__DARKLUA_BUNDLE_MODULES.l = function(value)
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
			local Spawn = __DARKLUA_BUNDLE_MODULES.b
			local typeof = __DARKLUA_BUNDLE_MODULES.l

			__DARKLUA_BUNDLE_MODULES.m = function()
				local Bin = {}

				return function(Item)
					table.insert(Bin, Item)
				end, function()
					for _, Item in ipairs(Bin) do
						if typeof(Item) == "Instance" then
							Item:Destroy()
						elseif typeof(Item) == "RBXScriptConnection" then
							Item:disconnect()
						elseif typeof(Item) == "function" then
							Spawn(Item)
						end
					end
					for i, _ in ipairs(Bin) do
						Bin[i] = nil
					end
				end
			end
		end

		local Net = __DARKLUA_BUNDLE_MODULES.h

		return {
			Server = Net.Server,
			Client = Net.Client,
			Collection = __DARKLUA_BUNDLE_MODULES.i,
			Ratelimit = __DARKLUA_BUNDLE_MODULES.j,
			Promise = __DARKLUA_BUNDLE_MODULES.c,
			Signal = __DARKLUA_BUNDLE_MODULES.k,
			Clock = __DARKLUA_BUNDLE_MODULES.e,
			Spawn = __DARKLUA_BUNDLE_MODULES.b,
			Bin = __DARKLUA_BUNDLE_MODULES.m,
		}
	end)

	if not success then
		error(result)
	end

	return result
end

return {
	Help = function()
		return "See https://redblox.dev/ for more information."
	end,
	Load = Red,
}
