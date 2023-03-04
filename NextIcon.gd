extends TextureRect


@onready var anim: AnimationPlayer = $AnimationPlayer


func _on_dialog_box_message_end():
	show()
	anim.play("next")


func _on_dialog_box_message_set():
	hide()
	anim.stop()


func _on_dialog_box_message_add():
	hide()
	anim.stop()
