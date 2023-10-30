extends CanvasModulate

var fadetween: Tween


func fade(to_color: Color = Color.WHITE, duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	if duration <= 0:
		color = to_color
	else:
		fadetween = create_tween()
		fadetween.tween_property(self, "color", to_color, duration)


func fadeout(duration: float = 1.0):
	fade(Color.BLACK, duration)


func fadein(duration: float = 1.0):
	fade(Color.WHITE, duration)


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
