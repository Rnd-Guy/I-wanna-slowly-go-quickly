extends Node2D


func _ready():
	# if it's the first time entering the credits, save the final time
	if GLOBAL_SAVELOAD.variableGameData.final_time == 0:
		GLOBAL_SAVELOAD.variableGameData.final_time = GLOBAL_GAME.time
		GLOBAL_SAVELOAD.variableGameData.final_deaths = GLOBAL_GAME.deaths
	
	var final_time = GLOBAL_SAVELOAD.variableGameData.final_time
	var time_string = GLOBAL_GAME.seconds_to_time_with_microseconds(final_time)
	$deaths.set_text(str(GLOBAL_SAVELOAD.variableGameData.final_deaths))
	$time.set_text(time_string)
	
	var barrel_reduction = 0
	if GLOBAL_SAVELOAD.variableGameData.interacted_with_barrel:
		$barrel.set_text("Barrel! (10s)")
		barrel_reduction = 10
	else:
		$barrel.set_text("No :c")
	
	var rhythm_score: float = GLOBAL_SAVELOAD.variableGameData.rhythm_score
	var rhythm_score_reduction: float = (rhythm_score-5000.0)/100.0
	$rhythm.set_text(str(rhythm_score) + " (" + str(rhythm_score_reduction) + "s)")
	
	var miku_score: float = GLOBAL_SAVELOAD.variableGameData.miku_score
	var miku_score_reduction: float = miku_score - 114.0
	$miku.set_text(str(miku_score) + " (" + str(miku_score_reduction) + "s)")
	
	var final_time_after_reduction = final_time - barrel_reduction - rhythm_score_reduction - miku_score_reduction
	$finalTime.set_text(GLOBAL_GAME.seconds_to_time_with_microseconds(final_time_after_reduction))
	
	hide_debug_text()


func _on_area_2d_body_entered(body):
	show_debug_text()

func _on_area_2d_body_exited(body):
	hide_debug_text()

func show_debug_text():
	$DebugLeft.visible = true
	$DebugRight.visible = true

func hide_debug_text():
	$DebugLeft.visible = false
	$DebugRight.visible = false



