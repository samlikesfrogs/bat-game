extends CharacterBody2D
class_name Enemy

signal direction_changed(new_direction:Vector2)
signal enemy_damaged()
signal enemy_entered()

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3

var cardinal_dir: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player:Player
var invulnerable:bool=false
#var detected:bool=false

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

var is_out:bool=false

func _ready():
	$EnemyStateMachine.Initialize(self)
	player = PlayerManager.player
#	$collision.disabled=true
	pass

func _physics_process(_delta: float) -> void:
#	if not detected:
#		z_index = 0
#	else:
#		await get_tree().create_timer(0.9).timeout
#		z_index = 1
	move_and_slide()
	
func setDirection(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
		
	var direction_id:int=int(round(
		(direction*cardinal_dir*0.1).angle()
		/TAU*DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_dir:
		return false
	
	cardinal_dir = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x=-1 if cardinal_dir==Vector2.LEFT else 1
	return true
		
func updateAnim(state:String) -> void:
	$AnimatedSprite2D.animation = (state + "_" + AnimDirection())
	print(state)
	print(AnimDirection())

func AnimDirection() -> String:
	if cardinal_dir == Vector2.DOWN:
		return "down"
	elif cardinal_dir == Vector2.UP:
		return "up"
	else:
		return "side"

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		enemy_entered.emit()


func _on_detection_body_exited(body: Node2D) -> void:
#	if body.is_in_group("player"): 
#		detected = false
	pass # Replace with function body.
