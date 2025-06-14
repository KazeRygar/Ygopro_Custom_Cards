--Infinity God Impact
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetLabel(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e3:SetCost(s.costSp)
	e3:SetTarget(s.targetSp)
	e3:SetOperation(s.operationSp)
	c:RegisterEffect(e3)
end

function s.filter(c,tp)
	return c:IsMonster() and c:GetControler()~=tp and c:GetPreviousControler()~=tp
end
function s.condition(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return bit.band(r,REASON_DESTROY+REASON_EFFECT)==REASON_DESTROY+REASON_EFFECT 
	and re and re:GetHandler():IsAttribute(ATTRIBUTE_DIVINE) and re:GetHandler():IsControler(tp)
	and eg:FilterCount(s.filter,nil,tp)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local count = eg:FilterCount(s.filter,nil,tp)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(count*1000)
	Duel.SetOperationInfo(nil,CATEGORY_DAMAGE,nil,nil,1-tp,count*1000)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,dmg = Duel.GetChainInfo(nil,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,dmg,REASON_EFFECT)
end

function s.filterR(c,code)
	return c:GetCode()==code and c:IsAbleToRemoveAsCost()
end
function s.costSp(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.filterR,tp,LOCATION_GRAVE,0,1,nil,11511605)
		and Duel.IsExistingMatchingCard(s.filterR,tp,LOCATION_GRAVE,0,1,nil,11511606)
		and Duel.IsExistingMatchingCard(s.filterR,tp,LOCATION_GRAVE,0,1,nil,11511607)
	end
	local g=Group.FromCards(e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g:Merge( Duel.SelectMatchingCard(tp,s.filterR,tp,LOCATION_GRAVE,0,1,1,nil,11511605) )
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g:Merge( Duel.SelectMatchingCard(tp,s.filterR,tp,LOCATION_GRAVE,0,1,1,nil,11511606) )
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g:Merge( Duel.SelectMatchingCard(tp,s.filterR,tp,LOCATION_GRAVE,0,1,1,nil,11511607) )
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_COST)
end
function s.filterSp(c,e,tp,code)
	return c:GetCode()==code and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	and not( c:IsLocation(LOCATION_GRAVE) and c:IsHasEffect(EFFECT_NECRO_VALLEY) )
end
function s.targetSp(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingMatchingCard(s.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000020)
		and Duel.IsExistingMatchingCard(s.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000010)
		and Duel.IsExistingMatchingCard(s.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000000)
	end
end
function s.operationSp(e,tp,eg,ep,ev,re,r,rp)
	if 	not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingMatchingCard(s.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000020)
		and Duel.IsExistingMatchingCard(s.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000010)
		and Duel.IsExistingMatchingCard(s.filterSp,tp,e:GetLabel(),0,1,nil,e,tp,10000000)
	then
		local g=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g:Merge( Duel.SelectMatchingCard(tp,s.filterSp,tp,e:GetLabel(),0,1,1,nil,e,tp,10000020) )
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g:Merge( Duel.SelectMatchingCard(tp,s.filterSp,tp,e:GetLabel(),0,1,1,nil,e,tp,10000010) )
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g:Merge( Duel.SelectMatchingCard(tp,s.filterSp,tp,e:GetLabel(),0,1,1,nil,e,tp,10000000) )
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)		
	end
end 

