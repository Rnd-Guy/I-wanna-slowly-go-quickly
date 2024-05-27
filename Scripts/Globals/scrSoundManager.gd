extends Node


# Add sound effects here!
const sndDeath = preload("res://Audio/Sounds/sndDeath.wav")
const sndDJump = preload("res://Audio/Sounds/sndDJump.wav")
const sndJump = preload("res://Audio/Sounds/sndJump.wav")
const sndShoot = preload("res://Audio/Sounds/sndShoot.wav")
const sndJumpRefresher = preload("res://Audio/Sounds/sndJumpRefresher.wav")
const sndMenuButton = preload("res://Audio/Sounds/sndMenuButton.wav")
const sndSave = preload("res://Audio/Sounds/sndSave.wav")
const sndSaveBlocker = preload("res://Audio/Sounds/sndSaveBlocker.wav")
const sndPause = preload("res://Audio/Sounds/sndPause.wav")
const sndHit = preload("res://Audio/Sounds/sndHit.wav")
const sndCherry = preload("res://Audio/Sounds/sndCherry.wav")
const sndCoin = preload("res://Audio/Sounds/sndCoin.wav")
const sndItem = preload("res://Audio/Sounds/sndItem.wav")
const sndWarp = preload("res://Audio/Sounds/sndWarp.wav")
const sndBlockChange = preload("res://Audio/Sounds/sndBlockChange.wav")
const sndZoop = preload("res://Audio/Sounds/sndZoop.wav")
const sndGlass = preload("res://Audio/Sounds/sndGlass.wav")

const sndHoldNote = preload("res://Audio/My Stuff/sndHoldNote.ogg")
const sndRhythm1 = preload("res://Audio/My Stuff/sndRhythm1.wav")

# We get the audioPlayerList node from this variable. A little cleaner
@onready var audioPlayers: Node = $audioPlayerList

var looping_sounds = {}

var volume_offsets = {
	sndHoldNote: -5,
	sndRhythm1: -5
}

# since we can't compare object to object, we'll need to compare the actual resource names
var actual_volume_offsets = {}

# Sound should keep on playing/processing even if the game is paused
func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	for key in volume_offsets:
		actual_volume_offsets[key.resource_name] = volume_offsets[key];

# This function loops through the 8 audioStreamPlayer nodes, gets one that's 
# not on use, assigns it the sound we want and then plays it
func play_sound(sound) -> void:
	for audioStreamPlayers: AudioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayers.playing:
			audioStreamPlayers.stream = sound
			audioStreamPlayers.volume_db = get_volume(sound)
			audioStreamPlayers.play()
			
			break
		
func play_looping_sound(sound):
	if looping_sounds.find_key(sound) == null:
		for audioStreamPlayers in audioPlayers.get_children():
			if not audioStreamPlayers.playing:
				audioStreamPlayers.stream = sound
				audioStreamPlayers.volume_db = get_volume(sound)
				audioStreamPlayers.play()
				looping_sounds[sound] = audioStreamPlayers
				break

func stop_looping_sound(sound):
	var player = looping_sounds.get(sound);
	if player != null:
		player.stop()
	
	
func get_volume(sound):
	var volume = actual_volume_offsets[sound.resource_name]
	if volume != null:
		return volume
	else:
		return 0
