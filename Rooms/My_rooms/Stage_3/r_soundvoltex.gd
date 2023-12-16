extends Node2D

var note = preload("res://Objects/My_Stuff/Rhythm/objColourfulNote.tscn")

var x_positions = [
	208, 280, 352, 416, 488, 560
]
var y_target = 490

var notes = [
	[1, 234]
	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	%objPlayer.h_speed = 6
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

