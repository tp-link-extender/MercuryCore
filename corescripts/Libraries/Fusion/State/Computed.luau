--!nonstrict

--[[
	Constructs and returns objects which can be used to model derived reactive
	state.
]]

local Types = require "../Types"
-- Logging
local logError = require "../Logging/logError"
local logErrorNonFatal = require "../Logging/logErrorNonFatal"
local logWarn = require "../Logging/logWarn"
local parseError = require "../Logging/parseError"
-- Utility
local isSimilar = require "../Utility/isSimilar"
local needsDestruction = require "../Utility/needsDestruction"
-- State
local makeUseCallback = require "../State/makeUseCallback"

local class = {}

local CLASS_METATABLE = { __index = class }
local WEAK_KEYS_METATABLE = { __mode = "k" }

--[[
	Recalculates this Computed's cached value and dependencies.
	Returns true if it changed, or false if it's identical.
]]
function class:update(): boolean
	-- remove this object from its dependencies' dependent sets
	for dependency in pairs(self.dependencySet) do
		dependency.dependentSet[self] = nil
	end

	-- we need to create a new, empty dependency set to capture dependencies
	-- into, but in case there's an error, we want to restore our old set of
	-- dependencies. by using this table-swapping solution, we can avoid the
	-- overhead of allocating new tables each update.
	self._oldDependencySet, self.dependencySet =
		self.dependencySet, self._oldDependencySet
	-- table.clear(self.dependencySet)
	for i, _ in pairs(self.dependencySet) do
		self.dependencySet[i] = nil
	end

	local use = makeUseCallback(self.dependencySet)
	-- local ok, newValue, newMetaValue =
	-- 	xpcall(self._processor, parseError, use)
	local ok, newValue, newMetaValue = pcall(self._processor, use)

	if ok then
		if self._destructor == nil and needsDestruction(newValue) then
			logWarn "destructorNeededComputed"
		end

		if newMetaValue ~= nil then
			logWarn "multiReturnComputed"
		end

		local oldValue = self._value
		local similar = isSimilar(oldValue, newValue)
		if self._destructor ~= nil then
			self._destructor(oldValue)
		end
		self._value = newValue

		-- add this object to the dependencies' dependent sets
		for dependency in pairs(self.dependencySet) do
			dependency.dependentSet[self] = true
		end

		return not similar
	else
		-- this needs to be non-fatal, because otherwise it'd disrupt the
		-- update process
		logErrorNonFatal("computedCallbackError", parseError(newValue))

		-- restore old dependencies, because the new dependencies may be corrupt
		self._oldDependencySet, self.dependencySet =
			self.dependencySet, self._oldDependencySet

		-- restore this object in the dependencies' dependent sets
		for dependency in pairs(self.dependencySet) do
			dependency.dependentSet[self] = true
		end

		return false
	end
end

--[[
	Returns the interior value of this state object.
]]
function class:_peek(): any
	return self._value
end

function class:get()
	logError "stateGetWasRemoved"
end

local function Computed<T>(
	processor: () -> T,
	destructor: ((T) -> ())?
): Types.Computed<T>
	local dependencySet = {}
	local self = setmetatable({
		type = "State",
		kind = "Computed",
		dependencySet = dependencySet,
		-- if we held strong references to the dependents, then they wouldn't be
		-- able to get garbage collected when they fall out of scope
		dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
		_oldDependencySet = {},
		_processor = processor,
		_destructor = destructor,
		_value = nil,
	}, CLASS_METATABLE)

	self:update()

	return self
end

return Computed
