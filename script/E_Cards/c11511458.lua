--SW Immortal Battle
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.tg)
	e2:SetCountLimit(2)
	e2:SetValue(s.valcon)
	c:RegisterEffect(e2)
	--aclimit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(s.accon)
	e3:SetValue(s.aclimit)
	c:RegisterEffect(e3)
end
function s.tg(e,c)
	return c:IsSetCard(0xffb) and c:IsFaceup()
end
function s.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function s.accon(e)
	local tp=e:GetHandler():GetControler()
	local c1=Duel.GetAttacker()
	local c2=Duel.GetAttackTarget()
	if c1 and c1:GetControler()==1-tp then c1=c2 c2=Duel.GetAttacker() end
	return c1 and c2 and c1:IsSetCard(0xffb) and c1:IsFaceup()
end
function s.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
