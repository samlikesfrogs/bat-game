class_name HeartUI extends Control

@onready var sprite: Sprite2D = $Sprite2D

var value: int = 4:
	set(_value):
		value=_value
		update_sprite()

func update_sprite():
	sprite.frame = value
