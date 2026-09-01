local StateTemplate = require(script.Parent.StateTemplate)

local Types = {}

export type Replica = {
	Tags: { [string]: any },
	Data: StateTemplate.Data,
	Id: number,
	Token: string,
	Parent: Replica?,
	Children: { [Replica]: true },
	BoundInstance: Instance?,
	OnServerEvent: any,
	OnClientEvent: any,
	Maid: any,
	Set: (self: Replica, path: { string | number }, value: any) -> (),
	SetValues: (self: Replica, path: { string | number }, values: { [string]: any }) -> (),
	TableInsert: (self: Replica, path: { string | number }, value: any, index: number?) -> number,
	TableRemove: (self: Replica, path: { string | number }, index: number) -> any,
	Write: (self: Replica, functionName: string, ...any) -> ...any,
	FireClient: (self: Replica, player: Player, ...any) -> (),
	FireAllClients: (self: Replica, ...any) -> (),
	UFireClient: (self: Replica, player: Player, ...any) -> (),
	UFireAllClients: (self: Replica, ...any) -> (),
	FireServer: (self: Replica, ...any) -> (),
	UFireServer: (self: Replica, ...any) -> (),
	SetParent: (self: Replica, replica: Replica) -> (),
	BindToInstance: (self: Replica, instance: Instance) -> (),
	Replicate: (self: Replica) -> (),
	DontReplicate: (self: Replica) -> (),
	Subscribe: (self: Replica, player: Player) -> (),
	Unsubscribe: (self: Replica, player: Player) -> (),
	Identify: (self: Replica) -> string,
	IsActive: (self: Replica) -> boolean,
	Destroy: (self: Replica) -> (),
	OnSet: (self: Replica, path: { string | number }, listener: () -> ()) -> { Disconnect: (self: any) -> () },
	OnWrite: (self: Replica, functionName: string, listener: (...any) -> ()) -> { Disconnect: (self: any) -> () },
	OnChange: (
		self: Replica,
		listener: (
			action: "Set" | "SetValues" | "TableInsert" | "TableRemove",
			path: { any },
			param1: any,
			param2: any?
		) -> ()
	) -> { Disconnect: (self: any) -> () },
	GetChild: (self: Replica, token: string) -> Replica?,
}

return Types
