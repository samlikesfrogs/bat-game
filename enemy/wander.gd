class_name EnemyStateWander extends EnemyState

@export var anim_name:String="walk"
@export var wander_speed:float =20.0
@export_category("AI")
#@export var state_duration_min:float=0.5
#@export var state_duration_max:float=1.5
#@export var after_idle_state:EnemyState

func init() -> void:
	pass

func enter()-> void:
	enemy.velocity=Vector2.ZERO
	enemy.updateAnim(anim_name)
	pass
	
func exit()->void:
	pass
	
func process(_delta:float)->EnemyState:
	
	return null
	
func physics(_delta:float)->EnemyState:
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
