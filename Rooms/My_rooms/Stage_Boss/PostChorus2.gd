extends BossPhase

var first_frames = 0
var player_in_start = false
var bullet = preload("res://Objects/My_Stuff/Boss/objBossBullet.tscn")
var cloud = preload("res://Objects/My_Stuff/Speed/objSpeedCloud.tscn")
var bird = preload("res://Objects/My_Stuff/Speed/objSpeedBird.tscn")

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
	
	if t(349, 379):
		handle_bird()
		handle_cloud()
	elif one(379):
		for i in $Instances.get_children():
			if "fall_speed" in i: # cloud
				i.fall_speed = 1000
			else:
				i.velocity.y = 1000

var last_bird = 349
func handle_bird():
	if b()  > last_bird:
		var bd = bird.instantiate()
		bd.position = $Boss3c.position
		bd.position.y += randf_range(-100, 500)
		bd.position.x += (randi_range(0,1) - 0.5)*800
		bd.velocity = Vector2(0,0)
		if bd.position.x < $Boss3c.position.x:
			bd.velocity.x = randf_range(100,300)
		else:
			bd.velocity.x = randf_range(-100,-300)
		bd.velocity.y = randf_range(-200, 200)
		last_bird += randf_range(0.5, 1)
		$Instances.add_child(bd)
	
	pass

var last_cloud = 349
func handle_cloud():
	if b() > last_cloud:
		var c = cloud.instantiate()
		c.position = $Boss3c.position
		c.position.y -= 100
		c.position.x += randf_range(-400,400)
		var cloud_size = randi_range(1,3)
		if cloud_size == 1:
			last_cloud += 0.5
		elif cloud_size == 2:
			c.scale = Vector2(1.5,1.5)
			last_cloud += 1
			c.fall_speed = 200
		elif cloud_size == 3:
			c.scale = Vector2(2,2)
			last_cloud += 2
			c.fall_speed = 400
		$Instances.add_child(c)
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

var next_bullet = 317
func handle_bullets():
	if b() > next_bullet:
		next_bullet += 0.1
		var blt = bullet.instantiate()
		# setup(mode="circle", velocity=Vector2(0,0), direction=0, curve=0, m_scale=0.5):
		blt.setup("circle", Vector2(0, 100), randf_range(-80, 80))
		blt.position = $Boss3b.position
		blt.set_colour()
		$Instances.add_child(blt)
