--Vortex Tempo
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,11511514,aux.FilterBoolFunction(s.filterF))
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_WIND)
end
function s.filterR(c,race)
	return c:IsRace(race) and c:IsFaceup()
end
function s.filter(c,tp)
	return c:IsSetCard(0xffa) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	and not Duel.IsExistingMatchingCard(s.filterR,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c:GetRace()) 
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,tp,nil,tp)
end
function s.filterDes(c)
	return c:IsDestructable() and c:IsSpellTrap()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filterDes,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filterDes,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,nil,LOCATION_ONFIELD)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
