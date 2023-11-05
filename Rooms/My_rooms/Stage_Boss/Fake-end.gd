extends Node2D

# mostly to hold utility functions, will still need to do most things manually
class_name BossPhase

@onready var player = GLOBAL_INSTANCES.objPlayerID

var in_green = 0
var in_red = 0
@onready var list = [

]

# NOTE cannot set process mode to disabled and then enabled on the same frame
# it breaks the area2d collision detection and there's no fix yet
# therefore only set it once per frame

func _physics_process(delta):
	#if t(1, 5):
	#	pass
		
#	for i in range(0,in_green):
#		GLOBAL_INSTANCES.objPlayerID.h_speed += delta * 0.1
#	for i in range(0,in_red):
#		GLOBAL_INSTANCES.objPlayerID.h_speed -= delta * 0.1
	pass

# shortcuts
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

func phase(mint, maxt):
	pass

func disable(node):
	node.set_process_mode(PROCESS_MODE_DISABLED)
	node.set_visible(false)
func enable(node):
	node.set_process_mode(PROCESS_MODE_PAUSABLE)
	node.set_visible(true)

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

func reset():
	if get_node_or_null("tiles"):
		$tiles.set_layer_enabled(0,false)
func setup():
	if get_node_or_null("tiles"):
		$tiles.set_layer_enabled(0, true)
		pass
