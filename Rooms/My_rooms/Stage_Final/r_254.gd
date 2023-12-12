extends Node2D

@onready var a1 = $a1
@onready var a2 = $a2
@onready var m1 = $m1
@onready var m2 = $m2
@onready var positions = [a1.position,a2.position,m1.position,m2.position]
@onready var blocks = [a1,a2,m1,m2]

# Called when the node enters the scene tree for the first time.
func _ready():
	while !scramble():
		pass # just need to rerun scramble until it returns true
	
func scramble():
	
	var sub = snappedf(randf_range(1,2), 1)
	var add = snappedf(randf_range(1,2), 1)
	var mult = snappedf(randf_range(4,4), 1)
	
	# limit divide values
	var divide = [0.5]
	divide.shuffle()
	divide = divide[0]
	
	a1.speed = add
	a2.speed = -sub
	m1.multiplier = mult
	m2.multiplier = divide
	
	# avoid making it too easy
	if add == sub:
		return false
	if mult == 1/divide:
		return false
	
	blocks.shuffle()
	for i in range(positions.size()):
		blocks[i].position = positions[i]
		blocks[i]._ready()
	
	var order = ["add", "sub", "mult", "divide"]
	order.shuffle()
	
	var answer = 2.54
	var debug_strings = []
	var debug_instructions = []
	for i in range(2):
		var o = order[i]
		match o:
			"add":
				answer -= add
			"sub":
				answer += sub
			"mult":
				answer /= mult
			"divide":
				answer /= divide
		if answer < 1:
			return false
		
		debug_strings.push_back(o + ": " + str(answer))
		debug_instructions.push_back(o)
	
	if answer < 1:
		return false
	
	#for d in debug_strings:
	#	print(d)
	
#	debug_instructions.reverse()
#	var reverse = ""
#	for d in debug_instructions:
#		if reverse != "":
#			reverse += ", "
#		reverse += d
#	print(reverse)
	
	%objPlayer.h_speed = answer
	return true
