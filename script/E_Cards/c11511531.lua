--Vortex Wisdom
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,11511512,aux.FilterBoolFunction(s.filterF))
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
function s.filterF(c)
	return c:IsSetCard(0xffa) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.con(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function s.tg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:IsSetCard(0xffa) and c:GetRace()==bc:GetRace() and c:GetControler()~=bc:GetControler()
end
function s.val(e,c)
	return c:GetBattleTarget():GetAttack()
end
