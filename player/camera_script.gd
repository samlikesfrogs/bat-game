class_name PlayerCam extends Camera2D


func _ready() -> void:
	RoomManager.map_limits_update.connect(make_limits)
	make_limits(RoomManager.current_limits)

func make_limits(limits:Array[Vector2])->void:
	limit_left = int(limits[0].x + 18)
	limit_top = int(limits[0].y + 18)
	limit_right = int(limits[1].x - 18)
	limit_bottom = int(limits[1].y - 18)
	
