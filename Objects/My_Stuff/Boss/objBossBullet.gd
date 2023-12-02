extends Node2D

@onready var modes = [
	["circle", $circle],
	["line", $line],
	["arrow", $arrow],
]
var mode = "circle"
var velocity = Vector2(100,100)
var curve = 0
var direction = 0
var default_scale = 0.5
var damage = 1

var player_in_hitbox = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var found = false
	for m in modes:
		if m[0] == mode:
			m[1].set_visible(true)
			m[1].get_node("area").monitoring = false
			found = true
		else:
			m[1].set_visible(false)
			m[1].get_node("area").monitoring = true
	assert(found)
	scale = Vector2(default_scale,default_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# in case i want curving shenanigans
	move_local_x(velocity.x * delta)
	move_local_y(velocity.y * delta)
	rotate(curve*delta)
	if player_in_hitbox:
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			player.take_damage(damage)
			queue_free()

func set_curve(c):
	curve = c

func set_velocity(v):
	velocity = v

func setup(mode="circle", velocity=Vector2(0,0), direction=0, curve=0, m_scale=0.5):
	self.mode = mode
	self.velocity = velocity
	rotation = deg_to_rad(direction)
	scale = Vector2(m_scale, m_scale)
	default_scale = m_scale # in case setup is called before ready()
	self.curve = curve
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_body_entered(body):
	player_in_hitbox = true


func _on_area_body_exited(body):
	player_in_hitbox = false