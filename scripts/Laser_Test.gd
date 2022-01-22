extends RayCast2D

var is_casting := false setget set_is_casting
var damage = 1
var damage_type = "beam"

func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO

func shoot(is_shooting):
	self.is_casting = is_shooting
		
func _physics_process(_delta: float) -> void:
	
	var cast_point := cast_to
	force_raycast_update()
	
	$CastingParticlesHit.emitting = is_colliding()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$CastingParticlesHit.global_rotation = get_collision_normal().angle()
		$CastingParticlesHit.position = cast_point
		var body = get_collider();
		if body.is_in_group("enemy"):
			body.take_damage(damage, damage_type)

	$Line2D.points[1] = cast_point
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
	
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	$CastingParticlesOrigin.emitting = is_casting
	$BeamParticles.emitting = is_casting
	
	if is_casting:
		appear()
	else:
		$CastingParticlesHit.emitting = false
		disappear()
	set_physics_process(is_casting)
	
func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 10.0, 0.2)
	$Tween.start()
	
func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, 0.1)
	$Tween.start()
