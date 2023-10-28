extends SpeedBuff

## Amount added to player speed. Can be negative
@export var speed: float = 1

func _ready():
	var prefix = "+"
	if speed <= 0:
		prefix = ""
	var speed_string = str(speed)
	if speed >= 1000:
		speed_string = "c"
	$Label.set_text(prefix + speed_string)

func buff_effect():
	if contact_body is Player:
		contact_body.h_speed += speed
		#if contact_body.h_speed < 0:
		#	contact_body.h_speed = 0
		GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
	
