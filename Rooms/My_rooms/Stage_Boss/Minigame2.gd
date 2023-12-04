extends BossPhase

var cap = 0.8

func setup():
	super()
	%objPlayer.set_global_position($start.global_position)
	for i in $buffs.get_children():
		handle_random_adder(i)

func reset():
	super()
	%objPlayer.reverse_controls = false
	%objPlayer.set_modulate(Color(1,1,1))

func _physics_process(_delta):
	if t(81,113):
		if floori((b()+1)/2) % 2 == 0:
			$BlackBar.set_scale(Vector2(1,1))
			$BlackBar.set_z_index(1)
			$WhiteBar.set_scale(Vector2(fmod((b()+1)/2,2),1))
			$WhiteBar.set_z_index(2)
			%objPlayer.reverse_controls = true
			%objPlayer.set_modulate(Color(0,0,0))
		else:
			$WhiteBar.set_scale(Vector2(1,1))
			$WhiteBar.set_z_index(1)
			$BlackBar.set_scale(Vector2(fmod(((b()+1)/2)-1,2),1))
			$BlackBar.set_z_index(2)
			%objPlayer.reverse_controls = false
			%objPlayer.set_modulate(Color(1,1,1))
	elif t(113,114):
		%objPlayer.reverse_controls = false
		%objPlayer.set_modulate(Color(1,1,1))
		

func handle_random_adder(adder_node):
	adder_node.colour_cap = cap
	adder_node.speed = randf_range(0.01, cap)
	adder_node.speed *= adder_node.speed
	adder_node.enable_buff()
	adder_node._ready()
