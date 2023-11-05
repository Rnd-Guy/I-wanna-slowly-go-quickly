extends BossPhase


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
	var weight = min(w(117,145,b()),1) # don't extrapolate
	var cameraX = lerp(400,2000,weight)
	print(cameraX)
	$objCameraDynamic.set_global_position(Vector2(cameraX,304))
	
	
