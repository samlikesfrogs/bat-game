extends CanvasLayer
@onready var container: HFlowContainer = $HFlowContainer
@onready var gameover: Control = $gameover
@onready var button_continue: Button = $gameover/continue
@onready var button_title: Button = $gameover/title

var hearts:Array[HeartUI]=[]
func _ready() -> void:
	gameover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in container.get_children():
		if child is HeartUI:
			hearts.append(child)
			child.visible = false
	button_continue.pressed.connect(on_load_pressed)
	button_title.pressed.connect(title_screen)
	self.visible = true
	await get_tree().process_frame
	
func update_hp(_hp: int, _max_hp: int):
	for i in _max_hp:
		update_heart(i, _hp)
	update_max(_max_hp)
		
func update_heart(_index:int, _hp:int):
	@warning_ignore("integer_division")
	_index = _index/4
	var _value: int = clampi(_hp-_index*4, 0, 4)
	hearts[_index].value = _value
	
func update_max(_max_hp:int):
	@warning_ignore("integer_division")
	var _heart_amnt:int = round(_max_hp/4)
	for i in hearts.size():
		if i < _heart_amnt:
			hearts[i].visible = true
		else:
			hearts[i].visible=false

func show_game_over():
	gameover.mouse_filter = Control.MOUSE_FILTER_STOP
	await get_tree().create_timer(0.7).timeout
	get_tree().paused = true
	gameover.visible = true
	var can_continue:bool = SaveManager.get_save_file() != null
	button_continue.visible = can_continue
	gameover.fade_in()
	if PlayerManager.using_controller:
		if can_continue:
			button_continue.grab_focus()
		else:
			button_title.grab_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func hide_game_over():
	PlayerManager.player.revive_player()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	gameover.visible = false
	gameover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func on_load_pressed():
	gameover.fade_out()
	SaveManager.load_game()
	pass
	
func title_screen():
	gameover.fade_out()
	RoomManager.load_level("res://load_screen.tscn", "", Vector2.ZERO, false)
	pass
