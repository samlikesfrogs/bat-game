class_name StateDash extends State
@export var move_speed:float = 230.0
@export var dash_audio:AudioStream
@onready var idle: State_Idle = $"../idle"
var direction:Vector2 = Vector2.ZERO
var next_state:State = null

func Enter() -> void:
	player.invulnerable = true
	player.updateAnim("dash")
	direction = player.direction
	if direction == Vector2.ZERO:
		direction = player.cardinal_dir
	
func Exit() -> void:
	player.invulnerable = false
	next_state = null
	pass
	
func Process(_delta:float)  -> State:
	player.velocity = direction*move_speed
	return next_state
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	return null


func _on_player_sprite_animation_finished() -> void:
	if player.state_machine.current_state == self:
		next_state = idle
