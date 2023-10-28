extends Node2D

@export var hp: float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.set_text(str(hp))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($RigidBody2D.get_contact_count())
	#print($RigidBody2D.get_colliding_bodies())
	pass

func _on_speed_damage_rigid_player_collision(player, collision):
	#print("angle: " + str(collision.get_angle()))
	#print("normal: " + str(collision.get_normal().x) + ", " + str(collision.get_normal().y))
	
	# horizontal collisions only
	if collision.get_normal().x == 1 || collision.get_normal().x == -1:
		var damage = player.h_speed - 3
		if damage > 0:
			if damage > hp:
				damage = hp
			hp -= damage
			player.h_speed -= damage
			$Label.set_text(str(hp))
			GLOBAL_INSTANCES.player_speed_changed.emit(player.h_speed)
		
			if hp <= 0:
				queue_free()
