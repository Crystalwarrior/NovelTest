extends TextureRect


@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_dialog_view_wait_for_input(tog):
	if tog:
		show()
		anim.play("next")
	else:
		hide()
		anim.stop()
