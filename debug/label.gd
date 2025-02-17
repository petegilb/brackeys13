extends Label

### Exported variables ###
@export var is_debug := false

### Public variables ###
var root_node: Node3D
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root_node = get_parent().get_parent()
	player = root_node.get_child(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (is_debug):
		var target_rotation = player.mouse.target_rotation
		var player_origin_2d = get_viewport().get_camera_3d().unproject_position(player.position)
		text = ("player_origin_2d: %s, Rotation to mouse: %s" % [player_origin_2d, target_rotation])
