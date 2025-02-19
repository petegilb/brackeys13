extends Node3D

@export var anim_tree : AnimationTree
@export var active_camera: Camera3D
@export var collider: CollisionShape3D

@onready var parent_character_body: CharacterBody3D = self.get_parent()

var in_air = false

func _physics_process(_delta: float) -> void:
    var velocity = parent_character_body.velocity
    in_air = !parent_character_body.is_on_floor()
    var local_velocity = collider.global_transform.basis.inverse() * velocity.normalized()

    # BlendSpace2D expects (x=left/right, y=forward/back)
    var blend_x = local_velocity.x  # Left/Right
    var blend_y = -local_velocity.z  # Forward/Backward (Godot uses -Z as forward)
    
    anim_tree.set("parameters/PlayerLocomotion/WalkIdle/blend_position", Vector2(blend_x, blend_y))
    # anim_tree.set("parameters/PlayerLocomotion/conditions/in_air", in_air)
