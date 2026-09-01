local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local WiredEvents = require("@game/ReplicatedStorage/Shared/WiredEvents")
local ReplicaTypes = require(ReplicatedStorage.Shared.Replica)
local ProfileService = require(ServerScriptService.ServerPackages.profileservice)
local Replica = require(ReplicatedStorage.Packages.replica)
local StateTemplate = require(ReplicatedStorage.Shared.StateTemplate)


local ProfileStore = ProfileService.GetProfileStore("PlayerData_v3", StateTemplate.New())
local PlayerToken = Replica.Token("PlayerData")
local SessionKeys = StateTemplate.SessionData()

local Profiles = {}
local PlayerReplicas = {}
local ReplicaService = {}

local function OnPlayerAdded(Player: Player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. Player.UserId)

	if profile == nil then
		Player:Kick("Failed to load data. Please rejoin.")
		return
	end

	profile:AddUserId(Player.UserId)
	profile:Reconcile()

	for key, value in StateTemplate.SessionData() do
		profile.Data[key] = value
	end

	profile:ListenToRelease(function()
		Profiles[Player] = nil
		local replica = PlayerReplicas[Player]
		if replica then
			replica:Destroy()
			PlayerReplicas[Player] = nil
		end
		Player:Kick("Your data was loaded on another server. Please rejoin.")
	end)

	if not Player:IsDescendantOf(Players) then
		profile:Release()
		return
	end

	Profiles[Player] = profile

	local replica: ReplicaTypes.Replica = Replica.New({
		Token = PlayerToken,
		Tags = { UserId = Player.UserId },
		Data = profile.Data,
	})
	PlayerReplicas[Player] = replica
	replica.OnServerEvent:Connect(function(Sender: Player, Event: string, ...)
		if Sender ~= Player then
			return
		end
		local Args = { ... }
		WiredEvents.Fire(Event, Player, replica, table.unpack(Args))
	end)

	if not Replica.ReadyPlayers[Player] then
		local conn
		conn = Replica.NewReadyPlayer:Connect(function(readyPlayer: Player)
			if readyPlayer ~= Player then
				return
			end
			conn:Disconnect()
			if Player:IsDescendantOf(Players) then
				replica:Subscribe(Player)
			end
		end)
	else
		replica:Subscribe(Player)
	end
	WiredEvents.Fire("OnPlayerDataLoaded",Player,replica)
	-- Actions.ServerActions.PlayerJoined(Player, replica, {})
end

local function OnPlayerRemoving(Player: Player)
	local profile = Profiles[Player]
	local replica = PlayerReplicas[Player]
	if replica then 
		WiredEvents.FireSynchronous("BeforeDataRelease",Player,replica)
		PlayerReplicas[Player] = nil
	end
	if profile then
		for key in SessionKeys do
			profile.Data[key] = nil
		end
		profile:Release()
	end
end

WiredEvents.OnEvent("OnPlayerAdded", OnPlayerAdded)
WiredEvents.OnEvent("OnPlayerRemoving", OnPlayerRemoving)
return ReplicaService
