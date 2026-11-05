class_name Level extends Node2D

@export var opendoors: PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.y_sort_enabled
	PlayerManager.set_as_parent(self)
	#for opening in opendoors:
	#	randomize()
	#	await get_tree().create_timer(0.5).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
