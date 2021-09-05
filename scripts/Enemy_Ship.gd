extends KinematicBody2D

const Enemy_Procectile=preload("res://scenes/Enemy_Projectile.tscn")

const MAX_FIRE_DELAY=0.5
var velocity=Vector2.ZERO
var speed=50.0
var slow_radius=200.0
var acceleration=Vector2.ZERO
var steer_force=25.0
var fire_delay=0.0
var target=null

func _ready():
	add_to_group("enemy")
	target=get_parent().find_node("Player_Ship")
	
func seek():
	var steer = Vector2.ZERO
	var to_target=position.distance_to(target.position)
	var desired = (target.position - position).normalized() * speed
	steer = (desired - velocity).normalized() * steer_force
	if to_target < slow_radius:
		steer*=(to_target-slow_radius)*0.8+.02
		return steer
	else:
		return steer
	
func move(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
	
func shoot():
	if fire_delay<=0.0:
		var p = Enemy_Procectile.instance()
		get_parent().add_child(p)
		p.start(get_node("gun_position").global_transform, target)
		fire_delay=MAX_FIRE_DELAY
		
func destroy():
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
		
		
func _physics_process(delta):
	move(delta)
	shoot()
	fire_delay-=delta
