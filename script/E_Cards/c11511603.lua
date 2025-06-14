--Lost Memmories of the Pharaoh
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.costRev)
	e2:SetTarget(s.targetT)
	e2:SetOperation(s.operationT)
	c:RegisterEffect(e2)
end
function s.costRev(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_HAND,0,1,nil,ATTRIBUTE_DIVINE)
	end
	local max=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_HAND,0,1,max,nil,ATTRIBUTE_DIVINE)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
	e:SetLabel(g1:GetCount())
end
function s.targetT(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11511601,0,TYPES_TOKEN,0,3000,1,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,e:GetLabel(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),0,0)
end
function s.operationT(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,11511601,0,TYPES_TOKEN,0,3000,1,RACE_ROCK,ATTRIBUTE_EARTH) then 
		return
	end
	local loc_count=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if loc_count>0 then
		if loc_count>e:GetLabel() then loc_count=e:GetLabel() end

		for i=1,loc_count do
			local token=Duel.CreateToken(tp,11511601)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
end
