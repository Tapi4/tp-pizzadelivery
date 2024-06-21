QBCore = exports['qb-core']:GetCoreObject()

local deliveryPoint = nil
local deliveryBlip = nil
local isOnDelivery = false
local deliveryPed = nil
local holdingPizzaProp = false
local pizzaProp = nil

CreateThread(function()
    local model = Config.PizzaDeliveryNPC.model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    local npc = CreatePed(4, model, Config.PizzaDeliveryNPC.coords.x, Config.PizzaDeliveryNPC.coords.y, Config.PizzaDeliveryNPC.coords.z, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                type = 'client',
                event = 'tp-pizzadelivery:openMenu',
                icon = 'fas fa-pizza-slice',
                label = Config.PizzaDeliveryNPC.targetLabel,
            }
        },
        distance = Config.PizzaDeliveryNPC.interactionDistance,
    })
end)

RegisterNetEvent('tp-pizzadelivery:openMenu', function()
    exports['qb-menu']:openMenu({
        {
            header = "Pizza Delivery Job",
            isMenuHeader = true,
        },
        {
            header = "Start Working",
            txt = "Begin delivering pizzas",
            params = {
                event = "tp-pizzadelivery:startJob",
            }
        },
        {
            header = "Stop Working",
            txt = "End your delivery job",
            params = {
                event = "tp-pizzadelivery:stopJob",
            }
        }
    })
end)

RegisterNetEvent('tp-pizzadelivery:startJob', function()
    if not isOnDelivery then
        isOnDelivery = true
        local randomPoint = Config.DeliveryPoints[math.random(#Config.DeliveryPoints)]
        deliveryPoint = randomPoint
        deliveryBlip = AddBlipForCoord(deliveryPoint.x, deliveryPoint.y, deliveryPoint.z)
        SetBlipSprite(deliveryBlip, 1)
        SetBlipColour(deliveryBlip, 5)
        SetBlipAsShortRange(deliveryBlip, true)
        SetBlipRoute(deliveryBlip, true)
        SetBlipRouteColour(deliveryBlip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Delivery Point")
        EndTextCommandSetBlipName(deliveryBlip)

        QBCore.Functions.Notify("Deliver the pizza to the marked location!", "success")
        TriggerServerEvent('tp-pizzadelivery:givePizzaItem')

        local playerPed = PlayerPedId()
        local vehicleHash = GetHashKey(Config.VehicleModel)

        RequestModel(vehicleHash)
        while not HasModelLoaded(vehicleHash) do
            Wait(1)
        end

        local vehicle = CreateVehicle(vehicleHash, 185.0, -1424.88, 29.24, 0.0, true, false)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    else
        QBCore.Functions.Notify("You are already on a delivery!", "error")
    end
end)

RegisterNetEvent('tp-pizzadelivery:stopJob', function()
    if isOnDelivery then
        isOnDelivery = false
        if deliveryBlip then
            RemoveBlip(deliveryBlip)
            deliveryBlip = nil
        end
        if deliveryPed then
            DeleteEntity(deliveryPed)
            deliveryPed = nil
        end
        TriggerServerEvent('tp-pizzadelivery:removePizzaItem')
        if holdingPizzaProp then
            ClearPedTasks(PlayerPedId())
            DeleteObject(pizzaProp)
            holdingPizzaProp = false
        end
        QBCore.Functions.Notify("You have stopped working.", "error")
    else
        QBCore.Functions.Notify("You are not on a delivery!", "error")
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        if holdingPizzaProp then
            if not DoesEntityExist(pizzaProp) then
                holdingPizzaProp = false
            else
                AttachEntityToEntity(pizzaProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.06, 0.08, 0.08, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
            end
        end
        if isOnDelivery and deliveryPoint then
            local playerCoords = GetEntityCoords(playerPed)

            if GetDistanceBetweenCoords(playerCoords, deliveryPoint.x, deliveryPoint.y, deliveryPoint.z, true) < 20.0 and not deliveryPed then
                local pedModel = GetHashKey(Config.DeliveryPedModel)
                RequestModel(pedModel)
                while not HasModelLoaded(pedModel) do
                    Wait(1)
                end

                deliveryPed = CreatePed(4, pedModel, deliveryPoint.x, deliveryPoint.y, deliveryPoint.z, 0.0, false, true)
                TaskStartScenarioInPlace(deliveryPed, Config.DeliveryPedAnimDict, 0, true)
                FreezeEntityPosition(deliveryPed, true)
                SetEntityInvincible(deliveryPed, true)
                SetBlockingOfNonTemporaryEvents(deliveryPed, true)

                exports['qb-target']:AddTargetEntity(deliveryPed, {
                    options = {
                        {
                            type = 'client',
                            event = 'tp-pizzadelivery:deliverPizza',
                            icon = 'fas fa-pizza-slice',
                            label = 'Deliver Pizza',
                        }
                    },
                    distance = 2.0,
                })
            end
        elseif holdingPizzaProp then
            ClearPedTasks(playerPed)
            DeleteObject(pizzaProp)
            holdingPizzaProp = false
        end
    end
end)

RegisterNetEvent('tp-pizzadelivery:deliverPizza', function()
    if isOnDelivery and deliveryPed then
        TriggerServerEvent('tp-pizzadelivery:completeDelivery')
        isOnDelivery = false
        deliveryPoint = nil
        RemoveBlip(deliveryBlip)
        deliveryBlip = nil
        DeleteEntity(deliveryPed)
        deliveryPed = nil
        if holdingPizzaProp then
            ClearPedTasks(PlayerPedId())
            DeleteObject(pizzaProp)
            holdingPizzaProp = false
        end
        QBCore.Functions.Notify("Pizza delivered!", "success")
    end
end)

-- Inside the `tp-pizzadelivery:spawnPizzaProp` event handler
RegisterNetEvent('tp-pizzadelivery:spawnPizzaProp', function()
    local playerPed = PlayerPedId()
    if not holdingPizzaProp then
        RequestModel(GetHashKey('prop_pizza_box_01'))
        while not HasModelLoaded(GetHashKey('prop_pizza_box_01')) do
            Wait(1)
        end
        pizzaProp = CreateObject(GetHashKey('prop_pizza_box_01'), 0, 0, 0, true, true, true)
        AttachEntityToEntity(pizzaProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.06, 0.08, 0.08, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        holdingPizzaProp = true
        QBCore.Functions.Notify("You are now holding a pizza!", "success")
    end
end)


RegisterNetEvent('tp-pizzadelivery:removePizzaProp', function()
    if holdingPizzaProp then
        ClearPedTasks(PlayerPedId())
        DeleteObject(pizzaProp)
        holdingPizzaProp = false
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end

CreateThread(function()
    local pizzadelivery = AddBlipForCoord(176.52, -1438.68, 28.24)
    SetBlipSprite(pizzadelivery, 616)
    SetBlipDisplay(pizzadelivery, 4)
    SetBlipScale(pizzadelivery, 1.2)
    SetBlipAsShortRange(pizzadelivery, true)
    SetBlipColour(pizzadelivery, 70)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Pizza Delivery Job")
    EndTextCommandSetBlipName(pizzadelivery)
end)