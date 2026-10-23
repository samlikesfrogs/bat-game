class_name State_Idle extends State

@onready var walk : State_Walk = $"../walk"
@onready var attack:State = $"../attack"
@onready var stun:State = $"../stun"

func Enter() -> void:
	player.updateAnim("idle")
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta:float)  -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null


func _on_player_player_damaged(hurt_box:HurtBox) -> void:
	state_machine.ChangeState(stun)
	pass # Replace with function body.
