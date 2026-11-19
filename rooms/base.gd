class_name RoomBase extends TileMapLayer

func _ready() -> void:
	RoomManager.update_map_limits(get_limits())

func get_limits() -> Array[Vector2]:
	var limits:Array[Vector2] = []
	limits.append(Vector2(get_used_rect().position * 16)) 
	limits.append(get_used_rect().end * 16)
	return limits
