extends Control
class_name VariableWidget

var linked_node: Story_FlowNode
var property_index: int

@onready var value_text: TextEdit= $HBoxContainer/MarginContainer/value_text
@onready var value_line: TextEdit = $HBoxContainer/MarginContainer/value_line
@onready var value_code: CodeEdit = $HBoxContainer/MarginContainer/value_code
@onready var value_int: SpinBox = $HBoxContainer/MarginContainer/value_int
@onready var value_float: SpinBox = $HBoxContainer/MarginContainer/value_float
@onready var value_bool: CheckBox = $HBoxContainer/MarginContainer/value_bool

func _ready():
	value_text = $HBoxContainer/MarginContainer/value_text
	value_line = $HBoxContainer/MarginContainer/value_line
	value_code = $HBoxContainer/MarginContainer/value_code

func _rebuild_widget():
	$HBoxContainer/Label.text=_get_property_name()
	var incoming_value=linked_node.NodeProperties.get(_get_property_name(),"")
	
	#set typr
	var local_type: String = (_get_property_data().get("type","line"))
	
	for i in $HBoxContainer/MarginContainer.get_children():
		i.visible=false
	
	if local_type == "text":
		$HBoxContainer/MarginContainer/value_text.visible=true
		$HBoxContainer/MarginContainer/value_text.text=str(incoming_value)
	if local_type == "line":
		$HBoxContainer/MarginContainer/value_line.visible=true
		$HBoxContainer/MarginContainer/value_line.text=str(incoming_value)
	if local_type == "code":
		$HBoxContainer/MarginContainer/value_code.visible=true
		$HBoxContainer/MarginContainer/value_code.text=str(incoming_value)
	if local_type == "int":
		$HBoxContainer/MarginContainer/value_int.visible=true
		if incoming_value is int:
			$HBoxContainer/MarginContainer/value_int.value=incoming_value
	if local_type == "bool":
		$HBoxContainer/MarginContainer/value_bool.visible=true
		if incoming_value is bool:
			$HBoxContainer/MarginContainer/value_bool.button_pressed=incoming_value
	if local_type == "float":
		$HBoxContainer/MarginContainer/value_float.visible=true
		if incoming_value is float:
			$HBoxContainer/MarginContainer/value_float.value=incoming_value

func _get_property_name() -> String:
	return _get_property_data()["name"]

func _get_property_data():
	return STK_Utilities.json_to_dictionary(linked_node.NodeTemplate).get("properties","")[property_index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## UPDATE PROPERTY
func _on_text_edit_text_changed():
	if(linked_node):
		linked_node.NodeProperties[_get_property_name()]=value_text.text

func _on_value_line_text_changed():
	if(linked_node):
		linked_node.NodeProperties[_get_property_name()]=value_line.text

func _on_value_code_text_changed():
	if(linked_node):
		linked_node.NodeProperties[_get_property_name()]=value_code.text

func _on_value_int_value_changed(value):
	if(linked_node):
		linked_node.NodeProperties[_get_property_name()]=value

func _on_value_bool_toggled(toggled_on):
	if(linked_node):
		linked_node.NodeProperties[_get_property_name()]=toggled_on
