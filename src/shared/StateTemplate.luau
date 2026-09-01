local Types = require(script.Parent.Types)
local AttackUpgrades = require(script.Parent.AttackUpgrades)
local DefenseUpgrades = require(script.Parent.DefenseUpgrades)
local UtilityUpgrades = require(script.Parent.UtilityUpgrades)

local StateTemplate = {}

function StateTemplate.SavedRun()
	return {
		Available = false,

		Run = {
			Tier = 0,
			Wave = 0,
			Time = 0,

			Cash = 0,
			

			Kills = 0,
			Damage = 0,

			Speed = 1,
			EnemyHealthSkips = 0,
			EnemyAttackSkips = 0,
		},

		RunUpgrades = {
			Attack = AttackUpgrades.NewLevels(),
			Defense = DefenseUpgrades.NewLevels(),
			Utility = UtilityUpgrades.NewLevels(),
			Perks = {},
		},

		PerkChoices = {},

		Combat = {
			Health = 0,
			MaxHealth = 0,

			Shield = 0,
			MaxShield = 0,

			Damage = 0,
			AttackSpeed = 0,

			Defense = 0,
		},
	}
end

function StateTemplate.New()
	return {
		
		Slots = {}, --  
		SavedRun = StateTemplate.SavedRun(),

		BalanceVersion = 1,

		-- Persistent currencies
		Wallet = {
			Coins = 1,
			Gems = 0,
			Medals = 0,
			Tokens = 0,
			EliteStones = 0,
		},

		-- Overall progression
		Progression = {
			Level = 1,
			XP = 0,

			HighestWave = 0,
			HighestWaves = {},
			HighestTier = 0,

			TotalWaves = 0,
			TotalKills = 0,
			TotalDamage = 0,
			TotalCoinsEarned = 0,
		},

		-- Tower upgrades
		WorkshopUpgrades = {
			Attack = AttackUpgrades.NewLevels(),
			Defense = DefenseUpgrades.NewLevels(),
			Utility = UtilityUpgrades.NewLevels(),
		},

		-- Permanent unlocks
		Unlocks = {
			Attack = {},
			Utility = {},
			Cards = {},
			Modules = {},
			Labs = {},
			Perks = {},
			Tiers = {},
			GameModes = {},
		},

		-- Achievements / milestones
		Achievements = {
			Completed = {},
			Progress = {},
		},

		-- Statistics
		Stats = {
			GamesPlayed = 0,
			GamesWon = 0,

			TotalTimePlayed = 0,

			EnemiesKilled = 0,
			BossesKilled = 0,

			DamageDealt = 0,
			DamageTaken = 0,

			CoinsEarned = 0,
			GemsEarned = 0,

			DeathCount = 0,
		},

		-- Settings that should persist
		Settings = {
			Music = true,
			Sound = true,
			Notifications = true,

			AutoPickPerks = false,
			AutoStart = false,
		},
	}
end

function StateTemplate.SessionData()
	return {
		Run = {
			Active = false,

			Tier = 0,
			Wave = 0,

			Time = 0,

			Cash = 0,

			Kills = 0,
			Damage = 0,

			Enemies = {},

			Speed = 1,
			EnemyHealthSkips = 0,
			EnemyAttackSkips = 0,
		},

		RunUpgrades = {
			Attack = AttackUpgrades.NewLevels(),
			Defense = DefenseUpgrades.NewLevels(),
			Utility = UtilityUpgrades.NewLevels(),
			Perks = {},
		},

		PerkChoices = {},
		Combat = {
			Health = 0,
			MaxHealth = 0,

			Shield = 0,
			MaxShield = 0,

			Damage = 0,
			AttackSpeed = 0,

			Defense = 0,
		},

		Runtime = {
			LastSave = 0,
			LastAttack = 0,
			LastWave = 0,

			Paused = false,
		},
	}
end

export type Data =
	typeof(StateTemplate.New())
	& typeof(StateTemplate.SessionData())

return StateTemplate
