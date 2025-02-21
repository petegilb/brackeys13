class_name Plate
extends Node3D
## The plate component meant to hold the object on top.

### Signals ###

### Enums ###

### Constants ###
const ON_TOP_OF_PLATE_POS := Vector3(0,.024,0)

### Exported variables ###


### Public variables ###
var outer_gravity: Area3D
var inner_gravity: Area3D
var object_on_plate: Node3D = null

### Private variables ###


### Onready variables ###


### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outer_gravity = $RigidBody3D/OuterGravity
	inner_gravity = $RigidBody3D/InnerGravity

	# Object approaching
	inner_gravity.body_entered.connect(_on_object_entered_plate)

	# Object exiting
	inner_gravity.body_entered.connect(_on_object_exiting_plate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (object_on_plate != null):
		object_on_plate.position = ON_TOP_OF_PLATE_POS
		object_on_plate.global_rotation = Vector3.ZERO

### Public methods ###



### Private methods ###

## TODO: Make it so other objects aren't attracted if the plate already has an object on it
func _on_object_exiting_plate(body: Node3D):
	if body == object_on_plate:
		object_on_plate = null

## Make the object be on top of the plate if there is not an object on it already
func _on_object_entered_plate(body: Node3D): 
	if (object_on_plate == null):
		object_on_plate = body