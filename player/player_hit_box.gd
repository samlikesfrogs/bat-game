class_name PlayerHitBox extends HitBox

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass
	
func TakeDamage(hurt_box:HurtBox)-> void:
	Damaged.emit(hurt_box)
