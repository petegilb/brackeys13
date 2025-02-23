extends Node

signal pause_game(paused)

@onready var your_mom = false
@onready var main = get_tree().get_root().get_node('Main')

var game_paused = false

func quit_game() -> void:
    get_tree().quit()

### Collision Mask Layers ###
const PLAYER_LAYER := 1
const FLOOR_LAYER := 2
const OBSTACLE_LAYER := 3
const ENTITY_LAYER := 4
const SANDWICH_LAYER := 5

func _pause_game(paused) -> void:
    pause_game.emit(paused)
    game_paused = paused
