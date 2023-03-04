@tool
extends PanelContainer


func _on_rich_text_label_finished():
	await get_tree().process_frame
	reset_size()
