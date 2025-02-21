class_name Plate
extends Node3D
## The plate component meant to hold the object on top.

### Signals ###

### Enums ###

### Constants ###
const ON_TOP_OF_PLATE_POS := Vector3(0,.024,0)

### Exported variables ###
@export var max_distance: float = 2  # Adjust the threshold

### Public variables ###
var detection_area: DetectionComponent
var pin_joint: JoltGeneric6DOFJoint3D
var gravity_area: Area3D
var object_on_plate: Node3D = null

### Private variables ###


### Onready variables ###
@onready var rigid_body = $RigidBody3D

### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detection_area = $RigidBody3D/DetectionComponent
	pin_joint = $RigidBody3D/JoltGeneric6DOFJoint3D
	gravity_area = $RigidBody3D/Gravity

	_toggle_gravity(true)

	# Spawn sandwich and attach
	var sandwich = preload("res://entities/sandwich/sandwich.tscn")
	var sandwich_object = sandwich.instantiate()
	sandwich_object.global_position = self.global_position
	get_tree().current_scene.add_child(sandwich_object)
	_attach_sandwich(sandwich_object)

	# Object approaching
	detection_area.body_entered.connect(_on_object_entered_plate)

	# Object exiting
	detection_area.body_exited.connect(_on_object_exited_plate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if object_on_plate and global_transform.origin.distance_to(object_on_plate.global_transform.origin) > max_distance:
		_detach_sandwich()

### Public methods ###



### Private methods ###

## TODO: Make it so other objects aren't attracted if the plate already has an object on it
func _on_object_exited_plate(body: Node3D):
	if body == object_on_plate:
		_detach_sandwich()

## Make the object be on top of the plate if there is not an object on it already
func _on_object_entered_plate(body: Node3D): 
	if (object_on_plate == null):
		_attach_sandwich(body)
		print("Sandwich has docked on the plate :D")

func _attach_sandwich(body: Node3D):
	print("Attach sandwich")
	object_on_plate = body
	pin_joint.enabled = true
	pin_joint.node_b = object_on_plate.get_path()

func _detach_sandwich():
	print("detach sandwich")
	object_on_plate = null
	pin_joint.enabled = false  # Remove the joint

func _toggle_gravity(is_enabled: bool) -> void:
	if (is_enabled):
		gravity_area.gravity_space_override = Area3D.SPACE_OVERRIDE_COMBINE
		gravity_area.gravity_point = true
		gravity_area.gravity = 500
	else:
		gravity_area.gravity_space_override = Area3D.SPACE_OVERRIDE_DISABLED
