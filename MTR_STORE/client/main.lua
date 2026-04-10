local isProtected = true

CreateThread(function()
    while true do
        local sleep = 1500
        local ped = PlayerPedId()
        local player = PlayerId()

        -- 1. كشف الـ GodMode
        if Config.Settings.AntiGodMode and GetPlayerInvincible(player) then
            TriggerServerEvent(VeraAC.Encode("Ban"), "GodMode Detected")
        end

        -- 2. كشف الـ NoClip & SpeedHack
        if not IsPedInAnyVehicle(ped, false) then
            local speed = GetEntitySpeed(ped)
            if speed > Config.Settings.MaxSpeed and not IsPedFalling(ped) and not IsPedInWater(ped) then
                TriggerServerEvent(VeraAC.Encode("Alert"), "Potential SpeedHack: " .. speed)
            end
        end

        -- 3. كشف الاختفاء
        if Config.Settings.AntiInvisible and not IsEntityVisible(ped) then
            TriggerServerEvent(VeraAC.Encode("Alert"), "Player is Invisible")
        end

        -- 4. كشف الأسلحة الممنوعة
        for _, wp in ipairs(Config.Settings.BlacklistedWeapons) do
            if HasPedGotWeapon(ped, GetHashKey(wp), false) then
                RemoveWeaponFromPed(ped, GetHashKey(wp))
                TriggerServerEvent(VeraAC.Encode("Ban"), "Blacklisted Weapon: " .. wp)
            end
        end

        Wait(sleep)
    end
end)

-- كشف ضغطات أزرار المنيو
CreateThread(function()
    while true do
        Wait(0)
        for _, key in ipairs(Config.Settings.BlacklistedKeys) do
            if IsControlJustReleased(0, key) then
                TriggerServerEvent(VeraAC.Encode("Alert"), "Pressed Blacklisted Key ID: " .. key)
            end
        end
    end
end)