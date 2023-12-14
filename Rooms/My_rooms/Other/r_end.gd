extends Node2D


func _ready():
	# if it's the first time entering the credits, save the final time
	print(GLOBAL_SAVELOAD.variableGameData)
	if GLOBAL_SAVELOAD.variableGameData.final_time == 0:
		GLOBAL_SAVELOAD.variableGameData.final_time = GLOBAL_GAME.time
		GLOBAL_SAVELOAD.variableGameData.final_deaths = GLOBAL_GAME.deaths

	var time_string = GLOBAL_GAME.seconds_to_time(GLOBAL_SAVELOAD.variableGameData.final_time)
	$deaths.set_text(str(GLOBAL_SAVELOAD.variableGameData.final_deaths))
	$time.set_text(time_string)
	
