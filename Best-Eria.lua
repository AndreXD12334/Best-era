--// SERVICIOS
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// BASE DE DATOS DE HABILIDADES
local abilityData = {
    -- Starter Abilities
    ["Rock Throw"] = {ID = 34, RemoteNames = {"rock-hit"}},
    ["Magic Missile"] = {ID = 1, RemoteNames = {"strike"}},

    -- Mage
    ["Mana Bomb"] = {ID = 4, RemoteNames = {"holo"}},
    ["Thundercall"] = {ID = 77, RemoteNames = {"strike"}},
    ["Zap"] = {ID = 32, RemoteNames = {"bolt"}},

    -- Warrior
    ["Spin Slash"] = {ID = 26, RemoteNames = {"uppercut"}},
    ["Blasting Slash"] = {ID = 80, RemoteNames = {"aftershock-1", "aftershock-2", "aftershock-3", "tombSpike"}},
    ["Ground Slam"] = {ID = 5, RemoteNames = {"spike", "warlord", "warlord-outer", "divineSlam", "divineSlam-sword", "divineSlam-outer", "shockwave", "shockwave-outer", "slash", "aftershock", "agile-strike", "bee-attack", "ghost-fire", "ghost-explode", "ghost-ring"}},

    -- Hunter
    ["Execute"] = {ID = 6, RemoteNames = {"strike", "echo", "strike_aoe", "echo_aoe", "shadowblast", "bleed"}},
    ["Barrage"] = {ID = 15, RemoteNames = {"arrow-1", "arrow-2", "arrow-3", "holo-direct", "holo-reflect", "jade-dot", "ghost-fire", "boom"}},
    ["Shunpo"] = {ID = 13, RemoteNames = {"dash-through", "icicle", "icicle-bomb", "ghost-explode", "ghost-fire", "ghost-ring", "mumpo-hit", "mumpo-slice"}},

    -- Warlock (Mage Subclass)
    ["Pillage Vitality"] = {ID = 40, RemoteNames = {"bolt", "fireworks"}},
    ["Dark Pulse"] = {ID = 59, RemoteNames = {"pulse"}},
    ["Desecrate"] = {ID = 64, RemoteNames = {"pulse"}},
    ["Blood Plague"] = {ID = 78, RemoteNames = {"dot"}},
    ["Chain Binding"] = {ID = 69, RemoteNames = {"bolt"}},

    -- Sorcerer
    ["Frost Storm"] = {ID = 103, RemoteNames = {"blizzard", "blizzard-burst", "iceExplosion"}},
    ["Earth Call"] = {ID = 104, RemoteNames = {"boulder", "seismic"}},
    ["Meteor Storm"] = {ID = 102, RemoteNames = {"explosion", "burn"}},
    ["Unstable Charge"] = {ID = 100, RemoteNames = {"bolt", "electrified"}},
    ["Howling Gale"] = {ID = 99, RemoteNames = {"tornado"}},

    -- Cleric
    ["Spear of Light"] = {ID = 67, RemoteNames = {"spear", "blast"}},
    ["Flare"] = {ID = 50, RemoteNames = {"flare"}},
	["Judgement"] = {ID = 137, RemoteNames = {"excise", "retribution"}},
	["Holy Surge"] = {ID = 168, RemoteNames = {"beam-impact"}},
	["Light Barrage"] = {ID = 167, RemoteNames = {"barrage", "barrage_prime"}},
	

    -- Songweaver
    ["Vibrato"] = {ID = 544, RemoteNames = {"note", "note_encore"}},
    ["Aria Wave"] = {ID = 541, RemoteNames = {"wave"}},

    -- Paladin (Warrior Subclass)
    ["Rebuke"] = {ID = 56, RemoteNames = {"blast", "blast_dullThud", "jadePulse"}},
    ["Consecrate"] = {ID = 70, RemoteNames = {"blast", "pulse", "ghost-fire", "ghost-explode", "ghost-link"}},
    ["Smite"] = {ID = 48, RemoteNames = {"smite", "thunder"}},

    -- Berserker
    ["Ferocious Assault"] = {ID = 60, RemoteNames = {"strike"}},
    ["Blade Spin"] = {ID = 55, RemoteNames = {"spin"}},
    ["Headlong Dive"] = {ID = 68, RemoteNames = {"impact", "firworks"}},
    ["Blood Cleave"] = {ID = 131, RemoteNames = {"cleave", "cleave-projectile", "bleed"}},

    -- Knight
    ["Shield Bash"] = {ID = 61, RemoteNames = {"chargefire", "strike", "tsunami", "jade", "jadeExplosion"}},
    ["Cleave"] = {ID = 128, RemoteNames = {"aftershock1", "aftershock2", "aftershock3", "aftershock4", "aftershock5", "wave"}},
    ["Chain Pull"] = {ID = 127, RemoteNames = {"chain", "ghostflame_tick"}},
    ["Defensive Stance"] = {ID = 129, RemoteNames = {"explosion", "holo"}},

    -- Bard (Hunter Subclass)
    ["Crescendo"] = {ID = 92, RemoteNames = {"note", "eighth-note", "burst"}},
    ["Lullaby"] = {ID = 93, RemoteNames = {"lullaby"}},

    -- Assassin
    ["Shadow Flurry"] = {ID = 43, RemoteNames = {"strike", "fireworks"}},
    ["Ethereal Strike"] = {ID = 79, RemoteNames = {"throw", "teleport"}},
    ["Shadow Volley"] = {ID = 164, RemoteNames = {"impact"}},

    -- Trickster
    ["Prism Trap"] = {ID = 42, RemoteNames = {"trap"}},
    ["Switch Strike"] = {ID = 41, RemoteNames = {"bolt"}},
    ["Bubble Burst"] = {ID = 65, RemoteNames = {"bolt1", "bolt2", "bolt3"}},
    ["Disengage"] = {ID = 51, RemoteNames = {"shot"}},

    -- Ranger
    ["Hail of Arrows"] = {ID = 36, RemoteNames = {"quarterSecondDamage"}},
    ["Ricochet"] = {ID = 31, RemoteNames = {"initial", "bounce"}},
}
--// LISTA DE MOBS
local listaDeMobs = {
    "Eldering Shroom", "Dummy", "Chicken", "Crabby", "Elder Shroom", "Ent Sapling", "Goblin", "Guardian", "Rubee", "Scarecrow", "Shroom", "Spider", "Spider Queen", "Spiderling", "Moglo", "Ratty", "Batty", "Trickster Spirit", "Baby Yeti", "Undead", "The Yeti", "Hog", "Redwood Bandit", "Mo Ko Tu Aa", "Treemuk", "Terror of the Deep", "Bandit Skirmisher", "Bandit", "Shaman", "Chad", "Guardian Dummy", "Horseshoe Crab", "Mogloko", "Stingtail", "Scarab", "Dustwurm", "Gauntlet Gate", "Deathsting", "Possum the Devourer", "Slime", "Baby Slime", "Big Slime", "Baby Yeti Tribute", "Pit Ratty", "Reanimated Slime", "Gorgog Guardian", "Aevrul", "Pirate", "Rootbeard", "Tortoise", "Bamboo Mage", "Humanoid", "Shade", "Skull Boss", "Parasite Host", "Frightcrow", "Enchanted Slime", "Rock Slime", "Reaper", "Tumbleweed", "Monster", "Battering Shroom", "Ethera", "Pirate Captain", "Miner Prisoner", "First Mate", "Birthday Mage", "Fish", "Pirate Summon", "Parasite", "Orc", "Hermit Crabby", "Sunken Savage", "Cultist", "Wisp", "Runic Titan", "Tribute Gate", "Mosquito Parasite", "Gecko", "Prisoner", "Skeleton", "Mama Hermit Crabby", "Boar", "Book", "Crow", "Fly Trap", "Lost Spirit", "Enchiridion", "Jellyfish", "Mimic Jester", "Snel", "Ram", "Bear", "Redwood Bandit Leader", "Baby Scarab", "Bushi", "Ronin", "Samurai", "Sensei", "Shinobi", "Dark Cleric", "Master Miyamoto", "Dragon Boss", "Mummy", "Cow", "Dragon Monk", "Kobra", "Hag", "Ethereal Monarch", "Ghostflame Wisp", "Soulcage", "Baby Shroom", "Bull", "Mimic", "Toni", "Tal Rey", "Scorpentar", "Tombwurm"
}

--// FUNCIONES DE UTILIDAD
local function isValidGUID(guid)
    return typeof(guid) == "string" and #guid == 36 and string.match(guid, "^%x+%-%x+%-%x+%-%x+%-%x+$") ~= nil
end

local function isValidExecutionData(data)
    return typeof(data) == "table" and data["id"] ~= 0 and isValidGUID(data["ability-guid"])
end

local function getAbilityGUIDFromData(dataTable)
    for _, data in pairs(dataTable) do
        if isValidExecutionData(data) then
            return data["ability-guid"], data["id"]
        end
    end
    return nil, nil
end

local function getAbilityGUIDAndID()
    local player = Players.LocalPlayer
    local charModel = workspace.placeFolders.entityManifestCollection:FindFirstChild(player.Name)
    if not charModel then return nil end

    local Hitbox = charModel:FindFirstChild("hitbox")
    if not Hitbox then return nil end

    local ExecutionDataValue = Hitbox:FindFirstChild("activeAbilityExecutionData")
    if not ExecutionDataValue or not ExecutionDataValue.Value then return nil end

    local success, parsed = pcall(function()
        return HttpService:JSONDecode(ExecutionDataValue.Value)
    end)
    if not success or typeof(parsed) ~= "table" then
        return nil
    end

    if isValidExecutionData(parsed) then
        return parsed["ability-guid"], parsed["id"]
    end

    return getAbilityGUIDFromData(parsed)
end

local function getRemoteNamesFromID(id)
    for _, data in pairs(abilityData) do
        if data.ID == id then
            return data.RemoteNames
        end
    end
end

--// FUNCION ACTUALIZADA PARA AGRUPAR MOBS POR NOMBRE
local function obtenerMobsAgrupados()
    local grupos = {}

    for _, instancia in ipairs(workspace.placeFolders.entityManifestCollection:GetChildren()) do
        if instancia:IsA("BasePart") and table.find(listaDeMobs, instancia.Name) then
            grupos[instancia.Name] = grupos[instancia.Name] or {}
            table.insert(grupos[instancia.Name], instancia)
        end
    end

    return grupos
end

--// CACHE
local cachedGUID, cachedID = nil, nil

--// ACTUALIZAR GUID/ID
task.spawn(function()
    while true do
        local nuevoGUID, nuevoID = getAbilityGUIDAndID()
        if nuevoGUID and nuevoGUID ~= cachedGUID then
            cachedGUID = nuevoGUID
            cachedID = nuevoID
        end
        task.wait(0.1)
    end
end)

--// NUEVO CICLO DE ATAQUE AGRUPADO POR MOBS
task.spawn(function()
    while true do
        local success, err = pcall(function()
            if cachedGUID and cachedID then
                local gruposDeMobs = obtenerMobsAgrupados()
                local remoteNames = getRemoteNamesFromID(cachedID)
                local remoteEvent = ReplicatedStorage:WaitForChild("network"):WaitForChild("RemoteEvent"):WaitForChild("playerRequest_damageEntity_batch")

                for mobName, grupo in pairs(gruposDeMobs) do
                    for _, remoteName in ipairs(remoteNames) do
                        local ataques = {}

                        for _, mob in ipairs(grupo) do
                            table.insert(ataques, {
                                mob,
                                mob.Position,
                                "ability",
                                cachedID,
                                remoteName,
                                cachedGUID
                            })
                        end

                        remoteEvent:FireServer(ataques)
                    end
                end
            end
        end)

        if not success then
        end
        task.wait(0.1)
    end
end)
