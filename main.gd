extends Node2D

var current_room_scene = null
var room_connections = {
	"Room1": {"right": {"room": "Room2", "entry": "left"},
			"left": {"room": "Room3", "entry": "right"}},
	"Room2": {"left": {"room": "Room1", "entry": "right"},
			  "right": {"room": "Room3", "entry": "left"}},
	"Room3": {"left": {"room": "Room2", "entry": "right"},
			  "right": {"room": "Room1", "entry": "left"}}
}
var transitioning = false

func _ready():
	# Load the initial room (Room1)
	print("Ready")
	load_room("Room1", "left")

func load_room(room_name, entry_direction):
	print(transitioning)
	if transitioning:
		return # Prevent loading a new room if a transition is already in progress

	transitioning = true

	# Unload the current room if it exists
	if current_room_scene:
		current_room_scene.queue_free()

	# Load the new room scene
	var room_path = "res://" + room_name + ".tscn"
	print("Loading: ", room_path)
	var room_scene = ResourceLoader.load(room_path)
	
	# Check if the loaded resource is a PackedScene
	if room_scene is PackedScene:
		var room_instance = room_scene.instantiate() # Instantiate the PackedScene
		$RoomContainer.add_child(room_instance) # Add the instance to the RoomContainer

		# Update the current_room_scene to the new instance
		current_room_scene = room_instance

		# Position the player at the correct entry point
		var entry_point = current_room_scene.get_node(entry_direction.capitalize() + "Entry")
		$Player.global_position = entry_point.global_position

		# Connect to the room_loaded signal
		if current_room_scene.has_signal("room_loaded"):
			print("has signal")
			current_room_scene.connect("room_loaded", Callable(self, "_on_room_loaded"))
	else:
		print("Error: The loaded resource is not a PackedScene.")

func transition_to_next_room(current_room, exit_direction):
	print("Current room and exit direction: ", current_room, exit_direction)
	var next_room_data = room_connections[current_room][exit_direction]
	var next_room = next_room_data.room
	var entry_direction = next_room_data.entry
	print("Next room and entry direction: ", next_room, entry_direction)

	# Transition to the next room
	call_deferred("load_room", next_room, entry_direction)
	#transitioning = false

func _on_room_loaded():
	transitioning = false
	print("Room fully loaded and ready.")
