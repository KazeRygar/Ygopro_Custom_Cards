--Kairem Soul
local s,id=GetID()
function s.initial_effect(c)
	-- Place Pendulum 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	e1:SetLabel(LOCATION_DECK)
	c:RegisterEffect(e1)
	--Place Fusion/Synchro/Xyz Pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	e2:SetLabel(LOCATION_EXTRA)
	c:RegisterEffect(e2)

end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.filterD(c,loc)
	if loc==LOCATION_DECK then
		return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc)
	else
		return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)  and c:IsPosition(POS_FACEUP)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.filterD,tp,e:GetLabel(),0,1,nil,e:GetLabel()) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filterD,tp,e:GetLabel(),0,1,1,nil,e:GetLabel())
	if #g>0 then
	    Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
