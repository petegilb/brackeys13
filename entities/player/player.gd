class_name Player
extends CharacterBody3D

### Public Variables ###
var movement_direction := Vector3.ZERO
var look_rotation := Vector2.ZERO
var look_speed := 0.2

### Onready Variables ###
@onready var movement = $MovementComponent
@onready var mouse = $MouseDirectionComponent
@onready var body = $Mesh
@onready var collider = $Collider

### Built in virtual functions ###

func _physics_process(_delta: float) -> void:
	# Obtain input
	handle_input()

	# Execute the movement
	movement.move(movement_direction)

### Public functions ###

func handle_input() -> void: 
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		movement.execute_jump()

	if Input.is_action_just_pressed("test_action"):
		mouse.look_at_mouse()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	movement_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
