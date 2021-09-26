extends Area2D


var speed = 1000

var velocity = Vector2.ZERO
var target=null

func start(_transform, _target):
	target=_target
	global_transform = _transform
	velocity = transform.x * speed

func _ready():
	connect("body_entered", self, "_on_Projectile_body_entered")

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_Lifetime_timeout():
	queue_free()
	

