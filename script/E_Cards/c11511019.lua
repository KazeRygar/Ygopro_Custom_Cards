--Elegantea Queen Cassandra
local s,id=GetID()
function s.initial_effect(c)
    -- lv change
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.limcon)
	e1:SetTarget(s.targetM)
	e1:SetOperation(s.operationM)
	c:RegisterEffect(e1)
    --synchro , xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(s.limit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(s.negcon)
	e4:SetTarget(s.negtg)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
end
function s.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0xfff)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)  then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev) and  ep~=tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	end
end
function s.filterlim(c)
	return c:IsCode(11511045) and c:IsFaceup() and not c:IsDisabled()
end
function s.limcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    if Duel.IsExistingMatchingCard(s.filterlim,tp,LOCATION_SZONE,0,1,nil)
    then return e:GetHandler():GetFlagEffect(id)<2
	else return e:GetHandler():GetFlagEffect(id)<1 end
end
function s.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xfff)
end
function s.filterM1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>0 and Duel.IsExistingTarget(s.filterM2,tp,LOCATION_MZONE,0,1,c)
end
function s.filterM2(c)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>1
end
function s.targetM(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filterM1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filterM1,tp,LOCATION_MZONE,0,1,nil,tp)  end
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
         local g1=Duel.SelectTarget(tp,s.filterM1,tp,LOCATION_MZONE,0,1,1,nil,tp)
         e:SetLabelObject(g1:GetFirst())
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
         local g2=Duel.SelectTarget(tp,s.filterM2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
    	 e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
 end
function s.operationM(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(1)
		if hc:RegisterEffect(e1) then
			local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetCode(EFFECT_UPDATE_LEVEL)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(-1)
            tc:RegisterEffect(e2)
		end
	end
end
