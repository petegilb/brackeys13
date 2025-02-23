extends Node

@export var target_area: Area3D
@export var win_screen: Control

signal game_over(result)

func _ready():
	if target_area:
		target_area.body_entered.connect(_on_target_reached)

func _on_target_reached(body: Node3D):
	print(body)
	game_over.emit(true)
	win_screen.visible = true
	Global.game_paused = true
