extends Node

@onready var your_mom = false
@onready var main = get_tree().get_root().get_node('Main')

func quit_game() -> void:
    get_tree().quit()
