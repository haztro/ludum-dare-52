extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$VBoxContainer/VBoxContainer/Play.grab_focus()
	var tween = create_tween()
	tween.tween_property($ColorRect, "color:a", 0, 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().paused = false
	get_tree().get_first_node_in_group("hud").visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
		


func _on_quit_pressed():
	get_tree().quit()
