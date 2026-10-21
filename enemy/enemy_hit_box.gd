class_name HitBox extends Area2D

signal Damaged(damage:int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hitcollision.set_deferred("disabled", true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func TakeDamage(damage:int)-> void:
	print("TakeDamage: ", damage)
	Damaged.emit(damage)


func _on_comeout_disable() -> void:
	$hitcollision.set_deferred("disabled", false)
	pass # Replace with function body.


func _on_goin_disable_2() -> void:
	$hitcollision.set_deferred("disabled", true)
	pass # Replace with function body.
