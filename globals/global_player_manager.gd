extends Node

@onready var PLAYER = preload("res://player/player.tscn")

var player:Player
var player_in_scene:bool = false
var using_controller: bool = false
var connected_joypads = []

func _ready() -> void:
	connected_joypads = Input.get_connected_joypads()
	if connected_joypads.size() > 0:
		using_controller = true
	else:
		using_controller = false
	add_player_instance()
	await get_tree().create_timer(0.2).timeout

func add_player_instance()->void:
	player = PLAYER.instantiate()
	get_tree().current_scene.add_child(player)

func set_health(hp:int, max_hp:int):
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp(0)
	
func player_spawn_point(_new_position:Vector2):
	print("doing this", _new_position)
	player.global_position= _new_position
	print("pos", player.global_position)

func set_as_parent(_p:Node2D):
		if player.get_parent():
			player.get_parent().remove_child(player)
		_p.add_child(player)
	
func unparent_player(_p:Node2D):
	_p.remove_child(player)
	player_in_scene = false
	
