extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(_delta):
	if is_instance_valid($Room_related/objPlayer) && $Room_related/objPlayer.position[0] < 0:
		$Room_related/objPlayer.position[0] = 40
