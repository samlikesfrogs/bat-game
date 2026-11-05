extends CanvasLayer
@onready var rect = $Control/ColorRect

func fade_in():
	rect.modulate = Color(0.0, 0.0, 0.0, 0.0)
	var tween := create_tween()
	tween.tween_property(rect, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5) 
	await tween.finished
func fade_out():
	rect.modulate = Color(0.0, 0.0, 0.0, 1.0)
	var tween:= create_tween()
	tween.tween_property(rect, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.5) 
	await tween.finished
