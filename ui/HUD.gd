extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func  set_score(val):
	$Label.text = val
	
	
func show_escape():
	$Label2.visible = true
	
	
func show_others():
	$Label3.visible = true
	
func hide_others():
	$Label3.visible = false
	
	
func win():
	var tween = create_tween()
	$ColorRect.color = Color(0.960784, 0.960784, 0.960784, 0)
	tween.tween_property($ColorRect, "color:a", 1, 3)
	tween.tween_callback(restart)
	
	
func lose():
	var tween = create_tween()
	tween.tween_property($ColorRect, "color:a", 1, 1)
	tween.tween_callback(restart).set_delay(0.5)
	
	
func restart():
	get_tree().reload_current_scene()
