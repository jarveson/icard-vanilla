IDCard = {}
local skinTooltip = false;
local registry = {}

local function click()
	local reg = registry[ItemRefTooltip]
    if IsShiftKeyDown() and ChatFrameEditBox:IsVisible() and reg and reg.link then
		local name, _, quality = GetItemInfo(reg.link)
    	if name then
        	local _,_,_,hex = GetItemQualityColor(quality)
        	local link = hex ..  '|H' .. reg.link .. '|h[' .. name .. ']|h' .. FONT_COLOR_CODE_CLOSE
			ChatFrameEditBox:Insert(link)
		end
    elseif IsControlKeyDown() and reg.link then
        DressUpItemLink(reg.link)
    end
end

local function dragstart()this:GetParent():StartMoving()end
local function dragstop()this:GetParent():StopMovingOrSizing()end

local origSetItemRef = SetItemRef;

SetItemRef = function(link,text,button) 
	origSetItemRef(link,text,button);
	if not IsShiftKeyDown() and not IsControlKeyDown() then
		if skinTooltip then
			IDCard:SkinFrame();
		end
		IDCard:AddIconFrame();
		IDCard:AddIcon(link);
	end
end

function IDCard:AddIconFrame()
	if registry[ItemRefTooltip] then return end
	local reg = {}
	registry[ItemRefTooltip] = reg

	local b = CreateFrame("Button",nil, ItemRefTooltip)
    b:SetWidth(37)
    b:SetHeight(37)
	if skinTooltip then
    	b:SetPoint("TOPRIGHT",ItemRefTooltip,"TOPLEFT",-1,0)
	else 
		b:SetPoint("TOPRIGHT",ItemRefTooltip,"TOPLEFT",0,-3)
	end
    b:SetScript("OnDragStart",dragstart)
    b:SetScript("OnDragStop",dragstop)
    b:SetScript("OnClick",click)
    b:RegisterForDrag("LeftButton")
    reg.button = b
	
	--[[local t = b:CreateTexture(nil,"OVERLAY")
	t:SetTexture("Interface\\AchievementFrame\\UI-Achievement-IconFrame")
	t:SetTexCoord(0,0.5625,0,0.5625)
	t:SetPoint("CENTER",0,0)
	t:SetWidth(47)
	t:SetHeight(47)	
	t:Hide()]]--
end

function IDCard:AddIcon(link) 
	if registry[ItemRefTooltip] then
		local reg = registry[ItemRefTooltip]
		reg.link = nil
		if strfind(link,"^item") then
			local _, _, _, _, _, _, _, _, texture = GetItemInfo(link)
			--print(texture)
			reg.button:SetNormalTexture(texture)
			reg.link = link
		end
		-- no such thing as linking spells as far as i can tell
		--[[elseif strfind(link,"^spell") then
			--local _,id = self:GetSpell()
			local name, rank, icon, castingTime, minRange, maxRange, spellID = GetSpellInfo(link)
			b:SetNormalTexture(icon)
			b.link = link --GetSpellLink(id)
		end]]--
	end
end

function IDCard:SkinFrame() 
	ItemRefTooltip:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\AddOns\\IDCard\\border",
		tile = true,
		tileSize = 8,
		edgeSize = 4,
		insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0,
			}
		} 
	)
	ItemRefTooltip:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	ItemRefTooltip:SetBackdropColor(0, 0, 0, 0.75)
end