extends Node

#controlls the Fire behaviour of the player ship


enum States {IDLE, SHOOT_LEFT, SHOOT_RIGHT, SHOOT_DOUBLE}

var _state : int = States.IDLE
const MAX_FIRE_DELAY=0.3
var fire_delay=0.0

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

#consume fire inputs:
#func fire_inputs():
#	if Input.is_action_pressed("fire") and Input.is_action_pressed("secondary_fire"):
#		_state = States.SHOOT_DOUBLE 
#	elif Input.is_action_pressed("fire"):
#		_state = States.SHOOT_LEFT
#	elif Input.is_action_pressed("secondary_fire"):
#		_state = States.SHOOT_RIGHT
#	else:
#		_state = States.IDLE
		
func _physics_process(delta):
	fire_delay-=delta


""""

const Projectile =preload("res://scenes/Projectile.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")



	match _state:
		States.SHOOT_LEFT:
			if fire_delay<=0.0:
				var p = Projectile.instance()
				get_tree().get_root().add_child(p) #script is global so it has to get the scene tree first 
				p.transform =get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.SHOOT_RIGHT:
			if fire_delay<=0.0:
				var p = ProjectileRight.instance()
				get_tree().get_root().add_child(p)
				p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.SHOOT_DOUBLE:
			if fire_delay<=0.0:
				var p = ProjectileDouble.instance()
				get_tree().get_root().add_child(p)
				p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.IDLE:
			return
"""
