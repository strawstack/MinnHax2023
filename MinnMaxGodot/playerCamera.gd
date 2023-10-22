extends Camera2D

var gc
var trackPlayer = true
var shouldRotate = false

var leoNode
var benNode

var tween

func _ready():
	gc = get_tree().root.get_node("main")
	leoNode = gc.getLeoNode()
	benNode = gc.getBenNode()

func rotateCamera(value):
	if value:
		trackPlayer = false
		set_ignore_rotation(false)
		shouldRotate = true
		var pos = get_global_position()
		tween = create_tween()
		tween.tween_property(self, "position", pos + Vector2(32, 64), 0.5)
		tween.tween_property(self, "position", pos, 0.5)
		tween.set_loops()
	else:
		tween.stop()
		trackPlayer = true
		shouldRotate = false
		set_rotation(0)
		set_ignore_rotation(true)

func _process(delta):
	var state = gc.getState()

	if shouldRotate:
		rotation += delta * 1

	if trackPlayer:
		if state["active_char"] == "ben":
			set_global_position(benNode.get_global_position())
		else:
			set_global_position(leoNode.get_global_position())
