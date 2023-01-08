extends Node3D


signal camera_shake_request(amplitude, duration)

@export var SPEED = 0.01

var player

var destination: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO
var state: int = 0
var last_state: int = 0

enum States {
	SEARCHING = 0,
	HUNTING = 1,
}

var which_foot = 0
var left_foot_angle: float = 0
var right_foot_angle: float = 0

var l_last_foot_angle: float = 0
var r_last_foot_angle: float = 0

var l_last_foot_pos = Vector3.ZERO
var r_last_foot_pos = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	state = States.HUNTING
	l_last_foot_pos = $LeftFoot.global_position
	r_last_foot_pos = $RightFoot.global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	think()
	move()
	
	
func move():
	direction = (destination - position).normalized()
	direction.y = 0
	position += direction * SPEED
	
	var rot = -Vector2(direction.x, direction.z).angle()
	var last_rot = rotation.y
	rotation.y = lerp_angle(rotation.y, rot, 0.5)
	
	if $LeftFoot.position.y >= 1.2:
		$LeftFoot.rotation.y = lerp_angle($LeftFoot.rotation.y, left_foot_angle - rotation.y, 0.05)
		$LeftFoot.position += (Vector3(0, $LeftFoot.position.y, -5) - $LeftFoot.position) * SPEED
	else:
		var vec = Vector2.from_angle($LeftFoot.rotation.y)
		$LeftFoot.position -= (Vector3(vec.x, 0, vec.y)) * SPEED
		$LeftFoot.rotation.y += last_rot - rotation.y
		
	if $RightFoot.position.y >= 1.2:
		$RightFoot.rotation.y = lerp_angle($RightFoot.rotation.y, right_foot_angle - rotation.y, 0.05)
		$RightFoot.position += (Vector3(0, $RightFoot.position.y, 5) - $RightFoot.position) * SPEED
	else:
		var vec = Vector2.from_angle($RightFoot.rotation.y)
		$RightFoot.position -= (Vector3(vec.x, 0, vec.y)) * SPEED
		$RightFoot.rotation.y += last_rot - rotation.y
	
func lerp_angle(from: float, to: float, weight: float) -> float:
	return from + short_angle_dist(from, to) * weight
	
func short_angle_dist(from: float, to: float) -> float:
	var difference = fmod(to - from, PI * 2)
	return fmod(2 * difference, PI * 2) - difference

	
func think():
	match state:
		States.SEARCHING:
			state_searching_action()
		States.HUNTING:
			state_hunting_action()
	
	
func state_searching_action():
	pass
	
	
func state_hunting_action():
	destination = player.position


func stomp(foot):	
	var rot = -Vector2(direction.x, direction.z).angle()
	
	if which_foot:
		right_foot_angle = rot
	else:
		left_foot_angle = rot
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(foot, "position:y", 10, 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(foot, "position:y", 1, 1).set_ease(Tween.EASE_IN)
	tween.tween_callback(_on_ground_stomp)

func _on_ground_stomp():
	var distance = position.distance_to(player.position)
	var val = 0
	if distance <= 50:
		val = (1 - (distance / 50)) * 0.3
		
	camera_shake_request.emit(val, 0.1)
	
	if distance < 10:
		var hud = get_tree().get_first_node_in_group("hud")
		hud.lose()
		player.set_process(false)
		player.set_process_input(false)
		player.set_physics_process(false)

func _on_timer_timeout():
	var foot = $LeftFoot if !which_foot else $RightFoot
	stomp(foot)
	which_foot ^= 1
