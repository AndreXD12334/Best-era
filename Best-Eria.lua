local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 📌 Configuración para modificar `entityManifestCollection`
local folder = workspace.placeFolders.entityManifestCollection
local originalSize = Vector3.new(3, 3, 3)
local newSize = Vector3.new(1000, 1000, 1000)
local sizeChangeEnabled = false -- Estado inicial desactivado

-- 📌 Lista de nombres de mobs que se deben modificar (Ordenados alfabéticamente)
local monsterList = {
    "Aevrul", "Baby Scarab", "Baby Shroom", "Baby Slime", "Baby Yeti", "Baby Yeti Tribute",
    "Bamboo Mage", "Bandit", "Bandit Skirmisher", "Battering Shroom", "Batty", "Bear",
    "Big Slime", "Birthday Mage", "Boar", "Book", "Bushi", "Chad", "Chicken", "Crabby",
    "Crow", "Cultist", "Dark Cleric", "Deathsting", "Dragon Boss", "Dragon Monk", "Dummy",
    "Dustwurm", "Eldering Shroom", "Elder Shroom", "Enchanted Slime", "Enchiridion",
    "Ent Sapling", "Ethera", "Ethereal Monarch", "Frightcrow", "Fish", "First Mate",
    "Fly Trap", "Gauntlet Gate", "Gecko", "Goblin", "Gorgog Guardian", "Guardian",
    "Guardian Dummy", "Hag", "Hermit Crabby", "Hitbox", "Hog", "Horseshoe Crab", "Humanoid",
    "Jellyfish", "Kobra", "Lil Shroomie Cage", "Lobster", "Lost Spirit", "Mama Hermit Crabby",
    "Master Miyamoto", "Mimic Jester", "Miner Prisoner", "Mo Ko Tu Aa", "Mogloko", "Moglo",
    "Monster", "Mosquito Parasite", "Mummy", "Orc", "Parasite", "Parasite Host",
    "Pirate", "Pirate Captain", "Pirate Summon", "Pit Ratty", "Possum the Devourer",
    "Prisoner", "Ram", "Ratty", "Reanimated Slime", "Reaper", "Redwood Bandit",
    "Redwood Bandit Leader", "Rock Slime", "Rootbeard", "Rubee", "Runic Titan",
    "Samurai", "Scarab", "Scarecrow", "Sensei", "Shade", "Shaman", "Shinobi", "Shroom",
    "Skeleton", "Skull Boss", "Slime", "Snel", "Soulcage", "Spider", "Spider Queen",
    "Spiderling", "Stingtail", "Sunken Savage", "Terror of the Deep", "The Yeti",
    "Toni", "Tortoise", "Treemuk", "Tribute Gate", "Trickster Spirit", "Tumbleweed",
    "Undead", "Wisp"
}

-- 📌 Convertir la lista a una tabla rápida para búsqueda
local monsterLookup = {}
for _, name in ipairs(monsterList) do
    monsterLookup[name] = true
end

-- 📌 Función para verificar si una parte pertenece a un mob de la lista
local function shouldModify(part)
    return monsterLookup[part.Name] ~= nil
end

-- 📌 Función para cambiar tamaño de los mobs
local function processParts(size)
    for _, part in pairs(folder:GetDescendants()) do
        if part:IsA("BasePart") and shouldModify(part) then
            part.Size = size
            part.CanCollide = false
        end
    end
end

-- 📌 Monitorear cambios en la carpeta y aplicar cambios en tiempo real
folder.DescendantAdded:Connect(function(descendant)
    if sizeChangeEnabled and descendant:IsA("BasePart") and shouldModify(descendant) then
        descendant.Size = newSize
        descendant.CanCollide = false
    end
end)

-- 📌 Configuración para recoger ítems automáticamente
local PickUpItemRequest = ReplicatedStorage:WaitForChild("network"):WaitForChild("RemoteFunction"):WaitForChild("pickUpItemRequest")
local ItemsFolder = workspace:WaitForChild("placeFolders"):WaitForChild("items")
local UserId = "7037073399"
local autoPickupEnabled = false -- Estado inicial desactivado

local function pickUpOwnedItems()
    for _, item in ipairs(ItemsFolder:GetChildren()) do
        local ownersFolder = item:FindFirstChild("owners")
        if ownersFolder and ownersFolder:FindFirstChild(UserId) then
            PickUpItemRequest:InvokeServer(item)
        end
    end
end

ItemsFolder.ChildAdded:Connect(function(item)
    if autoPickupEnabled then
        local ownersFolder = item:FindFirstChild("owners")
        if ownersFolder and ownersFolder:FindFirstChild(UserId) then
            PickUpItemRequest:InvokeServer(item)
        end
    end
end)

-- 📌 Detección de teclas para activar/desactivar los scripts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- 🔹 Alternar cambio de tamaño con "X"
    if input.KeyCode == Enum.KeyCode.X then
        sizeChangeEnabled = not sizeChangeEnabled
        if sizeChangeEnabled then
            processParts(newSize)
            print("✅ Cambio de tamaño ACTIVADO (1000,1000,1000)")
        else
            processParts(originalSize)
            print("❌ Cambio de tamaño DESACTIVADO (Volviendo a 3,3,3)")
        end
    end

    -- 🔹 Alternar auto-pickup con "Z"
    if input.KeyCode == Enum.KeyCode.Z then
        autoPickupEnabled = not autoPickupEnabled
        print(autoPickupEnabled and "✅ Auto Pickup ACTIVADO" or "❌ Auto Pickup DESACTIVADO")
    end
end)