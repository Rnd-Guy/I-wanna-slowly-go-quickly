extends BossPhase

var first_frames = 0
var player_in_start = false
var bullet = preload("res://Objects/My_Stuff/Boss/objBossBullet.tscn")

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
	if !$Boss3b:
		return
	
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3
	
	if one(319):
		$RightWarning.set_visible(true)
	elif one(321.2):
		$RightWarning.set_visible(false)
		$Instances/LaserRight.play("fire")
	elif one(322.5):
		$Instances/LaserRight.play("fade_partial", 2)
	elif one(323):
		$LeftWarning.set_visible(true)
	elif one(325.2):
		$LeftWarning.set_visible(false)
		$Instances/LaserLeft.play("fire")
		$RightWarning.set_visible(true)
	elif one(326.5):
		$Instances/LaserLeft.play("fade_partial", 2)
	elif one(327.2):
		$RightWarning.set_visible(false)
		$Instances/LaserRight.play("fire")
		$LeftWarning.set_visible(true)
	elif one(328.5):
		$Instances/LaserRight.play("fade_partial", 2)
	elif one(329.2):
		$LeftWarning.set_visible(false)
		$Instances/LaserLeft.play("fire")
	elif one(330.5):
		$Instances/LaserLeft.play("fade_partial", 2)
	elif one(333):
		$Instances/LaserLeft.play("fire")
		$Instances/LaserRight.play("fire")
	elif one(345):
		$Instances/LaserLeft.play("fade_partial", 10)
		$Instances/LaserRight.play("fade_partial", 10)
		
	if t(321, 323):
		lerp_rotation($Instances/LaserRight, 321, 323, -90, 0)
	elif t(325,327):
		lerp_rotation($Instances/LaserLeft, 325, 327, 90, 0)
	elif t(327, 329):
		lerp_rotation($Instances/LaserRight, 327, 329, 0, -90)
	elif t(329, 331):
		lerp_rotation($Instances/LaserLeft, 329, 331, 0, 90)
	elif t(333, 345):
		lerp_rotation($Instances/LaserLeft, 333, 345, 90, 450)
		lerp_rotation($Instances/LaserRight, 333, 345, -90,270)
		handle_laser_on_off()
	elif t(345, 349):
		lerp_rotation($Instances/LaserLeft, 345, 349, 90, 810)
		lerp_rotation($Instances/LaserRight, 345, 349, -90,630)
	
	if t(317,341):
		handle_bullets()

var last_laser = 0
func handle_laser_on_off():
	var floor_time = floori(b())
	if floor_time == last_laser:
		return
	if floor_time % 2 == 1:
		$Instances/LaserRight.play("fire", 4)
		$Instances/LaserLeft.play("fade_partial", 4)
		last_laser = floor_time
	else:
		$Instances/LaserRight.play("fade_partial", 4)
		$Instances/LaserLeft.play("fire", 4)
		last_laser = floor_time

var next_bullet = 317
func handle_bullets():
	if b() > next_bullet:
		next_bullet += 0.1
		var bul = bullet.instantiate()
		# setup(mode="circle", velocity=Vector2(0,0), direction=0, curve=0, m_scale=0.5):
		bul.setup("circle", Vector2(0, 100), randf_range(-80, 80))
		bul.position = $Boss3b.position
		bul.set_colour()
		$Instances.add_child(bul)

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

func phase_defeated():
	%warp.position = $Boss3b.position
	$Boss3b.queue_free()
	$Instances.queue_free()
