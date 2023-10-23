extends Node

var debug = false

func _ready():
	pass

func _process(_delta):
	pass

func _on_button_pressed():
	if debug:
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		$CanvasModulate.fade(func(): get_tree().change_scene_to_file("res://main.tscn"))
