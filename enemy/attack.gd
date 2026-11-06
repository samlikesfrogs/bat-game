class_name EnemyStateAttack extends EnemyState

@export var anim_name:String="attack"
@export var speed = 78
@export var aggroed: float = 1.5
@export var next_state:EnemyState
@onready var player = PlayerManager.player
@onready var hurt_box: EnemyHurtBox = $"../../HurtBox"
@onready var hit_box: HitBox = $"../../HitBox"
@onready var sfx_enemy_attack: AudioStreamPlayer2D = $sfx_enemy_attack

var _direction : Vector2
var _player_visible: bool = false
var animation_finished:bool
var player_pos
var i:int =0

func init() -> void:
	pass

func enter()-> void:
	$"../../CollisionShape2D".set_deferred("disabled", true)
	#enemy.setDirection(enemy.global_position.direction_to(player.global_position))
	enemy.updateAnim(anim_name)
	enemy.velocity = Vector2.ZERO	
	animation_finished = false
	i=0
	if hurt_box:
		hurt_box.monitoring = true
	
func exit()->void:
	i = 0
	_player_visible = false
	pass
	
func process(_delta:float)->EnemyState:
	if animation_finished:
		return next_state
	if i ==0:
		enemy.velocity = Vector2.ZERO	
	elif i == 1:
		_direction = enemy.global_position.direction_to(player.global_position)
		enemy.velocity = _direction * speed
		enemy.move_and_slide()
	elif i == 2:
		_direction = enemy.global_position.direction_to(player.global_position)
		enemy.velocity = _direction * speed
		enemy.move_and_slide()
	elif i == 3:
		$"../../CollisionShape2D".set_deferred("disabled", false)
		enemy.velocity = Vector2.ZERO	
	if i == 3:
		animation_finished = true
	return null
	
func physics(_delta:float)->EnemyState:
	return null

#func _on_enemy_sprite_animation_changed() -> void:
#	i = 0
	
func _on_enemy_sprite_animation_finished() -> void:
	animation_finished = true

func _on_enemy_sprite_frame_changed() -> void:
	#await get_tree().create_timer(0.001).timeout
	if %EnemySprite.animation == anim_name + "_" + enemy.AnimDirection():
		if state_machine.current_state == self:
				i+=1
	if i == 2 and state_machine.current_state == self:
		sfx_enemy_attack.play()
