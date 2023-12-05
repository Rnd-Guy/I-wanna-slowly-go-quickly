extends Area2D

var shine_strength = 1

func _physics_process(delta):
	handle_warning_arrow()
	if shine_strength > 0:
		modulate.b = 1 - (0.8 * shine_strength * 2)
		shine_strength -= delta


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
	shine_strength = 0.5

