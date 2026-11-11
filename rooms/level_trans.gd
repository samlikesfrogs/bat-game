@tool
class_name LvlTrans extends Area2D
var prev_door
var current_door
enum SIDE{LEFT, RIGHT, TOP, BOTTOM}

@export var possible_rooms_right:Array=["res://rooms/room_2.tscn"]
@export var possible_rooms_left:Array=["res://rooms/room_3.tscn"]
@export var possible_rooms_bottom:Array=["res://rooms/room_4.tscn", "res://rooms/room_5.tscn"]
@export var possible_rooms_top:Array=["res://rooms/room_1.tscn"]
var is_return_door:bool = false
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

func _ready() -> void:
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
	update_area()
	if Engine.is_editor_hint():
		return
	monitoring = false
	player_pos()
	await RoomManager.room_load_end
	await get_tree().physics_frame
	monitoring = true
	body_entered.connect(on_player_entered)
	
func on_player_entered(_player:Node2D):
	if is_return_door:
		RoomManager.go_back(target_transition_area,get_offset())
	else:
		RoomManager.load_level(level, target_transition_area,get_offset())

func player_pos():
	if name != RoomManager.target_transition_area:
		return
	else:
		is_return_door = true
		PlayerManager.player_spawn_point(global_position + RoomManager.position_offset)
	
func get_offset()->Vector2:
	var offset : Vector2 = Vector2.ZERO
	var _player_pos:Vector2 = PlayerManager.player.global_position
	match side:
		SIDE.LEFT:
			if not is_return_door and self.level == null:
				self.level = possible_rooms_left.pick_random()
			offset.y = _player_pos.y - global_position.y
			offset.x = -8
		SIDE.RIGHT:
			if not is_return_door and self.level == null:
				self.level = possible_rooms_right.pick_random()
			offset.y = _player_pos.y - global_position.y
			offset.x = 8
		SIDE.TOP:
			if not is_return_door and self.level == null:
				self.level = possible_rooms_top.pick_random()
			offset.x = _player_pos.x - global_position.x
			offset.y = -8
		SIDE.BOTTOM:
			if not is_return_door and self.level == null:
				self.level = possible_rooms_bottom.pick_random()
			offset.x = _player_pos.x - global_position.x
			offset.y = 8
	print(is_return_door, self.side)
	return offset
		
func update_area()-> void:
	var new_rect:Vector2=Vector2(16,16)
	var new_position:Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	if side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
		
	if collision_shape_2d == null:
		collision_shape_2d = get_node("CollisionShape2D")

	collision_shape_2d.shape.size = new_rect
	collision_shape_2d.position = new_position
	
