extends Node2D

@export var left = true
@export var right = false
@export var limited = true

var used_left = false
var used_right = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if left:
		$StaticCollision/LeftRefresher.set_visible(true)
	else:
		$StaticCollision/LeftRefresher.set_visible(false)
	
	if right:
		$StaticCollision/RightRefresher.set_visible(true)
	else:
		$StaticCollision/RightRefresher.set_visible(false)

func _physics_process(_delta):
	if used_left:
		$StaticCollision/LeftRefresher/Poly.modulate.r = 0
	if used_right:
		$StaticCollision/RightRefresher/Poly.modulate.r = 0

func handle_collision(player, collision):
	if player.just_dashed && right && !used_right && collision.get_normal().x > 0:
		if player.instant_speed_ammo >= 0: # ie not infinite
			player.instant_speed_ammo += 1
		player.d_jump = true
		if limited:
			used_right = true
	elif player.just_dashed && left && !used_left && collision.get_normal().x < 0:
		if player.instant_speed_ammo >= 0:
			player.instant_speed_ammo += 1
		player.d_jump = true
		if limited:
			used_left = true
