class_name EnemyStateDestroy extends EnemyState

@export var anim_name:String="die"
@export var knockback_speed:float = 100.0
@export var decelerate_speed:float=10.0

var _animation_finished:bool=false
var _direction : Vector2
var _damage_position
@onready var sfx_enemy_die: AudioStreamPlayer2D = $sfx_enemy_die
@onready var sfx_enemy_hurt: AudioStreamPlayer2D = $"../stun/sfx_enemy_hurt"

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass

func enter()-> void:
	sfx_enemy_hurt.play()
	await get_tree().create_timer(0.2).timeout
	$"../../HurtBox/CollisionShape2D".set_deferred("disabled", true)
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.setDirection(_direction)
	enemy.velocity=_direction * -knockback_speed
	enemy.updateAnim(anim_name)
	await get_tree().create_timer(0.5).timeout
	sfx_enemy_die.play()
	pass
	
func exit()->void:
	pass
	
func process(_delta:float)->EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func physics(_delta:float)->EnemyState:
	return null

func _process(_delta: float) -> void:
	pass
	
func _on_enemy_destroyed(hurt_box:HurtBox):
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)
	await get_tree().create_timer(2).timeout
	if _animation_finished:
		var tween := create_tween()
		tween.tween_property(enemy, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
		tween.finished.connect(enemy.queue_free)

func _on_animated_sprite_2d_animation_finished() -> void:
	_animation_finished = true
	
