extends Node2D

# When extending this class, you should copy and override the following functions:
#func _ready():
#	$Label.set_text(str(something))
#func buff_effect():
#	# do stuff here


class_name SpeedBuff

## If true, the buff disappears after being picked up
@export var one_use: bool = false
## If true, the buff is immediately pickupable after the player leaves the area, ignoring fade_timer
@export var fade_instant: bool = false
## Seconds before the buff can be picked up again. Has no effect if fade_instant is true
@export var fade_timer: float = 1

var disabled = false
var in_contact = false
var contact_body

func _ready():
	pass

func _process(delta):
	if in_contact && !disabled:
		buff()

func buff_effect():
	# override this
	pass

func buff():
	if contact_body is Player:

		buff_effect()
		
		if one_use:
			queue_free()
		else:
			disable_buff()

func _on_area_2d_body_entered(body):
	in_contact = true
	contact_body = body
			

func _on_area_2d_body_exited(body):
	in_contact = false
	if fade_instant:
		enable_buff()


func _on_timer_timeout():
	enable_buff()

func disable_buff():
	disabled = true
	modulate.a = 0.5
	if !fade_instant:
		$Timer.start(fade_timer)

func enable_buff():
	disabled = false
	modulate.a = 1
