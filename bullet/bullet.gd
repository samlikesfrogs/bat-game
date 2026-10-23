extends Area2D

var speed: int = 320
var direction:Vector2

@onready var hurtbox = $HurtBox

func _process(delta: float) -> void:
	position += speed *direction*delta
	if direction == Vector2.DOWN:
		hurtbox.position = Vector2(-4, 0)
		hurtbox.rotation = PI / 2
		
		$AnimatedSprite2D.play("down")
	if direction==Vector2.LEFT:
		hurtbox.position = Vector2(1.0, 6.0)
		hurtbox.rotation = 0
		
		$AnimatedSprite2D.play("left")
	if direction==Vector2.RIGHT:
		hurtbox.position = Vector2(1.0, 6.0)
		hurtbox.rotation = 0
		
		$AnimatedSprite2D.play("right")
	if direction==Vector2.UP:
		hurtbox.position = Vector2(4.0, 0.0)
		hurtbox.rotation = PI / 2
		
		$AnimatedSprite2D.play("up")
	pass
