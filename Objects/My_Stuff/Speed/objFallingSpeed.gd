extends SpeedBuff

## Amount added to player vertical speed. Can be negative
@export var speed: float = 1

## If true, will multiply speed, if false will add speed instead
@export var multiply: bool = false

func _ready():
	var prefix = "+"
	if multiply:
		prefix = "x"
	elif speed <= 0:
		prefix = ""
	var speed_string = str(speed)
	if speed >= 1000:
		speed_string = "c"
	$Control/Label.set_text(prefix + speed_string)
	update_text_scaling()
	

func buff_effect():
	if contact_body is Player:
		if multiply:
			contact_body.v_speed *= speed
		else:
			contact_body.v_speed += speed
		#GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
