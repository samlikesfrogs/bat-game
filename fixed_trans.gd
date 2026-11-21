@tool
extends LvlTrans

func _ready() -> void:	
	if RoomManager.current_id != -1:
		# init dict if not present
		if RoomManager.current_id not in RoomManager.room_transitions.keys():
			RoomManager.room_transitions[RoomManager.current_id] = {}
		if side not in RoomManager.room_transitions[RoomManager.current_id].keys():
			RoomManager.room_transitions[RoomManager.current_id][side] = {}

	if Engine.is_editor_hint():
		return
		
	monitoring = false
	player_pos()
	await RoomManager.room_load_end
	await get_tree().physics_frame
	monitoring = true
	body_entered.connect(on_player_entered)
	update_area()
	
func on_player_entered(_player:Node2D):
	if RoomManager.current_id != -1:
		if "id" in RoomManager.room_transitions[RoomManager.current_id][side]:
			var id = RoomManager.room_transitions[RoomManager.current_id][side]["id"]
			RoomManager.load_level(RoomManager.rooms[id], target_transition_area, get_offset(), false, id)
			return
			
	if self.is_return_door:
		RoomManager.go_back(target_transition_area,get_offset())
	else:
		self.is_return_door = true
		if RoomManager.current_id != -1:
			RoomManager.queued_trans_room = get_tree().current_scene.scene_file_path
		
		var opp_side: SIDE
		match side:
			SIDE.LEFT:
				opp_side = SIDE.RIGHT
			SIDE.RIGHT:
				opp_side = SIDE.LEFT
			SIDE.TOP:
				opp_side = SIDE.BOTTOM
			SIDE.BOTTOM:
				opp_side = SIDE.TOP
		RoomManager.load_level(level, target_transition_area, get_offset(), false, -1, opp_side)

func player_pos():
	if self.name != RoomManager.target_transition_area:
		return
	
	if not self.is_return_door:
		self.is_return_door = true
		RoomManager.room_transitions[RoomManager.current_id][side]["return"] = true
	PlayerManager.player_spawn_point(global_position + RoomManager.position_offset)
	
func get_offset()->Vector2:
	var offset : Vector2 = Vector2.ZERO
	var _player_pos:Vector2 = PlayerManager.player.global_position
	match side:
		SIDE.LEFT:
			offset.y = _player_pos.y - global_position.y
			offset.x = -8
		SIDE.RIGHT:
			offset.y = _player_pos.y - global_position.y
			offset.x = 8
		SIDE.TOP:
			offset.x = _player_pos.x - global_position.x
			offset.y = -8
		SIDE.BOTTOM:
			offset.x = _player_pos.x - global_position.x
			offset.y = 8
	return offset
		
func update_area()-> void:
	var new_rect:Vector2=Vector2(16,16)
	var new_position:Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 8
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 8
	if side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 8
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 8
		
	if collision_shape_2d == null:
		collision_shape_2d = get_node("CollisionShape2D")

	collision_shape_2d.shape.size = new_rect
	collision_shape_2d.position = new_position
	
