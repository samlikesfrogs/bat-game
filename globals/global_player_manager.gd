extends Node

@onready var PLAYER = preload("res://player/player.tscn")
var player:Player
var player_in_scene:bool = false

func _ready() -> void:
	add_player_instance()

func add_player_instance()->void:
	player = PLAYER.instantiate()
	get_tree().current_scene.add_child(player)
	pass

func player_spawn_point(_new_position:Vector2)->void:
	player.global_position= _new_position
