local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local function NearestValue(table, number)
    local smallestSoFar, smallestIndex
    for i, y in ipairs(table) do
        if not smallestSoFar or (math.abs(number-y.chance) < smallestSoFar) then
            smallestSoFar = math.abs(number-y.chance)
            smallestIndex = i
        end
    end
    return smallestIndex, table[smallestIndex]
end

-----------------------------------------------------------
--[[ Callbacks ]]--
-----------------------------------------------------------

exports.tpz_core:getCoreAPI().addNewCallBack("tpz_mining:callbacks:getFoundRewardData", function(source, cb, city)

	local rewards  = {}
    local chance   =  math.random(1, 100)
	local finished = false
	local added    = false

	for k,v in pairs(Config.Items[city]) do 
		
		if v.chance >= chance then
			table.insert(rewards, v)
			added = true
		end

		if next(Config.Items[city], k) == nil then
			finished = true
		end
	end

	while not finished do
		Wait(10)
	end

	if added then
		chance = math.random(1, 100)
		local index, value = NearestValue(rewards, chance)
		cb(value)
	else

		cb({item = "n/a", difficulties = {first = "easy", second = "easy"} })
	end

end)