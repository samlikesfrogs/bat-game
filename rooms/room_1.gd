class_name Room extends Node2D
@export var enemy:PackedScene
@export var enemy_count:int = randi_range(2, 6)

func _ready() -> void:
	PlayerManager.set_as_parent(self)
	RoomManager.room_load_start.connect(_free_level)
	MusicManager.play_music(MusicManager.cowboying)
	
func _free_level():
	PlayerManager.unparent_player(self)
	queue_free()
