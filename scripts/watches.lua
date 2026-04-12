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
            --print(",")
        end
    end
end

function Writing2()
    local pokemon = ""
    local area = ""
    local arrows = 0
    for index, value in pairs(SPECIES) do
        for i = 1, #value, 1 do
            arrows = arrows + 1
        end
    end
    print("pokemon count: ", arrows)
end

function Writing3(mon)

end

function Set()
    for i = 1, 70, 1 do
        local test = Pokemon[i]
        Tracker:FindObjectForCode(test).CurrentStage = 0
    end
end

--ScriptHost:AddWatchForCode("Writing", "write", Set)


function Set1()
    for i = 71, 140, 1 do
        --  local test = Pokemon[i]
        Tracker:FindObjectForCode(Pokemon[i]).CurrentStage = 1
    end
end

--ScriptHost:AddWatchForCode("Writing1", "write", Set1)
function Set2()
    for i = 141, 205, 1 do
        -- local test = Pokemon[i]
        Tracker:FindObjectForCode((Pokemon[i])).CurrentStage = 2
    end
end

--ScriptHost:AddWatchForCode("Writing2", "write", Set2)

function Highlighttest()
    Tracker:FindObjectForCode("@Ruby Board/Test (Ruby)/Species - Treecko").Highlight = Highlight.Priority
end

--ScriptHost:AddWatchForCode("Writing2", "write", Highlighttest)

function Total(code)
    local count = 0
    if code == "Total" then
        return
    end
    for index, value in ipairs(Pokemon) do
        --	print(value.."Got")
        if Caught(value) then
            count = count + 1
        end
        --print(count)
    end
    Tracker:FindObjectForCode("Total").AcquiredCount = count
end

ScriptHost:AddWatchForCode("Total", "Mon", Total)

function AreaPokemon(field)

end

function PokemonAreaR(area)
    if Has("ruby") then
        if Has(area) then
            for index, value in pairs(POKEMON_RUBY_AREA[area]) do
                if CanDo(value[1]) then
                    return
                else
                    if Tracker:FindObjectForCode("get").CurrentStage >= (value[2] - 2) then
                        if value[3] then
                            if (Has("ratecard") or Caught("Rayquaza")) then
                                Tracker:FindObjectForCode(value[1]).CurrentStage = 1
                            end
                        else
                            Tracker:FindObjectForCode(value[1]).CurrentStage = 1
                        end
                    end
                end
            end
        end
    end
end

function PokemonAreaS(area)
    if Has("sapphire") then
        if Has(area) then
            for index, value in pairs(POKEMON_SAPPHIRE_AREA[area]) do
                if CanDo(value[1]) then
                    return
                else
                    if Tracker:FindObjectForCode("get").CurrentStage >= (value[2] - 2) then
                        if value[3] then
                            if (Has("ratecard") or Caught("Rayquaza")) then
                                Tracker:FindObjectForCode(value[1]).CurrentStage = 1
                            end
                        else
                            Tracker:FindObjectForCode(value[1]).CurrentStage = 1
                        end
                    end
                end
            end
        end
    end
end

for index, value in pairs(AREA_NAMES) do
    ScriptHost:AddWatchForCode("Area " .. index, value, Evolve)
end

--ScriptHost:AddWatchForCode("Areax", "forestR", Evolve)

for index, value in pairs(AREA_NAMES_SAPPHIRE) do
    --    ScriptHost:AddWatchForCode("AreaS" .. index, value, Evolve)
end


--ScriptHost:AddWatchForCode("Ruby", "ruby", Evolve)

--ScriptHost:AddWatchForCode("Sapphire", "sapphire", Evolve)
function Evolve(trigger)
    for key, value in pairs(Pokemon) do
        local obj = Tracker:FindObjectForCode("@Pokemon/" .. value).AccessibilityLevel

        if Tracker:FindObjectForCode(value).MaxCount == 3 then
            Tracker:FindObjectForCode(value).CurrentStage = 2
        else
            if obj == AccessibilityLevel.Normal then
                Tracker:FindObjectForCode(value).CurrentStage = 1
            elseif obj == AccessibilityLevel.None then
                Tracker:FindObjectForCode(value).CurrentStage = 0
            end
        end
    end
end

for index, value in pairs(AREA_NAMES) do
    ScriptHost:AddWatchForCode("Area " .. index, value, Evolve)
end
--ScriptHost:AddWatchForCode("evo", "evo", Evolve)
--ScriptHost:AddWatchForCode("evo2", "startball", Evolve)
--ScriptHost:AddWatchForCode("evo3", "startcoins", Evolve)
--ScriptHost:AddWatchForCode("evo4", "perpichu", Evolve)







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
