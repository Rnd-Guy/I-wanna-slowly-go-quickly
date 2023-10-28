extends Node2D

@export var show: bool = false
@export var delete_after_save: bool = true

var is_touching_save = false
var can_save = true

func _ready():
	if !show:
		modulate.a = 0

func _physics_process(_delta):
	if (is_touching_save == true):
			$Sprite2D.frame = 1
			$Timer.start()
	
	is_saving_allowed()



# Reads the animation frame from the save sprite. Also uses a variable to only
# save once
func is_saving_allowed() -> void:
	
	# If the save button is green (saving), save once and wait until it's red
	# (not saving) again
	if ($Sprite2D.frame == 1):
		if (can_save == true):
			# The actual saving is done here
			GLOBAL_SAVELOAD.save_game()
			if delete_after_save:
				queue_free()
		can_save = false
	
	# Save button is red (not saving). Can save as soon as the button turns 
	# green again
	elif ($Sprite2D.frame == 0):
		can_save = true



func _on_hitbox_body_entered(body):
	
	# Check if player is touching the save
	if (body.name == "objPlayer"):
		is_touching_save = true
			

# Check if player is not touching the save anymore
func _on_hitbox_body_exited(body):
	if (body.name == "objPlayer"):
		is_touching_save = false
	


func _on_timer_timeout():
	$Sprite2D.frame = 0
