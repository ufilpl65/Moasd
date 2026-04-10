local QBCore = exports['qb-core']:GetCoreObject()
local sitting = false
local lastPos = nil

-- قائمة شاملة جداً لموديلات الكراسي والكنب في اللعبة
local chairModels = {
    -- كراسي المكاتب والمنزل
    `prop_chair_01a`, `prop_chair_01b`, `prop_chair_02`, `prop_chair_03`, `prop_chair_04a`, `prop_chair_04b`, `prop_chair_05`, `prop_chair_06`, `prop_chair_08`, `prop_chair_09`, `prop_chair_10`,
    `v_res_fh_chair01`, `v_res_fa_chair01`, `v_res_f_chair02`, `v_club_officechair`, `v_corp_offchair`, `prop_direct_chair_01`, `prop_off_chair_01`, `prop_off_chair_03`, `prop_off_chair_04`, `prop_off_chair_05`,
    -- كنب ومقاعد (Sofas & Benches)
    `prop_bench_01a`, `prop_bench_01b`, `prop_bench_01c`, `prop_bench_02`, `prop_bench_03`, `prop_bench_04`, `prop_bench_05`, `prop_bench_06`, `prop_bench_08`, `prop_bench_09`, `prop_bench_10`, `prop_bench_11`,
    `v_res_d_sofa_3p`, `v_res_mp_sofa`, `v_res_tre_sofa`, `v_res_sofa_mess_01`, `v_club_ch_armchair`, `prop_waiting_chair_01`, `prop_yacht_seat_01`, `prop_yacht_seat_02`, `prop_yacht_seat_03`,
    -- كراسي المطاعم والحدائق
    `prop_beach_chair_01`, `prop_beach_chair_02`, `p_garden_chair_01`, `prop_garden_chair_b`, `prop_table_01_chr_a`, `prop_table_02_chr_a`, `prop_table_03_chr_a`, `prop_table_03b_chr_a`, `prop_table_04_chr_a`, `prop_table_05_chr_a`, `prop_table_06_chr_a`,
    -- كراسي إضافية (Common MLO & DLC)
    `v_ilev_hd_chair`, `v_ret_gc_chair01`, `v_res_d_chair`, `v_res_j_chair01`, `v_res_ka_chair`, `v_res_m_chair`, `v_res_mb_chair`, `v_res_tre_chair01`, `prop_rock_chair_01`, `hei_heist_din_chair_01`, `hei_heist_din_chair_02`, `hei_heist_din_chair_03`, `hei_heist_din_chair_04`, `hei_heist_din_chair_05`
}

-- إضافة الموديلات لـ qb-target
exports['qb-target']:AddTargetModel(chairModels, {
    options = {
        {
            type = "client",
            event = "vera-sit:client:sit",
            icon = "fas fa-chair",
            label = "Sit Down",
        },
    },
    distance = 1.5,
})

-- حدث الجلوس والنهوض
RegisterNetEvent('vera-sit:client:sit', function(data)
    local playerPed = PlayerPedId()
    local object = data.entity
    
    if not sitting then
        -- حفظ المكان قبل الجلوس للعودة إليه عند النهوض
        lastPos = GetEntityCoords(playerPed)
        local objectCoords = GetEntityCoords(object)
        local objectHeading = GetEntityHeading(object)
        
        -- تجميد اللاعب مؤقتاً لضبط الوضعية
        FreezeEntityPosition(playerPed, true)
        
        -- تشغيل انيميشن الجلوس (الوضعية القياسية)
        -- نستخدم Offset -0.5 لضبط الارتفاع على الكرسي
        TaskStartScenarioAtPosition(playerPed, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", objectCoords.x, objectCoords.y, objectCoords.z - 0.5, objectHeading + 180.0, 0, true, true)
        
        sitting = true
        QBCore.Functions.Notify("Press [E] to Stand Up", "primary")
    end
end)

-- خيط معالجة (Thread) للنهوض عند الضغط على زر E
CreateThread(function()
    while true do
        local wait = 1000
        if sitting then
            wait = 0
            if IsControlJustPressed(0, 38) then -- زر E
                local playerPed = PlayerPedId()
                
                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)
                
                -- العودة قليلاً للخلف عند النهوض حتى لا يعلق اللاعب داخل الكرسي
                SetEntityCoords(playerPed, lastPos.x, lastPos.y, lastPos.z)
                
                sitting = false
            end
        end
        Wait(wait)
    end
end)