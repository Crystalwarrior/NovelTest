extends Control


func _on_save_button_pressed():
	SaveSystem.save_game()
	$SaveButton.release_focus()


func _on_load_button_pressed():
	SaveSystem.load_game()
	$LoadButton.release_focus()
