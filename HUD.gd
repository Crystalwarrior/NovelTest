extends Node


func _on_set_button_pressed():
	$DialogBox.set_showname($DebugStuff/LineEdit.text)
	$DialogBox.set_msg($DebugStuff/MsgEdit.text)
	$DialogBox.letter_delay = $DebugStuff/DelaySpinBox.value


func _on_add_button_pressed():
	$DialogBox.set_showname($DebugStuff/LineEdit.text)
	$DialogBox.add_msg($DebugStuff/MsgEdit.text)
	$DialogBox.letter_delay = $DebugStuff/DelaySpinBox.value
