extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$detection.set_deferred("disabled", false)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_comeout_disable() -> void:
	print("aghhh")
	#$detection.set_deferred("disabled", true)
	pass # Replace with function body.


func _on_goin_disable_2() -> void:
	print("done detect")
	#$detection.set_deferred("disabled", false)
	pass # Replace with function body.
