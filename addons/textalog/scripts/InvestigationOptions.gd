extends ItemList

@export var objects_container: Node

func _ready():
	for child in objects_container.get_children():
		add_item(child.name)
		set_item_metadata(item_count-1, child)


func _on_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		var object = get_item_metadata(index)
		object.click()
		set_item_text(index, object.name + " (checked!)")
