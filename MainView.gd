extends Control

@export var dialog_view: Node

func _gui_input(event):
	if dialog_view.pause_testimony or dialog_view.testimony.is_empty():
		dialog_view._process_timeline(event)
	else:
		dialog_view._process_testimony(event)
