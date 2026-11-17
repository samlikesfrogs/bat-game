extends Control
@onready var save_button: Button = $panel/InfoPanel2/Save
@onready var load_button: Button = $panel/InfoPanel3/Load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerManager.using_controller:
		save_button.grab_focus()
	save_button.mouse_entered.connect(button_mouse_enter.bind(save_button))
	load_button.mouse_entered.connect(button_mouse_enter.bind(load_button))
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
		SaveManager.load_game()
		
func button_mouse_enter(_b):
	$panel/InfoPanel3/sfx_hover.play()
