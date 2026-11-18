extends CanvasLayer
@onready var inventory_ui: Control = $NinePatchRect/inventory_ui
@onready var save_load: Control = $Save_Load



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
	
func on_room_load_end():
	if self.visible == true:
		self.visible=false
