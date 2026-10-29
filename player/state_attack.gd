class_name State_Attack extends State

var attacking: bool = false

@export var move_speed : float = 250.0
@onready var idle : State_Idle = $"../idle"
@onready var walk: State_Walk = $"../walk"
var shoot_buffer:bool = false
@export var shoot_buffer_timer:float=0.41
var standing:bool
var walking:bool

func Enter() -> void:
	if player.direction == Vector2.ZERO:
		player.updateAnim("attackstand")
		standing = true
	else:
		player.updateAnim("attackwalk")
		walking = true
	attacking = true
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta:float)  -> State:
	if walking:
		player.velocity = player.direction * move_speed
	elif standing:
		player.velocity = Vector2.ZERO
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	elif attacking == true and Input.is_action_just_pressed("attack"):
		shoot_buffer=true
		get_tree().create_timer(shoot_buffer_timer).timeout.connect(on_shoot_buffer_timeout)
	if shoot_buffer:
		Enter()
		shoot_buffer=false
	return null
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	return null

func EndAttack()->void:
	attacking = false
	
func on_shoot_buffer_timeout()->void:
	shoot_buffer = false
	pass
