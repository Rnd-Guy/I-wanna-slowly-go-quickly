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
	%objPlayer.turn_back_on_killers()

	

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()
	$"../../Room_related/objCameraFixedNoSmoothing".reset_smoothing()
	first_frames = 0
	%objPlayer.vertical_shots = false
	%objPlayer.disable_shmup_mark_2()

func _physics_process(_delta):
	if !$Boss3e:
		return
		
	if one(397):
		$Instances/LeftLaser.rotation = deg_to_rad(-3)
		$Instances/RightLaser.rotation = deg_to_rad(3)
		$Instances/LeftLaser.play("fire")
		$Instances/RightLaser.play("fire")
		var c = $Instances/objCherry
		c.set_visible(true)
		c.position = $Boss3e.position
		$"/root/rBoss".set_stop_processing()

	
	if t(397,416):
		var weight = inverse_lerp(397, 427, b())
		var newPos = lerp($Boss3e.position.y+50, 900.0, weight)
		$Instances/objCherry.position = Vector2($Boss3e.position.x, newPos)

func phase_defeated():
	%warp.position = $Boss3e.position
	$Boss3e.queue_free()
	$Instances.queue_free()
