extends Control


signal message_set()
signal message_add()
signal message_end()

@export var showname_label: RichTextLabel
@export var dialog_label: RichTextLabel
@export var letter_delay: float = 0.02

@export var blip_sound: AudioStream
@export var blip_rate: int = 3

@onready var blip_player: AudioStreamPlayer = $BlipPlayer

var process_charcters: bool = false
var process_counter: float = 0.0

var last_animation = ""
var last_animation_speed = 1.0

var blip_counter: int = 0

var parsed_text = ""

func _process(delta):
	if process_charcters:
		process_counter += delta
		if process_counter >= letter_delay:
			var count: int = int(process_counter / letter_delay)
			while (letter_delay == 0 or count > 0) and process_charcters:
				next_letter()
				count -= 1
			process_counter = 0
			var letter = parsed_text[dialog_label.visible_characters-1] if parsed_text != "" else ""
			if blip_counter == 0 and letter != "":
				blip()
			blip_counter = (blip_counter + 1) % blip_rate


func blip():
	if blip_player.stream != blip_sound:
		blip_player.stream = blip_sound
	blip_player.play()


func skip():
	if process_charcters:
		dialog_label.visible_characters = parsed_text.length()
		next_letter()


func next_letter():
	dialog_label.visible_characters += 1
	if dialog_label.visible_characters >= parsed_text.length():
		process_charcters = false
		message_end.emit()


func start_processing():
	blip_counter = 0
	process_charcters = true


func set_showname(showname):
	showname_label.text = showname
	showname_label.visible = not showname_label.text.is_empty()


func set_msg(text):
	dialog_label.visible_characters = 0
	dialog_label.text = text
	parsed_text = dialog_label.get_parsed_text()
	message_set.emit()
	start_processing()


func add_msg(text):
	dialog_label.text += text
	parsed_text = dialog_label.get_parsed_text()
	message_add.emit()
	start_processing()


func get_savedict() -> Dictionary:
	var save_dict = {
		"letter_delay": letter_delay,
		"showname": showname_label.text,
		"dialog": dialog_label.text,
		"animation": [last_animation, last_animation_speed],
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
		if key == "animation":
			$AnimationPlayer.play(value[0], -1, value[1], value[1] < 0)


func _on_animation_player_animation_started(_anim_name):
	last_animation = $AnimationPlayer.current_animation
	last_animation_speed = $AnimationPlayer.get_playing_speed()
