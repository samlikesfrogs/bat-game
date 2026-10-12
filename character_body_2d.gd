extends CharacterBody2D

var speed = 400

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "idle" #switch to forward when made
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "backward"
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "forward"
	move_and_slide()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
