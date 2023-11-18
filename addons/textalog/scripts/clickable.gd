extends Sprite2D

var outline_mat = preload("res://addons/textalog/shaders/outline.tres")
@onready var checkmark = get_node_or_null("Check")

@export var checked: bool:
	set(value):
		if checkmark:
			checkmark.visible = value
		checked = value

@export var highlight: bool = true

@export var set_campos: bool
@export var campoint: int

@export var timeline: CommandCollection


signal clicked(obj, timeline)
signal hovered(obj, tog)


func _unhandled_input(event):
	if event is InputEventMouse:
		var pos = to_local(get_global_mouse_position())
		if is_pixel_opaque(pos):
			hovered.emit(self, true)
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				clicked.emit(self, timeline)
		else:
			hovered.emit(self, false)


func outline(tog):
	material = outline_mat if tog and highlight else null


func activate():
	if set_campos:
		var cam = get_viewport().get_camera_2d()
		if cam:
			cam.set_campoint(campoint)
