function Writing()
    local pokemon = ""
    local area = ""
    local arrows = 0
    for index, value in ipairs(AREAS) do
        area = AREA_NAMES[index]
        for i, v in ipairs(value) do
            pokemon = PokemonZero[v[1]]
            arrows = v[2]
            print(v[1] + 1 .. "," .. pokemon .. "," .. area .. "," .. arrows)
        end
    end
end

function Writing7()
    local obj = Tracker:FindObjectForCode("Score")
    obj.Active = true
    obj.BadgeTextColor = "#f8d100"
    obj:SetOverlay("100,000,000")
    obj:SetOverlayFontSize(25)

    Tracker:FindObjectForCode("Pokedex").AcquiredCount = 205
    Tracker:FindObjectForCode("Pokedex"):SetOverlayFontSize(25)

    Tracker:FindObjectForCode("Targets").AcquiredCount = 205
    Tracker:FindObjectForCode("Targets"):SetOverlayFontSize(25)
end

function Writing5()
    local total = 0

    local single = 0
    for i = 1, 205, 1 do
        local count = 0
        local mon = ""
        for key, value in pairs(LOCATION_MAPPING[i]) do
            if value[1]:sub(1, 1) == "@" then
            else
                --       print(value[1])
            end
            count = key
        end
        -- print(LOCATION_MAPPING[i][count][1] .. "," .. count - 2)
        -- if (count - 2) > 1 then
        print(LOCATION_MAPPING[i][count][1])
        for u = 1, (count - 2), 1 do
            if LOCATION_MAPPING[i][u][1]:sub(1, 7) == "@Eggs R" then
                print(LOCATION_MAPPING[i][count][1] .. "RubyEgg,RubyEgg," .. LOCATION_MAPPING[i][u][1])
            elseif LOCATION_MAPPING[i][u][1]:sub(1, 7) == "@Eggs S" then
                print(LOCATION_MAPPING[i][count][1] .. "SapphireEgg,SapphireEgg," .. LOCATION_MAPPING[i][u][1])
            elseif LOCATION_MAPPING[i][u][1]:sub(1, 7) == "@Ruby B" then
                print(LOCATION_MAPPING[i][count][1] .. "Ruby,Ruby," .. LOCATION_MAPPING[i][u][1])
            elseif LOCATION_MAPPING[i][u][1]:sub(1, 7) == "@Sapphi" then
                print(LOCATION_MAPPING[i][count][1] .. "Sapphire,Sapphire," .. LOCATION_MAPPING[i][u][1])
            else
                print(LOCATION_MAPPING[i][count][1] .. u .. ",Special," .. LOCATION_MAPPING[i][u][1])
            end
        end
        -- else
        --    single = single +1
        --     print(LOCATION_MAPPING[i][count][1])
        --      print(LOCATION_MAPPING[i][count][1].."Dex,".. LOCATION_MAPPING[i][1][1])
        --   end
        -- total = total +count
        --    print(mon)
    end
    -- print(single)
end

function Writing6()

end

--ScriptHost:AddWatchForCode("test", "write", Writing6)
--ScriptHost:AddWatchForCode("test2", "Difficulty", Writing2)
--ScriptHost:AddWatchForCode("test3", "OoL", Writing2)


function Total(code)
    local count = 0
    if code == "Total" then
        -- print("----------------------code total---------------------------")
        return
    end
    for index, value in ipairs(Pokemon) do
        if Caught2(value) then
            count = count + 1
        end
    end
    Tracker:FindObjectForCode("Total").AcquiredCount = count
end

ScriptHost:AddWatchForCode("Total", "Dummy", Total)


function Evolve(trigger)
    local countruby = 0
    local countsapphire = 0
    for key, value in pairs(Pokemon) do
        local mon = Tracker:FindObjectForCode(value)
        local obj = Tracker:FindObjectForCode("@Pokemon//" .. value).AccessibilityLevel
        if obj == AccessibilityLevel.Cleared then
            mon.CurrentStage = 2
        elseif obj == AccessibilityLevel.Normal then
            mon.CurrentStage = 1
        elseif (obj == AccessibilityLevel.None) or (obj == AccessibilityLevel.SequenceBreak) then
            mon.CurrentStage = 0
        end
    end
    for key, value in pairs(POKEMON_RUBY_LIST) do
        local mon = Tracker:FindObjectForCode(key)
        local obj = Tracker:FindObjectForCode(value).AccessibilityLevel
        if obj == AccessibilityLevel.Cleared then
            mon.CurrentStage = 2
        elseif obj == AccessibilityLevel.Normal then
            mon.CurrentStage = 1
            countruby = countruby + 1
        elseif (obj == AccessibilityLevel.None) or (obj == AccessibilityLevel.SequenceBreak) then
            mon.CurrentStage = 0
        end
    end
    for key, value in pairs(POKEMON_SAPPHIRE_LIST) do
        local mon = Tracker:FindObjectForCode(key)
        local obj = Tracker:FindObjectForCode(value).AccessibilityLevel
        if obj == AccessibilityLevel.Cleared then
            mon.CurrentStage = 2
        elseif obj == AccessibilityLevel.Normal then
            mon.CurrentStage = 1
            countsapphire = countsapphire + 1
        elseif (obj == AccessibilityLevel.None) or (obj == AccessibilityLevel.SequenceBreak) then
            mon.CurrentStage = 0
        end
    end
    BoardTotals(countruby, countsapphire)
    Tracker:FindObjectForCode("dummy").Active = not Tracker:FindObjectForCode("dummy").Active
end

for index, value in pairs(AREA_NAMES) do
    ScriptHost:AddWatchForCode("Area " .. index, value, Evolve)
end


function BoardTotals(countruby, countsapphire)
    if countsapphire == nil then
        countruby = 0
        countsapphire = 0
        for key, value in pairs(POKEMON_RUBY_LIST) do
            local obj = Tracker:FindObjectForCode(value).AccessibilityLevel
            if obj == AccessibilityLevel.Normal then
                countruby = countruby + 1
            end
        end
        for key, value in pairs(POKEMON_SAPPHIRE_LIST) do
            local obj = Tracker:FindObjectForCode(value).AccessibilityLevel
            if obj == AccessibilityLevel.Normal then
                countsapphire = countsapphire + 1
            end
        end
    end
    for key, value in pairs(LOCATION_RUBY_LIST) do
        local obj = Tracker:FindObjectForCode(value)
        if obj.AccessibilityLevel == AccessibilityLevel.Normal then
            countruby = countruby + obj.AvailableChestCount
        end
    end
    for key, value in pairs(LOCATION_SAPPHIRE_LIST) do
        local obj = Tracker:FindObjectForCode(value)
        if obj.AccessibilityLevel == AccessibilityLevel.Normal then
            countsapphire = countsapphire + obj.AvailableChestCount
        end
    end
    Tracker:FindObjectForCode("ruby").BadgeText = countruby
    Tracker:FindObjectForCode("sapphire").BadgeText = countsapphire
end

ScriptHost:AddOnLocationSectionChangedHandler("Board Totals", BoardTotals)


function Highlighting(list)
    for key, value in pairs(list) do
        local obj = Tracker:FindObjectForCode(value[1])
        if obj then
            if obj.AccessibilityLevel == AccessibilityLevel.Cleared then
                obj.Highlight = Highlight.None
            else
                obj.Highlight = Highlight.NoPriority
            end
        end
    end
end

function Unlighting(list)
    for key, value in pairs(list) do
        local obj = Tracker:FindObjectForCode(value[1])
        if obj then
            obj.Highlight = Highlight.None
        end
    end
end

function Multiplier()
    local multi = Tracker:ProviderCountForCode("multi")
    if multi > 9 then
        Tracker:FindObjectForCode("@Ruby Board/Ruby Board/Bonus Multiplier 1-9").AvailableChestCount = 9
        Tracker:FindObjectForCode("@Sapphire Board/Sapphire Board/Bonus Multiplier 1-9").AvailableChestCount = 9
        multi = multi - 9
        if multi > 14 then
            Tracker:FindObjectForCode("@Ruby Board/Ruby Board/Bonus Multiplier 10-24").AvailableChestCount = 15
            Tracker:FindObjectForCode("@Sapphire Board/Sapphire Board/Bonus Multiplier 10-24").AvailableChestCount = 15
            multi = multi - 15
            if multi > 49 then
                Tracker:FindObjectForCode("@Ruby Board/Ruby Board/Bonus Multiplier 25-74").AvailableChestCount = 50
                Tracker:FindObjectForCode("@Sapphire Board/Sapphire Board/Bonus Multiplier 25-74").AvailableChestCount = 50
                multi = multi - 50
                Tracker:FindObjectForCode("@Ruby Board/Ruby Board/Bonus Multiplier 75-99").AvailableChestCount = multi
                Tracker:FindObjectForCode("@Sapphire Board/Sapphire Board/Bonus Multiplier 75-99").AvailableChestCount =
                multi
            else
                Tracker:FindObjectForCode("@Ruby Board/Ruby Board/Bonus Multiplier 25-74").AvailableChestCount = multi
                Tracker:FindObjectForCode("@Sapphire Board/Sapphire Board/Bonus Multiplier 25-74").AvailableChestCount =
                multi
                return
            end
        else
            Tracker:FindObjectForCode("@Ruby Board/Ruby Board/Bonus Multiplier 10-24").AvailableChestCount = multi
            Tracker:FindObjectForCode("@Sapphire Board/Sapphire Board/Bonus Multiplier 10-24").AvailableChestCount =
            multi
            return
        end
    else
        Tracker:FindObjectForCode("@Ruby Board/Ruby Board/Bonus Multiplier 1-9").AvailableChestCount = multi
        Tracker:FindObjectForCode("@Sapphire Board/Sapphire Board/Bonus Multiplier 1-9").AvailableChestCount = multi
        return
    end
end

ScriptHost:AddWatchForCode("Set Multiplier", "multi", Multiplier)


function Upgrade()
    local multi = Tracker:ProviderCountForCode("upgrade")
    if multi > 9 then
        Tracker:FindObjectForCode("@Ruby Board/Ruby/Ball Upgrade 1-9").AvailableChestCount = 9
        Tracker:FindObjectForCode("@Sapphire Board/Sapphire/Ball Upgrade 1-9").AvailableChestCount = 9
        multi = multi - 9
        if multi > 14 then
            Tracker:FindObjectForCode("@Ruby Board/Ruby/Ball Upgrade 10-24").AvailableChestCount = 15
            Tracker:FindObjectForCode("@Sapphire Board/Sapphire/Ball Upgrade 10-24").AvailableChestCount = 15
            multi = multi - 15
            if multi > 49 then
                Tracker:FindObjectForCode("@Ruby Board/Ruby/Ball Upgrade 25-74").AvailableChestCount = 50
                Tracker:FindObjectForCode("@Sapphire Board/Sapphire/Ball Upgrade 25-74").AvailableChestCount = 50
                multi = multi - 50
                Tracker:FindObjectForCode("@Ruby Board/Ruby/Ball Upgrade 75-99").AvailableChestCount = multi
                Tracker:FindObjectForCode("@Sapphire Board/Sapphire/Ball Upgrade 75-99").AvailableChestCount = multi
            else
                Tracker:FindObjectForCode("@Ruby Board/Ruby/Ball Upgrade 25-74").AvailableChestCount = multi
                Tracker:FindObjectForCode("@Sapphire Board/Sapphire/Ball Upgrade 25-74").AvailableChestCount = multi
                return
            end
        else
            Tracker:FindObjectForCode("@Ruby Board/Ruby/Ball Upgrade 10-24").AvailableChestCount = multi
            Tracker:FindObjectForCode("@Sapphire Board/Sapphire/Ball Upgrade 10-24").AvailableChestCount = multi
            return
        end
    else
        Tracker:FindObjectForCode("@Ruby Board/Ruby/Ball Upgrade 1-9").AvailableChestCount = multi
        Tracker:FindObjectForCode("@Sapphire Board/Sapphire/Ball Upgrade 1-9").AvailableChestCount = multi
        return
    end
end

ScriptHost:AddWatchForCode("Set Ball Upgrade", "upgrade", Upgrade)
