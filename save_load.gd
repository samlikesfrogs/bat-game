extends Control
@onready var save_button: Button = $GridContainer/Save
@onready var load_button: Button = $GridContainer/Load
@onready var options_button: Button = $GridContainer/Options
@onready var sfx_click: AudioStreamPlayer2D = $sfx_click
@onready var sfx_hover: AudioStreamPlayer2D = $sfx_hover


func _ready() -> void:
	for child in $GridContainer.get_children():
		child.mouse_entered.connect(child.grab_focus)
		child.focus_entered.connect(_on_focus_entered)
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if get_tree().paused == false:
			pass
		else:
			pass
		get_viewport().set_input_as_handled()
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_RIGHT_SHOULDER:
			save_button.grab_focus()

func _on_save_pressed() -> void:
	sfx_click.play()
	if get_tree().paused == false:
		return
	else:
		SaveManager.save_game()

func _on_load_pressed() -> void:
	sfx_click.play()
	if get_tree().paused == false:
		return
	else:
		SaveManager.save_game()
		RoomManager.load_level("res://load_screen.tscn", "", Vector2.ZERO, false, -2)
		await RoomManager.room_load_start
		PlayerManager.player.revive_player()
		
func _on_focus_entered():
	sfx_hover.play()
