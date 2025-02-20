extends Node

@onready var your_mom = false
@onready var main = get_tree().get_root().get_node('Main')

func quit_game() -> void:
    get_tree().quit()

### Collision Mask Layers ###
const PLAYER_LAYER := 1
const FLOOR_LAYER := 2
const OBSTACLE_LAYER := 3
const ENTITY_LAYER := 4
const SANDWICH_LAYER := 5
