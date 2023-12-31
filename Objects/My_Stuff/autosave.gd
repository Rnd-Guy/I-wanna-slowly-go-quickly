extends Node2D

# default will make it face whatever kid was facing when they entered the warp
@export_enum("Right:1", "Left:-1", "Default:0") var facing: int = 0

func _ready():
	if facing != 0:
		GLOBAL_INSTANCES.objPlayerID.xscale = facing
	GLOBAL_SAVELOAD.save_game()
