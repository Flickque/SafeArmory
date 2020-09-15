local Sa = SafeArmory
local L = Sa.L
Sa.fnc = {}
Sa.dataCount = 0

if not Sa then return end 

----------------------------------------------------------------------------
---- Constants
--

Sa.classID = {
    ["NONE"] = 0,
    ["WARRIOR"] = 1,
    ["PALADIN"] = 2,
    ["HUNTER"] = 3,
    ["ROGUE"] = 4,
    ["PRIEST"] = 5,
    ["DEATHKNIGHT"] = 6,
    ["SHAMAN"] = 7,
    ["MAGE"] = 8,
    ["WARLOCK"] = 9,
    ["MONK"] = 10,
    ["DRUID"] = 11,
	["DEMONHUNTER"] = 12,
}

Sa.raceID = {
	["None"] = 0,
	["Human"] = 1,
	["Orc"] = 2,
	["Dwarf"] = 3,
	["NightElf"] = 4,
	["Undead"] = 5,
	["Tauren"] = 6,
	["Gnome"] = 7,
	["Troll"] = 8,
	["Goblin"] = 9,
	["BloodElf"] = 10,
	["Draenei"] = 11,
	["Worgen"] = 2,
	["Pandaren"] = 23,
	["Nightborne"] = 27,
	["HighmountainTauren"] = 28,
	["VoidElf"] = 29,
	["LightforgedDraenei"] = 30,
	["ZandalariTroll"] = 31,
	["KulTiran"] = 32,
	["DarkIronDwarf"] = 34,
	["Vulpera"] = 35,
	["MagharOrc"] = 36,
	["Mechagnome"] = 37
}

local kek = {
	head = {

	}
}
Sa.categories = {
	[1] = {
		name = "head",
		type = "body"
	},
	[2] = {
		name = "shoulder",
		type = "body"
	},
	[3] = {
		name = "back",
		type = "body"
	},
	[4] = {
		name = "chest",
		type = "body"
	},
	[5] = {
		name = "shirt",
		type = "body"
	},
	[6] = {
		name = "tabard",
		type = "body"
	},
	[7] = {
		name = "wrist",
		type = "body"
	},
	[8] = {
		name = "hands",
		type = "body"
	},
	[9] = {
		name = "waist",
		type = "body"
	},
	[10] = {
		name = "legs",
		type = "body"
	},
	[11] = {
		name = "feet",
		type = "body"
	},
	[12] = {
		name = "wands",
		type = "body"
	},
	[13] = {
		name = "oneHandedAxes",
		type = "offHand"
	},
	[14] = {
		name = "oneHandedSwords",
		type = "offHand"
	},
	[15] = {
		name = "oneHandedMaces",
		type = "offHand"
	},
	[16] = {
		name = "daggers",
		type = "offHand"
	},
	[17] = {
		name = "fistWeapons",
		type = "offHand"
	},
	[18] = {
		name = "shields",
		type = "offHand"
	},
	[19] = {
		name = "heldInOffHand",
		type = "offHand"
	},
	[20] = {
		name = "twoHandedAxes",
		type = "mainHand"
	},
	[21] = {
		name = "twoHandedSwords",
		type = "mainHand"
	},
	[22] = {
		name = "twoHandedMaces",
		type = "mainHand"
	},
	[23] = {
		name = "staves",
		type = "mainHand"
	},
	[24] = {
		name = "polearms",
		type = "mainHand"
	},
	[25] = {
		name = "bows",
		type = "mainHand"
	},
	[26] = {
		name = "guns",
		type = "mainHand"
	},
	[27] = {
		name = "crossbows",
		type = "mainHand"
	},
	[28] = {
		name = "warglaives",
		type = "mainHand"
	},
	[29] = {
		name = "legionArtifacts",
		type = "mainHand"
	}
}

Sa.EquipIds = { 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 }

----------------------------------------------------------------------------
---- Utils
--

local function dump(t)

	if type(t) == 'table' then
	   local s = '{ '
	   for k,v in pairs(t) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(t)
	end

end

local function tableCount(t)

	if type(t) == 'table' then
	   for k,v in pairs(t) do
		  Sa.dataCount = Sa.dataCount + 1
		  tableCount(v)
	   end	   
	else
	   return tostring(t)
	end

	return tostring(Sa.dataCount)

end

function isEmpty(s)

  return s == nil or s == ''

end

function Sa.fnc:x(b)
	return GetContainerNumSlots(b)
end

function Sa.fnc:y(b,s)
	return Item:CreateFromBagAndSlot(b,s)
end

function Sa.fnc:_z(v)
	if v then
		return v:IsItemEmpty()
	else
		return nil
	end
end

function Sa.fnc:idg(v)
	if v then
		return v:GetItemID()
	else
		return nil
	end	
end

function Sa.fnc:s_bn()
	return NUM_BAG_SLOTS
end

function Sa.fnc:s_bbn()
	return NUM_BANKBAGSLOTS
end

function Sa.fnc:s_v(o,t)
	return GetVoidItemInfo(o,t)
end


----------------------------------------------------------------------------
---- Character Data
--

function Sa:GetPlayerData()

	local data = {}
	local _, clsEn = UnitClass("player")
	local _, raceEn = UnitRace("player")
	
	data.name = UnitName("player")
	data.realm = GetRealmName()
	data.level = UnitLevel("player")
	data.Faction = UnitFactionGroup("player")
	data.achievements = AreAccountAchievementsHidden()
	data.spec = GetSpecialization()
	data.guid =  UnitGUID("player")
	data.gender = UnitSex("player")-1
	data.classID = Sa.classID[clsEn]
    data.raceID = Sa.raceID[raceEn]
    data.raceEng = raceEn

    return data

end

----------------------------------------------------------------------------
---- Items
--

local function ReadAzeritePowers(loc)

	local ret = {}
	local hasSome = false
	
	local tiers = C_AzeriteEmpoweredItem.GetAllTierInfo(loc)
	for tier, tierInfo in ipairs(tiers) do
		for _, power in ipairs(tierInfo.azeritePowerIDs) do
			if C_AzeriteEmpoweredItem.IsPowerSelected(loc, power) then
				local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(power)
				table.insert(ret, powerInfo.spellID)
				hasSome = true
			end
		end
	end

	if hasSome then
		return ret
	else
		return nil
	end

end

local tooltip
local function GetTooltip()

	if not tooltip then
		tooltip = CreateFrame("GameTooltip", "SaScanningTooltip", nil, "GameTooltipTemplate")
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end

	return tooltip

end

local function GetItemTooltip(bagId, slotId, link)

	local tooltip = GetTooltip()

	tooltip:ClearLines()
	if bagId then
		tooltip:SetBagItem(bagId, slotId)
	elseif slotId then
		tooltip:SetInventoryItem("player", slotId)
	else
		tooltip:SetHyperlink(link)
	end

	return tooltip

end

local function GetItemLevel(bagId, slotId, link)	

	local itemLevelPattern = _G["ITEM_LEVEL"]:gsub("%%d", "(%%d+)")
	local tooltipItem = GetItemTooltip(bagId, slotId, link)
	
	local regions = { tooltipItem:GetRegions() }
	for i, region in ipairs(regions) do
		if region and region:GetObjectType() == "FontString" then
			local text = region:GetText()
			if text then
				ilvl = tonumber(text:match(itemLevelPattern))
				if ilvl then
					return ilvl
				end
			end
        end	
	end
	
	return 0

end

local function readBonusIdList(parts, first, last)

	local ret = {}	

	for i = first, last do
		table.insert(ret, tonumber(parts[i]))
	end
	table.sort(ret)

	return ret

end

local function ParseItemLink(itemLink)

    if not itemLink then return nil end
    
   	local str = string.match(itemLink, "|Hitem:([\-%d:]+)|")

    if not str then return nil end
    
    local parts = { strsplit(":", str) }    
	local item = {}

    item.id = tonumber(parts[1]) or 0
    item.count = GetItemCount(item.id, false, false)    
    item.isItemEquippable = IsEquippableItem(itemLink)
	
	if item.isItemEquippable then   
		item.enchantId = tonumber(parts[2]) or 0
   		item.gemIds = { tonumber(parts[3]) or 0, tonumber(parts[4]) or 0, tonumber(parts[5]) or 0, tonumber(parts[6]) or 0 }

	    local numBonuses = tonumber(parts[13]) or 0
		local offset = numBonuses
	    if numBonuses > 0 then
	        item.bonusIds = readBonusIdList(parts, 14, 13 + numBonuses)
    	else
    		item.bonusIds = {}
	    end
		
		if #parts > 16 + offset then
			item.relicBonusIds = { nil, nil, nil }
			numBonuses = tonumber(parts[16 + offset])
			if numBonuses then
				if numBonuses > 0 then
					item.relicBonusIds[1] = readBonusIdList(parts, 17 + offset, 16 + offset + numBonuses)
				end					
				offset = offset + numBonuses
				if #parts > 17 + offset then
					numBonuses = tonumber(parts[17 + offset])
					if numBonuses then
						if numBonuses > 0 then
							item.relicBonusIds[2] = readBonusIdList(parts, 18 + offset, 17 + offset + numBonuses)
						end
						offset= offset + numBonuses
						if #parts > 18 + offset then
							numBonuses = tonumber(parts[18 + offset])
							if numBonuses then
								if numBonuses > 0 then
									item.relicBonusIds[3] = readBonusIdList(parts, 19 + offset, 18 + offset + numBonuses)
								end	
							end
						end
					end
				end
			end
		end
	end
	
    return item

end

local function GetBagItems()

	local bag = 0
	local slots = GetContainerNumSlots(bag)
	local slot = 1
	local location = ItemLocation.CreateEmpty()
	return function()
		while bag < 5 do
			local item = Item:CreateFromBagAndSlot(bag, slot)
			local _, _, _, _, _, _, itemLink = GetContainerItemInfo(bag, slot)			
			if itemLink ~= nil  then
				item.data = ParseItemLink(itemLink)	
				isItemEquippable = IsEquippableItem(itemLink)
				if item.data ~= nil and isItemEquippable then
					item.data.ilvl = GetItemLevel(bag, slot, link) 
					location:SetBagAndSlot(bag, slot)
					if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(location) then
						local powers = ReadAzeritePowers(location)
						if powers then
							item.data.azerite = powers
						else
							item.data.azerite = "undefined"
						end
					end
	            end
			end
			slot = slot + 1
			if slot > slots then
				bag = bag + 1
				slot = 1
				slots = GetContainerNumSlots(bag)
			end
			if not item:IsItemEmpty() then
				return item
			end
		end
	end

end

local function GetBankItems()

	local bag = -1
	local slots = GetContainerNumSlots(bag)
	local slot = 1
	local location = ItemLocation.CreateEmpty()
	return function()
		while bag <= (NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) do
			local item = Item:CreateFromBagAndSlot(bag, slot)
			local _, itemCount, _, _, _, _, itemLink = GetContainerItemInfo(bag, slot)		
			if itemLink ~= nil  then
				item.data = ParseItemLink(itemLink)	
				isItemEquippable = IsEquippableItem(itemLink)
				if item.data ~= nil and isItemEquippable then
					item.data.ilvl = GetItemLevel(bag, slot, link) 
					location:SetBagAndSlot(bag, slot)
					if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(location) then
						local powers = ReadAzeritePowers(location)
						if powers then
							item.data.azerite = powers
						else
							item.data.azerite = "undefined"
						end
					end
	            end
			end
			slot = slot + 1
			if slot > slots then
				if bag == -1 then
					bag = NUM_BAG_SLOTS + 1
				else
					bag = bag + 1
				end
				slot = 1
				slots = GetContainerNumSlots(bag)
			end
			if not item:IsItemEmpty() then
				item.count = itemCount
				return item
			end
		end
	end

end

----------------------------------------------------------------------------
---- Bag items
--

function Sa:GetBagItemsData()

	local items = {}
	local collectedItems = {}

	for item in GetBagItems() do
		local id = item:GetItemID()	
		if not collectedItems[id] then
			collectedItems[id] = true	
			table.insert(items, item.data)
		end		
	end
	return items

end

----------------------------------------------------------------------------
---- Bank items
--


function Sa:GetBankItemsData()

	local items = {}
	local collectedItems = {}

	for item in GetBankItems() do
		local id = item:GetItemID()	
		if not collectedItems[id] then
			collectedItems[id] = {
				count = 1,
				itemsID = #items + 1
			}
			if item.data then
				item.data.count = item.count
			end	
			items[#items + 1] = item.data
		else
			collectedItems[id].count = collectedItems[id].count + 1
			if items[collectedItems[id].itemsID] then
				items[collectedItems[id].itemsID].count = item.count + items[collectedItems[id].itemsID].count
			end
		end
	end

	return items

end

function Sa:GetBankItemsDataOld()

	local items = {}
	local collectedItems = {}

	for item in GetBankItems() do
		local id = item:GetItemID()	
		if not collectedItems[id] then	
			collectedItems[id] = true
			table.insert(items, item)
		end
	end

	return items

end



----------------------------------------------------------------------------
---- Toys
--

function Sa:SetToyList()

    C_ToyBox.SetAllSourceTypeFilters(true);
    C_ToyBox.SetCollectedShown(true);
    C_ToyBox.SetUncollectedShown(false);
    C_ToyBox.SetUnusableShown(true);
    C_ToyBox.SetFilterString("");

    local NumToys = C_ToyBox.GetNumToys();
    local toyList = {};
    for idx = NumToys, 1, -1 do
    	local itemID = C_ToyBox.GetToyFromIndex(idx)
        if itemID ~= -1 then
            table.insert(toyList, itemID)
        end
    end
    return toyList
end


function Sa:GetToysData()
    collectedToyList = {}
    for i, itemID in pairs(Sa:SetToyList()) do
        if PlayerHasToy(itemID) then
            table.insert(collectedToyList, itemID)
        end
    end
    return collectedToyList
end

----------------------------------------------------------------------------
---- Void Storage
--

function Sa:GetVoidStorageData()

	local collection = {}
	local data = {}
	slot = 1
	slots = 160
	while slot <= slots do
		if not isEmpty(GetVoidItemInfo(1, slot)) then
			local itemId = GetVoidItemInfo(1,slot)
			local itemLink = GetVoidItemHyperlinkString(slot);
			data = ParseItemLink(itemLink)
			data.count = GetItemCount(itemLink, true, false) + 1
			data.ilvl = "undefined"
			collection[#collection+1] = data
		end
		slot = slot+1
	end
	return collection

end

----------------------------------------------------------------------------
---- Trasmogrifications
--

function Sa:GetTransmogData()	

	local collection = {
		illusions = {},
		gear = {
			body = {},
			offHand = {},
			mainHand = {}
		},
		sets = {},
	}

	----------------------------------------------------------------------------
	-- Illusions
	--

	local illusions = collection.illusions
	for _, illusion in ipairs(C_TransmogCollection.GetIllusions()) do
		if illusion.isCollected then
			local _, name = C_TransmogCollection.GetIllusionSourceInfo(illusion.sourceID)
			illusions[#illusions+1] = {
				visualID = illusion.visualID,
				sourceID = illusion.sourceID
			}
		end
	end

	----------------------------------------------------------------------------
	-- Sets
	--

	local sets =  C_TransmogSets.GetAllSets()
	local j = 1;
	for i=1, #sets, 1 do	
		if (sets[i]['collected']==true) then					
			collection.sets[j] = sets[i].setID
			j = j + 1;
		end
	end

	----------------------------------------------------------------------------
	-- Gear
	--

	for id, category in next, Sa.categories do 
		local visuals = C_TransmogCollection.GetCategoryAppearances(id)				
		local transmog = {}
		collection.gear[category.type][category.name] = transmog
		for _, visual in ipairs(visuals) do  
			if visual.isCollected then 
				local collectedSources = {}
				local sources = C_TransmogCollection.GetAppearanceSources(visual.visualID)
				for _, source in ipairs(sources) do 
					if source.isCollected then
						table.insert(collectedSources, source.itemID)
					end
				end			
				transmog[#transmog + 1] = {
					visualID = visual.visualID,
					sources = collectedSources,
					type = category.type
				}				
			end
		end
		collection.gear[category.type][category.name] = transmog
	end  	
	return collection

end

----------------------------------------------------------------------------
---- Equip
--

function Sa:GetEquippedItemsData()

	local items = {};
	local loc = ItemLocation.CreateEmpty()

	for slotNum = 1, #Sa.EquipIds do
		local slotId = Sa.EquipIds[slotNum]
		local itemLink = GetInventoryItemLink("player", slotId)
		if itemLink ~= nil then
			local itemData = ParseItemLink(itemLink)
			if itemData ~= nil then
				loc:SetEquipmentSlot(slotId)
				if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(loc) then
					local powers = ReadAzeritePowers(loc)
					if powers then
						itemData.azerite = powers
					else
						item.data.azerite = "undefined"
					end
				end
				table.insert(items, itemData)
			end
		end
	end
    
	return items

end

----------------------------------------------------------------------------
---- Export data
--

function Sa:GetBagBankVoidCounts()

	local counts = {
		bag = #Sa:GetBagItemsData(), 
		bank = #Sa:GetBankItemsDataOld(), 
		void = #Sa:GetVoidStorageData()
	}
	return counts

end

function Sa:GetAllData()

	local data = {}

	data['toys'] = Sa:GetToysData()
	data['transmog'] = Sa:GetTransmogData()
	data['void'] = Sa:GetVoidStorageData()
	data['bag'] = Sa:GetBagItemsData()
	data['bank'] = Sa:GetBankItemsData()	
	data['info'] = Sa:GetPlayerData()
	data['security'] = Sa:Security()
	data['counts'] = Sa:GetBagBankVoidCounts()


	return data

end

function Sa:CountData(data)

	return tableCount(data)

end

