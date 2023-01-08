extends Node3D


@export var max_health = 100
@export var speed = 30


var pulling = false
var harvested = false
var health = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pulling and !harvested:
		health = max(0, health - delta * speed)
		if health <= 0:
			harvest()
	$Sprite3D.position.y = (max_health - health) / max_health
	
	
func harvest():
	Audio.play("pop", -5, randf_range(0.85, 1.15))
	$Sprite3D.position.y = 1
	var player = get_tree().get_first_node_in_group("player")
	player.release_veg()
	$Area3D.queue_free()
	var tween = create_tween()
	tween.tween_property($Sprite3D, "position:y", 1.5, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite3D, "position:y", 1, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	harvested = true
	var world = get_tree().get_first_node_in_group("world")
	world.add_score()
	$AudioStreamPlayer.stop()
	
func pull():
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	pulling = true
	
	
func release():
	$AudioStreamPlayer.stop()
	pulling = false


func _on_area_3d_area_entered(area):
	var player = area.get_parent()
	if player.is_in_group("player"):
		player.set_veg(self)


func _on_area_3d_area_exited(area):
	var player = area.get_parent()
	if player.is_in_group("player"):
		release()
		player.release_veg()

