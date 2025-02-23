extends Node

@onready var parent_obj = self.get_parent()

@export var hover_speed: float = 2.0  # Speed of hover (rise and fall)
@export var hover_height: float = 0.5  # Max height of the hover
@export var rotation_speed: float = 45.0  # Speed of rotation in degrees per second
@export var is_active = true

var initial_position: Vector3 = Vector3()
var time: float = 0.0

func _ready():
	if is_active:
		activate()

func _physics_process(delta):
	time += delta

	if !is_active:
		return

	var hover_offset = sin(hover_speed * time) * hover_height
	parent_obj.global_transform.origin.y = initial_position.y + hover_offset
	parent_obj.rotate_y(deg_to_rad(rotation_speed * delta))

func activate():
	is_active = true
	initial_position = parent_obj.global_transform.origin
	