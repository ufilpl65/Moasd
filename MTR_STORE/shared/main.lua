VeraAC = {}

-- تشفير الأحداث لمنع الهاكرز من معرفة الـ Triggers
function VeraAC.Encode(name)
    local secret = "VERA_SECRET_99" -- يمكنك تغيير هذا الرمز لزيادة الأمان
    return string.upper(name .. ":" .. secret)
end