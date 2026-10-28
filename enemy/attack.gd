class_name EnemyStateAttack extends EnemyState

@export var anim_name:String="attack"
@export var speed = 78
@export var aggroed: float = 1.5
@export var next_state:EnemyState
@onready var player = get_tree().get_first_node_in_group("player")
@onready var hurt_box: EnemyHurtBox = $"../../HurtBox"
@onready var hit_box: HitBox = $"../../HitBox"
@onready var sfx_enemy_attack: AudioStreamPlayer2D = $sfx_enemy_attack

var _direction : Vector2
var _player_visible: bool = false
var animation_finished:bool
var player_pos
var i:int

func init() -> void:
	pass

func enter()-> void:
	$"../../CollisionShape2D".set_deferred("disabled", true)
	enemy.velocity = Vector2.ZERO	
	i = 0
	enemy.updateAnim(anim_name)
	animation_finished = false
	if hurt_box:
		hurt_box.monitoring = true
	pass
	enemy.velocity = Vector2.ZERO	
	
func exit()->void:
	_player_visible = false
	pass
	
func process(_delta:float)->EnemyState:
	if animation_finished:
		return next_state
	if i == 1 or i == 2:
		_direction = enemy.global_position.direction_to(player.global_position)
		enemy.velocity = _direction * speed
		enemy.move_and_slide()
	elif i ==3:
		$"../../CollisionShape2D".set_deferred("disabled", false)
		enemy.velocity = Vector2.ZERO	
	return null
	
func physics(_delta:float)->EnemyState:
	return null

func _on_enemy_direction_changed(_new_direction: Vector2) -> void:
	enemy.updateAnim(anim_name)

func _on_enemy_sprite_animation_finished() -> void:
	animation_finished = true

func _on_enemy_sprite_frame_changed() -> void:
	i+=1
	if i == 2:
		sfx_enemy_attack.play()
