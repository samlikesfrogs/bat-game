class_name StateStun extends State

@export var knockback_speed:float = 500.0
@export var decelerate_speed:float=10.0
@export var move_speed : float = 250.0
@export var invulnerable_duration:float=0.5

signal damaged

var _animation_finished:bool=false
var hurt_box:HurtBox
var direction: Vector2
var _damage_position: Vector2

@export var next_state:State 

func init():
	pass

func Enter() -> void:
	_animation_finished = false
	direction = player.global_position.direction_to(_damage_position)
	player.velocity = direction * -knockback_speed
	player.setDirection()
	player.make_invulnerable(invulnerable_duration)
	player.updateAnim("stun")
	pass
	
func Exit() -> void:
	
	pass
	
func Process(_delta:float)  -> State:
	if _animation_finished ==true:
		return next_state
	player.velocity -= player.velocity * decelerate_speed * _delta
	return null
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	return null

func _on_player_player_damaged(_hurt_box:HurtBox) -> void:
	hurt_box = _hurt_box
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)
#	pass # Replace with function body.


func _on_player_sprite_animation_finished() -> void:
	_animation_finished=true
	pass # Replace with function body.
	
	




	

	
