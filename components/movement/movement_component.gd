class_name MovementComponent
extends Node3D
## A component intended to add speed and movement capabilities to the object it is attached to.
##
## This component adds an editable speed variable as well as a max and min speed for the attached object.
## Additionally it executes the movement for the parent node all in this component.

### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
@export var min_speed := 1.0
@export var current_speed := 1.0
@export var max_speed := 1.0
@export var jump_velocity := 1.0
@export var additional_gravity_force := Vector3(0, 0, 0)

### Public variables ###
var movement_direction := Vector3.ZERO
var external_force := Vector3.ZERO
var external_force_decay := 20000.0

### Private variables ###

### Onready variables ###
@onready var parent_character_body: CharacterBody3D = self.get_parent()

### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_gravity(delta)

### Public methods ###

func apply_force(direction_force: Vector3) -> void:
	external_force = direction_force

func move(delta: float) -> void: 
	if movement_direction:
		parent_character_body.velocity.x = movement_direction.x * current_speed
		parent_character_body.velocity.z = movement_direction.z * current_speed
	else:
		parent_character_body.velocity.x = move_toward(parent_character_body.velocity.x, 0, current_speed)
		parent_character_body.velocity.z = move_toward(parent_character_body.velocity.z, 0, current_speed)

	# Apply external force
	if external_force.length() > 0.1:
		parent_character_body.velocity += external_force
		external_force = external_force.move_toward(Vector3.ZERO, external_force_decay * delta)

	parent_character_body.move_and_slide()

func execute_jump() -> void:
	if parent_character_body.is_on_floor():
		parent_character_body.velocity.y = jump_velocity

func set_speed(new_speed: float) -> void: 
	current_speed = clampf(new_speed, min_speed, max_speed)

### Private methods ###

func _handle_gravity(delta: float) -> void:
	# Add the gravity.
	if not parent_character_body.is_on_floor():
		parent_character_body.velocity += (parent_character_body.get_gravity() + additional_gravity_force) * delta