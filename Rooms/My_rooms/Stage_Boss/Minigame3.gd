extends BossPhase

var first_frames = 0
var player_in_start = false
@onready var start_y = $Start.global_position.y

### from rhythm
var bpm: float = 120
var seconds_per_beat: float = 60 / bpm # seconds per beat - 98bpm
var speed = 400
const block2 = preload("res://Objects/My_Stuff/Rhythm/objRhythmBlock2.tscn")
const slider = preload("res://Objects/My_Stuff/Rhythm/objRhythmSlider.tscn")
var blockSize = 1.1
var sliderSize = 1
var slider_skew = 0.6
var beat_offset
enum {UP, DOWN}

# first beat is 185
var notes = [
	#[185, 100],
	[186, 500, 186.25],
	[186.5, 300, 186.75],
	[187, 400],
	[187.25, 430],
	[187.5, 460],
	[187.75, 230],
	
	[188.25, 400],
	[188.5, 430],
	[188.75, 460],
	[189, 350,189.25], # slider
	[189.5, 500, 189.75], # slider
	[190, 300],
	[190.25, 260],
	[190.5, 220],
	[190.75, 180],
	[191, 380, 191.25], #slider
	[191.5, 280],
	[191.75, 420],
	
	[192.25, 300],
	[192.5, 250],
	
	[193, 400],
	[193.25, 450],
	
	[193.75, 150],
	[194, 100],
	
	[194.5, 300],
	[194.75, 320],
	[195, 340],
	[195.25, 360],
	[195.5, 380],
	[195.75, 200],
	
	[196.25, 420],
	[196.5, 460],
	[196.75, 500],
	[197, 300],
	[197.25, 280],
	
	[197.75, 480],
	[198, 500],
	
	[198.5, 380],
	[198.75, 280],
	[199, 180],
	[199.5, 380],
	[200, 300, 200.4], #slider
	[200.5, 500, 200.9], #slider
	[201, 200, 201.8], #slider
	
	# second half
	
	[202,600, 202.25], #slider
	[202.5,400, 202.75], #slider
	[203,600],
	[203.25,540],
	[203.5,600],
	[203.75,540], #slider?
	
	[204.25,370],
	[204.5,430],
	[204.75,370],
	[205,440, 205.25], # slider
	[205.5,360, 205.75], # slider
	[206,430],
	[206.25,370],
	[206.5,430],
	[206.75,370],
	[207,440, 207.25], # slider
	[207.5,370],
	[207.75,500],
	
	[208.25,400],
	[208.5,500],
	
	[209,300],
	[209.25,600],
	
	[209.75,200],
	[210,700],
	
	[210.5,100],
	[210.75,160],
	[211,100],
	[211.25,160],
	[211.5,100],
	[211.75,260],
	
	[212.25,140],
	[212.5,200],
	[212.75,140],
	[213,200],
	[213.25,130, 213.5], # slider?
	[213.75,300],
	[214,230, 214.25], #slider
	[214.5,500],
	[214.75,440],
	[215,520,215.25],
	[215.5,420,215.75],
	[216,620, 216.5], # sliders?
	
	
]

var debug_slider_starts_right_consistent = [
	[188,100,190],
	[191,-100],
	[192,100,196],
	[197,-100],
	[198,100,210]
]

var debug_slider_starts_left_consistent = [
	[186,700],
	[188,500,190],
	[191,700],
	[192,500,196],
	[197,700],
	[198,500,210]
]

var notes_versus_sliders = [
	[190, 100],
	[190, 400, 192],
	
	[194, 700],
	[194, 400,196]
]

var slider_length = [
	[185, 0],
	[186, 100, 188],
	[188, 0],
	[189, 100, 190.75],
	[190.75,0],
	[192, 100, 193.5],
	[193.5,0],
	[195, 100, 196.25],
	[196.25,0],
	[198, 100, 199],
	[199, 0],
	[200, 100, 200.75],
	[200.75, 0],
	[202, 100, 202.5],
	[202.5, 0],
	[204, 100, 204.25]
	
]

func setup():
	super()
	$objCameraFixedNoSmoothing.make_current()
	$objCameraFixedNoSmoothing.reset_smoothing()
	%objPlayer.d_jump = false
	%objPlayer.vertical_shots = true
	%objPlayer.no_fall = true
	%objPlayer.slide = false
	beat_offset = get_beat_offset()
	prepare_notes()

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()
	$"../../Room_related/objCameraFixedNoSmoothing".reset_smoothing()
	first_frames = 0
	%objPlayer.no_fall = false
	%objPlayer.slide = true
	for c in $Notes.get_children():
		c.queue_free()

func prepare_notes():
	var prev_x = -1600
	for note in notes:
	#for note in debug_slider_starts_right_consistent:
	#for note in debug_slider_starts_left_consistent:
	#for note in notes_versus_sliders:
	#for note in slider_length:
	#for i in range(190,240):
	#	var note = [i,100]
		if note.size() == 2:
			var n = [note[0], DOWN, note[1]-1600]
			create_note2(n, prev_x)
			prev_x = note[1]-1600
		elif note.size() == 3:
			var sl = [note[0], note[1]-1600, note[2]]
			prev_x = create_slider(sl, prev_x)

func create_note2(note, prev_x):
	var note_block = block2.instantiate()
	note_block.speed = speed
	note_block.bpm = bpm
	note_block.beat = note[0]-beat_offset
	note_block.direction = "up"
	note_block.x = note[2]
	note_block.size = blockSize
	note_block.time_offset = -get_boss().offset
	if note_block.x > prev_x:
		note_block.flip = true
	note_block.collided.connect(score_points)
	$Notes.add_child(note_block)

func create_slider(note, prev_x):
	# this is to make the prev_x based off the end of the slider rather than the start
	var end_offset = (note[2]-note[0]) * speed * seconds_per_beat * slider_skew
	
	var note_block = slider.instantiate()
	note_block.speed = speed
	note_block.bpm = bpm
	note_block.beat = note[0]-beat_offset
	note_block.direction = "up"
	note_block.x = note[1] # using raw data instead
	note_block.end_beat = note[2]-beat_offset
	note_block.slider_skew = slider_skew
	note_block.size = sliderSize
	note_block.time_offset = -get_boss().offset
	if note_block.x > prev_x:
		note_block.flip = true
		end_offset *= -1
	note_block.collided.connect(score_points)
	$Notes.add_child(note_block)
	
	return note[1] - end_offset

func score_points(event):
	if event == "note":
		%objPlayer.h_speed += 0.03
	elif event == "sliderTop" || event == "sliderBottom":
		%objPlayer.h_speed += 0.015
	elif event == "sliderBody":
		%objPlayer.h_speed += 0.005

func _physics_process(_delta):
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3
	%objPlayer.set_global_position(Vector2(%objPlayer.global_position.x,$Start.global_position.y))


func setup_deferred():
	if !player_in_start:
		%objPlayer.set_global_position($Start.global_position)
	
func get_start_y():
	return start_y

func _on_start_region_body_entered(_body):
	player_in_start = true
	pass # Replace with function body.


func _on_start_region_body_exited(_body):
	player_in_start = false
	pass # Replace with function body.

func get_beat_offset():
	return get_tree().root.get_node("rBoss").beat_offset
func get_boss():
	return get_tree().root.get_node("rBoss")
