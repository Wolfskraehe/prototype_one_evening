extends Node

const Laser =preload("res://scenes/Laser_Test.tscn")

var laser = Laser.instance()



func _ready() -> void:
	get_tree().get_root().call_deferred("add_child", laser)
	
func _physics_process(delta: float) -> void:

	if get_tree().get_root().get_node("Instance/Player_Ship/gun_position"):
		laser.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
		laser.rotation_degrees -= 90
	

func shoot(is_shooting):
	laser.shoot(is_shooting)

