extends Node2D

@onready var player = GLOBAL_INSTANCES.objPlayerID

var in_green = 0
var in_red = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	disable($InitialGreenBeam)
	disable($InitialRedBeam)

func _physics_process(delta):
	reset()
	if t(1, 5):
		enable($InitialGreenBeam)
		var weight = w(1,5,b())
		var angle = lerp(0, -70, weight)
		$InitialGreenBeam.set_rotation(d(angle))
	elif t(5,9):
		enable($InitialRedBeam)
		var weight = w(5,9,b())
		var angle = lerp(-90, -20, weight)
		$InitialRedBeam.set_rotation(d(angle))
	elif t(9,100):
		#disable($InitialRedBeam)
		pass
	pass
	
	for i in range(0,in_green):
		GLOBAL_INSTANCES.objPlayerID.h_speed += delta * 0.3
	for i in range(0,in_red):
		GLOBAL_INSTANCES.objPlayerID.h_speed -= delta * 0.3


# shortcut
func b():
	return GLOBAL_GAME.boss_beat

# use for the timeline
func t(mint, maxt):
	return GLOBAL_GAME.boss_beat >= mint && GLOBAL_GAME.boss_beat < maxt

# get weight where t is between min and max, for use in a lerp
func w(mint,maxt,time):
	return (time-mint)/(maxt-mint)

# radians is pain
func d(degrees):
	return deg_to_rad(degrees)


func disable(node):
	if node.visible:
		node.set_process_mode(PROCESS_MODE_DISABLED)
		node.set_visible(false)
func enable(node):
	if !node.visible:
		node.set_process_mode(PROCESS_MODE_PAUSABLE)
		node.set_process(true)
		node.set_visible(true)




func _on_initial_green_beam_body_entered(_body):
	#print(body)
	in_green += 1
	pass # Replace with function body.


func _on_initial_green_beam_body_exited(_body):
	print(_body)
	in_green -= 1
	pass # Replace with function body.




func _on_initial_red_beam_body_entered(_body):
	in_red += 1
	pass # Replace with function body.


func _on_initial_red_beam_body_exited(_body):
	in_red -= 1
	pass # Replace with function body.
