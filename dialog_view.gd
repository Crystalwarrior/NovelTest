extends Control

@onready var dialogbox = $HUD/DialogBox

var finished = false
var waiting_on_input = true

var testimony: PackedStringArray = []
var current_testimony_index: int = 0

var flags = {}:
	set(value):
		flags = value
		flags_modified.emit(flags)

signal wait_for_input(tog)
signal flags_modified(flags)

signal dialog_finished
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if testimony:
		_process_testimony()
	else:
		_process_timeline()


func _process_testimony():
	if Input.is_action_just_pressed("next"):
		var target_index = (current_testimony_index + 1) % testimony.size()
		print(target_index, ' - ', testimony[target_index])
		_go_to_statement(target_index)
	if Input.is_action_just_pressed("previous"):
		var target_index = posmod(current_testimony_index - 1, testimony.size())
		print(target_index, ' - ', testimony[target_index])
		_go_to_statement(target_index)


func _go_to_statement(index: int):
	current_testimony_index = index
	$HUD/TestimonyIndicator.select_statement(current_testimony_index)
	var command_bookmark = testimony[current_testimony_index]
	var target_command = $CommandManager.current_timeline.get_command_by_bookmark(command_bookmark)
	var command_index = $CommandManager.current_timeline.get_command_idx(target_command)
	$CommandManager.go_to_command(command_index)


func _process_timeline():
	if not waiting_on_input:
		return
	if Input.is_action_just_pressed("next"):
		if finished:
			finished = false
			$CommandManager.start_timeline()
		else:
			$CommandManager.go_to_next_command()


func start_testimony(statements: PackedStringArray):
	testimony = statements
	current_testimony_index = 0
	$HUD/TestimonyIndicator.set_statements(testimony.size())
	_go_to_statement(current_testimony_index)	


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
