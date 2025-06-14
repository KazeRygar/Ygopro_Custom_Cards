--Elegantea Assassin Petra
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
	--to hand,grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function s.filterH(c)
	return c:IsSetCard(0xfff) and c:IsMonster() and not c:IsCode(id) and c:IsAbleToHand()
end
function s.filterG(c)
	return c:IsSetCard(0xfff) and c:IsMonster() and not c:IsCode(id) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filterH,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filterH,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
    local dg=Duel.GetMatchingGroup(s.filterG,tp,LOCATION_DECK,0,nil)
    if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filterG,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
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
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>0
	and Duel.IsExistingTarget(s.filterM2,tp,LOCATION_MZONE,0,1,c)
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
