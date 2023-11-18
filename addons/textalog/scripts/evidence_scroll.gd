extends PanelContainer

@onready var evidence_container = $ScrollContainer/HBoxContainer

var evidence_piece: PackedScene = preload("res://addons/textalog/scenes/evidence_piece.tscn")

signal selected_evidence(index)


func clear_evidence():
	for child in evidence_container.get_children():
		child.queue_free()


func remove_evidence(evidence):
	for child in evidence_container.get_children():
		if child == evidence or child.name == evidence:
			child.queue_free()


func add_evidence(evidence_dict):
	var new_evidence = evidence_piece.instantiate()
	evidence_container.add_child(new_evidence)
	new_evidence.name = evidence_dict["name"]
	new_evidence.title.text = evidence_dict["name"]
	new_evidence.icon.texture = evidence_dict["icon"]
	new_evidence.select.connect(select_evidence.bind(new_evidence.get_index()))


func deselect_evidence():
	for child in evidence_container.get_children():
		child.set_selected(false)
	selected_evidence.emit(-1)


func select_evidence(index):
	if index < 0:
		deselect_evidence()
		return
	var selected = evidence_container.get_child(index)
	if not selected:
		return
	if selected.selected:
		selected.set_selected(false)
		selected_evidence.emit(-1)
		return
	for child in evidence_container.get_children():
		child.set_selected(child == selected)
	selected_evidence.emit(index)
