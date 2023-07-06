extends ItemList

signal present_evidence(index)


func _on_item_activated(index):
	present_evidence.emit(index)
