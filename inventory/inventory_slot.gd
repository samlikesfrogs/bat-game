extends Control

@onready var item_icon: Sprite2D = $NinePatchRect/item_icon
@onready var item_quantity: Label = $NinePatchRect/item_quantity
@onready var info_panel: NinePatchRect = $InfoPanel
@onready var item_type: Label = $InfoPanel/type
@onready var item_name: Label = $InfoPanel/name
@onready var item_function: Label = $InfoPanel/function
@onready var item_button: Button = $NinePatchRect/ItemButton

signal slot_clicked(slot:Control)
signal slot_released(slot:Control)

var item = null

func _ready() -> void:
	info_panel.visible = false
	item_button.mouse_entered.connect(item_button.grab_focus)
	item_button.focus_entered.connect(_on_focus_entered)
	item_button.focus_exited.connect(_on_focus_exited)
	
func _on_focus_entered():
	if item != null and not info_panel.visible:
		info_panel.visible = true

func _on_focus_exited():
	info_panel.visible=false	

func set_empty():
	item_icon.texture=null
	item_quantity.text = ""
	
func set_item(new_item):
	item = new_item
	item_icon.texture = new_item["texture"] 
	item_quantity.text = str(int((item["quantity"]))) 
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["function"]!="":
		item_function.text = str(item["function"])
	else:
		item_function.text = ""

func _on_item_button_gui_input(event: InputEvent) -> void:	
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or event.is_action_pressed("ui_accept"):
		slot_clicked.emit(self)
		get_viewport().set_input_as_handled()
	elif (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
		slot_released.emit(self)
		#get_viewport().set_input_as_handled()
