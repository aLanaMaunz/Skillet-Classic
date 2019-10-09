local addonName,addonTable = ...
local DA = LibStub("AceAddon-3.0"):GetAddon("Skillet") -- for DebugAids.lua
--[[
Skillet: A tradeskill window replacement.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

local L = LibStub("AceLocale-3.0"):GetLocale("Skillet")

--
-- internal recipe filter
--
-- filter this recipe based on the values selected in the filter dropdown
--
-- most of the work has already been done and is stored in:
--   subClass = Skillet.db.realm.subClass[player][tradeID]
--   invSlot = Skillet.db.realm.invSlot[player][tradeID]
-- indexed by itemID with the choices stored in a table:
--   Skillet.db.realm.subClass[player][tradeID].name
--   Skillet.db.realm.invSlot[player][tradeID].name
--
-- the filter dropdown will offer the choices in the name table
-- and will set two global variables:
--   Skillet.db.realm.subClass[player][tradeID].selected
--   Skillet.db.realm.invSlot[player][tradeID].selected
--
--[[
	["invSlot"] = {
		["player"] = {
			[2550] = {
				[4343] = "INVTYPE_LEGS",
				["name"] = {
					[""] = 13,
					["INVTYPE_BODY"] = 4,
					["INVTYPE_FEET"] = 2,
					["INVTYPE_LEGS"] = 2,
					["INVTYPE_CLOAK"] = 2,
					["INVTYPE_BAG"] = 1,
				},
	["subClass"] = {
		["player"] = {
			[2550] = {
				[4343] = "Cloth",
				["name"] = {
					["Bag"] = 1,
					["Cloth"] = 12,
				},
]]--

function Skillet:RecipeFilter(skillIndex)
	DA.DEBUG(1,"RecipeFilter("..tostring(skillIndex)..")")
	local skill = Skillet:GetSkill(Skillet.currentPlayer, Skillet.currentTrade, skillIndex)
	--DA.DEBUG(1,"skill= "..DA.DUMP1(skill,1))
	local recipe = Skillet:GetRecipe(skill.id)
	--DA.DEBUG(1,"recipe= "..DA.DUMP1(recipe,1))
	local subClass = Skillet.db.realm.subClass[Skillet.currentPlayer][Skillet.currentTrade]
	local invSlot = Skillet.db.realm.invSlot[Skillet.currentPlayer][Skillet.currentTrade]
	local itemID = recipe.itemID
	DA.DEBUG(1,"RecipeFilter: itemID= "..tostring(itemID)..", subClass= "..tostring(subClass[itemID])..", invSlot= "..tostring(invSlot[itemID]))
	DA.DEBUG(1,"RecipeFilter: subClass.selected= "..tostring(subClass.selected)..", invSlot.selected= "..tostring(invSlot.selected))
	if not ItemID and not subClass.selected and not invSlot.selected then
		return false
	end
	if subClass[itemID] == subClass.selected or invSlot[itemID] == invSlot.selected then
		return true
	end
	return false
end

--
-- called when the new filter drop down is first loaded
--
function Skillet:FilterDropDown_OnLoad()
	DA.DEBUG(0,"FilterDropDown_OnLoad()")
	UIDropDownMenu_Initialize(SkilletFilterDropdown, Skillet.FilterDropDown_Initialize)
	SkilletFilterDropdown.displayMode = "MENU"  -- changes the pop-up borders to be rounded instead of square
end

--
-- Called when the new filter drop down is displayed
--
function Skillet:FilterDropDown_OnShow()
	DA.DEBUG(0,"FilterDropDown_OnShow()")
	UIDropDownMenu_Initialize(SkilletFilterDropdown, Skillet.FilterDropDown_Initialize)
	SkilletFilterDropdown.displayMode = "MENU"  -- changes the pop-up borders to be rounded instead of square
	if Skillet.unlearnedRecipes then
		UIDropDownMenu_SetSelectedID(SkilletFilterDropdown, 2)
	else
		UIDropDownMenu_SetSelectedID(SkilletFilterDropdown, 1)
	end
end

--
-- The method we use the initialize the new filter drop down.
--
function Skillet:FilterDropDown_Initialize()
	DA.DEBUG(0,"FilterDropDown_Initialize()")
	local info
	local i = 1

	info = UIDropDownMenu_CreateInfo()
	info.text = L["None"]
	info.func = Skillet.FilterDropDown_OnClick
	info.value = i
	if self then
		info.owner = self:GetParent()
	end
	UIDropDownMenu_AddButton(info)
	i = i + 1

--[[
	info = UIDropDownMenu_CreateInfo()
	info.text = L["SubClass"]
	info.func = Skillet.FilterDropDown_OnClick
	info.value = i
	if self then
		info.owner = self:GetParent()
	end
	UIDropDownMenu_AddButton(info)
	i = i + 1

	info = UIDropDownMenu_CreateInfo()
	info.text = L["Slot"]
	info.func = Skillet.FilterDropDown_OnClick
	info.value = i
	if self then
		info.owner = self:GetParent()
	end
	UIDropDownMenu_AddButton(info)
	i = i + 1
]]--
end

--
-- Called when the user selects an item in the new filter drop down
--
function Skillet:FilterDropDown_OnClick()
	DA.DEBUG(0,"FilterDropDown_OnClick()")
	UIDropDownMenu_SetSelectedID(SkilletFilterDropdown, self:GetID())
	local index = self:GetID()
	if index == 1 then
--		Skillet:SetTradeSkillLearned()
	elseif index == 2 then
--		Skillet:SetTradeSkillUnlearned()
	end
	Skillet.dataScanned = false
	Skillet:RescanTrade()
	Skillet:UpdateTradeSkillWindow()
end