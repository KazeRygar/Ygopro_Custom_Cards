--Dragonilian Frenuss
local s,id=GetID()
function s.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(s.filter,nil))
	c:RegisterEffect(e1)

end
function s.filterAtt(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.filter(c)
	return c:IsSetCard(0xffd) and not Duel.IsExistingMatchingCard(s.filterAtt, c:GetControler(), LOCATION_MZONE,0,1,nil,c:GetAttribute()) 
end
