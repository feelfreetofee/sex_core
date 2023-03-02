RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function(char)
	character = char

	local status = character.status
	
	if status.health > 0 then
		TriggerEvent('revivePlayer')
	end

	local player = PlayerId()

	SetMaxWantedLevel(Config.policeNPC and 5 or 0)
	NetworkSetFriendlyFireOption(Config.PVP)

	SetPlayerMaxArmour(player, status.maxarmour)
	SetPlayerHealthRechargeMultiplier(player, status.rechargemultiplier)
	SetPlayerHealthRechargeLimit(player, status.rechargelimit)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(GetEntityCoords(PlayerPedId()))
		Wait(1)
	end

	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	if IsPlayerSwitchInProgress() then
		SwitchInPlayer(PlayerPedId())
		while IsPlayerSwitchInProgress() do Wait(1) end
	end

	SetEntityMaxHealth(PlayerPedId(), status.maxhealth)
	SetPedArmour(PlayerPedId(), status.armour)
	SetEntityHealth(PlayerPedId(), status.health)

	TriggerEvent('freezePlayer')

	DoScreenFadeIn(100)
end)

RegisterNetEvent('playerConnected')
AddEventHandler('playerConnected', function()
	TriggerEvent('freezePlayer', true)
	local ped = PlayerPedId()
	if Config.sky and ped ~= 2 then
		SwitchOutPlayer(ped, 0, 1)
	elseif IsScreenFadedIn() then
		DoScreenFadeOut(100)
	end
	TriggerServerEvent('playerConnected')
end)

TriggerEvent('playerConnected')