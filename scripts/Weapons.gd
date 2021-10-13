extends Node

#Spawns the weapon projectiles or effects

const Projectile =preload("res://scenes/Projectile.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")

func fire_weapon(weapon):
	if weapon=="red":
		_projectile_left()
	elif weapon=="blue":
		_projectile_right()
	elif weapon=="double":
		_projectile_double()
		
	
#Right now harcoded to the three scenes Projectile, ProjectileRight and ProjectileDouble
func _projectile_left():
				var p = Projectile.instance()
				get_tree().get_root().add_child(p) #script is global so it has to get the scene tree first 
				p.transform =get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform

func _projectile_right():
				var p = ProjectileRight.instance()
				get_tree().get_root().add_child(p)
				p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform

func _projectile_double():
				var p = ProjectileDouble.instance()
				get_tree().get_root().add_child(p)
				p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
