extends Control

var finished = false

var waiting_on_input = true

var flag1 = 0

var flags = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if waiting_on_input and Input.is_action_just_pressed("ui_accept"):
		if finished:
			finished = false
			$CommandManager.start_timeline(0)
		else:
			$CommandManager.go_to_next_command()


func _on_command_manager_timeline_finished():
	finished = true


func _on_command_manager_command_started(command):
	waiting_on_input = false


func _on_command_manager_command_finished(command):
	waiting_on_input = true


func set_flag(flag: String, value: Variant):
	flags[flag] = value


func increment_flag():
	flag1 += 1

