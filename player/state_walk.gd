class_name State_Walk extends State

@export var move_speed : float = 300.0
@onready var idle : State_Idle = $"../idle"

func Enter() -> void:
	player.updateAnim("walk")
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta:float)  -> State:
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * move_speed
		
	if player.setDirection():
		player.updateAnim("walk")
	return null
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	return null
