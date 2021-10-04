extends Area2D

var speed = 1000

func _ready():
	connect("body_entered", self, "_on_Projectile_body_entered")
	$Timer.connect("timeout", self, "_on_timeout")

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_Projectile_body_entered(body):
	if body.is_in_group("enemy"):
		body.destroy()
	queue_free()

func _on_timeout():
	queue_free()
