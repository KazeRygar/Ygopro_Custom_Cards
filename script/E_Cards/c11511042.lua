--Tribute for the Stars
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return c:IsSetCard(0xfff) and c:GetLevel()>0 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,c)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.filter,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.filter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetLevel())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    local i=1
	for i=1,lv do
        if i>10 then k=10 else k=i end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,k))
        local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
        local tc=g:GetFirst()
        if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
        Duel.BreakEffect()
	end
	end
end
