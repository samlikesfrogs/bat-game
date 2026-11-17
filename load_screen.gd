extends Node2D
@onready var new_game_button: Button = $CanvasLayer/Control/new_game
@onready var continue_button: Button = $CanvasLayer/Control/continue
const START_LEVEL:String = "res://rooms/room_town.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	DifferentName.visible = false
	PlayerManager.set_as_parent(self)
	if SaveManager.get_save_file() == null:
		continue_button.disabled = true
		continue_button.visible = false
	RoomManager.room_load_start.connect(_free_load_screen)
	setup_load_screen()
	
func _free_load_screen():
	PlayerManager.unparent_player(self)
	await ($sfx_click.finished)
	queue_free()

func setup_load_screen():
	PlayerManager.set_as_parent(self)
	new_game_button.mouse_entered.connect(button_mouse_enter.bind(new_game_button))
	continue_button.mouse_entered.connect(button_mouse_enter.bind(continue_button))
	MusicManager.play_music(MusicManager.menu)
	new_game_button.pressed.connect(new_game)
	continue_button.pressed.connect(continue_game)
	if PlayerManager.using_controller:
		new_game_button.grab_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	PlayerManager.player.inventory_ui.process_mode = Node.PROCESS_MODE_DISABLED
	

func new_game():
	$sfx_click.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
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
	
func button_mouse_enter(_b:Button):
	$sfx_hover.play()
