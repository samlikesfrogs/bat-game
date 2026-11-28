extends Sprite2D
@onready var _hit_box: HitBox = $HitBox
var hp := 3
@export var tree_drop_rate: int = randi_range(1, 3)
@export var spawnable_items:Array = [{"type":"wood", "name":"small log", "function":"", "texture":preload("res://aart/decorations/log.png")}]
var dead:bool = false
var _direction:Vector2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	_hit_box.Damaged.connect(_take_damage)

func _take_damage(hurt_box:HurtBox):
	audio_stream_player_2d.play()
	hp -= hurt_box.damage
	var _damage_position = hurt_box.global_position
	_direction = (self.global_position).direction_to(_damage_position)
	material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)
	print("tree hp: ", hp)
	if hp <= 0:
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
		$HitBox.set_deferred("disabled", true)
		var tween := create_tween()
		tween.tween_property($".", "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
		drop_rand_items(tree_drop_rate)
		tween.finished.connect($".".queue_free)

func drop_rand_items(count):
	print("dropping items")
	var dropped = 0
	while dropped < count:
		drop_item(spawnable_items[randi()% spawnable_items.size()], Vector2(self.global_position.x, self.global_position.y))
		print(dropped)
		dropped += 1
		
func drop_item(data, position):
	var item_instance = preload("res://inventory/inventory_item.tscn").instantiate()
	item_instance.instance_item(data["type"], data["name"], data["function"], data["texture"])
	print(self.get_parent())
	self.get_parent().call_deferred("add_child", item_instance)
	item_instance.global_position = position
	item_instance.velocity = (_direction * -20).rotated(randf_range(-0.8,0.8))*randf_range(0.9, 1.2)
