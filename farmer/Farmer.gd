extends Node3D


var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = (player.position - position).normalized()
	dir.y = 0
	
	rotation.y = -Vector2(dir.x, dir.z).angle()
	
	position += dir * 0.02
