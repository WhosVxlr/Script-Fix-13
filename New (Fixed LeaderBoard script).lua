local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataStoreService = game:GetService("DataStoreService")
local DataStore_Minutes = DataStoreService:GetDataStore("TimeStats_Minutes")
local DataStore_Coins = DataStoreService:GetDataStore("TimeStats_Coins")

Players.PlayerAdded:Connect(function(Player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = Player
    
    local Coins = Instance.new("NumberValue")
    Coins.Value = 0
    Coins.Name = "Coins"
    Coins.Parent = leaderstats
    
    local Minutes = Instance.new("IntValue")
    Minutes.Name = "Minutes"
    Minutes.Value = 0
    Minutes.Parent = leaderstats
    
    local MinutesData = DataStore_Minutes:GetAsync(Player.UserId)
    if MinutesData then
        Minutes.Value = MinutesData
    end
    
    local CoinsData = DataStore_Coins:GetAsync(Player.UserId)
    if CoinsData then
        Coins.Value = CoinsData
    end
    
    coroutine.resume(coroutine.create(function()
        while true do
            wait(60)
            Minutes.Value = Minutes.Value + 1
            DataStore_Minutes:SetAsync(Player.UserId, Minutes.Value)
        end
    end))
    
end)

ReplicatedStorage.ShopEvent.OnServerEvent:Connect(function(Player, ItemName, ItemPrice)
    if not Player then return end
    if not ItemName then return end
    if not ItemPrice then return end
    if Player.leaderstats.Coins.Value >= tonumber(ItemPrice) then 
        local ItemClone = ReplicatedStorage.ShopItems[ItemName]:Clone()
        ItemClone.Parent = Player.Backpack
        Player.leaderstats.Coins.Value = Player.leaderstats.Coins.Value - tonumber(ItemPrice)
        DataStore_Coins:SetAsync(Player.UserId, Player.leaderstats.Coins.Value)
    end
end)

workspace.ShopPart.ProximityPrompt.Triggered:Connect(function(Player)
    ReplicatedStorage.ShopEvent:FireClient(Player, "Open")
end)

game.Players.PlayerRemoving:Connect(function(Player)
    DataStore_Minutes:SetAsync(Player.UserId, Player.leaderstats.Minutes.Value)
    DataStore_Coins:SetAsync(Player.UserId, Player.leaderstats.Coins.Value)
end)
