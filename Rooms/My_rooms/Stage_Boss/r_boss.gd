extends Node2D

# for debugging - skip to this phase via "o"
@onready var phase_to_seek = $Phases/Minigame5
var speed_on_debug = 10

var bpm = 120
var debug_metronome = preload("res://Audio/Sounds/sndMenuButton.wav")

var music_time = 0
var seconds_per_beat = 0.5 # 60 / bpm
var last_beat = -0.5
#var offset = 0.065 # 0.05 offset for the song (not player offset)
var offset = -0.05
var boss_hp = 2500

var frames_before_resync = 10

var beat = -2
var beat_offset = -1

var stop_processing = false

@onready var phases = [
	# beat start, phase node, active (first is false, rest should be true)
	[-10, $"Phases/BeforeIntro", false],
	[1, $"Phases/Intro-Intro", true],
	[17,$"Phases/Beep-boop-1", true],
	[49,$"Phases/Minigame1", true],
	[81,$"Phases/Minigame2", true],
	[113,$"Phases/Transition1", true],
	[117,$"Phases/Chorus1", true],
	[149,$"Phases/PostChorus1", true],
	[181,$"Phases/Transition2", true],
	[185,$"Phases/Minigame3", true],
	[217,$"Phases/Minigame4", true],
	[249,$"Phases/Minigame5", true],
	[281,$"Phases/Transition3", true],
	[285,$"Phases/Chorus2", true],
	[317,$"Phases/Chorus2_part2", true],
	[349,$"Phases/PostChorus2", true],
	[381,$"Phases/Final", true],
	[397,$"Phases/End", true], 
	[1000,$"Phases/Fake-end", true], 
]

func set_phase():
	if !%objPlayer:
		return
	for i in range(0, phases.size()-1):
		var phase = phases[i][1]
		if phases[i][0] <= beat && beat < phases[i+1][0]:
			#if phase.visible != true:
			if phases[i][2] == false:
				phases[i][2] = true
				phase.set_process_mode(PROCESS_MODE_PAUSABLE)
				phase.set_visible(true)
				if phase.has_method("setup"):
					phase.setup()
		else:
			#if phase.visible == true: # attempts to be efficient but makes it hard to create new phases in editor
			if phases[i][2] == true:
				phases[i][2] = false
				phase.set_process_mode(PROCESS_MODE_DISABLED)
				phase.set_visible(false)
				if phase.has_method("reset"):
					phase.reset()

# Called when the node enters the scene tree for the first time.
func _ready():
	seconds_per_beat = 60.0/bpm
	$objRhythmPreviewer.play_sample()
	$Room_related/objPlayer.is_boss = true
	#$Room_related/objPlayer.v_speed = 400 # was created when this was the value, breaks the falling otherwise
	setup_boss()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if !stop_processing:
		music_time += delta
		if music_time >= last_beat + seconds_per_beat + offset:
			last_beat += seconds_per_beat

		beat = music_time_to_beat(music_time)
		GLOBAL_GAME.boss_beat = beat

func _physics_process(_delta):
	debug_inputs()
	$Debug/CanvasLayer/ms.set_text(str(music_time))
	$Debug/CanvasLayer/beat.set_text(str(beat))
	$Debug/CanvasLayer/shotbeat.set_text(str(GLOBAL_GAME.shot_beat))
	if !stop_processing:
		# resync beat values every x frames
		if frames_before_resync > 0:
			frames_before_resync -= 1
		else:
			resync_rhythm_position()
			frames_before_resync = 7

		set_phase()
		
	update_boss()
	show_debug_labels()

func resync_rhythm_position():
	music_time = GLOBAL_MUSIC.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()


func on_the_beat():
	if fmod(music_time, seconds_per_beat) < 0.2:
		var mod = 1.5 - (fmod(music_time, seconds_per_beat) * 2.5)
		$Environment/til32x32.modulate = Color(mod, mod, mod)
	else:
		$Environment/til32x32.modulate = Color(1,1,1)

func debug_inputs():
	if GLOBAL_GAME.debug_mode == false:
		return
	if Input.is_action_just_pressed("button_debug_left", true):
		if music_time > 1:
			GLOBAL_MUSIC.seek(music_time-1)
		else:
			GLOBAL_MUSIC.seek(0)
	if Input.is_action_just_pressed("button_debug_right", true):
		GLOBAL_MUSIC.seek(music_time+1)
	
	if Input.is_action_just_pressed("button_debug_shift_left"):
		# if phase 0 or phase 1, go back to start
		if music_time < beat_to_music_time(phases[2][0]):
			GLOBAL_MUSIC.seek(0)
		else:
			for i in range(2,phases.size()):
				if beat_to_music_time(phases[i-1][0]) < music_time && music_time < beat_to_music_time(phases[i][0]):
					GLOBAL_MUSIC.seek(beat_to_music_time(phases[i-2][0]))
					break
	
	if Input.is_action_just_pressed("button_debug_shift_right"):
		for i in range(0,phases.size()-2):
			if beat_to_music_time(phases[i][0]) < music_time && music_time < beat_to_music_time(phases[i+1][0]):
				GLOBAL_MUSIC.seek(beat_to_music_time(phases[i+1][0]))
				break
	
	if Input.is_action_pressed("button_debug_up"):
		$Room_related/objPlayer.h_speed += 0.1
	if Input.is_action_pressed("button_debug_down"):
		$Room_related/objPlayer.h_speed -= 0.1
	
	if Input.is_action_just_pressed("button_debug_prog"):
		%objPlayer.h_speed = speed_on_debug
		var phase_filter = phases.filter(func(p): return p[1] == phase_to_seek);
		var phase_index = phases.find(phase_filter[0])
		GLOBAL_MUSIC.seek(beat_to_music_time(phases[phase_index][0]))
	
func beat_to_music_time(b):
	var mt = ((b-beat_offset)*seconds_per_beat) - offset
	return mt
func music_time_to_beat(mt):
	var b = (mt + offset)/seconds_per_beat + beat_offset
	return b

func setup_boss():
	%bossHp.max_value = boss_hp
	%bossHp.value = boss_hp
func update_boss():
	%bossHp.value = boss_hp
	%bossHpLabel.set_text("Hp: " + str(snappedf(boss_hp, 0.1)))
func take_damage(attack_type, damage):
	if attack_type == GlobalClass.weapon_type.BULLET:
		boss_hp -= damage
	elif attack_type == GlobalClass.weapon_type.NOTE:
		boss_hp -= 2*damage
	
	if boss_hp <= 0:
		defeat_boss()

func defeat_boss():
	for node in [
		$"Phases/Beep-boop-1",
		$Phases/Chorus1,
		$Phases/PostChorus1,
		$Phases/Chorus2,
		$Phases/Chorus2_part2,
		$Phases/PostChorus2,
		$Phases/Final,
		$Phases/End,
	]:
		if node.visible == true:
			node.phase_defeated()

	set_stop_processing()
	pass

func set_stop_processing():
	stop_processing = true
	GLOBAL_MUSIC.stop()

func show_debug_labels():
	if GLOBAL_GAME.debug_mode:
		$Debug/CanvasLayer/ms.set_visible(true)
		$Debug/CanvasLayer/beat.set_visible(true)
		$Debug/CanvasLayer/shotbeat.set_visible(true)
	else:
		$Debug/CanvasLayer/ms.set_visible(false)
		$Debug/CanvasLayer/beat.set_visible(false)
		$Debug/CanvasLayer/shotbeat.set_visible(false)
