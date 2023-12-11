extends BossPhase

var first_frames = 0
var player_in_start = false

# 149 to 181

func setup():
	super()
	$objCameraDynamic.make_current()
	$objCameraDynamic.reset_smoothing()
	%objPlayer.d_jump = false
	%objPlayer.vertical_shots = true

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()
	$"../../Room_related/objCameraFixedNoSmoothing".reset_smoothing()
	first_frames = 0
	%objPlayer.vertical_shots = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(_delta):
	if !$Boss2Falling:
		return
	
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3
	
	if t(149,151):
		var weight = w(149,151,GLOBAL_GAME.boss_beat)
		$Boss2Falling.global_position = Vector2(1976,lerp(400,600,weight))
	elif t(151,177):
		var weight = w(151,177,GLOBAL_GAME.boss_beat)
		$Boss2Falling.global_position = Vector2(1976,lerp(600,5800,weight))
	elif t(177,181):
		var weight = w(177,181,GLOBAL_GAME.boss_beat)
		$Boss2Falling.global_position = Vector2(1976,lerp(5800,6400,weight))


func setup_deferred():
	if !player_in_start:
		%objPlayer.set_global_position($Start.global_position)
	


func _on_start_region_body_entered(_body):
	player_in_start = true


func _on_start_region_body_exited(_body):
	player_in_start = false


func _on_falling_spike_body_entered(_body):
	%objPlayer.h_speed -= 0.5
	pass # Replace with function body.

func get_camera_pos():
	return $objCameraDynamic.global_position

func phase_defeated():
	$Boss2Falling.queue_free()
	%warp.position = %objPlayer.position
