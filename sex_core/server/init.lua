RegisterNetEvent('playerConnected')
AddEventHandler('playerConnected', function()
	local src = source
	local identifier = GetPlayerIdentifier(src)
	players[src] = {
		src = src,
		identifier = identifier
	}
	if not kvp[identifier] then
		kvp[identifier] = json.decode(GetResourceKvpString(identifier)) or {
			characters = {}
		}
	end
	local data = kvp[identifier]
	if Config.multicharacter then
		TriggerClientEvent('multicharacterMenu', src, data)
	elseif data.characters[1] then
		spawnPlayer(players[src], data, 1)
	else
		TriggerClientEvent('registerCharacter', src)
	end
end)

AddEventHandler('playerDropped', function()
	local src = source
	savePlayer(players[src])
	players[src] = nil
end)

local resourceName = GetCurrentResourceName()
AddEventHandler('onResourceStop', function(resource)
    if resourceName == resource then
		for _, player in pairs(players) do
			savePlayer(player)
		end	
	end
end)