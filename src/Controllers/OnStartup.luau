--!nocheck
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WiredEvents = require("@game/ReplicatedStorage/Shared/WiredEvents")
local Enemys = require("../Classes/Enemys")
local Types = require(ReplicatedStorage.Shared.Types)
local ReplicaTypes = require(ReplicatedStorage.Shared.Replica)
local Assets = ReplicatedStorage:WaitForChild("Assets")
local ReplicaController = require(ReplicatedStorage.Shared.ReplicaController)
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Scriptable


local PlayerController = {}

function PlayerController.Init(PlayerReplica: ReplicaTypes.Replica)
	Camera.CFrame = workspace:GetAttribute("CamPos")
	for i =1,100 do
		Camera.CameraType = Enum.CameraType.Scriptable
	end
end


return PlayerController
