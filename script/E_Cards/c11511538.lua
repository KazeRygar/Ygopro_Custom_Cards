--Vortex Chain
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.filterD(c,sc)
	return c:IsSetCard(0xffa) and c:IsMonster() and c:IsAbleToHand() 
	and bit.band(c:GetRace(),sc:GetRace())==0
	and bit.band(c:GetAttribute(),sc:GetAttribute())==0
end
function s.filterG(c)
	return c:IsSetCard(0xffa) and c:IsMonster() and c:IsAbleToGrave() 
end
function s.filterS(c,tp)
	return c:IsSetCard(0xffa) and c:GetControler()==tp
end
function s.filterM(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filterS,nil,tp)
	if chk==0 then return #g==1 and Duel.IsExistingMatchingCard(s.filterD,tp,LOCATION_DECK,0,1,nil,g:GetFirst()) end
	g:GetFirst():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(s.filterS,nil,tp):GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filterD,tp,LOCATION_DECK,0,1,1,nil,tc)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if  not Duel.IsExistingMatchingCard(s.filterM,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,tc,tc:GetRace())
			and Duel.IsExistingMatchingCard(s.filterG,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g2=Duel.SelectMatchingCard(tp,s.filterG,tp,LOCATION_DECK,0,1,1,nil)
				if g2:GetCount()>0 then
					Duel.SendtoGrave(g2,REASON_EFFECT)
				end
		end
	end
end
