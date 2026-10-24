class_name State_Attack extends State

var attacking: bool = false

@export var move_speed : float = 250.0
@onready var idle : State_Idle = $"../idle"
@onready var walk: State_Walk = $"../walk"
@onready var sfx_attack: AudioStreamPlayer2D = $sfx_attack

func Enter() -> void:
	sfx_attack.play()
	if player.direction == Vector2.ZERO:
		player.updateAnim("attackstand")
	else:
		player.updateAnim("attackwalk")
	attacking = true
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta:float)  -> State:
	player.velocity = player.direction * move_speed
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	return null

func EndAttack()->void:
	attacking = false
