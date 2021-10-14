extends Node

#Spawns the weapon projectiles or effects

const Projectile =preload("res://scenes/Projectile.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")
const Laser =preload("res://scenes/Laser_Test.tscn")

func fire_weapon(weapon):
	if weapon=="red":
		_projectile_left()
	elif weapon=="blue":
		gun_right_active = true
		_projectile_right(true)
	elif weapon=="double":
		_projectile_double()
		gun_right.shoot(false)
		gun_right_active = false
		
		
		
var gun_right_active = true
var gun_left
var gun_right = Laser.instance()

"""func _ready() -> void:
	gun_left = Projectile.instance()
	gun_right = Laser.instance()
	get_tree().get_root().add_child(gun_left)
	get_tree().get_root().add_child(gun_right)
	"""

func _physics_process(delta: float) -> void:
	if get_tree().get_root().get_node_or_null("Instance/Player_Ship"):
		get_tree().get_root().get_node_or_null("Instance/Player_Ship").connect("state_idle", self, "_on_state_idle")
		gun_right.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
		gun_right.rotation_degrees -= 90
	

func _on_state_idle():

	gun_right.shoot(false)
#Right now harcoded to the three scenes Projectile, ProjectileRight and ProjectileDouble
func _projectile_left():
#	gun_left = Projectile.instance()
#	get_tree().get_root().move_child(get_node("Instance/Player_Ship/gun_left"),get_tree().get_node_count())
#	#var GunLeft = Projectile.instance()
#	gun_left.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
	return
	

func _projectile_right(is_shooting):
	
	get_tree().get_root().add_child(gun_right)
	if gun_right_active:
		gun_right.shoot(is_shooting)

func _projectile_double():
	var p = ProjectileDouble.instance()
	get_tree().get_root().add_child(p)
	p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
