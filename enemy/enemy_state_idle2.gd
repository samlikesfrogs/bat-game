class_name EnemyStateIdleTwo extends EnemyState

@export var anim_name:String="idletwo"
var _timer:float=2.0
@export var next_state:EnemyState

func init() -> void:
	pass

func enter()-> void:
	enemy.velocity=Vector2.ZERO
	enemy.updateAnim(anim_name)
	pass
	
func exit()->void:
	pass
	
func process(_delta:float)->EnemyState:
	_timer -= _delta
	if _timer <=0:
		return next_state
	return null
