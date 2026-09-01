local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local Http = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Assets = ReplicatedStorage.Assets
---Vars---
local ClientModules = ReplicatedStorage.Modules
local ServerModules = ServerStorage.ServerModules
local Remotes = ReplicatedStorage.Remotes
local MoneyLib = require(ClientModules.MoneyLib)
local ClassLoader = require(ClientModules.ClassLoader)
local DelayCall = require(ClientModules.DelayCall)
local Events = require(ClientModules.Events)
local Types = require(ClientModules.Types)
local Spring = require(ClientModules.Spring)
local CustomEvents = require(ClientModules.CustomEvent)
local NpcPart = Assets.NpcPart

local RunService = game:GetService("RunService")

local NpcService = {}
NpcService.__index = NpcService

function NpcService.new(Name: string)
	local self = setmetatable({}, NpcService)
	self.Part = NpcPart:Clone()
	self.IsMoving = false
	self.Target = ""
	self.Speed = 16
	self.StopDistance = 4
	self.Part.Parent = workspace
	self.StepConnection = nil
	self.Events = {
		DoneWalking = CustomEvents.new()
	}
	return self
end

export type NpcService = typeof(NpcService.new())

function NpcService.MoveTo(self: NpcService, Position: Vector3)
	if self.IsMoving then return end
	self.IsMoving = true

	local FlatTarget = Vector3.new(Position.X, self.Part.Position.Y, Position.Z)
	local Direction = (FlatTarget - self.Part.Position).Unit
	local EndPos = FlatTarget - (Direction * self.StopDistance)

	self.Part.CFrame = CFrame.lookAt(self.Part.CFrame.Position, FlatTarget)

	self.StepConnection = RunService.PreSimulation:Connect(function(DeltaTime: number)
		local CurrentPos = self.Part.Position
		local GoalPos = EndPos - CurrentPos
		local DistRemaining = GoalPos.Magnitude

		local StepSize = self.Speed * DeltaTime

		if DistRemaining <= StepSize then
			self.Part.Position = EndPos
			self.StepConnection:Disconnect()
			self.StepConnection = nil
			self.Events.DoneWalking:Fire()
			return
		end

		self.Part.Position = CurrentPos + GoalPos.Unit * StepSize
	end)
end

function NpcService.StopMoving(self: NpcService)
	if self.StepConnection then
		self.StepConnection:Disconnect()
		self.StepConnection = nil
	end
	self.IsMoving = false
end

function NpcService.Destroy(self: NpcService)
	self:StopMoving()
	for _, Event: CustomEvents.CustomEventClass in self.Events do
		Event:Destroy()
	end
	self.Part:Destroy()
	setmetatable(self, nil)
end

return NpcService
