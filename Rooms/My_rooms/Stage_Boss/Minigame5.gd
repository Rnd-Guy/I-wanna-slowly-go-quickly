extends BossPhase

var first_frames = 0
var player_in_start = false

var note = preload("res://Objects/My_Stuff/Rhythm/objColourfulNote.tscn")
var bpm = 120
var speed = 400
var beat_offset
var speed_per_hit = 0.1

var x_positions = [208, 280, 352, 416, 488, 560]
var y_target = 490

var notes = [
	#[249,4],
	[249.5,4],
	[250,4],
	[250.5,4],
	[251,4],
	[251.5,5],
	[251.75,6],
	
	[252.25,1],
	[252.5,2],
	[252.75,3],
	[253,4],
	[253.5,1],
	[254,3],
	[254.5,1],
	[255,6],
	[255.5,5],
	[256,3],
	[256.5,1],
	[257,2],
	
	[258,4],
	[258.5,5],
	[259,6],
	[259.5,1],
	[260,6],
	[260.5,1],
	[261,6],
	[261.5,6],
	[262,4],
	[262.5,5],
	[263,3],
	[263.5,4],
	
	[264.5,2],
	[264.75,3],
	[265,4],
	[265.5,2],
	[266,3],
	[266.5,2],
	[267,6],
	[267.5,1],
	[267.75,2],
	
	[268.25,6],
	[268.5,5],
	[268.75,4],
	[269,3],
	[269.5,6],
	[270,4],
	[270.5,6],
	[271,1],
	[271.5,2],
	[272,3],
	[272.5,6],
	[273,4],
	
	[274,2],
	[274.5,3],
	[275,4],
	[275.5,1],
	[276,3],
	[276.5,1],
	[277,6],
	[277.5,6],
	[278,4],
	[278.5,5],
	[279,4],
	[279.5,1],
	[280, 3]
]

func setup():
	super()
	beat_offset = get_beat_offset()
	%objPlayer.instant_speed_ammo = -1
	$tempTiles.set_layer_enabled(0, true)
	prepare_notes()

func reset():
	super()
	first_frames = 0
	$tempTiles.set_layer_enabled(0, false)
	%objPlayer.instant_speed_ammo = 0
	for c in $Instances.get_children():
		c.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prepare_notes():
	for n in notes:
		create_note(n)

func create_note(note_data):
	var note_block = note.instantiate()
	note_block.speed = speed
	note_block.bpm = bpm
	note_block.beat = note_data[0]-beat_offset # offset as song doesn't start at 0
	note_block.x = x_positions[note_data[1]-1]
	note_block.collided.connect(score_points)
	$Instances.add_child(note_block)
	

func _physics_process(_delta):
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3
	#%objPlayer.set_global_position(Vector2(%objPlayer.global_position.x,$Start.global_position.y))

func score_points():
	%objPlayer.h_speed += speed_per_hit

func get_beat_offset():
	return get_tree().root.get_node("rBoss").beat_offset
func get_boss():
	return get_tree().root.get_node("rBoss")

func setup_deferred():
	if !player_in_start:
		%objPlayer.set_global_position($Start.global_position)
