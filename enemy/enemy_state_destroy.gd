class_name EnemyStateDestroy extends EnemyState

@export var anim_name:String="die"
@export var knockback_speed:float = 100.0
@export var decelerate_speed:float=10.0

var _timer:float=0.0
var _animation_finished:bool=false
var _direction : Vector2

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass

func enter()-> void:
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to(PlayerManager.player.global_position)
	enemy.setDirection(_direction)
	enemy.velocity=_direction * -knockback_speed
	enemy.updateAnim(anim_name)
	pass
	
func exit()->void:
	pass
	
func process(_delta:float)->EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func physics(_delta:float)->EnemyState:
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_enemy_destroyed():
	state_machine.ChangeState(self)

func _on_animated_sprite_2d_animation_finished() -> void:
	enemy.queue_free()
	
