local players = {}
local kvp = {}

RegisterNetEvent('playerConnected')
AddEventHandler('playerConnected', function()
	local src = source
	if players[src] then
		return
	end
	local identifier = GetPlayerIdentifier(src)
	players[src] = {
		identifier = identifier
	}
	if not kvp[identifier] then
		kvp[identifier] = json.decode(GetResourceKvpString(identifier)) or {}
	end
	TriggerClientEvent('charactersMenu', src, kvp[identifier])
end)

local function savePlayer(player)
	local characters = kvp[player.identifier]
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
	if characters then
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

local function savePlayers()
	for _, player in pairs(players) do
		savePlayer(player)
	end	
end

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
		savePlayers()
	end
end)

local function playCharacter(src, player, characters, id)
	local character = characters[id]
	local model = joaat(character.appearance.model)
	SetPlayerModel(src, model)
	local ped = GetPlayerPed(src)
	while GetEntityModel(ped) ~= model do Wait(1) end
	SetPedDefaultComponentVariation(ped)
	SetEntityCoords(ped, vec3(character.position.x, character.position.y, character.position.z))
	SetEntityHeading(ped, character.position.w)
	FreezeEntityPosition(ped)
	player.ped = ped
	player.character = id
	TriggerClientEvent('playerSpawned', src, character)
end

RegisterNetEvent('playCharacter')
AddEventHandler('playCharacter', function(id)
	local src = source
	local player = players[src]
	if not player then
		return
	end
	local characters = kvp[player.identifier]
	if not characters or not characters[id] then
		return
	end
	playCharacter(src, player, characters, id)
end)

RegisterNetEvent('registerCharacter')
AddEventHandler('registerCharacter', function(character)
	local src = source
	local player = players[src]
	if not player then
		return
	end
	local characters = kvp[player.identifier]
	if not characters then
		return
	end
	table.insert(characters, character)
	playCharacter(src, player, characters, #characters)
end)

RegisterNetEvent('deleteCharacter')
AddEventHandler('deleteCharacter', function(id)
	local src = source
	local player = players[src]
	if not player then
		return
	end
	local characters = kvp[player.identifier]
	if not characters or not characters[id] then
		return
	end
	table.remove(characters, id)
	savePlayer(player)
end)

RegisterCommand('relog', function(src)
	local player = players[src]
	savePlayer(player)
	players[src] = {
		identifier = player.identifier
	}
	TriggerClientEvent('charactersMenu', src, kvp[player.identifier])
end)