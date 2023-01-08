extends Camera3D

var shake = 0
var timer = Timer.new()

func _ready():
	timer.timeout.connect(_on_Timer_timeout)
	timer.one_shot = true
	add_child(timer)
	connect_to_shakers()
	
func _process(_delta):
	shake_camera()

func shake_camera():
	h_offset = shake * randi_range(-1, 1)
	v_offset = shake * randi_range(-1, 1)
		
func _camera_shake_requested(amplitude=0.1, duration=0.1):
	shake = amplitude
	if !timer.is_stopped():
		timer.wait_time += duration
	else:
		timer.wait_time = duration
		timer.start()
		
func _on_Timer_timeout():
	shake = 0
		
func connect_to_shakers():
	for cs in get_tree().get_nodes_in_group("camera_shaker"):
		cs.camera_shake_request.connect(_camera_shake_requested)
