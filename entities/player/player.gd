class_name Player
extends CharacterBody3D

### Public Variables ###
var direction := Vector3.ZERO

### Onready Variables ###
@onready var movement = $MovementComponent

### Built in virtual functions ###

func _physics_process(_delta: float) -> void:
	# Obtain input
	handle_input()

	# Execute the movement
	movement.move(direction)

### Public functions ###

func handle_input() -> void: 
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		movement.execute_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()