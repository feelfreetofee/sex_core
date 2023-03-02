RegisterCommand("revive", function(src, args)
	local player = args[1] and tonumber(args[1]) or src
	if players[player] then
		TriggerClientEvent('revivePlayer', player)
	end
end)

RegisterCommand('tp', function(src, args)
	if args[1] then
		local from = players[args[2] and tonumber(args[1]) or src]
		local to = players[tonumber(args[2] and args[2] or args[1])]
		if from and to then
			SetEntityCoords(from.ped, GetEntityCoords(to.ped))
		end
	end
end)

RegisterCommand("god", function(src, args)
	local player = args[1] and tonumber(args[1]) or src
	if players[player] then
		SetPlayerInvincible(player, not GetPlayerInvincible(player))
	end
end, true)

RegisterCommand('weapon', function(src, args)
	if args[1] then
		local player = args[2] and tonumber(args[1]) or src
		if players[player] and players[player].ped then
			GiveWeaponToPed(players[player].ped, args[2] or args[1], 999999)
		end
	end
end)

RegisterCommand("infinite", function(src, args)
	local player = args[1] and tonumber(args[1]) or src
	TriggerClientEvent('infiniteAmmo', player)
end)

RegisterCommand("dv", function(src, args)
	local player = args[1] and tonumber(args[1]) or src
	local veh = GetVehiclePedIsIn(GetPlayerPed(player))
	if veh > 0 then
		DeleteEntity(veh)
	end
end)

RegisterNetEvent('car')
AddEventHandler('car', function(model, type, maxseats, seats, passengers)
	local src = source
	local player = players[src]
	if player and player.ped then
		local peds = {player.ped}
		local veh = GetVehiclePedIsIn(player.ped)
		if veh > 0 then
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
	end
end)