extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func startTween():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 0.5, 1)

