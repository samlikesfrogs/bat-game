extends CanvasLayer

func _ready() -> void:
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
