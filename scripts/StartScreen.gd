extends Node2D

func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/Level.tscn");

func _on_IntroBtn_pressed():
	get_tree().change_scene("res://scenes/IntroScene.tscn");
