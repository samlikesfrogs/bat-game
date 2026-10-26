class_name EnemyStateChase extends EnemyState

@onready var navigation_agent_2d: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 200
var direction: Vector2
@export var anim_name:String="walk"
@export var aggroed: float = 4.0
@export var next_state:EnemyState
@onready var sfx_enemy_walk: AudioStreamPlayer2D = $sfx_enemy_walk
@onready var fov: FieldOfVision = $"../../FOV"
@onready var hurt_box: EnemyHurtBox = $"../../HurtBox"
@onready var hit_box: HitBox = $"../../HitBox"
var i: int = 0
var destroyed:bool
var _timer: float = 0
var _direction : Vector2
var _player_visible: bool = false

func init() -> void:
	if fov:
		fov.player_entered.connect(_on_fov_player_entered)
		fov.player_exited.connect(_on_fov_player_exited)
	pass

func enter()-> void:
	_timer = aggroed
	enemy.updateAnim(anim_name)
	_player_visible=true
	if hurt_box:
		hurt_box.monitoring = true
	
func exit()->void:
	i = 0
	if hurt_box:
		hurt_box.monitoring=false
	_player_visible = false
	
func process(_delta:float)->EnemyState:
	
	navigation_agent_2d.target_position = player.global_position
	_direction = lerp(direction, enemy.global_position.direction_to(navigation_agent_2d.get_next_path_position()), 5*_delta)
	if navigation_agent_2d.is_target_reached() == false:
		enemy.velocity = _direction * speed
		enemy.move_and_slide()
	if enemy.setDirection(_direction):
		enemy.updateAnim(anim_name)
	if _player_visible == false:
		_timer -= _delta
		if _timer < 0:
			
			return next_state
	else:
		_timer = aggroed
	return null
	
func _on_fov_player_entered() -> void:
	_player_visible = true
	if (state_machine.current_state is EnemyStateStun or 
	state_machine.current_state is EnemyStateDestroy):
		return
	state_machine.ChangeState(self)

func _on_fov_player_exited() -> void:
	_player_visible = false

func _on_enemy_sprite_animation_changed() -> void:
	await get_tree().create_timer(0.001).timeout
	if %EnemySprite.animation == anim_name + "_" + enemy.AnimDirection():
		if i%3==0 or i==0:
			sfx_enemy_walk.play()
		i += 1

func _on_enemy_sprite_frame_changed() -> void:
	if %EnemySprite.animation == anim_name + "_" + enemy.AnimDirection():
		if i%3==0 or i ==0:
			sfx_enemy_walk.play()
		i +=1

func _on_enemy_enemy_destroyed(hurt_box: HurtBox) -> void:
	destroyed = true
