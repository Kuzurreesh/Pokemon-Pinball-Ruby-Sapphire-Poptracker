if (PopVersion >= "0.30.4") then
  Tracker.AllowDeferredLogicUpdate = true
end


TEST = {
  [0] = {
    image = "images/items/1.jpg",
    img_mod = "saturation|0.33,brightness|0.40",
    codes = "TreeckoOff2",
    disabled = false
  },
  [1] = {
    image = "images/items/1.jpg",
    img_mod = "saturation|0.50,brightness|0.66",
    codes = "TreeckoCan2",
    disabled = false
  },
  [2] = {
    image = "images/items/1.jpg",
    codes = "Treecko2,TreeckoCaught2,Mon",
    img_mod = "@enabled",
    disabled = false
  }
}



ScriptHost:LoadScript("scripts/custom_items/class.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlusWrapper.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlus.lua")

--ProgressiveTogglePlus("TreeckoTest", "Treecko2", TEST, false, true, false, 0, true, "", false)

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

--Tracker:FindObjectForCode("ruby").BadgeTextColor = "FFFF0000"
Tracker:FindObjectForCode("ruby"):SetOverlayFontSize(20)
--Tracker:FindObjectForCode("sapphire").BadgeTextColor = "FFFF0000"
Tracker:FindObjectForCode("sapphire"):SetOverlayFontSize(20)