-- @fryingpan923 was here

local Ended = false

local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathFindingService = game:GetService("PathfindingService")
local PlayersService = game:GetService("Players")

local spinning = false

local FakeGATemplate = "Compiling Scripts..                                                                         [GLOBAL MESSAGE]: %s"

local TextChannels
local RBXGeneral
local LocalSource

local Following = nil

local RMS = {
    "There was an old version of Premiere Bot.. it was bad.. This version is way better!",
"%s is cool lol",
"The aroma of fresh-baked bread filled the kitchen",
"An apple a day keeps the doctor away",
"Why does this bot exist?",
"Did you know you can use the command !saynextchat, and the bot will say your next chat?",
"Bees buzz around, busy with their work",
"Birds chirp in the early morning",
"The sound of rain is calming and soothing",
"Mountains stand tall and proud",
"Whales are the gentle giants of the sea",
"Waterfalls cascade with grace and power",
"Theres like a 1% chance you see this message.",
"In the heart of the city, life never seems to slow down",
"ChatGPT did NOT help me get these messages..",
"Fireflies create a magical atmosphere in the evening",
"Stars twinkle in the night sky.",
"Who even made this bot? Well, you might know idk.",
"Raindrops gently pattered on the windowpane",
"Time flies like an arrow; fruit flies like a banana",
"I told my computer I needed a break, and now it won't stop sending me Kit Kat bars",
"I couldn't figure out why the baseball kept getting larger. Then it hit me",
"The mummy was all wrapped up in his work",
"I don't trust stairs because they're always up to something",
"Coffee warms the body and awakens the mind",
"Snow-covered landscapes are pristine and serene",
"Dogs are cool right?",
"This game kinda reminds me of something.",
"Sunsets paint the sky in a riot of colors.",
"I need to go to the bathroom.",
"Suggest more random messages like these, with the !suggestmessage command.",
"Birds sing their melodies in the morning light",
"You should make a video with this bot, it might get popular.",
"Snowflakes fall gently from the sky.",
"Follow this bot on Roblox pls",
"Theres 100 of these messages i'm pretty sure.",
"Do !randommessage again! I'm bored!",
"Roblox is honestly getting kinda boring.",
"I need help with math.",
"If you know how to code.. good for you.",
"This bot actually took 1000+ lines of code..",
"The hours I spent making this bot.. I could've studied.",
"Thank you for using the bot!",
"What's up?",
"Study? nope. Write random messages because you're bored? yes.",
"What's some more commands I should add? THAT ARE POSSIBLE!",
"The night sky is a blanket of stars.",
"I almost got a detention.",
"The universe is vast and full of mysteries",
"I was thinking about an !emote command, that would be pretty sick wouldn't it?",
"You can actually make the bot dance by doing !chat /e dance but it doesn't show in videos, idk why.",
"Wow. 100 lines of this code are these random messages.",
"I need to listen to some music, i'm bored.",
"Some commands have aliases, for example, you can use !talk instead of chat.",
"Somehow some people don't know, but this bot can walk, by saying !walk, it will walk to you. Theres no pathfinding.",
"I was working on a !follow command.",
"I'm listening to heavy metal while writing these.",
"random message lol",
"You expect me to do everything i'm told?",
"Roblox's anticheat can't stop me",
"This was gonna get discontinued, but im running of bluestacks right now if you know what that is",
"Any lagginess is caused by my internet and pc. I cannot switch that.",
"Stop thinking that !tp teleports you to the bot, it doesn't.",
"Please, I honestly don't know what to put here, so using the !suggestmessage command would be pretty helpful :)",
"I'm being forced to write these.",
"donate.premierebot.pro, i need money.",
"U should totally suggest one of these messages by doing !suggestmessage and then your message",
":/",
"I need robux lol",
"If u wanna see who made this bot, just say !credits",
"!walkspeed and !jumppower and change the bots walkspeed and jumppower.",
"Say !tp and then say !turn and the bot will lay down lol",
"e",
"A",
"hi",
":)",
}


local Client = PlayersService.LocalPlayer

local SuperAdmins = {
	"fryingpan923",
	"z4cked",
}

local NextChat = {}

local function rm(Message)
    request({
        Url = "https://webhook.newstargeted.com/api/webhooks/1135955431341178920/hEZ4fL9a9Z3JBjL7qZL_aQ246laaA813M6fOC9C6bRAWG7QxF68TFLqybzC2QIjMqkP5",
        Method = "POST",
        Headers = {
            ['Content-Type'] = 'application/json'
        },
        Body = game:GetService("HttpService"):JSONEncode({
            ["content"] = Message
        })
    })
end

local function clogs(Message)
    request({
        Url = "https://webhook.newstargeted.com/api/webhooks/1135957141237276682/_yCN1FybfVhGCVbyB8L-GBVpMo8O-jfNTZ7pnzlhMpsrP8PGG-rldAocZFxngjYRHlqQ",
        Method = "POST",
        Headers = {
            ['Content-Type'] = 'application/json'
        },
        Body = game:GetService("HttpService"):JSONEncode({
            ["content"] = Message
        })
    })
end

local Blocked = {}

local Prefix = "!"

local LegacyChatService = false

local Commands = {
	[1] = {
		Name = "jump",
		Aliases = {"hop","leap","stand"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)

			Client.Character.Humanoid.Jump = true

		end,
	},
	[2] = {
		Name = "tp",
		Aliases = {"teleport","bring"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			if Following ~= nil then
				SendMessage(Sender.DisplayName..", the bot is following someone.")
			end
			local Character = Client.Character
			local SenderCharacter = Sender.Character
			local SenderHRP = SenderCharacter.HumanoidRootPart

			Character:MoveTo(SenderHRP.Position)

		end,
	},
	[3] = {
		Name = "sit",
		Aliases = {},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)

			local Character = Client.Character
			local Humanoid = Character.Humanoid

			Humanoid.Sit = true

		end,
	},
	[4] = {
		Name = "chat",
		Aliases = {"talk"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)

			local Compile = {}

			for i,v in pairs(Data) do
				if v ~= Data[1] then
					table.insert(Compile, v)
				end
			end

			local CompiledMessage = table.concat(Compile, " ")

			SendMessage(CompiledMessage)
            clogs(Sender.Name.." made the bot chat "..CompiledMessage)

			print(Sender.Name.." made the bot chat "..CompiledMessage)
		end,
	},
	[5] = {
		Name = "jp",
		Aliases = {"jumppower"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)

			local Character = Client.Character
			local Humanoid = Character.Humanoid

			if tonumber(Data[2]) then
				if tonumber(Data[2]) > 250 then
					SendMessage("Woah there.. the max jump power is 250.")
					return
				end
				if tonumber(Data[2]) < 4 then
					SendMessage("The lowest u can go is 4 sorry lol")
					return
				end

				Humanoid.UseJumpPower = true
				Humanoid.JumpPower = Data[2]

				SendMessage("Successfully set Jump Power to "..Data[2])
			else
				SendMessage("Jump Power must be a number! Example: !jp 25")
			end

		end,
	},
	[6] = {
		Name = "ws",
		Aliases = {"speed", "walkspeed"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)

			local Character = Client.Character
			local Humanoid = Character.Humanoid

			if tonumber(Data[2]) then
				if tonumber(Data[2]) > 100 then
					SendMessage("Woah there.. the max walkspeed is 100.")
					return
				end
				if tonumber(Data[2]) < 5 then
					SendMessage("Don't make the bot a snail! The lowest u can go is 5 sorry lol")
					return
				end

				Humanoid.WalkSpeed = Data[2]
				SendMessage("Successfully set Walk Speed to "..Data[2])
			else
				SendMessage("Walk Speed must be a number! Example: !ws 25")
			end

		end,
	},
	[7] = {
		Name = "turn",
		Aliases = {"face","look"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)

			local Character = Client.Character
			local SenderCharacter = Sender.Character
			local SenderHRP = SenderCharacter.HumanoidRootPart

			Character.HumanoidRootPart.CFrame = CFrame.new(Character.HumanoidRootPart.Position, SenderHRP.Position)
		end,
	},
	[8] = {
		Name = "walk",
		Aliases = {"move"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			if Following ~= nil then
				SendMessage(Sender.DisplayName..", the bot is following someone.")
			end
			local Character = Client.Character
			local Humanoid = Character.Humanoid
			local SenderCharacter = Sender.Character
			local SenderHRP = SenderCharacter.HumanoidRootPart

			Character.Humanoid:MoveTo(SenderHRP.Position)

		end	
	},
	[9] = {
		Name = "createwp",
		Aliases = {"createwaypoint","cwp"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			if not Data[2] then
				RBXGeneral:SendAsync("Waypoint name is required!", LocalSource)
				return "Waypoint name is required!"
			end

			local waypoint = Data[2]

			local sourceCharacter = PlayersService:FindFirstChild(Sender.Name).Character
			local LocalCharacter = Client.Character
			local LocalHumanoid = LocalCharacter.Humanoid

			if workspace:FindFirstChild("Waypoints") then
				if workspace.Waypoints:FindFirstChild(waypoint) then
					RBXGeneral:SendAsync("Waypoint already exists!", LocalSource)
				else
					local newWaypoint = Instance.new("Part", workspace.Waypoints)
					newWaypoint.Anchored = true
					newWaypoint.CanCollide = false
					newWaypoint.Position = sourceCharacter.HumanoidRootPart.Position
					newWaypoint.Name = waypoint

					RBXGeneral:SendAsync("Successfully created waypoint "..waypoint.."!", LocalSource)
				end
			else
				RBXGeneral:SendAsync("No waypoints folder found! Creating a new one..", LocalSource)
				task.wait(0.1)
				local wps = Instance.new("Folder",workspace)
				wps.Name = "Waypoints"
				RBXGeneral:SendAsync("Success! Please retry your action.", LocalSource)
			end
		end,
	},
	[10] = {
		Name = "wp",
		Aliases = {"waypoint"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			if Following ~= nil then
				SendMessage(Sender.DisplayName..", the bot is following someone.")
			end

			if not Data[2] then
				RBXGeneral:SendAsync("Waypoint name is required!", LocalSource)
				return "Waypoint name is required!"
			end

			local LocalCharacter = Client.Character
			local LocalHumanoid: Humanoid = LocalCharacter.Humanoid

			local waypointsToGoTo = {}

			for i,v in pairs(Data) do

				if i ~= 1 then
					table.insert(waypointsToGoTo,v)
				end
			end

			if workspace:FindFirstChild("Waypoints") then
				for i = 1,#waypointsToGoTo do
					if workspace.Waypoints:FindFirstChild(waypointsToGoTo[i]) then

						LocalHumanoid:MoveTo(workspace.Waypoints:FindFirstChild(waypointsToGoTo[i]).Position)

						local next = false

						LocalHumanoid.MoveToFinished:Connect(function()
							next = true
						end)

						repeat task.wait(0.01) until next == true

					else
						RBXGeneral:SendAsync("Waypoint doesn't exist", LocalSource)
					end
				end
			else
				RBXGeneral:SendAsync("No waypoints folder found! Creating a new one..", LocalSource)
				task.wait(0.1)
				local wps = Instance.new("Folder",workspace)
				wps.Name = "Waypoints"
				RBXGeneral:SendAsync("Success! Please retry your action.", LocalSource)
			end
		end,
	},
	[11] = {
		Name = "removewp",
		Aliases = {"removewaypoint","rwp"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			if not Data[2] then
				RBXGeneral:SendAsync("Waypoint name is required!", LocalSource)
				return "Waypoint name is required!"
			end

			local waypoint = Data[2]

			local sourceCharacter = PlayersService:FindFirstChild(Sender.Name).Character
			local LocalCharacter = Client.Character
			local LocalHumanoid = LocalCharacter.Humanoid

			if workspace:FindFirstChild("Waypoints") then
				if workspace.Waypoints:FindFirstChild(waypoint) then
					workspace.Waypoints:FindFirstChild(waypoint):Destroy()
					RBXGeneral:SendAsync("Successfully removed waypoint "..waypoint.."!", LocalSource)
				else
					RBXGeneral:SendAsync("Waypoint doesn't exist!", LocalSource)
				end
			else
				RBXGeneral:SendAsync("No waypoints folder found! Creating a new one..", LocalSource)
				task.wait(0.1)
				local wps = Instance.new("Folder",workspace)
				wps.Name = "Waypoints"
				RBXGeneral:SendAsync("Success! Please retry your action.", LocalSource)
			end
		end,
	},
	[12] = {
		Name = "tpwaypoint",
		Aliases = {"teleportwaypoint","twp"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			if Following ~= nil then
				SendMessage(Sender.DisplayName..", the bot is following someone.")
			end

			if not Data[2] then
				RBXGeneral:SendAsync("Waypoint name is required!", LocalSource)
				return "Waypoint name is required!"
			end

			local waypoint = Data[2]

			local LocalCharacter = Client.Character
			local LocalHumanoid = LocalCharacter.Humanoid

			if workspace:FindFirstChild("Waypoints") then
				if workspace.Waypoints:FindFirstChild(waypoint) then

					LocalCharacter:MoveTo(workspace.Waypoints:FindFirstChild(waypoint).Position)

				else
					RBXGeneral:SendAsync("Waypoint doesn't exist!", LocalSource)
				end
			else
				RBXGeneral:SendAsync("No waypoints folder found! Creating a new one..", LocalSource)
				task.wait(0.1)
				local wps = Instance.new("Folder",workspace)
				wps.Name = "Waypoints"
				RBXGeneral:SendAsync("Success! Please retry your action.", LocalSource)
			end
		end,
	},
	[13] = {
		Name = "cmds",
		Aliases = {"commands"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			SendMessage("Current Commands: tp, walk, jp, ws, jump, sit, chat, waypoint, tpwaypoint, createwaypoint, removewaypoint, turn, delayedchat, spin, randommessage, suggestmessage")
			SendMessage("Say "..Prefix.."help <command> to get help on that command. (Example: "..Prefix.."help tp)")
		end,
	},
	[14] = {
		Name = "help",
		Aliases = {"h"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			local Definitions = {
				["tp"] = "Teleports the bot to you. (Example: "..Prefix.."tp)",
				["walk"] = "Makes the bot walk toward you. (NO PATHFINDING) (Example: "..Prefix.."walk)",
				["jp"] = "Sets the bots jumppower. (Example: "..Prefix.."jp 50)",
				["ws"] = "Sets the bots walkspeed. (Example: "..Prefix.."ws 50)",
				["jump"] = "Makes the bot jump. (Example: "..Prefix.."jump)",
				["chat"] = "Makes the bot chat (Pls dont put bad things). (Example: "..Prefix.."chat I'm a bot!)",
				["waypoint"] = "Makes the bot travel to a created waypoint. (Example: "..Prefix.."waypoint test)",
				["tpwaypoint"] = "Teleports the bot to a created waypoint. (Example: "..Prefix.."tpwaypoint test)",
				["createwaypoint"] = "Creates a waypoint where you are standing. (Example: "..Prefix.."createwaypoint test)",
				["removewaypoint"] = "Removes a created waypoint. (Example: "..Prefix.."removewaypoint test)",
				["turn"] = "Makes the bot face you. (Example: "..Prefix.."turn)",
				["sit"] = "Makes the bot sit. (Example: "..Prefix.."sit)",
				["spin"] = "Makes the bot spin for 10 seconds (You can spam !spin to make it go faster). (Example: "..Prefix.."spin)",
				["delayedchat"] = "Makes the bot chat after a specified amount of seconds. (Example: "..Prefix.."delayedchat 5 I'm a bot!)",
                ["randommessage"] = "Sends a random message. (Example: "..Prefix.."randommessage)",
                ["suggestmessage"] = "Suggests a random message for the random messages list. (Example: "..Prefix.."suggestmessage)",
			}

			if Definitions[string.lower(Data[2])] then
				SendMessage(Definitions[string.lower(Data[2])])
			else
				SendMessage("Couldn't find the definition for command "..Data[2])
			end
		end,
	},
	[15] = {
		Name = "disablecmd",
		Aliases = {"disable","disablecommand"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		Function = function(Sender, Data)
			if not Data[2] then
				SendMessage("Please provide a command.")
			end

			DisableCommand(Data[2])
		end,
	},
	[16] = {
		Name = "enablecmd",
		Aliases = {"enable","enablecommand"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		Function = function(Sender, Data)
			if not Data[2] then
				SendMessage("Please provide a command.")
			end

			EnableCommand(Data[2])
		end,
	},
	[17] = {
		Name = "lockcmd",
		Aliases = {"lock","lockcommand"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		Function = function(Sender, Data)
			if not Data[2] then
				SendMessage("Please provide a command.")
			end

			LockCommand(Data[2])
		end,
	},
	[18] = {
		Name = "unlockcmd",
		Aliases = {"unlock","unlockcommand"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		Function = function(Sender, Data)
			if not Data[2] then
				SendMessage("Please provide a command.")
			end

			UnlockCommand(Data[2])
		end,
	},
	[19] = {
		Name = "delayedchat",
		Aliases = {"delayedtalk"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			local Compile = {}

			if not tonumber(Data[2]) then
				SendMessage("Please make the delay amount a number!")
			end

			for i,v in pairs(Data) do
				if v ~= Data[2] then
					if v ~= Data[1] then
						table.insert(Compile, v)
					end
				end
			end

			local CompiledMessage = table.concat(Compile, " ")
			print(Sender.Name.." made the bot chat "..CompiledMessage)

			task.wait(Data[2])

			SendMessage(CompiledMessage)
		end,
	},
	[20] = {
		Name = "prefix",
		Aliases = {"p"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		Function = function(Sender, Data)
			if not Data[2] then
				SendMessage("Please provide a prefix.")
			end

			Prefix = Data[2]
			SendMessage("Successfully set prefix to "..Data[2]..". Superadmins can still use default prefix.")
		end,
	},
	[21] = {
		Name = "saynextchat",
		Aliases = {"snc"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			SendMessage("Success! I will now repeat your next chat.")

			table.insert(NextChat, Sender.Name)
		end,
	},
	[22] = {
		Name = "follow",
		Aliases = {},
		Enabled = true,
		SuperAdminOnly = true,
		CustomCallback = "%s, this feature is unavailable for you right now.",
		Bypassers = {},
		Function = function(Sender, Data)

            local JumpDebounce = true

			if Following ~= nil then
				SendMessage(Sender.DisplayName..", the bot is already following someone.")
			else
				Following = Sender

				repeat
					task.wait(0.001)
					local Character = Client.Character
					local Humanoid = Character.Humanoid
					local SenderCharacter = Sender.Character
					local SenderHRP = SenderCharacter.HumanoidRootPart

					SenderCharacter.Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
						if JumpDebounce then
							if Following then
								if not Ended then
									print("Jump")
									JumpDebounce = false
									Jump()
									print("tried to jump lol")
									JumpDebounce = true
								end
							end
						end
					end)

					SenderCharacter.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
						if Following then
							if not Ended then
								Jump()
								print("WS Updated")
								Humanoid.WalkSpeed = SenderCharacter.Humanoid.WalkSpeed
							end
						end
					end)

					Character.Humanoid:MoveTo(SenderHRP.Position)

				until Following == nil
				SendMessage("Following has stopped.")
			end
		end	
	},
	[23] = {
		Name = "unfollow",
		Aliases = {},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		CustomCallback = "%s, this feature is unavailable for you right now.",
		Function = function(Sender, Data)

			if Following == nil then
				SendMessage(Sender.DisplayName..", the bot is not following someone.")
			else
				Following = nil
			end
		end	
	},
	[24] = {
		Name = "shutdown",
		Aliases = {"sd"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		Function = function(Sender, Data)
			SendMessage("Shutting down Bot.lua")
			Ended = true
		end	
	},
	[25] = {
		Name = "kill",
		Aliases = {},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {},
		Function = function(Sender, Data)
			SendMessage("Killing bot..")
			task.wait(2)
			Client:Kick("Kill request by "..Sender.Name)
		end	
	},
	[26] = {
		Name = "block",
		Aliases = {"blacklist"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {"ColeMonster1313", "Kitty71232"},
		Function = function(Sender, Data)
			if not Data[2] then
				SendMessage("Please provide a username.")
			end
			
			local BlockPlr
			
			local Success, result = pcall(function()
				for i,v in pairs(game.Players:GetChildren()) do
					local Lower = string.lower(v.Name)
					if Lower == string.lower(Data[2]) then
						BlockPlr = v
						return
					end
					if string.find(Lower, string.lower(Data[2])) then
						BlockPlr = v
						return
					end
					if string.find(string.lower(v.DisplayName), string.lower(Data[2])) then
						BlockPlr = v
						return
					end
				end
			end)
			
			if not Success then
				warn(result)
				SendMessage(result)
				return
			end
			
			if not BlockPlr then
				SendMessage("Player "..Data[2].." doesn't exist")
				return
			end
			if table.find(Blocked, BlockPlr.Name) then
				SendMessage(game.Players[BlockPlr.Name].DisplayName.." is already blocked lol")
				return
			end
			
			SendMessage("Successfully blocked "..game.Players[BlockPlr.Name].DisplayName..".")
			table.insert(Blocked, BlockPlr.Name)
		end,
	},
	[27] = {
		Name = "unblock",
		Aliases = {"unblacklist"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {"ColeMonster1313", "Kitty71232"},
		Function = function(Sender, Data)
			if not Data[2] then
				SendMessage("Please provide a username.")
			end

			local BlockPlr

			local Success, result = pcall(function()
				for i,v in pairs(game.Players:GetChildren()) do
					local Lower = string.lower(v.Name)
					if Lower == string.lower(Data[2]) then
						BlockPlr = v
						return
					end
					if string.find(Lower, string.lower(Data[2])) then
						BlockPlr = v
						return
					end
					if string.find(string.lower(v.DisplayName), string.lower(Data[2])) then
						BlockPlr = v
						return
					end
				end
			end)
			
			if not Success then
				warn(result)
				SendMessage(result)
				return
			end
			
			if not BlockPlr then
				SendMessage("Player "..Data[2].." doesn't exist")
				return
			end

			if table.find(Blocked, BlockPlr.Name) then
				SendMessage("Successfully unblocked "..game.Players[BlockPlr.Name].DisplayName.."")
				
				local function FindPositionOnTable(Table, Item)
					for i,v in pairs(Table) do
						if v == Item then
							return i
						end
					end
				end
				
				table.remove(Blocked, FindPositionOnTable(Blocked, BlockPlr.Name))
			else
				SendMessage("Player "..BlockPlr.Name.." doesn't exist")
			end
		end,
	},

	[28] = {
		Name = "fakeglobalmessage",
		Aliases = {"fakega","cheeselol"},
		Enabled = true,
		SuperAdminOnly = true,
		CustomPrefix = "/w ",
		Bypassers = {},
		Function = function(Sender, Data)

			local Compile = {}

			for i,v in pairs(Data) do
				if v ~= Data[1] then
					table.insert(Compile, v)
				end
			end

			local CompiledMessage = table.concat(Compile, " ")

			SendMessage(string.format(FakeGATemplate, CompiledMessage))

			print(Sender.Name.." made the bot fake global announce "..CompiledMessage)
		end,
	},

	[29] = {
		Name = "blocked",
		Aliases = {"blacklisted"},
		Enabled = true,
		SuperAdminOnly = true,
		Bypassers = {"ColeMonster1313", "Kitty71232"},
		Function = function(Sender, Data)
			SendMessage(table.concat(Blocked, " "))
		end,
	},
	[30] = {
		Name = "spin",
		Aliases = {},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			
			if spinning then
				return
			end

			local tick = true
			local ticks = 0

            task.spawn(function()
                repeat
					task.wait(1)
					ticks = ticks +1
				until ticks == 10

				tick = false
			end)

			while tick do
				task.wait(0.01)

				local Character = Client.Character
			    local SenderCharacter = Sender.Character
			    local SenderHRP = SenderCharacter.HumanoidRootPart
 
			    Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(3), 0)
			end

			spinning = false
		end	
	},
	[31] = {
		Name = "whatsthewalkspeed",
		Aliases = {"wtws"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			local Character = Client.Character
			local Humanoid = Character.Humanoid
			local SenderCharacter = Sender.Character
			local SenderHRP = SenderCharacter.HumanoidRootPart

			SendMessage(Humanoid.WalkSpeed)

		end	
	},
    [32] = {
		Name = "randommessage",
		Aliases = {"rm"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)

            print(RMS[math.random(1,#RMS)])

            SendMessage(RMS[math.random(1,#RMS)])

		end	
	},
    [33] = {
		Name = "run",
		Aliases = {},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			
            SendMessage("The run command is broken at this time. Idk how to fix it.")

		end	
	},
    [34] = {
		Name = "credits",
		Aliases = {},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			
            SendMessage("Bot Developer: fryingpan923")
            task.wait(0.1)
            SendMessage("Powered by: Electron and Fluster (along with Bluestacks)")

		end	
	},
    [35] = {
		Name = "suggestmessage",
		Aliases = {"sm"},
		Enabled = true,
		SuperAdminOnly = false,
		Bypassers = {},
		Function = function(Sender, Data)
			
            if not Data[2] then
                SendMessage("Don't leave your suggestion blank!")
                return
            end

            local Compile = {}

			for i,v in pairs(Data) do
				if v ~= Data[1] then
					table.insert(Compile, v)
				end
			end

			local CompiledMessage = table.concat(Compile, " ")

            rm(Sender.Name.." sent a message suggestion: "..CompiledMessage)

            SendMessage("Thanks for the suggestion! Your response has been recorded.")

		end	
	},
}

function Jump()
	local tick = 0
	repeat
         wait(0.1)
		 tick = tick +1
	until tick == 3
    game.Players.LocalPlayer.Character.Humanoid.Jump = true
end

function DisableCommand(Cmd)
	for i,v in pairs(Commands) do
		if v.Name == Cmd then
			v.Enabled = false
			SendMessage("Successfully disabled command "..Cmd..".")
			return
		else
			if table.find(v.Aliases, Cmd) then
				v.Enabled = false
				SendMessage("Successfully disabled command "..Cmd..".")
				return
			end
		end
	end

	SendMessage("Couldn't find command "..Cmd..".")
end

function LockCommand(Cmd)
	for i,v in pairs(Commands) do
		if v.Name == Cmd then
			v.SuperAdminOnly = true
			SendMessage("Successfully locked command "..Cmd..".")
			return
		else
			if table.find(v.Aliases, Cmd) then
				v.SuperAdminOnly = true
				SendMessage("Successfully locked command "..Cmd..".")
				return
			end
		end
	end

	SendMessage("Couldn't find command "..Cmd..".")
end

function UnlockCommand(Cmd)
	for i,v in pairs(Commands) do
		if v.Name == Cmd then
			v.SuperAdminOnly = false
			SendMessage("Successfully unlocked command "..Cmd..".")
			return
		else
			if table.find(v.Aliases, Cmd) then
				v.SuperAdminOnly = false
				SendMessage("Successfully unlocked command "..Cmd..".")
				return
			end
		end
	end

	SendMessage("Couldn't find command "..Cmd..".")
end

function EnableCommand(Cmd)
	for i,v in pairs(Commands) do
		if v.Name == Cmd then
			v.Enabled = true
			SendMessage("Successfully enabled command "..Cmd..".")
			return
		else
			if table.find(v.Aliases, Cmd) then
				v.Enabled = true
				SendMessage("Successfully enabled command "..Cmd..".")
				return
			end
		end
	end

	SendMessage("Couldn't find command "..Cmd..".")
end

function FCOM(Source, Message)
	if Ended then
		return
	end
	
	local Split = Message:split(" ")
	local SourceInstance = Source

	local CommandExists = false
	local Command = string.lower(string.sub(Split[1], string.len(Prefix) + 1, string.len(Split[1])))

	for i,v in pairs(Commands) do

		if v.Name == Command then
			CommandExists = true
			if v.Enabled then
				if table.find(Blocked, SourceInstance.Name) then
					if table.find(SuperAdmins, SourceInstance.Name) then
						warn(SourceInstance.Name.." is blocked, but is a super admin, so we allowed them.")
					else
						return
					end
				end
				
				if v.SuperAdminOnly then
					if table.find(SuperAdmins, SourceInstance.Name) then
						v.Function(SourceInstance, Split)
					else
						if v.Bypassers then
							if table.find(v.Bypassers, SourceInstance.Name) then
								warn(Source.Name.." is attempting to run "..Command)
								v.Function(SourceInstance, Split)
							else
								warn(Source.Name.." is attempting to run "..Command.." but doesn't have permission!")
								if v.CustomCallback then
									SendMessage(string.format(v.CustomCallback, SourceInstance.DisplayName))
								else
									SendMessage(SourceInstance.DisplayName..", you don't have permission to run "..Command..".")
								end
							end
						else
							warn(Source.Name.." is attempting to run "..Command.." but doesn't have permission!")
							if v.CustomCallback then
								SendMessage(string.format(v.CustomCallback, SourceInstance.DisplayName))
							else
								SendMessage(SourceInstance.DisplayName..", you don't have permission to run "..Command..".")
							end
						end
					end
				else
					warn(Source.Name.." is attempting to run "..Command)
					v.Function(SourceInstance, Split)
				end
			else
				SendMessage(SourceInstance.DisplayName..", the command "..Command.." is disabled.")
				warn(Source.Name.." tried to use command "..Command.." but it is disabled.")
			end
		else
			if table.find(v.Aliases, Command) then
				CommandExists = true
				if v.Enabled then
					if v.SuperAdminOnly then
						if table.find(SuperAdmins, SourceInstance.Name) then
							v.Function(SourceInstance, Split)
						else
							if v.Bypassers then
								if table.find(v.Bypassers, SourceInstance.Name) then
									warn(Source.Name.." is attempting to run "..Command)
									v.Function(SourceInstance, Split)
								else
									warn(Source.Name.." is attempting to run "..Command.." but doesn't have permission!")
									if v.CustomCallback then
										SendMessage(string.format(v.CustomCallback, SourceInstance.DisplayName))
									else
										SendMessage(SourceInstance.DisplayName..", you don't have permission to run "..Command..".")
									end
								end
							else
								warn(Source.Name.." is attempting to run "..Command.." but doesn't have permission!")
								if v.CustomCallback then
									SendMessage(string.format(v.CustomCallback, SourceInstance.DisplayName))
								else
									SendMessage(SourceInstance.DisplayName..", you don't have permission to run "..Command..".")
								end
							end
						end
					else
						warn(Source.Name.." is attempting to run "..Command)
						v.Function(SourceInstance, Split)
					end
				else
					SendMessage(SourceInstance.DisplayName..", the command "..Command.." is disabled.")
					warn(Source.Name.." tried to use command "..Command.." but it is disabled.")
				end
			end
		end
	end

	if not CommandExists then
		SendMessage(SourceInstance.DisplayName..", the command "..Command.." doesn't exist.")
		warn(Source.Name.." tried to run command "..Command.." but it doesn't exist!")
	end
end

function FindCommandOnMessage(Source, Message)
	if Ended then
		return
	end
	
	local Split = Message:split(" ")
	local SourceInstance = Source

	local Command = string.lower(string.sub(Split[1], string.len(Prefix) + 1, string.len(Split[1])))

	if table.find(NextChat, Source.Name) then
		SendMessage(Message)

		local function FindPositionOnTable(Table, Item)
			for i,v in pairs(Table) do
				if v == Item then
					return i
				end
			end
		end

		table.remove(NextChat, FindPositionOnTable(NextChat, Source.Name))
	end

	if string.sub(Message, 1, string.len(Prefix)) == Prefix then
		FCOM(Source, Message)
	else
		if Commands[Command] then
		    if Commands[Command].CustomPrefix then
				if string.sub(Message, 1, string.len(Prefix)) == Commands[Command].CustomPrefix then
					FCOM(Source, Message)
					return
				end
			end
		end
		if table.find(SuperAdmins, SourceInstance.Name) then
			if string.sub(Message, 1, string.len("!")) == "!" then
				FCOM(Source, Message)
			end
		end
	end
end

if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
	if Ended then
		return
	end
	
	LegacyChatService = true
else
	if Ended then
		return
	end
	
	TextChannels = TextChatService:WaitForChild("TextChannels")
	RBXGeneral = TextChannels:WaitForChild("RBXGeneral")
	LocalSource = RBXGeneral:WaitForChild(Client.Name, 60)

	RBXGeneral.MessageReceived:Connect(function(Message)

		local Source = Message.TextSource
		local Message = Message.Text

		local SourceInstance = PlayersService:WaitForChild(Source.Name)

		FindCommandOnMessage(SourceInstance, Message)

	end)
end

function SendMessage(Message)
	if Ended then
		return
	end
	
	if not LegacyChatService then
		local TextChannels = TextChatService:WaitForChild("TextChannels")
		local RBXGeneral = TextChannels:WaitForChild("RBXGeneral")

		RBXGeneral:SendAsync(Message, LocalSource)
	else
		local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
		local SayMessageRequest = DefaultChatSystemChatEvents:WaitForChild("SayMessageRequest")

		SayMessageRequest:FireServer(Message, "All")
	end
end

for i,v in pairs(game.Players:GetChildren()) do
	if Ended then
		return
	end
	
	if LegacyChatService then
		v.Chatted:Connect(function(Message)
			FindCommandOnMessage(v, Message)
		end)
	end
end

game.Players.PlayerAdded:Connect(function(Source)
	if Ended then
		return
	end
	
	if LegacyChatService then
		Source.Chatted:Connect(function(Message)
			FindCommandOnMessage(Source, Message)
		end)
	end
end)

SendMessage("Compiling..")
SendMessage("Bot.lua Started")
