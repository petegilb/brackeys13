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

### Public variables ###
var nervousness := 0.0
var nervousness_loss_rate := 10

var distance_away_from_node: float

### Private variables ###
var _is_debug_mode := false
var _debug_timer: SceneTreeTimer

### Onready variables ###
@onready var parent_character_body: CharacterBody3D = self.get_parent()

### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (_is_debug_mode):
		_setup_scene_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not nervousness_raycast_area.body_to_colliding_point.is_empty()):
		var nervousness_gain_rate = clampf(_calculate_nervousness_for_all_detected_nodes() * delta, MIN_NERVOUSNESS_GAIN, MAX_NERVOUSNESS_GAIN)
		nervousness = clampf(nervousness + nervousness_gain_rate * delta, MIN_NERVOUSNESS, MAX_NERVOUSNESS)
	else:
		nervousness = clampf(nervousness - nervousness_loss_rate * delta, MIN_NERVOUSNESS, MAX_NERVOUSNESS)

### Public methods ###



### Private methods ###

## Obtains the distance ta all the detected nodes and calculates the nervousness based on the inverse of the distance
func _calculate_nervousness_for_all_detected_nodes() -> float:
	var nervousness_sum := 0.0
	for object in nervousness_raycast_area.body_to_colliding_point:
		var colliding_point: Vector3 = nervousness_raycast_area.body_to_colliding_point[object]
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
	for body in nervousness_raycast_area.body_to_colliding_point:
		var colliding_point = nervousness_raycast_area.body_to_colliding_point[body]
		var distance = abs((colliding_point - parent_character_body.position).length())
		print("Body: %s, Distance away from node: %s" % [body,distance])

	_setup_scene_timer()
