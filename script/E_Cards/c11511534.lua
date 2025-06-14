--Vortex Wrath
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,4)
	--cannot negate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCondition(s.con)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e1)
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)	
end
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0xffa,fc,sumtype,tp)
	and c:GetRace(fc,sumtype,tp)~=0
	and (not sg or not sg:IsExists(s.fusfilter,1,c,c:GetRace(fc,sumtype,tp),fc,sumtype,tp))
end
function s.fusfilter(c,race,fc,sumtype,tp)
	return c:IsRace(race,fc,sumtype,tp) and not c:IsHasEffect(511002961)
end
function s.con(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function s.filter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local mc=mg:GetFirst()
	local races=0
	while mc do
		races=bit.bor(races,mc:GetRace())
		mc=mg:GetNext()
	end
	e:SetLabel(races)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,nil,races)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,nil,e:GetLabel())
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(#g*400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)

	end
end
