extends Control

@export var dialog_view: Node

func _gui_input(event):
	if dialog_view.pause_testimony or dialog_view.testimony.is_empty():
		dialog_view._process_timeline(event)
	else:
		dialog_view._process_testimony(event)


func fade(speed: float = 1.0, block_mouse: bool = false):
	$DialogBox/AnimationPlayer.play("fade", -1, speed, speed < 0)
	mouse_filter = Control.MOUSE_FILTER_STOP if block_mouse else Control.MOUSE_FILTER_IGNORE


func fadeout():
	if $DialogBox.modulate == Color.TRANSPARENT:
		return
	fade(1.0, false)

func fadein():
	if $DialogBox.modulate != Color.TRANSPARENT:
		return
	fade(-1.0, true)
