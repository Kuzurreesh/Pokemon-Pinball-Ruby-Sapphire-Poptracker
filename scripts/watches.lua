function Writing()
    local pokemon = ""
    local area = ""
    local arrows = 0
    for index, value in ipairs(AREAS) do
        area = AREA_NAMES[index]
        for i, v in ipairs(value) do
            pokemon = PokemonZero[v[1]]
            arrows = v[2]
            print(v[1]+1 .. "," .. pokemon .. "," .. area .. "," .. arrows)
            --print(",")
        end
    end
end
--ScriptHost:AddWatchForCode("writing", "write", Writing)

function Set()
    
    for i = 1, 70, 1 do
        local test = Pokemon[i]
        Tracker:FindObjectForCode(test).CurrentStage = 0
    end
end

function Set1()
     for i = 71, 140, 1 do
      --  local test = Pokemon[i]
        Tracker:FindObjectForCode(Pokemon[i]).CurrentStage = 1
    end
end

function Set2()
    for i = 141, 205, 1 do
       -- local test = Pokemon[i]
        Tracker:FindObjectForCode((Pokemon[i])).CurrentStage = 2
    end
end
