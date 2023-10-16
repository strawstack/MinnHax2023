extends Node2D

var moving = false

func _ready():
	pass

func move(targetOffset):
	moving = true
	var tween = create_tween()
	var pos = get_position()
	tween.tween_property(self, "position", pos + targetOffset, 0.2)
	tween.tween_callback(func(): moving = false)
	
func _process(delta):
	if not moving:
		if Input.is_action_pressed("up"):
			move(Vector2(0, -32))
		if Input.is_action_pressed("right"):
			move(Vector2(32, 0))
		if Input.is_action_pressed("down"):
			move(Vector2(0, 32))
		if Input.is_action_pressed("left"):
			move(Vector2(-32, 0))
