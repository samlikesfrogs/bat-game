extends Area2D
class_name FieldOfVision

signal player_entered
signal player_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited.emit()
	pass # Replace with function body.
	

func _on_enemy_direction_changed(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_: 
			rotation_degrees = 0
	pass # Replace with function body.
