extends Node
var inventory:Array = []
@export var inventory_size:int = 27
@onready var player = PlayerManager.player
signal inventory_updated
signal held_item_changed(new_item)
var dragged_index:int = -1

func _ready():
	inventory.resize(inventory_size)
	
func interact_with_slot(slot_index:int):
	if dragged_index == -1:
		if inventory[slot_index] != null:
			dragged_index = slot_index
			held_item_changed.emit(inventory[slot_index])
			inventory_updated.emit()
	else:
		if dragged_index != slot_index:
			swap_inventory_items(dragged_index, slot_index)
		dragged_index = -1
		held_item_changed.emit(null)
		inventory_updated.emit()
		
func drop_to_world(slot_index:int, drop_position:Vector2):
	if slot_index<0 or slot_index>= inventory.size():
		return
	var item_data = inventory[slot_index]
	if item_data == null:
		return
	drop_item(item_data.duplicate(), drop_position)
	inventory[slot_index] = null
	if dragged_index == slot_index:
		dragged_index = -1
		held_item_changed.emit(null)
	inventory_updated.emit()
	
func add_item(item):
	var has_item:bool = false
	if not get_tree().paused:
		var audio = AudioStreamPlayer.new()
		await get_tree().process_frame
		get_tree().root.add_child(audio)
		audio.stream = preload("res://sound/Cozy SFX Volume 1/UI/ITEM_PICKUP_3.wav")
		audio.play()
	for i in range(inventory.size()):
		if inventory[i]!=null:
			if inventory[i]["name"]==item["name"]:
				has_item = true
	for i in range(inventory.size()):
		if has_item:
			if inventory[i]!=null:
				if inventory[i]["name"]==item["name"]:
					inventory[i]["quantity"]+=item["quantity"]
					return true
		elif inventory[i]==null:
			inventory[i] = item
			return true
	inventory_updated.emit()
	return false
		
func remove_item(item_name):
	for i in range(inventory.size()):
		if inventory[i]!= null and inventory[i]["name"] == item_name:
			inventory[i]["quantity"]-=1
			if inventory[i]["quantity"] <=0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
#func increase_inventory_size():
	#inventory_updated.emit()
	
func swap_inventory_items(index1, index2):
	if (index1 < 0 or index1 >= inventory.size()) or (index2 < 0 or index2 >= inventory.size()):
		return false
	var temp = inventory[index1]
	inventory[index1]=inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true
	
func adjust_drop(position):
	var radius = 30
	var nearby_items = get_tree().get_nodes_in_group("items")
	for item in nearby_items:
		if item.global_position.distance_to(position)<radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position
		
func drop_item(item_data, drop_position):
	var item_instance = preload("res://inventory/inventory_item.tscn").instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop(drop_position)
	get_tree().current_scene.add_child(item_instance)
	item_instance.global_position = drop_position

func cancel_drag():
	if dragged_index!=-1:
		dragged_index = -1
		held_item_changed.emit(null)
		inventory_updated.emit()
		
func is_position_accessible(player_pos:Vector2, target_pos:Vector2):
	var space_state = PlayerManager.player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player_pos, target_pos)
	query.collision_mask = 5
	query.exclude=[PlayerManager.player.get_rid()]
	var result = space_state.intersect_ray(query)
	return result.is_empty()
