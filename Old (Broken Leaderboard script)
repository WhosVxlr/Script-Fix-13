local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("TimeStats")

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
    
    local Data = DataStore:GetAsync(Player.UserId)
    if Data then
        Minutes.Value = Data
        Coins.Value = Data
    end
    
    coroutine.resume(coroutine.create(function()
        while true do
            wait(60)
            Minutes.Value = Minutes.Value + 1
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
        Player.leaderstats.Coins.Value -= tonumber(ItemPrice)
    end
end)

workspace.ShopPart.ProximityPrompt.Triggered:Connect(function(Player)
    ReplicatedStorage.ShopEvent:FireClient(Player, "Open")
end)

game.Players.PlayerRemoving:Connect(function(Player)
    DataStore:SetAsync(Player.UserId, Player.leaderstats.Minutes.Value)
    DataStore:SetAsync(Player.UserId, Player.leaderstats.Coins.Value)
end)
