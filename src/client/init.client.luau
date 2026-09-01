local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicaController = require(ReplicatedStorage.Shared.ReplicaController)
local ReplicaTypes = require(ReplicatedStorage.Shared.Replica)
local Controllers = ReplicatedStorage:WaitForChild("Controllers")

ReplicaController.Init()
-- local Place = GameConfig.PlaceIds[tostring(game.PlaceId)]

ReplicaController.WhenReady(function(replica: ReplicaTypes.Replica)
	ReplicaController._WireEvents(replica)
	for i, v in Controllers:GetChildren() do
		if v:IsA("ModuleScript") then
			local S, Res = pcall(function(...)
				local Mod = require(v)
				if Mod.Init then
					Mod.Init(replica)
				end
			end)
			if not S then
				warn(Res)
			end
		end
	end

	replica:FireServer("ClientLoaded")
end)
