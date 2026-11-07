extends Node

@onready var PLAYER = preload("res://player/player.tscn")

var player:Player
var player_in_scene:bool = false

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout

func add_player_instance()->void:
	player = PLAYER.instantiate()
	get_tree().current_scene.add_child(player)

func player_spawn_point(_new_position:Vector2)->void:
	player.global_position= _new_position

func set_as_parent(_p:Node2D):
		if player.get_parent():
			player.get_parent().remove_child(player)
		_p.add_child(player)
	
func unparent_player(_p:Node2D):
	_p.remove_child(player)
	
