extends KinematicBody2D

enum States {IDLE, SHOOT_LEFT, SHOOT_RIGHT, SHOOT_DOUBLE}
var _state : int = States.IDLE

signal state_idle

export (int) var speed = 150

export var rotation_dir : float=0
export var rotation_speed : float = 200
export var friction : float = 0.01
export var acceleration : float = 0.05
export var mouse_sensitivity := 0.05
export var relative_controls: bool =true

var velocity = Vector2()

func _ready():
	#make mouse invisible and confine to window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")

#pseudo-newtonian movement with accleration and slow deccelration, relative movement
func get_newtonian_input(delta):
	if Input.is_action_pressed("right"):
		rotation_degrees+=rotation_speed*delta
	if Input.is_action_pressed('left'):
		rotation_degrees-=rotation_speed*delta
	var move_dir=Vector2(1,0).rotated(rotation)
	if Input.is_action_pressed('up'):
		velocity=velocity.linear_interpolate(get_node("gun_position").global_transform.y,acceleration)
	if Input.is_action_pressed("strafe_left"):
		velocity=velocity.linear_interpolate(get_node("gun_position").global_transform.x,acceleration)
	if Input.is_action_pressed("strafe_right"):
		velocity=velocity.linear_interpolate(-get_node("gun_position").global_transform.x,acceleration)
	if Input.is_action_pressed("down"):
		velocity=velocity.linear_interpolate(-get_node("gun_position").global_transform.y,acceleration)
	else:
		velocity=velocity.linear_interpolate(Vector2(0,0),friction)

#version with fixed movement	
func get_newtonian_input_fixed(delta):
	if Input.is_action_pressed("right"):
		rotation_degrees+=rotation_speed*delta
	if Input.is_action_pressed('left'):
		rotation_degrees-=rotation_speed*delta
	var move_dir=Vector2(1,0).rotated(rotation)
	if Input.is_action_pressed('up'):
		velocity=velocity.linear_interpolate(get_node("gun_position").transform.y,acceleration)
	if Input.is_action_pressed("strafe_left"):
		velocity=velocity.linear_interpolate(get_node("gun_position").transform.x,acceleration)
	if Input.is_action_pressed("strafe_right"):
		velocity=velocity.linear_interpolate(-get_node("gun_position").transform.x,acceleration)
	if Input.is_action_pressed("down"):
		velocity=velocity.linear_interpolate(-get_node("gun_position").transform.y,acceleration)
	else:
		velocity=velocity.linear_interpolate(Vector2(0,0),friction)
		
	
#get input for rotation via mouse
func _input(event: InputEvent) -> void:
	
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		rotation_degrees += mouse_motion.relative.x * mouse_sensitivity
	
		
		
func fire_inputs():
	if Input.is_action_just_released("secondary_fire"):
		emit_signal("state_idle")
	if Input.is_action_pressed("fire") and Input.is_action_pressed("secondary_fire"):
		_state = States.SHOOT_DOUBLE 
	elif Input.is_action_pressed("fire"):
		_state = States.SHOOT_LEFT
	elif Input.is_action_pressed("secondary_fire"):
		_state = States.SHOOT_RIGHT
	else:
		_state = States.IDLE
		

func _physics_process(delta):
	fire_inputs()
	WeaponController.shoot(_state)
	
	if relative_controls:
		get_newtonian_input(delta)
	else:
		get_newtonian_input_fixed(delta)
		
	#fire_delay-=delta
	global_position-=move_and_slide(velocity*speed*delta)




	
"""
Old shooting mechanic for backup purposes

Weapons were moved to a global Weapon_Controller script
const Projectile =preload("res://scenes/Projectile.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")
const MAX_FIRE_DELAY=0.3
var fire_delay=0.0
enum States {IDLE, SHOOT_LEFT, SHOOT_RIGHT, SHOOT_DOUBLE}
var _state : int = States.IDLE
enum States {IDLE, SHOOT_LEFT, SHOOT_RIGHT, SHOOT_DOUBLE}
	
func shoot():
	match _state:
		States.SHOOT_LEFT:
			if fire_delay<=0.0:
				var p = Projectile.instance()
				owner.add_child(p)
				p.transform = get_node("gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.SHOOT_RIGHT:
			if fire_delay<=0.0:
				var p = ProjectileRight.instance()
				owner.add_child(p)
				p.transform = get_node("gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.SHOOT_DOUBLE:
			if fire_delay<=0.0:
				var p = ProjectileDouble.instance()
				owner.add_child(p)
				p.transform = get_node("gun_position").global_transform
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
"""
	
	
