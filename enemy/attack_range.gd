class_name Attackrange extends Area2D

signal player_entered_attack
signal player_exited_attack


func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered_attack.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited_attack.emit()
	
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
