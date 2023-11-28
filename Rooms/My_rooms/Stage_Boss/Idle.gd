extends State

var end_beat
var possible_next_states = [
	["slide", 3], 
	["jump", 3], 
	#["rebound", 1]
]
var weighted_sum = 0

func _ready():
	for s in possible_next_states:
		weighted_sum += s[1]

func enter():
	var current_beat = floori(GLOBAL_GAME.boss_beat)
	end_beat = randi_range(current_beat+2, current_beat+3)
	
func physics(_delta):
	if GLOBAL_GAME.boss_beat > end_beat:
		var random_float = randf_range(0, weighted_sum);
		var current_sum = 0
		for state in possible_next_states:
			current_sum += state[1]
			if current_sum > random_float:
				Transition.emit(self, state[0])
				break
		
	
