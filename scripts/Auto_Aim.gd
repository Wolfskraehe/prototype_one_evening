extends Node2D

const Projectile =preload("res://scenes/Projectile.tscn")

const MAX_FIRE_DELAY=0.3
var fire_delay=0.0
var firing = false
var target


func shoot(is_shooting):
	firing = is_shooting

func _physics_process(delta):
	fire_delay-=delta
	self.position = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_position
	if is_instance_valid(target):

		look_at(target.global_position)
	if firing:
		if fire_delay<=0.0:
				var p = Projectile.instance()
				get_tree().get_root().add_child(p)
				p.transform = self.global_transform
				p.rotation_degrees += 90
				fire_delay = MAX_FIRE_DELAY


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Enemy:
		print(body)
		target = body
