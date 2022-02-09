extends KinematicBody2D

const Enemy_Procectile=preload("res://scenes/Enemy_Projectile.tscn")
const Procectile=preload("res://scenes/Enemy_Projectile_Dumb.tscn")

#general movement stats
export var speed=200.0
export var slow_radius=200.0
export var evade_radius=300.0
export var trigger_radius=1000.0
export var agility=20.0
export var hostile=true

#Defensive stats
export var hitpoints_structure=2

#weapon selection workaround for in editor use
#offensive stats
export var weapon_projectile=true
export var weapon_seeking=false
export var max_fire_delay=0.5
export var fire_radius=Vector2(0,400)

#states
enum state {state_idle, state_alerted, state_combat}
export var current_state=state.state_idle

var target=null
var acceleration=Vector2.ZERO
var velocity=Vector2.ZERO
var steer = Vector2.ZERO
var fire_delay=0.0
var ray_cast=null
var origin = Vector2.ZERO

var last_target_position = Vector2.ZERO

func _ready():
	add_to_group("enemy")
	ray_cast=get_node("RayCast2D") #sets the fire range for the enemy 
	ray_cast.set_cast_to(fire_radius)
	origin = global_position

#function to find the player ship, align with it und follow it till slow_radius is reached
func seek():
	target=get_parent().find_node("Player_Ship")
	var to_target=position.distance_to(target.position)
	if to_target<trigger_radius:
		last_target_position = target.position
		current_state = state.state_combat
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * agility
		if to_target < slow_radius:
			steer*=(to_target - slow_radius)*0.7 + .3
			return steer
		if to_target > evade_radius:
			return steer * agility
		return steer
	else:
		current_state = state.state_idle
		var desired_last_position = (last_target_position - position).normalized() * speed
		steer = (desired_last_position - velocity).normalized()*speed
		return steer
	
func move(delta):
	#acceleration += seek()
	if current_state == state.state_alerted or state.state_combat:
			acceleration += seek()
			velocity += acceleration * delta
			velocity = velocity.clamped(speed)
			rotation = velocity.angle() #mutiply by agility to make it spin like crazy
			position += velocity * delta
	
	#the enemy flys to the last position of the player and stops there spinning
	if current_state == state.state_idle:
#			acceleration += seek()
#			velocity += acceleration * delta
#			velocity = velocity.clamped(speed)
#			rotation = position.angle_to(last_target_position) #mutiply by agility to make it spin like crazy
			position += seek() * delta


			

	
func shoot():
	if hostile and ray_cast.is_colliding():
		if fire_delay<=0.0:
			if weapon_projectile:
				var p = Procectile.instance()
				get_parent().add_child(p)
				#activiates the start function of projectile only necessary for seeking projectiles
				p.start(get_node("gun_position").global_transform, target)
				fire_delay=max_fire_delay
			else:
				var p = Enemy_Procectile.instance()
				get_parent().add_child(p)
				#activiates the start function of projectile only necessary for seeking projectiles
				#seeking missles currently broken
				p.start(get_node("gun_position").global_transform, target)
				fire_delay=max_fire_delay
		
func take_damage(damage, type):
	hitpoints_structure -= damage
	
func destroy():
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
		
		
func _physics_process(delta):
	move(delta)
	shoot()
	fire_delay-=delta
	if hitpoints_structure <= 0:
		destroy()
