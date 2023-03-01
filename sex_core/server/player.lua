function playCharacter(src, player, characters, id)
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