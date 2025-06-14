--Dragonilian Reusnous
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterBoolFunction(s.filterS,ATTRIBUTE_FIRE),1,1,Synchro.NonTunerEx(s.filterS,ATTRIBUTE_LIGHT),1,1)
	local effs={c:GetCardEffect(EFFECT_SPSUMMON_PROC)}
	effs[1]:SetDescription(aux.Stringid(id,0))
	Synchro.AddProcedure(c,aux.FilterBoolFunction(s.filterS,ATTRIBUTE_LIGHT),1,1,Synchro.NonTunerEx(s.filterS,ATTRIBUTE_FIRE),1,1)
	effs={c:GetCardEffect(EFFECT_SPSUMMON_PROC)}
	for i=1,#effs do
		local e=effs[i]
		if e:GetDescription()==1172 then 
			e:SetDescription(aux.Stringid(id,1))
			break;	
		end
	end
	-- add pendulum to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

end
function s.filterS(c,att)
	return c:IsSetCard(0xffd) and c:IsAttribute(att) 
end
function s.filter(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
