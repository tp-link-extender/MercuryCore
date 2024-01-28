--!strict

--[[
	Manages batch updating of spring objects.
]]

local Types = require "../Types"
local External = require "../External"
local packType = require "../Animation/packType"
local springCoefficients = require "../Animation/springCoefficients"
local updateAll = require "../State/updateAll"

type Set<T> = { [T]: any }
type Spring = Types.Spring<any>

local SpringScheduler = {}

local EPSILON = 0.0001
local activeSprings: Set<Spring> = {}
local lastUpdateTime = External.lastUpdateStep()

function SpringScheduler.add(spring: Spring)
	-- we don't necessarily want to use the most accurate time - here we snap to
	-- the last update time so that springs started within the same frame have
	-- identical time steps
	spring._lastSchedule = lastUpdateTime
	spring._startDisplacements = {}
	spring._startVelocities = {}
	for index, goal in ipairs(spring._springGoals) do
		spring._startDisplacements[index] = spring._springPositions[index]
			- goal
		spring._startVelocities[index] = spring._springVelocities[index]
	end

	activeSprings[spring] = true
end

function SpringScheduler.remove(spring: Spring)
	activeSprings[spring] = nil
end

local function updateAllSprings(now: number)
	local springsToSleep: Set<Spring> = {}
	lastUpdateTime = now

	for spring in pairs(activeSprings) do
		local posPos, posVel, velPos, velVel = springCoefficients(
			lastUpdateTime - spring._lastSchedule,
			spring._currentDamping,
			spring._currentSpeed
		)

		local positions = spring._springPositions
		local velocities = spring._springVelocities
		local startDisplacements = spring._startDisplacements
		local startVelocities = spring._startVelocities
		local isMoving = false

		for index, goal in ipairs(spring._springGoals) do
			local oldDisplacement = startDisplacements[index]
			local oldVelocity = startVelocities[index]
			local newDisplacement = oldDisplacement * posPos
				+ oldVelocity * posVel
			local newVelocity = oldDisplacement * velPos + oldVelocity * velVel

			if
				math.abs(newDisplacement) > EPSILON
				or math.abs(newVelocity) > EPSILON
			then
				isMoving = true
			end

			positions[index] = newDisplacement + goal
			velocities[index] = newVelocity
		end

		if not isMoving then
			springsToSleep[spring] = true
		end
	end

	for spring in pairs(activeSprings) do
		spring._currentValue =
			packType(spring._springPositions, spring._currentType)
		updateAll(spring)
	end

	for spring in pairs(springsToSleep) do
		activeSprings[spring] = nil
		-- Guarantee that springs reach exact goals, since mathematically they only approach it infinitely
		spring._currentValue =
			packType(spring._springGoals, spring._currentType)
	end
end

External.bindToUpdateStep(updateAllSprings)

return SpringScheduler
