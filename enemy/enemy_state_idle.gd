class_name EnemyStateIdle extends EnemyState

@export var anim_name:String="idle"

func init() -> void:
	pass

func enter()-> void:
	await get_tree().create_timer(0.5).timeout
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
