extends CanvasLayer
func _ready() -> void:
	RoomManager.room_load_end.connect(on_room_load_end)
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
	
func on_room_load_end():
	if self.visible == true:
		self.visible=false
