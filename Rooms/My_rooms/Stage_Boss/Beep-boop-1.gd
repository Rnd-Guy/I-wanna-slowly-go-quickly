extends Node2D

@onready var player = GLOBAL_INSTANCES.objPlayerID

var in_green = 0
var in_red = 0
@onready var list = [

]

@onready var green_floor_panels = [
	$Floor/Green/GFP,
	$Floor/Green/GFP2,
	$Floor/Green/GFP3,
	$Floor/Green/GFP4,
	$Floor/Green/GFP5,
	$Floor/Green/GFP6,
	$Floor/Green/GFP7,
	$Floor/Green/GFP8,
	$Floor/Green/GFP9,
	$Floor/Green/GFP10,
	$Floor/Green/GFP11,
	$Floor/Green/GFP12,
	$Floor/Green/GFP13,
]
@onready var red_floor_panels = [
	$Floor/Red/RFP,
	$Floor/Red/RFP2,
	$Floor/Red/RFP3,
	$Floor/Red/RFP4,
	$Floor/Red/RFP5,
	$Floor/Red/RFP6,
	$Floor/Red/RFP7,
	$Floor/Red/RFP8,
	$Floor/Red/RFP9,
	$Floor/Red/RFP10,
	$Floor/Red/RFP11,
	$Floor/Red/RFP12,
	$Floor/Red/RFP13,
]

# NOTE cannot set process mode to disabled and then enabled on the same frame
# it breaks the area2d collision detection and there's no fix yet
# therefore only set it once per frame

func reset():
	$tiles.set_layer_enabled(0,false)
func setup():
	$tiles.set_layer_enabled(0, true)
	$Boss1/StateMachine.initial_state = $Boss1/StateMachine/InitialIdle
	$Boss1/StateMachine.start()
	$bg.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if t(1, 5):
		pass
	
	handle_floor()
		
	for i in range(0,in_green):
		GLOBAL_INSTANCES.objPlayerID.h_speed += delta * 0.1
	for i in range(0,in_red):
		GLOBAL_INSTANCES.objPlayerID.h_speed -= delta * 0.1

func handle_floor():
	for i in range(0, green_floor_panels.size()):
		# right side will alternate over time
		if i % 2 == floori(b()) % 2:
			disable(green_floor_panels[i])
			enable(red_floor_panels[i])
		else:
			enable(green_floor_panels[i])
			disable(red_floor_panels[i])
			

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
	#if node is Area2D:
	#	node.set_disable_mode(Area2D.DISABLE_MODE_REMOVE)
func enable(node):
	node.set_process_mode(PROCESS_MODE_PAUSABLE)
	node.set_visible(true)
	#if node is Area2D:
	#	node.set_disable_mode(Area2D.DISABLE_MODE_MAKE_STATIC)

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


func _on_gfp_body_entered(_body):
	in_green += 1
	pass # Replace with function body.


func _on_gfp_body_exited(_body):
	in_green -= 1
	pass # Replace with function body.


func _on_rfp_body_entered(_body):
	in_red += 1
	pass # Replace with function body.


func _on_rfp_body_exited(_body):
	in_red -= 1
	pass # Replace with function body.

func phase_defeated():
	%warp.position = $Boss1.position
	$Boss1.queue_free()
