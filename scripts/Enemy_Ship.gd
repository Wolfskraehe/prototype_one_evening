extends KinematicBody2D

const Enemy_Procectile=preload("res://scenes/Enemy_Projectile.tscn")
const Procectile=preload("res://scenes/Enemy_Projectile_Dumb.tscn")

#general movement stats
export var speed=150.0
export var slow_radius=200.0
export var evade_radius=300.0
export var trigger_radius=1000.0
export var agility=80.0
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

func _ready():
	add_to_group("enemy")
	ray_cast=get_node("RayCast2D") #sets the fire range for the enemy 
	ray_cast.set_cast_to(fire_radius)

#function to find the player ship, align with it und follow it till slow_radius is reached
func seek():
	target=get_parent().find_node("Player_Ship")
	var to_target=position.distance_to(target.position)
	if to_target<trigger_radius:
		current_state=state.state_alerted
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * agility
		if to_target < slow_radius:
			steer*=(to_target-slow_radius)*0.7+.03
			return steer
		if to_target > evade_radius:
			return steer
		return steer
	else:
		current_state=state.state_idle
		return steer
	
func move(delta):
	acceleration += seek()
	if current_state == state.state_alerted or current_state == state.state_combat:
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
		position += velocity * delta
	else:
		#enemy lost sight of player and stops
		acceleration = Vector2.ZERO
	
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
