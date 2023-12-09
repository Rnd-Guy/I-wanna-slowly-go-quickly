extends SpeedBuff

## Amount to multiply to player's speed. Should be > 0
@export var multiplier: float = 1

func _ready():
	$Control/Label.set_text("x" + str(multiplier))
	update_text_scaling()

func buff_effect():
	if contact_body is Player:
		contact_body.h_speed *= multiplier
		GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
