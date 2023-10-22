extends CanvasModulate

func fadeIn(callback):
	var tween = create_tween()
	tween.tween_property(self, "color", Color.WHITE, 2)
	tween.tween_callback(callback)
