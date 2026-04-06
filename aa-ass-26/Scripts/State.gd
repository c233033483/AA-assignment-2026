class_name State extends Node

var boid
var state_machine

func _enter() -> void:
	pass  # called when this state becomes active

func _exit() -> void:
	pass  # called when leaving this state

func _think():
	pass
 

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = get_parent()
	pass # Replace with function body.
