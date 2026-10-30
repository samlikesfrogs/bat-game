@tool
extends Node2D
@export var item_type:String
@export var item_name:String
@export var item_texture:Texture
@export var item_function:String
var _scene = "res://inventory_item.tscn"
@onready var sprite: Sprite2D = $Sprite2D
var player_in_range = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		sprite.texture = item_texture

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		sprite.texture = item_texture
	if player_in_range:
		pickup_item()
		
func pickup_item():
	var item = {
		"quantity":1,
		"type":item_type,
		"name":item_name,
		"function":item_function,
		"texture":item_texture,
		"scene":_scene,
		}
	InventoryManager.add_item(item)
	self.queue_free()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
