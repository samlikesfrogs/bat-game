extends CanvasLayer
@onready var inventory_ui: Control = $NinePatchRect/inventory_ui
@onready var save_load: Control = $Save_Load
@onready var inventory_button: Button = $NinePatchRect2/inventory
@onready var settings_button: Button = $NinePatchRect3/settings



func _ready() -> void:
	RoomManager.room_load_end.connect(on_room_load_end)
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
		if inventory_ui.mouse_filter == Control.MOUSE_FILTER_PASS:
			inventory_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
		elif inventory_ui.mouse_filter == Control.MOUSE_FILTER_IGNORE:
			inventory_ui.mouse_filter = Control.MOUSE_FILTER_PASS
		if save_load.mouse_filter == Control.MOUSE_FILTER_PASS:
			save_load.mouse_filter = Control.MOUSE_FILTER_IGNORE
		elif save_load.mouse_filter == Control.MOUSE_FILTER_IGNORE:
			save_load.mouse_filter = Control.MOUSE_FILTER_PASS
		_on_inventory_pressed()
	
func on_room_load_end():
	if self.visible == true:
		self.visible=false


func _on_inventory_pressed() -> void:
	inventory_button.modulate.a = 0.4
	settings_button.modulate.a = 1.0
	inventory_ui.visible = true
	inventory_ui.mouse_filter = Control.MOUSE_FILTER_PASS
	save_load.visible = false
	save_load.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_settings_pressed() -> void:
	inventory_button.modulate.a = 1.0
	settings_button.modulate.a = 0.4
	inventory_ui.visible = false
	inventory_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	save_load.visible = true
	save_load.mouse_filter = Control.MOUSE_FILTER_PASS
