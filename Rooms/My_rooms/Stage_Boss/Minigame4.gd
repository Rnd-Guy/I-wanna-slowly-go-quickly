extends BossPhase

var bar_damage = 2

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
@onready var currentTop = t1
@onready var currentBot = b1
var dontSpawnAdder = null

var speedAdder = preload("res://Objects/My_Stuff/Speed/objSpeedAdder.tscn")

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
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
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

func _on_start_region_body_entered(body):
	player_in_start = true

func _on_start_region_body_exited(body):
	player_in_start = false

func _on_instant_speed_body_entered(body):
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
	var spikes: TileMap = phase.find_child("spike", false)
	spikes.set_layer_enabled(0, true)
	var tiles: TileMap = phase.find_child("tiles", false)
	tiles.set_layer_enabled(0, true)
	phase.set_visible(true)

# disable obstacle
func diso(phase: Node2D):
	phase.find_child("spike", false).set_layer_enabled(0, false)
	phase.find_child("tiles", false).set_layer_enabled(0, false)
	phase.set_visible(false)
	delete_adder(phase)

func create_adder(phase):
	var pos = phase.get_node("speedBuffLocation")
	var adder = speedAdder.instantiate()
	adder.speed = 1
	adder.decay = 0.25
	adder.one_use = true
	phase.get_node("speedBuffLocation").add_child(adder)

func delete_adder(phase):
	if phase.get_node("speedBuffLocation").get_child_count() > 0:
		for child in phase.get_node("speedBuffLocation").get_children():
			child.queue_free()

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
		delete_adder(phases[index+1])
		dontSpawnAdder = phases[index+1]
		
	# change the next phase immediately so you go into the next one
	if index < phases.size()-2:
		var next_same_side_phase = phases[index+2]
		diso(current_phase)
		eo(phases[index+2])
	
	

