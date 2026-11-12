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
	persistence = [],
	quests = []
}

func save_game():
	update_player_data()
	update_scene()
	var file := FileAccess.open(SAVE_PATH+"save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	print("save pressed")
	pass
	
func load_game():
	print("load pressed")
	var file := FileAccess.open(SAVE_PATH+"save.sav", FileAccess.READ)
	var json :=JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	RoomManager.load_level(current_save.scene_path, "", Vector2.ZERO, false)
	await RoomManager.room_load_start
	PlayerManager.player_spawn_point(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	await RoomManager.room_load_end

func update_player_data():
	current_save.player.hp = PlayerManager.player.hp
	current_save.player.max_hp = PlayerManager.player.max_hp
	current_save.player.pos_x = PlayerManager.player.global_position.x
	current_save.player.pos_y = PlayerManager.player.global_position.y

func update_scene():
	current_save.scene_path = get_tree().current_scene.scene_file_path
	if current_save.scene_path == "res://rooms/room_town.tscn":
		pass #reset all room door persistance
