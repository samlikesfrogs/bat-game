class_name RoomBase extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RoomManager.update_map_limits(get_limits())
	print("roombase doing")

func get_limits() -> Array[Vector2]:
	var limits:Array[Vector2] = []
	limits.append(Vector2(get_used_rect().position * 16)) 
	print(Vector2(get_used_rect().position * 16))
	limits.append(get_used_rect().end * 16)
	print(Vector2(get_used_rect().end * 16))
	return limits
