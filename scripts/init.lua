if (PopVersion >= "0.30.4") then
  Tracker.AllowDeferredLogicUpdate = true
end


ScriptHost:LoadScript("scripts/Lists.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/locations.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")
ScriptHost:LoadScript("scripts/watches.lua")

Tracker:AddItems("items/items.json")
Tracker:AddMaps("maps/maps.json")
Tracker:AddLayouts("layouts/item_grids.json")
Tracker:AddLayouts("layouts/layouts.json")
Tracker:FindObjectForCode("Score"):SetOverlayFontSize(25)
Tracker:FindObjectForCode("Score").BadgeTextColor = "#f8d100"
Tracker:FindObjectForCode("Pokedex"):SetOverlayFontSize(25)
Tracker:FindObjectForCode("Targets"):SetOverlayFontSize(25)
Tracker:FindObjectForCode("ruby"):SetOverlayFontSize(13)
Tracker:FindObjectForCode("ruby"):SetOverlayBackground("7E252523")
Tracker:FindObjectForCode("sapphire"):SetOverlayFontSize(13)
Tracker:FindObjectForCode("sapphire"):SetOverlayBackground("7E252523")

for index, value in ipairs(POKEMON_CODES) do
  for k, v in pairs(value) do
    Tracker:FindObjectForCode(v):SetOverlayBackground("FF252523")
    Tracker:FindObjectForCode(v):SetOverlayFontSize(15)
  end
end
GOALS = {}
