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
