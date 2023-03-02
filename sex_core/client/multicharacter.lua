local function locale(text)
	return text
end

local function confirmMenu(title, confirm, cancel)
	exports.sex_menu:menu({
		title,
		{
			title = locale('yes'),
			type = 'button'
		},
		{
			title = locale('no'),
			type = 'button'
		}		
	}, function(res)
		if res[1] == 2 then
			if confirm then
				confirm()
			end
		elseif cancel then
			cancel()
		end
	end, false, cancel)
end

local characters

local function characterMenu(id, cancel)
	exports.sex_menu:menu({
		{
			title = id
		},
		{
			type = 'button',
			title = locale('play')
		},
		{
			type = 'button',
			title = locale('delete')
		}
	}, function(res)
		local action = res[1] == 2 and 'play' or 'delete'
		confirmMenu({
			title = locale('confirm_' .. action)
		}, function()
			TriggerServerEvent(action .. 'Character', id)
			if res[1] == 2 then
				exports.sex_menu:menu()
			else
				table.remove(characters, id)
				TriggerEvent('multicharacterMenu', characters)
			end
		end, function()
			characterMenu(id, cancel)
		end)
	end, false, cancel)
end

local function identityMenu(confirm, cancel, identity)
	local handler = function(res)
		confirmMenu({
			title = locale((#res == 2 and 'confirm' or 'cancel') .. '_register')
		}, #res == 2 and function()
			for i, v in pairs(res[2]) do
				v.desc = nil
				if i < 3 then -- name
					if not v.value then
						v.desc = '* Field Required'
						return identityMenu(confirm, cancel, res[2])
					end
					if #v.value < 3 then
						v.desc = '* Input too short'
						return identityMenu(confirm, cancel, res[2])
					end
					if v.value:find(' ') then
						v.desc = '* No spaces allowed'
						return identityMenu(confirm, cancel, res[2])
					end
					if v.value:match('%d+') then
						v.desc = '* No numbers allowed'
						return identityMenu(confirm, cancel, res[2])
					end
				end
			end
			if not res[2][3].value or res[2][3].value == '' then -- dob
				res[2][3].desc = '* Field Required'
				return identityMenu(confirm, cancel, res[2])
			end
			if res[2][3].value:sub(0, 4) > res[2][3].max:sub(0, 4) then
				res[2][3].desc = '* Input too short'
				return identityMenu(confirm, cancel, res[2])
			end
			if res[2][3].value:sub(0, 4) < res[2][3].min:sub(0, 4) then
				res[2][3].desc = '* Input too long'
				return identityMenu(confirm, cancel, res[2])
			end
			confirm({
				firstname = res[2][1].value:gsub('^%l', string.upper),
				lastname = res[2][2].value:gsub('^%l', string.upper),
				dob = {
					year = tonumber(res[2][3].value:sub(0, 4)),
					month = tonumber(res[2][3].value:sub(6, 7)),
					day = tonumber(res[2][3].value:sub(9, 10))
				},
				height = tonumber(res[2][4].value),
				gender = res[2][5].value[1][2] and 0 or 1,
			})
		end or cancel, function()
			identityMenu(confirm, cancel, #res == 2 and res[2] or res)
		end)
	end
	exports.sex_menu:menu(identity or {
		{
			title = locale('firstname'),
			type = 'text',
			placeholder = 'Firstname',
			maxlength = 30
		},
		{
			title = locale('lastname'),
			type = 'text',
			placeholder = 'Lastname',
			maxlength = 30
		},
		{
			title = locale('dob'),
			type = 'date',
			min = '1900-01-01',
			max = '2005-01-01'
		},
		{
			title = locale('height'),
			type = 'range',
			min = 120,
			max = 220
		},
		{
			title = locale('gender'),
			type = 'radio',
			value = {
				{locale('male'), true},
				{locale('female')}
			}
		},
		{
			title = locale('submit'),
			type = 'button'
		}
	}, handler, false, cancel and handler)
end

RegisterNetEvent('registerCharacter')
AddEventHandler('registerCharacter', function(cancel)
	local character = {
		appearance = {
			model = 'mp_m_freemode_01',
			components = {}
		},
		position = {
			x = 0,
			y = 0,
			z = 70,
			w = 0
		},
		status = {
			health = 200,
			maxhealth = 200,
			armour = 0,
			maxarmour = 100,
			rechargemultiplier = 0,
			rechargelimit = 0
		}
	}
	if Config.identity then
		identityMenu(function(identity)
			character.identity = identity
			TriggerServerEvent('registerCharacter', character)
			exports.sex_menu:menu()
		end, cancel)
	else
		TriggerServerEvent('registerCharacter', character)
	end
end)

RegisterNetEvent('multicharacterMenu')
AddEventHandler('multicharacterMenu', function(data)
	characters = data and data.characters or characters
	local elements = {
		{
			title = locale('characters_menu')
		},
	}
	for id, character in pairs(characters) do
		table.insert(elements, {
			type = 'button',
			title = id,
			id = id
		})
	end
	table.insert(elements, {
		type = 'button',
		title = locale('create_character'),
		id = 'create'
	})
	exports.sex_menu:menu(elements, function(res)
		local id = res[2][res[1]].id
		if id == 'create' then
			confirmMenu({
				title = locale('confirm_register')
			}, function()
				TriggerEvent('registerCharacter', function()
					TriggerEvent('multicharacterMenu')
				end)
			end, function()
				TriggerEvent('multicharacterMenu')
			end)
		else
			characterMenu(id, function()
				TriggerEvent('multicharacterMenu')
			end)
		end
	end)
end)