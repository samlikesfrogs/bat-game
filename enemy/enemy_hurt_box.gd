class_name EnemyHurtBox extends HurtBox

func _ready() -> void:
	area_entered.connect(AreaEntered)

func _process(_delta: float) -> void:
	pass
	
func AreaEntered(a:Area2D)->void:
	if a is HitBox:
		a.TakeDamage(self)
