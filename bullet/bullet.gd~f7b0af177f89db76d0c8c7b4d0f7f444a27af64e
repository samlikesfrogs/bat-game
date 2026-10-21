extends Area2D

#fix collisionshape for up/down bullets

var speed: int = 320
var direction:Vector2
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed *direction*delta
	if direction == Vector2.DOWN:
		$"side collision".set_deferred("disabled", true)
		$"HurtBox/side hurt".set_deferred("disabled", true)
		$"up collision".set_deferred("disabled", true)
		$"HurtBox/up hurt".set_deferred("disabled", true)
		$"down collision".set_deferred("disabled", false)
		$"HurtBox/down hurt".set_deferred("disabled", false)
		$AnimatedSprite2D.play("down")
	if direction==Vector2.LEFT:
		$"side collision".set_deferred("disabled", false)
		$"HurtBox/side hurt".set_deferred("disabled", false)
		$"up collision".set_deferred("disabled", true)
		$"HurtBox/up hurt".set_deferred("disabled", true)
		$"down collision".set_deferred("disabled", true)
		$"HurtBox/down hurt".set_deferred("disabled", true)
		$AnimatedSprite2D.play("left")
	if direction==Vector2.RIGHT:
		$"side collision".set_deferred("disabled", false)
		$"HurtBox/side hurt".set_deferred("disabled", false)
		$"up collision".set_deferred("disabled", true)
		$"HurtBox/up hurt".set_deferred("disabled", true)
		$"down collision".set_deferred("disabled", true)
		$"HurtBox/down hurt".set_deferred("disabled", true)
		$AnimatedSprite2D.play("right")
	if direction==Vector2.UP:
		$"side collision".set_deferred("disabled", true)
		$"HurtBox/side hurt".set_deferred("disabled", true)
		$"up collision".set_deferred("disabled", false)
		$"HurtBox/up hurt".set_deferred("disabled", false)
		$"down collision".set_deferred("disabled", true)
		$"HurtBox/down hurt".set_deferred("disabled", true)
		$AnimatedSprite2D.play("up")
	pass
