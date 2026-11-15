extends Control


func fade_in():
	self.modulate = Color(0.0, 0.0, 0.0, 0.0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.6) 
	await tween.finished
	
func fade_out():
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	var tween:= create_tween()
	tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.6) 
	await tween.finished
