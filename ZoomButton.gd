extends Button


@export var zoom_animation: AnimationPlayer
@export var animation_to_play: String = "zoom"


func _on_toggled(button_pressed):
	if button_pressed:
		zoom_animation.play(animation_to_play)
	else:
		zoom_animation.play_backwards(animation_to_play)
