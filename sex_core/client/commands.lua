local infiniteAmmo

RegisterNetEvent('infiniteAmmo')
AddEventHandler('infiniteAmmo', function()
	infiniteAmmo = not infiniteAmmo
	SetPedInfiniteAmmoClip(PlayerPedId(), infiniteAmmo)
end)

local types = {
	[8] = 'bike',
	[11] = 'trailer',
	[13] = 'bike',
	[14] = 'boat',
	[15] = 'heli',
	[16] = 'plane',
	[21] = 'train'
}

RegisterCommand('car', function(src, args)
	if args[1] then
		local player = args[2] and tonumber(args[1]) or src
		local model = args[2] or args[1]
		if model and IsModelInCdimage(model) then
			local veh = GetVehiclePedIsIn(PlayerPedId())
			TriggerServerEvent('car', model, (model == 'submersible' or model == 'submersible2') and 'submarine' or types[GetVehicleClassFromName(model)] or 'automobile', GetVehicleModelNumberOfSeats(model), veh > 0 and GetVehicleMaxNumberOfPassengers(veh) - 1, veh > 0 and GetVehicleNumberOfPassengers(veh))
		end
	end
end)

RegisterCommand('color', function()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped)
	if veh > 0 then
		FreezeEntityPosition(ped, true)
		exports.sex_menu:menu({
			{
				title = "Colors"
			},
			{
				title = "primary",
				type = "color",
				id = 1,
				value = string.format("#%02x%02x%02x", GetVehicleCustomPrimaryColour(veh))
			},
			{
				title = "secondary",
				type = "color",
				id = 2,
				value = string.format("#%02x%02x%02x", GetVehicleCustomSecondaryColour(veh))
			}
		}, false, function(res)
			local value = res[2][res[1]].value
			local r = tonumber(value:sub(2, 3), 16)
			local g = tonumber(value:sub(4, 5), 16)
			local b = tonumber(value:sub(6, 7), 16)
			if res[1] == 2 then
				SetVehicleCustomPrimaryColour(veh, r, g, b)
			else
				SetVehicleCustomSecondaryColour(veh, r, g, b)
			end
		end, function()
			exports.sex_menu:menu()
			FreezeEntityPosition(PlayerPedId())
		end)
	end
end)