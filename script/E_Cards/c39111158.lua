-- Tri-Horned Dragon
local s,id=GetID()
function s.initial_effect(c)
    -- add setcode to card using script instead of modifying original cards.cdb
    -- this card is still a Normal Type Monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_ALL)
	e1:SetValue(0x1ffe)
	c:RegisterEffect(e1)
end
