--Vortex Dread
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,11511510,aux.FilterBoolFunction(s.filterF))
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
end
function s.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function s.filter(c)
	return c:IsSetCard(0xffa) and c:IsFaceup()
end
function s.value(e)
	local g=Duel.GetMatchingGroup(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetRace)*100
end
