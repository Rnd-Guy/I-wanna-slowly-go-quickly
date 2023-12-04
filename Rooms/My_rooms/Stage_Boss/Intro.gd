extends Node2D

@onready var player = GLOBAL_INSTANCES.objPlayerID

var in_green = 0
var in_red = 0

@onready var list = [
	$InitialGreenBeam,
	$InitialRedBeam,
	$NextGreenBeam2,
	$NextGreenBeam3,
	$NextGreenBeam4,
	$NextGreenBeam5,
	$NextRedBeam2,
	$NextRedBeam3,
	$NextRedBeam4,
	$NextRedBeam5,
]


# NOTE cannot set process mode to disabled and then enabled on the same frame
# it breaks the area2d collision detection and there's no fix yet
# therefore only set it once per frame


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	$tiles.set_layer_enabled(0,false)
func setup():
	$tiles.set_layer_enabled(0, true)


func _physics_process(delta):
	#setup()
	if t(1, 5):
		sole_enable($InitialGreenBeam)
		var weight = w(1,5,b())
		var angle = lerp(0, -70, weight)
		$InitialGreenBeam.set_rotation(d(angle))
	elif t(5,9):
		sole_enable($InitialRedBeam)
		var weight = w(5,9,b())
		var angle = lerp(-90, -20, weight)
		$InitialRedBeam.set_rotation(d(angle))
	elif t(9,13):
		sole_enable([	$NextGreenBeam2,
	$NextGreenBeam3,
	$NextGreenBeam4,
	$NextGreenBeam5,
	$NextRedBeam2,
	$NextRedBeam3,
	$NextRedBeam4,
	$NextRedBeam5,])
		lerp_rotation($NextGreenBeam2, 9, 13, -90, -20)
		lerp_rotation($NextGreenBeam3, 9, 13, 0, -70)
		lerp_rotation($NextGreenBeam4, 9, 13, -70, 0)
		lerp_rotation($NextGreenBeam5, 9, 13, 10, -60)
		lerp_rotation($NextRedBeam2, 9, 13, -30, -100)
		lerp_rotation($NextRedBeam3, 9, 13, -90, -20)
		lerp_rotation($NextRedBeam4, 9, 13, 0, -70)
		lerp_rotation($NextRedBeam5, 9, 13, -60, 10)
	elif t(13,17):
		sole_enable([	$NextGreenBeam2,
	$NextGreenBeam3,
	$NextGreenBeam4,
	$NextGreenBeam5,
	$NextRedBeam2,
	$NextRedBeam3,
	$NextRedBeam4,
	$NextRedBeam5,])
		lerp_rotation($NextGreenBeam2, 9, 13, -20, 980)
		lerp_rotation($NextGreenBeam3, 9, 13, -70, -1070)
		lerp_rotation($NextGreenBeam4, 9, 13, 0, 1000)
		lerp_rotation($NextGreenBeam5, 9, 13, -60, -1060)
		lerp_rotation($NextRedBeam2, 9, 13, -100, -1100)
		lerp_rotation($NextRedBeam3, 9, 13, -20, 980)
		lerp_rotation($NextRedBeam4, 9, 13, -70, -1070)
		lerp_rotation($NextRedBeam5, 9, 13, 10, 1010)
	
	for i in range(0,in_green):
		GLOBAL_INSTANCES.objPlayerID.h_speed += delta * 0.3
	for i in range(0,in_red):
		GLOBAL_INSTANCES.objPlayerID.h_speed -= delta * 0.3
	
	#print($InitialGreenBeam.get_overlapping_bodies())

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
	node.set_process_mode(PROCESS_MODE_DISABLED)
	node.set_visible(false)
	if node is Area2D:
		node.set_disable_mode(Area2D.DISABLE_MODE_REMOVE)
func enable(node):
	node.set_process_mode(PROCESS_MODE_PAUSABLE)
	#node.set_process(true)
	node.set_visible(true)
	if node is Area2D:
		node.set_disable_mode(Area2D.DISABLE_MODE_MAKE_STATIC)

func sole_enable(nodes):
	if typeof(nodes) != TYPE_ARRAY:
		nodes = [nodes]

	for node in list:
		if node in nodes:
			enable(node)
		else:
			disable(node)

func lerp_rotation(node, start_time, end_time, start_angle, end_angle):
	var weight = w(start_time, end_time, b())
	var angle = lerp(start_angle, end_angle, weight)
	node.set_rotation(d(angle))

func _on_green_beam_body_entered(_body):
	in_green += 1
	pass # Replace with function body.


func _on_green_beam_body_exited(_body):
	in_green -= 1
	pass # Replace with function body.




func _on_red_beam_body_entered(_body):
	in_red += 1
	pass # Replace with function body.


func _on_red_beam_body_exited(_body):
	in_red -= 1
	pass # Replace with function body.
