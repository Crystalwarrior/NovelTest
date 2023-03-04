extends TextureRect


@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_dialog_box_message_set():
	anim.stop()
	anim.play("spin")
