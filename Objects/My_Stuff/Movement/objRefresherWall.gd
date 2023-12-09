extends Node2D

@export var left = true
@export var right = false

var in_left = false
var in_right = false
var used_left = false
var used_right = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if left:
		$StaticCollision/LeftRefresher.set_visible(true)
		$StaticCollision/LeftRefresher/Area2D.set_monitoring(true)
	else:
		$StaticCollision/LeftRefresher.set_visible(false)
		$StaticCollision/LeftRefresher/Area2D.set_monitoring(false)
	
	if right:
		$StaticCollision/RightRefresher.set_visible(true)
		$StaticCollision/RightRefresher/Area2D.set_monitoring(true)
	else:
		$StaticCollision/RightRefresher.set_visible(false)
		$StaticCollision/RightRefresher/Area2D.set_monitoring(false)

func _physics_process(_delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		if in_left && player.just_dashed > 0:
			player.instant_speed_ammo += 1
			player.d_jump = true
			used_left = true
		if in_right && player.just_dashed > 0:
			player.instant_speed_ammo += 1
			player.d_jump = true
			used_right = true
		
	if used_left:
		$StaticCollision/LeftRefresher/Poly.modulate.r = 0
	if used_right:
		$StaticCollision/RightRefresher/Poly.modulate.r = 0

func _on_left_area_2d_body_entered(body):
	print("int")
	if !used_left:
		in_left = true


func _on_right_area_2d_body_entered(body):
	if !used_right:
		in_right = true


func _on_left_area_2d_body_exited(body):
	in_left = false


func _on_right_area_2d_body_exited(body):
	in_right = false

func handle_collision(player, collision):
	if player.just_dashed > 0 && collision.get_normal().x > 0:
		used_right = true
	elif player.just_dashed > 0 && collision.get_normal().x < 0:
		used_left = true
