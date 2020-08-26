SafeArmory = LibStub("AceAddon-3.0"):NewAddon("SafeArmory", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("SafeArmory", true)
local Sa = SafeArmory

Sa.L = L
Sa.ADDON_NAME = "SafeArmory"

local json = LibStub("json.lua")
local LibCopyPaste = LibStub("LibCopyPaste-1.0")
local LibDeflate = LibStub("LibDeflate")
local AceDB = LibStub("AceDB-3.0")

Sa.ldb = LibStub("LibDataBroker-1.1"):NewDataObject(Sa.ADDON_NAME, {
	type = "launcher",
	text = "Safe Armory",
	icon = "Interface\\AddOns\\" .. Sa.ADDON_NAME .. "\\images\\icon",
	OnClick = function(self, button, down)
		if button == "LeftButton" then
			Sa:Collect()
		elseif button == "RightButton" then	
			Sa:Collect()				
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine(Sa.L.title , 1, 1, 1);
		tt:AddLine(Sa.L.notice);
		tt:AddLine(Sa.L.click)
	end	
})
Sa.icon = LibStub("LibDBIcon-1.0")

local defaultDB = {
	profile = {
		minimap = {                
			hide = false,
			minimapPos = 142,
		},
	},
}

function Sa:OnInitialize()

	SafeArmoryData = {
		data = nil,
		count = nil
	}	

	self.db = AceDB:New("SafeArmoryDB", defaultDB, true)
	Sa.icon:Register(Sa.ADDON_NAME, Sa.ldb, self.db.profile.minimap)
end


function Sa:Collect()

	Sa.dataCount = 0

	local data = Sa:GetAllData()
	local count = Sa:CountData()
	local comressedData = Sa:CompressData(Sa:ToJSON(data))

	Sa:Copy(comressedData)

	SafeArmoryData = {
		data = comressedData,
		count = count
	}	

end

function Sa:ToJSON(collection)

	local data = json.encode(collection)
	return data

end

function Sa:CompressData(collection)

	collection = LibDeflate:CompressDeflate(collection)
	collection = LibDeflate:EncodeForPrint(collection)

	return collection

end
function Sa:Copy(text)

	LibCopyPaste:Copy("SafeArmory", text)

end

function Sa:SlashCommand(msg)

	Sa:Collect()

end

Sa:RegisterChatCommand("safearmory", "SlashCommand")
Sa:RegisterChatCommand("sa", "SlashCommand")

print(L.title);
print(L.welcome);
print(L.notice);