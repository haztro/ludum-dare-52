extends Node

var audio_files = \
{
	"step" : ["res://assets/audio/step.wav", "SFX", 0],
	"pull" : ["res://assets/audio/pull.wav", "SFX", 0],
	"pop" : ["res://assets/audio/pop.wav", "SFX", 0],
}

var audio_streams = {}
var audio_buses = {}
var audio_stream_players = {}
var time_last_played = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_audio() # probs change 
	
	
func load_audio():
	for key in audio_files:
		var stream = load(audio_files[key][0])
		stream.set_loop_mode(audio_files[key][2])
		audio_streams[key] = stream 
		audio_buses[key] = audio_files[key][1]
		time_last_played[key] = 0


func play(sound_name, volume = -3, pitch = 1.0, fade = 0):
	if !audio_streams.has(sound_name):
		print("Cannot find sound %s" % sound_name)
		return
		
	var stream_player = AudioStreamPlayer.new()
	stream_player.finished.connect(self._on_sound_finished.bind(stream_player))
	stream_player.set_stream(audio_streams[sound_name])
	stream_player.set_bus(audio_buses[sound_name])
	stream_player.set_pitch_scale(pitch)
	stream_player.set_volume_db(volume)
	add_sound(stream_player)
	
	if fade != 0:
		stream_player.volume_db = -80
		var t = get_tree().create_tween()
		t.tween_property(stream_player, "volume_db", volume, fade).from(-80)
		t.tween_callback(self._on_fade_finished.bind(t))
	
	stream_player.play()
	time_last_played[sound_name] = Time.get_unix_time_from_system()

func stop(sound_name):
	pass

func add_sound(sound):
	add_child(sound)
	
func remove_sound(sound):
	sound.queue_free()
	remove_child(sound)

func _on_sound_finished(sound):
	remove_sound(sound)
	
func _on_fade_finished(object, path, fade):
	fade.queue_free()
	remove_child(fade)
	
