extends KinematicBody2D

export (int) var speed = 150
const Projectile =preload("res://scenes/Projectile.tscn")

var velocity = Vector2()
var rotation_dir=0
var rotation_speed = 200
export var friction = 0.01
export var acceleration = 0.05

const MAX_FIRE_DELAY=0.5
var fire_delay=0.0
func _ready():
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
	else:
		velocity=velocity.linear_interpolate(Vector2(0,0),friction)

	
func shoot():
	if Input.is_action_pressed('fire'):
		if fire_delay<=0.0:
			var p = Projectile.instance()
			owner.add_child(p)
			p.transform = get_node("gun_position").global_transform
			fire_delay=MAX_FIRE_DELAY

func _physics_process(delta):
	#get_input()
	#shoot()
	#rotation+=rotation_dir*rotation_speed*delta
	#velocity = move_and_slide(velocity)
	#fire_delay-=delta
	
	get_newtonian_input(delta)
	shoot()
	fire_delay-=delta
	global_position-=move_and_slide(velocity*speed*delta)
	
	
