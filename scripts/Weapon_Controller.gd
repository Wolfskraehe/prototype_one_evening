extends Node

const Projectile =preload("res://scenes/Projectile.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")


enum States {IDLE, SHOOT_LEFT, SHOOT_RIGHT, SHOOT_DOUBLE}

var _state : int = States.IDLE
const MAX_FIRE_DELAY=0.3
var fire_delay=0.0
var _loadout=""


func shoot():
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

#consume fire inputs:
func fire_inputs():
	if Input.is_action_pressed("fire") and Input.is_action_pressed("secondary_fire"):
		_state = States.SHOOT_DOUBLE 
	elif Input.is_action_pressed("fire"):
		print(_loadout) #for testing purposes
		_state = States.SHOOT_LEFT
	elif Input.is_action_pressed("secondary_fire"):
		_state = States.SHOOT_RIGHT
	else:
		_state = States.IDLE
		
func _physics_process(delta):
	fire_delay-=delta
