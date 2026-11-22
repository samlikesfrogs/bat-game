extends Control
@onready var save_button: Button = $panel/InfoPanel2/Save
@onready var load_button: Button = $panel/InfoPanel3/Load
@onready var options_button: Button = $panel/InfoPanel4/Options

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerManager.using_controller:
		save_button.grab_focus()
	save_button.mouse_entered.connect(button_mouse_enter.bind(save_button))
	load_button.mouse_entered.connect(button_mouse_enter.bind(load_button))
	options_button.mouse_entered.connect(button_mouse_enter.bind(options_button))
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if get_tree().paused == false:
			pass
		else:
			pass
		get_viewport().set_input_as_handled()


func _on_save_pressed() -> void:
	$panel/InfoPanel3/sfx_click.play()
	if get_tree().paused == false:
		return
	else:
		SaveManager.save_game()

func _on_load_pressed() -> void:
	$panel/InfoPanel3/sfx_click.play()
	if get_tree().paused == false:
		return
	else:
		SaveManager.save_game()
		PlayerManager.player.revive_player()
		RoomManager.load_level("res://load_screen.tscn", "", Vector2.ZERO, false)
		
func button_mouse_enter(_b):
	$panel/InfoPanel3/sfx_hover.play()

func _on_options_pressed() -> void:
	print("options pressed")
	$panel/InfoPanel3/sfx_click.play()
	if get_tree().paused == false:
		return
