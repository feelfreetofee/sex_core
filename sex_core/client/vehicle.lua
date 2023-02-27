local types = {
	[8] = "bike",
	[11] = "trailer",
	[13] = "bike",
	[14] = "boat",
	[15] = "heli",
	[16] = "plane",
	[21] = "train"
}

RegisterClientCallback('getVehicleModel', function(cb, model)
	local exist = IsModelInCdimage(model)
	if not exist then
		cb()
		return
	end
	local veh = GetVehiclePedIsIn(PlayerPedId())
	cb((model == "submersible" or model == "submersible2") and "submarine" or types[GetVehicleClassFromName(model)] or "automobile", GetVehicleModelNumberOfSeats(model), veh > 0 and GetVehicleMaxNumberOfPassengers(veh) - 1, veh > 0 and GetVehicleNumberOfPassengers(veh))
end)