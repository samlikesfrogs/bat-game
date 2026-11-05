@tool
class_name LvlTrans extends Area2D

enum SIDE{LEFT, RIGHT, TOP, BOTTOM}

@export_file("*.tscn") var level
@export var target_transition_area :String = "LevelTransition"
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

func _ready() -> void:
	update_area()
	if Engine.is_editor_hint():
		return
	monitoring = false
	player_pos()
	await RoomManager.room_load_end
	await get_tree().physics_frame
	monitoring = true
	body_entered.connect(on_player_entered)
	

func on_player_entered(player:Node2D):
	print("going here")
	RoomManager.load_level(level, target_transition_area,get_offset())

func player_pos():
	if name != RoomManager.target_transition_area:
		return
	else:
		print("doing player pos?")
		PlayerManager.player_spawn_point(global_position + RoomManager.position_offset)
	
func get_offset()->Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos:Vector2 = PlayerManager.player.global_position
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 8
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 8
		if side == SIDE.TOP:
			offset.y *= -1
	print(offset)
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
	
