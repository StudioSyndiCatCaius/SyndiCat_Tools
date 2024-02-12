-- a selectable player choice
--plays a dialog line
local t={}

t.title="Dialog Line"
t.default={
	text=""
}

t.GetDescription=function(data)
	return data.speaker..": "..data.line
end

t.OnEnter=function(data)
	
end

return t 