extends Area2D

var speed: int = 320
var direction:Vector2
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed *direction*delta
	if direction == Vector2.DOWN:
		$AnimatedSprite2D.play("down")
	if direction==Vector2.LEFT:
		$AnimatedSprite2D.play("left")
	if direction==Vector2.RIGHT:
		$AnimatedSprite2D.play("right")
	if direction==Vector2.UP:
		$AnimatedSprite2D.play("up")
	pass
