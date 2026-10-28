extends Node2D
@onready var sfx_attack: AudioStreamPlayer2D = $sfx_attack
@export var bullet_scene:PackedScene


func _on_player_shoot(pos, dir) -> void:
	sfx_attack.play()
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir
	bullet.add_to_group("bullets")
