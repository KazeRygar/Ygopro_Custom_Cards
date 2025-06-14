--Elemental Sky Barrier
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk inc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.tginc)
	e2:SetValue(s.valinc)
	c:RegisterEffect(e2)
	--atk dec
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.tgdec)
	e3:SetValue(s.valdec)
	c:RegisterEffect(e3)
end
s.listed_series={0xff8}
s.counter_list={0x1ff8}
function s.tginc(e,c)
	return c:IsFaceup() and c:IsSetCard(0xff8)
end
function s.tgdec(e,c)
	return c:IsFaceup()
end
function s.valinc(e,c)
	return c:GetCounter(0x1ff8)*100
end
function s.valdec(e,c)
	return c:GetCounter(0x1ff8)*-100
end
