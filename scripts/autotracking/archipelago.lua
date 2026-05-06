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
    NotifyStorage = {
        "PINBALLRS_POKEDEX_" .. TeamNumber .. "_" .. Archipelago.PlayerNumber
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
            end
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
    end


    -- Autotracking options

    TARGETS = {}
    if slot_data then
        GOALS = slot_data["goal"]
        for index, value in ipairs(GOALS) do
            if value == "Pokedex" then
                Tracker:FindObjectForCode("pokedex_requirement").AcquiredCount = slot_data["pokedex_requirement"]
            elseif value == "Targets" then
                Tracker:FindObjectForCode("Targets").AcquiredCount = #slot_data["pokemon_targets"]
                for i, va in ipairs(slot_data["pokemon_targets"]) do
                    --     print(POKEMON_INVERSE[va], va)
                    table.insert(TARGETS, POKEMON_INVERSE[va])
                end

                -- print(dump_table(TARGETS))
                for k, v in pairs(TARGETS) do
                    for key, val in pairs(POKEMON_CODES[v]) do
                        Tracker:FindObjectForCode(val).BadgeText = "T"
                    end
                end
            elseif value == "Score" then
                Tracker:FindObjectForCode("score_requirement").AcquiredCount = slot_data["score_requirement"] / 1000
            end
        end
        Tracker:FindObjectForCode("bonus_multiplier_checks").AcquiredCount = slot_data["bonus_multiplier_checks"]
        Tracker:FindObjectForCode("ball_upgrade_checks").AcquiredCount = slot_data["ball_upgrade_checks"]

        Tracker:FindObjectForCode("Difficulty").CurrentStage = slot_data["difficulty"]
        Tracker:FindObjectForCode("Targets").AcquiredCount = #slot_data["pokemon_targets"]
        Tracker:FindObjectForCode("single").Active = slot_data["single_board"]
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
    -- Archipelago:Get(NotifyStorage)
    -- Archipelago:SetNotify(NotifyStorage)
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

    ScriptHost:RemoveOnLocationSectionChangedHandler("Board Totals")
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
    local mon = ""
    for index, value in ipairs(v) do
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
            if index == #v then
                if val:sub(1, 5) == "@Poke" then
                    local x = val:find("//")
                    mon = val:sub(x + 2, val:len())
                    for _, va in ipairs(POKEMON_CODES[POKEMON_INVERSE[mon]]) do
                        if TableContains(TARGETS, POKEMON_INVERSE[mon]) then
                            Tracker:FindObjectForCode(va).BadgeTextColor = "#00FF00"
                        end
                        Tracker:FindObjectForCode(va).CurrentStage = 2
                    end
                end
            end
        end
    end
    if mon ~= "" then

    end
    ScriptHost:AddOnLocationSectionChangedHandler("Board Totals", BoardTotals)
    Evolve()
    Total()
    BoardTotals()
end

-- called when a bounce message is received
function onBounce(json)

end

function onDataStorageUpdate(key, value, oldValue)
    ScriptHost:RemoveWatchForCode("Total")
    if key == NotifyHints[1] and value then
        for _, hint in ipairs(value) do
            if hint.finding_player == Archipelago.PlayerNumber then
                local location_code = LOCATION_MAPPING[hint.location]
                for k, v in pairs(location_code) do
                    if v then
                        if v[1]:sub(1, 1) == "@" then
                            if (Tracker:FindObjectForCode(v[1]).Highlight < HIGHLIGHT_STATUS_MAPPING[hint.status]) or Tracker:FindObjectForCode(v[1]).Highlight == Highlight.None then
                                Tracker:FindObjectForCode(v[1]).Highlight = HIGHLIGHT_STATUS_MAPPING[hint.status]
                            end
                        end
                    end
                end
            end
        end
    end
    if key == NotifyStorage[1] and value then
        local gameDex = toBits(value)


        local target = false
        for index, val in ipairs(gameDex) do
            if TableContains(TARGETS, val) then
                target = true
            end
            if val < 206 then
                for k, v in pairs(POKEMON_CODES[val]) do
                    if not target then
                        Tracker:FindObjectForCode(v).BadgeText = "X"
                    end
                    Tracker:FindObjectForCode(v).BadgeTextColor = "#00FF00"
                end
                target = false
            end
        end
    end


    if key == "x" then
        print(value)
        local buffer = {}
        local dex = tostring(value)
        for i = 1, dex:len(), 1 do
            buffer[i] = dex:sub(i, i)
        end
        --   dex = value & (1 << (dexNum - 1))
        print(dump_table(buffer))

        local buffer = {}
        --if value ~= oldValue then
        print(value)
        local dex = string.unpack('f', value)

        for i = 1, 4, 1 do
            buffer[i] = string.byte(dex, i); print(string.format("%d", buffer[i]))
        end
        --  end
        print(dump_table(toBits(buffer[1])))
        print(dump_table(toBits(buffer[2])))
        print(dump_table(toBits(buffer[3])))
        print(dump_table(toBits(buffer[4])))
    end

    ScriptHost:AddWatchForCode("Total", "Dummy", Total)
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
