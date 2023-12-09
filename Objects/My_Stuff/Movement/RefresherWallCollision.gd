extends StaticBody2D

func on_player_collision(player, collision):
	$"../../RefresherWall".handle_collision(player, collision)
