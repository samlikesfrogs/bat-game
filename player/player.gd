extends CharacterBody2D
class_name Player

@export var hp: int = 6
@export var max_hp: int = 6
@onready var hit_box: HitBox = $HitBox
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine

var cardinal_dir: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var view
var invulnerable:bool=false
var can_shoot:bool

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

signal shoot
signal player_damaged(hurt_box:HurtBox)
signal player_destroyed(hurt_box:HurtBox)

func _ready():
	update_hp(99)
	hit_box.Damaged.connect(_take_damage)
	PlayerManager.player = self
	state_machine.Initialize(self)
	$PlayerSprite.animation = "idle_down"
	$PlayerSprite.flip_h = false
	can_shoot = true
	
func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if Input.is_action_just_pressed("attack") and can_shoot:
		shoot.emit(position, cardinal_dir)
		can_shoot = false
	
func _physics_process(_delta):
	move_and_slide()
	
func setDirection() -> bool:
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
	$PlayerSprite.flip_h = true if cardinal_dir == Vector2.RIGHT else false
	$PlayerSprite.offset.x = 3 if cardinal_dir == Vector2.RIGHT else 0
	return true

func AnimDirection() -> String:
	if cardinal_dir == Vector2.DOWN:
		return "down"
	elif cardinal_dir == Vector2.UP:
		return "up"
	else:
		return "side"
		
func updateAnim(state:String) -> void:
	$PlayerSprite.play (state + "_" + AnimDirection())
	
func _on_player_sprite_animation_finished() -> void:
	can_shoot = true

func _take_damage(hurt_box:HurtBox) -> void:
	if invulnerable == true:
		return
	update_hp(-hurt_box.damage)
	if hp>0:
		player_damaged.emit(hurt_box)
	else:
#		player_destroyed.emit(hurt_box)	
		player_damaged.emit(hurt_box)
		update_hp(99)
		
func update_hp(delta:int):
	hp=clampi(hp+delta, 0, max_hp)
	pass
	
func make_invulnerable( _duration) -> void:
	invulnerable = true
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	$HitBox/CollisionShape2D.set_deferred("disabled", false)
