class_name State_Walk extends State

@export var move_speed : float = 200.0
@onready var idle : State_Idle = $"../idle"
@onready var attack:State = $"../attack"
@onready var sfx_walk: AudioStreamPlayer2D = $sfx_walk
var anim_name = "walk"
var i:int=0

func Enter() -> void:
	player.updateAnim("walk")
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta:float)  -> State:
	if state_machine.current_state == State_Attack:
		return
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * move_speed
		
	if player.setDirection():
		player.updateAnim("walk")
	return null
	
func Physics(_delta:float)  -> State:
	return null
	
func HandleInput(_event:InputEvent)  -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null

#this right here is absolute bullshit

func _on_player_sprite_frame_changed() -> void:
	if $"../../PlayerSprite".animation == anim_name + "_" + player.AnimDirection():
		if i%3==0 or i == 1:
			sfx_walk.play()
		i+=1

func _on_player_sprite_animation_changed() -> void:
	if $"../../PlayerSprite".animation == anim_name + "_" + get_tree().get_first_node_in_group("player").AnimDirection():
		if i%3==0 or i == 1:
			sfx_walk.play()
		i+=1
