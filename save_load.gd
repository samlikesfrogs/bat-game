extends Control
@onready var save_button: Button = $panel/InfoPanel2/Save
@onready var load_button: Button = $panel/InfoPanel3/Load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_button.grab_focus()
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if get_tree().paused == false:
			pass
		else:
			pass
		get_viewport().set_input_as_handled()


func _on_save_pressed() -> void:
	if get_tree().paused == false:
		return
	else:
		print("bro go")
		SaveManager.save_game()


func _on_load_pressed() -> void:
	if get_tree().paused == false:
		return
	else:
		print("bro go")
		SaveManager.load_game()
