extends Camera2D


onready var player=get_parent().find_node("Player_Ship")

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	position=player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
