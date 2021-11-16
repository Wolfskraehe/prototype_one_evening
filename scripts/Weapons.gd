extends Node

const Ability_A = preload("res://scenes/PlayerShield.tscn")
const Ability_B = preload("res://scenes/PlayerShield.tscn")

#Spawns the weapon projectiles or effects

const Projectile_Gun =preload("res://scenes/Projectile_Gun.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")
const Laser =preload("res://scenes/Sustained_Gun.tscn")

	
var gun_left
var gun_right
var ability_a_instance
var ability_b_instance
var left_gun_false_flag = false
var right_gun_false_flag = false
		
const MAX_FIRE_DELAY=0.3
var fire_delay=0.0
		
func _ready() -> void:
	ability_a_instance = Ability_A.instance()
	ability_b_instance = Ability_B.instance()
	gun_left = Projectile_Gun.instance()
	gun_right = Laser.instance()
	get_tree().get_root().call_deferred("add_child", gun_right)
	get_tree().get_root().call_deferred("add_child", gun_left)
	get_tree().get_root().call_deferred("add_child", ability_a_instance)
	get_tree().get_root().call_deferred("add_child", ability_b_instance)
#	call_deferred("reparent", ability_a_instance, get_tree().get_root().get_node("Instance/Player_Ship"))
#	call_deferred("reparent", ability_b_instance, get_tree().get_root().get_node("Instance/Player_Ship"))
var _left_weapon=""
var _right_weapon=""
var _double_weapon=""

func _get_weapons():
	PlayerLoadout._set_default()
	_left_weapon=PlayerLoadout.left_weapon
	_right_weapon=PlayerLoadout.right_weapon
	_double_weapon=PlayerLoadout.double_weapon

func shoot(state):
	_get_weapons()
	#print("passedState:" + state as String)
	#print("waitingState" + _state as String)
	match state:
		1:
			Weapons.fire_weapon(_left_weapon) #Calls global Weapon Script
		2:
			Weapons.fire_weapon(_right_weapon)

		3:
			if fire_delay<=0.0:
				Weapons.fire_weapon(_double_weapon)
				fire_delay=MAX_FIRE_DELAY
		0:
			return

func _physics_process(delta: float) -> void:
	fire_delay-=delta

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	
func stop_fire() -> void:
	if not left_gun_false_flag:
		left_gun_false_flag = true
		gun_left.shoot(false)
	if not right_gun_false_flag:
		right_gun_false_flag = true
		gun_right.shoot(false)

func trigger_ability_a():
	ability_a_instance.trigger()
func trigger_ability_b():
	ability_b_instance.trigger()

#Right now harcoded to the three scenes Projectile, ProjectileRight and 
func fire_left():
	left_gun_false_flag = false
	gun_left.shoot(true)

func fire_right():
	right_gun_false_flag = false
	gun_right.shoot(true)

func fire_double():
	var p = ProjectileDouble.instance()
	get_tree().get_root().add_child(p)
	p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
