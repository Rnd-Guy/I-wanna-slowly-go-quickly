extends RigidBody2D

signal player_collision(player, collision)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_player_collision(player, collision):
	player_collision.emit(player, collision)
