extends Node2D

const MAX_ENEMIES=3
const MAX_RESPAWN_TIMER=3.0
var respawn_timer=0.0
var enemy_array=[]

const enemy=preload("res://scenes/Enemy_Ship.tscn")

func spawn_enemy():
	if respawn_timer<=0.0 and enemy_array.size()<=2:
		var e=enemy.instance()
		add_child(e)
		enemy_array.append(e)
		e.global_position=Vector2(rand_range(100,500),rand_range(200,600))
		respawn_timer=MAX_RESPAWN_TIMER
		

func _process(delta):
	spawn_enemy()
	respawn_timer-=delta
	if !get_node('Enemy_Ship'):
		enemy_array.clear()
	
