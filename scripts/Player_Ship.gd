extends KinematicBody2D

export (int) var speed = 150
const Projectile =preload("res://scenes/Projectile.tscn")
const ProjectileRight =preload("res://scenes/Projectile_right.tscn")
const ProjectileDouble =preload("res://scenes/Projectile_double_big.tscn")

enum States {IDLE, SHOOT_LEFT, SHOOT_RIGHT, SHOOT_DOUBLE}

var _state : int = States.IDLE
var velocity = Vector2()
export var rotation_dir=0
export var rotation_speed = 200
export var friction = 0.01
export var acceleration = 0.05
export var mouse_sensitivity := 0.05

const MAX_FIRE_DELAY=0.3
var fire_delay=0.0

func _ready():
	#make mouse invisible and confine to window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	add_to_group("player")
			
#function for direct input without acceleration and friction
func get_input():
	# rotate and move
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		rotation_dir += 1
	if Input.is_action_pressed('left'):
		rotation_dir -= 1
	if Input.is_action_pressed('up'):
		velocity -= get_node("gun_position").global_transform.y * speed
	if Input.is_action_pressed("down"):
		velocity += get_node("gun_position").global_transform.y * speed

#pseudo-newtonian movement with accleration and slow deccelration
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
		
	
#get input for rotation via mouse
func _input(event: InputEvent) -> void:
	
			
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		rotation_degrees += mouse_motion.relative.x * mouse_sensitivity

	
	
func shoot():
	match _state:
		States.SHOOT_LEFT:
			print("left")
			if fire_delay<=0.0:
				var p = Projectile.instance()
				owner.add_child(p)
				p.transform = get_node("gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.SHOOT_RIGHT:
			print("right")
			if fire_delay<=0.0:
				var p = ProjectileRight.instance()
				owner.add_child(p)
				p.transform = get_node("gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.SHOOT_DOUBLE:
			print("double")
			if fire_delay<=0.0:
				var p = ProjectileDouble.instance()
				owner.add_child(p)
				p.transform = get_node("gun_position").global_transform
				fire_delay=MAX_FIRE_DELAY
		States.IDLE:
			print("idle")
			return

func _physics_process(delta):
	#consume fire inputs:
	if Input.is_action_just_released("fire"):
		if _state == States.SHOOT_LEFT:
			_state = States.IDLE
		if _state == States.SHOOT_DOUBLE:
			_state = States.SHOOT_RIGHT
	if Input.is_action_just_released("secondary_fire"):
		if _state == States.SHOOT_RIGHT:
			_state = States.IDLE
		elif _state == States.SHOOT_DOUBLE:
			_state = States.SHOOT_LEFT
			
	if Input.is_action_pressed("fire") and Input.is_action_pressed("secondary_fire"):
		#for catchin fram perfect double input - maybe not needed
		_state = States.SHOOT_DOUBLE 
	if Input.is_action_pressed("fire"):
		if _state == States.IDLE:
			_state = States.SHOOT_LEFT
		elif _state == States.SHOOT_RIGHT:
			_state = States.SHOOT_DOUBLE
	if Input.is_action_pressed("secondary_fire"):
		if _state == States.IDLE:
			_state = States.SHOOT_RIGHT
		elif _state == States.SHOOT_LEFT:
			_state = States.SHOOT_DOUBLE
	
	#get_input()
	#shoot()
	#rotation+=rotation_dir*rotation_speed*delta
	#velocity = move_and_slide(velocity)
	#fire_delay-=delta
	
	get_newtonian_input(delta)
	shoot()
	fire_delay-=delta
	global_position-=move_and_slide(velocity*speed*delta)
	
	
	
	
