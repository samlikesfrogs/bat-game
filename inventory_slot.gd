extends Control

@onready var item_icon: Sprite2D = $NinePatchRect/item_icon
@onready var item_quantity: Label = $NinePatchRect/item_quantity
@onready var info_panel: NinePatchRect = $InfoPanel
@onready var item_type: Label = $InfoPanel/type
@onready var item_name: Label = $InfoPanel/name
@onready var item_function: Label = $InfoPanel/function
@onready var usage_panel: ColorRect = $UsagePanel
signal drag_start(slot)
signal drag_end()

var item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_panel.visible = false
	usage_panel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_button_mouse_entered() -> void:
	if item != null:
		info_panel.visible = true

func _on_item_button_mouse_exited() -> void:
	if item != null:
		info_panel.visible = false

func set_empty():
	item_icon.texture=null
	item_quantity.text = ""
	
func set_item(new_item):
	item = new_item
	item_icon.texture = new_item["texture"]
	item_quantity.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["function"]!="":
		item_function.text = str("+ ", item["function"])
	else:
		item_function.text = ""



func _on_item_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if item != null:
				usage_panel.visible = !usage_panel.visible
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				drag_start.emit(self)
			else:
				drag_end.emit()
	pass # Replace with function body.


func _on_drop_pressed() -> void:
	if item != null:
		var drop_position = PlayerManager.player.global_position
		var drop_offset = Vector2(0, 50)
		drop_offset=drop_offset.rotated((PlayerManager.player.cardinal_dir).angle())
		InventoryManager.drop_item(item, drop_position+drop_offset)
		InventoryManager.remove_item(item["name"])
		usage_panel.visible=false
