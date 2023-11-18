extends Control


var hollow_tex = preload("res://addons/textalog/ui/hollowcircle.png")
var full_tex = preload("res://addons/textalog/ui/fullcircle.png")


@onready var container = $MarginContainer/Container


func set_statements(number: int):
	for child in container.get_children():
		child.queue_free()
	for i in range(number):
		var indicator := TextureRect.new()
		indicator.ignore_texture_size = true
		indicator.set_custom_minimum_size(Vector2i(40, 40))
		indicator.texture = hollow_tex
		indicator.name = str(i)
		container.add_child(indicator)
	set_visible(number > 0)


func select_statement(idx: int):
	for child in container.get_children():
		child.texture = hollow_tex
		if child.name == str(idx):
			child.texture = full_tex
