extends SpeedBuff

## Amount added to player speed. Can be negative
@export var speed: float = 1
@export var decay: float = 0

func _ready():
	update_text()

func _physics_process(delta):
	if decay > 0:
		speed -= decay * delta
		update_text()
		if speed <= 0:
			queue_free()

func buff_effect():
	if contact_body is Player:
		contact_body.h_speed += speed
		GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
	
func update_text():
	var prefix = "+"
	if speed <= 0:
		prefix = ""
	var speed_string = str(snapped(speed,0.01))
	if speed >= 1000:
		speed_string = "c"
	$Label.set_text(prefix + speed_string)
