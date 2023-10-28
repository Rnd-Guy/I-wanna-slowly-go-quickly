extends SpeedBuff

## Amount to multiply to player's speed. Should be > 0
@export var multiplier: float = 1

func _ready():
	$Label.set_text("x" + str(multiplier))

func buff_effect():
	if contact_body is Player:
		contact_body.h_speed *= multiplier
		GLOBAL_INSTANCES.player_speed_changed.emit(contact_body.h_speed)
		

#extends Node2D
#
#@export var multiplier: float = 1
#@export var one_use: bool = false
#@export var fade_timer: float = 5
#
#var disabled = false
#var in_contact = false
#var contact_body
#
#func _ready():
#	$Label.set_text("x" + str(multiplier))
#
#
#func _process(delta):
#	if in_contact && !disabled:
#		buff()
#
#
#func buff():
#	if contact_body is Player:
#		contact_body.h_speed *= multiplier
#
#		if one_use:
#			queue_free()
#		else:
#			disabled = true
#			$Timer.start(fade_timer)
#			modulate.a = 0.5
#
#func _on_area_2d_body_entered(body):
#	in_contact = true
#	contact_body = body
#
#
#func _on_area_2d_body_exited(body):
#	in_contact = false
#
#
#func _on_timer_timeout():
#	disabled = false
#	modulate.a = 1
#	pass
#
#
