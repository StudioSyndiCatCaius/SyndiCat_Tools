--plays a dialog line
local t={}

--fields
t.title="Dialog Line"
t.default={
	speaker="",
	line="",
	expression="",
}


--scripts
t.GetDescription=function(data)
	return data.speaker..": "..data.line
end

t.OnEnter=function(data)
	
end

return t 