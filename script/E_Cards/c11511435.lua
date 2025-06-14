--SW Ally Guan Yu
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffb),1,1,Synchro.NonTunerEx(Card.IsCode,11511417),1,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--battle destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)

end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function s.mgfilter(c,e,tp,sc,mg,to)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),REASON_SYNCHRO)==REASON_SYNCHRO and c:GetReasonCard()==sc
		and ( (to==LOCATION_HAND and c:IsAbleToHand() ) or (to==LOCATION_MZONE and c:IsCanBeSpecialSummoned(e,0,tp,false,false) ) )
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	mg=mg:Filter(aux.NecroValleyFilter(c11511433.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	mg=mg:Filter(aux.NecroValleyFilter(s.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_MZONE)
	if mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if mg:GetCount()>1 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			mg=mg:Select(tp,1,1,nil)
		end
		if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP) then 
			mg=e:GetHandler():GetMaterial()
			mg=mg:Filter(aux.NecroValleyFilter(c11511433.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_HAND)
			if mg:GetCount()>0 then
				Duel.SendtoHand(mg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,mg)
			end
		end
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
