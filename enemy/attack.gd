class_name EnemyStateAttack extends EnemyState

@export var anim_name:String="attack"
@export var speed = 60
@export var aggroed: float = 3.0
@export var next_state:EnemyState

var _direction : Vector2
var _player_visible: bool = false
var animation_finished:bool

#if player is in attack range and the best direction is player global position, switch to attack anim and jump to player

func init() -> void:
	pass

func enter()-> void:
	print("attack entered")
	enemy.updateAnim(anim_name)
	animation_finished = false
	pass
	
func exit()->void:
	_player_visible = false
	pass
	
func process(_delta:float)->EnemyState:
	enemy.velocity = _direction * speed
	if enemy.setDirection(_direction):
		enemy.updateAnim(anim_name)
	if animation_finished:
		return next_state
	return null
	
func physics(_delta:float)->EnemyState:
	return null

func _on_enemy_direction_changed(_new_direction: Vector2) -> void:
	enemy.updateAnim(anim_name)

func _on_attack_range_player_entered_attack() -> void:
	_player_visible = true
	if (state_machine.current_state is EnemyStateStun or 
	state_machine.current_state is EnemyStateDestroy):
		return
	state_machine.ChangeState(self)

func _on_attack_range_player_exited_attack() -> void:
	_player_visible = false

func _on_enemy_sprite_animation_finished() -> void:
	animation_finished = true
	pass # Replace with function body.
