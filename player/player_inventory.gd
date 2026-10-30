extends CanvasLayer

func _ready() -> void:
	$"../hotbar".visible = true
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		$"../hotbar".visible = false
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
