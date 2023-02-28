RegisterNetEvent('playerConnected')
AddEventHandler('playerConnected', function()
	local ped = PlayerPedId()
	freezePlayer(true)
	if Config.sky and ped ~= 2 then
		SwitchOutPlayer(ped, 0, 1)
	end
end)

TriggerEvent('playerConnected')

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function(character)
	Citizen.CreateThread(function()
		local status = character.status

		local player = PlayerId()
		
		if status.health > 0 and IsPlayerDead(player) then
			TriggerEvent('revivePlayer')
		end

		SetMaxWantedLevel(Config.policeNPC and 5 or 0)
		NetworkSetFriendlyFireOption(Config.PVP)

		SetPlayerMaxArmour(player, status.maxarmour)
		SetPlayerHealthRechargeMultiplier(player, status.rechargemultiplier)
		SetPlayerHealthRechargeLimit(player, status.rechargelimit)

		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			RequestCollisionAtCoord(character.position.x, character.position.y, character.position.z)
			Wait(1)
        end

		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()

		if Config.sky then
			SwitchInPlayer(PlayerPedId())
	
			while IsPlayerSwitchInProgress() do Wait(1) end
		end

		SetEntityMaxHealth(PlayerPedId(), status.maxhealth)
		SetPedArmour(PlayerPedId(), status.armour)
		SetEntityHealth(PlayerPedId(), status.health)

		freezePlayer()

		DoScreenFadeIn(100)
	end)
end)

TriggerServerEvent('playerConnected')