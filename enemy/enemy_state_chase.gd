class_name EnemyStateChase extends EnemyState

@export var anim_name:String="walk"
@export var speed = 60
@export var aggroed: float = 3.0
@export var next_state:EnemyState
#make go back into ground state
var _timer: float = 0
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
	pass
	
func exit()->void:
	pathfinding.queue_free()
	_player_visible = false
	pass
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_fov_player_entered() -> void:
	_player_visible = true
	if (state_machine.current_state is EnemyStateStun or 
	state_machine.current_state is EnemyStateDestroy):
		return
	state_machine.ChangeState(self)
	pass

func _on_fov_player_exited() -> void:
	_player_visible = false
	pass # Replace with function body.


func _on_enemy_direction_changed(new_direction: Vector2) -> void:
	enemy.updateAnim(anim_name)
