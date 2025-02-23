class_name Sandwich
extends Node3D

@onready var rigid_body = $RigidBody3D
@onready var hover_component = $HoverComponent
@onready var label: Label3D = $PickLabel

var is_picked_up = false
var was_picked_up = false

func _ready() -> void:
	label.visible = true
	hover_component.is_active = true

func _process(_delta):
	if is_picked_up != was_picked_up:
		if is_picked_up:
			label.visible = false
			hover_component.is_active = false
		else:
			global_rotation = Vector3(0, 0, 0)
			hover_component.activate()
		
		was_picked_up = is_picked_up
