extends PanelContainer

@export var selected = false

@onready var title = $VBoxContainer/Label
@onready var icon = $VBoxContainer/Bg/Icon

var panel_deselected: StyleBox = preload("res://addons/textalog/ui/evidence_piece.tres")
var panel_selected: StyleBox = preload("res://addons/textalog/ui/evidence_piece_selected.tres")

signal select

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select.emit()

func set_selected(toggle):
	selected = toggle
	if selected:
		add_theme_stylebox_override("panel", panel_selected)
	else:
		add_theme_stylebox_override("panel", panel_deselected)
