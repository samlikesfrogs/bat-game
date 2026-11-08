class_name EnemyStateAttack extends EnemyState

@onready var navigation_agent_2d: NavigationAgent2D = $"../../NavigationAgent2D"
@export var anim_name:String="attack"
@export var speed = 78
@export var aggroed: float = 1.5
@export var next_state:EnemyState
@onready var player = PlayerManager.player
@onready var hurt_box: EnemyHurtBox = $"../../HurtBox"
@onready var hit_box: HitBox = $"../../HitBox"
@onready var sfx_enemy_attack: AudioStreamPlayer2D = $sfx_enemy_attack
@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"

var _direction : Vector2 = Vector2.ZERO
var _player_visible: bool = false
var animation_finished:bool
var player_pos
var i:int =0

#IDEA: add raycast, if raycast is colliding, jump to the next navigation point and otherwise jump to player position 

func init() -> void:
	pass

func enter()-> void:
	enemy.updateAnim(anim_name)
	print("going here")
	if ray_cast_2d.is_colliding():
			print("this happens")
			navigation_agent_2d.target_position = player.global_position
			_direction = enemy.global_position.direction_to(navigation_agent_2d.get_next_path_position())
	else:
			_direction = enemy.global_position.direction_to(player.global_position)
	enemy.velocity = Vector2.ZERO	
	animation_finished = false
	i=0
	if hurt_box:
		hurt_box.monitoring = true
	
func exit()->void:
	i = 0
	_player_visible = false
	
func process(_delta:float)->EnemyState:
	if enemy.setDirection(_direction):
		enemy.updateAnim(anim_name)
	if animation_finished:
		return next_state
	if i == 0:
		enemy.velocity = Vector2.ZERO
	elif i == 1:
		print("gets to 1")
		enemy.velocity = _direction * speed
		enemy.move_and_slide()
	elif i == 2:
		enemy.velocity = _direction * speed
		enemy.move_and_slide()
	elif i == 3:
		enemy.velocity = Vector2.ZERO	
	if i == 3:
		animation_finished = true
	return null
	
func physics(_delta:float)->EnemyState:
	return null
	
func _on_enemy_sprite_animation_finished() -> void:
	animation_finished = true

func _on_enemy_sprite_frame_changed() -> void:
	if state_machine.current_state == self:
		i+=1
		if i == 2:
			sfx_enemy_attack.play()


func _on_enemy_sprite_animation_changed() -> void:
	i = 0
