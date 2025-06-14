--Dragonilian Rapruda
local s,id=GetID()
function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
end

function s.filterE(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsControler(1-tp) and c:IsFaceup() 
end
function s.filterM(c)
	return c:IsSetCard(0xffd) and c:IsFaceup() 
end
function s.filterAtt(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev) and  ep~=tp 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.filterM,tp,LOCATION_MZONE,0,1,nil)
	and not Duel.IsExistingMatchingCard(s.filterAtt,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetAttribute())
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	end
end
