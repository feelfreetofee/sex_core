function createVehicle(src, model)
	local player = players[src]
	if not player or not model then
		return
	end
	TriggerClientCallback("getVehicleModel", src, function(type, maxseats, seats, passengers)
		if not type then
			return
		end
		local peds = {player.ped}
		local veh = GetVehiclePedIsIn(player.ped)
		if veh > 0 and GetPedInVehicleSeat(veh, -1) == player.ped then
			if maxseats > 1 then
				for i = 0, seats do
					local ped = GetPedInVehicleSeat(veh, i)
					if ped then
						table.insert(peds, ped)
						if #peds == maxseats or #peds == passengers then
							break
						end
					end
				end
			end
			DeleteEntity(veh)
		end
		local coords = GetEntityCoords(player.ped)
		local veh = CreateVehicleServerSetter(model, type, coords.x, coords.y, coords.z, GetEntityHeading(player.ped))
		SetEntityRoutingBucket(veh, GetPlayerRoutingBucket(src))
		for seat, ped in pairs(peds) do
			seat -= 2
			while GetPedInVehicleSeat(veh, seat) ~= ped do
				SetPedIntoVehicle(ped, veh, seat)
				Wait(1)
			end
		end
	end, model)
end

RegisterCommand("car", function(src, args)
	local player = args[1] == 'me' and src or tonumber(args[1])
	local model = args[2]
	createVehicle(player, model)
end)