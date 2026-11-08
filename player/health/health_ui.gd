extends CanvasLayer
@onready var container: HFlowContainer = $HFlowContainer

var hearts:Array[HeartUI]=[]
func _ready() -> void:
	for child in container.get_children():
		if child is HeartUI:
			hearts.append(child)
			child.visible = false
	self.visible = true

func update_hp(_hp: int, _max_hp: int):
	for i in _max_hp:
		update_heart(i, _hp)
	update_max(_max_hp)
		
func update_heart(_index:int, _hp:int):
	@warning_ignore("integer_division")
	_index = _index/4
	var _value: int = clampi(_hp-_index*4, 0, 4)
	hearts[_index].value = _value
	
func update_max(_max_hp:int):
	@warning_ignore("integer_division")
	var _heart_amnt:int = round(_max_hp/4)
	for i in hearts.size():
		if i < _heart_amnt:
			hearts[i].visible = true
		else:
			hearts[i].visible=false
