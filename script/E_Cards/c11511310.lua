--Kairem Omicron
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffc),1,1,Synchro.NonTunerEx(Card.IsSetCard,0xffc),1,1)
	-- banish from hand (Synchro Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.conSP)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	e1:SetLabel(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	-- banish from grave (Pendulum Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.conSP)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	e2:SetLabel(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
	-- atk up (Pendulum Effect)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.tg)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	-- Pendulum Summon Counter 
	if not s.global_check then
		s.global_check=true
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if bit.band(tc:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and tc:IsSetCard(0xffc) then
			local p=tc:GetSummonPlayer()
			s[p]=s[p]+1
		end
		tc=eg:GetNext()
	end
end
function s.clearop(e,tp,eg,ep,ev,re,r,rp)
	s[0]=0
	s[1]=0
end
function s.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end
-- e3
function s.tg(e,c)
	return c:IsSetCard(0xffc)
end
function s.filterV(c)
	return c:IsFaceup() and c:IsSetCard(0xffc)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filterV,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
-- e1
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
-- e2
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,s[tp],nil)
	if #g then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
