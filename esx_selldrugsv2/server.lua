ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('burner', function(source) ---## change to desired item which is to be used on drugsale
	TriggerClientEvent('myy:huume', source)
end)

RegisterServerEvent('myy:huume2')
AddEventHandler('myy:huume2', function()
    xPlayer = ESX.GetPlayerFromId(source)
    drugToSell = {
        type = '',
        label = '',
        count = 0,
        i = 0,
        price = 0,
    }
    for k, v in pairs(Config.drugs) do
        item = xPlayer.getInventoryItem(k)
            
        if item == nil then
            return        
        end
            
        count = item.count
        drugToSell.i = drugToSell.i + 1
        drugToSell.type = k
        drugToSell.label = item.label
        
        if count >= 5 then
            drugToSell.count = math.random(1, 5)
        elseif count > 0 then
            drugToSell.count = math.random(1, count)
        end

        if drugToSell.count ~= 0 then
            drugToSell.price = drugToSell.count * v + math.random(1, 300)
            TriggerClientEvent('stasiek_selldrugsv2:findClient', source, drugToSell)
            break
        end
        
        if ESX.Table.SizeOf(Config.drugs) == drugToSell.i and drugToSell.count == 0 then
            xPlayer.showNotification(Config.notify.nodrugs, 6)
        end
    end
end)

RegisterServerEvent('stasiek_selldrugsv2:pay')
AddEventHandler('stasiek_selldrugsv2:pay', function(drugToSell)
    xPlayer = ESX.GetPlayerFromId(source)
	local checkki = xPlayer.getInventoryItem(drugToSell.type).count
	
	if checkki > 0 then
		if Config.account == 'money' then
			xPlayer.removeInventoryItem(drugToSell.type, drugToSell.count)
			xPlayer.addMoney(drugToSell.price)
		else
			xPlayer.removeInventoryItem(drugToSell.type, drugToSell.count)
			xPlayer.addAccountMoney(Config.account, drugToSell.price)
		end
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, ('~r~NICE TRY DOG, ~n~ WAS IT WORTH IT ~n~YOU SCUM...')) -- Notification for exploiter / cheater
		TriggerClientEvent('huijari:dickhead', source)
	end
end)

RegisterServerEvent('stasiek_selldrugsv2:notifycops')
AddEventHandler('stasiek_selldrugsv2:notifycops', function(drugToSell)
    TriggerClientEvent('stasiek_selldrugsv2:notifyPolice', -1, drugToSell.coords)
end)

ESX.RegisterServerCallback('stasiek_selldrugsv2:getPoliceCount', function(source, cb)
    count = 0

    for _, playerId in pairs(ESX.GetPlayers()) do
        xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer.job.name == 'police' then
            count = count + 1
        end
    end

    cb(count)
end)
