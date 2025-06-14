--Kairem Rho
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--fusion summon rule
	Fusion.AddProcMixN(c,true,true,s.ffilter,2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,SUMMON_TYPE_FUSION)
	--Destroy (fusion summon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.conSP)
	e1:SetLabel(SUMMON_TYPE_FUSION)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	-- ATK (Pendulum Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(SUMMON_TYPE_PENDULUM)
	e2:SetCondition(s.conSP)
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	-- Scale (Pendulum Effect)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(s.conLV)
	e3:SetOperation(s.operationLV)
	c:RegisterEffect(e3)
end
function s.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0xffc,fc,sumtype,tp)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(function(c) return c:IsMonster() and c:IsAbleToDeckOrExtraAsCost() end,tp,LOCATION_GRAVE,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA or e:GetHandler():IsFaceup()
end
function s.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_ONFIELD,nil,POS_FACEDOWN)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_ONFIELD,nil,POS_FACEDOWN)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.value(e,c)
	local tp=c:GetControler()
	local tcl=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tcr=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local total=0;
	if tcl and tcl:IsSetCard(0xffc) then total=total+tcl:GetLeftScale() end
	if tcr and tcr:IsSetCard(0xffc) then total=total+tcr:GetRightScale() end
	return total*100
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xffc) and c:IsType(TYPE_PENDULUM) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.conLV(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLeftScale()<11 and e:GetHandler():GetRightScale()<11 and eg:IsExists(s.cfilter,1,nil)
end
function s.operationLV(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or c:GetLeftScale()>=11 or c:GetRightScale()>=11 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
