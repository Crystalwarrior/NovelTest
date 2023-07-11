extends CanvasModulate

var fadetween: Tween


func fade(out: bool = false, duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	fadetween = create_tween()
	fadetween.tween_property(self, "color", Color.BLACK if out else Color.WHITE, duration)


func fadeout(duration: float = 1.0):
	fade(true, duration)


func fadein(duration: float = 1.0):
	fade(false, duration)


func get_savedict() -> Dictionary:
	if fadetween:
		fadetween.custom_step(9999)
		fadetween.kill()
	var save_dict = {
		"color": color,
	}
	return save_dict


func load_savedict(save_dict: Dictionary):
	if fadetween:
		fadetween.kill()
	for key in save_dict.keys():
		if key == "color":
			color = save_dict[key]
