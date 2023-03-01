RegisterCommand('color', function()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped)
	if veh < 1 then
		return
	end
	FreezeEntityPosition(ped, true)
	exports.sex_menu:menu({
		{
			title = "Vehicle Colors"
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
end)