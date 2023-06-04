extends Control

var finished = false

var flag1 = 0

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


func increment_flag():
	flag1 += 1
