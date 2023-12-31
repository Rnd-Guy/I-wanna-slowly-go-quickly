extends Node2D

var logo_speed = 50
var logo_velocity = Vector2(logo_speed, logo_speed)

# Called when the node enters the scene tree for the first time.
func _ready():
	#$IWTLogo.position = Vector2()
	logo_velocity[0] *= [-1,1].pick_random()
	logo_velocity[1] *= [-1,1].pick_random()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if is_instance_valid($Room_related/objPlayer) && $Room_related/objPlayer.position[0] < 0:
		$Room_related/objPlayer.position[0] = 40
	
	$IWTLogo.position += logo_velocity * delta
	if $IWTLogo.position[0] < 160 || $IWTLogo.position[0] > 512:
		logo_velocity[0] *= -1
	if $IWTLogo.position[1] < 32 || $IWTLogo.position[1] > 448:
		logo_velocity[1] *= -1
