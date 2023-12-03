extends Node2D

@export var speed = -1
@export var velocity = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	$objSpeedAdderCustom.one_use = true
	$objSpeedAdderCustom.speed = speed
	$objSpeedAdderCustom/AnimatedSprite2D.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	translate(velocity * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
