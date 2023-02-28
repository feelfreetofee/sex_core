players = {}
kvp = {}

RegisterNetEvent('playerConnected')
AddEventHandler('playerConnected', function()
	local src = source
	local identifier = GetPlayerIdentifier(src)
	players[src] = {
		identifier = identifier
	}
	if not kvp[identifier] then
		kvp[identifier] = json.decode(GetResourceKvpString(identifier)) or {}
	end
	TriggerClientEvent('charactersMenu', src, kvp[identifier])
end)

function savePlayer(player)
	local characters = kvp[player.identifier]
	if characters then
		if player.character then
			local coords = GetEntityCoords(player.ped)
			local character = characters[player.character]
			character.position = {
				x = coords.x,
				y = coords.y,
				z = coords.z,
				w = GetEntityHeading(player.ped)		
			}
			character.status.health = GetEntityHealth(player.ped)
			character.status.armour = GetPedArmour(player.ped)
		end
		SetResourceKvp(player.identifier, json.encode(characters))
	end
end

AddEventHandler('playerDropped', function()
	local src = source
	local player = players[src]
	if player then
		savePlayer(player)
		players[src] = nil
	end
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
		for _, player in pairs(players) do
			savePlayer(player)
		end	
	end
end)