extends SpeedBuff

@export var speed: float = 3

func _ready():
	var prefix = "="
	$Label.set_text(prefix + str(speed))

func buff_effect():
	if contact_body is Player:
		contact_body.h_speed = speed
		GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
	
