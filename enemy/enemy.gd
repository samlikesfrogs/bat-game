extends CharacterBody2D
class_name Enemy

@export var hp: int = 3
@export var aggrorange: = 128

@onready var sprite:AnimatedSprite2D = $EnemySprite
@onready var _hit_box: HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

var cardinal_dir: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player:Player
var invulnerable:bool=false

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

signal direction_changed(new_direction:Vector2)
signal enemy_damaged(hurt_box:HurtBox)
signal enemy_entered()
signal enemy_destroyed(hurt_box:HurtBox)

func _ready():
	state_machine.Initialize(self)
	_hit_box.Damaged.connect(_take_damage)
	player = PlayerManager.player
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func setDirection(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
		
	var direction_id:int=int(round(
		(direction).angle()
		/TAU*DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_dir:
		return false
	
	cardinal_dir = new_dir
	direction_changed.emit(new_dir)
	%EnemySprite.flip_h = true if cardinal_dir == Vector2.LEFT else false
	return true
		
func updateAnim(state:String) -> void:
	%EnemySprite.play (state + "_" + AnimDirection())
	print((state + "_" + AnimDirection()))

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
	
func _take_damage(hurt_box:HurtBox) -> void:
	if invulnerable == true:
		return
	hp -= hurt_box.damage
	if hp>0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
