extends Line2D

var point_nodes = []

func _ready() -> void:
	set_physics_process(false)
	clear_points()
#	self.points[0] = Vector2.ZERO
#	self.points[1] = Vector2.ZERO
	self.width = 5
	

func generate_arcs(nodes_array):
	clear_points()
	point_nodes = nodes_array
	if point_nodes.size() != 0:
		for n in point_nodes.size():
			add_point(to_local(point_nodes[n].get_global_position()))
		set_physics_process(true)
	print(point_nodes)
	
	
func _physics_process(_delta: float) -> void:
	if point_nodes.size() != 0:
		for n in points.size():
			points[n] = to_local(point_nodes[n].get_global_position())
	
		
		
