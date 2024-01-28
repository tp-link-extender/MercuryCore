--!strict
--[[
    Roblox implementation for Fusion's abstract scheduler layer.
]]

local RunService = game:GetService "RunService"

local External = require "./External"

local MercuryExternal = {}

--[[
   Sends an immediate task to the external scheduler. Throws if none is set.
]]
function MercuryExternal.doTaskImmediate(resume: () -> ())
	Spawn(resume)
end

--[[
    Sends a deferred task to the external scheduler. Throws if none is set.
]]
function MercuryExternal.doTaskDeferred(resume: () -> ())
	coroutine.resume(coroutine.create(resume))
end

--[[
    Sends an update step to Fusion using the Roblox clock time.
]]
local function performUpdateStep()
	External.performUpdateStep(time())
end

--[[
    Binds Fusion's update step to RunService step events.
]]
local stopSchedulerFunc: () -> ()? = nil
function MercuryExternal.startScheduler()
	if stopSchedulerFunc ~= nil then
		return
	end
	-- if RunService:IsClient() then
	-- In cases where multiple Fusion modules are running simultaneously,
	-- -- this prevents collisions.
	-- local id = "FusionUpdateStep_" .. HttpService:GenerateGUID()
	-- RunService:BindToRenderStep(
	-- 	id,
	-- 	Enum.RenderPriority.First.Value,
	-- 	performUpdateStep
	-- )
	-- stopSchedulerFunc = function()
	-- 	RunService:UnbindFromRenderStep(id)
	-- end
	local conn = RunService.RenderStepped:connect(performUpdateStep)
	stopSchedulerFunc = function()
		conn:disconnect()
	end
	-- else
	-- 	local connection = RunService.Heartbeat:connect(performUpdateStep)
	-- 	stopSchedulerFunc = function()
	-- 		connection:Disconnect()
	-- 	end
	-- end
end

--[[
    Unbinds Fusion's update step from RunService step events.
]]
function MercuryExternal.stopScheduler()
	if stopSchedulerFunc ~= nil then
		stopSchedulerFunc()
		stopSchedulerFunc = nil
	end
end

return MercuryExternal
