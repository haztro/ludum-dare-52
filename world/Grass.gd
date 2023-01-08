extends Node3D


@export var size: float = 20
@export var step: float = 0.5
@export var prob: = 0.75

var grass_sprite_scene = preload("res://world/GrassSprite.tscn")
var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 4
	noise.fractal_lacunarity = 2
	
	#print(range(-int((size/2)/step), int((size/2)/step)))
	
	for x in range(size):
		for y in range(size):
			
			if randf() > prob:
				var g = grass_sprite_scene.instantiate()
				g.region_rect.position.x = randi_range(0, 4) * 32
				g.position.x = x - (size/2)
				g.position.z = y - (size/2)
				add_child(g)
		

