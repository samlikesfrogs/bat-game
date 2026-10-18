extends CharacterBody2D
class_name Player

var cardinal_dir: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var view

@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	$PlayerSprite.animation = "idle_down"
	
func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
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
	$PlayerSprite.scale.x = 1 if cardinal_dir == Vector2.LEFT else -1 #use smth other than scale.x
	return true

func AnimDirection() -> String:
	if cardinal_dir == Vector2.DOWN:
		return "down"
	elif cardinal_dir == Vector2.UP:
		return "up"
	else:
		return "side"
		
func updateAnim(state:String) -> void:
	$PlayerSprite.animation = (state + "_" + AnimDirection())
	
	#add health


	
