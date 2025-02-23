extends Node

@export var target_area: Area3D
@export var win_screen: Control
@export var pause_screen: Control

signal game_over(result)

func _ready():
	if target_area:
		target_area.body_entered.connect(_on_target_reached)
    
	Global.pause_game.connect(_on_pause)

func _on_target_reached(body: Node3D):
	print(body)
	game_over.emit(true)
	win_screen.visible = true
	Global.game_paused = true

func _on_pause(_paused):
	if win_screen.visible == true:
		return
	pause_screen.visible = _paused
