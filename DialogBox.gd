extends Control


signal message_set()
signal message_add()
signal message_end()

@export var showname_label: RichTextLabel
@export var dialog_label: RichTextLabel
@export var letter_delay: float = 0.02

var process_charcters: bool = false
var process_counter: float = 0.0


func _process(delta):
	if process_charcters:
		process_counter += delta
		if process_counter >= letter_delay:
			var count: int = process_counter / letter_delay
			while (letter_delay == 0 or count > 0) and process_charcters:
				next_letter()
				count -= 1
			process_counter = 0


func next_letter():
	dialog_label.visible_characters += 1
	if dialog_label.visible_characters >= dialog_label.text.length():
		process_charcters = false
		message_end.emit()


func start_processing():
	process_charcters = true


func set_showname(showname):
	showname_label.text = showname


func set_msg(text):
	dialog_label.visible_characters = 0
	dialog_label.text = text
	message_set.emit()
	start_processing()


func add_msg(text):
	dialog_label.text += text
	message_add.emit()
	start_processing()


func get_savedict() -> Dictionary:
	var save_dict = {
		"letter_delay": letter_delay,
		"showname": showname_label.text,
		"dialog": dialog_label.text,
	}
	return save_dict


func load_savedict(save_dict: Dictionary):
	for key in save_dict.keys():
		var value = save_dict[key]
		if key == "showname":
			showname_label.text = value
		if key == "dialog":
			set_msg(value)
		if key == "letter_delay":
			set(key, value)
