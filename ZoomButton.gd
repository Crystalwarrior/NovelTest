extends Button


@export var zoom_animation: AnimationPlayer


func _on_toggled(button_pressed):
	if button_pressed:
		zoom_animation.play("zoom")
	else:
		zoom_animation.play_backwards("zoom")
