local ESX = exports['es_extended']:getSharedObject()

-- Start freight
RegisterNetEvent('truckerjob:startFreight')
AddEventHandler('truckerjob:startFreight', function(freightName)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == Config.JobName then
        for i, freight in ipairs(Config.Freights) do
            if freight.name == freightName then
                MySQL.Async.execute('INSERT INTO trucker_job (player_id, freight_name, status, payment) VALUES (@player_id, @freight_name, @status, @payment)', {
                    ['@player_id'] = xPlayer.identifier,
                    ['@freight_name'] = freight.name,
                    ['@status'] = 'in_progress',
                    ['@payment'] = freight.payment
                }, function(rowsChanged)
                    TriggerClientEvent('truckerjob:startFreight', source, freightName)
                end)
                break
            end
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'You are not a trucker.')
    end
end)

-- Complete freight
RegisterNetEvent('truckerjob:completeFreight')
AddEventHandler('truckerjob:completeFreight', function(freightName)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == Config.JobName then
        MySQL.Async.fetchAll('SELECT * FROM trucker_job WHERE player_id = @player_id AND freight_name = @freight_name AND status = @status', {
            ['@player_id'] = xPlayer.identifier,
            ['@freight_name'] = freightName,
            ['@status'] = 'in_progress'
        }, function(result)
            if result[1] then
                MySQL.Async.execute('UPDATE trucker_job SET status = @status WHERE id = @id', {
                    ['@status'] = 'completed',
                    ['@id'] = result[1].id
                }, function(rowsChanged)
                    xPlayer.addMoney(result[1].payment)
                    TriggerClientEvent('esx:showNotification', source, 'You have completed the delivery and earned $' .. result[1].payment .. '.')
                end)
            end
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'You are not a trucker.')
    end
end)