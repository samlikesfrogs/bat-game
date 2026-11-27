extends Node2D
@onready var new_game_button: Button = $CanvasLayer/Control/new_game
@onready var continue_button: Button = $CanvasLayer/Control/continue
@onready var options_button: Button = $CanvasLayer/Control/options
@onready var quit_button: Button = $CanvasLayer/Control/quit
const START_LEVEL:String = "res://rooms/room_town.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.set_as_parent(self)
	get_tree().paused = true
	DifferentName.visible = false
	if SaveManager.get_save_file() == null:
		continue_button.disabled = true
		continue_button.visible = false
	RoomManager.room_load_start.connect(_free_load_screen)
	setup_load_screen()
	
func _free_load_screen():
	InventoryManager.process_mode = Node.PROCESS_MODE_ALWAYS
	PlayerManager.unparent_player(self)
	await ($sfx_click.finished)
	queue_free()

func setup_load_screen():
	if get_tree().current_scene.scene_file_path != "res://load_screen.tscn":
		get_tree().change_scene_to_file("res://load_screen.tscn")
	DifferentName.visible = false
	PlayerManager.set_as_parent(self)
	new_game_button.mouse_entered.connect(button_mouse_enter.bind(new_game_button))
	continue_button.mouse_entered.connect(button_mouse_enter.bind(continue_button))
	options_button.mouse_entered.connect(button_mouse_enter.bind(options_button))
	quit_button.mouse_entered.connect(button_mouse_enter.bind(quit_button))
	MusicManager.play_music(MusicManager.menu)
	new_game_button.pressed.connect(new_game)
	continue_button.pressed.connect(continue_game)
	options_button.pressed.connect(show_options)
	quit_button.pressed.connect(quit_game)
	if PlayerManager.using_controller:
		new_game_button.grab_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	PlayerManager.player.inventory_ui.process_mode = Node.PROCESS_MODE_DISABLED
	InventoryManager.process_mode = Node.PROCESS_MODE_DISABLED
	

func new_game():
	$sfx_click.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	RoomManager.prev_id = -1
	RoomManager.current_id = -1
	RoomManager.id = 0
	RoomManager.rooms = {}
	RoomManager.room_transitions = {}
	PlayerManager.player_spawn_point(Vector2(283.0, -25.0))
	PlayerManager.set_health(12, 12)
	SaveManager.current_save["enemies_defeated"] = {}
	for i in InventoryManager.inventory.size():
		InventoryManager.inventory[i] = null
	SaveManager.save_game()
	RoomManager.load_level(START_LEVEL, "", Vector2.ZERO, false)
	await RoomManager.room_load_start
	PlayerManager.player.inventory_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	DifferentName.visible = true
	pass

func continue_game():
	$sfx_click.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	SaveManager.load_game()
	await RoomManager.room_load_start
	PlayerManager.player.inventory_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	DifferentName.visible = true
	pass

func show_options():
	print("options pressed")
	$sfx_click.play()

func quit_game():
	get_tree().quit()
	
func button_mouse_enter(_b:Button):
	$sfx_hover.play()
