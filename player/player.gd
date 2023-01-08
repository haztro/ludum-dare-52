extends CharacterBody3D


@export var gravity_multiplier: float = 3.0
@export var speed: float = 3
@export var acceleration: float = 8
@export var deceleration: float = 10
@export_range(0.0, 1.0, 0.05) var air_control: float = 0.3
@export var jump_height: float = 10
var direction := Vector3()
var input_axis := Vector2()
#var velocity := Vector3()
var snap := Vector3()
#var up_direction := Vector3.UP
var stop_on_slope := true
#@onready var floor_max_angle: float = deg2rad(45.0)
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)
		

var veg = null

func _process(delta):
	if Input.is_action_pressed("click"):
		if veg != null:
			veg.pull()
	elif Input.is_action_just_released("click"):
		if veg != null:
			veg.release()

# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
	
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_platform_velocity() * delta
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	accelerate(delta)
	move_and_slide()


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if input_axis.x >= 0.5:
		direction -= aim.z
	if input_axis.x <= -0.5:
		direction += aim.z
	if input_axis.y <= -0.5:
		direction -= aim.x
	if input_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	if direction.x == 0 and direction.y == 0:
		$Timer.stop()
	else:
		if $Timer.is_stopped():
			$Timer.start()


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	

func _input(event):
	pass


func set_veg(vveg):
	veg = vveg
	
	
func release_veg():
	veg = null

func stop_timer():
	$Timer.stop()

func _on_timer_timeout():
	Audio.play("step", -18, randf_range(0.85, 1.15))
