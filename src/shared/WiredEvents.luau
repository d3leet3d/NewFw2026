local WireEvents = {}

local EventListeners: { [string]: { (...any) -> () } } = {}

function WireEvents.OnEvent(EventName: string, fn: (...any) -> ())
	if not EventListeners[EventName] then
		EventListeners[EventName] = {}
	end
	table.insert(EventListeners[EventName], fn)
end

function WireEvents.Fire(EventName: string, ...)
	local listeners = EventListeners[EventName]
	if listeners then
		local args = { ... }
		for _, fn in listeners do
			task.spawn(fn, table.unpack(args))
		end
	end
end

function WireEvents.FireSynchronous(EventName: string, ...)
	local Listeners = EventListeners[EventName]
	if not Listeners then return end

	for _, Listener in Listeners do
		local Success, Result = pcall(Listener, ...)
		if not Success then
			warn(Result)
		end
	end
end

return WireEvents
