extends Control
@onready var grid_container: GridContainer = $GridContainer
@onready var inventory_slot_scene = preload("res://inventory_slot.tscn")
var dragged_slot = null
@export var joystick_sensitivity: float = 400.0
@export var joy_device: int = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	get_viewport().warp_mouse(Vector2(9,7))
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	if PlayerManager.player.using_controller and get_tree().paused == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var input_vector := Input.get_vector(
			"left", "right", "up", "down")
		if input_vector != Vector2.ZERO:
			var current_pos = get_viewport().get_mouse_position()
			var new_pos = get_viewport().get_mouse_position() + (input_vector * joystick_sensitivity * delta)
			get_viewport().warp_mouse(new_pos)
	elif get_tree().paused == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_inventory_updated():
	clear_grid()
	for item in InventoryManager.inventory:
		var slot = inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.drag_start.connect(on_drag_start)
		slot.drag_end.connect(on_drag_end)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
	pass

func clear_grid():
	while grid_container.get_child_count()>0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
		
func on_drag_start(slot_control:Control):
	dragged_slot = slot_control
	
func on_drag_end():
	var target_slot = get_hovered_slot()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	elif dragged_slot != target_slot:
		print("this is true for some reason")
		var drop_position = PlayerManager.player.global_position
		var drop_offset = Vector2(50,0)
		drop_offset = drop_offset.rotated((PlayerManager.player.cardinal_dir).angle())
		InventoryManager.drop_item(dragged_slot.item, drop_position + drop_offset)
		InventoryManager.remove_item(dragged_slot.item["name"])
	dragged_slot = null
	
func get_hovered_slot() ->Control:
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func get_slot_index(slot:Control)->int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot:
			return i
	return -1
	
func drop_slot(slot1:Control, slot2:Control):
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	if slot1_index == -1:
		return
	else:
		if InventoryManager.swap_inventory_items(slot1_index, slot2_index) == true:
			_on_inventory_updated()
	
