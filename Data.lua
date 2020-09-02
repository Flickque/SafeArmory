local a=SafeArmory;local b=a.L;a.fnc={}a.dataCount=0;if not a then return end;a.classID={["NONE"]=0,["WARRIOR"]=1,["PALADIN"]=2,["HUNTER"]=3,["ROGUE"]=4,["PRIEST"]=5,["DEATHKNIGHT"]=6,["SHAMAN"]=7,["MAGE"]=8,["WARLOCK"]=9,["MONK"]=10,["DRUID"]=11,["DEMONHUNTER"]=12}a.raceID={["None"]=0,["Human"]=1,["Orc"]=2,["Dwarf"]=3,["NightElf"]=4,["Undead"]=5,["Tauren"]=6,["Gnome"]=7,["Troll"]=8,["Goblin"]=9,["BloodElf"]=10,["Draenei"]=11,["Worgen"]=2,["Pandaren"]=23,["Nightborne"]=27,["HighmountainTauren"]=28,["VoidElf"]=29,["LightforgedDraenei"]=30,["ZandalariTroll"]=31,["KulTiran"]=32,["DarkIronDwarf"]=34,["Vulpera"]=35,["MagharOrc"]=36,["Mechagnome"]=37}local c={head={}}a.categories={[1]={name="head",type="body"},[2]={name="shoulder",type="body"},[3]={name="back",type="body"},[4]={name="chest",type="body"},[5]={name="shirt",type="body"},[6]={name="tabard",type="body"},[7]={name="wrist",type="body"},[8]={name="hands",type="body"},[9]={name="waist",type="body"},[10]={name="legs",type="body"},[11]={name="feet",type="body"},[12]={name="wands",type="body"},[13]={name="oneHandedAxes",type="offHand"},[14]={name="oneHandedSwords",type="offHand"},[15]={name="oneHandedMaces",type="offHand"},[16]={name="daggers",type="offHand"},[17]={name="fistWeapons",type="offHand"},[18]={name="shields",type="offHand"},[19]={name="heldInOffHand",type="offHand"},[20]={name="twoHandedAxes",type="mainHand"},[21]={name="twoHandedSwords",type="mainHand"},[22]={name="twoHandedMaces",type="mainHand"},[23]={name="staves",type="mainHand"},[24]={name="polearms",type="mainHand"},[25]={name="bows",type="mainHand"},[26]={name="guns",type="mainHand"},[27]={name="crossbows",type="mainHand"},[28]={name="warglaives",type="mainHand"},[29]={name="legionArtifacts",type="mainHand"}}a.EquipIds={1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17}local function d(e)if type(e)=='table'then local f='{ 'for g,h in pairs(e)do if type(g)~='number'then g='"'..g..'"'end;f=f..'['..g..'] = '..d(h)..','end;return f..'} 'else return tostring(e)end end;local function i(e)if type(e)=='table'then for g,h in pairs(e)do a.dataCount=a.dataCount+1;i(h)end else return tostring(e)end;return tostring(a.dataCount)end;function isEmpty(f)return f==nil or f==''end;function a.fnc:x(j)return GetContainerNumSlots(j)end;function a.fnc:y(j,f)return Item:CreateFromBagAndSlot(j,f)end;function a.fnc:_z(h)if h then return h:IsItemEmpty()else return nil end end;function a.fnc:idg(h)if h then return h:GetItemID()else return nil end end;function a.fnc:s_bn()return NUM_BAG_SLOTS end;function a.fnc:s_bbn()return NUM_BANKBAGSLOTS end;function a.fnc:s_v(k,e)return GetVoidItemInfo(k,e)end;function a:GetPlayerData()local l={}local m,n=UnitClass("player")local m,o=UnitRace("player")l.name=UnitName("player")l.realm=GetRealmName()l.level=UnitLevel("player")l.Faction=UnitFactionGroup("player")l.achievements=AreAccountAchievementsHidden()l.spec=GetSpecialization()l.guid=UnitGUID("player")l.gender=UnitSex("player")-1;l.classID=a.classID[n]l.raceID=a.raceID[o]return l end;local function p(q)local r={}local s=false;local t=C_AzeriteEmpoweredItem.GetAllTierInfo(q)for u,v in ipairs(t)do for m,w in ipairs(v.azeritePowerIDs)do if C_AzeriteEmpoweredItem.IsPowerSelected(q,w)then local x=C_AzeriteEmpoweredItem.GetPowerInfo(w)table.insert(r,x.spellID)s=true end end end;if s then return r else return nil end end;local y;local function z()if not y then y=CreateFrame("GameTooltip","SaScanningTooltip",nil,"GameTooltipTemplate")y:SetOwner(UIParent,"ANCHOR_NONE")end;return y end;local function A(B,C,link)local y=z()y:ClearLines()if B then y:SetBagItem(B,C)elseif C then y:SetInventoryItem("player",C)else y:SetHyperlink(link)end;return y end;local function D(B,C,link)local E=_G["ITEM_LEVEL"]:gsub("%%d","(%%d+)")local F=A(B,C,link)local G={F:GetRegions()}for H,I in ipairs(G)do if I and I:GetObjectType()=="FontString"then local J=I:GetText()if J then ilvl=tonumber(J:match(E))if ilvl then return ilvl end end end end;return 0 end;local function K(L,M,N)local r={}for H=M,N do table.insert(r,tonumber(L[H]))end;table.sort(r)return r end;local function O(P)if not P then return nil end;local Q=string.match(P,"|Hitem:([\-%d:]+)|")if not Q then return nil end;local L={strsplit(":",Q)}local item={}item.id=tonumber(L[1])or 0;item.count=GetItemCount(item.id,false,false)item.isItemEquippable=IsEquippableItem(P)if item.isItemEquippable then item.enchantId=tonumber(L[2])or 0;item.gemIds={tonumber(L[3])or 0,tonumber(L[4])or 0,tonumber(L[5])or 0,tonumber(L[6])or 0}local R=tonumber(L[13])or 0;local S=R;if R>0 then item.bonusIds=K(L,14,13+R)else item.bonusIds={}end;if#L>16+S then item.relicBonusIds={nil,nil,nil}R=tonumber(L[16+S])if R then if R>0 then item.relicBonusIds[1]=K(L,17+S,16+S+R)end;S=S+R;if#L>17+S then R=tonumber(L[17+S])if R then if R>0 then item.relicBonusIds[2]=K(L,18+S,17+S+R)end;S=S+R;if#L>18+S then R=tonumber(L[18+S])if R then if R>0 then item.relicBonusIds[3]=K(L,19+S,18+S+R)end end end end end end end end;return item end;local function T()local U=0;local slots=GetContainerNumSlots(U)local slot=1;local V=ItemLocation.CreateEmpty()return function()while U<5 do local item=Item:CreateFromBagAndSlot(U,slot)local m,m,m,m,m,m,P=GetContainerItemInfo(U,slot)if P~=nil then item.data=O(P)isItemEquippable=IsEquippableItem(P)if item.data~=nil and isItemEquippable then item.data.ilvl=D(U,slot,link)V:SetBagAndSlot(U,slot)if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(V)then local W=p(V)if W then item.data.azerite=W else item.data.azerite="undefined"end end end end;slot=slot+1;if slot>slots then U=U+1;slot=1;slots=GetContainerNumSlots(U)end;if not item:IsItemEmpty()then return item end end end end;local function X()local U=-1;local slots=GetContainerNumSlots(U)local slot=1;local V=ItemLocation.CreateEmpty()return function()while U<=NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do local item=Item:CreateFromBagAndSlot(U,slot)local m,m,m,m,m,m,P=GetContainerItemInfo(U,slot)if P~=nil then item.data=O(P)isItemEquippable=IsEquippableItem(P)if item.data~=nil and isItemEquippable then item.data.ilvl=D(U,slot,link)V:SetBagAndSlot(U,slot)if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(V)then local W=p(V)if W then item.data.azerite=W else item.data.azerite="undefined"end end end end;slot=slot+1;if slot>slots then if U==-1 then U=NUM_BAG_SLOTS+1 else U=U+1 end;slot=1;slots=GetContainerNumSlots(U)end;if not item:IsItemEmpty()then return item end end end end;function a:GetBagItemsData()local Y={}local Z={}for item in T()do local _=item:GetItemID()if not Z[_]then Z[_]=true;table.insert(Y,item.data)end end;return Y end;function a:GetBankItemsData()local Y={}local Z={}for item in X()do local _=item:GetItemID()if not Z[_]then Z[_]=true;if item.data then item.data.count=GetItemCount(_,true,false)end;table.insert(Y,item.data)end end;return Y end;function a:SetToyList()C_ToyBox.SetAllSourceTypeFilters(true)C_ToyBox.SetCollectedShown(true)C_ToyBox.SetUncollectedShown(false)C_ToyBox.SetUnusableShown(true)C_ToyBox.SetFilterString("")local a0=C_ToyBox.GetNumToys()local a1={}for a2=a0,1,-1 do local a3=C_ToyBox.GetToyFromIndex(a2)if a3~=-1 then table.insert(a1,a3)end end;return a1 end;function a:GetToysData()collectedToyList={}for H,a3 in pairs(a:SetToyList())do if PlayerHasToy(a3)then table.insert(collectedToyList,a3)end end;return collectedToyList end;function a:GetVoidStorageData()local Y={}local l={}slot=1;slots=160;while slot<=slots do if not isEmpty(GetVoidItemInfo(1,slot))then local a4=GetVoidItemInfo(1,slot)local P=GetVoidItemHyperlinkString(slot)l=O(P)l.count=GetItemCount(P,true,false)+1;l.ilvl="undefined"Y[#Y+1]=l end;slot=slot+1 end;return Y end;function a:GetTransmogData()local Y={illusions={},gear={body={},offHand={},mainHand={}},sets={}}local a5=Y.illusions;for m,a6 in ipairs(C_TransmogCollection.GetIllusions())do if a6.isCollected then local m,a7=C_TransmogCollection.GetIllusionSourceInfo(a6.sourceID)a5[#a5+1]={visualID=a6.visualID,sourceID=a6.sourceID}end end;local a8=C_TransmogSets.GetAllSets()local a9=1;for H=1,#a8,1 do if a8[H]['collected']==true then Y.sets[a9]=a8[H].setID;a9=a9+1 end end;for _,aa in next,a.categories do local ab=C_TransmogCollection.GetCategoryAppearances(_)local ac={}Y.gear[aa.type][aa.name]=ac;for m,ad in ipairs(ab)do if ad.isCollected then local ae={}local af=C_TransmogCollection.GetAppearanceSources(ad.visualID)for m,ag in ipairs(af)do if ag.isCollected then table.insert(ae,ag.itemID)end end;ac[#ac+1]={visualID=ad.visualID,sources=ae,type=aa.type}end end;Y.gear[aa.type][aa.name]=ac end;return Y end;function a:GetEquippedItemsData()local ah={}local q=ItemLocation.CreateEmpty()for ai=1,#a.EquipIds do local C=a.EquipIds[ai]local P=GetInventoryItemLink("player",C)if P~=nil then local aj=O(P)if aj~=nil then q:SetEquipmentSlot(C)if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(q)then local W=p(q)if W then aj.azerite=W else item.data.azerite="undefined"end end;table.insert(ah,aj)end end end;return ah end;function a:GetBagBankVoidCounts()local ak={bag=#a:GetBagItemsData(),bank=#a:GetBankItemsData(),void=#a:GetVoidStorageData()}return ak end;function a:GetAllData()local l={}l['toys']=a:GetToysData()l['transmog']=a:GetTransmogData()l['void']=a:GetVoidStorageData()l['bag']=a:GetBagItemsData()l['bank']=a:GetBankItemsData()l['info']=a:GetPlayerData()l['security']=a:Security()l['counts']=a:GetBagBankVoidCounts()return l end;function a:CountData(l)return i(l)end