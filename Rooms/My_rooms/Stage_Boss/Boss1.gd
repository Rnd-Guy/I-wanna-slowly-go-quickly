extends Node2D

var iframe = false

func react_to_hit(attack_type, attack_damage):
	if !iframe:
		$"/root/rBoss".take_damage(attack_type, attack_damage)
		iframe = true
		$Timer.start($/root/rBoss.seconds_per_beat * 0.75)
		$bossSprite.play("hit")

func on_timeout():
	iframe = false
	$bossSprite.play("default")
