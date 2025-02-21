extends Node3D

const RAY_LENGTH = 2000
var _debug_timer: SceneTreeTimer

var result
var movable_object: RigidBody3D = null

@onready var plate = $Plate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# plate.rigid_body.linear_velocity.y = 0.5

	var camera = get_viewport().get_camera_3d()
	var space_state = get_world_3d().direct_space_state

	# camera.position = plate.rigid_body.position + Vector3(0,.45,.45)

	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	result = space_state.intersect_ray(query)

	if Input.is_action_just_released("pickup"):
		movable_object = null

	if not result.is_empty():
		_setup_scene_timer()
		if (result.collider != null):
			var body = result.collider
			var parent = body.get_parent()
			if (parent is Plate):
				if (Input.is_action_just_pressed("pickup")):
					movable_object = body

	if (movable_object != null):
		movable_object.linear_velocity.y = 0.5

	camera.position = plate.rigid_body.position + Vector3(0,.45,.45)

func _setup_scene_timer() -> void:
	if _debug_timer == null:
		_debug_timer = get_tree().create_timer(2.5)
		_debug_timer.timeout.connect(_debug)

func _debug() -> void:
	print(result)
	_debug_timer = null
