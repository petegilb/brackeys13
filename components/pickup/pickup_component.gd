class_name PickupComponent
extends Area2D
## A component intended to add the ability for this item to be picked up

### Signals ###
signal can_pickup()

### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###
var parent: Node = self.get_parent()

### Private variables ###

### Onready variables ###

### Built in virtual methods ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

### Public methods ###



### Private methods ###

func _on_mouse_entered():
	print("mouse entered object area")

func _on_mouse_exited():
	print("mouse exited object area")
