extends Control

@onready var title = $MarginContainer/VBoxContainer/MarginContainer/Label
@onready var desc = $MarginContainer/VBoxContainer/HBoxContainer/RichTextLabel
@onready var icon = $MarginContainer/VBoxContainer/HBoxContainer/Icon


func set_evidence(evidence_dict):
	title.text = evidence_dict["name"]
	desc.text = evidence_dict["desc"]
	icon.texture = evidence_dict["icon"]
