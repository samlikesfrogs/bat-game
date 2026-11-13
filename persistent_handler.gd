class_name PersistentHandler extends Node

signal data_loaded
var fuckyou = {
	"value" = false,
	"room" = ""
}

func _ready() -> void:
	get_value()
	pass

func set_value():
	print("set", fuckyou["value"])
	SaveManager.add_persistent_value(_get_name())
	pass
	
func get_value():
	fuckyou.value = SaveManager.check_persistent_value(_get_name())
	print("got", fuckyou["value"])
	data_loaded.emit()
	pass
	
func _get_name():
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
