extends BossPhase

# 281 to 285

func setup():
	super()
	setup_animation()
	$fixedCamera.make_current()
	$fixedCamera.reset_smoothing()
	%objPlayer.d_jump = false
	%objPlayer.vertical_shots = true
	%objPlayer.enable_shmup_mark_1()
	%objPlayer.frozen = true

func reset():
	super()
	$"../../Room_related/objCameraFixedNoSmoothing".make_current()
	$"../../Room_related/objCameraFixedNoSmoothing".reset_smoothing()
	#first_frames = 0
	%objPlayer.vertical_shots = false
	%objPlayer.disable_shmup_mark_1()
	%objPlayer.frozen = false

func setup_animation():
	%objPlayer.position = $Start.position
	$PlayerAnimation.active = true
	$TextAnimation.play("TransitionText")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if one(281):
		$PlayerAnimation.play("Shake", -1, 0.1)
	elif one(282):
		$PlayerAnimation.play("Shake", -1, 0.2)
	elif one(283):
		$PlayerAnimation.play("Shake", -1, 1)
	elif one(284):
		$PlayerAnimation.play("BlastOff")

