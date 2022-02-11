extends Node2D

const MAX_JUMPS = 6

var body_array = []

const MAX_FIRE_DELAY=0.3
var fire_delay=0.0
var firing = false
#var target


func generate_arc_waypoints(jumps):
	var arc_waypoint_array = []
	var enemy_array = body_array.duplicate()
	enemy_array.pop_front()
	arc_waypoint_array.append(body_array[0])
	
	for n in min(enemy_array.size(), jumps):
		var nearest_enemy = find_nearest(arc_waypoint_array[n], enemy_array)
		arc_waypoint_array.append(nearest_enemy)
		enemy_array.erase(nearest_enemy)
	return arc_waypoint_array
	

func find_nearest(origin, enemy_array):
	if enemy_array.size() == 0:
		return
	var nearest_enemy = enemy_array[0]
	for enemy in enemy_array:
		if origin.get_global_position().distance_to(enemy.get_global_position()) < origin.get_global_position().distance_to(nearest_enemy.get_global_position()):
			nearest_enemy = enemy
	return nearest_enemy
	
func shoot(is_shooting):
	var waypoints = generate_arc_waypoints(MAX_JUMPS);
	print(waypoints)
	get_tree().get_root().get_node("Instance/Arc_Factory").generate_arcs(generate_arc_waypoints(MAX_JUMPS))
	
#	firing = is_shooting

func _physics_process(delta):
	
	fire_delay-=delta
	
	transform = get_tree().get_root().get_node("Instance/Player_Ship/gun_position").get_global_transform()
	if firing:
		if fire_delay<=0.0:
			
			fire_delay = MAX_FIRE_DELAY



func _on_Area2D_body_entered(body: Node) -> void:
	print(body_array)
	body_array.append(body)
	print(body_array)	


func _on_Area2D_body_exited(body: Node) -> void:
	print(body_array)
	body_array.erase(body)
	print(body_array)
	
