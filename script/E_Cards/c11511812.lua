--Tribute for the Xerxian
local s,id=GetID()
function s.initial_effect(c)
	-- Ritual Summon
	local e1=Ritual.AddProcGreater({
		handler=c,
		filter=aux.FilterBoolFunction(Card.IsSetCard,0xff7),
	})
end
s.listed_series={0xff7}
