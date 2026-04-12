if (PopVersion >= "0.30.4") then
    Tracker.AllowDeferredLogicUpdate = true
end

ScriptHost:LoadScript("scripts/Lists.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/locations.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")
ScriptHost:LoadScript("scripts/watches.lua")

Tracker:AddItems("items/items.json")
Tracker:FindObjectForCode("evo").BadgeTextColor = "#00FF00"
Tracker:FindObjectForCode("evo").SetOverlayFontSize(Tracker:FindObjectForCode("evo"), 15)
Tracker:AddMaps("maps/maps.json")
Tracker:AddLayouts("layouts/item_grids.json")
Tracker:AddLayouts("layouts/layouts.json")



for key, value in pairs(Pokemon) do
    Tracker:FindObjectForCode(value).MaxCount = -1
    Tracker:FindObjectForCode(value).CurrentStage = 0
end

