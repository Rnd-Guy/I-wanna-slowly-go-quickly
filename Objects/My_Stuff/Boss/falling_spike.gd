extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):

	handle_warning_arrow()
		

func handle_warning_arrow():
	var canvas_coord = get_global_transform_with_canvas()
	if get_tree().get_nodes_in_group("Player"):
		var player = get_tree().get_nodes_in_group("Player")[0]
		if canvas_coord.origin.y > 600 && canvas_coord.origin.y < 900:
			$CanvasLayer/Warning.set_position(Vector2(canvas_coord.origin.x, 620))
			$CanvasLayer/Warning.set_visible(true)
		else:
			$CanvasLayer/Warning.set_visible(false)
		
