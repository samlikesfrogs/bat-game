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
	print("save pressed")
	pass
	
func load_game():
	print("load pressed")
	pass
