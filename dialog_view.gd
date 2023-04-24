extends Control

var finished = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			finished = false
			$CommandManager.start_timeline(0)
		else:
			$CommandManager.go_to_next_command()

func _on_command_manager_timeline_finished():
	finished = true
