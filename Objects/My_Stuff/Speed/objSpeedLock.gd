extends Node2D

## speed used for condition
@export var speed: float = 3

## if true, player can pass through if they are faster than this speed
@export var above: bool = true

## if true, player can pass through if they are slower than this speed
@export var below: bool = false

## if true, player can pass through if they are equal than this speed 
@export var equal: bool = true

## if true, destroys itself if the player goes in while meeting the conditions
@export var one_use: bool = false

## if true, the first time this toggles, it stays permanently
@export var perma_lock: bool = false
var is_locked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBAL_INSTANCES.player_speed_changed.connect(on_player_speed_change)
	#GLOBAL_INSTANCES.connect("player_speed_changed", self, "on_player_speed_change")
	
	var prefix = ""
	# should never have all true or all false as it's useless
	assert(!(above && below && equal))
	assert(!(!above && !below && !equal))
#	if !above && !below && !equal:
#		prefix = "X"
#	elif above && below && equal:
#		prefix = "*"
	if above && below && !equal:
		prefix = "!="
	elif !above && !below && equal:
		prefix = "=="
	else:
		if above:
			prefix = ">"
		elif below:
			prefix = "<"
		if equal:
			prefix += "="
	
	$Control/Label.set_text(prefix + str(speed))
	print(GLOBAL_INSTANCES.objPlayerID)
	is_locked = false
	update_text_scaling()

func on_player_speed_change(newSpeed):
	var current_value = $StaticBody2D.get_collision_layer_value(2)
	var new_value: bool
	if ((above && newSpeed > speed) ||
			(below && newSpeed < speed) ||
			(equal && newSpeed == speed)):
		new_value = false
		
	else:
		new_value = true
	
	if current_value != new_value && !is_locked:
		$StaticBody2D.set_collision_layer_value(2, new_value)
		if perma_lock:
			is_locked = true
		if new_value:
			modulate.a = 1
		else:
			modulate.a = 0.5


func _on_area_2d_body_entered(body):
	if body is Player && one_use:
		queue_free()

func update_text_scaling():
	var xscale = scale.x
	var yscale = scale.y
	
	if xscale > yscale:
		$Control.scale.x = (yscale/xscale)
	else:
		$Control.scale.y *= (xscale/yscale)
