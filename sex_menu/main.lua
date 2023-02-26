local selected
local changed
local closed

RegisterNUICallback('selected', function(data, cb)
	if selected then selected(data) end
	cb('ok')
end)

RegisterNUICallback('changed', function(data, cb)
	if changed then changed(data) end
	cb('ok')
end)

RegisterNUICallback('closed', function(data, cb)
	if closed then closed(data) end
	cb('ok')
end)

exports('menu', function(data, select, change, close)
	selected = select
	changed = change
	closed = close
	SendNUIMessage(data)
	SetNuiFocus(data, data)
	SetNuiFocusKeepInput(data)
end)