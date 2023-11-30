extends BossPhase

var damage = 100
var player_in_hitbox = false

func setup():
	super()
	$objCameraDynamic.make_current()

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera_weight = min(w(117,145,b()),1) # don't extrapolate
	var cameraX = lerp(400,2000,camera_weight)
	$objCameraDynamic.set_global_position(Vector2(cameraX,304))
	
	var phase_weight = min(w(117,149,b()),1)
	var bossX = lerp(88,2000, phase_weight)
	$Boss2.set_global_position(Vector2(bossX,528))
	
func _physics_process(_delta):
	if player_in_hitbox == true:
		%objPlayer.take_damage(damage)
	
	if one(117):
		spawn_turret(rx(), ry(), 120, 121)
	elif one(117.5):
		spawn_turret(rx(), ry(), 120.5, 121.5)
	elif one(118):
		spawn_turret(rx(), ry(), 121, 122)
	elif one(118.5):
		spawn_turret(rx(), ry(), 121.5, 122.5)
	elif one(119):
		spawn_turret(rx(), ry(), 122, 123)

	elif one(121):
		spawn_turret(rx(), ry(), 124, 125)
	elif one(121.5):
		spawn_turret(rx(), ry(), 124.5, 125.5)
	elif one(122):
		spawn_turret(rx(), ry(), 125, 126)
	elif one(122.5):
		spawn_turret(rx(), ry(), 125.5, 126.5)
	elif one(123):
		spawn_turret(rx(), ry(), 126, 127)

	elif one(125):
		spawn_turret(rx(), ry(), 128, 129)
		spawn_turret(rx(), ry(), 128, 129)
	elif one(125.5):
		spawn_turret(rx(), ry(), 128.5, 129.5)
		spawn_turret(rx(), ry(), 128.5, 129.5)
	elif one(126):
		spawn_turret(rx(), ry(), 129, 130)
		spawn_turret(rx(), ry(), 129, 130)
	elif one(126.5):
		spawn_turret(rx(), ry(), 129.5, 130.5)
		spawn_turret(rx(), ry(), 129.5, 130.5)
	
	elif one(133):
		shoot()
		spawn_turret(rx(), ry(), 136, 137)
	elif one(133.5):
		shoot()
		spawn_turret(rx(), ry(), 136.5, 137.5)
	elif one(134):
		spawn_turret(rx(), ry(), 137, 138)
	elif one(134.5):
		spawn_turret(rx(), ry(), 137.5, 138.5)
	
	elif one(137):
		spawn_turret(rx(), ry(), 140, 141)
	elif one(137.5):
		spawn_turret(rx(), ry(), 140.5, 141.5)
	elif one(138):
		spawn_turret(rx(), ry(), 141, 142)
	elif one(138.5):
		spawn_turret(rx(), ry(), 141.5, 142.5)
	elif one(139):
		spawn_turret(rx(), ry(), 142, 143)
	elif one(139.5):
		spawn_turret(rx(), ry(), 142.5, 143.5)
	elif one(140):
		spawn_turret(rx(), ry(), 143, 144)
		
	elif one(141):
		spawn_turret(rx(), ry(), 144, 145)
		spawn_turret(rx(), ry(), 144, 145)
		spawn_turret(rx(), ry(), 144, 145)
		spawn_turret(rx(), ry(), 144, 145)
		spawn_turret(rx(), ry(), 144, 145)
	elif one(142):
		spawn_turret(rx(), ry(), 145, 146)
		spawn_turret(rx(), ry(), 145, 146)
		spawn_turret(rx(), ry(), 145, 146)
		spawn_turret(rx(), ry(), 145, 146)
		spawn_turret(rx(), ry(), 145, 146)
	elif one(143):
		spawn_turret(rx(), ry(), 146, 147)
		spawn_turret(rx(), ry(), 146, 147)
		spawn_turret(rx(), ry(), 146, 147)
		spawn_turret(rx(), ry(), 146, 147)
		spawn_turret(rx(), ry(), 146, 147)
	elif one(144):
		spawn_turret(rx(), ry(), 147, 148)
		spawn_turret(rx(), ry(), 147, 148)
		spawn_turret(rx(), ry(), 147, 148)
		spawn_turret(rx(), ry(), 147, 148)
		spawn_turret(rx(), ry(), 147, 148)
	elif one(145):
		$Boss2/BossRelativeTransformer.set_remote_node("")

func _on_player_collision_body_entered(body):
	# immediately kill on contact
	#player_in_hitbox = true
	%objPlayer.on_death()


func _on_player_collision_body_exited(body):
	player_in_hitbox = false

func spawn_turret(x, y, start_beat, end_beat):
	$Boss2.spawn_turret(Vector2(x, y), start_beat, end_beat)

func rx():
	return 0 + randf_range(0,300)

func ry():
	return -100 + randf_range(0,-200)

func shoot():
	$Boss2.shoot("circle", Vector2(200, 0), randf_range(-10,10), 0, 1)
