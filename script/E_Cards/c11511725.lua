--EM-Parts Strike
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.counter_place_list={0x1ff8}
function s.filter(c)
	return c:IsFaceup() and c:GetCounter(0x1ff8)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.tg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc) or s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return s.tg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc) or s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	local opt0=s.tg0(e,tp,eg,ep,ev,re,r,rp,0,nil)
	local opt1=s.tg1(e,tp,eg,ep,ev,re,r,rp,0,nil)
	local opt=0
	if opt0 and opt1 then opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif opt1 then opt=1 end
	if opt==0 
	then s.tg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	else s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	end
	e:SetLabel(opt)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==0 
	then s.op0(e,tp,eg,ep,ev,re,r,rp)
	else s.op1(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.tg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,10,0,0x1ff8)
end
function s.op0(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1ff8,10)
	end
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
        and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
    end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g1=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,g1:GetFirst():GetCounter(0x1ff8),0,0x1ff8)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc2==tc1 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) and tc1:IsFaceup() and tc2:IsRelateToEffect(e) and tc2:IsFaceup() then
        local counters=tc1:GetCounter(0x1ff8)
        if counters>0 then
            tc1:RemoveCounter(tp,0x1ff8,counters,REASON_EFFECT)
            tc2:AddCounter(0x1ff8,counters)
        end
    end
end
