extends Node2D

var iframe = false
var damage = 1
var player_in_hitbox = false

func react_to_hit(attack_type, attack_damage):
	if !iframe:
		$"/root/rBoss".take_damage(attack_type, attack_damage)
		iframe = true
		$Timer.start($/root/rBoss.seconds_per_beat * 0.75)
		$bossSprite.play("hit")

func on_timeout():
	iframe = false
	$bossSprite.play("default")

func _physics_process(_delta):
	if %objPlayer && %objPlayer.position.x < position.x:
		$bossSprite.flip_h = false
	elif %objPlayer && %objPlayer.position.x > position.x:
		$bossSprite.flip_h = true
	
	if player_in_hitbox == true:
		%objPlayer.take_damage(damage)
	


func _on_player_collision_body_entered(_body):
	player_in_hitbox = true
	pass # Replace with function body.


func _on_player_collision_body_exited(_body):
	player_in_hitbox = false
	pass # Replace with function body.







