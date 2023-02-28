local function playCharacter(src, player, characters, id)
	local character = characters[id]
	local model = joaat(character.appearance.model)
	SetPlayerModel(src, model)
	local ped = GetPlayerPed(src)
	while GetEntityModel(ped) ~= model do Wait(1) end
	SetPedDefaultComponentVariation(ped)
	SetEntityCoords(ped, vec3(character.position.x, character.position.y, character.position.z))
	SetEntityHeading(ped, character.position.w)
	player.ped = ped
	player.character = id
	TriggerClientEvent('playerSpawned', src, character)
end

RegisterNetEvent('playCharacter')
AddEventHandler('playCharacter', function(id)
	local src = source
	local player = players[src]
	if player then
		local characters = kvp[player.identifier]
		if characters and characters[id] then
			playCharacter(src, player, characters, id)
		end
	end
end)

RegisterNetEvent('registerCharacter')
AddEventHandler('registerCharacter', function(character)
	local src = source
	local player = players[src]
	if player then
		local characters = kvp[player.identifier]
		if characters then
			table.insert(characters, character)
			playCharacter(src, player, characters, #characters)
		end
	end
end)

RegisterNetEvent('deleteCharacter')
AddEventHandler('deleteCharacter', function(id)
	local src = source
	local player = players[src]
	if player then
		local characters = kvp[player.identifier]
		if characters and characters[id] then
			table.remove(characters, id)
			savePlayer(player)
		end
	end
end)

if Config.relog then
	RegisterCommand('relog', function(src)
		if Config.relog then
			local player = players[src]
			if player then
				savePlayer(player)
				TriggerClientEvent('playerConnected', src)
				players[src] = {
					identifier = player.identifier
				}
				TriggerClientEvent('charactersMenu', src, kvp[player.identifier])
			end
		end
	end)
end