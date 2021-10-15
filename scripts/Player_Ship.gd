extends KinematicBody2D

enum States {IDLE, SHOOT_LEFT, SHOOT_RIGHT, SHOOT_DOUBLE}
var _state : int = States.IDLE
var _previous_state : int = States.IDLE

signal state_idle
signal state_double
signal stop_fire_left
signal stop_fire_right
signal stop_fire_double

export (int) var speed = 150

export var rotation_dir : float=0
export var rotation_speed : float = 200
export var friction : float = 0.01
export var acceleration : float = 0.05
export var mouse_sensitivity := 0.05
export var relative_controls: bool =true

var velocity = Vector2()

var left_flag = false
var right_flag = false
var double_flag = false

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
	
	
#func _unhandled_input(event: InputEvent) -> void:
#
#	if event is InputEventMouseButton:
#		if event.is_action_pressed("secondary_fire"):
#			right_flag = true
#			if left_flag:
#				print("double")
#			else:
#				print("right")
#		elif event.is_action_pressed("fire"):
#			left_flag = true
#			if right_flag:
#				print("double")
#			else:
#				print("right")
#		elif event.is_action_released("strafe_left")
#		elif event.is_action_released("strafe_left")
			
const FIRE : Dictionary = {
	NONE = 0,
	LEFT = 1,
	RIGHT = 2,
	BOTH = 3
}

var fire : int = FIRE.NONE
var last_fire : int = FIRE.NONE


func _process(delta: float) -> void:
	fire_inputs()
	

func fire_inputs() -> void:
	# credit to Whitehshampoo of godot engine discord
	var new_fire = FIRE.NONE
	if Input.is_action_pressed("fire"):
		new_fire |= FIRE.LEFT
	if Input.is_action_pressed("secondary_fire"):
		new_fire |= FIRE.RIGHT
	
	if new_fire == last_fire:
		fire = FIRE.NONE
		return
	
	last_fire = new_fire
	fire = new_fire
	
	test_fire_inputs()


func test_fire_inputs() -> void:
	_previous_state = _state
	match fire:
		FIRE.NONE:
			emit_signal("stop_fire_double")
			emit_signal("stop_fire_right")
			emit_signal("stop_fire_left")
			_state = States.IDLE
			print("none")
		FIRE.LEFT:
			emit_signal("stop_fire_double")
			#emit_signal("stop_fire_right")
			_state = States.SHOOT_LEFT
			print("left")
		FIRE.RIGHT:
			_state = States.SHOOT_RIGHT
			emit_signal("stop_fire_double")
			#emit_signal("stop_fire_left")
			print("right")
		FIRE.BOTH:
			_state = States.SHOOT_DOUBLE
			if _previous_state == States.SHOOT_RIGHT:
				emit_signal("stop_fire_right")
			if  _previous_state == States.SHOOT_LEFT:
				emit_signal("stop_fire_left")
			print("both")
		_:
			prints("error (%s)" % fire)
	WeaponController.shoot(_state)
		
"""func fire_inputs():
	if Input.is_action_just_released("secondary_fire"):
		emit_signal("state_idle")
		right_flag = false
		if double_flag:
			double_flag = false
			left_flag = false
	elif Input.is_action_just_released("fire"):
		emit_signal("state_idle")
		left_flag = false
		if double_flag:
			double_flag = false
			right_flag = false
	if Input.is_action_pressed("fire") and Input.is_action_pressed("secondary_fire") and double_flag == false:
		left_flag = true
		right_flag = true
		double_flag = true
		print("double")
		emit_signal("state_idle")
		_state = States.SHOOT_DOUBLE
	elif Input.is_action_pressed("fire") and left_flag == false:
		print("fire")
		left_flag = true
		double_flag = false
		_state = States.SHOOT_LEFT
	elif Input.is_action_pressed("secondary_fire") and right_flag == false:
		right_flag = true
		double_flag = false
		print("secondary fire")
		_state = States.SHOOT_RIGHT
	else:
		#emit_signal("state_idle")
		_state = States.IDLE
"""

func _physics_process(delta):
	
	#WeaponController.shoot(_state)
	
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
	
	
