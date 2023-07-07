extends Node


func _on_set_button_pressed():
	$MainView/DialogBox.set_showname($DebugStuff/LineEdit.text)
	$MainView/DialogBox.set_msg($DebugStuff/MsgEdit.text)
	$MainView/DialogBox.letter_delay = $DebugStuff/DelaySpinBox.value


func _on_add_button_pressed():
	$MainView/DialogBox.set_showname($DebugStuff/LineEdit.text)
	$MainView/DialogBox.add_msg($DebugStuff/MsgEdit.text)
	$MainView/DialogBox.letter_delay = $DebugStuff/DelaySpinBox.value
