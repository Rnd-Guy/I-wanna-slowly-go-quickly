extends Node2D

# ammo on room start
@export var initial_ammo = 0

# ammo when landing on floor
@export var default_instant_speed_ammo = 0

var setup = false

func _physics_process(_delta):
	if setup == false && get_tree().get_first_node_in_group("Player"):
		setup = true
		var player = get_tree().get_first_node_in_group("Player")
		player.show_instant_speed = true
		player.instant_speed_ammo = initial_ammo
		player.default_instant_speed_ammo = default_instant_speed_ammo
		
