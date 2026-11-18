extends Node2D

func _ready() -> void:
	visible = false
	if PlayerManager.player_in_scene == false:
		PlayerManager.player_spawn_point(self.global_position)
		PlayerManager.player_in_scene = true
