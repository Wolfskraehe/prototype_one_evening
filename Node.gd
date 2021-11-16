extends Node2D

export(float, 0, 50, 0.5) var lifetime_length

onready var ShieldParticles = $Particles2D


var running := false

func _ready() -> void:
	add_to_group("player")
	running = false
	$CollisionShape2D.disabled = true
	ShieldParticles.visible = false
	ShieldParticles.emitting = false

func trigger() -> void:
	if running == false:
		running = true
		$Lifetime.start(lifetime_length)
		$CollisionShape2D.disabled = false
		ShieldParticles.visible = true
		ShieldParticles.emitting = true
	

func _on_Lifetime_timeout() -> void:
	running = false
	$CollisionShape2D.disabled = true
	ShieldParticles.visible = false
	ShieldParticles.emitting = false
	

func _physics_process(delta: float) -> void:
	if running:
		global_position = get_tree().get_root().get_node("Instance/Player_Ship").global_position


func _on_PlayerShield_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_Projectiles"):
		area.queue_free()
