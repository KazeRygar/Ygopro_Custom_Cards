--Dragonilian Possedon
local s,id=GetID()
function s.initial_effect(c)
	-- sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

function s.filterAtt(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.filterSP(c,e,tp)
	return c:IsSetCard(0xffd) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not Duel.IsExistingMatchingCard(s.filterAtt,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filterSP,tp,LOCATION_HAND,0,1,nil,e,tp) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filterSP,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
