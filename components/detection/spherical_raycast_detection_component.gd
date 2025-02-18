class_name SphericalRaycastDetectionComponent
extends Node3D
## A component intended to form a sphere of raycasts to detect where bodies are and where the exact point that collides.
##
## This component adds an editable "nervousness".

### Signals ###

### Enums ###

### Constants ###
const STARTING_VERTICAL_ANGLE = 0.0
const STARTING_HORIZONTAL_ANGLE = 0.0

### Exported variables ###
@export var num_ray_casts_horizontal := 10
@export var num_ray_casts_vertical := 10
@export var ray_cast_origin := Vector3(0,0,0)
@export var ray_cast_length := 5.0
@export var exceptions: Array[Node3D] = [self.get_parent()]
@export var detectable_collision_masks: Array[int] = [Global.OBSTACLE_LAYER, Global.ENTITY_LAYER]

### Public variables ###
var raycasts_to_closest_body: Dictionary = {}
var body_to_colliding_point: Dictionary = {}

### Private variables ###

### Onready variables ###

### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vertical_angle = STARTING_VERTICAL_ANGLE
	var horizontal_angle = STARTING_HORIZONTAL_ANGLE

	var vertical_angle_increment = PI / num_ray_casts_vertical
	var horizontal_angle_increment = PI / num_ray_casts_horizontal

	# Rotate in equal increments around the sphere until you reach the starting point
	# At each point generate a raycast at the origin rotated by the angle it is on the sphere
	for vertical_ray in range(num_ray_casts_vertical):
		for horizontal_ray in range(num_ray_casts_horizontal):
			_create_raycast(vertical_angle, horizontal_angle)
			horizontal_angle += horizontal_angle_increment
		vertical_angle += vertical_angle_increment

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_detect_collisions()

### Public methods ###

### Private methods ###

func _create_raycast(vertical_rotation: float, horizontal_rotation: float) -> void: 
	var raycast = RayCast3D.new()
	raycast.enabled = true
	raycast.position = ray_cast_origin
	raycast.target_position = Vector3(0,0,ray_cast_length)
	raycast.rotate_y(horizontal_rotation)
	raycast.rotate_x(vertical_rotation)

	# Nodes to ignore
	_set_exceptions(raycast)
	_set_collision_mask_layers(raycast)

	add_child(raycast)
	raycasts_to_closest_body[raycast] = null

	# Check collision
	if raycast.is_colliding():
		var hit_collider = raycast.get_collider()
		print("Hit object:", hit_collider.name)


func _set_exceptions(raycast: RayCast3D) -> void:
	for exception in exceptions:
		raycast.add_exception(exception)

func _set_collision_mask_layers(raycast: RayCast3D) -> void:
	raycast.collision_mask = 0
	for collision_mask_layer in detectable_collision_masks:
		raycast.set_collision_mask_value(collision_mask_layer, true)

func _detect_collisions() -> void:
	for raycast in raycasts_to_closest_body:
		if raycast.is_colliding():
			var body: Object = raycast.get_collider()
			body_to_colliding_point[body] = raycast.get_collision_point()
			raycasts_to_closest_body[raycast] = body
		else:
			var previous_colliding_body: Object = raycasts_to_closest_body[raycast]
			body_to_colliding_point.erase(previous_colliding_body)
			raycasts_to_closest_body[raycast] = null