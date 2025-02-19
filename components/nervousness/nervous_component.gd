class_name NervousComponent
extends Node3D
## A component intended add a variable "nervousness" to be tracked and modify the parent node depending on the nervousness.
##
## This component adds an editable "nervousness".

### Signals ###

### Enums ###

### Constants ###
const MIN_NERVOUSNESS := 0.0
const MAX_NERVOUSNESS := 100.0

const MIN_NERVOUSNESS_GAIN := 0.1
const MAX_NERVOUSNESS_GAIN := 90.0

### Exported variables ###
@export var movement_component: MovementComponent
@export var nervousness_raycast_area: SphericalRaycastDetectionComponent
@export var nervousness_loss_rate := 15
@export var nervous_force := 0.025
@export var noise_seed := randi()
@export var noise_frequency := 0.1
@export var noise_type := FastNoiseLite.TYPE_PERLIN

### Public variables ###
var nervousness := 0.0
var noise: Noise

var distance_away_from_node: float

### Private variables ###
var _is_debug_mode := true
var _debug_timer: SceneTreeTimer
var _vary_direction := Vector3.ZERO
var _random_speed := 0.0

### Onready variables ###
@onready var parent_character_body: CharacterBody3D = self.get_parent()

### Built in virtual methods ###

func _init() -> void:
	noise = FastNoiseLite.new()
	noise.seed = noise_seed
	noise.noise_type = noise_type
	noise.frequency = noise_frequency

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (_is_debug_mode):
		_setup_scene_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var body_to_colliding_point = nervousness_raycast_area.get_unique_colliding_bodies()
	if (not body_to_colliding_point.is_empty()):
		var nervousness_gain_rate = clampf(_calculate_nervousness_for_all_detected_nodes() * delta, MIN_NERVOUSNESS_GAIN, MAX_NERVOUSNESS_GAIN)
		nervousness = clampf(nervousness + nervousness_gain_rate * delta, MIN_NERVOUSNESS, MAX_NERVOUSNESS)
	else:
		nervousness = clampf(nervousness - nervousness_loss_rate * delta, MIN_NERVOUSNESS, MAX_NERVOUSNESS)

	_vary_movement()

### Public methods ###



### Private methods ###

func _vary_movement() -> void:
	var time = Time.get_ticks_msec()
	var _random_x = noise.get_noise_3dv(Vector3(time,time,time))
	var _random_z = noise.get_noise_3dv(Vector3(-time,-time,-time))
	_vary_direction = Vector3(_random_x, 0, _random_z).normalized()
	movement_component.apply_force(_vary_direction * nervous_force * nervousness)

	_random_speed = randf_range(-1.0, 1.0)
	movement_component.set_speed(movement_component.current_speed + (_random_speed * nervous_force * nervousness))

## Obtains the distance ta all the detected nodes and calculates the nervousness based on the inverse of the distance
func _calculate_nervousness_for_all_detected_nodes() -> float:
	var nervousness_sum := 0.0
	var body_to_colliding_point = nervousness_raycast_area.get_unique_colliding_bodies()
	for object in body_to_colliding_point:
		var colliding_point: Vector3 = body_to_colliding_point[object]
		nervousness_sum += _calculate_nervousness_for_node(colliding_point)
	return nervousness_sum

## Pass in nodes from the bodies in range and calculate how nervous the player should be based on the nodes in range
## Nervousness is calculated inversely from the distance away from the object. AKA: Further away object = less nervous and close object = more nervous
## The parent node gets exponentially nervous the closer the object is to it.
func _calculate_nervousness_for_node(pos: Vector3) -> float:
	distance_away_from_node = abs((pos - parent_character_body.position).length())
	var result: float
	if (distance_away_from_node == 0):
		result = 100
	else:
		result = pow(15 / distance_away_from_node, 4)

	return result

# Debugging purposes only
func _setup_scene_timer() -> void:
	_debug_timer = get_tree().create_timer(1.0)
	_debug_timer.timeout.connect(_debug)

func _debug() -> void:
	var body_to_colliding_point = nervousness_raycast_area.get_unique_colliding_bodies()
	for body in body_to_colliding_point:
		var colliding_point = body_to_colliding_point[body]
		var distance = abs((colliding_point - parent_character_body.position).length())
		print("Body: %s, Distance away from node: %s" % [body,distance])

	_setup_scene_timer()
