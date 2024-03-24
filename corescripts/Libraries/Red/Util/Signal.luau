--!strict

local Promise = require "./Promise"
local Spawn = require "./Spawn"

type SignalNode<T...> = {
	Next: SignalNode<T...>?,
	Callback: (T...) -> (),
}

export type Signal<T...> = {
	Root: SignalNode<T...>?,

	Connect: (self: Signal<T...>, Callback: (T...) -> ()) -> () -> (),
	Wait: (self: Signal<T...>) -> Promise.Promise,
	Fire: (self: Signal<T...>, T...) -> (),
	DisconnectAll: (self: Signal<T...>) -> (),
}

local Signal = {}
Signal.__index = Signal

function Signal.new<T...>(): Signal<T...>
	return setmetatable({
		Root = nil,
	}, Signal) :: any
end

function Signal.Connect<T...>(self: Signal<T...>, Callback: (T...) -> ()): () -> ()
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

function Signal.Wait<T...>(self: Signal<T...>): Promise.Promise
	return Promise.new(function(Resolve)
		local Disconnect

		Disconnect = self:Connect(function(...)
			Disconnect()
			Resolve(... :: any)
		end)
	end)
end

function Signal.Fire<T...>(self: Signal<T...>, ...: T...)
	local Current = self.Root
	while Current do
		Spawn(Current.Callback, ...)
		Current = Current.Next
	end
end

function Signal.DisconnectAll<T...>(self: Signal<T...>)
	self.Root = nil
end

return Signal
