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

func _physics_process(delta):
	if one(397):
		$LeftLaser.rotation = deg_to_rad(-3)
		$RightLaser.rotation = deg_to_rad(3)
		$LeftLaser.play("fire")
		$RightLaser.play("fire")
	elif one(398):
		$"/root/rBoss".stop_processing = true
		GLOBAL_MUSIC.stop()
	elif one(402):
		print(123)
		var c = $objCherry
		c.set_visible(true)
		c.position = $Boss3e.position
	
	if t(402,416):
		var weight = inverse_lerp(402, 416, b())
		var newPos = lerp($Boss3e.position.y+50, 900.0, weight)
		$objCherry.position = Vector2($Boss3e.position.x, newPos)
