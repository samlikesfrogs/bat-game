extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	if PlayerManager.player_in_scene == false:
		PlayerManager.player_spawn_point(global_position)
		PlayerManager.player_in_scene = true
