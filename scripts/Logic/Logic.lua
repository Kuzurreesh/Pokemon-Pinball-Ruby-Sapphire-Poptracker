function Has(item)
	return Tracker:FindObjectForCode(item).Active
end

function Caught(item)
	if Tracker:FindObjectForCode(item).CurrentStage == 2 then
		return true
	else
		return false
	end
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

function Total(code)
	ScriptHost:RemoveWatchForCode("Total")
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


	ScriptHost:AddWatchForCode("Total", "*", Total)
end

ScriptHost:AddWatchForCode("Total", "*", Total)
