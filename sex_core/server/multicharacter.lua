RegisterNetEvent('playCharacter')
AddEventHandler('playCharacter', function(id)
	local player = players[source]
	local data = kvp[player.identifier]
	if data.characters[id] then
		spawnPlayer(player, data, id)
	end
end)

RegisterNetEvent('registerCharacter')
AddEventHandler('registerCharacter', function(character)
	local player = players[source]
	local data = kvp[player.identifier]
	table.insert(data.characters, character)
	spawnPlayer(player, data, #data.characters)
end)

RegisterNetEvent('deleteCharacter')
AddEventHandler('deleteCharacter', function(id)
	table.remove(kvp[players[source].identifier].characters, id)
end)

RegisterCommand('relog', function(src)
	if Config.multicharacter then
		savePlayer(players[src])
		TriggerClientEvent('playerConnected', src)
	end
end)