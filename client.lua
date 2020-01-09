local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

function enterfrontdoor()
	SendNUIMessage({
		action = 'Open'
	})
	SetNuiFocus(true, true)
end

function leavetofront()
	SendNUIMessage({
		action = 'Leave'
	})
	SetNuiFocus(true, true)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		SetNuiFocus(false, false)
	end
end)

AddEventHandler('portals:hasEnteredMarker', function(zone)
	CurrentAction     = zone
	CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to enter.'
	CurrentActionData = {zone = zone}
end)

AddEventHandler('portals:hasExitedMarker', function (zone)
	CurrentAction = nil
end)

RegisterNUICallback('NUIFocusOff', function()
	open = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
end)

RegisterNUICallback('enter', function()
	SetEntityCoords(PlayerPedId(), 320.217, 263.81, 82.974)
	SetEntityHeading(PlayerPedId(), 180.0)
end)

RegisterNUICallback('leave', function()
	SetEntityCoords(PlayerPedId(), 298.96, 197.93, 104.33)
	SetEntityHeading(PlayerPedId(), 180.0)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
					isInMarker  = true
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('portals:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('portals:hasExitedMarker', LastZone)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'IN' then
					enterfrontdoor()
				elseif CurrentAction == 'OUT' then
					leavetofront()
				end
				CurrentAction = nil
			elseif IsControlJustReleased (0, 322) or IsControlJustReleased (0, 178)  then
				ESX.SetTimeout(200, function()
					SendNUIMessage({
						action = "Close",
						array = source
					})
					SetNuiFocus(false, false)
				end)
			end

		else
			Citizen.Wait(500)
		end
	end
end)