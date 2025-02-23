class_name MouseDirectionComponent
extends Node3D
## A component intended to store the angle of the mouse from the parent node to the mouse .

### Signals ###
signal mouse_moved

### Enums ###

### Constants ###

### Exported variables ###
@export var min_speed := 1.0
@export var active_camera : Camera3D
@export var collider: Node3D

### Public variables ###
var mouse_pos_2d := Vector2.ZERO
var mouse_pos_3d := Vector3.ZERO
var target_rotation := 0.0

### Private variables ###

### Onready variables ###
@onready var parent_node: Node3D = get_parent()

### Built in virtual methods ###

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Global.game_paused == true):
		return

	# Get the mouse position and project it to 3D
	mouse_pos_2d = get_viewport().get_mouse_position()
	mouse_pos_3d = active_camera.project_position(mouse_pos_2d, get_depth_away_from_camera())

	# Calculate direction from the parent_node to the mouse
	var direction_to_mouse = (mouse_pos_3d - parent_node.global_transform.origin).normalized()

	# Rotate parent_node to face the direction of the mouse (ignore Y-axis)
	target_rotation = atan2(-direction_to_mouse.x, -direction_to_mouse.z)
	collider.rotation.y = target_rotation
	mouse_moved.emit()

### Public methods ###

func get_depth_away_from_camera() -> float:
	return active_camera.position.length()

### Private methods ###