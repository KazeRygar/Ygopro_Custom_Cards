--Kairem Zeta
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffc),6,2)
	-- attack twice (Xyz Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.conSP)
	e1:SetCost(s.cost1)
	e1:SetCountLimit(1)
	e1:SetOperation(s.op1)
	e1:SetLabel(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	-- Change Scale (Xyz Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.conSP)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	e2:SetLabel(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	-- atk increase (Pendulum Summon)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.conSP)
	e3:SetOperation(s.op3)
	e3:SetLabel(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e3)
	-- Destroy (Pendulum effect)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.tg4)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
end
s.pendulum_level=8

function s.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	-- attack twice
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function s.filter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_PZONE,0,1,nil) end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_PZONE,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local value=1
		if tc:GetLeftScale()>0 and tc:GetRightScale()>0 then
			value=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))*-2+1
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(value)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	end
end

function s.filter3(c)
	return c:IsSetCard(0xffc) and c:IsFaceup()
end
function s.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end

	local sc=g:GetFirst()
	local c=e:GetHandler()
	while sc do
		-- atk increase	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		sc:RegisterEffect(e1)
		sc=g:GetNext()
	end
end

function s.filter4(c)
	return c:IsSetCard(0xffc) and c:IsDestructable()
end
function s.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter4,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,2,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter4,tp,LOCATION_MZONE,0,1,1,nil) 
	if #g and Duel.Destroy(g,REASON_EFFECT) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g2:GetCount() then 
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
