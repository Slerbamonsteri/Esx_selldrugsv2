ESX = nil
PlayerData = {}
npc = {}
cooldown = false
blips = {}

RegisterNetEvent("myy:huume")
AddEventHandler("myy:huume", function()
	Wait(10)
	toimisaatana()
end)

RegisterNetEvent("huijari:dickhead")
AddEventHandler("huijari:dickhead", function()
	huijariii()
end)

function toimisaatana()
  TriggerServerEvent('myy:huume2')
end

function huijariii()
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		RequestModel(-1275859404)
		Citizen.Wait(5)
		coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 4.0, 3.0)
		huijariped = CreatePed(30, -1275859404, coords.x, coords.y, coords.z, 0.0, true, true)
		Wait(10)
		PlaceObjectOnGroundProperly(huijariped)
		SetEntityAsMissionEntity(huijariped)
		TaskGoToEntity(huijariped, PlayerPedId(), 60000, 4.0, 2.0, 0, 0)
		ESX.Game.MakeEntityFaceEntity(huijariped, PlayerPedId())
		SetPedAsEnemy(huijariped, true)
		GiveWeaponToPed(huijariped, GetHashKey('WEAPON_HEAVYSNIPER'), 250, false, true)
		TaskCombatPed(huijariped, PlayerPedId(), 0, 16)
		SetPedAccuracy(huijariped, 100)
		SetPedDropsWeaponsWhenDead(huijariped, false)
		Citizen.Wait(20000)
		SetPedAsNoLongerNeeded(huijariped)
		DeletePed(huijariped)
		Citizen.Wait(5000)
		SetEntityHealth(PlayerPedId(), 0)
	end)
end

function tukijoukot()
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		RequestModel(2072724299)
		coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 3.0)
		poliisiped = CreatePed(30, 2072724299, coords.x, coords.y, coords.z, 0.0, true, true)
		Wait(10)
		PlaceObjectOnGroundProperly(poliisiped)
		SetEntityAsMissionEntity(poliisiped)
		TaskGoToEntity(poliisiped, PlayerPedId(), 60000, 4.0, 2.0, 0, 0)
		ESX.Game.MakeEntityFaceEntity(poliisiped, PlayerPedId())
		SetPedAsEnemy(poliisiped, true)
		GiveWeaponToPed(poliisiped, GetHashKey('WEAPON_COMBATPISTOL'), 250, false, true)
		TaskCombatPed(poliisiped, PlayerPedId(), 0, 16)
		SetPedAccuracy(poliisiped, 50)
		SetPedDropsWeaponsWhenDead(poliisiped, false) --poliisiped1 end
		
		coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 3.0) --poliisiped2 start
		poliisiped2 = CreatePed(30, 2072724299, coords.x, coords.y, coords.z, 0.0, true, true)
		Wait(10)
		PlaceObjectOnGroundProperly(poliisiped2)
		SetEntityAsMissionEntity(poliisiped2)
		TaskGoToEntity(poliisiped2, PlayerPedId(), 60000, 40.0, 2.0, 0, 0)
		ESX.Game.MakeEntityFaceEntity(poliisiped2, PlayerPedId())
		SetPedAsEnemy(poliisiped2, true)
		GiveWeaponToPed(poliisiped2, GetHashKey('WEAPON_COMBATPISTOL'), 250, false, true)
		TaskCombatPed(poliisiped2, PlayerPedId(), 0, 16)
		SetPedAccuracy(poliisiped2, 50)
		SetPedDropsWeaponsWhenDead(poliisiped2, false)
		Citizen.Wait(40000)
		SetPedAsNoLongerNeeded(poliisiped2)
		DeletePed(poliisiped2)
		SetPedAsNoLongerNeeded(poliisiped)
		DeletePed(poliisiped)
	end)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(5000)
	end

	PlayerData = ESX.GetPlayerData()
	ESX.Streaming.RequestStreamedTextureDict('DIA_CLIFFORD')

	ESX.PlayAnim = function(dict, anim, speed, time, flag)
		ESX.Streaming.RequestAnimDict(dict, function()
			TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
		end)
	end

	ESX.PlayAnimOnPed = function(ped, dict, anim, speed, time, flag)
		ESX.Streaming.RequestAnimDict(dict, function()
			TaskPlayAnim(ped, dict, anim, speed, speed, time, flag, 1, false, false, false)
		end)
	end

	ESX.Game.MakeEntityFaceEntity = function(entity1, entity2)
		local p1 = GetEntityCoords(entity1, true)
		local p2 = GetEntityCoords(entity2, true)
	
		local dx = p2.x - p1.x
		local dy = p2.y - p1.y
	
		local heading = GetHeadingFromVector_2d(dx, dy)
		SetEntityHeading( entity1, heading )
	end
end)

next_ped = function(drugToSell)

	if cooldown then
		ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.cooldown, 'DIA_CLIFFORD', 1)
		return
	end

	cooldown = true

	if Config.cityPoint ~= false and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.cityPoint, true) > 10000.0 then
		ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.toofar, 'DIA_CLIFFORD', 1)
		return
	end

	if npc ~= nil and npc.ped ~= nil then
		SetPedAsNoLongerNeeded(npc.ped)
	end

	cops = 0
	ESX.TriggerServerCallback('stasiek_selldrugsv2:getPoliceCount', function(_cops)
		cops = _cops
	end)

	Wait(500)

	if cops < Config.requiredCops then
		ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.cops, 'DIA_CLIFFORD', 1)
		return
	end
	
	
	if cops == 3 then
		drugToSell.price = ESX.Math.Round(drugToSell.price * 1.10)
	elseif cops == 4 then
		drugToSell.price = ESX.Math.Round(drugToSell.price * 1.15)
	elseif cops == 5 then
		drugToSell.price = ESX.Math.Round(drugToSell.price * 1.20)
	elseif cops == 6 then
		drugToSell.price = ESX.Math.Round(drugToSell.price * 1.25)
	elseif cops >= 7 then
		drugToSell.price = ESX.Math.Round(drugToSell.price * 1.30)
	elseif cops < 2 then
		drugToSell.price = ESX.Math.Round(drugToSell.price * 0.70)
	end

	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)
	ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.searching .. drugToSell.label, 'DIA_CLIFFORD', 1)
	Wait(math.random(5000, 10000))
	--ESX.PlayAnim('amb@world_human_drug_dealer_hard@male@base', 'base', 8.0, -1, 1)

	npc.hash = GetHashKey(Config.pedlist[math.random(1, #Config.pedlist)])
	ESX.Streaming.RequestModel(npc.hash)
	npc.coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 50.0, 5.0)
	retval, npc.z = GetGroundZFor_3dCoord(npc.coords.x, npc.coords.y, npc.coords.z, 0)

	if retval == false then
		cooldown = false
		ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.abort, 'DIA_CLIFFORD', 1)
		ClearPedTasks(PlayerPedId())
		return
	end

	npc.zone = GetLabelText(GetNameOfZone(npc.coords))
	drugToSell.zone = npc.zone
	npc.ped = CreatePed(5, npc.hash, npc.coords.x, npc.coords.y, npc.z, 0.0, true, true)
	PlaceObjectOnGroundProperly(npc.ped)
	SetEntityAsMissionEntity(npc.ped)
	
	if IsEntityDead(npc.ped) or GetEntityCoords(npc.ped) == vector3(0.0, 0.0, 0.0) then
		ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.notfound, 'DIA_CLIFFORD', 1)
        return
	end
	
	ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.approach, Config.notify.found .. npc.zone, 'DIA_CLIFFORD', 1)
	TaskGoToEntity(npc.ped, PlayerPedId(), 60000, 4.0, 2.0, 0, 0)

	CreateThread(function()
		canSell = true
		while npc.ped ~= nil and npc.ped ~= 0 and not IsEntityDead(npc.ped) do
			Wait(0)
			npc.coords = GetEntityCoords(npc.ped)
			ESX.Game.Utils.DrawText3D(npc.coords, (Config.notify.client):format(drugToSell.count, drugToSell.label), 0.5)
			distance = Vdist2(GetEntityCoords(PlayerPedId()), npc.coords)
			
			if distance < 10.0 then
				ESX.ShowHelpNotification(Config.notify.press)
				if IsControlJustPressed(0, 38) and canSell then
					canSell = false
					reject = math.random(1, 7) --- modify this to increase/ decrease chances of reject (currently around 50/50 if rejects or success)

					if reject <= 3 then
						ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.reject, 'DIA_CLIFFORD', 1)
						PlayAmbientSpeech1(npc.ped, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
						drugToSell.coords = GetEntityCoords(PlayerPedId())
						TriggerServerEvent('stasiek_selldrugsv2:notifycops', drugToSell)
						SetPedAsNoLongerNeeded(npc.ped)
						ClearPedTasksImmediately(PlayerPedId())
						if Config.requiredCops == 0 and cops < 1 then
							tukijoukot()
						end
						if Config.npcFightOnReject then
							GiveWeaponToPed(npc.ped, GetHashKey('WEAPON_SNSPISTOL'), 250, false, true)
							TaskCombatPed(npc.ped, PlayerPedId(), 0, 16)
							SetPedAccuracy(npc.ped, 0)
							SetPedDropsWeaponsWhenDead(npc.ped, false)
						end
						npc = {}
						return
					end

					if IsPedInAnyVehicle(PlayerPedId(), false) then
						ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.vehicle, '', 'DIA_CLIFFORD', 1)
						return
					end

					ESX.Game.MakeEntityFaceEntity(PlayerPedId(), npc.ped)
					ESX.Game.MakeEntityFaceEntity(npc.ped, PlayerPedId())
					SetPedTalk(npc.ped)
					PlayAmbientSpeech1(npc.ped, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
					obj = CreateObject(GetHashKey('prop_weed_bottle'), 0, 0, 0, true)
					AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
					obj2 = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), 0, 0, 0, true)
					AttachEntityToEntity(obj2, npc.ped, GetPedBoneIndex(npc.ped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
					ESX.PlayAnim('mp_common', 'givetake1_a', 8.0, -1, 0)
					ESX.PlayAnimOnPed(npc.ped, 'mp_common', 'givetake1_a', 8.0, -1, 0)
					Wait(1000)
					AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
					AttachEntityToEntity(obj, npc.ped, GetPedBoneIndex(npc.ped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
					Wait(1000)
					DeleteEntity(obj)
					DeleteEntity(obj2)
					PlayAmbientSpeech1(npc.ped, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
					SetPedAsNoLongerNeeded(npc.ped)
					TriggerServerEvent('stasiek_selldrugsv2:pay', drugToSell)
					ESX.ShowAdvancedNotification(Config.notify.title, '', (Config.notify.sold):format(drugToSell.count, drugToSell.label, drugToSell.price), 'DIA_CLIFFORD', 1)
					npc = {}
				end
			end
		end
	end)
end

CreateThread(function()
	while true do
		Wait(120000) -- Adjust this to set up wanted cooldown between sales
		if cooldown then
			cooldown = false
		end
	end
end)


RegisterNetEvent('stasiek_selldrugsv2:findClient')
AddEventHandler('stasiek_selldrugsv2:findClient', next_ped)

RegisterNetEvent('stasiek_selldrugsv2:notifyPolice')
AddEventHandler('stasiek_selldrugsv2:notifyPolice', function(coords)	
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		street = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
		street2 = GetStreetNameFromHashKey(street)
		ESX.ShowAdvancedNotification(Config.notify.police_notify_title, Config.notify.police_notify_subtitle, street2, "CHAR_CALL911", 1)
		PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)

		blip = AddBlipForCoord(coords)
		SetBlipSprite(blip,  403)
		SetBlipColour(blip,  1)
		SetBlipAlpha(blip, 250)
		SetBlipScale(blip, 1.2)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Ilmoitettu huumemyynti')
		EndTextCommandSetBlipName(blip)
		table.insert(blips, blip)
		Wait(50000)
		for i in pairs(blips) do
			RemoveBlip(blips[i])
			blips[i] = nil
		end
	end
end)
