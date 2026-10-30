extends Control
@onready var grid_container: GridContainer = $GridContainer
@onready var inventory_slot_scene = preload("res://inventory_slot.tscn")
func _ready() -> void:
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _on_inventory_updated():
	clear_grid()
	for item in InventoryManager.inventory:
		var slot = inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
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
