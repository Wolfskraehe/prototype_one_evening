extends Node

#Spawns the weapon projectiles or effects

const Projectile_Gun =preload("res://scenes/Projectile_Gun.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")
const Laser =preload("res://scenes/Sustained_Gun.tscn")


	
var gun_left
var gun_right
#stops off signal from triggering off animation if already off
var false_flag = true 
		
		
func _ready() -> void:
	gun_left = Projectile_Gun.instance()
	gun_right = Laser.instance()
	get_tree().get_root().call_deferred("add_child", gun_right)
	get_tree().get_root().call_deferred("add_child", gun_left)
	
	
func fire_weapon(weapon):
	if weapon=="red":
		_projectile_left()
	elif weapon=="blue":
		_projectile_right()
	elif weapon=="double":
		_projectile_double()

"""func _ready() -> void:
	gun_left = Projectile.instance()
	gun_right = Laser.instance()
	get_tree().get_root().add_child(gun_left)
	get_tree().get_root().add_child(gun_right)
	"""

func _physics_process(delta: float) -> void:
	var player = get_tree().get_root().get_node_or_null("Instance/Player_Ship")
	
	if player:
#		if not player.is_connected("state_idle", self, "_on_state_idle"):
#			player.connect("state_idle", self, "_on_state_idle")
		if not player.is_connected("stop_fire_double", self, "_on_stop_fire_double"):
			player.connect("stop_fire_double", self, "_on_stop_fire_double")
		if not player.is_connected("stop_fire_left", self, "_on_stop_fire_left"):
			player.connect("stop_fire_left", self, "_on_stop_fire_left")
		if not player.is_connected("stop_fire_right", self, "_on_stop_fire_right"):
			player.connect("stop_fire_right", self, "_on_stop_fire_right")
		
	

#func _on_state_idle():
#	if false_flag == false:
#
#		false_flag = true
#		#gun_right.shoot(false)
#		#gun_left.shoot(false)
		
func _on_stop_fire_double():
		return
	
		#gun_left.shoot(false)
	#stops shutdown signal from triggering off animation if already off
	#if not false_flag: 
		#false_flag = true
		#gun_right.shoot(false)
	
	
func _on_stop_fire_left():
	

		gun_left.shoot(false)
func _on_stop_fire_right():
	#if not false_flag:
		false_flag = true
		gun_right.shoot(false)
#Right now harcoded to the three scenes Projectile, ProjectileRight and ProjectileDouble
func _projectile_left():

	gun_left.shoot(true)

func _projectile_right():
	false_flag = false
	gun_right.shoot(true)

func _projectile_double():
	
	var p = ProjectileDouble.instance()
	get_tree().get_root().add_child(p)
	p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
