extends Node3D

var saved = 0
var num_veg = 0

var hud = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in get_tree().get_nodes_in_group("veg"):
		num_veg += 1
		
	hud = get_tree().get_first_node_in_group("hud")
	
	hud.set_score(str(saved) + "/" + str(num_veg))
		
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func add_score():
	saved += 1
	hud.set_score(str(saved) + "/" + str(num_veg))
	
	if saved == num_veg:
		hud.show_escape()
		$Node3D/Farmer.sicko_mode()


func _input(event):
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_area_3d_area_entered(area):
	var player = area.get_parent()
	if player.is_in_group("player"):
		if saved == num_veg:
			player.set_process(false)
			player.set_process_input(false)
			player.set_physics_process(false)
			player.stop_timer()
			hud.win()
		else:
			hud.show_others()


func _on_area_3d_area_exited(area):
	hud.hide_others()
