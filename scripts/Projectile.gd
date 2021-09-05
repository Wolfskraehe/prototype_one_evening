extends Area2D

var speed = 1000

func _ready():
	connect("body_entered", self, "_on_Projectile_body_entered")

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_Projectile_body_entered(body):
	if body.is_in_group("enemy"):
		body.destroy()
	queue_free()
