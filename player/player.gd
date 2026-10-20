extends CharacterBody2D
class_name Player

#cut legs off shootwalk animations

var cardinal_dir: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var view

signal shoot
var can_shoot:bool

@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	$PlayerSprite.animation = "idle_down"
	can_shoot = true
	
func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("attack") and can_shoot:
		shoot.emit(position, cardinal_dir)
		can_shoot = false
	
func _physics_process(_delta):
	move_and_slide()
	
func setDirection() -> bool:
	var new_dir: Vector2 = cardinal_dir
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_dir:
		return false
		
	cardinal_dir = new_dir
	$PlayerSprite.flip_h = true if cardinal_dir == Vector2.RIGHT else false
	$PlayerSprite.offset.x = 3 if cardinal_dir == Vector2.RIGHT else 0
	return true

func AnimDirection() -> String:
	if cardinal_dir == Vector2.DOWN:
		return "down"
	elif cardinal_dir == Vector2.UP:
		return "up"
	else:
		return "side"
		
func updateAnim(state:String) -> void:
	$PlayerSprite.play (state + "_" + AnimDirection())
	
	#add health
func _on_player_sprite_animation_finished() -> void:
	can_shoot = true
	pass # Replace with function body.
