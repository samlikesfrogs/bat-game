extends Node

signal room_load_start
signal room_load_end
signal map_limits_update(limits:Array[Vector2])
var rooms := {}
var room_transitions := {}
var current_limits:Array[Vector2]
var target_transition_area:String
var position_offset: Vector2
var prev_id: int = -1
var current_id: int = -1
var queued_trans_room := ""
var id: int = 0

func _ready() -> void:
	await get_tree().process_frame
	room_load_end.emit()

func update_map_limits(limits:Array[Vector2]) -> void:
	current_limits = limits
	map_limits_update.emit(limits)

func load_level(level_path, _target_transition_area:String, _position_offset:Vector2, _go_back_called:bool, room_id := -1, trans_dir := -1):
	prev_id = current_id
	current_id = room_id if room_id != -1 else id
	
	get_tree().paused = true
	target_transition_area = _target_transition_area
	position_offset = _position_offset
	await SceneTransUi.fade_in()
	room_load_start.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	get_tree().paused =false
	
	await get_tree().process_frame

	# when generating new room
	if room_id == -1:
		rooms[id] = get_tree().current_scene.scene_file_path
		if prev_id != -1 and trans_dir != -1:
			if queued_trans_room != "":
				room_transitions[id][trans_dir]["level"] = queued_trans_room
				queued_trans_room = ""
				
			room_transitions[id][trans_dir]["id"] = prev_id
		
		id += 1
	
	await get_tree().process_frame
	room_load_end.emit()
	await SceneTransUi.fade_out()
	

func go_back(_target_transition_area:String, _position_offset:Vector2):
	var _temp_trans = _target_transition_area
	var _temp_offset = _position_offset
	var previous = rooms[prev_id]
	load_level(previous, _temp_trans, _temp_offset, true, prev_id)
	
