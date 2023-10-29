extends Node2D

var is_inside = false
var is_playing = false

@export var song_id: AudioStream = null
@export var loop_start: float = 0.0
@export var loop_end: float = 0.0

var prev_song_id
var prev_loop_start
var prev_loop_end
var prev_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_inside && Input.is_action_just_pressed("button_up"):
		if !is_playing:
			play_sample()
		else:
			on_sample_finish()
	
	if is_inside:
		$UpArrow.visible = true
	else:
		$UpArrow.visible = false
	
func play_sample():
	is_playing = true
	# remember the previous so we remember where we left off
	prev_song_id = GLOBAL_MUSIC.song_id
	prev_loop_start = GLOBAL_MUSIC.loop_start
	prev_loop_end = GLOBAL_MUSIC.loop_end
	prev_position = GLOBAL_MUSIC.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	
	GLOBAL_MUSIC.song_id = song_id
	GLOBAL_MUSIC.loop_start = loop_start
	GLOBAL_MUSIC.loop_end = loop_end
	GLOBAL_MUSIC.set_process_mode(PROCESS_MODE_PAUSABLE)
	GLOBAL_MUSIC.music_update_and_play()
	GLOBAL_MUSIC.finished.connect(on_sample_finish)

func on_sample_finish():
	is_playing = false
	GLOBAL_MUSIC.finished.disconnect(on_sample_finish)
	GLOBAL_MUSIC.song_id = prev_song_id
	GLOBAL_MUSIC.loop_start = prev_loop_start
	GLOBAL_MUSIC.loop_end = prev_loop_end
	GLOBAL_MUSIC.set_process_mode(PROCESS_MODE_ALWAYS)
	GLOBAL_MUSIC.music_update_and_play()
	GLOBAL_MUSIC.seek(prev_position)
	

func _on_area_2d_body_entered(_body):
	is_inside = true
	pass # Replace with function body.


func _on_area_2d_body_exited(_body):
	is_inside = false
	pass # Replace with function body.
