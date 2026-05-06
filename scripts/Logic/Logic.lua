function Has(item)
	return Tracker:FindObjectForCode(item).Active
end

function toBits(num)
	-- returns a table of bits, least significant first.
	local t = {} -- will contain the bits
	local i = 1
	--local num2 = tonumber(num)
	--print(num2)
	while num > 0 do
		local rest = math.fmod(num, 2)
		if rest ~= 0 then
			--	 t[#t + 1] = "{"..i..","..rest.."}"
			table.insert(t, i)
		end
		num = (num - rest) / 2
		i = i + 1
	end
	return t
end

function CanPlayBasicPinball()
	return (Tracker:FindObjectForCode("startball").AcquiredCount >= 2 and Tracker:FindObjectForCode("startcoins").CurrentStage >= 1) or
		Tracker:FindObjectForCode("Difficulty").CurrentStage >= 1
end

function CanPlayModeratePinball()
	return (Tracker:FindObjectForCode("startball").AcquiredCount >= 3 and Tracker:FindObjectForCode("startcoins").CurrentStage >= 3) or
		(Tracker:FindObjectForCode("Difficulty").CurrentStage >= 2)
end

function CanPlayLongPinball()
	return (Tracker:FindObjectForCode("startball").AcquiredCount >= 5 and Tracker:FindObjectForCode("startcoins").CurrentStage >= 4 and Has("perpichu")) or
		Tracker:FindObjectForCode("Difficulty").CurrentStage >= 3
end

function HasAmount(item, num)
	return Tracker:FindObjectForCode(item).AcquiredCount >= num
end

function OoL2()
	return (Tracker:FindObjectForCode("OoL").CurrentStage == 1 and Tracker:FindObjectForCode("Difficulty").CurrentStage >= 1) or
		Tracker:FindObjectForCode("OoL").CurrentStage == 2
end

function OoL(dif)
	dif = tonumber(dif)
	return Tracker:FindObjectForCode("OoL").CurrentStage == 2 or
		(Tracker:FindObjectForCode("OoL").CurrentStage == 1 and (Tracker:FindObjectForCode("difficulty").CurrentStage + 1) == dif)
end

function CanEvolveRuby(mon)
	local obj = Tracker:FindObjectForCode("evo")
	local poke = POKEMON_EVO_RUBY[mon]
	local ool = OoL(1)
	if obj.CurrentStage == 3 then
		if Has(EVOLUTION_METHOD[poke[1]]) then
			if CanPlayBasicPinball() then
				if poke[3] then
					local evo = CanEvolveRuby(poke[2])
					if evo == AccessibilityLevel.SequenceBreak then
						if ool then
							return AccessibilityLevel.SequenceBreak
						end
					else
						return evo
					end
				else
					local catch = SpeciesRuby(poke[2])
					if catch == AccessibilityLevel.SequenceBreak then
						if ool then
							return catch
						end
					else
						return catch
					end
				end
			elseif ool then
				if poke[3] then
					local evo = CanEvolveRuby(poke[2])
					if evo >= AccessibilityLevel.SequenceBreak then
						return AccessibilityLevel.SequenceBreak
					end
				else
					local catch = SpeciesRuby(poke[2])
					if catch >= AccessibilityLevel.SequenceBreak then
						return AccessibilityLevel.SequenceBreak
					end
				end
			end
		end
	end
	return AccessibilityLevel.None
end

function CanEvolveSapphire(mon)
	local obj = Tracker:FindObjectForCode("evo")
	local poke = POKEMON_EVO_SAPPHIRE[mon]
	local ool = OoL(1)

	if obj.CurrentStage == 3 then
		if Has(EVOLUTION_METHOD[poke[1]]) then
			if CanPlayBasicPinball() then
				if poke[3] then
					local evo = CanEvolveSapphire(poke[2])
					if evo == AccessibilityLevel.SequenceBreak then
						if ool then
							return AccessibilityLevel.SequenceBreak
						end
					else
						return evo
					end
				else
					local catch = SpeciesSapphire(poke[2])
					if catch == AccessibilityLevel.SequenceBreak then
						if ool then
							return catch
						end
					else
						return catch
					end
				end
			elseif ool then
				if poke[3] then
					local evo = CanEvolveSapphire(poke[2])
					if evo >= AccessibilityLevel.SequenceBreak then
						return AccessibilityLevel.SequenceBreak
					end
				else
					local catch = SpeciesSapphire(poke[2])
					if catch >= AccessibilityLevel.SequenceBreak then
						return AccessibilityLevel.SequenceBreak
					end
				end
			end
		end
	elseif OoL(4) and Has("bonuszig") then
		if Has(EVOLUTION_METHOD[poke[1]]) then
			if poke[3] then
				if SpeciesSapphire(POKEMON_EVO_SAPPHIRE[poke[2]][2]) >= AccessibilityLevel.SequenceBreak then
					return AccessibilityLevel.SequenceBreak
				end
			else
				if SpeciesSapphire(poke[2]) >= AccessibilityLevel.SequenceBreak then
					return AccessibilityLevel.SequenceBreak
				end
			end
		end
	end
	return AccessibilityLevel.None
end

function CanEvolveEggRuby(mon)
	local obj = Tracker:FindObjectForCode("evo")
	local poke = POKEMON_EVO_RUBY_EGG[mon]
	local ool = OoL(1)
	if obj.CurrentStage == 3 then
		if Has(EVOLUTION_METHOD[poke[1]]) then
			if CanPlayBasicPinball() then
				if poke[3] then
					local evo = CanEvolveEggRuby(poke[2])
					if evo == AccessibilityLevel.SequenceBreak then
						if ool then
							return AccessibilityLevel.SequenceBreak
						end
					else
						return evo
					end
				else
					return AccessibilityLevel.Normal
				end
			elseif ool then
				if poke[3] then
					local evo = CanEvolveEggRuby(poke[2])
					if evo >= AccessibilityLevel.SequenceBreak then
						return AccessibilityLevel.SequenceBreak
					end
				else
					return AccessibilityLevel.SequenceBreak
				end
			end
		end
	end
	return AccessibilityLevel.None
end

function CanEvolveEggSapphire(mon)
	local obj = Tracker:FindObjectForCode("evo")
	local poke = POKEMON_EVO_SAPPHIRE_EGG[mon]
	local ool = OoL(1)
	if obj.CurrentStage == 3 then
		if Has(EVOLUTION_METHOD[poke[1]]) then
			if CanPlayBasicPinball() then
				if poke[3] then
					local evo = CanEvolveEggSapphire(poke[2])
					if evo == AccessibilityLevel.SequenceBreak then
						if ool then
							return AccessibilityLevel.SequenceBreak
						end
					else
						return evo
					end
				else
					return AccessibilityLevel.Normal
				end
			elseif ool then
				if poke[3] then
					local evo = CanEvolveEggSapphire(poke[2])
					if evo >= AccessibilityLevel.SequenceBreak then
						return AccessibilityLevel.SequenceBreak
					end
				else
					return AccessibilityLevel.SequenceBreak
				end
			end
		end
	elseif OoL(4) and Has("bonuszig") then
		if Has(EVOLUTION_METHOD[poke[1]]) then
			if poke[3] then
				if Has(EVOLUTION_METHOD[POKEMON_EVO_SAPPHIRE_EGG[poke[2]][1]]) then
					return AccessibilityLevel.SequenceBreak
				end
			else
				return AccessibilityLevel.SequenceBreak
			end
		end
	end
	return AccessibilityLevel.None
end

function Can(location)
	return Tracker:FindObjectForCode(location).AccessibilityLevel > 5
end

function Can2(location)
	return Tracker:FindObjectForCode(location).AccessibilityLevel == 6
end

function Can3(location)
	return Tracker:FindObjectForCode(location).AccessibilityLevel == 5
end

function CanEvo()
	return Tracker:FindObjectForCode("evo").CurrentStage == 3 and CanPlayModeratePinball()
end

function Caught(mon)
	return Tracker:FindObjectForCode(mon).CurrentStage == 2
end

function Caught2(mon)
	return Tracker:FindObjectForCode("@Pokemon//" .. mon).AccessibilityLevel == AccessibilityLevel.Cleared
end

function Caught3(mon)
	if Tracker:FindObjectForCode("@Pokemon//" .. mon).AccessibilityLevel == AccessibilityLevel.Cleared then
		return true
	elseif Tracker:FindObjectForCode("@Pokemon//" .. mon).AccessibilityLevel == AccessibilityLevel.Normal then
		return false
	end
	return nil
end

function Targets()
	for index, value in ipairs(TARGETS) do
		if POKEMON_INVERSE[value] ~= nil then
			if Tracker:FindObjectForCode("@Pokemon//" .. POKEMON_INVERSE[value]).AccessibilityLevel < AccessibilityLevel.Normal then
				return false
			end
		end
	end
	return true
end

function CanCatchSpecial2()
	if HasAmount("Total", 100) then
		if (Caught("Rayquaza") or Has("ratecard")) then
			if CanPlayLongPinball() then
				return AccessibilityLevel.Normal
			elseif OoL(3) then
				return AccessibilityLevel.SequenceBreak
			end
		elseif OoL(4) then
			return AccessibilityLevel.SequenceBreak
		end
	end
	return AccessibilityLevel.None
end

function CanCatchPichu()
	if Caught("Rayquaza") or Has("ratecard") then
		if CanPlayLongPinball() then
			return AccessibilityLevel.Normal
		elseif OoL(3) then
			return AccessibilityLevel.SequenceBreak
		end
	else
		if OoL(4) then
			return AccessibilityLevel.SequenceBreak
		end
	end
	return AccessibilityLevel.None
end

function SpeciesRuby(mon)
	local species = POKEMON_RUBY[mon]
	if Tracker:FindObjectForCode("get").CurrentStage >= (species[1] - 2) then
		if species[2] then
			if (Has("ratecard") or Caught("Rayquaza")) then
				return AccessibilityLevel.Normal
			elseif OoL(4) then
				return AccessibilityLevel.SequenceBreak
			end
		else
			return AccessibilityLevel.Normal
		end
	end
	return AccessibilityLevel.None
end

function SpeciesSapphire(mon)
	local species = POKEMON_SAPPHIRE[mon]
	if Tracker:FindObjectForCode("get").CurrentStage >= (species[1] - 2) then
		if species[2] then
			if (Has("ratecard") or Caught("Rayquaza")) then
				return AccessibilityLevel.Normal
			elseif OoL(4) then
				return AccessibilityLevel.SequenceBreak
			end
		else
			return AccessibilityLevel.Normal
		end
	end
	return AccessibilityLevel.None
end

function GoalCheck()
	local dex = 0
	local targets = 0
	local score = 0
	if #GOALS > 0 then
		for index, value in ipairs(GOALS) do
			if value == "Pokedex" then
				if (Tracker:ProviderCountForCode("Total") + Tracker:ProviderCountForCode("CanTotal")) >=
					Tracker:ProviderCountForCode("pokedex") then
					dex = 1
				end
			elseif value == "Targets" then
				if Targets() then
					targets = 1
				end
			elseif value == "Score" then
				local amount = Tracker:ProviderCountForCode("score")
				if amount < 50000 then
					score = 1
				elseif amount < 250000 and CanPlayBasicPinball() then
					score = 1
				elseif amount < 750000 and CanPlayModeratePinball() then
					score = 1
				elseif CanPlayLongPinball() then
					score = 1
				end
			end
		end
		if (dex + targets + score) == #GOALS then
			Tracker:FindObjectForCode("gomode").Active = true
		else
			Tracker:FindObjectForCode("gomode").Active = false
		end
	end
end
