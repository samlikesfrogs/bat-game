class_name EnemyStateDestroy extends EnemyState

@export var anim_name:String="die"
@onready var gpu_particles_2d: GPUParticles2D = $"../../GPUParticles2D"

var _animation_finished:bool=false
var _direction : Vector2
var _damage_position
@onready var sfx_enemy_die: AudioStreamPlayer2D = $sfx_enemy_die
@onready var sfx_enemy_hurt: AudioStreamPlayer2D = $"../stun/sfx_enemy_hurt"

func init() -> void:
	pass

func enter()-> void:
	sfx_enemy_hurt.play()
	gpu_particles_2d.rotation = get_tree().get_first_node_in_group("player").cardinal_dir.angle()
	gpu_particles_2d.restart()
	gpu_particles_2d.emitting = true
	await get_tree().create_timer(0.1).timeout
	enemy.velocity = Vector2.ZERO
	$"../../HurtBox/CollisionShape2D".set_deferred("disabled", true)
	enemy.invulnerable = true
	enemy.setDirection(_direction)
	enemy.updateAnim(anim_name)
	await get_tree().create_timer(0.5).timeout
	sfx_enemy_die.play()
	
func exit()->void:
	pass
	
func process(_delta:float)->EnemyState:
	return null
	
func physics(_delta:float)->EnemyState:
	return null

func _process(_delta: float) -> void:
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	_animation_finished = true

func _on_enemy_enemy_destroyed(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)
	await get_tree().create_timer(2).timeout
	if _animation_finished:
		var tween := create_tween()
		tween.tween_property(enemy, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
		tween.finished.connect(enemy.queue_free)
