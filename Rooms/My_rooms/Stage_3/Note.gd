extends Node2D

signal collided

var speed = 300
var bpm = 220
var beat = 1# which beat this note should reach the middle
var x = 100
var target_y = 490
var offset = 0
var flip = false
var time_offset = 0
var global_offset = 0

var seconds_per_beat # 60 / bpm
var time_to_reach_middle
var music_time

func _ready():
	seconds_per_beat = 60.0/bpm
	time_to_reach_middle = (beat * seconds_per_beat) + time_offset + global_offset
	resync_rhythm_position()

func resync_rhythm_position():
	global_offset = GLOBAL_SETTINGS.MUSIC_OFFSET/1000.0
	time_to_reach_middle = (beat * seconds_per_beat) + time_offset + global_offset
	music_time = GLOBAL_MUSIC.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	var distance = (time_to_reach_middle - music_time) * speed
	set_global_position(Vector2(x,target_y + offset - distance))

func _on_timer_timeout():
	resync_rhythm_position()
	pass # Replace with function body.

func on_the_beat():
	if fmod(music_time, seconds_per_beat) < 0.2:
		var mod = 1.5 - (fmod(music_time, seconds_per_beat) * 2.5)
		$Sprite2D.modulate = Color(mod, mod, mod)
	else:
		$Sprite2D.modulate = Color(1,1,1)

func _process(delta):
	$Sprite.get_material().set_shader_parameter("screen_position", global_position)

func _physics_process(delta):
	position.y += speed*delta



func _on_area_2d_body_entered(body):
	collided.emit()
	queue_free()
