local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WiredEvents = require("@game/ReplicatedStorage/Shared/WiredEvents")

local Services = script.Parent.Services

for i, v in Services:GetChildren() do
	if v:IsA("ModuleScript") then
		local Mod = require(v)
		local S, Res = pcall(function()
			if Mod.Init then
				Mod.Init()
			end
		end)
		if not S then
			warn(Res)
		end
		print(v.Name, "Loaded")
	end
end

for _, Player in Players:GetPlayers() do
	task.spawn(function()
		WiredEvents.Fire("OnPlayerAdded", Player)
	end)
	-- print(Player)
end

Players.PlayerAdded:Connect(function(Player: Player)
	WiredEvents.Fire("OnPlayerAdded", Player)
end)

Players.PlayerRemoving:Connect(function(Player: Player, a1: Enum.PlayerExitReason)
	WiredEvents.Fire("OnPlayerRemoving", Player)
end)
