extends Node2D

@export var object_list:Node

signal object_clicked(obj, timeline: CommandCollection)

var current_hovered = -1

func _ready():
	for child in object_list.get_children():
		child.clicked.connect(on_object_clicked)
		child.hovered.connect(on_object_hovered)
	$Camera2D.make_current()


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


func on_object_clicked(obj, target_timeline: CommandCollection):
	if current_hovered >= 0 and obj.get_index() != current_hovered:
		return
	obj.activate()
	object_clicked.emit(obj, target_timeline)
