--Dragonilian Ouza
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunction(s.filterxyz),4,2,s.filterxyzOV,aux.Stringid(id,0),2,s.xyzop)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filterSP(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xffd) 
	and Duel.IsExistingMatchingCard(s.filterD,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filterSP,1,nil,tp)
end
function s.filterD(c,att)
	return c:IsFaceup() and c:IsDestructable() and c:IsAttribute(att)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filterSP,1,nil,tp) end
	local g=eg:Filter(s.filterSP,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttribute())
	local dg=Duel.GetMatchingGroup(s.filterD,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	local dg=Duel.GetMatchingGroup(s.filterD,tp,0,LOCATION_MZONE,nil,att)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function s.filterxyz(c)
	return c:IsSetCard(0xffd) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.filterxyzOV(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and not c:IsAttribute(ATTRIBUTE_FIRE) 
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
