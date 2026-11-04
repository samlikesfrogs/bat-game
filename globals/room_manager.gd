extends Node

var current_limits:Array[Vector2]
signal map_limits_update(limits:Array[Vector2])

func update_map_limits(limits:Array[Vector2]) -> void:
	current_limits = limits
	map_limits_update.emit(limits)
