class_name Player
extends CharacterBody3D

### Signals ###

### Public Variables ###
var speed_change_rate := 1

### Onready Variables ###
@onready var movement = $MovementComponent
@onready var nervous = $NervousComponent
@onready var mouse = $MouseDirectionComponent
@onready var body = $Collider/test_character
@onready var collider = $Collider

### Built in virtual functions ###

func _physics_process(delta: float) -> void:
	# Obtain input
	handle_input()

	# Execute the movement
	movement.move(delta)

### Public functions ###

func handle_input() -> void: 
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		movement.execute_jump()

	if Input.is_action_just_pressed("scroll_up"):
		movement.set_speed(movement.current_speed + speed_change_rate)

	if Input.is_action_just_pressed("scroll_down"):
		movement.set_speed(movement.current_speed - speed_change_rate)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	movement.movement_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
