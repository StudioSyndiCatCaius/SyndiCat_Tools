extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dictionary_to_json(dictionary: Dictionary):
	var json_string = JSON.stringify(dictionary)

func json_to_dictionary(json_path: String) -> Dictionary:
	var file = FileAccess.open(json_path,FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		var parsed_data = JSON.parse_string(json_text)
		if parsed_data is Dictionary:
			return parsed_data
		else:
			push_error("JSON file did not contain a dictionary: " + json_path)
	else:
		push_error("Failed to open JSON file: " + json_path)
	return {}

func get_json_list_from_path(path:String) -> PackedStringArray:
	var json_files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		
		for file_name in dir.get_files():
			
			while file_name != "":
				if dir.current_is_dir():
					print("Found directory: " + file_name)
				else:
					#file_name = dir.get_next()
					if file_name.ends_with(".json"):
						json_files.append(path+file_name)
						print("Found file: " + path+file_name)
					file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return json_files
