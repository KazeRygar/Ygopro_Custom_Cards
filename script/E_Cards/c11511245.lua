--Dragonilian Eradication
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.con)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter2(c)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					and Duel.IsExistingTarget(s.filter1,tp,LOCATION_PZONE,0,1,nil,e,tp)
					and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,0,1,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
    e:SetLabelObject(g1:GetFirst())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
	    Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.filterAtt(c,att)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsAttribute(att)
end
function s.getAttributesNumber(tp)
	local attributes={ATTRIBUTE_WIND,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_WATER,ATTRIBUTE_FIRE}
	local count=0
	local att
	for att=1,6 do
		if Duel.IsExistingMatchingCard(s.filterAtt,tp,LOCATION_MZONE,0,1,nil,attributes[att]) then count=count+1 end
	end
	return count
end
---------------------------------------------------
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and s.getAttributesNumber(tp)==6
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.cfilter(c,att)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsAttribute(att)
end
function s.dfilter1(c)
	return c:IsDestructable() and c:IsFaceup()
end
function s.dfilter2(c)
	return c:IsDestructable() and c:IsFacedown()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		   Duel.IsExistingMatchingCard(s.dfilter1,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingMatchingCard(s.dfilter2,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		or Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0
	end
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(s.dfilter1,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(s.dfilter2,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=0 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(s.dfilter1,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(s.dfilter2,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==3 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	elseif opval[op]==4 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
