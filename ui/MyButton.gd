extends Button


@export var outline_colour = Color(0, 0, 0, 1)
@export var offset_amount = Vector2(-66, 7)

# Called when the node enters the scene tree for the first time.
func _ready():
	init_button()
	
	
func set_text(val):
	$Label.text = val
	text = val

func init_button():
	$Label.text = text
	$Label.visible = true
#	$Label.get_font("font").outline_color = outline_colour


func _on_focus_entered():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($Label, "position", offset_amount, 0.2)


func _on_focus_exited():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($Label, "position", Vector2.ZERO, 0.2)


func _on_mouse_entered():
	grab_focus()


func _on_mouse_exited():
	release_focus()
