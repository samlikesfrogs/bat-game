class_name EnemyStateIdleTwo extends EnemyState

@export var anim_name:String="idletwo"
@export_category("AI")
@export var state_duration_min:float=1.0
@export var state_duration_max:float=2.0
@export var next_state:EnemyState

var _timer:float=0.0

func init() -> void:
	pass

func enter()-> void:
	enemy.velocity=Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.updateAnim(anim_name)
	pass
	
func exit()->void:
	pass
	
func process(_delta:float)->EnemyState:
	_timer -= _delta
	if _timer <=0:
		return next_state
	return null
	
func physics(_delta:float)->EnemyState:
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
