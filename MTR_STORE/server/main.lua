local QBCore = exports['qb-core']:GetCoreObject()

-- وظيفة إرسال اللوج للديسكورد
local function SendToDiscord(webhook, title, message, color)
    local embed = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = message,
            ["footer"] = { ["text"] = "Vera CFW Protection System" },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- استلام بلاغات الباند
RegisterNetEvent(VeraAC.Encode("Ban"), function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local logMsg = "**اللاعب:** " .. GetPlayerName(src) .. "\n**السبب:** " .. reason .. "\n**ID:** " .. src
    SendToDiscord(Config.Webhooks.bans, "⛔ Permanent Ban", logMsg, 16711680)
    
    -- تنفيذ الباند في قاعدة البيانات (QB-Core)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, bannedby) VALUES (?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src), GetPlayerIdentifier(src, 0), GetPlayerIdentifier(src, 3), GetPlayerEndpoint(src), "Vera-AC: " .. reason, "System"
    })
    
    DropPlayer(src, Config.Prefix .. "تم حظرك نهائياً من السيرفر. السبب: " .. reason)
end)

-- استلام بلاغات التنبيه (بدون طرد)
RegisterNetEvent(VeraAC.Encode("Alert"), function(info)
    local src = source
    SendToDiscord(Config.Webhooks.alerts, "⚠️ Detection Alert", "**اللاعب:** " .. GetPlayerName(src) .. "\n**التنبيه:** " .. info, 16776960)
end)