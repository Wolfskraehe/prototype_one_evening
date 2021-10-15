extends Node

const Projectile =preload("res://scenes/Projectile.tscn")

const MAX_FIRE_DELAY=0.3
var fire_delay=0.0
var firing = false

func shoot(is_shooting):
	firing = is_shooting

func _physics_process(delta):
	fire_delay-=delta
	
	if firing:
		if fire_delay<=0.0:
				var p = Projectile.instance()
				get_tree().get_root().add_child(p)
				p.transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").global_transform
				fire_delay = MAX_FIRE_DELAY
