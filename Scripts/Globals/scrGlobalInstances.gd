"""
This script is used to reference objects globally. A common case for this is
the player object
"""

extends Node

# The player object
var objPlayerID: Node = null

signal player_speed_changed(newSpeed)
signal player_landed()
