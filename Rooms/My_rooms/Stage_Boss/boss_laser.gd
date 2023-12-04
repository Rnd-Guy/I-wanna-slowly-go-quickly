extends Node2D

var player_in_hitbox = false
@export var damage = 3
var direction = 0 # 0 = south

func _physics_process(_delta):
	if player_in_hitbox:
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			player.take_damage(damage)

func _on_area_2d_body_entered(body):
	if body is Player:
		player_in_hitbox = true


func _on_area_2d_body_exited(body):
	if body is Player:
		player_in_hitbox = false

func play(animation, speed=1):
	$AnimationPlayer.play(animation, -1, speed)
