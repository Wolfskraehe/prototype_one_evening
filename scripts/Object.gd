extends KinematicBody2D

func _on_Interact_Shape_body_entered(body):
	if body.is_in_group("player"):
		print("Interaction range reached")


func _on_Interact_Shape_body_exited(body):
	if body.is_in_group("player"):
		print("Leaving interaction range")
