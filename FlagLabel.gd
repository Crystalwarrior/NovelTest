extends RichTextLabel

func _on_dialog_view_flags_modified(flags):
	text = str(flags).replace("{", "{\n").replace("}", "\n}").replace(",", ",\n")
