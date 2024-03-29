--!strict

local RunService = game:GetService "RunService"

local function MakeHeartbeatFunction(Clock: Clock)
	return function(Delta)
		Clock:Advance(Delta)
	end
end

local Clock = {}
Clock.__index = Clock

function Clock.Clock(Interval: number, Callback: () -> ())
	local self = setmetatable({}, Clock)

	self.Interval = Interval
	self.Callback = Callback
	self.Delta = 0

	self.Connection = RunService.Heartbeat:connect(MakeHeartbeatFunction(self))

	return self
end

Clock.new = Clock.Clock

function Clock.Pause(self: Clock)
	if self.Connection then
		self.Connection:Disconnect()
	end
end

function Clock.Resume(self: Clock)
	if self.Connection.Connected then
		return
	end

	self.Connection = RunService.Heartbeat:connect(MakeHeartbeatFunction(self))
end

function Clock.Advance(self: Clock, Delta: number)
	self.Delta += Delta

	if self.Delta >= self.Interval * 10 then
		local Skipped = math.floor(self.Delta / self.Interval)
		self.Delta -= Skipped * self.Interval

		-- if ReplicatedStorage:GetAttribute "RedDebug" then
		-- 	warn(
		-- 		"[Red.Clock]: Clock is falling behind! Skipped "
		-- 			.. Skipped
		-- 			.. " intervals."
		-- 	)
		-- end

		return
	end

	if self.Delta >= self.Interval then
		self.Delta -= self.Interval
		self.Callback()
	end
end

export type Clock = typeof(Clock.Clock(...))

return Clock
