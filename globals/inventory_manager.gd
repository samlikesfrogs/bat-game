extends Node
var inventory:Array = []
var inventory_size:int
@onready var player = get_tree().get_first_node_in_group("player")
signal inventory_updated
var hotbar_inventory = []

func _ready():
	inventory.resize(27)
	hotbar_inventory.resize(5)
	
func add_item(item):
	for i in range(inventory.size()):
		if inventory[i]!=null and inventory[i]["name"]==item["name"]:
			inventory[i]["quantity"]+=item["quantity"]
			inventory_updated.emit()
			print("item added", inventory)
			return true
		elif inventory[i]==null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false
		
func remove_item(item_name):
	print(item_name)
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item_name:
			print(inventory[i])
			inventory[i]["quantity"]-=1
			if inventory[i]["quantity"] <=0:
				inventory[i] = null
			inventory_updated.emit()
			return true
		return false
	
func increase_inventory_size():
	inventory_updated.emit()
	
func swap_inventory_items(index1, index2):
	if (index1 < 0 or index1 > inventory.size()) or (index2 < 0 or index2 > inventory.size()):
		return false
	var temp = inventory[index1]
	inventory[index1]=inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true
	
func adjust_drop(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("items")
	for item in nearby_items:
		if item.global_position.distance_to(position)<radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position
		
func drop_item(item_data, drop_position):
	var item_instance = preload("res://inventory_item.tscn").instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop(drop_position)
	get_tree().current_scene.add_child(item_instance)
	item_instance.global_position = drop_position
