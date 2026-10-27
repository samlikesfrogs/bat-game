class_name PlayerHitBox extends HitBox

signal player_damaged(hurt_box:HurtBox)

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass
	
func TakeDamage(hurt_box:HurtBox)-> void:
	Damaged.emit(hurt_box)
