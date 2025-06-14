--Kairem Ancient Tree
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

end
function s.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_PZONE,0,2,nil) end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_PZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		local tc1=g1:GetFirst()
		local g2=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_PZONE,0,1,1,tc1)
		if g2:GetCount()>0 then
			local tc2=g2:GetFirst()
			-- increase first
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			tc1:RegisterEffect(e2)
			-- decrease second
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_LSCALE)
			e3:SetValue(-1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_RSCALE)
			tc2:RegisterEffect(e4)
		end
	end
end
