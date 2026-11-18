extends Control
@onready var grid_container: GridContainer = $GridContainer
@onready var inventory_slot_scene = load("res://inventory/inventory_slot.tscn")
var dragged_slot:Control = null

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	PlayerManager.player.inventory_opened.connect(_on_inventory_updated)
	_on_inventory_updated()

func _process(delta: float) -> void:
	if get_tree().paused:
		print("Focused node: ", get_viewport().gui_get_focus_owner())
	if get_tree().paused and not PlayerManager.using_controller:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_inventory_updated():
	var previous_focus_index := 0
	var current_focused = _get_focused_slot()
	if current_focused !=null:
		previous_focus_index = current_focused.get_index()
	dragged_slot = null
	clear_grid()
	for i in range(InventoryManager.inventory.size()):
		var item = InventoryManager.inventory[i]
		var slot = inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.slot_clicked.connect(_on_slot_clicked)
		slot.slot_released.connect(_on_slot_released)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
	if grid_container.get_child_count()>0:
		grid_container.get_child(previous_focus_index).grab_focus()

func clear_grid():
		while grid_container.get_child_count()>0:
			var child = grid_container.get_child(0)
			grid_container.remove_child(child)
			child.queue_free()
		pass
	
func get_hovered_slot() ->Control:
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func _get_focused_slot()->Control:
	var focused = get_viewport().gui_get_focus_owner()
	if focused == null:
		return null
	for slot in grid_container.get_children():
		if slot == focused or slot.is_ancestor_of(focused):
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
	if slot1_index != -1 and slot2_index != -1:
		if InventoryManager.swap_inventory_items(slot1_index, slot2_index) == true:
			_on_inventory_updated()
			
func _on_slot_clicked(slot:Control):
	if dragged_slot == null:
		if slot.item != null:
			dragged_slot = slot
			dragged_slot.modulate.a = 0.4
	else:
		if dragged_slot!=slot:
			InventoryManager.swap_inventory_items(dragged_slot.get_index(), slot.get_index())
		else:
			dragged_slot.modulate.a = 1.0
			dragged_slot = null
				
func _on_slot_released(slot:Control):
	if dragged_slot == null:
		return
	var target_slot = get_hovered_slot()
	if target_slot != null and target_slot != dragged_slot:
		InventoryManager.swap_inventory_items(dragged_slot.get_index(), target_slot.get_index())
	elif target_slot == null:
		drop_outside(dragged_slot)
		dragged_slot = null
		
func drop_outside(slot_to_drop:Control):
	if slot_to_drop.item == null:
		return
	var drop_position = PlayerManager.player.global_position
	var drop_offset = Vector2(25, 0).rotated(PlayerManager.player.cardinal_dir.angle())
	InventoryManager.drop_to_world(slot_to_drop.get_index(), drop_position+drop_offset)
	
func _unhandled_input(event: InputEvent) -> void:
	if not visible or not get_tree().paused:
		return
	if event.is_action_pressed("drop item"):
		var target = dragged_slot if dragged_slot != null else _get_focused_slot()
		if target != null and target.item != null:
			drop_outside(target)
			dragged_slot = null
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel") or event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_RIGHT and event.pressed):
		if dragged_slot!=null:
			dragged_slot.modulate.a = 1.0
			dragged_slot = null
			get_viewport().set_input_as_handled()
