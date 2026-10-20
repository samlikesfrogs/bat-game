class_name EnemyStateComeOut extends EnemyState

@export var anim_name:String="comeout"
@export var next_state:EnemyState

signal disable

var _animation_finished: bool = false

func init() -> void:
	pass

func enter()-> void:
	enemy.velocity=Vector2.ZERO
	enemy.updateAnim(anim_name)
	pass
	
func exit()->void:
	pass
	
func physics(_delta:float)->EnemyState:
	return null
	
func _on_enemy_enemy_entered() -> void:
	state_machine.ChangeState(self)

func _on_animated_sprite_2d_animation_finished() -> void:
	_animation_finished=true
	disable.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta:float)->EnemyState:
	if _animation_finished==true:
		return next_state
	else:
		return null

	

	
