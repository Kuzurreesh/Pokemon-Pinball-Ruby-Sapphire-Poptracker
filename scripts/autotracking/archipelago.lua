-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via their ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")


CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
Traps = {}

function onClear(slot_data)
    ScriptHost:RemoveWatchForCode("Total")
    ScriptHost:RemoveOnLocationSectionChangedHandler("Board Totals")
    for index, value in pairs(AREA_NAMES) do
        ScriptHost:RemoveWatchForCode("Area " .. index)
    end

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1

    TeamName = Archipelago:GetPlayerAlias(Archipelago.PlayerNumber)
    TeamNumber = Archipelago.TeamNumber

    NotifyHints = {
        "_read_hints_" .. TeamNumber .. "_" .. Archipelago.PlayerNumber
    }

    Tracker:FindObjectForCode("Total").AcquiredCount = 0
    for key, value in pairs(Pokemon) do
        Tracker:FindObjectForCode(value).CurrentStage = 0
    end


    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))

                for index, value in ipairs(v) do
                    local obj = Tracker:FindObjectForCode(value[1])
                    if obj then
                        if value[1]:sub(1, 1) == "@" then
                            obj.AvailableChestCount = obj.ChestCount
                        else
                            --hosted_item reset
                            obj.CurrentStage = 0
                        end
                    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                        print(string.format("onClear: could not find object for code %s", v[1]))
                    end
                end
            end
        end
        -- reset items
        for _, v in pairs(ITEM_MAPPING) do
            if v[1][1] and v[1][2] then
                if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: clearing item %s of type %s", v[1][1], v[1][2]))
                end
                if v[2] then
                    Tracker:FindObjectForCode(v[2][1]).AcquiredCount = 0
                end
                local obj = Tracker:FindObjectForCode(v[1][1])
                if obj then
                    if v[1][2] == "toggle" then
                        obj.Active = false
                    elseif v[1][2] == "progressive" then
                        obj.CurrentStage = 0
                        obj.Active = false
                    elseif v[1][2] == ("consumable") then
                        obj.AcquiredCount = 0
                    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                        print(string.format("onClear: unknown item type %s for code %s", v[1][2], v[1][1]))
                    end
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: could not find object for code %s", v[1][1]))
                end
            end
        end

        -- reset local item(s)


        -- Autotracking options


        if slot_data then

        end

        LOCAL_ITEMS = {}
        GLOBAL_ITEMS = {}
        ScriptHost:AddWatchForCode("Total", "Dummy", Total)
        for index, value in pairs(AREA_NAMES) do
            ScriptHost:AddWatchForCode("Area " .. index, value, Evolve)
        end
        ScriptHost:AddOnLocationSectionChangedHandler("Board Totals", BoardTotals)
        Archipelago:Get(NotifyHints)
        Archipelago:SetNotify(NotifyHints)
    end
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1][1], v[1][2]))
    end
    if not v[1] then
        return
    end
    if v[2] then
        local obj = Tracker:FindObjectForCode(v[2][1])
        if obj then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        end
    end
    local obj = Tracker:FindObjectForCode(v[1][1])
    if obj then
        if v[1][2] == "toggle" then
            obj.Active = true
        elseif v[1][2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[1][2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[1][2], v[1][1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1][1]))
    end
    -- track local items via snes interface

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump(GLOBAL_ITEMS)))
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    -- print(string.format("called onLocation: %s, %s", location_id, location_name))

    if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
        return
    end
    local v = LOCATION_MAPPING[location_id]

    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v then
        return
    end
    for index, value in ipairs(v) do
        local mon = nil
        for ind, val in ipairs(value) do
            local obj = Tracker:FindObjectForCode(val)

            if obj then
                if val:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.AvailableChestCount - 1
                    obj.Highlight = Highlight.None
                else
                  --  if val == "Treecko" then
                 --       Tracker:FindObjectForCode("Treecko2").ItemState:setState(2)
                 --   else
                        obj.CurrentStage = 2
                    --end
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onLocation: could not find object for code %s", v[1]))
            end
        end
    end
end

-- called when a bounce message is received
function onBounce(json)

end

function onDataStorageUpdate(key, value, oldValue)
    if key == NotifyHints[1] and value then
        for _, hint in ipairs(value) do
            -- we only care about hints in our world

            if hint.finding_player == Archipelago.PlayerNumber then
                local location_code = LOCATION_MAPPING[hint.location]
                --   print("-----------------location_code-------------------------")
                -- print(dump_table(location_code))
                for k, v in pairs(location_code) do
                    --   print("-----------------v-------------------------")
                    --      print(dump_table(v))
                    --    print("-----------------v[1]-------------------------")
                    --    print(dump_table(v[1]))

                    if v then
                        -- print("-----------------value-------------------------", v)
                        if v[1]:sub(1, 1) == "@" then
                            Tracker:FindObjectForCode(v[1]).Highlight = HIGHLIGHT_STATUS_MAPPING[hint.status]
                        end
                    end
                end
            end
        end
    end
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end

if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end
--Archipelago:AddBouncedHandler("bounce handler", onBounce)
Archipelago:AddRetrievedHandler("retrieved handler", onDataStorageUpdate)
Archipelago:AddSetReplyHandler("set reply handler", onDataStorageUpdate)
