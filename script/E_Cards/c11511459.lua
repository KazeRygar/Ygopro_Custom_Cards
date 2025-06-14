--SW Formation Transform
local s,id=GetID()
function s.initial_effect(c)
	-- sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
end
function s.filterF(c,e,tp,tc)
	local min=1
	if tc then min=2 end
	return c:IsSetCard(0xffb) and c:IsAbleToHand() and c:IsMonster() 
		and Duel.IsExistingMatchingCard(s.filterH,tp,LOCATION_HAND,0,min,nil,e,tp,c,tc)
end
function s.filterH(c,e,tp,rc,tc)
	return c:IsSetCard(0xffb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsMonster() 
	and not c:IsCode(rc:GetCode()) and not (tc and c:IsCode(tc:GetCode()) )
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 
		and Duel.IsExistingTarget(s.filterF,tp,LOCATION_MZONE,0,1,nil,e,tp,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filterF,tp,LOCATION_MZONE,0,1,1,nil,e,tp,nil)
	local tc1=g:GetFirst()
	if Duel.IsExistingTarget(s.filterF,tp,LOCATION_MZONE,0,1,tc1,e,tp,tc1) 
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g:Merge(Duel.SelectTarget(tp,s.filterF,tp,LOCATION_MZONE,0,1,1,tc1,e,tp,tc1))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#g,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,LOCATION_MZONE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=Duel.SelectMatchingCard(tp,s.filterH,tp,LOCATION_HAND,0,#g,#g,nil,e,tp,tc1,tc2)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
