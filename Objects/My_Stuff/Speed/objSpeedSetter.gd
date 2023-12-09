extends SpeedBuff

@export var speed: float = 3

func _ready():
	var prefix = "="
	var speed_label = str(speed)
	if speed > 1000:
		speed_label = "c"
	$Control/Label.set_text(prefix + speed_label)
	update_text_scaling()
	

func buff_effect():
	if contact_body is Player:
		contact_body.h_speed = speed
		GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
