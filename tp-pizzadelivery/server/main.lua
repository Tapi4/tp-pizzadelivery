QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('tp-pizzadelivery:completeDelivery')
AddEventHandler('tp-pizzadelivery:completeDelivery', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.AddMoney('cash', Config.DeliveryReward)
        Player.Functions.RemoveItem(Config.PizzaItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PizzaItem], "remove")
        TriggerClientEvent('QBCore:Notify', src, 'Delivery completed! You earned $'..Config.DeliveryReward, 'success')
    end
end)

RegisterServerEvent('tp-pizzadelivery:givePizzaItem')
AddEventHandler('tp-pizzadelivery:givePizzaItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.AddItem(Config.PizzaItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PizzaItem], "add")
    end
end)

RegisterServerEvent('tp-pizzadelivery:removePizzaItem')
AddEventHandler('tp-pizzadelivery:removePizzaItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.RemoveItem(Config.PizzaItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PizzaItem], "remove")
    end
end)
