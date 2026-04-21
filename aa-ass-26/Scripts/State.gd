class_name State extends Node

var boid: Larva
var sm: StateMachine

func _ready() -> void:
	
	sm = get_parent() as StateMachine
	boid = sm.get_parent() as Larva

func _enter() -> void:
	pass

func _exit() -> void:
	pass

# Called every frame by StateMachine — put behaviour + transitions here
func _think(_delta: float) -> void:
	pass
