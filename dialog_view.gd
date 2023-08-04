extends Node

@onready var dialogbox = $HUD/MainView/DialogBox
@onready var command_manager: CommandManager = $CommandManager
@onready var testimony_indicator = $HUD/MainView/DialogBox/TestimonyIndicator
@onready var characters = $Characters
@onready var backgrounds = $Background
@onready var canvas_modulate = $CanvasModulate

var finished = false
var waiting_on_input = true

var testimony: PackedStringArray = []
var testimony_timeline: Timeline
var current_testimony_index: int = 0

var pause_testimony: bool = false
var next_statement_on_pause: bool = false
var current_press: Timeline
var current_present: Timeline

var last_presented_evidence: int = -1

var current_background: String

var flags = {}:
	set(value):
		flags = value
		flags_modified.emit(flags)

signal wait_for_input(tog)
signal flags_modified(flags)

signal dialog_finished


func canvas_fade(out: bool = false, duration: float = 1.0):
	canvas_modulate.fade(out, duration)


func canvas_fadeout(duration: float = 1.0):
	canvas_fade(true, duration)


func canvas_fadein(duration: float = 1.0):
	canvas_fade(false, duration)


func add_character(res_path, charname = ""):
# multithreaded character loading, thi	s is WIP and will probably need 
# its own command node to handle more efficiently
#	ResourceLoader.load_threaded_request(res_path)
#	while(ResourceLoader.load_threaded_get_status(res_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS):
#		await get_tree().process_frame
#	var chara = ResourceLoader.load_threaded_get(res_path).instantiate()

	var chara = load(res_path).instantiate()
	if not charname.is_empty():
		chara.name = charname
	chara.add_to_group("save")
	characters.add_child(chara)


func get_character(charname):
	for chara in characters.get_children():
		if chara.name == charname:
			return chara
	return null


func remove_character(charname):
	var chara = get_character(charname)
	if chara:
		chara.queue_free()


func set_background(res_path):
	clear_background()

	var bg = load(res_path)
	if bg is PackedScene:
		bg = bg.instantiate()
	else:
		var sprite: TextureRect = TextureRect.new()
		sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		sprite.texture = bg
		sprite.layout_mode = 1
		sprite.anchors_preset = sprite.PRESET_FULL_RECT
		bg = sprite
	current_background = res_path
	backgrounds.add_child(bg)


func clear_background():
	current_background = ""
	for child in backgrounds.get_children():
		child.queue_free()


func _unhandled_input(event):
	if pause_testimony or testimony.is_empty():
		_process_timeline(event)
	else:
		_process_testimony(event)


func _process_testimony(event):
	if event.is_action_pressed("next"):
		go_to_next_statement()
	elif event.is_action_pressed("previous"):
		go_to_previous_statement()
	elif event.is_action_pressed("press") and current_press:
		press()


func go_to_next_statement():
	var target_index = (current_testimony_index + 1) % testimony.size()
	go_to_statement(target_index)


func go_to_previous_statement():
	var target_index = posmod(current_testimony_index - 1, testimony.size())
	go_to_statement(target_index)


func go_to_statement(index: int):
	command_manager._disconnect_command_signals(command_manager.current_command)
	current_testimony_index = index
	testimony_indicator.select_statement(current_testimony_index)
	var command_bookmark = testimony[current_testimony_index]
	var target_command = testimony_timeline.get_command_by_bookmark(command_bookmark)
	var command_index = testimony_timeline.get_command_idx(target_command)
	command_manager.go_to_command(command_index, testimony_timeline)


func _process_timeline(event):
	if not waiting_on_input:
		return
	if event.is_action_pressed("next"):
		if finished:
			finished = false
			command_manager.start_timeline()
		else:
			command_manager.go_to_next_command()


func set_statements(statements: PackedStringArray):
	testimony_timeline = command_manager.current_timeline
	testimony = statements
	testimony_indicator.set_statements(testimony.size())


func start_testimony(statements: PackedStringArray = []):
	pause_testimony = false
	current_testimony_index = 0
	if not statements.is_empty():
		set_statements(statements)
	go_to_statement(current_testimony_index)


func stop_testimony():
	pause_testimony = false
	testimony_timeline = null
	testimony.clear()
	current_press = null
	current_present = null
	current_testimony_index = 0
	testimony_indicator.set_statements(0)


func set_press(timeline: Timeline):
	current_press = timeline


func set_present(timeline: Timeline):
	current_present = timeline


func press():
	pause_testimony = true
	next_statement_on_pause = true
	command_manager._disconnect_command_signals(command_manager.current_command)
	command_manager.start_timeline(current_press)


func dialog(showname: String = "", text: String = "", additive: bool = false, letter_delay: float = 0.02) -> void:
	dialogbox.letter_delay = letter_delay
	dialogbox.set_showname(showname)
	if additive:
		dialogbox.add_msg(text)
	else:
		dialogbox.set_msg(text)


func set_flag(flag: String, value: Variant):
	flags[flag] = value
	flags_modified.emit(flags)


func get_savedict() -> Dictionary:
	var save_dict = {
		"timeline": command_manager.current_timeline.get_path(),
		"current_command_idx": command_manager.current_command_idx,
		"flags": flags,
		"history": command_manager._history,
		"jump_history": command_manager._jump_history,
		"background": current_background,
	}
	return save_dict


func load_savedict(save_dict: Dictionary):
	if command_manager.current_command:
		command_manager._disconnect_command_signals(command_manager.current_command)
	for key in save_dict.keys():
		if key == "timeline":
			command_manager.current_timeline = load(save_dict[key])
		if key == "current_command_idx":
			command_manager.current_command_idx = save_dict[key]
		if key == "flags":
			flags = save_dict[key]
		if key == "history":
			command_manager._history = save_dict[key]
		if key == "jump_history":
			command_manager._jump_history = save_dict[key]
		if key == "background":
			set_background(save_dict[key])
	command_manager.start_timeline(null, command_manager.current_command_idx)


func _on_command_manager_timeline_finished():
	if pause_testimony:
		pause_testimony = false
		if next_statement_on_pause:
			go_to_next_statement()
		else:
			go_to_statement(current_testimony_index)
		return
	finished = true


func _on_command_manager_command_started(_command):
	waiting_on_input = false
	wait_for_input.emit(false)


func _on_command_manager_command_finished(_command):
	waiting_on_input = true
	wait_for_input.emit(true)


func _on_dialog_box_message_end():
	dialog_finished.emit()


func _on_present_evidence(index):
	if pause_testimony or current_present == null:
		return
	last_presented_evidence = index
	pause_testimony = true
	next_statement_on_pause = false
	command_manager._disconnect_command_signals(command_manager.current_command)
	command_manager.start_timeline(current_present)
