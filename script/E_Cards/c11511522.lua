--Vortex Triumph
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,11511509,aux.FilterBoolFunction(s.filterF))
	--Inflict Grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.con)
	e1:SetLabel(LOCATION_GRAVE)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Inflict Field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11511510,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabel(LOCATION_MZONE)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_FIRE)
end
function s.filter(c)
	return c:IsSetCard(0xffa) and c:IsMonster() and c:IsFaceup()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION 
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d=Duel.GetMatchingGroup(s.filter,tp,e:GetLabel(),0,nil):GetClassCount(Card.GetRace)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroup(s.filter,tp,e:GetLabel(),0,nil):GetClassCount(Card.GetRace)*200
	Duel.Damage(p,d,REASON_EFFECT)
end