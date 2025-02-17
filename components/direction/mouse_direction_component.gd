class_name MouseDirectionComponent
extends Node3D
## A component intended to store the angle of the mouse from the parent node to the mouse .

### Signals ###

### Enums ###

### Constants ###
const UP_VECTOR := Vector3(0,1,0)

### Exported variables ###
@export var min_speed := 1.0
@export var active_camera : Camera3D
@export var mesh: Node3D
@export var collider: Node3D

### Public variables ###
var mouse_pos_2d := Vector2.RIGHT
var mouse_pos_3d := Vector3.RIGHT
var look_direction := Vector3.RIGHT
var space_state: PhysicsDirectSpaceState3D
var ray_origin := Vector3.ZERO
var ray_end := Vector3.ZERO
var translation_y := 0.0

### Private variables ###

### Onready variables ###
@onready var parent_node: Node3D = get_parent()

### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space_state = get_world_3d().direct_space_state 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_get_mouse_angle()
	pass

### Public methods ###

func look_at_mouse() -> void:
	_get_mouse_angle()

### Private methods ###

func _get_mouse_angle() -> void: 
	# Obtain mouse position 2D and convert it into a 3D representation
	mouse_pos_2d = get_viewport().get_mouse_position()
	translation_y = parent_node.position.y

	# We are projecting the Vector2 of mouse position into 3D coordinates. This will act as the origin of where are mouse is at on the camera in 3D space
	# We then get where the mouse is pointing out in the screen by extending the origin ray by some arbitrarily large number so that it can intersect an object
	# Finally we see if the mouse intersects with any objects on screen, and if it does we get the point of intersection and look towards that point
	ray_origin = active_camera.project_ray_origin(mouse_pos_2d)
	ray_end = ray_origin + active_camera.project_ray_normal(mouse_pos_2d) * 2000
	var physics_ray_query_params_3d := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	var intersection = space_state.intersect_ray(physics_ray_query_params_3d)

	if (not intersection.is_empty()):
		mouse_pos_3d = intersection.position
		look_direction = Vector3(mouse_pos_3d.x, translation_y, mouse_pos_3d.z)
		mesh.look_at(look_direction, UP_VECTOR)
		collider.look_at(look_direction, UP_VECTOR)
