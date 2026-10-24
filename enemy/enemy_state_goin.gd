class_name EnemyStateGoIn extends EnemyState

@export var anim_name:String="goin"
@export var next_state:EnemyState
@onready var sfx_goin: AudioStreamPlayer2D = $sfx_goin
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
	
func process(_delta:float)->EnemyState:
	if _animation_finished==true:
		sfx_goin.play()
		return next_state
	else:
		return null

func _on_enemy_sprite_animation_finished() -> void:
	_animation_finished=true
