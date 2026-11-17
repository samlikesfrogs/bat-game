extends Node2D

func _ready() -> void:
	#visible = false
	print("in playerspawner")
	if PlayerManager.player_in_scene == false:
		print("playerspawner doin smth")
		PlayerManager.player_spawn_point(self.global_position)
		PlayerManager.player_in_scene = true
