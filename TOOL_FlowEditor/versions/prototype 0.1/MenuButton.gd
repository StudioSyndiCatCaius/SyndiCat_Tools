extends Button

@export var popup_menu_path: NodePath
@onready var popup_menu: PopupMenu = get_node(popup_menu_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if popup_menu:
		popup_menu.visible=true
