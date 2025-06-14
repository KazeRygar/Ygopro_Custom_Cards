--Dragonilian Zarkish
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterBoolFunction(s.filterS,ATTRIBUTE_DARK),1,1,Synchro.NonTunerEx(s.filterS,ATTRIBUTE_EARTH),1,1)
	local effs={c:GetCardEffect(EFFECT_SPSUMMON_PROC)}
	effs[1]:SetDescription(aux.Stringid(id,0))
	Synchro.AddProcedure(c,aux.FilterBoolFunction(s.filterS,ATTRIBUTE_EARTH),1,1,Synchro.NonTunerEx(s.filterS,ATTRIBUTE_DARK),1,1)
	effs={c:GetCardEffect(EFFECT_SPSUMMON_PROC)}
	for i=1,#effs do
		local e=effs[i]
		if e:GetDescription()==1172 then 
			e:SetDescription(aux.Stringid(id,1))
			break;	
		end
	end
	-- add attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

end
function s.filterS(c,att)
	return c:IsSetCard(0xffd) and c:IsAttribute(att) 
end
function s.filter(c)
	return c:IsSetCard(0xffd) and c:IsMonster() and c:IsFaceup()
	and c:GetAttribute()~=ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_WIND+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_DIVINE
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)	
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-g:GetFirst():GetAttribute())
	e:SetLabel(att)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local att=e:GetLabel()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
