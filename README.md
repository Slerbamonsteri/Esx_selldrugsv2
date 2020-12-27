# Esx_selldrugsv2
Sell drugs to NPC

Originally made by xxxstasiek (https://github.com/xxxstasiek/stasiek_selldrugsv2) 
Modified and customized by me.

Create an item in your database which is to be used to set up drugsales, default "burner"
You can change the item in server.lua

Otherwise it's pretty much straightforward drag&drop

# esx error? From stasieks readme
if you've issues with ESX try adding this two functions to your es_extended/client/functions.lua
```
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
```
