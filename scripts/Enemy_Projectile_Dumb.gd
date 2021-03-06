extends Area2D


var speed = 1000

var velocity = Vector2.ZERO
var target=null

var damage=1
var damage_type="kinetic"

func start(_transform, _target):
	target=_target
	global_transform = _transform
	velocity = transform.x * speed

func _ready():
	connect("body_entered", self, "_on_Projectile_body_entered")
	$Lifetime.connect("timeout", self, "_on_timeout")

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_timeout():
	queue_free()
	

func _on_Projectile_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage, damage_type)
		queue_free()

