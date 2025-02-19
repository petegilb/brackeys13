extends Node3D

@export var anim_tree : AnimationTree
@export var active_camera: Camera3D
@export var collider: CollisionShape3D

@onready var parent_character_body: Player = self.get_parent()

var in_air = false
var jitter_amount = 0.1

func _process(_delta: float) -> void:
    # Rotate spine bone based on nervousness
    var skeleton: Skeleton3D = parent_character_body.body.get_node("root/Skeleton3D")
    var spine_idx = skeleton.find_bone('Spine')

    var nervousness = parent_character_body.nervous.nervousness * parent_character_body.nervous.nervous_force
    var jitter = randf_range(-jitter_amount * nervousness, jitter_amount * nervousness)
    
    if spine_idx != -1:
        var bone_transform: Transform3D = skeleton.get_bone_pose(spine_idx)
        bone_transform.basis = bone_transform.basis.rotated(Vector3(0, 1, 0), jitter)
        skeleton.set_bone_pose(spine_idx, bone_transform)
    
func _physics_process(_delta: float) -> void:
    var velocity = parent_character_body.velocity
    in_air = !parent_character_body.is_on_floor()

    var blend_x = 0
    var blend_y = 0

    if self.parent_character_body.movement and self.parent_character_body.movement.movement_direction:
        var local_velocity = collider.global_transform.basis.inverse() * velocity.normalized()

        # BlendSpace2D expects (x=left/right, y=forward/back)
        blend_x = local_velocity.x  # Left/Right
        blend_y = -local_velocity.z  # Forward/Backward (Godot uses -Z as forward)        
        
    anim_tree.set("parameters/PlayerLocomotion/WalkIdle/blend_position", Vector2(blend_x, blend_y))
    # anim_tree.set("parameters/PlayerLocomotion/conditions/in_air", in_air)
