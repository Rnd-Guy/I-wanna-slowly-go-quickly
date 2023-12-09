extends Node2D

@onready var a1 = $a1
@onready var a2 = $a2
@onready var m1 = $m1
@onready var m2 = $m2
@onready var positions = [a1.position,a2.position,m1.position,m2.position]
@onready var blocks = [a1,a2,m1,m2]

# Called when the node enters the scene tree for the first time.
func _ready():
	blocks.shuffle()
	for i in range(positions.size()):
		blocks[i].position = positions[i]
	
	

