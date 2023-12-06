extends Node2D

var shine_strength = 0
var max_strength = 0.2
var damage = 0.5

func _physics_process(delta):
	handle_warning_arrow()
	if shine_strength > 0:
		modulate.b = 1 - (shine_strength * 5)
		#shine_strength -= delta


func handle_warning_arrow():
	var canvas_coord = get_global_transform_with_canvas()
	#if get_tree().get_nodes_in_group("Player"):
		#var player = get_tree().get_nodes_in_group("Player")[0]
	if canvas_coord.origin.y > 600 && canvas_coord.origin.y < 900:
		$CanvasLayer/Warning.set_position(Vector2(canvas_coord.origin.x, 620))
		$CanvasLayer/Warning.set_visible(true)
	else:
		$CanvasLayer/Warning.set_visible(false)
		
func shine():
	reset_colour()
	shine_strength = max_strength

func set_colour():
	$Shape/FallingSpike/Polygon2D.color.g = 0.5
	$Shape/FallingSpike/Polygon2D.color.b = 0.5

func reset_colour():
	$Shape/FallingSpike/Polygon2D.color.g = 1
	$Shape/FallingSpike/Polygon2D.color.b = 1

func _on_area_2d_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	shine()

func set_shape_rotation(degrees):
	$Shape.rotation = deg_to_rad(degrees)


func _on_falling_spike_body_entered(body):
	body.h_speed -= damage
	queue_free()
