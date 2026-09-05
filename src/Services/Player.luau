local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local WiredEvents = require("@game/ReplicatedStorage/Shared/WiredEvents")
local ReplicaTypes = require(ReplicatedStorage.Shared.Replica)

WiredEvents.OnEvent("OnPlayerDataLoaded", function(Player : Player,PlayerReplica: ReplicaTypes.Replica)
    local Char = Player.Character or Player.CharacterAdded:Wait()
    task.wait()
    Char:Destroy()
end)
-- WiredEvents.OnEvent("OnPlayerRemoving", OnPlayerRemoving)


return {}