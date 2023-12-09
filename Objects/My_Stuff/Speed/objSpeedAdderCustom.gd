extends SpeedBuff

## Amount added to player speed. Can be negative
@export var speed: float = 1
@export var decay: float = 0
@export var colour_cap = 0

func _ready():
	update_text_scaling()

func _physics_process(delta):
	if decay > 0:
		speed -= decay * delta
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
	$Control/Label.set_text(prefix + speed_string)
	
	if !one_use && fade_timer < 100:
		$Control/Infinity.set_visible(true)

