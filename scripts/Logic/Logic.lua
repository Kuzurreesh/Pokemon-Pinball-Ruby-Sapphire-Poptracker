function Has(item)
	return Tracker:FindObjectForCode(item).Active
end

function HasAmount(item, num)
	return Tracker:FindObjectForCode(item).AcquiredCount >= num
end

function Can(location)
	if Tracker:FindObjectForCode(location).AccessibilityLevel > 5 then
		return true
	else
		return false
	end
end

function Can2(location)
	if Tracker:FindObjectForCode(location).AccessibilityLevel == 6 then
		return true
	else
		return false
	end
end

function Can3(location)
	if Tracker:FindObjectForCode(location).AccessibilityLevel == 5 then
		return true
	else
		return false
	end
end

function CanPlayBasicPinball()
	if Tracker:FindObjectForCode("startball").AcquiredCount >= 2 and Tracker:FindObjectForCode("startcoins").CurrentStage >= 1 then
		return true
	else
		return false
	end
end

function CanPlayModeratePinball()
	if Tracker:FindObjectForCode("startball").AcquiredCount >= 3 and Tracker:FindObjectForCode("startcoins").CurrentStage >= 3 then
		return true
	else
		return false
	end
end

function CanPlayLongPinball()
	if Tracker:FindObjectForCode("startball").AcquiredCount >= 5 and Tracker:FindObjectForCode("startcoins").CurrentStage >= 4 and Has("perpichu") then
		return true
	else
		return false
	end
end

function CanEvo()
	if Tracker:FindObjectForCode("evo").CurrentStage == 3 and CanPlayModeratePinball() then
		Tracker:FindObjectForCode("evo").BadgeText = "V"
		
		return true
	else
		Tracker:FindObjectForCode("evo").BadgeText = ""
		return false
	end
end

function CanDo(mon)
	return Tracker:FindObjectForCode(mon).CurrentStage > 1
end

function CanCatch(mon)
	if Tracker:FindObjectForCode(mon).CurrentStage == 1 then
		return true
	else
		return false
	end
end

function Caught(mon)
	if Tracker:FindObjectForCode(mon).CurrentStage == 2 then
		return true
	else
		return false
	end
end

function CanCatchSpecial()
	return CanPlayLongPinball() and (Caught("Rayquaza") or Has("ratecard")) and HasAmount("Total", 100)
end

function CanCatchPichu()
	return CanPlayLongPinball() and (Caught("Rayquaza") or Has("ratecard")) 
end

function SpeciesRuby(mon)
	local species = POKEMON_RUBY[mon]
	if Tracker:FindObjectForCode("get").CurrentStage >= (species[1] - 2) then
		if species[2] then
			if (Has("ratecard") or Caught("Rayquaza")) then
				return true
				--else
				--	return false
			end
		else
			return true
		end
		--else
		--	return false
	end
	return false
end

function SpeciesSapphire(mon)
	local species = POKEMON_SAPPHIRE[mon]
	if Tracker:FindObjectForCode("get").CurrentStage >= (species[1] - 2) then
		if species[2] then
			if (Has("ratecard") or Caught("Rayquaza")) then
				return true
				--	else
				--		return false
			end
		else
			return true
		end
		--else
		--	return false
	end
	return false
end