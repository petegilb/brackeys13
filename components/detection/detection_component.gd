class_name DetectionComponent
extends Node3D
## A component intended add an Area3D to allow for detection.
##
## NOTE: This does not obtain exact points of collision. We only know the origin of the object that intersected with the area.

### Signals ###

### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###
var bodies_in_range: Dictionary = {}
var num_bodies_in_range := 0

### Private variables ###

### Onready variables ###

### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node3D):
	bodies_in_range[body] = true
	num_bodies_in_range += 1

	print(body)

	# if body.get_parent() and body.is_in_group('body'):


func _on_body_exited(body: Node3D):
	bodies_in_range.erase(body)
	num_bodies_in_range -= 1

### Public methods ###

### Private methods ###