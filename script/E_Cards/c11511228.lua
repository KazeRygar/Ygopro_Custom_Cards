--Dragonilian Qasysde
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--counter permit
	c:EnableCounterPermit(0xffd)
	--fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.fscon)
	e0:SetOperation(s.fsop)
	c:RegisterEffect(e0)
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_WIND+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	-- add counters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.addctg)
	e2:SetOperation(s.addcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	-- remove counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)	
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(s.conrem)
	e4:SetOperation(s.oprem)
	c:RegisterEffect(e4)
	-- Immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.efilter)
	e5:SetCondition(s.conrem)
	c:RegisterEffect(e5)

end
function s.FConditionCheckF(c,chkf)
	return c:IsOnField() and c:IsControler(chkf)
end
function s.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsSetCard,nil,0xffd)
	mg=mg:Filter(Card.IsType,nil,TYPE_MONSTER)

	local fs=false
	if Duel.GetLocationCount(chkf,LOCATION_MZONE) == 0 then
		fs = mg:IsExists(s.FConditionCheckF,1,nil,chkf)
	else fs = true end
	return mg:GetClassCount(Card.GetAttribute)>=6 and (fs or chkf==PLAYER_NONE)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if not s.fscon(e,eg,gc,chkf) then return end
	local sg=eg:Filter(Card.IsSetCard,nil,0xffd)
	sg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local g1=nil

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE and Duel.GetLocationCount(chkf,LOCATION_MZONE) == 0 then
		g1=sg:FilterSelect(tp,s.FConditionCheckF,1,1,nil,chkf)
	else
		g1=sg:Select(tp,1,1,nil)
	end
	sg:Remove(Card.IsAttribute,nil,g1:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsAttribute,nil,g2:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsAttribute,nil,g3:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g4=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsAttribute,nil,g4:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g5=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsAttribute,nil,g5:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g6=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	g1:Merge(g5)
	g1:Merge(g6)
	Duel.SetFusionMaterial(g1)
end
function s.addctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,6,0,0xffd)
end
function s.addcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xffd,6)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.conrem(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xffd)>0
end
function s.oprem(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	e:GetHandler():RemoveCounter(tp,0xffd,1,REASON_COST+REASON_EFFECT)
end