extends KinematicBody2D

const MAX_INTERACTION_DELAY=0.5
var player_docked=false
var interaction_delay=0.0

func _on_Interact_Shape_body_entered(body):
	if body.is_in_group("player"):
		print("Interaction range reached")
		player_docked=true
		interaction_delay=MAX_INTERACTION_DELAY
		
func _on_Interact_Shape_body_exited(body):
	if body.is_in_group("player"):
		print("Leaving interaction range")
		player_docked=false
		

func _physics_process(delta):
	interaction_delay-=delta
	if player_docked and interaction_delay<=0:
		if Input.is_action_pressed("use"):
				print("Docking with station")
