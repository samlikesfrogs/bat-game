extends Node
var inventory:Array = []
var inventory_size:int
@onready var player = get_tree().get_first_node_in_group("player")
signal inventory_updated

func _ready():
	inventory_size = 30
	inventory.resize(inventory_size)
	
func add_item(item):
	print("no", inventory)
	for i in range(inventory.size()):
		if inventory[i]!=null and inventory[i]["type"]==item["type"]:
			inventory[i]["quantity"]+=item["quantity"]
			inventory_updated.emit()
			print("item added", inventory)
			return true
			print(inventory)
		elif inventory[i]==null:
			print("i go here")
			inventory[i] = item
			inventory_updated.emit()
			print("yes", inventory)
			return true
		return false
		
func remove_item(item):
	inventory_updated.emit()
	
func increase_inventory_size():
	inventory_updated.emit()
