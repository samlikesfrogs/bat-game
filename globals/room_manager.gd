extends Node

signal room_load_start
signal room_load_end
signal map_limits_update(limits:Array[Vector2])
var room_history:Array = []
var current_limits:Array[Vector2]
var target_transition_area:String
var position_offset: Vector2
var previous

func _ready() -> void:
	await get_tree().process_frame
	room_load_end.emit()

func update_map_limits(limits:Array[Vector2]) -> void:
	current_limits = limits
	map_limits_update.emit(limits)

func load_level(level_path, _target_transition_area:String, _position_offset:Vector2, go_back_called:bool):
	get_tree().paused = true
	previous = get_tree().current_scene.scene_file_path
	room_history.append(previous)
	print(previous)
	print("load", room_history)
	target_transition_area = _target_transition_area
	position_offset = _position_offset
	await SceneTransUi.fade_in()
	room_load_start.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	get_tree().paused =false
	await get_tree().process_frame
	room_load_end.emit()
	await SceneTransUi.fade_out()

func go_back(_target_transition_area:String, _position_offset:Vector2):
	var _temp_trans = _target_transition_area
	var _temp_offset = _position_offset
	if room_history.size()>0:
		previous = room_history.pop_back()
	print("goback", room_history)
	load_level(previous, _temp_trans, _temp_offset, true)
	
