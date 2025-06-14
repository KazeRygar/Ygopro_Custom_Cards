--Dragonilian Windra
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--counter permit
	c:EnableCounterPermit(0xffd)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.hspcon)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	-- add counters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.addctg)
	e2:SetOperation(s.addcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--cannot be attack target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetTarget(s.tg)
	e5:SetValue(s.bttg)
	c:RegisterEffect(e5)
	--destroy spell/trap
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(s.cost)
	e7:SetTarget(s.destg)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)
	--negate spell/trap
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCost(s.cost)
	e8:SetCondition(s.negcon)
	e8:SetTarget(s.negtg)
	e8:SetOperation(s.negop)
	c:RegisterEffect(e8)
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev) and  ep~=tp 
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE+CATEGORY_DESTROY,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xffd,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xffd,1,REASON_COST)
end
function s.desfilter(c)
	return c:IsSpellTrap() and c:IsDestructable()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.tg(e,c)
	e:SetLabelObject(c)
	return true
end
function s.bttg(e,c)
	local tc=e:GetLabelObject()
	return tc:IsFaceup() and tc:IsSetCard(0xffd) and tc:IsAttribute(c:GetAttribute())
end
function s.spfilter(c)
	return c:IsSetCard(0xffd) and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),s.spfilter,1,nil)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.spfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.filterAtt(c,att)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsAttribute(att)
end
function s.getAttributesNumber(tp)
	local attributes={ATTRIBUTE_WIND,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_DIVINE}
	local count=0
	local att
	for att=1,7 do
		if Duel.IsExistingMatchingCard(s.filterAtt,tp,LOCATION_MZONE,0,1,nil,attributes[att]) then count=count+1 end
	end
	return count
end
function s.addctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,s.getAttributesNumber(tp),0,0xffd)
end
function s.addcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xffd,s.getAttributesNumber(tp))
	end
end
