extends Node2D

@onready var target = $Target
var create_beat = 117
var start_beat = 119
var end_beat = 121
var fired_laser = false
var relative_end_position = Vector2(100,-100)
var start_position = Vector2(0,0)
var player_offset = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$turretShape/Laser.set_visible(false)
	start_position = position
	pass # Replace with function body.

func _physics_process(delta):
	var beat = GLOBAL_GAME.boss_beat
	if beat < start_beat:
		target.global_position = get_tree().get_nodes_in_group("Player")[0].global_position + player_offset
		look_at(target.global_position)
		var weight = inverse_lerp(create_beat, start_beat, beat)
		var new_position = lerp(start_position, start_position + relative_end_position, ease(weight,0.4))
		position = new_position
	elif beat < end_beat:
		$turretShape/Laser.set_visible(true)
	elif !fired_laser:
		$AnimationPlayer.play("laserfire")
		fired_laser = true
	elif beat > end_beat+1:
		var weight = inverse_lerp(end_beat+1, end_beat+3, beat)
		var new_position = lerp(start_position + relative_end_position, start_position, ease(weight, -3))
		position = new_position
	elif beat > end_beat + 3:
		queue_free()
	
