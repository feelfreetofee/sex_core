-- Client

local ClientCallbacks = {}
local ClientCallbackID = 0

TriggerClientCallback = function(name, src, cb, ...)
	ClientCallbacks[ClientCallbackID] = cb
	TriggerClientEvent('TriggerClientCallback', src, name, ClientCallbackID, ...)
	ClientCallbackID = ClientCallbackID < 65535 and ClientCallbackID + 1 or 0
end

exports('TriggerClientCallback', TriggerClientCallback)

RegisterNetEvent('ClientCallback')
AddEventHandler('ClientCallback', function(id, ...)
	ClientCallbacks[id](...)
	ClientCallbacks[id] = nil
end)

-- Server

local ServerCallbacks = {}

RegisterServerCallback = function(name, cb)
	ServerCallbacks[name] = cb
end

exports('RegisterServerCallback', RegisterServerCallback)

RegisterNetEvent('TriggerServerCallback')
AddEventHandler('TriggerServerCallback', function(name, id, ...)
	local src = source
	ServerCallbacks[name](src, function(...)
		TriggerClientEvent('ServerCallback', src, id, ...)
	end, ...)
end)