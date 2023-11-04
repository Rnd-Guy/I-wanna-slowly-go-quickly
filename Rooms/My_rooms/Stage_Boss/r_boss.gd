extends Node2D

var bpm = 120
var debug_metronome = preload("res://Audio/Sounds/sndMenuButton.wav")

var music_time = 0
var seconds_per_beat = 0.5 # 60 / bpm
var last_beat = -0.5
#var offset = 0.065 # 0.05 offset for the song (not player offset)
var offset = -0.05

var frames_before_resync = 10

var beat = -2
var beat_offset = -1

@onready var phases = [
	[1, $"Phases/Intro-Intro"],
	[17,$"Trigger_related"],
	[50,$"Phases/Fake-end"],
]

func set_phase():
	for i in range(0, phases.size()-1):
		var phase = phases[i][1]
		if phases[i][0] <= beat && beat < phases[i+1][0]:
			if phase.visible != true:
				phase.set_process_mode(PROCESS_MODE_PAUSABLE)
				phase.set_visible(true)
		else:
			if phase.visible == true:
				phase.set_process_mode(PROCESS_MODE_DISABLED)
				phase.set_visible(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	seconds_per_beat = 60.0/bpm
	$objRhythmPreviewer.play_sample()
	$Room_related/objPlayer.is_boss = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	music_time += delta
	if music_time >= last_beat + seconds_per_beat + offset:
		last_beat += seconds_per_beat
		#GLOBAL_SOUNDS.play_sound(debug_metronome)
	beat = (music_time + offset)/seconds_per_beat + beat_offset
	GLOBAL_GAME.boss_beat = beat

func _physics_process(_delta):
	if frames_before_resync > 0:
		frames_before_resync -= 1
	else:
		resync_rhythm_position()
		frames_before_resync = 7

	$Debug/ms.set_text(str(music_time))
	$Debug/beat.set_text(str(beat))
	$Debug/shotbeat.set_text(str(GLOBAL_GAME.shot_beat))
	set_phase()
	debug_inputs()

func resync_rhythm_position():
	music_time = GLOBAL_MUSIC.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()


func on_the_beat():
	if fmod(music_time, seconds_per_beat) < 0.2:
		var mod = 1.5 - (fmod(music_time, seconds_per_beat) * 2.5)
		$Environment/til32x32.modulate = Color(mod, mod, mod)
	else:
		$Environment/til32x32.modulate = Color(1,1,1)

func debug_inputs():
	if Input.is_action_just_pressed("button_debug_left"):
		if music_time > 1:
			GLOBAL_MUSIC.seek(music_time-1)
		else:
			GLOBAL_MUSIC.seek(0)
	if Input.is_action_just_pressed("button_debug_right"):
		GLOBAL_MUSIC.seek(music_time+1)
