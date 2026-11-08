extends Room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.y_sort_enabled
	PlayerManager.set_as_parent(self)
	RoomManager.room_load_start.connect(_free_level)
	

func _free_level():
	PlayerManager.unparent_player(self)
	queue_free()

func _process(delta: float) -> void:
	pass
