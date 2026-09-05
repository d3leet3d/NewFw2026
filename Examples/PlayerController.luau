--!nocheck
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WiredEvents = require("@game/ReplicatedStorage/Shared/WiredEvents")
local Types = require(ReplicatedStorage.Shared.Types)
local ReplicaTypes = require(ReplicatedStorage.Shared.Replica)
local Assets = ReplicatedStorage:WaitForChild("Assets")
local ReplicaController = require(ReplicatedStorage.Shared.ReplicaController)
local Player = game.Players.LocalPlayer

local PlayerController = {}
local Parts = {} :: { BasePart }

WiredEvents.OnEvent("CollectLeaves", function()
	local Overlap = OverlapParams.new()
	Overlap.CollisionGroup = "Leaf"
	Overlap.IncludeInstances = workspace.Leavs:GetChildren()
	local PlayerReplica: ReplicaTypes.Replica = ReplicaController:GetReplica()
	local Leaves = workspace:GetPartBoundsInRadius(Player.Character:GetPivot().Position, 5, Overlap)
	local Leaf: string

	if #Leaves < 1 then
		return
	end

	local Closest = math.huge
	for i, v in Leaves do
		local Dist = (Player.Character:GetPivot().Position - v.Position).Magnitude
		if Dist < Closest then
			Leaf = v.Name
		end
	end
	PlayerReplica:FireServer("CollectLeaves", Leaves[1].Name)
end)

ReplicaController.OnEvent("RemoveLeaf", function(PlayerReplica: ReplicaTypes.Replica, Leaf: Types.SpawnPartData)
	if Parts[Leaf] then
		Parts[Leaf]:Destroy()
	end
end)

ReplicaController.OnEvent("LeavesSpawned", function(PlayerReplica: ReplicaTypes.Replica, Amount : number)
	for i, v: Types.SpawnPartData in PlayerReplica.Data.LeavesInGame do
		local Part = Assets:WaitForChild("Leaf"):Clone()
		Part.Name = v.Name
		Part.Position = v.Position
		Part.Size = v.Size
		Part.Parent = workspace.Leavs
		Part.CFrame = Part.CFrame * CFrame.Angles(0, math.rad(math.random(-360, 360)), 0)
		Parts[v.Name] = Part
	end
end)

return PlayerController
