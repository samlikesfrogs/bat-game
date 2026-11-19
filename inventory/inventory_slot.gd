extends Control

@onready var item_icon: Sprite2D = $item_icon
@onready var item_quantity: Label = $item_quantity
@onready var info_panel: NinePatchRect = $InfoPanel
@onready var item_type: Label = $InfoPanel/type
@onready var item_name: Label = $InfoPanel/name
@onready var item_function: Label = $InfoPanel/function

signal slot_clicked(slot:Control)
signal slot_released(slot:Control)

var item = null

func _ready() -> void:
	info_panel.visible = false
	self.mouse_entered.connect(self.grab_focus)
	self.focus_entered.connect(_on_focus_entered)
	self.focus_exited.connect(_on_focus_exited)
	self.pressed.connect(_on_pressed)
	self.gui_input.connect(_on_item_button_gui_input)
	
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

func _on_pressed():
	print("pressed")
	slot_clicked.emit(self)
	
func _on_item_button_gui_input(event: InputEvent) -> void:	
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		slot_clicked.emit(self)
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
		slot_released.emit(self)
