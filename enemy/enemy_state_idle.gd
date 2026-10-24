class_name EnemyStateIdle extends EnemyState

@export var anim_name:String="idle"
@onready var sfx_idle_leaves: AudioStreamPlayer2D = $sfx_idle_leaves

#add aniamtion finished to play sound 

func init() -> void:
	pass

func enter()-> void:
	$"../../Detection/detection".set_deferred("disabled", false)
	$"../../FOV/CollisionPolygon2D".set_deferred("disabled", true)
	$"../../HitBox/hitcollision".set_deferred("disabled", true)
	$"../../HurtBox/CollisionShape2D".set_deferred("disabled", true)
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

func _process(_delta: float) -> void:
	pass

func _on_enemy_sprite_animation_finished() -> void:
	pass
