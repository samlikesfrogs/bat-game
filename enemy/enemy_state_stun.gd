class_name EnemyStateStun extends EnemyState

@export var anim_name:String="stun"
@export var knockback_speed:float = 100.0
@export var next_state:EnemyState
@export var decelerate_speed:float=10.0


var _timer:float=0.0
var _animation_finished:bool=false
var _direction : Vector2

func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass

func enter()-> void:
	enemy.invulnerable = true
	_animation_finished = false
	_direction = enemy.global_position.direction_to(PlayerManager.player.global_position)
	enemy.setDirection(_direction)
	enemy.velocity=_direction * -knockback_speed
	enemy.updateAnim(anim_name)
	pass
	
func exit()->void:
	enemy.invulnerable = false
	pass
	
func process(_delta:float)->EnemyState:
	if _animation_finished ==true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func physics(_delta:float)->EnemyState:
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_enemy_damaged():
	state_machine.ChangeState(self)

func _on_animated_sprite_2d_animation_finished() -> void:
	_animation_finished=true
