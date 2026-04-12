if (PopVersion >= "0.30.4") then
    Tracker.AllowDeferredLogicUpdate = true
end
--ScriptHost:LoadScript("scripts/custom_items/class.lua")
--ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlusWrapper.lua")
--ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlus.lua")

TEST = {
    [0] = {
        image = "images/items/1 - Off.jpg",
        codes = "test4Off",
        disabled = false
    },
    [1] = {
        image = "images/items/1.jpg",
        codes = "test4Can",
        img_mod = "saturation|0.5,brightness|0.5",
        disabled = false
    },
    [2] = {
        image = "images/items/1.jpg",
        codes = "test6, test4Got",
        disabled = false
    }
}

--Test2 = ProgressiveTogglePlus("Test", "test5", TEST, true, false, false, 0, true, {}, false, {}, false)

ScriptHost:LoadScript("scripts/Lists.lua")
ScriptHost:LoadScript("scripts/watches.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/locations.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")
--Tracker:AddClasses("scripts/Classes/Sapphire1.json")

Tracker:AddItems("items/items.json")
Tracker:FindObjectForCode("evo").BadgeTextColor = "#00FF00"
Tracker:FindObjectForCode("evo").SetOverlayFontSize(Tracker:FindObjectForCode("evo"),15)
Tracker:AddMaps("maps/maps.json")
Tracker:AddLayouts("layouts/item_grids.json")
Tracker:AddLayouts("layouts/layouts.json")


