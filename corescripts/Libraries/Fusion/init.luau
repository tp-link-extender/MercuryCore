--!strict

--[[
	The entry point for the Fusion library.
]]

local PubTypes = require "./PubTypes"
local External = require "./External"
local restrictRead = require "./Utility/restrictRead"

-- Down the line, this will be conditional based on whether Fusion is being
-- compiled for Mercury.
do
	local MercuryExternal = require "./MercuryExternal"
	External.setExternalScheduler(MercuryExternal)
end

local Fusion = restrictRead("Fusion", {
	version = { major = 0, minor = 3, isRelease = false },

	New = require "./Instances/New",
	Hydrate = require "./Instances/Hydrate",
	Ref = require "./Instances/Ref",
	Out = require "./Instances/Out",
	Cleanup = require "./Instances/Cleanup",
	Children = require "./Instances/Children",
	OnEvent = require "./Instances/OnEvent",
	OnChange = require "./Instances/OnChange",

	Value = require "./State/Value",
	Computed = require "./State/Computed",
	ForPairs = require "./State/ForPairs",
	ForKeys = require "./State/ForKeys",
	ForValues = require "./State/ForValues",
	Observer = require "./State/Observer",

	Tween = require "./Animation/Tween",
	Spring = require "./Animation/Spring",

	Contextual = require "./Utility/Contextual",
	cleanup = require "./Utility/cleanup",
	doNothing = require "./Utility/doNothing",
	peek = require "./State/peek",

	typeof = require "../../Modules/Polyfill/typeof",
	TweenInfo = require "../../Modules/Polyfill/TweenInfo",

	Help = function()
		return "See https://elttob.uk/Fusion/0.3/ for more information."
	end,
}) :: Fusion

export type StateObject<T> = PubTypes.StateObject<T>
export type CanBeState<T> = PubTypes.CanBeState<T>
export type Symbol = PubTypes.Symbol
export type Value<T> = PubTypes.Value<T>
export type Computed<T> = PubTypes.Computed<T>
export type ForPairs<KO, VO> = PubTypes.ForPairs<KO, VO>
export type ForKeys<KI, KO> = PubTypes.ForKeys<KI, KO>
export type ForValues<VI, VO> = PubTypes.ForKeys<VI, VO>
export type Observer = PubTypes.Observer
export type Tween<T> = PubTypes.Tween<T>
export type Spring<T> = PubTypes.Spring<T>
export type Use = PubTypes.Use
export type Contextual<T> = PubTypes.Contextual<T>

type Fusion = {
	version: PubTypes.Version,

	New: (
		className: string
	) -> (propertyTable: PubTypes.PropertyTable) -> Instance,
	Hydrate: (
		target: Instance
	) -> (propertyTable: PubTypes.PropertyTable) -> Instance,
	Ref: PubTypes.SpecialKey,
	Cleanup: PubTypes.SpecialKey,
	Children: PubTypes.SpecialKey,
	Out: (propertyName: string) -> PubTypes.SpecialKey,
	OnEvent: (eventName: string) -> PubTypes.SpecialKey,
	OnChange: (propertyName: string) -> PubTypes.SpecialKey,

	Value: <T>(initialValue: T) -> Value<T>,
	Computed: <T>(callback: (Use) -> T, destructor: (T) -> ()?) -> Computed<T>,
	ForPairs: <KI, VI, KO, VO, M>(
		inputTable: CanBeState<{ [KI]: VI }>,
		processor: (Use, KI, VI) -> (KO, VO, M?),
		destructor: (KO, VO, M?) -> ()?
	) -> ForPairs<KO, VO>,
	ForKeys: <KI, KO, M>(
		inputTable: CanBeState<{ [KI]: any }>,
		processor: (Use, KI) -> (KO, M?),
		destructor: (KO, M?) -> ()?
	) -> ForKeys<KO, any>,
	ForValues: <VI, VO, M>(
		inputTable: CanBeState<{ [any]: VI }>,
		processor: (Use, VI) -> (VO, M?),
		destructor: (VO, M?) -> ()?
	) -> ForValues<any, VO>,
	Observer: (watchedState: StateObject<any>) -> Observer,

	Tween: <T>(goalState: StateObject<T>, tweenInfo: TweenInfo?) -> Tween<T>,
	Spring: <T>(
		goalState: StateObject<T>,
		speed: CanBeState<number>?,
		damping: CanBeState<number>?
	) -> Spring<T>,

	Contextual: <T>(defaultValue: T) -> Contextual<T>,
	cleanup: (...any) -> (),
	doNothing: (...any) -> (),
	peek: Use,
}

return Fusion
