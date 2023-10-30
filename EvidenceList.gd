extends ItemList

signal show_evidence(index)


func _on_item_activated(index):
	show_evidence.emit(index)
