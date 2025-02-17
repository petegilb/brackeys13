extends Control

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
	queue_redraw()

func _draw() -> void:
	if (is_debug):
		var player_origin_2d = get_viewport().get_camera_3d().unproject_position(player.position)
		var mouse_pos = player.mouse.mouse_pos_2d
		draw_circle(player_origin_2d, 10, Color.BLUE)
		draw_circle(mouse_pos, 10, Color.WHITE)
		draw_line(player_origin_2d, mouse_pos, Color.BLACK)
