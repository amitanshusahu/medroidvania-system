extends Node2D

signal room_loaded

func _ready():
	# Emit the signal when the room is fully loaded and ready
	emit_signal("room_loaded")
	get_tree().root.get_node("Main").transitioning = false

func _on_left_exit_body_entered(body):
	if body.name == "Player":
		get_tree().root.get_node("Main").transition_to_next_room("Room2", "left")


func _on_right_exit_body_entered(body):
	if body.name == "Player":
		get_tree().root.get_node("Main").transition_to_next_room("Room2", "right")
