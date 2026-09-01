--Binds RBXScriptConnection to intances and disconnects when the object is destroyed
--TODO(d3leet3d)
local module = {}
module.__index = module

function module.New(Inst: Instance)
	local self = setmetatable({}, module)
	self.Connections = {} :: { RBXScriptConnection }

	self.DestroyConnection = nil :: RBXScriptConnection?
	self.DestroyConnection = Inst.Destroying:Connect(function()
		self.DestroyConnection:Disconnect()
		self:Destroy()
	end)
	return self
end

export type SelfClass = typeof(module.New(Instance.new("Part")))

function module.AddConnection(self: SelfClass, Name: string, Connection: RBXScriptConnection)
	if not Name then
		table.insert(self.Connections, Connection)
	else
		self.Connections[Name] = Connection
	end
end

function module.ClearConnections(self: SelfClass)
	for i, v: RBXScriptConnection in self.Connections do
		v:Disconnect()
	end
	self.Connections = {}
end

function module.Destroy(self: SelfClass)
	self:ClearConnections()
	setmetatable(self, nil)
	self = nil
end

return module
