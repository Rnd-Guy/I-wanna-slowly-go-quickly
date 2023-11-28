extends SpeedBuff

## Amount added to player speed. Can be negative
@export var speed: float = 1
@export var decay: float = 0
@export var colour_cap = 0

func _ready():
	update_text()
	update_colour()

func _physics_process(delta):
	if decay > 0:
		speed -= decay * delta
		update_text()
		update_colour()
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
	
	if !one_use && fade_timer < 100:
		$Infinity.set_visible(true)

func update_colour():
	if speed > 0:
		$Green.set_visible(true)
		$Red.set_visible(false)
		$Sprite2D.set_visible(false)
		$Green.color.s = 0.5 + (tanh(speed/10)*0.5)
	elif speed < 0:
		$Green.set_visible(false)
		$Red.set_visible(true)
		$Sprite2D.set_visible(false)
		$Red.color.s = 0.5 + (tanh(-speed/10)*0.5)
	else: # speed = 0
		$Green.set_visible(false)
		$Red.set_visible(false)
		$Sprite2D.set_visible(true)
	
	if colour_cap > 0:
		if speed > 0:
			$Green.color.s = 0.3 + (tanh((speed/colour_cap)*2)*0.7)
			$Red.color.s = 0.3 + (tanh((-speed/colour_cap)*2)*0.7)
