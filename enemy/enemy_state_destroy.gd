class_name EnemyStateDestroy extends EnemyState

@export var anim_name:String="die"
@export var knockback_speed:float = 50.0
@onready var gpu_particles_2d: GPUParticles2D = $"../../GPUParticles2D"
var _animation_finished:bool=false
var _direction : Vector2
@onready var sfx_enemy_die: AudioStreamPlayer2D = $sfx_enemy_die
@onready var sfx_enemy_hurt: AudioStreamPlayer2D = $"../stun/sfx_enemy_hurt"
@export var enemy_drop_rate: int = randi_range(1, 3)
var _position
var _damage_position:Vector2

func init() -> void:
	pass

func enter()-> void:
	sfx_enemy_hurt.play()
	gpu_particles_2d.emitting = true
	_direction = (enemy.global_position).direction_to(_damage_position)
	print(_direction)
	gpu_particles_2d.rotation = get_tree().get_first_node_in_group("player").cardinal_dir.angle()
	gpu_particles_2d.restart()
	enemy.setDirection(_direction)
	print(enemy.setDirection(_direction))
	enemy.velocity=_direction * -knockback_speed
	enemy.updateAnim(anim_name)
	$"../../HurtBox/CollisionShape2D".set_deferred("disabled", true)
	Engine.time_scale=0
	await get_tree().create_timer(0.1, true, false, true).timeout
	Engine.time_scale=1
	enemy.velocity = Vector2.ZERO
	enemy.invulnerable = true
	await get_tree().create_timer(0.5).timeout
	sfx_enemy_die.play()
	
func exit()->void:
	pass
	
func process(_delta:float)->EnemyState:
	$"../../HurtBox/CollisionShape2D".set_deferred("disabled", true)
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
		tween.tween_property(enemy.sprite, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
		tween.finished.connect(enemy.sprite.queue_free)
		drop_rand_items(enemy_drop_rate)
		enemy.queue_free()
		
func drop_rand_items(count):
	var dropped = 0
	while dropped < count:
		var position = enemy.global_position
		drop_item(enemy.spawnable_items[randi()% enemy.spawnable_items.size()], position)
		dropped += 1
		
func drop_item(data, position):
	var item_instance = preload("res://inventory_item.tscn").instantiate()
	item_instance.instance_item(data["type"], data["name"], data["function"], data["texture"])
	enemy.get_parent().call_deferred("add_child", item_instance)
	item_instance.global_position = position
	item_instance.velocity = (_direction * -knockback_speed).rotated(randf_range(-0.8,0.8))*randf_range(0.9, 1.2)
