ESX = nil
eventStart = false
local sendTime = false
endTimeData = 0
MainObject = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent("awaken_warevent:setInfos-SV")
AddEventHandler("awaken_warevent:setInfos-SV", function()
    -- print("setInfos", #MainObject)
    if #MainObject <= 0 then 
        for k, v in pairs(Config['Gangs']) do
            table.insert(MainObject, {jobName = v.job, rkScore = 0, label = v.label, imgLink = v.imgLink})
        end
    end

    TriggerClientEvent("awaken_warevent:UpdataMainObj", source, MainObject)
    -- print("setInfos2", #MainObject)
end)

Citizen.CreateThread(function()
    while true do 
        local time = 3000
        -- print(eventStart, sendTime)
        if eventStart then 
            if not sendTime then
                Citizen.CreateThread(function()
                    anccantake(endTimeData)
                end)
                sendTime = true 
            end
            time = 5000
        end
        Citizen.Wait(time)
    end
end)

function anccantake(min)
    
    local time = ESX.Math.Round(((min*60000+1000) / 1000))
    -- print(time)
    while time > 0 do
      
      if time > 0 then
        time = time - 1
      end
      
    --   print(secondsToClock(time))
	
		-- SendNUIMessage({
		-- 	type = "time-update",
		-- 	time = secondsToClock(time, player_sec)
		-- })
        TriggerClientEvent('awaken_warevent:sendTimeToUI', -1, "time-update", secondsToClock(time))
        Citizen.Wait(1000)
  
    end
end 

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		TriggerEvent("awaken_warevent:stopEvent")
		return "00:00:00"
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return hours..":"..mins.. ":" .. secs
	end
end

RegisterServerEvent("awaken_warevent:setObj")
AddEventHandler("awaken_warevent:setObj", function()
    MainObject = {}
    -- print("setObj",#MainObject)
end)

loadTimerNow = function(src)
    -- print("loadTimerNow2")
    local data = {
        hour = tonumber(os.date("%H", timestamp)),
        minite = tonumber(os.date("%M", timestamp))
    }
    TriggerClientEvent("awaken_warevent:setTimer",src, data)
end

RegisterServerEvent("awaken_warevent:loadTimerNow-SV")
AddEventHandler("awaken_warevent:loadTimerNow-SV", function()
    -- print("loadTimerNow1")
    loadTimerNow(source)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    data.victim = source
    if data.killedByPlayer then
        local xPlayer = ESX.GetPlayerFromId(data.victim)   
        local PlayerDied = xPlayer.identifier
        local xKiller = ESX.GetPlayerFromId(data.killerServerId)
        local Killer = xKiller.identifier

        for k,v in pairs(MainObject) do 
            -- print(xKiller.getJob().name, xPlayer.getJob().name)
            if (xKiller.getJob().name ~= xPlayer.getJob().name) and (xKiller.getJob().name == v.jobName) then
                v.rkScore =  v.rkScore + 1
            end
        end
        table.sort(MainObject, function(a, b)
            -- print(a.rkScore, b.rkScore)
            return a.rkScore > b.rkScore
        end)
        TriggerClientEvent("awaken_warevent:updateScore", -1, MainObject)
    end
end)

TriggerEvent('es:addGroupCommand', Config['Admin_Command'], 'admin', function(source, args, user)
	if args[1] ~= nil then
        local min_end = tonumber(args[1])
        if min_end then
            eventStart = true
            endTimeData = min_end
            TriggerClientEvent('awaken_warevent:check_setinfo', -1)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'กรุณาระบุเป็นตัวเลขเท่านั้น' } })
        end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'ใส่จำนวนนาทีของกิจกรรมด้วย' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = '/'..Config['Admin_Command']..' นาที', params = {{ name = 'Minute' }} })

RegisterNetEvent("awaken_warevent:stopEvent")
AddEventHandler("awaken_warevent:stopEvent", function()
    if eventStart then 
        -- print(MainObject[1].jobName, MainObject[1].rkScore)
        TriggerClientEvent('awaken_warevent:getGangWinner", -1, MainObject[1])
        eventStart = false
        sendTime = false
        endTimeData = 0
        MainObject = {}
        
    end
end)

