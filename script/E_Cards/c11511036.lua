--Elegantea Kingdom
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0xfff)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.Ecount)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
    -- lv change
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_LVCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(s.cost)
	e4:SetCountLimit(1)
	e4:SetTarget(s.targetM)
	e4:SetOperation(s.operationM)
	c:RegisterEffect(e4)
 	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(s.desreptg)
	e5:SetOperation(s.desrepop)
	c:RegisterEffect(e5)
	--remove overlay replace
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.xcon)
	e6:SetOperation(s.xop)
	c:RegisterEffect(e6)

end
function s.cfilter(c)
	return c:GetLevel()>0 and c:IsFaceup() and c:IsSetCard(0xfff)
end
s.cardsList = {}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	s.cardsList = {}
	for i=1,#g do
		local c
		if i==1 then c = g:GetFirst() else c = g:GetNext() end
		local card_info = {}
		card_info.card 	= c
		card_info.level = c:GetLevel()
		s.cardsList[i]	= card_info
    end
    return true
end
function s.Ecount(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler() == re:GetHandler() then return end
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	for i=1,#s.cardsList do
		local c = s.cardsList[i].card
		if g:IsContains(c) and s.cardsList[i].level ~= c:GetLevel() then
			e:GetHandler():AddCounter(0xfff,1)
			break
		end
    end
end
function s.filterM3(c)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xfff,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xfff,1,REASON_COST)
end
function s.targetM(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filterM3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filterM3,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g1=Duel.SelectTarget(tp,s.filterM3,tp,LOCATION_MZONE,0,1,1,nil)
 end
function s.operationM(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0xfff)>1 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xfff,2,REASON_EFFECT)
end
function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0xfff)
		and re:GetHandler():GetOverlayCount()>=ev-1
		and e:GetHandler():GetCounter(0xfff)>2
end
function s.xop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	e:GetHandler():RemoveCounter(ep,0xfff,3,REASON_EFFECT)
	if ct>1 then
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end
