--Dragonilian Nemeses
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunction(s.filterxyz),4,2,s.filterxyzOV,aux.Stringid(id,0),2,s.xyzop)
	-- destroy (after)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetLabel(1)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetLabel(3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetLabel(4)
	c:RegisterEffect(e4)
	--destroy (before)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.op1)
	e5:SetLabel(5)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_SUMMON)
	e6:SetLabel(6)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON)
	e7:SetLabel(7)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON)
	e8:SetLabel(8)
	c:RegisterEffect(e8)
end
s.attributes = 0
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	print(e:GetLabel()," ",s.attributes)
    s.attributes = s.getAttributesNumber(tp)
    -- e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	print(e:GetLabel()," ",s.getAttributesNumber(tp))
	return (s.getAttributesNumber(tp)>s.attributes) and (s.attributes>0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then Duel.Destroy(g,REASON_EFFECT) end
end

function s.filterxyz(c)
	return c:IsSetCard(0xffd) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.filterxyzOV(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and not c:IsAttribute(ATTRIBUTE_DARK) 
end
function s.xyzop(e,tp,chk)
	if chk~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	return true
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ 
end
function s.filterAtt(c,att)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsAttribute(att)
end
function s.getAttributesNumber(tp)
	local attributes={ATTRIBUTE_WIND,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_DIVINE}
	local count=0
	local att
	for att=1,7 do
		if Duel.IsExistingMatchingCard(s.filterAtt,tp,LOCATION_MZONE,0,1,nil,attributes[att]) then count=count+1 end
	end
	return count
end
