--!strict

--[[
	Manages batch updating of tween objects.
]]

local Types = require "../Types"
local External = require "../External"
local lerpType = require "../Animation/lerpType"
local getTweenRatio = require "../Animation/getTweenRatio"
local updateAll = require "../State/updateAll"

local TweenScheduler = {}

type Set<T> = { [T]: any }
type Tween = Types.Tween<any>

local WEAK_KEYS_METATABLE = { __mode = "k" }

-- all the tweens currently being updated
local allTweens: Set<Tween> = {}
setmetatable(allTweens, WEAK_KEYS_METATABLE)

--[[
	Adds a Tween to be updated every render step.
]]
function TweenScheduler.add(tween: Tween)
	allTweens[tween] = true
end

--[[
	Removes a Tween from the scheduler.
]]
function TweenScheduler.remove(tween: Tween)
	allTweens[tween] = nil
end

--[[
	Updates all Tween objects.
]]
local function updateAllTweens(now: number)
	-- FIXME: Typed Luau doesn't understand this loop yet
	for tween: Tween in pairs(allTweens :: any) do
		local currentTime = now - tween._currentTweenStartTime

		if
			currentTime > tween._currentTweenDuration
			and tween._currentTweenInfo.RepeatCount > -1
		then
			if tween._currentTweenInfo.Reverses then
				tween._currentValue = tween._prevValue
			else
				tween._currentValue = tween._nextValue
			end
			tween._currentlyAnimating = false
			updateAll(tween)
			TweenScheduler.remove(tween)
		else
			local ratio = getTweenRatio(tween._currentTweenInfo, currentTime)
			local currentValue =
				lerpType(tween._prevValue, tween._nextValue, ratio)
			tween._currentValue = currentValue
			tween._currentlyAnimating = true
			updateAll(tween)
		end
	end
end

External.bindToUpdateStep(updateAllTweens)

return TweenScheduler
