class_name EnemyStateChase extends EnemyState

@export var anim_name:String="walk"
@export var speed = 60
@export var aggroed: float = 6.0
@export var next_state:EnemyState
@onready var sfx_enemy_walk: AudioStreamPlayer2D = $sfx_enemy_walk

var destroyed:bool
var _timer: float = 0
var i:int
var _direction : Vector2
var _player_visible: bool = false

const PATHFINDING:PackedScene=preload("res://pathfinding.tscn")
var pathfinding:PathFinding

func init() -> void:
	pass

func enter()-> void:
	pathfinding = PATHFINDING.instantiate() as PathFinding
	enemy.add_child(pathfinding)
	_timer = aggroed
	enemy.updateAnim(anim_name)
	
func exit()->void:
	i=0
	pathfinding.queue_free()
	_player_visible = false
	
func process(_delta:float)->EnemyState:
	_direction =pathfinding.movement_dir
	enemy.velocity = _direction * speed
	if enemy.setDirection(_direction):
		enemy.updateAnim(anim_name)
	if _player_visible == false:
		_timer -= _delta
		if _timer < 0:
			return next_state
	else:
		_timer = aggroed
	return null
	
func physics(_delta:float)->EnemyState:
	return null

func _process(_delta: float) -> void:
	pass
	
func _on_fov_player_entered() -> void:
	_player_visible = true
	if (state_machine.current_state is EnemyStateStun or 
	state_machine.current_state is EnemyStateDestroy):
		return
	state_machine.ChangeState(self)

func _on_fov_player_exited() -> void:
	_player_visible = false

func _on_enemy_direction_changed(_new_direction: Vector2) -> void:
	if not destroyed:
		enemy.updateAnim(anim_name)
	else:
		state_machine.ChangeState($"../destroy")

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
