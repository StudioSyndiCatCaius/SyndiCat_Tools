extends GraphNode
class_name Story_FlowNode

@export var NodeTemplate=""
var NodeProperties={}

# Called when the node enters the scene tree for the first time.
func _ready():
	name=str(randi_range(0,9999999))
	print(name)
	_rebuild_node()

func _rebuild_node():
	title=_get_template_data().get("title","Empty Node")
	if _get_template_data().get("utility",false):
		self_modulate=Color.BROWN
		
	# add inputs/outputs
	var input_list: PackedStringArray = _get_template_data().get("input",[""])
	for i in input_list:
		set_slot_enabled_left(input_list.find(i),true)
	
	var output_list: PackedStringArray = _get_template_data().get("output",[""])
	for i in output_list:
		set_slot_enabled_right(output_list.find(i),true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_template_data() -> Dictionary:
	return STK_Utilities.json_to_dictionary(NodeTemplate)


func _on_position_offset_changed():
	pass

func SAVE_SetData(data: Dictionary):
	name=data.get("id",randi_range(0,9999999))
	position_offset.x=data.get("position_x",0)
	position_offset.y=data.get("position_y",0)
	NodeTemplate=data.get("template","")
	NodeProperties=data.get("properties",{})
	_rebuild_node()

func SAVE_GetData()-> Dictionary:
	var out_data={}
	out_data["id"]=name
	out_data["position_x"]=position_offset.x
	out_data["position_y"]=position_offset.y
	out_data["template"]=NodeTemplate
	out_data["properties"]=NodeProperties
	return out_data
