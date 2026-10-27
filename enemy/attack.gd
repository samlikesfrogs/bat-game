class_name EnemyStateAttack extends EnemyState

@export var anim_name:String="attack"
@export var speed = 99
@export var aggroed: float = 1.5
@export var next_state:EnemyState
@onready var player = get_tree().get_first_node_in_group("player")
@onready var hurt_box: EnemyHurtBox = $"../../HurtBox"
@onready var hit_box: HitBox = $"../../HitBox"

var _direction : Vector2
var _player_visible: bool = false
var animation_finished:bool
var player_pos
var i:int

#if player is in attack range and the best direction is player global position, switch to attack anim and jump to player

func init() -> void:
	pass

func enter()-> void:
	$"../../CollisionShape2D".set_deferred("disabled", true)
	i = 0
	enemy.updateAnim(anim_name)
	animation_finished = false
	if hurt_box:
		hurt_box.monitoring = true
	pass
	
func exit()->void:
	_player_visible = false
	pass
	
func process(_delta:float)->EnemyState:
	if animation_finished:
		return next_state
	if enemy.setDirection(_direction):
		enemy.updateAnim(anim_name)
	if i==0 or i == 1 or i == 2:
		var direction = enemy.global_position.direction_to(player.global_position)
		enemy.velocity = direction * speed
		enemy.move_and_slide()
	else:
		$"../../CollisionShape2D".set_deferred("disabled", false)
		enemy.velocity = Vector2.ZERO	
	return null
	
func physics(_delta:float)->EnemyState:
	return null

func _on_enemy_direction_changed(_new_direction: Vector2) -> void:
	enemy.updateAnim(anim_name)

func _on_enemy_sprite_animation_finished() -> void:
	animation_finished = true
	pass # Replace with function body.

func _on_enemy_sprite_frame_changed() -> void:
	i+=1
	pass # Replace with function body.
