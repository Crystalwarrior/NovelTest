extends Control


func _on_save_button_pressed():
	SaveSystem.save_game()
	$SaveButton.release_focus()


func _on_load_button_pressed():
	# not the best place to do it, but it does the job for the prototype.
	for chara in $"../../Characters".get_children():
		chara.queue_free()
	await get_tree().process_frame
	SaveSystem.load_game()
	$LoadButton.release_focus()
