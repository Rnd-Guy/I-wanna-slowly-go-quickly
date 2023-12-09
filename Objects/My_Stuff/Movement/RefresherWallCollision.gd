extends StaticBody2D

func on_player_collision(player, collision):
	get_owner().handle_collision(player, collision)
