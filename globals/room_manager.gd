extends Node

signal room_load_start
signal room_load_end
signal map_limits_update(limits:Array[Vector2])

var current_limits:Array[Vector2]
var target_transition_area:String
var position_offset: Vector2

func _ready() -> void:
	await get_tree().process_frame
	room_load_end.emit()

func update_map_limits(limits:Array[Vector2]) -> void:
	current_limits = limits
	map_limits_update.emit(limits)

func load_level(level_path:String, _target_transition_area:String, _position_offset:Vector2):
	get_tree().paused = true
	target_transition_area = _target_transition_area
	position_offset = _position_offset
	await get_tree().process_frame
	room_load_start.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	await get_tree().process_frame
	get_tree().paused =false
	await get_tree().process_frame
	room_load_end.emit()
	
