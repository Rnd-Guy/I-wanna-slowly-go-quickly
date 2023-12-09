extends SpeedBuff

## Amount to multiply to player's speed. Should be > 0
@export var multiplier: float = 1

func _ready():
	if multiplier >= 1:
		$Control/Label.set_text("x" + str(multiplier))
	else:
		$Control/Label.set_text("/" + str(1/multiplier))
	update_text_scaling()

func buff_effect():
	if contact_body is Player:
		contact_body.h_speed *= multiplier
		GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
