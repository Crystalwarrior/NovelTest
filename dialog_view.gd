extends Control


func _on_set_button_pressed():
	$DialogBox.set_msg($MsgEdit.text)
	$DialogBox.letter_delay = $DelaySpinBox.value


func _on_add_button_pressed():
	$DialogBox.add_msg($MsgEdit.text)
	$DialogBox.letter_delay = $DelaySpinBox.value
