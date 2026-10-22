class_name StateStun extends State

@export var knockback_speed:float = 100.0
@export var decelerate_speed:float=10.0
@export var move_speed : float = 250.0
@export var invulnerable_duration:float=1.0

var hurt_box:HurtBox
var direction: Vector2

@onready var idle : State_Idle = $"../idle"

var next_state:State = null

func init():
	pass

func Enter() -> void:
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.setDirection()
	player.make_invulnerable(invulnerable_duration)
	player.updateAnim("stun")
	pass
	
func Exit() -> void:
	next_state = null
	pass
	
func Process(_delta:float)  -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	return null

func _on_player_player_damaged() -> void:
	state_machine.ChangeState(self)
	pass # Replace with function body.


func _on_player_sprite_animation_finished() -> void:
	next_state = idle
	pass # Replace with function body.
