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

## For direct equality leniency, how much leeway to give
@export var leniency = 0.01

@onready var sprites = {
	"perma_open": $perma/open,
	"perma_closed": $perma/closed,
	"temp_open": $temp/open,
	"temp_closed": $temp/closed,
	"breakable_open": $breakable/open,
	"breakable_closed": $breakable/closed,
}
var closed = null


# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBAL_INSTANCES.player_speed_changed.connect(on_player_speed_change)
	
	var prefix = ""
	# should never have all true or all false as it's useless
	assert(!(above && below && equal))
	assert(!(!above && !below && !equal))

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
	is_locked = false
	update_text_scaling()
	if get_tree() && get_tree().get_first_node_in_group("Player"):
		on_player_speed_change(get_tree().get_first_node_in_group("Player").h_speed)
	
	handle_sprites()

func on_player_speed_change(newSpeed):
	var current_value = $StaticBody2D.get_collision_layer_value(2)
	if ((above && newSpeed > speed) ||
			(below && newSpeed < speed) ||
			(equal && is_equal(newSpeed, speed))):
		closed = false
	else:
		closed = true
	
	#if current_value != closed && !is_locked:
	if !is_locked:
		$StaticBody2D.set_collision_layer_value(2, closed)
		if perma_lock && closed:
			is_locked = true
#		if new_value:
#			modulate.a = 1
#		else:
#			modulate.a = 0.5
	handle_sprites()

func is_equal(speeda, speedb, len=leniency):
	#print(str(speeda) + " " + str(speedb) + " " + str(len) + " " + str(abs(speeda - speedb) <= leniency))
	return abs(speeda - speedb) <= leniency

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

func handle_sprites():
	if perma_lock:
		$perma.set_visible(true)
		$temp.set_visible(false)
		$breakable.set_visible(false)
		if is_locked:
			turn_off_sprites_except_this_one("perma_closed")
		else:
			turn_off_sprites_except_this_one("perma_open")
	elif one_use:
		$perma.set_visible(false)
		$breakable.set_visible(true)
		$temp.set_visible(false)
		if closed:
			turn_off_sprites_except_this_one("breakable_closed")
		else:
			turn_off_sprites_except_this_one("breakable_open")
	else:
		$perma.set_visible(false)
		$breakable.set_visible(false)
		$temp.set_visible(true)
		if closed:
			turn_off_sprites_except_this_one("temp_closed")
		else:
			turn_off_sprites_except_this_one("temp_open")
		
		
		
func turn_off_sprites_except_this_one(index):
	for i in sprites:
		if i == index:
			sprites[i].set_visible(true)
		else:
			sprites[i].set_visible(false)
