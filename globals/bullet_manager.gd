extends Node2D
@onready var BULLET = preload("res://bullet/bullet.tscn")
var bullet

func _ready() -> void:
	PlayerManager.player.shoot.connect(_on_player_shoot)

func _on_player_shoot(pos, dir) -> void:
	bullet = BULLET.instantiate()
	bullet.position = pos
	bullet.direction = dir
	add_child(bullet)
	bullet.add_to_group("bullets")
