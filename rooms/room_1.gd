class_name Room extends Node2D
@export var opendoors: PackedStringArray

func _ready() -> void:
	PlayerManager.set_as_parent(self)
	RoomManager.room_load_start.connect(_free_level)
	
func _free_level():
	PlayerManager.unparent_player(self)
	queue_free()
