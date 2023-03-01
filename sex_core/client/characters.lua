local function ConfirmMenu(title, confirm, cancel)
	exports.sex_menu:menu({
		{
			title = title
		},
		{
			title = 'yes',
			type = 'button',
			confirm = 1
		},
		{
			title = 'no',
			type = 'button'
		}		
	}, function(res)
		if res[2][res[1]].confirm then
			if confirm then
				confirm()
			end
		elseif cancel then
			cancel()
		end
	end, false, cancel)
end

local function IdentityMenu(confirm, cancel, identity)
	exports.sex_menu:menu(identity or {
		{
			title = 'Firstname',
			type = 'text',
			placeholder = 'Firstname',
			maxlength = 30
		},
		{
			title = 'Lastname',
			type = 'text',
			placeholder = 'Lastname',
			maxlength = 30
		},
		{
			title = 'Date Of Birthday',
			type = 'date',
			min = '1900-01-01',
			max = '2005-01-01'
		},
		{
			title = 'Height',
			type = 'range',
			min = 120,
			max = 220
		},
		{
			title = 'Gender',
			type = 'radio',
			value = {
				{'male', true},
				{'female'}
			}
		},
		{
			title = 'submit',
			type = 'button'
		}
	}, function(res)
		ConfirmMenu('Confirm Create New Character?', res[1] == 6 and function()
			for i, r in pairs(res[2]) do
				r.desc = nil
				-- name
				if i < 3 then
					if not r.value then
						r.desc = '* Field Required'
						return IdentityMenu(confirm, cancel, res[2])
					end
					if #r.value < 3 then
						r.desc = '* Input too short'
						return IdentityMenu(confirm, cancel, res[2])
					end
					if r.value:find(' ') then
						r.desc = '* No spaces allowed'
						return IdentityMenu(confirm, cancel, res[2])
					end
					if r.value:match("%d+") then
						r.desc = '* No numbers allowed'
						return IdentityMenu(confirm, cancel, res[2])
					end
				end
			end
			-- dob
			if not res[2][3].value or res[2][3].value == '' then
				res[2][3].desc = '* Field Required'
				return IdentityMenu(confirm, cancel, res[2])
			end
			if res[2][3].value:sub(0, 4) > res[2][3].max:sub(0, 4) then
				res[2][3].desc = '* Input too short'
				return IdentityMenu(confirm, cancel, res[2])
			end
			if res[2][3].value:sub(0, 4) < res[2][3].min:sub(0, 4) then
				res[2][3].desc = '* Input too long'
				return IdentityMenu(confirm, cancel, res[2])
			end
			confirm({
				firstname = res[2][1].value:gsub("^%l", string.upper),
				lastname = res[2][2].value:gsub("^%l", string.upper),
				dob = {
					year = tonumber(res[2][3].value:sub(0, 4)),
					month = tonumber(res[2][3].value:sub(6, 7)),
					day = tonumber(res[2][3].value:sub(9, 10))
				},
				height = tonumber(res[2][4].value),
				gender = res[2][5].value[1][2] and 0 or 1,
			})
		end or cancel, function() IdentityMenu(confirm, cancel, res[2]) end)
	end, false, function(res)
		ConfirmMenu('Cancel Create New Character?', cancel, function() IdentityMenu(confirm, cancel, res) end)
	end)
end

local function characterOptions(id, characters, cancel)
	exports.sex_menu:menu({
		{
			title = characters[id].identity.firstname
		},
		{
			type = 'button',
			title = 'Play this Character',
			play = true
		},
		{
			type = 'button',
			title = 'Delete this Character'
		}
	}, function(res)
		ConfirmMenu(res[2][res[1]].play and 'Confirm Play this Character?' or 'Confirm Delete this Character?', res[2][res[1]].play and function()
			TriggerServerEvent('playCharacter', id)
			exports.sex_menu:menu()
		end or function()
			TriggerServerEvent('deleteCharacter', id)
			table.remove(characters, id)
			cancel()
		end, function()
			characterOptions(id, characters, cancel)
		end)
	end, false, cancel)
end

local function registerIdentity(cancel)
	IdentityMenu(function(identity)
		TriggerServerEvent('registerCharacter', {
			identity = identity,
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
		})
		exports.sex_menu:menu()
	end, cancel)
end

RegisterNetEvent('registerIdentity')
AddEventHandler('registerIdentity', registerIdentity)

local function charactersMenu(characters)
	local elements = {
		{
			title = 'Characters Menu'
		}
	}
	for i, character in pairs(characters) do
		table.insert(elements, {
			type = 'button',
			title = character.identity.firstname,
			id = i
		})
	end
	table.insert(elements, {
		type = 'button',
		title = 'Create New Character',
		id = 'create'
	})
	exports.sex_menu:menu(elements, function(res)
		local id = res[2][res[1]].id
		if id == 'create' then
			ConfirmMenu('Confirm Create New Character?', function()
				registerIdentity(function()
					charactersMenu(characters)
				end)
			end, function()
				charactersMenu(characters)
			end)
		else
			characterOptions(id, characters, function()	
				charactersMenu(characters)
			end)
		end
	end)
end

RegisterNetEvent('charactersMenu')
AddEventHandler('charactersMenu', charactersMenu)