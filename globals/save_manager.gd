extends Node

const SAVE_PATH = "user://"
signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	enemies_defeated = {},
	rooms = [],
	room_transitions = [],
	prev_id = -1,
	current_id = -1,
	queued_trans_room = "",
	id = 0,
}

func save_game():
	update_player_data()
	update_scene()
	update_inventory()
	var file := FileAccess.open(SAVE_PATH+"save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	print("save pressed")
	pass
	
func get_save_file()->FileAccess:
	return FileAccess.open(SAVE_PATH+"save.sav", FileAccess.READ)
	
func load_game():
	print("load pressed")
	var file := get_save_file()
	var json :=JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	RoomManager.rooms = current_save.rooms
	RoomManager.room_transitions = current_save.room_transitions
	print("passed in", RoomManager.room_transitions)
	RoomManager.load_level(current_save.scene_path, "", Vector2.ZERO, false, RoomManager.current_id)
	await RoomManager.room_load_start
	print(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.player_spawn_point(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	await RoomManager.room_load_end
	for i in range(current_save.items.size()):
		if current_save.items[i]!=null:
			InventoryManager.inventory[i] = current_save.items[i]
			print(InventoryManager.inventory)
		else:
			InventoryManager.inventory[i] = null
	InventoryManager.inventory_updated.emit()

func update_player_data():
	current_save.player.hp = PlayerManager.player.hp
	current_save.player.max_hp = PlayerManager.player.max_hp
	current_save.player.pos_x = PlayerManager.player.global_position.x
	current_save.player.pos_y = PlayerManager.player.global_position.y

func update_scene():
	current_save.prev_id = RoomManager.prev_id
	current_save.current_id = RoomManager.current_id
	current_save.queued_trans_room = RoomManager.queued_trans_room
	current_save.id = RoomManager.id
	current_save.rooms = RoomManager.rooms
	current_save.room_transitions = RoomManager.room_transitions
	current_save.scene_path = get_tree().current_scene.scene_file_path
	if current_save.scene_path == "res://rooms/room_town.tscn":
		pass #reset all room door persistance

func update_inventory():
	current_save.items = InventoryManager.inventory
	
func check_defeated_enemies(room_id: int, id: int) -> bool:
	if room_id in current_save.enemies_defeated:
		return id in current_save.enemies_defeated[room_id]
	return false

func insert_defeated_enemy(room_id: int, id: int) -> void:
	if not room_id in current_save.enemies_defeated:
		current_save.enemies_defeated[room_id] = []
	if not id in current_save.enemies_defeated[room_id]:
		current_save.enemies_defeated[room_id].append(id)
