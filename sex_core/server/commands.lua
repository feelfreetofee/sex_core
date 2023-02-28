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
end)

RegisterCommand("revive", function(src, args)
	local player = args[1] and tonumber(args[1]) or src
	if players[player] then
		TriggerClientEvent('revivePlayer', player)
	end
end)

RegisterCommand('weapon', function(src, args)
	local player = args[1] == 'me' and src or tonumber(args[1])
	if players[player] then
		GiveWeaponToPed(players[player].ped, args[2], 999999)
	end
end)

RegisterCommand("infinite", function(src, args)
	local player = args[1] and tonumber(args[1]) or src
	if players[player] then
		TriggerClientEvent('infiniteAmmo', player)
	end
end)

