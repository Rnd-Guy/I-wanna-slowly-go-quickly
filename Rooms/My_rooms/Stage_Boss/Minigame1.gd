extends BossPhase

var player_in_start = false
var first_frames = 0

func setup():
	super()
	$objCameraDynamic.make_current()
	$FallCheck.monitoring = true

func reset():
	super()
	first_frames = 0
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if first_frames < 2:
		first_frames += 1
	elif first_frames == 2:
		setup_deferred()
		first_frames = 3


func setup_deferred():
	if !player_in_start:
		%objPlayer.set_global_position($Start.global_position)

func _on_position_check_body_entered(_body):
	player_in_start = true
	pass # Replace with function body.


func _on_position_check_body_exited(_body):
	player_in_start = false
	pass # Replace with function body.


func _on_fall_check_body_entered(_body):
	%objPlayer.set_global_position($Start.global_position)
	#%objPlayer.h_speed -= 1
	pass # Replace with function body.

func gain_speed(speed):
	%objPlayer.set_global_position($Start.global_position)
	%objPlayer.h_speed += speed
	GLOBAL_INSTANCES.player_speed_changed.emit(%objPlayer.h_speed)
