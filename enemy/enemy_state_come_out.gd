class_name EnemyStateComeOut extends EnemyState

@export var anim_name:String="comeout"
@export var next_state:EnemyState
@onready var sfx_comeout_land: AudioStreamPlayer2D = $sfx_comeout_land

var _animation_finished: bool = false

func init() -> void:
	pass

func enter()-> void:
	_animation_finished = false
	enemy.velocity=Vector2.ZERO
	enemy.updateAnim(anim_name)
	
func exit()->void:
	pass
	
func physics(_delta:float)->EnemyState:
	return null
	
func _on_enemy_enemy_entered() -> void:
	state_machine.ChangeState(self)

func _on_animated_sprite_2d_animation_finished() -> void:
	_animation_finished=true
	$"../../FOV/CollisionPolygon2D".set_deferred("disabled", false)
	$"../../HitBox/hitcollision".set_deferred("disabled", false)
	$"../../HurtBox/CollisionShape2D".set_deferred("disabled", false)
	$"../../Detection/detection".set_deferred("disabled", true)

func process(_delta:float)->EnemyState:
	if _animation_finished==true:
		sfx_comeout_land.play()
		return next_state
	else:
		return null

	

	
