RegisterNetEvent('freezePlayer')
AddEventHandler('freezePlayer', function(freeze)
    local player = PlayerId()
    SetPlayerControl(player, not freeze)
    SetPlayerInvincible(player, freeze)

	local ped = PlayerPedId()
    SetEntityVisible(ped, not freeze or not IsEntityVisible(ped))

    if freeze or IsPedOnFoot(ped) then
        SetEntityCollision(ped, not freeze)
    end

    FreezeEntityPosition(ped, freeze)

    if freeze and not IsPedFatallyInjured(ped) then
        ClearPedTasksImmediately(ped)
    end
end)

RegisterNetEvent('revivePlayer')
AddEventHandler('revivePlayer', function()
	if IsPlayerDead(PlayerId()) then
		local ped = PlayerPedId()
		NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped))
	end
end)