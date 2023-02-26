-- Server

local ServerCallbacks = {}
local ServerCallbackID = 0

TriggerServerCallback = function(name, cb, ...)
	ServerCallbacks[ServerCallbackID] = cb
	TriggerServerEvent('TriggerServerCallback', name, ServerCallbackID, ...)
	ServerCallbackID = ServerCallbackID < 65535 and ServerCallbackID + 1 or 0
end

exports('TriggerServerCallback', TriggerServerCallback)

RegisterNetEvent('ServerCallback')
AddEventHandler('ServerCallback', function(id, ...)
	ServerCallbacks[id](...)
	ServerCallbacks[id] = nil
end)


-- Client

local ClientCallbacks = {}

RegisterClientCallback = function(name, cb)
	ClientCallbacks[name] = cb
end

exports('RegisterClientCallback', RegisterClientCallback)

RegisterNetEvent('TriggerClientCallback')
AddEventHandler('TriggerClientCallback', function(name, id, ...)
	ClientCallbacks[name](function(...)
		TriggerServerEvent('ClientCallback', id, ...)
	end, ...)
end)