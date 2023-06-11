extends Control

var finished = false

var waiting_on_input = true

var flags = {}:
	set(value):
		flags = value
		flags_modified.emit(flags)

signal flags_modified(flags)

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
	flags_modified.emit(flags)


func get_savedict() -> Dictionary:
	var save_dict = {
		"nodepath": get_path(),
		"timeline": $CommandManager.timeline.get_path(),
		"current_command_idx": $CommandManager.current_command_idx,
		"flags": flags,
	}
	return save_dict


func load_savedict(save_dict: Dictionary):
	if $CommandManager.current_command:
		$CommandManager._disconnect_command_signals($CommandManager.current_command)
	for key in save_dict.keys():
		if key == "timeline":
			$CommandManager.timeline = load(save_dict[key])
		if key == "current_command_idx":
			$CommandManager.current_command_idx = save_dict[key]
		if key == "flags":
			flags = save_dict[key]
	$CommandManager.start_timeline($CommandManager.current_command_idx)

