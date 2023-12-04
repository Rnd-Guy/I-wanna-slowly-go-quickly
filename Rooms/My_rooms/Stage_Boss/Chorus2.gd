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
	%objPlayer.enable_shmup_mark_1()

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()
	$"../../Room_related/objCameraFixedNoSmoothing".reset_smoothing()
	first_frames = 0
	%objPlayer.vertical_shots = false
	%objPlayer.disable_shmup_mark_1()

func _physics_process(_delta):
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3
	
	if one(285):
		spawn_turret(288, 289)
	elif one(285.5):
		spawn_turret(288.5, 289.5)
	elif one(286):
		spawn_turret(289, 290)
	elif one(286.5):
		spawn_turret(289.5, 290.5)
	elif one(287):
		spawn_turret(290, 291)

	elif one(289):
		spawn_turret(292, 293)
	elif one(289.5):
		spawn_turret(292.5, 293.5)
	elif one(290):
		spawn_turret(293, 294)
	elif one(290.5):
		spawn_turret(293.5, 294.5)
	elif one(291):
		spawn_turret(294, 295)

	elif one(293):
		spawn_turret(296, 297)
		spawn_turret(296, 297)
	elif one(293.5):
		spawn_turret(296.5, 297.5)
		spawn_turret(296.5, 297.5)
	elif one(294):
		spawn_turret(297, 298)
		spawn_turret(297, 298)
	elif one(294.5):
		spawn_turret(297.5, 298.5)
		spawn_turret(297.5, 298.5)
#	elif one(301):
#		$Instances/LaserRight.set_visible(true)
#		$Instances/LaserLeft.set_visible(true)
#		point_lasers_with_angle(10)
	
	if t(285,301):
		handle_bullets(5)
	elif t(301,313):
		handle_bullets(3)
	
	
	if t(299,301):
		$Instances/LaserRight.set_visible(true)
		$Instances/LaserLeft.set_visible(true)
		point_lasers_with_angle(15)
	elif one(301):
		$Instances/LaserLeft.play("fire")
		$Instances/LaserRight.play("fire")
	elif t(301,305):
		handle_rotate_right()
	elif t(305,309):
		handle_rotate_left()
	elif t(309,311):
		handle_rotate_right(2)
	elif t(311,313):
		handle_rotate_left(2)
	elif t(313,314):
		handle_rotate_right(3)
	elif t(314,315):
		handle_rotate_left(3)
	elif t(315,316):
		handle_rotate_right(3)
	elif one(316):
		$Instances/LaserLeft.play("fade_partial")
		$Instances/LaserRight.play("fade_partial")
	elif t(316,317):
		handle_rotate_to_origin()
func setup_deferred():
	if !player_in_start:
		%objPlayer.set_global_position($Start.global_position)
	

var next_rotate = 301
func handle_rotate_right(speed=1):
	while next_rotate < b():
		$Instances/LaserLeft.rotation -= deg_to_rad(0.05)
		$Instances/LaserRight.rotation -= deg_to_rad(0.05)
		next_rotate += 0.01/speed

func handle_rotate_left(speed=1):
	while next_rotate < b():
		$Instances/LaserLeft.rotation += deg_to_rad(0.05)
		$Instances/LaserRight.rotation += deg_to_rad(0.05)
		next_rotate += 0.01/speed

var initial_left = 0
var initial_right = 0
func handle_rotate_to_origin():
	if initial_left == 0:
		initial_left = rad_to_deg($Instances/LaserLeft.rotation)
		initial_right = rad_to_deg($Instances/LaserRight.rotation)
		print(initial_left)
		print(initial_right)
	if initial_left < -180:
		initial_left += 360
	if initial_left > 180:
		initial_left -= 360
	if initial_right > 180:
		initial_right -= 360
	if initial_right < -180:
		initial_right += 360
	lerp_rotation($Instances/LaserLeft, 316, 317, initial_left, 90)
	lerp_rotation($Instances/LaserRight, 316, 317, initial_right, -90)

var next_bullet = 285
func handle_bullets(count):
	if b() > next_bullet:
		next_bullet += 0.5
		var angle = randf_range(-80, 80)
		for i in range(count):
			var bul = bullet.instantiate()
			# setup(mode="circle", velocity=Vector2(0,0), direction=0, curve=0, m_scale=0.5):
			bul.setup("arrow", Vector2(0, 150), angle-4 + (((count-1)/2)*i))
			$Instances.add_child(bul)

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

func spawn_turret(start_beat, end_beat):
	$Boss3a.spawn_turret(Vector2(rx(), ry()), start_beat, end_beat)
	$Boss3a.spawn_turret(Vector2(rx(), ry()), start_beat, end_beat)

func rx():
	return 0 + randf_range(-300,300)

func ry():
	return 0 + randf_range(100,400)

func point_lasers_with_angle(angle):
		$Instances/LaserRight.look_at(%objPlayer.position)
		$Instances/LaserLeft.look_at(%objPlayer.position)
		# looking at position makes these point left as these originally point down instead of right, so need to subtract
		$Instances/LaserRight.rotation -= deg_to_rad(90 + angle)
		$Instances/LaserLeft.rotation -= deg_to_rad(90 - angle)
