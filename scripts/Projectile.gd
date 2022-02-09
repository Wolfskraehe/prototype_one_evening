extends Area2D

var speed = 1000
var damage=1
var damage_type="kinetic"


func shoot():
	var p = load(get_script().resource_path).new()
	get_tree().get_root().add_child(p) #script is global so it has to get the scene tree first 
	p.transform =get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform

func _ready():
	connect("body_entered", self, "_on_Projectile_body_entered")
	$Timer.connect("timeout", self, "_on_timeout")

func _physics_process(delta):
	position -= transform.y * speed * delta
	


func _on_Projectile_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("player"):
		body.take_damage(damage, damage_type)
	queue_free()

func _on_timeout():
	queue_free()
