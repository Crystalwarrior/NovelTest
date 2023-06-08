@tool
extends PanelContainer

@onready var rtf_label = $MarginContainer/HBoxContainer/RichTextLabel

@export var showname: String = "":
	get:
		if rtf_label:
			showname = rtf_label.text
			return rtf_label.text
		return showname
	set(value):
		showname = value
		if rtf_label:
			rtf_label.text = value


func _on_rich_text_label_finished():
	await get_tree().process_frame
	reset_size()
