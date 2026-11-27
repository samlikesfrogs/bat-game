extends Sprite2D
@onready var _hit_box: HitBox = $HitBox
var hp := 3

func _ready() -> void:
	_hit_box.Damaged.connect(_take_damage)

func _take_damage(hurt_box:HurtBox):
	hp -= hurt_box.damage
	print("tree hp: ", hp)
