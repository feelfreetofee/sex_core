kvp = {}
players = {}

function savePlayer(player)
	local data = kvp[player.identifier]
	if player.character then
		local coords = GetEntityCoords(player.ped)
		local character = data.characters[player.character]
		character.position = {
			x = coords.x,
			y = coords.y,
			z = coords.z,
			w = GetEntityHeading(player.ped)		
		}
		character.status.health = GetEntityHealth(player.ped)
		character.status.armour = GetPedArmour(player.ped)
	end
	SetResourceKvp(player.identifier, json.encode(data))
end

function spawnPlayer(player, data, id)
	local character = data.characters[id]
	local model = joaat(character.appearance.model)
	SetPlayerModel(player.src, model)
	local ped = GetPlayerPed(player.src)
	player.ped = ped
	while GetEntityModel(ped) ~= model do Wait(1) end
	SetPedDefaultComponentVariation(ped)
	SetEntityCoords(ped, vec3(character.position.x, character.position.y, character.position.z))
	SetEntityHeading(ped, character.position.w)
	player.character = id
	TriggerClientEvent('playerSpawned', player.src, character)
end