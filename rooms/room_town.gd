extends Room

func _ready() -> void:
	PlayerManager.set_as_parent(self)
	RoomManager.room_load_start.connect(_free_level)
	MusicManager.play_music(MusicManager.town)
	
func _free_level():
	PlayerManager.unparent_player(self)
	queue_free()
