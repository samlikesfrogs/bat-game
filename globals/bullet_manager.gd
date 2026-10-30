extends Node2D
@onready var BULLET = preload("res://bullet/bullet.tscn")

func _ready() -> void:
	get_tree().get_first_node_in_group("player").shoot.connect(_on_player_shoot)

func _on_player_shoot(pos, dir) -> void:
	var bullet = BULLET.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir
	bullet.add_to_group("bullets")
