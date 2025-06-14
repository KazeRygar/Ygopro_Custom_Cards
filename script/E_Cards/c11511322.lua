--Kairem Warrior Blade
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(s.efilter))
	--equip from grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.eqcon)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--add to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end

function s.efilter(c)
	return c:IsSetCard(0xffc) and c:IsType(TYPE_PENDULUM)
end

function s.eqfilter(c,tp)
	return c:IsSetCard(0xffc) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return eg:FilterCount(s.eqfilter,nil,tp)==1
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:Filter(s.eqfilter,nil,tp):GetFirst()
	if c and c:IsFaceup() then Duel.Equip(tp,e:GetHandler(),c) end
end

function s.dfilter(c)
	return c:IsSetCard(0xffc) and c:IsMonster() and c:IsAbleToHand()
end
function s.con(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return e:GetHandler():GetEquipTarget()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk ==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0xffc)
						and Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_PZONE,0,1,1,nil,0xffc)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetFirstTarget()
	if ec and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		local g=Group.FromCards(e:GetHandler(),tc)
		if Duel.Destroy(g,REASON_COST) then
		    Duel.MoveToField(ec,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		    local g2=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK,0,1,1,nil)
		    if #g2 > 0 then
		    	Duel.SendtoHand(g2,tp,REASON_EFFECT)
		    end
		end
	end
end

