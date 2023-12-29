extends BossPhase

var bar_damage = 1
var bonus_point_start = 1

var first_frames = 0
var player_in_start = false

@onready var topAni = $RhythmBars/TopBar/TopBarAnimation
@onready var botAni = $RhythmBars/BottomBar/BottomBarAnimation
@onready var t1 = $Obstacles/t1
@onready var t2 = $Obstacles/t2
@onready var t3 = $Obstacles/t3
@onready var t4 = $Obstacles/t4
@onready var b1 = $Obstacles/b1
@onready var b2 = $Obstacles/b2
@onready var b3 = $Obstacles/b3
@onready var b4 = $Obstacles/b4

@onready var phases = [t1,b1,t2,b2,t3,b3,t4,b4]
@onready var top_phases = [t1,t2,t3,t4]
@onready var bot_phases = [b1,b2,b3,b4]
@onready var currentTop = t1
@onready var currentBot = b1
var dontSpawnAdder = null

var speedAdder = preload("res://Objects/My_Stuff/Speed/objSpeedAdder.tscn")
var falling_spike = preload("res://Objects/My_Stuff/Boss/falling_spike.tscn")
var mg4_block = preload("res://Objects/My_Stuff/Boss/Minigame4Block.tscn")
var mg4_ramp = preload("res://Objects/My_Stuff/Boss/objMinigame4Ramp.tscn")

var tilemap_to_spike_rotation = {
	0: 180,
	10: 0,
	1: 270,
	11: 90
}
var tilemap_to_ramp_rotation = {
	0: 0,
	10: 90,
	1: 270,
	11: 180
}

func setup():
	super()
	if %objPlayer:
		%objPlayer.d_jump = true
		%objPlayer.no_fall = false
		%objPlayer.instant_speed = false
		%objPlayer.vertical_shots = false
		$objCameraFixedNoSmoothing.make_current()
		$objCameraFixedNoSmoothing.reset_smoothing()
	diso(t1)
	diso(t2)
	diso(t3)
	diso(t4)
	diso(b1)
	diso(b2)
	diso(b3)
	diso(b4)

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()
	$"../../Room_related/objCameraFixedNoSmoothing".reset_smoothing()
	first_frames = 0
	topAni.stop()
	botAni.stop()
	diso(t1)
	diso(t2)
	diso(t3)
	diso(t4)
	diso(b1)
	diso(b2)
	diso(b3)
	diso(b4)

func _physics_process(_delta):
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3

	# animation actually starts 2 beats before (ie 1 second)
	if one(217):
		topAni.play("TopBar")
		topAni.seek(1,true)
		currentTop = t1
		eo(t1)
		eo(b1)
		ca(t1)
	elif one(219):
		botAni.play("BottomBar")
		currentBot = b1
	elif one(221):
		diso(t1)
		eo(t2)
		ca(b1)
	elif one(223):
		topAni.play("TopBar")
		currentTop = t2
	elif one(225):
		diso(b1)
		eo(b2)
		ca(t2)
	elif one(227):
		botAni.play("BottomBar")
		currentBot = b2
	elif one(229):
		diso(t2)
		eo(t3)
		ca(b2)
	elif one(231):
		topAni.play("TopBar")
		currentTop = t3
	elif one(233):
		diso(b2)
		eo(b3)
		ca(t3)
	elif one(235):
		botAni.play("BottomBar")
		currentBot = b3
	elif one(237):
		diso(t3)
		eo(t4)
		ca(b3)
	elif one(239):
		topAni.play("TopBar")
		currentTop = t4
	elif one(241):
		diso(b3)
		eo(b4)
		ca(t4)
	elif one(243):
		botAni.play("BottomBar")
		currentBot = b4
	elif one(245):
		ca(b4)

func setup_deferred():
	if !player_in_start:
		%objPlayer.set_global_position($Start.global_position)
		pass

func _on_start_region_body_entered(_body):
	player_in_start = true

func _on_start_region_body_exited(_body):
	player_in_start = false

func _on_instant_speed_body_entered(_body):
	%objPlayer.instant_speed = true
	%objPlayer.set_global_position(Vector2(%objPlayer.global_position.x,$"../Minigame3".get_start_y()))
	%objPlayer.global_translate(Vector2(-3200,0))
	%objPlayer.no_fall = true
	$"objCameraFixedNoSmoothing".make_current()
	$"objCameraFixedNoSmoothing".reset_smoothing()
	pass # Replace with function body.

func _on_top_bar_body_entered(body):
	if body is Player:
		handle_bar_collision(currentTop)


func _on_bottom_bar_body_entered(body):
	if body is Player:
		handle_bar_collision(currentBot)


# enable obstacle
func eo(phase: Node2D):
	phase.set_visible(true)
	replace_blocks(phase)
	replace_spikes(phase)
	if top_phases.has(phase):
		$objOneWay.rotation = deg_to_rad(0)
		$objOneWay2.rotation = deg_to_rad(0)
	else:
		$objOneWay.rotation = deg_to_rad(180)
		$objOneWay2.rotation = deg_to_rad(180)

# disable obstacle
func diso(phase: Node2D):
	phase.find_child("spike", false).set_layer_enabled(0, false)
	phase.find_child("tiles", false).set_layer_enabled(0, false)
	phase.set_visible(false)
	delete_adder(phase)
	for node in phase.get_node("instances").get_children():
		node.queue_free()

func create_adder(phase):
	#var pos = phase.get_node("speedBuffLocation")
	var adder = speedAdder.instantiate()
	adder.speed = bonus_point_start
	adder.decay = bonus_point_start/4.0
	adder.one_use = true
	phase.get_node("speedBuffLocation").add_child(adder)

func delete_adder(phase):
	if phase.get_node("speedBuffLocation").get_child_count() > 0:
		for child in phase.get_node("speedBuffLocation").get_children():
			child.queue_free()

# create adder
func ca(phase):
	if dontSpawnAdder != phase:
		create_adder(phase)
	else:
		dontSpawnAdder = null

func handle_bar_collision(current_phase):
	%objPlayer.h_speed -= bar_damage
	%objPlayer.global_position = current_phase.get_node("spawnLocation").global_position
	delete_adder(current_phase)
	
	var index = phases.find(current_phase)
	
	# delete next adder so you don't get instant bonus
	if index < phases.size()-1:
		var next_phase = phases[index+1]
		delete_adder(next_phase)
		dontSpawnAdder = next_phase
		
	# change the next phase immediately so you go into the next one
	if index < phases.size()-2:
		var next_same_side_phase = phases[index+2]
		diso.call_deferred(current_phase)
		eo.call_deferred(next_same_side_phase)
	
func replace_spikes(phase):
	
	var tiles = phase.get_node("spike") as TileMap
	var used_cells = tiles.get_used_cells(0)
	for i in used_cells.size():
		var atlas_coords = tiles.get_cell_atlas_coords(0, used_cells[i])
		var spike_rotation = tilemap_to_spike_rotation.get(10*atlas_coords.x + atlas_coords.y)
		var spike = falling_spike.instantiate()
		spike.position = tiles.map_to_local(used_cells[i])
		spike.set_shape_rotation(spike_rotation)
		spike.set_colour()
		phase.get_node("instances").add_child(spike)

func replace_blocks(phase):
	var tiles = phase.get_node("tiles") as TileMap
	var used_cells = tiles.get_used_cells(0)
	for i in used_cells.size():
		# 0 is blocks, 1 is ramp
		var source = tiles.get_cell_source_id(0, used_cells[i])
		var obj
		# block
		if source == 0:
			obj = mg4_block.instantiate()
		# ramp
		elif source == 1:
			obj = mg4_ramp.instantiate()
			var atlas_coords = tiles.get_cell_atlas_coords(0, used_cells[i])
			var ramp_rotation = tilemap_to_ramp_rotation.get(10*atlas_coords.x + atlas_coords.y)
			obj.set_shape_rotation(ramp_rotation)
		obj.position = tiles.map_to_local(used_cells[i])
		obj.position.x -= 1600 # for some reason all the tiles are transformed to -1600x 0y
		if top_phases.has(phase):
			obj.set_colour("73ff74")
		else:
			obj.set_colour("f18a53")
		phase.get_node("instances").add_child(obj)

func _on_falling_spike_body_entered(body):
	pass # Replace with function body.

