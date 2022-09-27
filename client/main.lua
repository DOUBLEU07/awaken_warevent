local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["Enter"] = 191
}

ESX         = nil
hour, minite = 0, 0
timeNow = 0
local startingEvent, inputData, PlayerLoaded, FirstSpawn, sendTime= false, false, false, true, false
MainObject = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.GetPlayerData()
	while true do
        PlayerPed = PlayerPedId()
        PlayerCoords = GetEntityCoords(PlayerPed)
        Citizen.Wait(500)
    end   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent("awaken_warevent:UpdataMainObj")
AddEventHandler("awaken_warevent:UpdataMainObj", function(data)
	MainObject = data
end)

RegisterNetEvent("awaken_warevent:updateScore")
AddEventHandler("awaken_warevent:updateScore", function(data)
	MainObject = data
	SendNUIMessage({
		type = "updateScore",
		gangs = MainObject
	})
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if not PlayerLoaded then
		TriggerServerEvent("awaken_warevent:setInfos-SV")
		PlayerLoaded = true
	end
end)

RegisterNetEvent('awaken_warevent:check_setinfo')
AddEventHandler('awaken_warevent:check_setinfo', function()
	
	if not startingEvent then 
		TriggerServerEvent("awaken_warevent:setInfos-SV")
	end		
end)

RegisterNetEvent('awaken_warevent:sendTimeToUI')
AddEventHandler('awaken_warevent:sendTimeToUI', function(typeUI, CountDown)
	if not startingEvent then 
		Citizen.CreateThread(function()
			MainWorking()
		end)
		startingEvent = true
	end
	SendNUIMessage({
		type = typeUI,
		time = CountDown
	})
end)

RegisterNetEvent("awaken_warevent:getGangWinner")
AddEventHandler("awaken_warevent:getGangWinner", function(data)
	startingEvent = false
	-- for i=1, 20, 1 do 
	SetTimecycleModifier('default')
	SetTimecycleModifier('hud_def_blur')
	SendNUIMessage({
		type = "showWinner",
		imgWinner = data.imgLink,
		labelWinner = data.label,
		scoreWinner = data.rkScore
	})
	-- end
end)

MainWorking = function()
	-- print('MainWorking')
	while startingEvent do 
		Wait(1000)
		if not inputData then
			SetDisplay(true, MainObject, "ui")
			inputData = true
		end
	end

	if MainObject then 
		MainObject = {}
		TriggerServerEvent("awaken_warevent:setObj")
		SetDisplay(false, MainObject, "ui")
		-- print(#MainObject)
	end
end


SetDisplay = function(bool, dataGangs, typeX)
    display = bool
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = typeX,
        status = bool,
		gangs = dataGangs
    })
end

local isShow = false
RegisterCommand("showscore", function()
    isShow = not isShow
    if isShow then
		SetDisplay(false, MainObject, "ui")
	else
		SetDisplay(true, MainObject, "ui")
	end
end)



RegisterNUICallback("clear_ui", function(data) -- index.js ruft diesen Callback auf und dan passiert das was dadrin passiert
	-- SetTimecycleModifier('default')
	startingEvent = false
	Wait(1000)
	SetTimecycleModifier('default')
	inputData = false
end)



AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then	
		TriggerServerEvent("awaken_warevent:setInfos-SV")
	end
end)