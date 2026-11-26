extends CharacterBody2D
class_name Player

@onready var inventory_ui: CanvasLayer = $inventory_ui
@export var hp: int = 12
@export var max_hp: int = 12
@onready var hit_box: HitBox = $HitBox
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine
var inventory_ui_visible:bool = false

var last_angle: float = PI/2
var cardinal_dir: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var view
var invulnerable:bool=false
var can_shoot:bool
@export var shoot_cooldown:float 
var _timer:float
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

signal shoot
signal inventory_opened 
signal player_damaged(hurt_box:HurtBox)
#signal player_destroyed(hurt_box:HurtBox)

var connected_joypads

func _ready():
	print("doing ready")
	update_hp(99)
	hit_box.Damaged.connect(_take_damage)
	PlayerManager.player = self
	state_machine.Initialize(self)
	player_sprite.flip_h = false
	can_shoot = true
	
func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("attack") and can_shoot:
		shoot.emit(position, cardinal_dir)
		can_shoot = false
	if can_shoot == false:
		_timer -= _delta
		if _timer < 0:
			can_shoot = true
	else:
		_timer = shoot_cooldown
	if Input.is_action_just_pressed("inventory"):
		inventory_opened.emit()
	
func _physics_process(_delta):
	move_and_slide()
	
func setDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var current_angle = direction.angle()
	if PlayerManager.using_controller:
		if cardinal_dir != Vector2.ZERO and abs(angle_difference(current_angle, last_angle)) < 0.05:
			return false
	
	var direction_id:int=int(round(
		(direction).angle()
		/TAU*DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_dir:
		return false
		
	cardinal_dir = new_dir
	last_angle = current_angle
	player_sprite.flip_h = true if cardinal_dir == Vector2.RIGHT else false
	player_sprite.offset.x = 3 if cardinal_dir == Vector2.RIGHT else 0
	return true

func AnimDirection() -> String:
	if cardinal_dir == Vector2.DOWN:
		return "down"
	elif cardinal_dir == Vector2.UP:
		return "up"
	else:
		return "side"
		
func updateAnim(state:String):
	player_sprite.play (state + "_" + AnimDirection())
	
func _on_player_sprite_animation_finished() -> void:
	can_shoot = true

func _take_damage(hurt_box:HurtBox) -> void:
	if invulnerable == true:
		return
	if hp>0:
		print("doing take damage")
		update_hp(-hurt_box.damage)
		player_damaged.emit(hurt_box)
	else:
		pass
		#player_destroyed.emit(hurt_box)	
		
func update_hp(delta:int):
	print("updating hp in player gd")
	hp=clampi(hp+delta, 0, max_hp)
	DifferentName.update_hp(hp, max_hp)
	
func make_invulnerable( _duration) -> void:
	invulnerable = true
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	$HitBox/CollisionShape2D.set_deferred("disabled", false)

func revive_player():
	print("doing revive")
	update_hp(99)
	state_machine.ChangeState($PlayerStateMachine/idle)	
