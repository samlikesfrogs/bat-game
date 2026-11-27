@tool
class_name LvlTrans extends Area2D
enum SIDE{LEFT, RIGHT, TOP, BOTTOM}

var possible_rooms_right:Array=["res://rooms/room_ld_0.tscn", "res://rooms/room_lr_0.tscn", "res://rooms/room_lu_0.tscn","res://rooms/room_ldu_0.tscn"]
var possible_rooms_left:Array=["res://rooms/room_lr_0.tscn", "res://rooms/room_rd_0.tscn", "res://rooms/room_ru_0.tscn"]
var possible_rooms_bottom:Array=["res://rooms/room_ud_0.tscn", "res://rooms/room_ru_0.tscn", "res://rooms/room_lu_0.tscn","res://rooms/room_ldu_0.tscn"]
var possible_rooms_top:Array=["res://rooms/room_ud_0.tscn","res://rooms/room_ld_0.tscn", "res://rooms/room_rd_0.tscn","res://rooms/room_ldu_0.tscn"]
@export var is_return_door:bool = false
@export_file("*.tscn") var level
@export var target_transition_area :String
@export_range(1,12,1, "or_greater") var size:int = 2:
	set(value):
		size = value
		update_area()
@export var side:SIDE = SIDE.LEFT:
	set(value):
		side = value
		update_area()
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var position_offset:Vector2 = Vector2.ZERO
var i:int = 0
var end:bool =  false
var leftcount:int = 0
var rightcount:int = 0
var upcount:int = 0
var downcount:int = 0

func _ready() -> void:
	if not RoomManager.room_transitions.has(RoomManager.current_id):
		self.level = null
	match self.name:
		"EnterLeft":
			target_transition_area = "ExitRight"
		"EnterTop":
			target_transition_area = "ExitBottom"
		"ExitRight":
			target_transition_area = "EnterLeft"
		"ExitBottom":
			target_transition_area = "EnterTop"
		_:
			print("shit fuck what the hell")
			
	if Engine.is_editor_hint():
		return
		
	if RoomManager.current_id == -1:
		await get_tree().process_frame
	if RoomManager.current_id != -1:
		if not RoomManager.room_transitions.has(RoomManager.current_id):
			RoomManager.room_transitions[RoomManager.current_id] = {}
		if not RoomManager.room_transitions[RoomManager.current_id].has(side):
			RoomManager.room_transitions[RoomManager.current_id][side] =  {}
		if RoomManager.room_transitions[RoomManager.current_id][side].has("level"):
			self.level = RoomManager.room_transitions[RoomManager.current_id][side]["level"]
			#self.is_return_door = true
			
		elif (self.level == null) and not self.is_return_door:
			var possible_rooms:Array = []
			var boss_room:String = ""
			var dead_end:String = ""
			var count:int = 0
			
			match side:
				SIDE.LEFT:
					possible_rooms = possible_rooms_left
					boss_room = "res://rooms/room_r_end.tscn"
					dead_end = "res://rooms/room_r_0.tscn"
				SIDE.RIGHT:
					possible_rooms = possible_rooms_right
					boss_room = "res://rooms/room_l_end.tscn"
					dead_end = "res://rooms/room_l_0.tscn"
				SIDE.TOP:
					possible_rooms = possible_rooms_top
					boss_room = "res://rooms/room_d_end.tscn"
					dead_end = "res://rooms/room_d_0.tscn"
				SIDE.BOTTOM:
					possible_rooms = possible_rooms_bottom
					boss_room = "res://rooms/room_u_end.tscn"
					dead_end = "res://rooms/room_u_0.tscn"
			for i in RoomManager.rooms.size():
				if RoomManager.rooms[i] in possible_rooms:
					count += 1
			if count >= 2:
				if not RoomManager.boss_room_exists:
					self.level = boss_room
					RoomManager.boss_room_exists = true
				else:
					self.level = dead_end
			else:
				self.level = possible_rooms.pick_random()
			RoomManager.room_transitions[RoomManager.current_id][side]["level"] = self.level	

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
		RoomManager.go_back(target_transition_area, get_offset())
	else:
		self.is_return_door = true
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
		RoomManager.load_level(level, target_transition_area, get_offset(), false, -1, opp_side, side)

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
	
