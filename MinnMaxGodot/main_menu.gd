extends Node

func _ready():
	pass

func _process(_delta):
	pass

func _on_button_pressed():
	$CanvasModulate.fade(func(): get_tree().change_scene_to_file("res://main.tscn"))
