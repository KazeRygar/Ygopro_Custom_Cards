--Vortex Judgement
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,11511511,aux.FilterBoolFunction(s.filterF))
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)

end
function s.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_EARTH)
end
function s.filter(c,race)
	return c:IsSetCard(0xffa) and c:IsFaceup() and c:IsRace(race)
end
function s.target(e,c)
	return Duel.IsExistingMatchingCard(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,c:GetRace())
end