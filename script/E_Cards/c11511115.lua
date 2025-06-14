--Beast Rebirth
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter1(c,tp)
	return c:IsSetCard(0xffe) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_XYZ)
	and Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,c:GetRace())
end
function s.filter2(c,rc)
	return c:IsSetCard(0xffe) and c:IsAbleToHand() and c:IsRace(rc)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabelObject(g:GetFirst())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,tc,tc:GetRace())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
