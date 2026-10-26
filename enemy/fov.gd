class_name FieldOfVision extends Area2D

signal player_entered
signal player_exited


func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited.emit()
	
func _on_enemy_direction_changed(new_direction: Vector2) -> void:
	print("hello hello")
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
