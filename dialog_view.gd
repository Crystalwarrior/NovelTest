extends Control

@onready var dialogbox = $HUD/DialogBox

var finished = false
var waiting_on_input = true

var flags = {}:
	set(value):
		flags = value
		flags_modified.emit(flags)

signal wait_for_input(tog)
signal flags_modified(flags)

signal dialog_finished
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if waiting_on_input and Input.is_action_just_pressed("ui_accept"):
		if finished:
			finished = false
			$CommandManager.start_timeline()
		else:
			$CommandManager.go_to_next_command()


func dialog(showname: String = "", dialog: String = "", additive: bool = false, letter_delay: float = 0.02) -> void:
	dialogbox.letter_delay = letter_delay
	dialogbox.set_showname(showname)
	if additive:
		dialogbox.add_msg(dialog)
	else:
		dialogbox.set_msg(dialog)


func set_flag(flag: String, value: Variant):
	flags[flag] = value
	flags_modified.emit(flags)


func get_savedict() -> Dictionary:
	var save_dict = {
		"timeline": $CommandManager.current_timeline.get_path(),
		"current_command_idx": $CommandManager.current_command_idx,
		"flags": flags,
	}
	return save_dict


func load_savedict(save_dict: Dictionary):
	if $CommandManager.current_command:
		$CommandManager._disconnect_command_signals($CommandManager.current_command)
	for key in save_dict.keys():
		if key == "timeline":
			$CommandManager.current_timeline = load(save_dict[key])
		if key == "current_command_idx":
			$CommandManager.current_command_idx = save_dict[key]
		if key == "flags":
			flags = save_dict[key]
	$CommandManager.start_timeline(null, $CommandManager.current_command_idx)


func _on_command_manager_timeline_finished():
	finished = true


func _on_command_manager_command_started(command):
	waiting_on_input = false
	wait_for_input.emit(false)


func _on_command_manager_command_finished(command):
	waiting_on_input = true
	wait_for_input.emit(true)


func _on_dialog_box_message_end():
	dialog_finished.emit()
