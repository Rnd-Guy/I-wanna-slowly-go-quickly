extends Node2D

var note = preload("res://Objects/My_Stuff/Rhythm/objColourfulNote.tscn")


var x_positions = [
	208, 280, 352, 416, 488, 560
]
var y_target = 490

var target_score = 11400 # max possible without z is 11600, max is 12400

var notes = [
	[2, 3],
	[4,1],
	
	[7,1],
	[8,2],
	[9,2],
	[9.5,2],
	[10.5,3],
	[12,3],
	
	[15,3],
	[16,4],
	[17,4],
	[17.5,4],
	[18.5,4],
	[19.5,5],
	[20.5,3],
	[21,3],
	
	[23,3],
	[24,3],
	[26,5],
	[28,4],
	[29,5],
	[30,4],
	[31,3],
	[32,4],
	
	[34,6],
	[36,1],
	
	[39,3],
	[40,4],
	[41,4],
	[41.5,4],
	[42.5,5],
	[44,5],
	
	[47,2],
	[48,4],
	[49,4],
	[49.5,4],
	[50.5,4],
	[51.5,5],
	[52.5,3],
	
	[55,3],
	[56,3],
	[58,6],
	[60,3],
	[61,4],
	[62,3],
	[63,2],
	[64,3],
	
	[66,6],
	[68,1],
	
	[71,1],
	[72,6],
	[73,6],
	[73.5,6],
	[74.5,1],
	[76,6],
	
	[79,4],
	[80,5],
	[81,5],
	[81.5,5],
	[82.5,5],
	[83.5,6],
	[84.5,2],
	[85,2],
	
	[87,2],
	[88,2],
	[90,6],
	[92,2],
	[93,3],
	[94,2],
	[95,1],
	[96,2],
	
	[98,5],
	[100,2],
	
	[103,2],
	[104,4],
	[105,3],
	[105.5,3],
	[106.5,2],
	[108,4],
	
	[111,1],
	[112,3],
	[113,3],
	[113.5,3],
	[114.5,3],
	[115.5,4],
	[116.5,2],
	
	[119,2],
	[120,2],
	[122,5],
	[124,4],
	[125,5],
	[126,4],
	[127,3],
	[128,4],
	
	[130,6],
	[132,1],
	# beginning of aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
	[138,2],
	[140,3],
	
	[146,5],
	[148,6],
	[149,5],
	[149.5,4],
	[150,3],
	
	[154,1],
	[155,2],
	[156,2],
	
	[162,5],
	[164,6],
	[166,1],
	[168,6],
	[170,4],
	[171,3],
	[172,4],
	[173,3],
	[175,2],
	[176,1],
	
	[179,1],
	[180,2],
	[181,3],
	
	[183,5],
	[184,6],
	[185,5],
	[186,3],
	[188,4],
	
	
	
	
]

var bpm = 240
var speed = 300
var song_finished = false
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	%objPlayer.h_speed = 9
	$objRhythmPreviewer.play_sample()
	GLOBAL_MUSIC.finished.connect(on_music_end)
	$Room_related/objPlayer.show_speed = false
	
	for n in notes:
	#for note in debug_slider_starts_right_consistent:
	#for note in debug_slider_starts_left_consistent:
		create_note(n)

func on_music_end():
	$Room_related/objPlayer.v_speed = 400
	$Room_related/objPlayer.h_speed = 3
	$Room_related/objPlayer.slide = true
	song_finished = true
	$Instances.queue_free()
	$Environment/tempTiles.queue_free()


func _physics_process(_delta):
	$Label.set_text("Score: " + str(score))

func create_note(note_data):
	var note_block = note.instantiate()
	note_block.speed = speed
	note_block.bpm = bpm
	note_block.beat = note_data[0]
	note_block.x = x_positions[note_data[1]-1]
	note_block.collided.connect(score_points)
	$Instances.add_child(note_block)
	
func score_points():
	#if event == "note":
		#score += 100
	#elif event == "sliderTop" || event == "sliderBottom":
		#score += 50
	#elif event == "sliderBody":
		#score += 1
	score += 100
	if $miku && score >= target_score:
		$miku.queue_free()
	
	#if $scoreReq && score > 5000: 
#		$scoreReq.queue_free()


func _on_miku_body_entered(body):
	$Room_related/objPlayer.on_death()
