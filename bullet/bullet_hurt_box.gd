class_name HurtBox extends Area2D
@export var damage:int=1
@export var go_through:float
#this can be changed for power up that lets bullets go through enemies

func _ready() -> void:
	area_entered.connect(AreaEntered)

func _process(_delta: float) -> void:
	pass
	
func AreaEntered(a:Area2D)->void:
	if a is HitBox:
		a.TakeDamage(self)
		await get_tree().create_timer(go_through).timeout
		$"..".queue_free()
	
