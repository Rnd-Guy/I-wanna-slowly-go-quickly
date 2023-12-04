extends BossPhase

var first_frames = 0
var player_in_start = false

func setup():
	super()
	$fixedCamera.make_current()
	$fixedCamera.reset_smoothing()
	%objPlayer.d_jump = false
	%objPlayer.vertical_shots = true
	%objPlayer.enable_shmup_mark_2()

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()
	$"../../Room_related/objCameraFixedNoSmoothing".reset_smoothing()
	first_frames = 0
	%objPlayer.vertical_shots = false
	%objPlayer.disable_shmup_mark_2()

func _physics_process(_delta):
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3
	
	handle_lasers()
	if one(381):
		$LeftLaser.position = $Boss3d.position
		$RightLaser.position = $Boss3d.position
		$LeftLaser.play("fire")
		$RightLaser.play("fire")

func handle_lasers():
	lerp_rotation($LeftLaser, 381, 397, -180, -3)
	lerp_rotation($RightLaser, 381, 397, 180, 3)
	pass

func setup_deferred():
	if !player_in_start:
		%objPlayer.set_global_position($Start.global_position)
	


func _on_start_region_body_entered(_body):
	player_in_start = true
	pass # Replace with function body.


func _on_start_region_body_exited(_body):
	player_in_start = false
	pass # Replace with function body.


func _on_instant_speed_body_entered(_body):
	%objPlayer.instant_speed = true
	%objPlayer.set_global_position(Vector2(%objPlayer.global_position.x,$"../Minigame3".get_start_y()))
	%objPlayer.global_translate(Vector2(-3200,0))
	%objPlayer.no_fall = true
	$"objCameraFixedNoSmoothing".make_current()
	$"objCameraFixedNoSmoothing".reset_smoothing()
	pass # Replace with function body.
