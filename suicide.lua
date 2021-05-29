local function onSuicide()
    Citizen.CreateThread(function()
        RequestAnimDict('mp_suicide')
        while not HasAnimDictLoaded('mp_suicide') do
			Citizen.Wait(0)
        end
		
        local ped = PlayerPedId()
		
		animationWeapon = ''
		weaponType = ''
		--Suicide By Weapon--
		if HasPedGotWeapon(ped, GetHashKey('weapon_pistol'), false) then
			weaponType = 'weapon_pistol'
			animationWeapon = 'pistol'
		elseif HasPedGotWeapon(ped, GetHashKey('weapon_combatpistol'), false) then
			weaponType = 'weapon_combatpistol'
			animationWeapon = 'pistol'
		else -- Suicide By Pill -- 
			weaponType = 'weapon_pill'
			animationWeapon = 'pill'
		end -- if
		
		SetCurrentPedWeapon(ped, GetHashKey(weaponType), true)
		TaskPlayAnim(ped, "mp_suicide", animationWeapon, 8.0, 1.0, -1, 2, 0, 0, 0, 0)
		
		ClearPedTasks(ped)
        while true do 
			SetPedFiringPattern(0x5D60E4E0)
            local animationTime = GetEntityAnimCurrentTime(ped, 'MP_SUICIDE', animationWeapon)
				Citizen.Wait(1)-- this is good, try it this way
            if animationTime > 0.536 then 
                ClearPedTasks(ped)
				ClearEntityLastDamageEntity(ped)
                SetEntityHealth(ped, 0)
			end -- if
			
			if animationTime > 0.3 then 
				-- TaskShootAtCoord(ped, 0.0, 0.0, 0.0, 1, GetHashKey('FIRING_PATTERN_SINGLE_SHOT ')) -- this one makes a fake move XD
				SetPedShootsAtCoord(ped, 0.0, 0.0, 0.0, 0)
				
			end -- if
			
        end -- while
		
    end) -- thread
	
end -- onSuicide

RegisterCommand('suicide', onSuicide())