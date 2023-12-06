extends Node2D

var shine_strength = 0
var max_strength = 0.2
var timeout = false

func _physics_process(delta):
	if shine_strength > 0:
		modulate.b = 1 - (shine_strength * 5)
		#shine_strength -= delta

func shine():
	#shine_strength = max_strength
	$Polygon2D.color = "000000"

func _on_area_2d_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if timeout:
		shine()

# avoid flashing on phase change
func _on_timer_timeout():
	timeout = true
