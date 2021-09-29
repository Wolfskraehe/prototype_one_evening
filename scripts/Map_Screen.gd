extends Node2D

#Must have Global.gd autoloaded to function

func _on_Button_pressed():
	Global.goto_scene("res://scenes/Instance.tscn")
	
func _on_Button2_pressed():
	Global.goto_scene("res://maps/Map01.tscn")


