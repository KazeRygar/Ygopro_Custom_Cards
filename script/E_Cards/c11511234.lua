--Dragonilian Bluerage
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunction(s.filterxyz),4,2,s.filterxyzOV,aux.Stringid(id,0),2,s.xyzop)
	--summon 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	c:RegisterEffect(e2)
	
end
function s.cfilter(c,tp)
	return c:IsSetCard(0xffd) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and c:IsMonster()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0
					 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
					 and Duel.IsPlayerCanSpecialSummonMonster(tp,11511247,0,TYPES_TOKEN,1000,2000,4,RACE_DRAGON,0xffff)   end
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,11511247,0,TYPES_TOKEN,1000,2000,4,RACE_DRAGON,0xffff) then
		local g=eg:Filter(s.cfilter,nil,tp)
		if not g or #g==0 then return end
		local tc
		if #g==1 then tc=g:GetFirst()
		else tc=g:Select(tp,1,1,nil):GetFirst() end

		local token=Duel.CreateToken(tp,11511247)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(tc:GetAttribute())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(tc:GetBaseAttack())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(tc:GetBaseDefense())
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3)
	end
end
function s.filterxyz(c)
	return c:IsSetCard(0xffd) and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.filterxyzOV(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and not c:IsAttribute(ATTRIBUTE_WATER) 
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
