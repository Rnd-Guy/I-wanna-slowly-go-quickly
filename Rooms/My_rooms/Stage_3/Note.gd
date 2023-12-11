extends Node2D

func _process(delta):
	$Sprite.get_material().set_shader_parameter("screen_position", position)

func _physics_process(delta):
	position.y += 100*delta
