local ESX = exports['es_extended']:getSharedObject()

local currentFreight = nil
local freightBlip = nil

-- Create job blip
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(Config.JobBlip.x, Config.JobBlip.y, Config.JobBlip.z))

        if distance < 100.0 then
            if not DoesBlipExist(jobBlip) then
                jobBlip = AddBlipForCoord(Config.JobBlip.x, Config.JobBlip.y, Config.JobBlip.z)
                SetBlipSprite(jobBlip, Config.JobBlip.id)
                SetBlipColour(jobBlip, Config.JobBlip.color)
                SetBlipScale(jobBlip, Config.JobBlip.scale)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(Config.JobLabel)
                EndTextCommandSetBlipName(jobBlip)
            end
        else
            if DoesBlipExist(jobBlip) then
                RemoveBlip(jobBlip)
                jobBlip = nil
            end
        end
    end
end)

-- Open job menu
RegisterNetEvent('truckerjob:openMenu')
AddEventHandler('truckerjob:openMenu', function()
    local elements = {}

    for i, freight in ipairs(Config.Freights) do
        table.insert(elements, {
            label = freight.label,
            value = freight.name
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'trucker_job', {
        title = Config.UI.title,
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        TriggerServerEvent('truckerjob:startFreight', data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end)

-- Start freight
RegisterNetEvent('truckerjob:startFreight')
AddEventHandler('truckerjob:startFreight', function(freightName)
    for i, freight in ipairs(Config.Freights) do
        if freight.name == freightName then
            currentFreight = freight
            break
        end
    end

    if currentFreight then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local freightCoords = currentFreight.locations[1]

        if freightBlip then
            RemoveBlip(freightBlip)
        end

        freightBlip = AddBlipForCoord(freightCoords.x, freightCoords.y, freightCoords.z)
        SetBlipSprite(freightBlip, 1)
        SetBlipColour(freightBlip, 2)
        SetBlipScale(freightBlip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(currentFreight.label)
        EndTextCommandSetBlipName(freightBlip)

        ESX.ShowNotification('You have started a ' .. currentFreight.label .. ' delivery.')
    end
end)

-- Complete freight
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if currentFreight then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local freightCoords = currentFreight.locations[2]
            local distance = #(playerCoords - vector3(freightCoords.x, freightCoords.y, freightCoords.z))

            if distance < 5.0 then
                ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to deliver the freight.')

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('truckerjob:completeFreight', currentFreight.name)
                    currentFreight = nil
                    RemoveBlip(freightBlip)
                    freightBlip = nil
                end
            end
        end
    end
end)