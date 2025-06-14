--Vortex Rampage
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,11511515,aux.FilterBoolFunction(s.filterF))
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(s.con)
	c:RegisterEffect(e2)

end
function s.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function s.filter(c)
	return c:IsSetCard(0xffa) and c:IsFaceup()
end
function s.val(e)
	return Duel.GetMatchingGroup(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetRace)-1
end
function s.con(e)
	return Duel.GetMatchingGroup(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetRace)==0
end
