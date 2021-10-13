extends Node2D

var opt_button=null
#Must have Global.gd autoloaded to function

func _ready():
	opt_button=get_node("Loadout/OptionButton")
	opt_button.add_item("First Weapon Loadout")
	opt_button.add_item("Second Weapon Loadout")
	opt_button.select(-1)
	
func _on_Button2_pressed():
	Global.goto_scene("res://maps/Map01.tscn")

func _on_TextureButton_pressed():
	#Global.goto_scene("res://scenes/Instance.tscn")
	get_node("MapDescription").popup()


func _on_LoadoutButton_pressed():
	get_node("Loadout").popup()


func _on_OptionButton_item_selected(index):
	
	#for testing
	if index==0:
		PlayerLoadout._set_default()
	else:
		PlayerLoadout._set_alternate()


func _on_StartButton_pressed():
	
	#if nothing selected in loadout
	if opt_button.selected==0:
		PlayerLoadout._set_default()
		
	Global.goto_scene("res://maps/Map01.tscn")
