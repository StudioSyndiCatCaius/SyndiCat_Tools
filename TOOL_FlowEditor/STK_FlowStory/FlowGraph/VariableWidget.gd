extends Control
class_name VariableWidget

var linked_node: Story_FlowNode
var property_index: int

@onready var value_text=$HBoxContainer/MarginContainer/value_text

func _rebuild_widget():
	$HBoxContainer/Label.text=_get_property_name()
	$HBoxContainer/MarginContainer/value_text.text=str(linked_node.NodeProperties.get(_get_property_name(),""))

func _get_property_name() -> String:
	return STK_Utilities.json_to_dictionary(linked_node.NodeTemplate).get("properties","")[property_index]["name"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_edit_text_changed():
	if(linked_node):
		linked_node.NodeProperties[_get_property_name()]=value_text.text
