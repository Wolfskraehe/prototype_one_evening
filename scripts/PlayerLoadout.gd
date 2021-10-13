extends Node

#Script that saves the Player weapon config, can be changed via the loadout menu in the map screen

var left_weapon=""
var right_weapon=""
var double_weapon=""

#sets default config if nothing is chosen in the loadout menu or the the first option was taken
func _set_default():
	left_weapon="red"
	right_weapon="blue"
	double_weapon="double"
	
#if second option in weapon loadout menu was chosen	
func _set_alternate():
	left_weapon="blue"
	right_weapon="red"
	double_weapon="double"
	
