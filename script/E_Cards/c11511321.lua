--Kairem Che
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--fusion summon rule
	Fusion.AddProcMixN(c,true,true,s.ffilter,2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,SUMMON_TYPE_FUSION)
	-- return to Hand (Fusion Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(SUMMON_TYPE_FUSION)
	e1:SetCondition(s.conSP)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)
	--dec ATK (Pendulum summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(SUMMON_TYPE_PENDULUM)
	e2:SetCondition(s.conSP)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	-- return to Hand (Pendulum Effect)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
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
function s.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xffc) and c:IsType(TYPE_PENDULUM) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thfilter,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function s.filterH(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filterH, tp, 0, LOCATION_MZONE, nil)
	if #g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function s.atkfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tcl=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tcr=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local pScales=0;
	if tcl and tcl:IsSetCard(0xffc) then pScales=pScales+tcl:GetLeftScale() end
	if tcr and tcr:IsSetCard(0xffc) then pScales=pScales+tcr:GetRightScale() end
	local g=Duel.GetMatchingGroup(s.atkfilter, tp, 0, LOCATION_MZONE, nil,e)

	if #g then
		local rc=g:GetFirst()
		while rc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(pScales*-100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1)
			rc=g:GetNext()
		end
	end
end
