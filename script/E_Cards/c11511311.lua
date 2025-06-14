--Kairem Xi
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffc),1,1,Synchro.NonTunerEx(Card.IsSetCard,0xffc),1,1)
	-- unaffected by card (Synchro Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.conSP)
	e1:SetValue(s.efilter)
	e1:SetLabel(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	-- cant battle destroy (Pendulum Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.conSP)
	e2:SetValue(1)
	e2:SetLabel(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
	--Battle indestructable (Pendulum Effect)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.tg3)
	e3:SetValue(s.val3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function s.tg3(e,c)
	return c:IsSetCard(0xffc)
end
function s.val3(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function s.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
