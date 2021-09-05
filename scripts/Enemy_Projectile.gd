extends Area2D

export var speed = 350

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var steer_force=25.0
var target=null

func start(_transform, _target):
	target=_target
	global_transform = _transform
	velocity = transform.x * speed
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()*steer_force
	position += velocity * delta
	
func explode():
	set_physics_process(false)
	velocity=Vector2.ZERO
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func _on_Lifetime_timeout():
	queue_free()

func _on_Projectile_body_entered(body):
	if body.is_in_group("player"):
		explode()
