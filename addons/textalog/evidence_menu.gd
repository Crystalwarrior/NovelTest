extends Control

signal show_evidence(index)

@onready var gray_out = $GrayOut
@onready var evidence_box = $EvidenceViewer/EvidenceBox
@onready var evidence_scroller = $EvidenceScroller

var current_selected_evidence = -1

var evidence_list = []


func _ready():
	for evidence_dict in evidence_list:
		evidence_scroller.add_evidence(evidence_dict)


func clear_evidence():
	evidence_list.clear()
	evidence_scroller.clear_evidence()


func remove_evidence(evidence_name):
	var evidence = find_name(evidence_name)
	if not evidence:
		return
	evidence_list -= [evidence]
	evidence_scroller.remove_evidence(evidence)


func find_name(evidence_name):
	for evi in evidence_list:
		if evi["name"] == evidence_name:
			return evi


func add_evidence(_name, _desc, _icon):
	if _icon is String:
		_icon = load(_icon)
	var evidence = {
		"name": _name,
		"desc": _desc,
		"icon": _icon
	}
	evidence_list += [evidence]
	evidence_scroller.add_evidence(evidence)


func _on_evidence_scroller_selected_evidence(index):
	$EvidenceViewer.set_visible(index > -1)
	$GrayOut.set_visible(index > -1)
	current_selected_evidence = index
	if index > -1:
		evidence_box.set_evidence(evidence_list[index])


func _on_show_button_pressed():
	show_evidence.emit(current_selected_evidence)


func _on_evidence_toggled(button_pressed):
	$EvidenceScroller.set_visible(button_pressed)
	deselect_evidence()


func deselect_evidence():
	$EvidenceScroller.deselect_evidence()


func select_evidence(evi):
	if evi is String:
		evi = evidence_list.find(find_name(evi))
	if evi <= -1:
		return
	$EvidenceToggle.set_pressed(true)
	$EvidenceScroller.select_evidence(evi)
