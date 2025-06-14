--SW Trapping Lure
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsSetCard(0xffb) and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	return bc and bc:IsControler(tp) and bc:IsSetCard(0xffb) and bc:IsFaceup() and Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,bc)>0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,bc)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local at=Duel.GetAttacker()
		if at:CanAttack() and not at:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,tc)

			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			at:RegisterEffect(e1)
		end
	end
end
