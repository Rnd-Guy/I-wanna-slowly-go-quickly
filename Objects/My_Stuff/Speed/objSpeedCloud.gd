extends Node2D

@export var speed: float = -1
@export var fall_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	var cloud = randi_range(0,1)
	if cloud == 0:
		$objSpeedAdderCustom/cloud2.set_visible(false)
		$objSpeedAdderCustom/cloud2/Area2D.set_monitoring(false)
	elif cloud == 1:
		$objSpeedAdderCustom/cloud1.set_visible(false)
		$objSpeedAdderCustom/cloud1/Area2D.set_monitoring(false)

	var test = $objSpeedAdderCustom
	$objSpeedAdderCustom.speed = speed
	$objSpeedAdderCustom.one_use = true

func _physics_process(delta):
	translate(Vector2(0,fall_speed * delta))

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
