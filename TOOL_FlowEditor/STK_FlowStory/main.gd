extends Control

@onready var Graph: GraphEdit = $FlowGraph
@onready var NodeTemp = load("res://FlowGraph/FlowNodeBase.tscn")


var NodeData={}

var NodeTypes=[]

func _ready():
	NodeTypes = STK_Utilities.get_json_list_from_path("res://Nodes/")
	menu_graph.clear()
	for i in NodeTypes:
		menu_graph.add_item(STK_Utilities.json_to_dictionary(i)["title"])
	print(NodeTypes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_viewport().gui_get_focus_owner())
	pass


# ==================================================================
# Current Flow
# ==================================================================
func _open_flow(flow):
	pass


# ==================================================================
# Graph
# ==================================================================
func _on_flow_graph_connection_request(from_node, from_port, to_node, to_port):
	# don't connect to an input already conected
	for con in Graph.get_connection_list():
		if con.from_node == from_node and con.from_port == from_port:
			return
	Graph.connect_node(from_node,from_port,to_node,to_port)
	print(Graph.get_connection_list())


func _on_flow_graph_delete_nodes_request(nodes):
	for node in selected_nodes:
		if selected_nodes[node]:
			remove_connections_to_node(node)
			node.queue_free()
	selected_nodes = {}

func _on_flow_graph_disconnection_request(from_node, from_port, to_node, to_port):
	Graph.disconnect_node(from_node, from_port, to_node, to_port)

func remove_connections_to_node(node):
	for con in Graph.get_connection_list():
		if con.to_node == node.name or con.from_node == node.name:
			Graph.disconnect_node(con.from_node, con.from_port, con.to_node, con.to_port)

# ==================================================================
# Node Creation
# ==================================================================
func _on_menu_graph_index_pressed(index):
	_create_new_node(NodeTypes[index])
		

func _create_new_node(template) -> Story_FlowNode:
	#create node
	var NewNode: Story_FlowNode = NodeTemp.instantiate()
	Graph.add_child(NewNode)
	NewNode.position_offset=get_global_mouse_position()
	
	var incoming_template: String
	
	if template is int && NodeTypes[template]:
		incoming_template = NodeTypes[template]
	elif template is String:
		incoming_template=template
		
	if NodeTypes.has(incoming_template):
		NewNode.NodeTemplate=incoming_template
		NewNode._rebuild_node()
	return NewNode

# ==================================================================
# Popup menu: New Node
# ==================================================================
@onready var menu_graph: PopupMenu=$menu_graph

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_1 and event.pressed:
			_create_new_node(0)
		if event.keycode == KEY_2 and event.pressed:
			_create_new_node(1)
		if event.keycode == KEY_3 and event.pressed:
			_create_new_node(2)
		if event.keycode == KEY_4 and event.pressed:
			_create_new_node(3)
		if event.keycode == KEY_5 and event.pressed:
			_create_new_node(4)
		if event.keycode == KEY_6 and event.pressed:
			_create_new_node(5)
	if event is InputEventMouseButton:
		# Open "New Node" menu
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			#menu_graph.visible=true
			menu_graph.position=get_global_mouse_position()
	return

func _on_menu_graph_popup_hide():
	$FlowGraph.grab_focus()

# ==================================================================
# SELECTION
# ==================================================================
var selected_nodes = []

func _on_flow_graph_node_selected(node):
	selected_nodes.push_back(node)
	_refresh_variables()

func _on_flow_graph_node_deselected(node):
	if selected_nodes.has(node):
		selected_nodes.erase(node)
	_refresh_variables()

@onready var VarWidget_temp = load("res://FlowGraph/VariableWidget.tscn")

func _refresh_variables():
	for i in %VariableList.get_children():
		i.queue_free()
	%Label_selectNode.visible=false
	if selected_nodes.size()<=0:
		%Label_selectNode.visible=true
	

	for i: Story_FlowNode in selected_nodes:
		var prop_list=[] 

		prop_list= i._get_template_data().get("properties",[])
		for p in prop_list:
			var property_index: int = prop_list.find(p)
			var new_widget: VariableWidget = VarWidget_temp.instantiate()
			new_widget.linked_node=i
			new_widget.property_index=property_index
			new_widget._rebuild_widget()
			%VariableList.add_child(new_widget)

# ==================================================================
# Save
# ==================================================================

var flow_file_path = "res://Flows/"

# Confirm save file
func _on_file_dialog_save_confirmed():
	var save_path: String = flow_file_path+$Canvas_File/FileDialog_Save.current_path
	_save_flow(save_path)


func _save_flow(path: String):
	var saving_data: Dictionary
	#----------------------------------------------------------------
	# Save data
	
	# save nodes
	var node_list=[]
	for i in $FlowGraph.get_children():
		if i is Story_FlowNode:
			node_list.push_back(i.SAVE_GetData())
	saving_data["nodes"]=node_list
	# save conncetions
	saving_data["connections"]=$FlowGraph.get_connection_list()
	
	#----------------------------------------------------------------
	# APPLY SAVE
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(saving_data))
	print("SAVED TO PATH: " + path)

# ==================================================================
# Load
# ==================================================================

func _on_file_dialog_load_confirmed():
	_load_flow(flow_file_path+$Canvas_File/FileDialog_Load.current_path)

func _load_flow(path: String):
	print(path)
	var loaded_data: Dictionary = STK_Utilities.json_to_dictionary(path)
	var nodes_to_remove = $FlowGraph.get_children()
	
	for i in nodes_to_remove:
		i.queue_free()
	
	# load nodes
	var node_list=loaded_data["nodes"]
	for i in node_list:
		var loaded_node: Story_FlowNode = _create_new_node("")
		loaded_node.SAVE_SetData(i)
		
	
	for i in loaded_data["connections"]:
		$FlowGraph.connect_node(i["from_node"],i["from_port"],i["to_node"],i["to_port"])
		
		
	print(loaded_data)

# ==================================================================
# TOP MENU: File
# ==================================================================
func _on_menu_popup_file_index_pressed(index):
	if index == 1:
		$Canvas_File/FileDialog_Load.visible=true
	if index == 2:
		$Canvas_File/FileDialog_Save.visible=true



