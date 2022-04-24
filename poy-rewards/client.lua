local QBCore = exports['qb-core']:GetCoreObject()
RegisterCommand('rewards', function()
    SendNUIMessage ({
        toggle = 'true',
    })
    QBCore.Functions.TriggerCallback('poy-rewards:getclaimedtime', function(time)
        claimedtime = time
    end)
end)
local loggedin = false
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    loggedin = true
    SendNUIMessage ({
        toggle = 'true',
    })
    QBCore.Functions.TriggerCallback('poy-rewards:getclaimedtime', function(time)
        claimedtime = time
    end)
end)



local secu = math.random(Config.LowestTime, Config.HighestTime)
local rand = math.random(1, 6)
local prize = tostring(Config.Money[rand])
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if loggedin then 
            secu = secu - 1
            sure = getTimer(secu)
            SendNUIMessage({
                toggle = 'update', 
                para = prize,
                sure = sure,
            })
            if sure == '00:00' then
                secu = math.random(Config.LowestTime, Config.HighestTime)
                if prize == prize then
                    prize = tostring(Config.Money[rand])
                end
                claimedtime = claimedtime + 1
                TriggerServerEvent('poy-rewards:addmoney', prize, claimedtime)
                    
            end
        end

    end
end)


function getTimer(seconds)
    local minutes = seconds /  60
    local cikarilacaksaniye = minutes * 60
    local yenisaniye = seconds - cikarilacaksaniye
    local newminutes = math.floor(minutes)
    local secondes = minutes - newminutes
    local gerekensaniye = secondes * 60
    local yeniminutos = '0'..newminutes
    local can = false
    if newminutes < 10 then
        can = true
    end
    if gerekensaniye < 10 then
        if not can then
            time = newminutes..':0'..math.floor(gerekensaniye+0.5)
        else
            time = yeniminutos..':0'..math.floor(gerekensaniye+0.5)
        end
    elseif newminutes < 10 then
        time = yeniminutos..':'..math.floor(gerekensaniye+0.5)
    elseif gerekensaniye < 10 and newminutes < 10 then
        time = yeniminutos..':0'..math.floor(gerekensaniye+0.5)
    else
        time = newminutes..':'..math.floor(gerekensaniye+0.5)
    end

    if newminutes == 0 and math.floor(gerekensaniye+05) == 0 then
        time = '00:00'
    end
    return time
end


