--!nocheck
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replica = require(ReplicatedStorage.Packages.replica)
local ReplicaTypes = require(ReplicatedStorage.Shared.Replica)
-- local Actions = require(script.Parent.ClientActions)

local ReplicaController = {}

local _Replica = nil
local _ReadyCallbacks: { (any) -> () } = {}

type Action = "Set" | "SetValues" | "TableInsert" | "TableRemove"

function ReplicaController.Init()
	Replica.OnNew("PlayerData", function(Replica)
		if Replica.Tags.UserId ~= Players.LocalPlayer.UserId then
			return
		end

		_Replica = Replica

		for _, Cb in _ReadyCallbacks do
			task.spawn(Cb, Replica)
		end
		table.clear(_ReadyCallbacks)
	end)

	Replica.RequestData()
end

function ReplicaController.GetReplica(): ReplicaTypes.Replica
	return _Replica
end

function ReplicaController.WhenReady(Fn: (any) -> ())
	if _Replica then
		task.spawn(Fn, _Replica)
	else
		table.insert(_ReadyCallbacks, Fn)
	end
end

local _EventListeners: { [string]: { (...any) -> () } } = {}
local CallbacksKey = {} :: any

local _Binds = {
	Set = {},
	SetValues = {},
	TableInsert = {},
	TableRemove = {},
} :: { [Action]: any }

local function GetNode(Root: any, Path: { string }, Create: boolean?): any
	local Pointer = Root

	for _, Key in Path do
		local Next = Pointer[Key]

		if Next == nil then
			if not Create then
				return nil
			end

			Next = {}
			Pointer[Key] = Next
		end

		Pointer = Next
	end

	return Pointer
end

local function FireNode(Node: any, ...)
	local List = Node and Node[CallbacksKey]

	if not List then
		return
	end

	for _, Fn in List do
		task.spawn(Fn, ...)
	end
end

local function FirePath(Action: Action, Path: { string }, ...)
	local Pointer = _Binds[Action]

	if not Pointer then
		return
	end

	FireNode(Pointer, ...)

	for _, Key in Path do
		Pointer = Pointer[Key]

		if Pointer == nil then
			return
		end

		FireNode(Pointer, ...)
	end
end

function ReplicaController.Bind(Action: Action, Path: { string }, Fn: (...any) -> ()): () -> ()
	local Node = GetNode(_Binds[Action], Path, true)
	local List = Node[CallbacksKey]

	if not List then
		List = {}
		Node[CallbacksKey] = List
	end

	table.insert(List, Fn)

	return function()
		local Index = table.find(List, Fn)

		if Index then
			table.remove(List, Index)
		end
	end
end

function ReplicaController.BindSet(Path: { string }, Fn: (...any) -> ()): () -> ()
	return ReplicaController.Bind("Set", Path, Fn)
end

function ReplicaController.OnEvent(EventName: string, Fn: (...any) -> ())
	if not _EventListeners[EventName] then
		_EventListeners[EventName] = {}
	end
	table.insert(_EventListeners[EventName], Fn)
end

function ReplicaController._WireEvents(Replica: ReplicaTypes.Replica)
	Replica.OnClientEvent:Connect(function(EventName: string, ...)
		-- if Actions[eventName] then
		-- 	task.spawn(Actions[eventName], replica, ...)
		-- end
		local Listeners = _EventListeners[EventName]
		-- print(EventName,Listeners)
		if Listeners then
			local Args = { ... }
			for _, Fn in Listeners do
				task.spawn(Fn, Replica, table.unpack(Args))
			end
		end
	end)
	Replica:OnChange(function(Action: Action, Path: { string }, Param1: any, Param2: any?)
		if Action == "SetValues" then
			for Key, Value in Param1 do
				local ChildPath = table.clone(Path)
				table.insert(ChildPath, Key)
				FirePath("SetValues", ChildPath, Replica, Value, nil, ChildPath)
			end

			return
		end

		FirePath(Action, Path, Replica, Param1, Param2, Path)
	end)
end

-- local function CheckListeners(Array,Key)

-- end

return ReplicaController
