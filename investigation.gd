extends Node2D

@export var object_list:Node

@onready var polygon = $Polygon2D

signal object_clicked(obj, timeline: Timeline)

var current_hovered = -1

var polygonVector2Array: PackedVector2Array = []

func _unhandled_input(event):
	if event is InputEventMouse:
		var pos: Vector2 = to_local(get_global_mouse_position())
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			polygonVector2Array.append(pos)
			polygon.set_polygon(polygonVector2Array)


func _ready():
	for child in object_list.get_children():
		child.clicked.connect(on_object_clicked)
		child.hovered.connect(on_object_hovered)


func on_object_hovered(obj, toggle):
	var index = obj.get_index()
	if index < current_hovered:
		obj.outline(false)
		return
	if toggle:
		current_hovered = obj.get_index()
		obj.outline(true)
	else:
		current_hovered = -1
		obj.outline(false)


func on_object_clicked(obj, target_timeline: Timeline):
	if current_hovered >= 0 and obj.get_index() != current_hovered:
		return
	obj.activate()
	obj.checked = true
	object_clicked.emit(obj, target_timeline)
